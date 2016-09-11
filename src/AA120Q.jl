module AA120Q

using Reexport
using Cairo
@reexport using DataFrames
@reexport using Distributions
@reexport using Discretizers
@reexport using Plots
plotlyjs()

# define_color("monokai_dark",   0x272822)
# define_color("monokai_blue",   0x52E3F6)
# define_color("monokai_green",  0xA7EC21)
# define_color("monokai_red",    0xFF007F)
# define_color("monokai_orange", 0xF9971F)
# define_color("monokai_cobalt", 0x79ABFF)

export
    Advisory,
    AircraftAction,
    AircraftState,
    SensorReading,
    Encounter,
    EncounterModel,
    EncounterSimParams,
    CollisionAvoidanceSystem,
    FullyObservableCollisionAvoidanceSystem,
    PartiallyObservableCollisionAvoidanceSystem,
    TCAS,

    DEFAULT_SIM_PARAMS,
    CLIMB_RATE_MAX,
    CLIMB_RATE_MIN,
    ADVISORY_NONE,

    ADVISORY_MAGNITUDE_PENALTY,
    ADVISORY_REVERSAL_PENALTY,
    NMAC_PENALTY,

    start_state,
    update_state,
    interpolate_state,
    get_interpolated_state,
    is_nmac,
    has_nmac,
    get_miss_distance,
    plot_encounter,
    pull_encounters,

    sample_initial,
    sample_transition,

    is_no_advisory,
    reset!,
    update!,

    generate_encounters!,
    generate_encounters,
    get_miss_distance_counts,
    plot_miss_distance_histogram,
    evaluate,

    render,
    render!,
    get_canvas_and_context,
    center_on_aircraft!

immutable AircraftAction
    Δv::Float64 # acceleration [ft/s²]
    Δh::Float64 # climb rate [ft/s]
    Δψ::Float64 # turnrate [deg/s]
end

immutable AircraftState
    n::Float64  # northing   [ft]
    e::Float64  # easting    [ft]
    h::Float64  # altitude   [ft]
    ψ::Float64  # heading    [deg] (angle CCW from north)
    v::Float64  # speed      [ft/s] (total speed in 3D)
    hd::Float64 # climb rate [ft/s] (vertical speed component)
end

start_state(v::Float64) = AircraftState(0.0,0.0,0.0,0.0,v,0.0)
function interpolate_state(a::AircraftState, b::AircraftState, z::Float64)
    AircraftState(
            a.n + (b.n - a.n)*z,
            a.e + (b.e - a.e)*z,
            a.h + (b.h - a.h)*z,
            a.ψ + atan2(sin(b.ψ-a.ψ), cos(b.ψ-a.ψ))*z,
            a.v + (b.v - a.v)*z,
            a.hd + (b.hd - a.hd)*z,
        )
end
function update_state(s::AircraftState, a::AircraftAction, Δt::Float64;
    theta_regulated::Float64 = 45.0, # [deg]
    )

    x, y, h, ψ, v = s.n, -s.e, s.h, s.ψ, s.v
    Δv, Δh, Δψ  = a.Δv, a.Δh, a.Δψ

    if abs(Δh) > abs(v) * sind(theta_regulated)
        Δh = sign(Δh) * abs(v) * sind(theta_regulated)
    end

    x₂ = x + sqrt(v^2 - Δh^2) * cosd(ψ) * Δt
    y₂ = y + sqrt(v^2 - Δh^2) * sind(ψ) * Δt

    v₂ = v + Δv * Δt  # ft/s
    h₂ = h + Δh * Δt  # ft
    ψ₂ = ψ + Δψ * Δt  # deg
    hd₂ = Δh

    AircraftState(x₂, -y₂, h₂, ψ₂, v₂, hd₂)
end

function get_interpolated_state(trace::Vector{AircraftState}, Δt::Float64, t::Float64)
    # t = 0.0 will give you the first state
    # t = Δt/2 will give you the state halfway between state 1 and state 2, etc.

    i_lo = clamp(floor(Int, t/Δt) + 1, 1, length(trace))
    i_hi = min(i_lo + 1, length(trace))
    z = (t - (i_lo-1)*Δt) / Δt

    interpolate_state(trace[i_lo], trace[i_hi], z)
end

####################################################

