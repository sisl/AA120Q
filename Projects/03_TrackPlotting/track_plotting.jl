using DataFrames
using PGFPlots

immutable AircraftAction
    Δh::Float64 # climb rate [ft/min]
    Δψ::Float64 # turnrate [deg/s]
end
immutable AircraftState
    x::Float64  # x-position [kt]
    y::Float64  # y-position [kt]
    h::Float64  # altitude   [ft]
    v::Float64  # speed      [kt/s]
    ψ::Float64  # heading    [kt/s]
end

start_state(v::Float64, ψ::Float64) = AircraftState(0.0,0.0,0.0,v,ψ)
function update_state(s::AircraftState, a::AircraftAction, Δt::Float64;
    theta_regulated::Float64 = 45.0, # [deg]
    Δv = 0.0, # TODO: is acceleration constant over the entire encounter?
    )

    x, y, h, v, ψ = s.x, s.y, s.h, s.v, s.ψ
    Δh, Δψ  = a.Δh, a.Δψ

    if abs(Δh) > abs(v) * sind(theta_regulated)
        Δh = sign(Δh) * abs(v) * sind(theta_regulated)
    end

    x₂ = x + sqrt(v^2 - Δh^2) * cosd(ψ) * Δt
    y₂ = y + sqrt(v^2 - Δh^2) * sind(ψ) * Δt

    v₂ = v + Δv * Δt  # ft/s
    h₂ = h + Δh * Δt  # ft
    ψ₂ = ψ + Δψ * Δt    # deg

    AircraftState(x₂, y₂, h₂, v₂, ψ₂)
end

function pull_action_trace(transition::DataFrame, id::Int)
    i_start = 1
    while i_start < nrow(transition) && transition[i_start,:id] != id
        i_start += 1
    end

    i_start < nrow(transition) || error("id $id not found in transition")

    i_end = i_start
    while i_end+1 ≤ nrow(transition) && transition[i_end+1,:id] == id
        i_end += 1
    end

    actions1 = Array(AircraftAction, i_end - i_start + 2)
    actions2 = Array(AircraftAction, i_end - i_start + 2)

    for (idx, dfrow) in enumerate(i_start : i_end)
        @assert(transition[dfrow,:id] == id)
        actions1[idx] = AircraftAction(transition[dfrow, :dh1], transition[dfrow, :dpsi1])
        actions2[idx] = AircraftAction(transition[dfrow, :dh2], transition[dfrow, :dpsi2])
    end

    (actions1, actions2)
end
function get_state_trace(s₀::AircraftState, actions::Vector{AircraftAction}, Δt::Float64)
    states = Array(AircraftState, length(actions) + 1)
    states[1] = s₀
    for (i,a) in enumerate(actions)
        states[i+1] = update_state(states[i], a, Δt)
    end
    states
end

type TCAGeometry
    χ::Int
    β::Float64
    hmd::Float64
    vmd::Float64
    L::Int # altitude layer index
end

function infer_psi(x₁::Float64, y₁::Float64, x₂::Float64, y₂::Float64)

    Δx = x₂ - x₁
    Δy = y₂ - y₁

    if Δx ≥ 0 && Δy ≥ 0
        psi = atand(Δy / Δx)
    elseif Δx ≤ 0 && Δy ≥ 0
        psi = atand(Δy / Δx) + 180
    elseif Δx ≤ 0 && Δy ≤ 0
        psi = atand(Δy / Δx) + 180
    else # Δx ≥ 0 && Δy ≤ 0
        psi = atand(Δy / Δx) + 360
    end

    psi
end
function transform_regarding_TCA!(
    trace1::Vector{AircraftState},
    trace2::Vector{AircraftState},
    tca_geometry::TCAGeometry,
    index_of_TCA::Int,               # index in each trace at which TCA geometry will be enforced
    )

    χ, β, hmd, vmd, L = tca_geometry.χ, tca_geometry.β, tca_geometry.hmd, tca_geometry.vmd, tca_geometry.L

    tca1 = trace1[index_of_TCA]
    tca2 = trace2[index_of_TCA]

    x1, x2 = Float64[s.x for s in trace1], Float64[s.x for s in trace2]
    y1, y2 = Float64[s.y for s in trace1], Float64[s.y for s in trace2]
    h1, h2 = Float64[s.h for s in trace1], Float64[s.h for s in trace2]
    v1, v2 = Float64[s.v for s in trace1], Float64[s.v for s in trace2]
    ψ1, ψ2 = Float64[s.ψ for s in trace1], Float64[s.ψ for s in trace2]

    ###########

    x1 .-= tca1.x
    y1 .-= tca1.y

    pos1 = transpose([cosd(-tca1.ψ) -sind(-tca1.ψ); sind(-tca1.ψ) cosd(-tca1.ψ)] * hcat(x1, y1)')
    x1[:] = pos1[:,1]
    y1[:] = pos1[:,2]

    if L == 1
        h_trans = 1000 + (3000 - 1000) * rand()
    elseif L == 2
        h_trans = 3000 + (10000 - 3000) * rand()
    elseif L == 3
        h_trans = 10000 + (18000 - 10000) * rand()
    elseif L == 4
        h_trans = 18000 + (29000 - 18000) * rand()
    elseif L == 5
        h_trans = 29000 + (50000 - 29000) * rand()
    end

    h1 .+= (-tca1.h + h_trans)
    ψ1 .+= infer_psi(x1[1], y1[1], x1[2], y1[2])

    ###########

    x2 .-= tca2.x
    y2 .-= tca2.y

    ψ2₀ = β - tca2.ψ

    pos2 = transpose([cosd(ψ2₀) -sind(ψ2₀); sind(ψ2₀) cosd(ψ2₀)] * hcat(x2, y2)')
    x2[:] = pos2[:,1]
    y2[:] = pos2[:,2]

    v_r_tca = [tca2.v * cosd(β) - tca1.v, tca2.v * sind(β)]
    x_trans = hmd / norm(v_r_tca) * [-v_r_tca[2], v_r_tca[1]]

    if χ == 1     # front
        if x_trans[1] < 0
            x_trans = -x_trans
        end
    else
        if x_trans[1] ≥ 0
            x_trans = -x_trans
        end
    end

    x2 .+= x_trans[1]
    y2 .+= x_trans[2]
    h2 .+= (-tca2.h + h_trans - vmd)
    ψ2 .+= infer_psi(x2[1], y2[1], x2[2], y2[2])

    for i in 1 : length(trace1)
        trace1[i] = AircraftState(x1[i], y1[i], h1[i], v1[i], ψ1[i])
        trace2[i] = AircraftState(x2[i], y2[i], h2[i], v2[i], ψ2[i])
    end

    (trace1, trace2)
end