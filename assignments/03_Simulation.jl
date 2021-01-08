### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 740057d4-5072-11eb-0e14-6791a83e8195
using PlutoUI

# ╔═╡ 81758064-5046-11eb-3162-4be4fd413e4e
using BayesNets, LightGraphs, Random, BSON, Discretizers, Distributions, LinearAlgebra

# ╔═╡ 0c5d23e0-5066-11eb-068e-7fbf46e297c4
using Plots; plotly()

# ╔═╡ ee57b148-5055-11eb-14fa-d75faeafeb31
include("support_code/em_support_code.jl")

# ╔═╡ 91ad6858-5045-11eb-3385-e5ba7a7a2d9f
md"""
# Assignment 3: Simulation
"""

# ╔═╡ bc2c5fbc-5045-11eb-1feb-59d8ae410e61
md"""
In order to test the effectiveness of an aircraft collision avoidance system in simulation, we need to simulate the collision avoidance system on a set of realistic airspace encounters. In this assignment, we will focus on developing an encounter set that is representative of the flight data in the [`flights.csv`](http://web.stanford.edu/class/aa120q/data/flights.txt) file we used in the previous assignment and analyzing some statistics of the set.

We have already created the encounter model for you based on the data using a probabilistic modeling technique called Bayesian networks. This assignment will not require any knowledge of the inner workings of Bayesian networks. However, feel free to check out optional lecture notebook on Bayesian networks and the optional "Learning" notebook in assignments to see how the model works if you are interested.
"""

# ╔═╡ dd0bf9b8-5045-11eb-2099-43fa6e4e605c
md"""
## What is Turned In:
Edit the contents of this notebook and turn in your final Pluto notebook file (.jl) to Canvas. Do not use any external code or Julia packages other than those used in the class materials.
"""

# ╔═╡ f5e20428-5045-11eb-0616-4b44a9f806f2
md"""
## Set Up
"""

# ╔═╡ 46336632-506f-11eb-0647-61b5796d2111
md"""
First, let's load in the encounter model and get familiar with it. The file `em_support_code.jl` contains the modeling and plotting tools we will be using.
"""

# ╔═╡ 766d7400-506f-11eb-0510-17524b84ceb2
md"""
Let's take a minute to familiarize ourselves with some of the functions available to us from this file. The file contains an `initial_state_model`, which allows us to sample an initial state for the encounter and a `transition_model`, which allows us to sample accelerations to determine the next state for each aircraft. By sampling from the initial state model at the start of the encounter, we can sample accelerations from the transition model as many times as we like to propagate the encounter forward in time. We have already implemented a function to do this for you called `sample_encounter`:
"""

# ╔═╡ 311774f0-506a-11eb-3547-9bb1ea73c506
enc = sample_encounter(initial_state_model, transition_model)

# ╔═╡ 8e9af8bc-5070-11eb-36eb-a5a4d77e93cb
md"""
We can plot the results using the plotting function we used in the previous assignment.
"""

# ╔═╡ 4fcb0452-506a-11eb-3a7f-edcbbc854ecd
plot_encounter(enc)

# ╔═╡ cc0afada-506b-11eb-3a25-ab4f136a54a5
md"""
## Milestone One: Creating an encounter set
"""

# ╔═╡ 0aec56f2-506e-11eb-3125-33b8df57c7c9
md"""
In order to test a collision avoidance system, we want to have a set of many encounters so that we can see how it performs in a diverse set of scenarios. Your first task is to fill in a function to create an encounter set with a specified number of encounters by repeatedly making calls to the `sample_encounter` function. Your function should return the encounter set as a vector of encounters. 
"""

# ╔═╡ 03180b30-5071-11eb-1b81-9d1e32e41dca
html"""
<h5><font color=crimson>💻 Fill in this function
<code>create_encounter_set(initial_state_model, transition_model, num_encs::Int64)</code></font></h5>
"""

# ╔═╡ 7bd42806-5071-11eb-2dc7-a30af2d936cd
function create_encounter_set(num_encs::Int64)
	enc_set = []
	
	# STUDENT CODE START

	# STUDENT CODE END
	
	return enc_set
end

# ╔═╡ dd3854d2-5071-11eb-24b2-f3df5296f75b
md"""
### Check: 
Let's use the function to create a set of 1,000 encounters.
"""