"""
    The Advisory provides the pilot with information on the vertical speed or pitch
    angle to fly or avoid to resolve an encounter.

    The climb rate must be between ±4400 feet per minute
    Setting the climb rate to NaN is equivalent to having no Advisory

    The simulated pilot will begin following the advisory exactly at t ∼ U(0, pilot_delay)
"""
immutable Advisory
    climb_rate::Float64 # ft/s
end
const CLIMB_RATE_MAX =  4400/60 # ft/s
const CLIMB_RATE_MIN = -4400/60 # ft/s
const ADVISORY_NONE = Advisory(NaN)
is_no_advisory(a::Advisory) = isnan(a.climb_rate)

##################################

const RANGE_STDEV = 50 # [ft²]
const BEARING_STDEV = 5 # [deg]
const RELATIVE_ALTITUDE_DISC = LinearDiscretizer([-Inf, -1000, -500, -250, -100, 0, 100, 250, 500, 1000, Inf])

immutable SensorReading
    r::Float64 # range [ft], horizontal distance AC1 → AC2
    b::Float64 # bearing [deg], positive to AC1's left
    a::Int # discretized relative altitude [-]. See RELATIVE_ALTITUDE_DISC for bins
end
function SensorReading(s1::AircraftState, s2::AircraftState)

    x1, y1, h1, vx1, vy1, h1_dot = s1.e, s1.n, s1.h, s1.v*cosd(90 + s1.ψ), s1.v*sind(90 + s1.ψ), s1.hd
    x2, y2, h2, vx2, vy2, h2_dot = s2.e, s2.n, s2.h, s2.v*cosd(90 + s2.ψ), s2.v*sind(90 + s2.ψ), s2.hd

    r = hypot(x2 - x1, y2 - y1) # range [ft]
    b = rad2deg(atan2(y2 - y1, x2 - x1) - s1.ψ) # bearing [deg]
    a_cont = abs(h1 - h2) # relative altitude [ft]

    # add sensor noise
    r += randn()*RANGE_STDEV
    b = mod(b + randn()*BEARING_STDEV, 360) # ensure is in range [0,360)
    a = encode(RELATIVE_ALTITUDE_DISC, a_cont)

    SensorReading(r, b, a)
end

##################################

type Encounter
    A::Int  # aircraft type
    C1::Int # category of aircraft 1
    C2::Int # category of aircraft 2
    Δt::Float64 # constant timestep between frames [sec]
    trace1::Vector{AircraftState}
    trace2::Vector{AircraftState}
    advisories::Vector{Advisory}

    function Encounter(
        A::Int,
        C1::Int,
        C2::Int,
        Δt::Float64,
        trace1::Vector{AircraftState},
        trace2::Vector{AircraftState},
        advisories::Vector{Advisory}=fill(ADVISORY_NONE, max(length(trace1)-1, 0))
        )

        retval = new()
        retval.A = A
        retval.C1 = C1
        retval.C2 = C2
        retval.Δt = Δt
        retval.trace1 = trace1
        retval.trace2 = trace2
        retval.advisories = advisories
        retval
    end
end

function get_miss_distance(enc::Encounter)
    trace1, trace2 = enc.trace1, enc.trace2
    d, i = findmin([norm([trace1[i].e - trace2[i].e, trace1[i].n - trace2[i].n, trace1[i].h - trace2[i].h]) for i in 1 : length(trace1)])
    d # [ft]
end

const NMAC_THRESOLD_VERT = 100.0 # [ft]
const NMAC_THRESOLD_HORZ = 500.0 # [ft]
function is_nmac(s1::AircraftState, s2::AircraftState)
    Δvert = abs(s1.h - s2.h)
    Δhorz = norm([s1.e - s2.e, s1.n - s2.n])
    Δvert ≤ NMAC_THRESOLD_VERT && Δhorz ≤ NMAC_THRESOLD_HORZ
end
function has_nmac(enc::Encounter)
    trace1, trace2 = enc.trace1, enc.trace2
    for i in 1 : length(trace1)
        if is_nmac(trace1[i], trace2[i])
            return true
        end
    end
    false
end

