"""
    The Advisory provides the pilot with information on the vertical speed or pitch
    angle to fly or avoid to resolve an encounter.

    The climb rate must be between ±4400 feet per minute
    Setting the climb rate to NaN is equivalent to having no Advisory

    The simulated pilot will begin following the advisory exactly at t ∼ U(0, pilot_delay)
"""
struct Advisory
<<<<<<< HEAD
    # change climb rate? 
=======
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
    climb_rate::Float64 # m/s
end
const CLIMB_RATE_MAX =  1350/60 # m/s
const CLIMB_RATE_MIN = -1350/60 # m/s
const ADVISORY_NONE = Advisory(NaN)
is_no_advisory(a::Advisory) = isnan(a.climb_rate)