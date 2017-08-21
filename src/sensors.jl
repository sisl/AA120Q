const RANGE_STDEV = 15 # [m]
const BEARING_STDEV = 5 # [deg]
const RELATIVE_AZIMUTH_DISC = LinearDiscretizer([-90.0, -80.0, -70.0, -60.0, -50.0, -40.0, -30.0, -20.0, -10.0, 0.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0])

struct SensorReading
    r::Float64 # range [m], horizontal distance AC1 → AC2
    θ::Float64 # the discretized azimuth [deg] from ego to intruder
end

function SensorReading(s1::AircraftState, s2::AircraftState)
    x1, y1, vx1, vy1 = s1.x, s1.y, s1.v, s1.u
    x2, y2, vx2, vy2 = s2.x, s2.y, s2.v, s2.u

    r = hypot(x2 - x1, y2 - y1) # range [m]
    θ = rad2deg(atan2(y2 - y1, x2 - x1)) # azimuth [deg]

    # add sensor noise
    r += randn()*RANGE_STDEV
    θ = encode(RELATIVE_AZIMUTH_DISC, θ)  # encode azimuth in to 10deg bins
    
    return SensorReading(r, θ)
end