function plot_encounter(enc::Encounter)

    trace1, trace2 = enc.trace1, enc.trace2

    # grab the index at which they are closest, and the dist
    d, i = findmin([norm([trace1[i].e - trace2[i].e, trace1[i].n - trace2[i].n, trace1[i].h - trace2[i].h]) for i in 1 : length(trace1)])

    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = (collect(1:length(trace1)).-1) .* enc.Δt

    e1_arr = map(s->s.e,trace1)
    n1_arr = map(s->s.n,trace1)
    e2_arr = map(s->s.e,trace2)
    n2_arr = map(s->s.n,trace2)

    min_e1, max_e1 = extrema(e1_arr)
    min_n1, max_n1 = extrema(n1_arr)
    min_e2, max_e2 = extrema(e2_arr)
    min_n2, max_n2 = extrema(n2_arr)

    max_e = max(max_e1, max_e2)
    max_n = max(max_n1, max_n2)
    min_e = min(min_e1, min_e2)
    min_n = min(min_n1, min_n2)

    w = max(abs(max_e), abs(min_e), abs(max_n), abs(min_n)) + 500

    p1 = plot(Vector{Float64}[e1_arr, e2_arr, [trace1[i].e, trace2[i].e]],
              Vector{Float64}[n1_arr, n2_arr, [trace1[i].n, trace2[i].n]],
              xlabel="East (ft)", ylabel="North (ft)", palette=palette, linewidth=4, xlims=(-w,w), ylims=(-w,w))
    scatter!(p1, Vector{Float64}[Float64[trace1[1].e], Float64[trace2[1].e]],
                 Vector{Float64}[Float64[trace1[1].n], Float64[trace2[1].n]])


    p2 = plot(Vector{Float64}[t_arr, t_arr, [(i-1)*enc.Δt,(i-1)*enc.Δt]],
              Vector{Float64}[map(s->s.h,trace1), map(s->s.h,trace2), [trace1[i].h, trace2[i].h]],
              xlabel="Time (s)", ylabel="Altitude (ft)", leg=false, palette=palette, linewidth=4,
              annotations=(i,(trace1[i].h+trace2[i].h)/2, Plots.text(@sprintf("mid dist: %.0f ft", d))))

    # indicate when advisories were issued
    advisory_t_vals = Float64[]
    advisory_h_vals = Float64[]

    prev_climb_rate = NaN

    let
        t = 0.0
        for (i,advisory) in enumerate(enc.advisories)
            if !is_no_advisory(advisory) && !isapprox(advisory.climb_rate, prev_climb_rate)
                prev_climb_rate = advisory.climb_rate
                push!(advisory_t_vals, t)
                push!(advisory_h_vals, enc.trace1[i].h)
            end
            t += enc.Δt
        end
    end

    scatter!(p2, advisory_t_vals, advisory_h_vals)


    plot(p1, p2, size=(950,400))
end

function pull_encounters(initial::DataFrame, traces::DataFrame, N::Int=nrow(initial))

    N = clamp(N, 0, nrow(initial))
    arr = Array(Encounter, N)
    j = 1
    traceids = traces[:id]
    for id in 1 : N
        j = findnext(traceids, id, j)
        j_end = findlast(traceids, id)
        Δt = convert(Float64, traces[j+1, :t] - traces[j, :t])

        m = j_end - j + 1
        trace1 = Array(AircraftState, m)
        trace2 = Array(AircraftState, m)

        for k in 1 : m
            j2 = j + k - 1

            if k < m
                hd1, hd2 = (traces[j2+1, :h1] - traces[j2, :h1]) / Δt,
                           (traces[j2+1, :h2] - traces[j2, :h2]) / Δt
            else
                hd1, hd2 = (traces[j2, :h1] - traces[j2-1, :h1]) / Δt,
                           (traces[j2, :h2] - traces[j2-1, :h2]) / Δt
            end

            trace1[k] = AircraftState(traces[j2, :n1], traces[j2, :e1], traces[j2, :h1], traces[j2, :ψ1], traces[j2, :v1], hd1)
            trace2[k] = AircraftState(traces[j2, :n2], traces[j2, :e2], traces[j2, :h2], traces[j2, :ψ2], traces[j2, :v2], hd2)
        end

        arr[id] = Encounter(initial[id, :A], initial[id, :C1], initial[id, :C2], Δt, trace1, trace2)
    end
    arr
end

