# Need for loading in BSON file
Core.eval(Main, :(import Distributions))
Core.eval(Main, :(import Discretizers))
Core.eval(Main, :(import BayesNets))
Core.eval(Main, :(import LightGraphs))

# Load in the encounter model
res = BSON.load("support_code/myencountermodel.bson")
bn_init = res[:bn_initial]
D_init = res[:D_initial]
bn_trans = res[:bn_transition]
D_trans = res[:D_transition]

# Set up data structures
struct DiscretizedBayesNet
    dbn::DiscreteBayesNet
    discs::Dict{Symbol, LinearDiscretizer}
end

initial_state_model = DiscretizedBayesNet(bn_init, D_init)
transition_model = DiscretizedBayesNet(bn_trans, D_trans)

# Set up sampling functions
function Base.rand(bn::DiscretizedBayesNet)
    sample = rand(bn.dbn) # pull from discrete Bayes net
    
    # convert discrete samples to continuous samples
    for (sym, disc) in bn.discs
        sample[sym] = decode(disc, sample[sym]) 
    end

    return sample
end

struct AircraftState
    x::Float64  # horizontal position [m]
    y::Float64  # veritcal position   [m]
    u::Float64  # horizontal speed    [m/s]
    v::Float64  # vertical speed      [m/s]
end

mutable struct EncounterState
    plane1::AircraftState
    plane2::AircraftState
    t::Float64
end

const Encounter = Vector{EncounterState}

function sample_encounter(initial_state_model, transition_model, nsteps = 50)
	enc = Vector{EncounterState}()
	
	# Sample initial state
	isample = rand(initial_state_model)
	# Convert to encounter state
	p1 = AircraftState(0.0, 
						   isample[:y1], 
						   isample[:u1], 
						   isample[:v1])
	
	p2 = AircraftState(isample[:Δx],
						   isample[:y1] + isample[:Δy],
						   isample[:u1] + isample[:Δu],
						   isample[:v1] + isample[:Δv])
	
	push!(enc, EncounterState(p1, p2, 0.0))
	
	# Sample transitions
	for i = 1:nsteps
		previous_enc_state = enc[end]
		p1_prev = previous_enc_state.plane1
		p2_prev = previous_enc_state.plane2
		
		tsample = rand(transition_model)
		
		p1 = AircraftState(p1_prev.x + p1_prev.u + 0.5 * tsample[:du1],
			 		       p1_prev.y + p1_prev.v + 0.5 * tsample[:dv1],
						   p1_prev.u + tsample[:du1],
						   p1_prev.v + tsample[:dv1])
		
		p2 = AircraftState(p2_prev.x + p2_prev.u + 0.5 * tsample[:du2],
			 		       p2_prev.y + p2_prev.v + 0.5 * tsample[:dv2],
						   p2_prev.u + tsample[:du2],
						   p2_prev.v + tsample[:dv2])
		
		push!(enc, EncounterState(p1, p2, previous_enc_state.t + 1.0))
	end
	return enc
end

# Finds the overall separation between two aircraft
get_separation(state::EncounterState) = hypot(state.plane1.x - state.plane2.x,
                                              state.plane1.y - state.plane2.y)

# Determines what is the minimum separation between the two aircraft
get_min_separation(enc::Encounter) = minimum(get_separation(s) for s in enc) 

find_min_separation(enc::Encounter) = argmin([get_separation(s) for s in enc])

function plot_encounter(enc::Encounter) 
    d = get_min_separation(enc)  # closest dist 
    i = find_min_separation(enc) # index of closest dist

    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = collect(1:length(enc)) .- 1 # time interval
    
    # Gets the x and y values for both planes 
    x1_arr = map(s->s.plane1.x, enc)
    y1_arr = map(s->s.plane1.y, enc)
    x2_arr = map(s->s.plane2.x, enc)
    y2_arr = map(s->s.plane2.y, enc)

    # Plots the trajectories 
    p1 = plot(Vector{Float64}[x1_arr, x2_arr, [enc[i].plane1.x, enc[i].plane2.x]],
              Vector{Float64}[y1_arr, y2_arr, [enc[i].plane1.y, enc[i].plane2.y]],
              xlabel="x [m]", ylabel="y [m]",
		      label=["Plane1" "Plane2" "Min Separation"],
              palette=palette, linewidth=4)
    
    # Plots the point where the minimum separation occurs 
    scatter!(p1, Vector{Float64}[Float64[enc[1].plane1.x],
			 Float64[enc[1].plane2.x]],
		     Vector{Float64}[Float64[enc[1].plane1.y], Float64[enc[1].plane2.y]],
             label=["Plane1 Initial" "Plane2 Initial"])

    plot(p1, size=(600,400))
end