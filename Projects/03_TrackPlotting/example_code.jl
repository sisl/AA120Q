using DataFrames
using PGFPlots

# initial = readtable("initial.txt")
# transition = readtable("transition.txt")

# type AircraftState
#     t::Float64
#     x::Float64
#     y::Float64
#     h::Float64
#     vx::Float64
#     vy::Float64
#     vh::Float64

#     AircraftState() = new(0.0,0.0,0.0,0.0,0.0,0.0,0.0)
# end

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
        @assert(transition[i,:id] == id)
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

function update_psi(state1::Vector{Float64}, state2::Vector{Float64})

    x1, y1 = state1
    x2, y2 = state2

    x = x2 - x1
    y = y2 - y1

    if x >= 0 && y >= 0
        psi = atand(y / x)
    elseif x <= 0 && y >= 0
        psi = atand(y / x) + 180
    elseif x <= 0 && y <= 0
        psi = atand(y / x) + 180
    elseif x >= 0 && y <= 0
        psi = atand(y / x) + 360
    end

    return psi
end
function transform_regarding_TCA(aem, L, geometry_at_TCA)

    chi, beta_, hmd, vmd = geometry_at_TCA

    x1_tca, y1_tca, h1_tca, v1_tca, psi1_tca = aem.state_tca[1, :]
    x2_tca, y2_tca, h2_tca, v2_tca, psi2_tca = aem.state_tca[2, :]

    AC1_state = reshape(aem.dynamic_states[1, 1:aem.dn_state_index[1], :], aem.dn_state_index[1], 6)
    AC2_state = reshape(aem.dynamic_states[2, 1:aem.dn_state_index[2], :], aem.dn_state_index[2], 6)


    AC1_state[:, 2] -= x1_tca
    AC1_state[:, 3] -= y1_tca

    AC1_state[:, 2:3] = transpose([cosd(-psi1_tca) -sind(-psi1_tca); sind(-psi1_tca) cosd(-psi1_tca)] * AC1_state[:, 2:3]')

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

    AC1_state[:, 4] += (-h1_tca + h_trans)

    psi = update_psi(AC1_state[1, 2:3], AC1_state[2, 2:3])
    AC1_state[:, 6] += psi


    AC2_state[:, 2] -= x2_tca
    AC2_state[:, 3] -= y2_tca

    psi2_0 = beta_ - psi2_tca
    AC2_state[:, 2:3] = transpose([cosd(psi2_0) -sind(psi2_0); sind(psi2_0) cosd(psi2_0)] * AC2_state[:, 2:3]')

    v_r_tca = [v2_tca * cosd(beta_) - v1_tca, v2_tca * sind(beta_)]

    x_trans = hmd / norm(v_r_tca) * [-v_r_tca[2], v_r_tca[1]]

    if chi == 1     # front
        if x_trans[1] < 0
            x_trans = -x_trans
        end
    else
        if x_trans[1] >= 0
            x_trans = -x_trans
        end
    end

    AC2_state[:, 2] += x_trans[1]
    AC2_state[:, 3] += x_trans[2]

    AC2_state[:, 4] += (-h2_tca + h_trans - vmd)

    psi = update_psi(AC2_state[1, 2:3], AC2_state[2, 2:3])
    AC2_state[:, 6] += psi


    aem.dynamic_states[1, 1:aem.dn_state_index[1], :] = reshape(AC1_state, 1, size(AC1_state, 1), 6)
    aem.dynamic_states[2, 1:aem.dn_state_index[2], :] = reshape(AC2_state, 1, size(AC2_state, 1), 6)
end

# transform_regarding_TCA(5, (0.0, 0.5*π, 10.0, 10.0))