type EncounterSimParams
    nsteps::Int # number of steps to simulate for
    Δt::Float64 # timestep of each update [s]
end
const DEFAULT_SIM_PARAMS = EncounterSimParams(50, 1.0)

abstract EncounterModel
sample_initial(model::EncounterModel) = error("sample_initial not implemented for EncounterModel $model") # should return A, C1, C2, s1 and s2 at t=0 sampled from the model
sample_transition(s1::AircraftState, s2::AircraftState, model::EncounterModel, params::EncounterSimParams) = error("step not implemented for EncounterModel $model") # returns (s1, s2) at t+1

function Base.rand(model::EncounterModel, params::EncounterSimParams)
    A, C1, C2, s1, s2 = sample_initial(model) # get initial setup

    # simulate to get the traces
    trace1 = Array(AircraftState, params.nsteps+1)
    trace2 = Array(AircraftState, params.nsteps+1)
    trace1[1] = s1
    trace2[1] = s2
    for i in 1 : params.nsteps
        a1, a2 = sample_transition(trace1[i], trace2[i], model, params)
        trace1[i+1] = update_state(trace1[i], a1, params.Δt)
        trace2[i+1] = update_state(trace2[i], a2, params.Δt)
    end

    # return the encounter
    Encounter(A, C1, C2, params.Δt, trace1, trace2)
end

abstract CollisionAvoidanceSystem
abstract FullyObservableCollisionAvoidanceSystem <: CollisionAvoidanceSystem
abstract PartiallyObservableCollisionAvoidanceSystem <: CollisionAvoidanceSystem

reset!(cas::CollisionAvoidanceSystem) = cas # do nothing by default
update!(cas::FullyObservableCollisionAvoidanceSystem, s1::AircraftState, s2::AircraftState, params::EncounterSimParams) = error("update! not implemented for FullyObservableCollisionAvoidanceSystem $cas")
update!(cas::PartiallyObservableCollisionAvoidanceSystem, reading::SensorReading, params::EncounterSimParams) = error("update! not implemented for PartiallyObservableCollisionAvoidanceSystem $cas")
update!(cas::PartiallyObservableCollisionAvoidanceSystem, s1::AircraftState, s2::AircraftState, params::EncounterSimParams)  = update!(cas, SensorReading(s1, s2), params)
function Base.rand(
    model::EncounterModel, # human pilot model and initial scene generation
    cas::CollisionAvoidanceSystem, # advisory policy
    params::EncounterSimParams, # defines encounter parameters
    )

    A, C1, C2, s1, s2 = sample_initial(model) # get initial setup
    reset!(cas) # re-initialize the CAS

    # simulate to get the traces
    trace1 = Array(AircraftState, params.nsteps+1)
    trace2 = Array(AircraftState, params.nsteps+1)
    advisories = Array(Advisory, params.nsteps)
    trace1[1] = s1
    trace2[1] = s2
    for i in 1 : params.nsteps

        s1, s2 = trace1[i], trace2[i]
        a1, a2 = sample_transition(s1, s2, model, params)

        advisory = update!(cas, s1, s2, params)
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            a1 = AircraftAction(a1.Δv, advisory.climb_rate, a1.Δψ)
        end

        trace1[i+1] = update_state(s1, a1, params.Δt)
        trace2[i+1] = update_state(s2, a2, params.Δt)
        advisories[i] = advisory
    end

    # return the encounter
    Encounter(A, C1, C2, params.Δt, trace1, trace2, advisories)
