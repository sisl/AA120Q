abstract type CollisionAvoidanceSystem end
abstract type FullyObservableCollisionAvoidanceSystem <: CollisionAvoidanceSystem end
abstract type PartiallyObservableCollisionAvoidanceSystem <: CollisionAvoidanceSystem end

reset!(cas::CollisionAvoidanceSystem) = cas # do nothing by default
update!(cas::FullyObservableCollisionAvoidanceSystem, s1::AircraftState, s2::AircraftState, params::EncounterSimParams) = error("update! not implemented for FullyObservableCollisionAvoidanceSystem $cas")
update!(cas::PartiallyObservableCollisionAvoidanceSystem, reading::SensorReading, params::EncounterSimParams) = error("update! not implemented for PartiallyObservableCollisionAvoidanceSystem $cas")
update!(cas::PartiallyObservableCollisionAvoidanceSystem, s1::AircraftState, s2::AircraftState, params::EncounterSimParams)  = update!(cas, SensorReading(s1, s2), params)
function Base.rand(
    model::EncounterModel, # human pilot model and initial scene generation
    cas::CollisionAvoidanceSystem, # advisory policy
    params::EncounterSimParams, # defines encounter parameters
    )

    s1, s2 = sample_initial(model) # get initial setup
    reset!(cas) # re-initialize the CAS

    # store aircraft states of planes in separate arrays
    trajectory = Vector{EncounterState}(params.nsteps+1)
    trajectory[1] = EncounterState(s1, s2, 0.0)

    advisories = Array(Advisory, params.nsteps)

    for i in 1 : params.nsteps

        s1, s2 = trajectory[i].plane1, trajectory[i].plane2
        a1, a2 = sample_transition(s1, s2, model, params)

        advisory = update!(cas, s1, s2, params)
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            a1 = AircraftAction(a1.Δu, a1.Δv)
        end
        
        trajectory[i+1] = update_state(s1, s2, params.Δt)
        advisories[i] = advisory
    end

    # return the encounter
    Encounter(params.Δt, trajectory, advisories)
end
function Base.rand(
    traj::Trajectory, # human-generated encounter
    cas::CollisionAvoidanceSystem, # advisory policy
    )

    reset!(cas) # re-initialize the CAS

    params = EncounterSimParams(length(enc.plane1)-1, enc.Δt)

    # infer all actions
    #actions1 = Array(AircraftAction, params.nsteps)
    #actions2 = Array(AircraftAction, params.nsteps)
    for i in 1 : params.nsteps
        s11 = traj[i].plane1
        s12 = traj[i+1].plane1
        actions1[i] = AircraftAction((s12.v - s11.v)/params.Δt,
                                     (s12.h - s11.h)/params.Δt,
                                    )
        s21 = traj[i].plane2
        s22 = traj[i+1].plane2
        actions2[i] = AircraftAction((s22.v - s21.v)/params.Δt,
                                     (s22.h - s21.h)/params.Δt,
                                    )
    end


    # simulate to get the traces
    trajectory = Vector{EncounterState}(params.nsteps+1)
    
    # plane1 = Array(AircraftState, params.nsteps+1)
    # plane2 = Array(AircraftState, params.nsteps+1)
    
    advisories = Array(Advisory, params.nsteps)
    trajectory[1] = EncounterState(s1, s2, 0.0)

    for i in 1 : params.nsteps

        s1, s2 = trajectory[i].plane1, trajectory[i].plane2
        a1, a2 = actions1[i], actions2[i]

        advisory = update!(cas, s1, s2, params)
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            a1 = AircraftAction(a1.Δu, a1.Δv)
        end
        
        trajectory[i+1] = update_state(s1, s2, params.Δt)
        advisories[i] = advisory
    end

    # return the encounter
    Encounter(trajectory, advisories)
end