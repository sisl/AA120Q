function generate_encounters!(arr::Vector{EncounterState}, model::EncounterModel, params::EncounterSimParams=DEFAULT_SIM_PARAMS)
    for i in 1 : length(arr)
        arr[i] = rand(model, params)
    end
    arr
end
function generate_encounters(
    n::Int,
    model::EncounterModel,
    params::EncounterSimParams=DEFAULT_SIM_PARAMS
    )

    generate_encounters!(Array(Encounter, n), model, params)
end

function generate_encounters!(
    arr::Vector{Encounter},
    model::EncounterModel,
    cas::CollisionAvoidanceSystem,
    params::EncounterSimParams=DEFAULT_SIM_PARAMS,
    )

    for i in 1 : length(arr)
        arr[i] = rand(model, cas, params)
    end
    arr
end
function generate_encounters(
    n::Int,
    model::EncounterModel,
    cas::CollisionAvoidanceSystem,
    params::EncounterSimParams=DEFAULT_SIM_PARAMS
    )

    generate_encounters!(Array(Encounter, n), model, cas, params)
end