end
function Base.rand(
    enc::Encounter, # human-generated encounter
    cas::CollisionAvoidanceSystem, # advisory policy
    )

    reset!(cas) # re-initialize the CAS

    params = EncounterSimParams(length(enc.trace1)-1, enc.Δt)

    # infer all actions
    actions1 = Array(AircraftAction, params.nsteps)
    actions2 = Array(AircraftAction, params.nsteps)
    for i in 1 : params.nsteps
        s11 = enc.trace1[i]
        s12 = enc.trace1[i+1]
        actions1[i] = AircraftAction((s12.v - s11.v)/params.Δt,
                                     (s12.h - s11.h)/params.Δt,
                                     rad2deg(atan2(sind(s12.ψ - s11.ψ), cosd(s12.ψ - s11.ψ)))/params.Δt)
        s21 = enc.trace2[i]
        s22 = enc.trace2[i+1]
        actions2[i] = AircraftAction((s22.v - s21.v)/params.Δt,
                                     (s22.h - s21.h)/params.Δt,
                                     rad2deg(atan2(sind(s22.ψ - s21.ψ), cosd(s22.ψ - s21.ψ)))/params.Δt)
    end


    # simulate to get the traces
    trace1 = Array(AircraftState, params.nsteps+1)
    trace2 = Array(AircraftState, params.nsteps+1)
    advisories = Array(Advisory, params.nsteps)
    trace1[1] = enc.trace1[1]
    trace2[1] = enc.trace2[1]

    for i in 1 : params.nsteps

        s1, s2 = trace1[i], trace2[i]
        a1, a2 = actions1[i], actions2[i]

        advisory = update!(cas, s1, s2, params)
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            a1 = AircraftAction(a1.Δv, advisory.climb_rate, a1.Δψ)
        end

        trace1[i+1] = update_state(s1, a1, params.Δt)
        trace2[i+1] = update_state(s2, a2, params.Δt)
        advisories[i] = advisory
    end

    # return the encounter
    Encounter(enc.A, enc.C1, enc.C2, params.Δt, trace1, trace2, advisories)
end

############################
const ADVISORY_PENALTY           =   10.0 # penalty for issuing an advisory
const ADVISORY_MAGNITUDE_PENALTY =    1.0 # penalty proportional to magnitude of climb rate
const ADVISORY_REVERSAL_PENALTY  =   50.0 # penalty for a reversal (changing sign of advisory)
const NMAC_PENALTY               =    1e5 # penalty for an NMAC

immutable CASEval
    n_encounters::Int
    n_advisories::Int
    n_NMACs::Int
    total_penalty::Float64
end
Base.show(io::IO, e::CASEval) = @printf(io, "CASEval(n_encounters: %d, n_advisories: %d, n_NMACs: %d, penalty: %.2f, normalized: %.2f)", e.n_encounters, e.n_advisories, e.n_NMACs, e.total_penalty, e.total_penalty/e.n_encounters)

function _evaluate(cas::CollisionAvoidanceSystem, enc::Encounter)
    reset!(cas) # re-initialize the CAS

    params = EncounterSimParams(length(enc.trace1)-1, enc.Δt)

    # infer all actions
    actions1 = Array(AircraftAction, params.nsteps)
    actions2 = Array(AircraftAction, params.nsteps)
    for i in 1 : params.nsteps
        s11 = enc.trace1[i]
        s12 = enc.trace1[i+1]
        actions1[i] = AircraftAction((s12.v - s11.v)/params.Δt,
                                     (s12.h - s11.h)/params.Δt,
                                     rad2deg(atan2(sind(s12.ψ - s11.ψ), cosd(s12.ψ - s11.ψ)))/params.Δt)
        s21 = enc.trace2[i]
        s22 = enc.trace2[i+1]
        actions2[i] = AircraftAction((s22.v - s21.v)/params.Δt,
                                     (s22.h - s21.h)/params.Δt,
                                     rad2deg(atan2(sind(s22.ψ - s21.ψ), cosd(s22.ψ - s21.ψ)))/params.Δt)
    end

    # simulate to get the traces
    s1 = enc.trace1[1]
    s2 = enc.trace2[1]
    n_advisories = 0
    prev_advisory = NaN
    total_penalty = 0.0

    for i in 1 : params.nsteps

        a1, a2 = actions1[i], actions2[i]

        advisory = update!(cas, s1, s2, params)
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            climb_rate = clamp(advisory.climb_rate, CLIMB_RATE_MIN, CLIMB_RATE_MAX)
            a1 = AircraftAction(a1.Δv, climb_rate, a1.Δψ)

            if !isapprox(climb_rate, prev_advisory)
                n_advisories += 1
                prev_advisory = climb_rate
                total_penalty += ADVISORY_MAGNITUDE_PENALTY * abs(climb_rate) + ADVISORY_PENALTY
                if !isnan(prev_advisory) # reversal
                    total_penalty += ADVISORY_REVERSAL_PENALTY
                end
            end
        end

        s1 = update_state(s1, a1, params.Δt)
        s2 = update_state(s2, a2, params.Δt)

        if is_nmac(s1, s2)
            return (true, n_advisories, total_penalty)
        end
    end

    (false, n_advisories, total_penalty)
