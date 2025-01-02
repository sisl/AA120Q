
struct HW3_Support_Code end

# Load in the encounter models
# Loading and reconstructing the DiscretizedBayesNet to avoid scope/loading issues
JLD2.@load "support_code/encounter_models.jld2"
initial_state_model = DiscretizedBayesNet(init_bn, init_D)
transition_model = DiscretizedBayesNet(transitions_bn, transitions_D)

# Set up sampling functions
function Base.rand(model::DiscretizedBayesNet)
	sample = rand(model.dbn) # Sample from the Bayesian network

	# Convert the discrete samples to continuous samples
	for (sym, disc) in model.discs
		sample[sym] = decode(disc, sample[sym])
	end
	
	return sample
end

function Base.rand(model::DiscretizedBayesNet, evidence::Dict{Symbol, <:Real})
    # Convert continuous state to discrete bins
    
	evidence_encoded = Assignment(
    	:Δx => encode(model.discs[:Δx], evidence[:Δx]),
		:Δy => encode(model.discs[:Δy], evidence[:Δy]),
    	:Δu => encode(model.discs[:Δu], evidence[:Δu]),
    	:Δv => encode(model.discs[:Δv], evidence[:Δv])
	)
    
    # Sample accelerations given the current state. Here we will sample 500 weighted samples consistent with the evidence and then sample from the weighted samples.
	samples, weights = [], Float64[]
	for _ in 1:10
		(s, w) = get_weighted_sample(model.dbn, evidence_encoded)
		push!(samples, s)
		push!(weights, w)
	end

	trans_model_sample = wsample(samples, weights)

    # Convert back to continuous values
	accel_sample = Dict()
    accel_sample[:au1] = decode(model.discs[:au1], trans_model_sample[:au1])
    accel_sample[:av1] = decode(model.discs[:av1], trans_model_sample[:av1])
	accel_sample[:au2] = decode(model.discs[:au2], trans_model_sample[:au2])
	accel_sample[:av2] = decode(model.discs[:av2], trans_model_sample[:av2])
    
    return accel_sample
end

function encounter_from_init_sample(sampled_init_cond::Dict{Symbol, Any})
	encounter_state = EncounterState(
		AircraftState(
			0.0,
			sampled_init_cond[:y1], 
			sampled_init_cond[:u1], 
			sampled_init_cond[:v1]
		),
		AircraftState(
			0.0 + sampled_init_cond[:Δx],
			sampled_init_cond[:y1] + sampled_init_cond[:Δy], 
			sampled_init_cond[:u1] + sampled_init_cond[:Δu],
			sampled_init_cond[:v1] + sampled_init_cond[:Δv]
		),
		0.0 # Time is 0 based on it being an initial condition
	)
	return encounter_state
end

function sample_step(model::DiscretizedBayesNet, state::EncounterState)
    # Note: dt = 1.0 

	# Get relative state
    Δx = state.plane2.x - state.plane1.x 
    Δy = state.plane2.y - state.plane1.y
    Δu = state.plane2.u - state.plane1.u 
    Δv = state.plane2.v - state.plane1.v
    
    # Sample accelerations and update state
    trans_sample = rand(model, Dict(:Δx=>Δx, :Δy=>Δy, :Δu=>Δu, :Δv=>Δv))
    
    # Update positions
    x1_new = state.plane1.x + state.plane1.u + 0.5 * trans_sample[:au1]
    y1_new = state.plane1.y + state.plane1.v + 0.5 * trans_sample[:av1]
    x2_new = state.plane2.x + state.plane2.u + 0.5 * trans_sample[:au2]
    y2_new = state.plane2.y + state.plane2.v + 0.5 * trans_sample[:av2]

	# Update velocities
	u1_new = state.plane1.u + trans_sample[:au1]
	v1_new = state.plane1.v + trans_sample[:av1]
	u2_new = state.plane2.u + trans_sample[:au2]
	v2_new = state.plane2.v + trans_sample[:av2]
	
    return EncounterState(
        AircraftState(x1_new, y1_new, u1_new, v1_new),
        AircraftState(x2_new, y2_new, u2_new, v2_new),
        state.t + 1
    )
end

function sample_encounter(initial_state::EncounterState, tx_model::DiscretizedBayesNet; steps=50)
    
    trajectory = Vector{EncounterState}(undef, steps + 1)
    trajectory[1] = initial_state
    
    for i in 1:steps
        trajectory[i+1] = sample_step(tx_model, trajectory[i])
    end
    
    return trajectory
end

function sample_encounter(init_model::DiscretizedBayesNet, tx_model::DiscretizedBayesNet; kwargs...)

	init_sample = rand(init_model)
	init_state = encounter_from_init_sample(init_sample)
	return sample_encounter(init_state, tx_model; kwargs...)
end
