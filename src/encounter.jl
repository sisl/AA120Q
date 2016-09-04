
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