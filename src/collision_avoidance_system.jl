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
        
<<<<<<< HEAD
        trajectory[i+1] = EncounterState(update_state(s1, a1, params.Δt),
                                         update_state(s2, a2, params.Δt), 
                                         params.Δt
                                        )
=======
        trajectory[i+1] = update_state(s1, s2, params.Δt)
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
        advisories[i] = advisory
    end

    # return the encounter
<<<<<<< HEAD
    Encounter(trajectory, advisories)
=======
    Encounter(params.Δt, trajectory, advisories)
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
end
function Base.rand(
    traj::Trajectory, # human-generated encounter
    cas::CollisionAvoidanceSystem, # advisory policy
    )

    reset!(cas) # re-initialize the CAS

<<<<<<< HEAD
    params = EncounterSimParams(length(traj)-1, 1)

    # infer all actions
    actions1 = Array{AircraftAction}(params.nsteps)
    actions2 = Array{AircraftAction}(params.nsteps)
    for i in 1 : params.nsteps
        s11 = traj[i].plane1
        s12 = traj[i+1].plane1
        actions1[i] = AircraftAction((s12.u - s11.u)/params.Δt,
                                     (s12.v - s11.v)/params.Δt,
                                    )
        s21 = traj[i].plane2
        s22 = traj[i+1].plane2
        actions2[i] = AircraftAction((s22.u - s21.u)/params.Δt,
                                     (s22.v - s21.v)/params.Δt,
=======
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
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
                                    )
    end


    # simulate to get the traces
<<<<<<< HEAD
    sim_traj = Vector{EncounterState}(params.nsteps+1)
    advisories = Array{Advisory}(params.nsteps)
    
    sim_traj[1] = traj[1]

    for i in 1 : params.nsteps

        s1, s2 = traj[i].plane1, traj[i].plane2
=======
    trajectory = Vector{EncounterState}(params.nsteps+1)
    
    # plane1 = Array(AircraftState, params.nsteps+1)
    # plane2 = Array(AircraftState, params.nsteps+1)
    
    advisories = Array(Advisory, params.nsteps)
    trajectory[1] = EncounterState(s1, s2, 0.0)

    for i in 1 : params.nsteps

        s1, s2 = trajectory[i].plane1, trajectory[i].plane2
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
        a1, a2 = actions1[i], actions2[i]

        advisory = update!(cas, s1, s2, params)
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            a1 = AircraftAction(a1.Δu, a1.Δv)
        end
<<<<<<< HEAD
        sim_traj[i+1] = EncounterState(update_state(s1, a1, params.Δt),
                                       update_state(s2, a2, params.Δt), 
                                       params.Δt
                                      )
=======
        
        trajectory[i+1] = update_state(s1, s2, params.Δt)
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
        advisories[i] = advisory
    end

    # return the encounter
<<<<<<< HEAD
    Encounter(sim_traj, advisories)
=======
    Encounter(trajectory, advisories)
>>>>>>> 34d9dd80b5f647280fd6b47c3d97bbbfabf02265
end