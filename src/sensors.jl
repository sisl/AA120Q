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