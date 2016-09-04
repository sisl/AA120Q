type EncounterSimParams
    nsteps::Int # number of steps to simulate for
    Δt::Float64 # timestep of each update [s]
end
const DEFAULT_SIM_PARAMS = EncounterSimParams(50, 1.0)

abstract EncounterModel
sample_initial(model::EncounterModel) = error("sample_initial not implemented for EncounterModel $model") # should return A, C1, C2, s1 and s2 at t=0 sampled from the model
sample_transition(s1::AircraftState, s2::AircraftState, model::EncounterModel, params::EncounterSimParams) = error("step not implemented for EncounterModel $model") # returns (s1, s2) at t+1

function Base.rand(model::EncounterModel, params::EncounterSimParams)
    A, C1, C2, s1, s2 = sample_initial(model) # get initial setup

    # simulate to get the traces
    trace1 = Array(AircraftState, params.nsteps+1)
    trace2 = Array(AircraftState, params.nsteps+1)
    trace1[1] = s1
    trace2[1] = s2
    for i in 1 : params.nsteps
        a1, a2 = sample_transition(trace1[i], trace2[i], model, params)
        trace1[i+1] = update_state(trace1[i], a1, params.Δt)
        trace2[i+1] = update_state(trace2[i], a2, params.Δt)
    end

    # return the encounter
    Encounter(A, C1, C2, params.Δt, trace1, trace2)
end