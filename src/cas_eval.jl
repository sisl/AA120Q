using Printf

const ADVISORY_PENALTY           =   10.0 # penalty for issuing an advisory
const ADVISORY_MAGNITUDE_PENALTY =    1.0 # penalty proportional to magnitude of climb rate
const ADVISORY_REVERSAL_PENALTY  =   50.0 # penalty for a reversal (changing sign of advisory)
const NMAC_PENALTY               =    1e5 # penalty for an NMAC

struct CASEval
    n_encounters::Int
    n_advisories::Int
    n_NMACs::Int
    total_penalty::Float64
end
Base.show(io::IO, e::CASEval) = @printf(io, "CASEval(n_encounters: %d, n_advisories: %d, n_NMACs: %d, penalty: %.2f, normalized: %.2f)", e.n_encounters, e.n_advisories, e.n_NMACs, e.total_penalty, e.total_penalty/e.n_encounters)

function _evaluate(cas::CollisionAvoidanceSystem, traj::Trajectory)
    reset!(cas) # re-initialize the CAS

    params = EncounterSimParams(length(traj)-1, 1.0) # change this

    # infer all actions
    actions1 = Array{AircraftAction}(undef, params.nsteps)
    actions2 = Array{AircraftAction}(undef, params.nsteps)
    for i in 1 : params.nsteps
        s11 = traj[i].plane1
        s12 = traj[i+1].plane1
        actions1[i] = AircraftAction((s12.v - s11.v)/params.Δt,
                                     (s12.u - s11.u)/params.Δt
                                    )
        
        s21 = traj[i].plane2
        s22 = traj[i+1].plane2
        actions2[i] = AircraftAction((s22.v - s21.v)/params.Δt,
                                     (s22.u - s21.u)/params.Δt
                                    )
    end

    # simulate to get the traces
    s1 = traj[1].plane1
    s2 = traj[1].plane2
    n_advisories = 0
    prev_advisory = NaN
    total_penalty = 0.0

    for i in 1 : params.nsteps

        a1, a2 = actions1[i], actions2[i]
        advisory = update!(cas, s1, s2, params)
        
        if !is_no_advisory(advisory)
            # replace response with that of advisory
            climb_rate = clamp(advisory.climb_rate, CLIMB_RATE_MIN, CLIMB_RATE_MAX)
            a1 = AircraftAction(a1.Δu, climb_rate)

            if !isapprox(climb_rate, prev_advisory)
                n_advisories += 1
                prev_advisory = climb_rate
                total_penalty += ADVISORY_MAGNITUDE_PENALTY * abs(climb_rate) + ADVISORY_PENALTY
                if !isnan(prev_advisory) # reversal
                    total_penalty += ADVISORY_REVERSAL_PENALTY
                end
            end
        end

        s1 = update_state(s1, a1, params.Δt)
        s2 = update_state(s2, a2, params.Δt)

        if is_nmac(s1, s2)
            return (true, n_advisories, total_penalty)
        end
    end

    (false, n_advisories, total_penalty)
end
function evaluate(cas::CollisionAvoidanceSystem, trajectories::Vector{Trajectory})
    n_advisories = 0
    n_NMACs = 0
    total_penalty = 0.0
    for traj in trajectories
        had_NMAC, nadv, encounter_penalty = _evaluate(cas, traj)
        n_advisories += nadv
        n_NMACs += had_NMAC
        total_penalty += encounter_penalty + had_NMAC*NMAC_PENALTY
    end
    CASEval(length(trajectories), n_advisories, n_NMACs, total_penalty)
end
function evaluate(cas::CollisionAvoidanceSystem, trajectories::Vector{Trajectory}, nsamples::Int)
    n_advisories = 0
    n_NMACs = 0
    total_penalty = 0.0
    sample_range = 1:length(trajectories)

    for i in 1 : nsamples
        traj = trajectories[rand(sample_range)]
        had_NMAC, nadv, encounter_penalty = _evaluate(cas, traj)
        n_advisories += nadv
        n_NMACs += had_NMAC
        total_penalty += encounter_penalty + had_NMAC*NMAC_PENALTY
    end
    CASEval(nsamples, n_advisories, n_NMACs, total_penalty)
end


# Need to change this
const MISS_DISTANCE_DISC = LinearDiscretizer(collect(range(0.0, stop=25000.0, length=21)))
function get_miss_distance_counts(encounters::Vector{Trajectory}, disc::LinearDiscretizer=MISS_DISTANCE_DISC)
    counts = zeros(Int, nlabels(disc))
    for enc in encounters
        min_sep = get_min_separation(enc)
        counts[encode(disc, min_sep)] += 1
    end
    counts
end
function plot_miss_distance_histogram(counts::Vector{Int}, disc::LinearDiscretizer=MISS_DISTANCE_DISC)
    xarr = Array{Float64}(undef, 2*length(disc.binedges))
    yarr = Array{Float64}(undef, length(xarr))

    j = 0
    for (i,x) in enumerate(disc.binedges)
        xarr[j+=1] = disc.binedges[i]
        yarr[j] = i == 1 ? 0.0 : counts[i-1]
        xarr[j+=1] = disc.binedges[i]
        yarr[j] = i == length(disc.binedges) ? 0.0 : counts[i]
    end

    plot(xarr, yarr, fill = (0, 1.0),
        xlabel="minimum separation distance",
        ylabel="counts",)
end
