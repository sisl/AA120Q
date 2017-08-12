struct AircraftAction
    Δu::Float64 # acceleration [m/s²]
    Δv::Float64 # acceleration [m/s²]
end

struct AircraftState
    x::Float64  # horizontal distance  [m]
    y::Float64  # vertical distance    [m]
    u::Float64  # speed                [m/s]
    v::Float64  # speed                [m/s]
end

start_state(v::Float64) = AircraftState(0.0,0.0,0.0,0.0,v,0.0)
function interpolate_state(a::AircraftState, b::AircraftState, z::Float64)
    AircraftState(
            a.x + (b.x - a.x)*z,
            a.y + (b.y - a.y)*z,
            a.u + (b.u - a.u)*z,
            a.v + (b.v - a.v)*z,
        )
end
function update_state(s::AircraftState, a::AircraftAction, Δt::Float64)

    x, y, u, v = s.x, s.y, s.u, s.v
    Δu, Δv  = a.Δu, a.Δv
    
    u₂ = u + Δu * Δt  # m/s
    v₂ = v + Δv * Δt  # m/s

    AircraftState(x, y, v₂, u₂)
end

function get_interpolated_state(trace::Vector{AircraftState}, Δt::Float64, t::Float64)
    # t = 0.0 will give you the first state
    # t = Δt/2 will give you the state halfway between state 1 and state 2, etc.

    i_lo = clamp(floor(Int, t/Δt) + 1, 1, length(trace))
    i_hi = min(i_lo + 1, length(trace))
    z = (t - (i_lo-1)*Δt) / Δt

    interpolate_state(trace[i_lo], trace[i_hi], z)
end