end
function evaluate(cas::CollisionAvoidanceSystem, encounters::Vector{Encounter})
    n_advisories = 0
    n_NMACs = 0
    total_penalty = 0.0
    for enc in encounters
        had_NMAC, nadv, encounter_penalty = _evaluate(cas, enc)
        n_advisories += nadv
        n_NMACs += had_NMAC
        total_penalty += encounter_penalty + had_NMAC*NMAC_PENALTY
    end
    CASEval(length(encounters), n_advisories, n_NMACs, total_penalty)
end
function evaluate(cas::CollisionAvoidanceSystem, encounters::Vector{Encounter}, nsamples::Int)
    n_advisories = 0
    n_NMACs = 0
    total_penalty = 0.0
    sample_range = 1:length(encounters)

    for i in 1 : nsamples
        enc = encounters[rand(sample_range)]
        had_NMAC, nadv, encounter_penalty = _evaluate(cas, enc)
        n_advisories += nadv
        n_NMACs += had_NMAC
        total_penalty += encounter_penalty + had_NMAC*NMAC_PENALTY
    end
    CASEval(nsamples, n_advisories, n_NMACs, total_penalty)
end


############################
# SimpleTCAS

type TCAS <: FullyObservableCollisionAvoidanceSystem
    advisory::Advisory
    climb_rate::Float64
    TCAS(climb_rate::Float64=1500/60, advisory::Advisory=ADVISORY_NONE) = new(advisory, min(abs(climb_rate), CLIMB_RATE_MAX))
end

function reset!(tcas::TCAS)
    tcas.advisory = ADVISORY_NONE
    tcas
