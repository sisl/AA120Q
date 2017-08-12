mutable struct EncounterSimParams
    nsteps::Int # number of steps to simulate for
    Δt::Float64 # timestep of each update [s]
end
const DEFAULT_SIM_PARAMS = EncounterSimParams(50, 1.0)

abstract type EncounterModel end
sample_initial(model::EncounterModel) = error("sample_initial not implemented for EncounterModel $model") # should return A, C1, C2, s1 and s2 at t=0 sampled from the model
sample_transition(s1::AircraftState, s2::AircraftState, model::EncounterModel, params::EncounterSimParams) = error("step not implemented for EncounterModel $model") # returns (s1, s2) at t+1

function Base.rand(model::EncounterModel, params::EncounterSimParams)
    s1, s2 = sample_initial(model) # get initial setup
    
    # simulate to get the traces
    trajectory = Vector{EncounterState}(params.nsteps+1)
    trajectory[1] = EncounterState(s1, s2, 0.0)

    for i in 1 : params.nsteps
        a1, a2 = sample_transition(trajectory[i].plane1, trajectory[i].plane2, model, params)
        trajectory[i+1] = update_state(trajectory[i].plane1, trajectory[i].plane2, params.Δt)
    end

    # return the encounter
    trajectory
end