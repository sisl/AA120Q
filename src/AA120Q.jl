module AA120Q

using Reexport
using Cairo
@reexport using DataFrames
@reexport using Distributions
@reexport using Discretizers
@reexport using Plots

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

    get_dataset,
    list_datasets,
    start_state,
    update_state,
    interpolate_state,
    get_interpolated_state,
    is_nmac,
    has_nmac,
    get_miss_distance,
    plot_encounter,
    pull_encounters,

    get_dataset,

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

include(Pkg.dir("AA120Q", "src", "states_and_actions.jl"))
include(Pkg.dir("AA120Q", "src", "dataio.jl"))
include(Pkg.dir("AA120Q", "src", "advisories.jl"))
include(Pkg.dir("AA120Q", "src", "sensors.jl"))
include(Pkg.dir("AA120Q", "src", "encounter.jl"))
include(Pkg.dir("AA120Q", "src", "encounter_model.jl"))
include(Pkg.dir("AA120Q", "src", "collision_avoidance_system.jl"))
include(Pkg.dir("AA120Q", "src", "cas_eval.jl"))
include(Pkg.dir("AA120Q", "src", "encounter_generation.jl"))
include(Pkg.dir("AA120Q", "src", "cairo_rendering.jl"))
include(Pkg.dir("AA120Q", "src", "simple_TCAS.jl"))

end # module