end
function update!(tcas::TCAS, s1::AircraftState, s2::AircraftState, params::EncounterSimParams)

    if is_no_advisory(tcas.advisory)
        # test for a threat

        # pull TCAS observations
        x1, y1, h1, vx1, vy1, h1_dot = s1.e, s1.n, s1.h, s1.v*cosd(90 + s1.ψ), s1.v*sind(90 + s1.ψ), s1.hd
        x2, y2, h2, vx2, vy2, h2_dot = s2.e, s2.n, s2.h, s2.v*cosd(90 + s2.ψ), s2.v*sind(90 + s2.ψ), s2.hd

        dxy = [(x2 - x1), (y2 - y1)]
        dvxy = [(vx2 - vx1), (vy2 - vy1)]

        r = norm(dxy) # range [ft]
        r_dot = dot(dxy,dvxy) / norm(dxy) # range rate [ft/s]

        a = abs(h1 - h2) # relative altitude [ft]
        a_dot = sign(h2 - h1) * (h2_dot - h1_dot) # relative altitude rate of change [ft/s]

        # get range parameters based on our altitude
        if h1 < 1000
            sl = 2
            tau = 0
            dmod = 0
            zthr = 0
            alim = 0
        elseif h1 < 2350
            sl = 3
            tau = 15
            dmod = 0.2 * 6076.12
            zthr = 600
            alim = 300
        elseif h1 < 5000
            sl = 4
            tau = 20
            dmod = 0.35 * 6076.12
            zthr = 600
            alim = 300
        elseif h1 < 10000
            sl = 5
            tau = 25
            dmod = 0.55 * 6076.12
            zthr = 600
            alim = 350
        elseif h1 < 20000
            sl = 6
            tau = 30
            dmod = 0.80 * 6076.12
            zthr = 600
            alim = 400
        elseif h1 < 42000
            sl = 7
            tau = 35
            dmod = 1.10 * 6076.12
            zthr = 700
            alim = 600
        else
            sl = 7
            tau = 35
            dmod = 1.10 * 6076.12
            zthr = 800
            alim = 700
        end

        # test for activation
        if (r_dot < 0 && (-(r - dmod) / r_dot <= tau || r < dmod)) && ((a_dot < 0 && -a / a_dot <= tau) || a <= zthr)

            ascend_cross = false
            ascend_dist = 0
            ascend_alim = false

            descend_cross = false
            descend_dist = 0
            descend_alim = false

            t_ = -r / r_dot # time to closest approach

            ###################################################################
            # test ascend command

            h1_dot_ascend = tcas.climb_rate

            h1_cpa = h1 + h1_dot_ascend * t_ # altitude of AC1 at closest point of approach
            h2_cpa = h2 + h2_dot * t_       # altitude of AC2 at closest point of approach

            if (h1 <= h2 && h1_cpa >= h2_cpa) || (h1 >= h2 && h1_cpa <= h2_cpa)
                # we predict an ascend over the other aircraft or a descent under the other aircraft between now and CPA
                # if we issue an ascend
                ascend_cross = true
            end

            ascend_dist = abs(h1_cpa - h2_cpa) # altitude difference at CPA
            if ascend_dist >= alim
                # distance is greater than threshold (we are good)
                ascend_alim = true
            end

            ###################################################################
            # test descend command

            h1_dot_descend = -tcas.climb_rate

            h1_cpa = h1 + h1_dot_descend * t_ # altitude of AC1 at closest point of approach
            h2_cpa = h2 + h2_dot * t_         # altitude of AC2 at closest point of approach

            if (h1 <= h2 && h1_cpa >= h2_cpa) || (h1 >= h2 && h1_cpa <= h2_cpa)
                # we predict an ascend over the other aircraft or a descent under the other aircraft between now and CPA
                # if we issue a descend
                descend_cross = true
            end

            descend_dist = abs(h1_cpa - h2_cpa)
            if descend_dist >= alim
                # distance is greater than threshold (we are good)
                descend_alim = true
            end

            ###################################################################

            if ascend_cross
                if descend_alim
                    resolution_advisory = h1_dot_descend
                elseif ascend_alim
                    resolution_advisory = h1_dot_ascend
                else
                    resolution_advisory = h1_dot_descend
                end
            elseif descend_cross
                if ascend_alim
                    resolution_advisory = h1_dot_ascend
                elseif descend_alim
                    resolution_advisory = h1_dot_descend
                else
                    resolution_advisory = h1_dot_ascend
                end
            else
                if descend_alim && ascend_alim # best case scenario
                    if descend_dist < ascend_dist
                        resolution_advisory = h1_dot_descend
                    else
                        resolution_advisory = h1_dot_ascend
                    end
                elseif descend_alim
                    resolution_advisory = h1_dot_descend
                elseif ascend_alim
                    resolution_advisory = h1_dot_ascend
                else
                    if descend_dist > ascend_dist
                        resolution_advisory = h1_dot_descend
                    else
                        resolution_advisory = h1_dot_ascend
                    end
                end
            end

            tcas.advisory = Advisory(resolution_advisory)
        end
    end

    tcas.advisory
end

############################

function generate_encounters!(arr::Vector{Encounter}, model::EncounterModel, params::EncounterSimParams=DEFAULT_SIM_PARAMS)
    for i in 1 : length(arr)
        arr[i] = rand(model, params)
    end
    arr
end
function generate_encounters(
    n::Int,
    model::EncounterModel,
    params::EncounterSimParams=DEFAULT_SIM_PARAMS
    )

    generate_encounters!(Array(Encounter, n), model, params)
end

function generate_encounters!(
    arr::Vector{Encounter},
    model::EncounterModel,
    cas::CollisionAvoidanceSystem,
    params::EncounterSimParams=DEFAULT_SIM_PARAMS,
    )

    for i in 1 : length(arr)
        arr[i] = rand(model, cas, params)
    end
    arr
end
function generate_encounters(
    n::Int,
    model::EncounterModel,
    cas::CollisionAvoidanceSystem,
    params::EncounterSimParams=DEFAULT_SIM_PARAMS
    )

    generate_encounters!(Array(Encounter, n), model, cas, params)
end

const MISS_DISTANCE_DISC = LinearDiscretizer(collect(linspace(0.0, 10000.0, 21)))
function get_miss_distance_counts(encounters::Vector{Encounter}, disc::LinearDiscretizer=MISS_DISTANCE_DISC)
    counts = zeros(Int, nlabels(disc))
    for enc in encounters
        miss_dist = get_miss_distance(enc)
        counts[encode(disc, miss_dist)] += 1
    end
    counts