# ╔═╡ 0d2eec1e-5072-11eb-0f7e-6967494324d7
Random.seed!(1);

# ╔═╡ fa42a514-5071-11eb-2240-d5aae0a6cd0f
encounter_set = create_encounter_set(1_000)

# ╔═╡ 8a794c52-5072-11eb-1559-075bf1d86c55
md"""
Change the number in the box below to flip through the plots of a few of the encounters in the set.
"""

# ╔═╡ 5cd1cfa2-5072-11eb-2b0c-db0e41aeaa94
md"""
Control the encounter number: $(@bind enc_ind NumberField(1:1000, default=1))
"""

# ╔═╡ 2cfc05ea-5072-11eb-029e-31f9af45d159
plot_encounter(encounter_set[enc_ind])

# ╔═╡ aa4f2df6-5072-11eb-30c3-2d52fc0e0072
md"""
## Milestone Two: Plotting the distribution of miss distances
"""

# ╔═╡ e7b5819a-5072-11eb-2ed2-e39a67e4203c
md"""
One metric we might be interested in testing for our encounter model is how close the aircraft come to one another with no collision avoidance system turned on. In other words, we are interested in the distribution of the minimum separation distance among the encounters in our encounter set.

Your next task is to fill in the function `get_miss_distances` to return a vector of the miss distance (meaning minimum separation distance) for each of the encounters in the set. You may find the function `get_min_separation(enc::Encounter)` helpful to you. It has already been loaded in for you to use.
"""

# ╔═╡ 81cba53e-5073-11eb-0e5b-4b1fd9e86bbb
html"""
<h5><font color=crimson>💻 Fill in this function
<code>get_miss_distances(encounter_set::Vector{Encounter})</code></font></h5>
"""

# ╔═╡ 96480fb6-5073-11eb-0bcd-3b877ff5a879
function get_miss_distances(encounter_set::Vector{Encounter})
	miss_distances = []
	
	# STUDENT CODE START

	# STUDENT CODE END
	
	return miss_distances
end

# ╔═╡ cade9ad8-5073-11eb-1590-8778a2baa3c8
md"""
### Check:
Let's plot the a histogram of the miss distances for the encounter set we created.
"""

# ╔═╡ df79c3a0-5073-11eb-1fba-1b8ac9151259
miss_distances = get_miss_distances(encounter_set)

# ╔═╡ 1585febe-5074-11eb-08a0-1f852b60e37c
plot(histogram(miss_distances), ylabel="Number of Encounters", xlabel = "Miss Distance [m]", legend = false)

# ╔═╡ 6d4c7f7e-5074-11eb-1b7a-538a43191a4f
md"""
## Milestone 3: Analyzing Near Midair Collisions (NMACs)
"""

# ╔═╡ 9e480706-5074-11eb-105f-f760a5507576
md"""
A metric typically used to analyze the safety of aircraft collision avoidance systems is the number of near midair collisions (NMACs) that occur with and without it. Ideally, a collision avoidance system will significantly decrease the number of NMACs in an encounter set. **An NMAC is defined as a simultaneous loss of separation to <100ft vertically (our y-direction) and <500ft horizontally (our x-direction).**

Your final task is to analyze the number of NMACs in the encounter set with no collision avoidance (i.e. the number of NMACs in the encounter set as it is currently).
"""

# ╔═╡ 632617f6-5076-11eb-084d-cbefa576587a
md"""
First, complete the following function that determines whether or not a particular encounter state is an NMAC state (<100 **FEET** vertical (y) separation and <500 **FEET** horizontal (x) separation).

Here is a reminder of what the encounter state type looks like, which has been loaded in for you:
```julia
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
```

**Note:** Pay attention to units. The fields in the encounter state are in **METERS**. 1 foot is 0.3048 meters.
"""

# ╔═╡ 89ef897c-5077-11eb-3f00-559f1a5c0576
html"""
<h5><font color=crimson>💻 Fill in this function
<code>is_nmac_state(enc_state::EncounterState)</code></font></h5>
"""

# ╔═╡ 04b987a8-5075-11eb-1952-836f96fa68db
function is_nmac_state(enc_state::EncounterState)
	nmac = false
	
	# STUDENT CODE START

	# STUDENT CODE END
	
	return nmac
end

