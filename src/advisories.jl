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