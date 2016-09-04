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