# ╔═╡ 2275ccb2-5077-11eb-158b-91d8fe4195e1
md"""
We will consider an encounter to be an NMAC if at least one encounter state is an NMAC state. Next, write a function that uses your `is_nmac_state` function to determine if an encounter is an NMAC.
"""

# ╔═╡ 9225ec2e-5077-11eb-076b-c3b4d2898dec
html"""
<h5><font color=crimson>💻 Fill in this function
<code>is_nmac(enc::Encounter)</code></font></h5>
"""

# ╔═╡ 5d459eca-5075-11eb-0ea6-2974b785ae76
function is_nmac(enc::Encounter)
	is_nmac = false
	
	# STUDENT CODE START

	# STUDENT CODE END
	
	return is_nmac
end

# ╔═╡ 9c1f0e4a-5077-11eb-3546-354793b10551
md"""
### Check:
Now, we can see how many NMACs the encounter set contains. You should see a number around 62, meaning 62 of the 1,000 encounters we created contain result in a near midair collision with no collision avoidance system in place.

Number of NMACs:
"""

# ╔═╡ 8b3cecc0-5075-11eb-181f-4b81477f1bbb
sum([is_nmac(enc) for enc in encounter_set])

# ╔═╡ Cell order:
# ╟─91ad6858-5045-11eb-3385-e5ba7a7a2d9f
# ╟─bc2c5fbc-5045-11eb-1feb-59d8ae410e61
# ╟─dd0bf9b8-5045-11eb-2099-43fa6e4e605c
# ╟─f5e20428-5045-11eb-0616-4b44a9f806f2
# ╠═740057d4-5072-11eb-0e14-6791a83e8195
# ╠═81758064-5046-11eb-3162-4be4fd413e4e
# ╠═0c5d23e0-5066-11eb-068e-7fbf46e297c4
# ╟─46336632-506f-11eb-0647-61b5796d2111
# ╠═ee57b148-5055-11eb-14fa-d75faeafeb31
# ╟─766d7400-506f-11eb-0510-17524b84ceb2
# ╠═311774f0-506a-11eb-3547-9bb1ea73c506
# ╟─8e9af8bc-5070-11eb-36eb-a5a4d77e93cb
# ╠═4fcb0452-506a-11eb-3a7f-edcbbc854ecd
# ╟─cc0afada-506b-11eb-3a25-ab4f136a54a5
# ╟─0aec56f2-506e-11eb-3125-33b8df57c7c9
# ╟─03180b30-5071-11eb-1b81-9d1e32e41dca
# ╠═7bd42806-5071-11eb-2dc7-a30af2d936cd
# ╟─dd3854d2-5071-11eb-24b2-f3df5296f75b
# ╠═0d2eec1e-5072-11eb-0f7e-6967494324d7
# ╠═fa42a514-5071-11eb-2240-d5aae0a6cd0f
# ╟─8a794c52-5072-11eb-1559-075bf1d86c55
# ╟─5cd1cfa2-5072-11eb-2b0c-db0e41aeaa94
# ╠═2cfc05ea-5072-11eb-029e-31f9af45d159
# ╟─aa4f2df6-5072-11eb-30c3-2d52fc0e0072
# ╟─e7b5819a-5072-11eb-2ed2-e39a67e4203c
# ╟─81cba53e-5073-11eb-0e5b-4b1fd9e86bbb
# ╠═96480fb6-5073-11eb-0bcd-3b877ff5a879
# ╟─cade9ad8-5073-11eb-1590-8778a2baa3c8
# ╠═df79c3a0-5073-11eb-1fba-1b8ac9151259
# ╠═1585febe-5074-11eb-08a0-1f852b60e37c
# ╟─6d4c7f7e-5074-11eb-1b7a-538a43191a4f
# ╟─9e480706-5074-11eb-105f-f760a5507576
# ╟─632617f6-5076-11eb-084d-cbefa576587a
# ╟─89ef897c-5077-11eb-3f00-559f1a5c0576
# ╠═04b987a8-5075-11eb-1952-836f96fa68db
# ╟─2275ccb2-5077-11eb-158b-91d8fe4195e1
# ╟─9225ec2e-5077-11eb-076b-c3b4d2898dec
# ╠═5d459eca-5075-11eb-0ea6-2974b785ae76
# ╟─9c1f0e4a-5077-11eb-3546-354793b10551
# ╠═8b3cecc0-5075-11eb-181f-4b81477f1bbb