end
function plot_miss_distance_histogram(counts::Vector{Int}, disc::LinearDiscretizer=MISS_DISTANCE_DISC)
    xarr = Array(Float64, 2*length(disc.binedges))
    yarr = Array(Float64, length(xarr))

    j = 0
    for (i,x) in enumerate(disc.binedges)
        xarr[j+=1] = disc.binedges[i]
        yarr[j] = i == 1 ? 0.0 : counts[i-1]
        xarr[j+=1] = disc.binedges[i]
        yarr[j] = i == length(disc.binedges) ? 0.0 : counts[i]
    end

    plot(xarr, yarr, fill = (0, 1.0),
        xlabel="minimum miss distance",
        ylabel="counts",)
end

############################

const AIRPLANE_IMAGE = read_from_png("../airplane-top-view.png")
const AIRPLANE_LENGTH = 70.7136 # meters
const AIRPLANE_SCALE = AIRPLANE_LENGTH/AIRPLANE_IMAGE.width

function get_canvas_and_context(canvas_width::Int, canvas_height::Int;
    camera_pos::Tuple{Float64,Float64} = (0.0,0.0), # [m]
    camera_zoom::Float64 = 0.5, # [pix/m]
    )
    s = CairoRGBSurface(canvas_width, canvas_height)
    ctx = creategc(s)

    # clear background to white
    set_source_rgb(ctx, 1.0,1.0,1.0)
    paint(ctx)

    # reset the transform such that (0,0) is the middle of the image
    reset_transform(ctx)
    Cairo.translate(ctx, canvas_width/2, canvas_height/2)                 # translate to image center
    scale(ctx, camera_zoom, -camera_zoom )  # [pix -> m]
    Cairo.translate(ctx, -camera_pos[1], -camera_pos[2]) # translate to camera location

    (s, ctx)
end

function center_on_aircraft!(ctx::CairoContext, states::AircraftState...)
    n = 0.0
    e = 0.0
    for s in states
        n += s.n
        e += s.e
    end
    Cairo.translate(ctx, -e/length(states), -n/length(states))
    ctx
end

function render!(ctx::CairoContext, s::AircraftState)
    Cairo.save(ctx)
    Cairo.translate(ctx, s.e, s.n)
    Cairo.rotate(ctx, π/2+deg2rad(s.ψ))
    Cairo.translate(ctx,-AIRPLANE_LENGTH/2, -AIRPLANE_LENGTH/2)
    scale(ctx, AIRPLANE_SCALE, AIRPLANE_SCALE)
    set_source_surface(ctx, AIRPLANE_IMAGE, 0.0, 0.0)
    paint(ctx)
    restore(ctx)
end

function render(s1::AircraftState, s2::AircraftState;
    canvas_width::Int = 1000,
    canvas_height::Int = 600,
    )

    s, ctx = get_canvas_and_context(canvas_width, canvas_height)
    render!(ctx, s1)
    render!(ctx, s2)
    s
end

function render!(ctx::CairoContext, trace::Vector{AircraftState}, color::Tuple{Float64,Float64,Float64,Float64})
    Cairo.save(ctx)
    # set_source_rgba(ctx,0.0,0.0,1.0,1.0)
    set_source_rgba(ctx,color...)
    set_line_width(ctx,0.5)

    move_to(ctx, trace[1].e, trace[1].n)
    for i in 2 : length(trace)
        line_to(ctx, trace[i].e, trace[i].n)
    end
    Cairo.stroke(ctx)
    restore(ctx)
    ctx
end

function render(enc::Encounter, t::Float64;
    canvas_width::Int = 1000,
    canvas_height::Int = 600,
    zoom::Float64 = 0.1,
    )

    s, ctx = get_canvas_and_context(canvas_width, canvas_height, camera_zoom=zoom)

    # pull the current aircraft positions
    s1 = get_interpolated_state(enc.trace1, enc.Δt, t)
    s2 = get_interpolated_state(enc.trace2, enc.Δt, t)

    # center
    center_on_aircraft!(ctx, s1, s2)

    # render the aircraft traces
    render!(ctx, enc.trace1, (0.0,0.0,1.0,1.0))
    render!(ctx, enc.trace2, (0.0,0.0,1.0,1.0))

    # render the current aircraft positions
    render!(ctx, s1)
    render!(ctx, s2)

    s
end

end # module
