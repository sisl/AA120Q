abstract CollisionAvoidanceSystem
abstract FullyObservableCollisionAvoidanceSystem <: CollisionAvoidanceSystem
abstract PartiallyObservableCollisionAvoidanceSystem <: CollisionAvoidanceSystem

reset!(cas::CollisionAvoidanceSystem) = cas # do nothing by default
update!(cas::FullyObservableCollisionAvoidanceSystem, s1::AircraftState, s2::AircraftState, params::EncounterSimParams) = error("update! not implemented for FullyObservableCollisionAvoidanceSystem $cas")
update!(cas::PartiallyObservableCollisionAvoidanceSystem, reading::SensorReading, params::EncounterSimParams) = error("update! not implemented for PartiallyObservableCollisionAvoidanceSystem $cas")
update!(cas::PartiallyObservableCollisionAvoidanceSystem, s1::AircraftState, s2::AircraftState, params::EncounterSimParams)  = update!(cas, SensorReading(s1, s2), params)
function Base.rand(
    model::EncounterModel, # human pilot model and initial scene generation
    cas::CollisionAvoidanceSystem, # advisory policy
    params::EncounterSimParams, # defines encounter parameters
    )

    A, C1, C2, s1, s2 = sample_initial(model) # get initial setup
    reset!(cas) # re-initialize the CAS

    # simulate to get the traces
    trace1 = Array(AircraftState, params.nsteps+1)
    trace2 = Array(AircraftState, params.nsteps+1)
    advisories = Array(Advisory, params.nsteps)
    trace1[1] = s1
    trace2[1] = s2
    for i in 1 : params.nsteps

        s1, s2 = trace1[i], trace2[i]
        a1, a2 = sample_transition(s1, s2, model, params)

        advisory = update!(cas, s1, s2, params)
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            a1 = AircraftAction(a1.Δv, advisory.climb_rate, a1.Δψ)
        end

        trace1[i+1] = update_state(s1, a1, params.Δt)
        trace2[i+1] = update_state(s2, a2, params.Δt)
        advisories[i] = advisory
    end

    # return the encounter
    Encounter(A, C1, C2, params.Δt, trace1, trace2, advisories)
end
function Base.rand(
    enc::Encounter, # human-generated encounter
    cas::CollisionAvoidanceSystem, # advisory policy
    )

    reset!(cas) # re-initialize the CAS

    params = EncounterSimParams(length(enc.trace1)-1, enc.Δt)

    # infer all actions
    actions1 = Array(AircraftAction, params.nsteps)
    actions2 = Array(AircraftAction, params.nsteps)
    for i in 1 : params.nsteps
        s11 = enc.trace1[i]
        s12 = enc.trace1[i+1]
        actions1[i] = AircraftAction((s12.v - s11.v)/params.Δt,
                                     (s12.h - s11.h)/params.Δt,
                                     rad2deg(atan2(sind(s12.ψ - s11.ψ), cosd(s12.ψ - s11.ψ)))/params.Δt)
        s21 = enc.trace2[i]
        s22 = enc.trace2[i+1]
        actions2[i] = AircraftAction((s22.v - s21.v)/params.Δt,
                                     (s22.h - s21.h)/params.Δt,
                                     rad2deg(atan2(sind(s22.ψ - s21.ψ), cosd(s22.ψ - s21.ψ)))/params.Δt)
    end


    # simulate to get the traces
    trace1 = Array(AircraftState, params.nsteps+1)
    trace2 = Array(AircraftState, params.nsteps+1)
    advisories = Array(Advisory, params.nsteps)
    trace1[1] = enc.trace1[1]
    trace2[1] = enc.trace2[1]

    for i in 1 : params.nsteps

        s1, s2 = trace1[i], trace2[i]
        a1, a2 = actions1[i], actions2[i]

        advisory = update!(cas, s1, s2, params)
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            a1 = AircraftAction(a1.Δv, advisory.climb_rate, a1.Δψ)
        end

        trace1[i+1] = update_state(s1, a1, params.Δt)
        trace2[i+1] = update_state(s2, a2, params.Δt)
        advisories[i] = advisory
    end

    # return the encounter
    Encounter(enc.A, enc.C1, enc.C2, params.Δt, trace1, trace2, advisories)
end