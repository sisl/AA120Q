### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ d09528f0-7a28-4bba-bea8-da1c8c36e14f
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ 4b69e4fe-3de8-4b5f-bd8c-0ed007a1369d
begin
	using DataFrames
	using CSV
	using Distributions
	using Plots
	using Discretizers
	using Random
	using BayesNets
	using JLD2
	plotlyjs()

	if !@isdefined HW2_Support_Code
		include("support_code/02_hw_support_code.jl")
	end
	
	if !@isdefined HW3_Support_Code
		include("support_code/03_hw_support_code.jl")
	end
end

# ╔═╡ 4bbd1d4d-2767-41e2-b9de-453468d576e6
begin
	using Base64
	include_string(@__MODULE__, String(base64decode("IyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgojIERFQ09ESU5HIFRISVMgSVMgQSBWSU9MQVRJT04gT0YgVEhFIEhPTk9SIENPREUKIyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgoKZnVuY3Rpb24gX19nZXRfbWlzc19kaXN0YW5jZXMoZW5jb3VudGVyX3NldDo6VmVjdG9ye0VuY291bnRlcn0pCgltaXNzX2Rpc3RhbmNlcyA9IFtnZXRfbWluX3NlcGFyYXRpb24oZW5jKSBmb3IgZW5jIGluIGVuY291bnRlcl9zZXRdCQoJcmV0dXJuIG1pc3NfZGlzdGFuY2VzCmVuZAo=")))

	__get_miss_distances = __get_miss_distances
	
	md""
end

# ╔═╡ 91ad6858-5045-11eb-3385-e5ba7a7a2d9f
md"""
# Assignment 3: Encounter Simulation and Analysis
v2025.0.1
"""

# ╔═╡ 14963911-171a-4d32-aad8-7eb3c573ffc2
md"## Notebook Setup"

# ╔═╡ bc2c5fbc-5045-11eb-1feb-59d8ae410e61
md"""
## Problem Description

Building on our previous work with aircraft encounter models, we now turn to the task of testing collision avoidance systems through simulation. To effectively evaluate such systems, we need a diverse and realistic set of encounter scenarios that represent actual airspace situations.

In this assignment, you will:

1. Generate a collection of simulated aircraft encounters using probabilistic models
2. Analyze the characteristics of these encounters, particularly focusing on safety metrics
3. Study the likelihood and characteristics of near mid-air collisions (NMACs) based on these encounters.

We provide you with a pre-trained Bayesian network model based on the flight data. This model was developed using the same processes from the last coding assignment. Recall that the encounter model consists of two key components:
- An initial state model that generates starting positions and velocities for the aircraft
- A transition model that determines how aircraft states evolve over time

Your task will be to use these models to:
- Create a diverse set of encounter scenarios
- Analyze the distribution of closest approaches between aircraft 
- Develop tools to help us determine potentially dangerous scenarios where aircraft come too close to each other.
"""

# ╔═╡ dd0bf9b8-5045-11eb-2099-43fa6e4e605c
md"""
## ‼️ What is Turned In
1. Export this notebook as a PDF ([how-to in the documentation](https://plutojl.org/en/docs/export-pdf/))
2. Upload the PDF to [Gradescope](https://www.gradescope.com/)
3. Tag your pages correctly on Gradescope:
   - Tag the page containing your checks (with the ✅ or ❌) 

**Do not use any external code or Julia packages other than those used in the class materials.**
"""

# ╔═╡ 7a8500ad-9345-40f4-8296-d8a68a294014
md"""
## Available Tools and Supporting Code

This assignment builds directly on Coding Assignment 2, and we've included all the supporting code and functions from that assignment. Additionally, we've implemented the encounter modeling functions you developed previously.

### Pre-trained Models
Two key models are available for generating encounters:

- `initial_state_model`: Samples initial aircraft positions and velocities
- `transition_model`: Determines how aircraft states evolve over time

### Key Functions
There are functions provided to help with encounter generation. We developed the in the previous coding assignment. Here is a reminder of some of them:

- `encounter_from_init_sample(sampled_init_cond::Dict{Symbol, Any})`
  - Helper function to convert a sampled initial condition into an `EncounterState` type

- `sample_step(model::DiscretizedBayesNet, state::EncounterState)`:
  - Arguments are a transition model and a state
  - Returns the next state in the encounter sequence
  - Handles all the internal model sampling and state updates

- `sample_encounter(initial_state_model::DiscretizedBayesNet, transition_model::DiscretizedBayesNet; kwargs...)`:
  - Arguments are initial state and transition models
  - Returns a complete encounter trajectory
  - Default length is 50 timesteps in addition to the initial state (can be modified via kwargs)
"""

# ╔═╡ af326e38-0040-4b77-acfc-dab6e8a42f30
md"""
## Example
To sample and plot an encounter using the provided funcctions and models, we could use `sample_encounter` with the models and also use `plot_encounter`:
"""

# ╔═╡ 1ff12898-36da-452f-b2cd-29b263c0f250
plot_encounter(sample_encounter(initial_state_model, transition_model))

# ╔═╡ cc0afada-506b-11eb-3a25-ab4f136a54a5
md"""
# 1️⃣ Milestone One: Creating an Encounter Set
"""

# ╔═╡ 0aec56f2-506e-11eb-3125-33b8df57c7c9
md"""
In order to test a collision avoidance system effectively, we need a diverse set of encounter scenarios. Your first task is to implement a function that generates multiple encounters to create a test set.
"""

# ╔═╡ 03180b30-5071-11eb-1b81-9d1e32e41dca
md"""
## 💻 Task: Implement `create_encounter_set(num_encs::Int64)`
"""

# ╔═╡ d7c75c38-b490-4e32-bc0a-1e1c9bc52a66
md"""
Details for this function:
- Input: num_encs::Int64 - The number of encounters to generate
- Output: Vector{Encounter} - A vector containing num_encs independent encounters
- Note: Each encounter in the vector should be sampled independently
"""

# ╔═╡ 7bd42806-5071-11eb-2dc7-a30af2d936cd
function create_encounter_set(num_encs::Int64)
	enc_set = Encounter[] # Initialize an empty Vector{Encounter}
	
	# STUDENT CODE START
	
	# STUDENT CODE END
	
	return enc_set
end

# ╔═╡ f3879afb-4ccf-4d23-8e21-3ebc23b856f0
begin
    global m1_icon = "❌"
    global milestone_one_pass = false
    
    try
        local all_tests_pass = true
        local failure_reason = md""

		m1_num_test = 5
	
		enc_set = create_encounter_set(m1_num_test)

		if isempty(enc_set)
			all_tests_pass = false
			failure_reason = md"The returned encounter set was empty!"
		end
	
		# Check 1: Correct number of encounters
		if all_tests_pass && length(enc_set) != m1_num_test
			all_tests_pass = false
			failure_reason = md"Function should have returned $m1_num_test encounters, but got $(length(enc_set))"
		end
		
		# Check 2: Vector contains Encounter types
		if all_tests_pass && !all(typeof.(enc_set) .<: Vector{EncounterState})
			all_tests_pass = false
			failure_reason = md"All elements should be of type Encounter (Vector{EncounterState})"
		end
		
		# Check 3: Each encounter has 51 timesteps
		if all_tests_pass && !all(length.(enc_set) .== 51)
		    all_tests_pass = false
		    failure_reason = md"Each encounter should have 51 timesteps"
		end
		
		# Check 4: Encounters are different (sample first 3)
		if all_tests_pass
			sample_size = min(3, m1_num_test)
			sample_encs = enc_set[1:sample_size]
			init_states = [enc[1] for enc in sample_encs]
			final_states = [enc[end] for enc in sample_encs]
		end
		
		# Check different initial states
		if all_tests_pass && length(unique(init_states)) != sample_size
		    all_tests_pass = false
		    failure_reason = md"Initial states should be different for different encounters"
		end
		
		# Check different final states
		if all_tests_pass && length(unique(final_states)) != sample_size
		    all_tests_pass = false
		    failure_reason = md"Final states should be different for different encounters"
		end
        
        if all_tests_pass
            global m1_icon = "✅"
            global milestone_one_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""
            Your encounter set generator passes all tests!
            - Creates correct number of encounters
            - Each encounter has correct number of timesteps
            - Encounters are properly sampled (different from each other)
            """]))
        else
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
            $failure_reason

            Make sure your function:
            1. Returns exactly the number of encounters requested
            2. Uses the appropriate function to generate each encounters
            3. Generates independent encounters (don't reuse the same encounter)
            """]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""
        There was an error running your code: $err"""]))
    end
end

# ╔═╡ 99ae977b-80e9-4f8e-9aeb-5e87e2a652d9
md"""
## $(m1_icon) Milestone One Check
"""

# ╔═╡ dd3854d2-5071-11eb-24b2-f3df5296f75b
md"""
## Using Your Function
Let's use the function to create a set of 5 encounters.
"""

# ╔═╡ fa42a514-5071-11eb-2240-d5aae0a6cd0f
test_encounter_set = create_encounter_set(100);

# ╔═╡ 8a794c52-5072-11eb-1559-075bf1d86c55
md"""
Change the number in the box below to flip through the plots of the encounters in the set.
"""

# ╔═╡ aa4f2df6-5072-11eb-30c3-2d52fc0e0072
md"""
# 2️⃣ Milestone Two: Analyzing Miss Distances
"""

# ╔═╡ e7b5819a-5072-11eb-2ed2-e39a67e4203c
md"""
One metric we might be interested in testing for our encounter model is how close the aircraft come to one another with no collision avoidance system turned on. In other words, we are interested in the distribution of the minimum separation distance among the encounters in our encounter set.

For any aircraft encounter, an important safety metric is the minimum separation distance between aircraft during the encounter. We call this the "miss distance" - effectively how close the aircraft came to colliding.

Your task is to implement a function that calculates these miss distances across all encounters in your encounter set. This will help us understand the distribution of close approaches in our simulated scenarios.

#### Helpful Tool
We've provided a helper function to aid your implementation.

- `get_min_separation(enc::Encounter)`: Returns the minimum separation distance (in meters) between aircraft during the encounter.

We have been using this helper function to display the location of the min separation when we have been plotting the encounters.
"""

# ╔═╡ 81cba53e-5073-11eb-0e5b-4b1fd9e86bbb
md"""
## 💻 Task: Implement `get_miss_distances`

This function should:

- Take in a vector of encounters (`Vector{Encounter}`)
- Calculate the miss distance for each encounter using `get_min_separation`
- Return a vector containing all the miss distances

"""

# ╔═╡ 96480fb6-5073-11eb-0bcd-3b877ff5a879
function get_miss_distances(encounter_set::Vector{Encounter})
	miss_distances = [] # Initialize an empty Vector
	
	# STUDENT CODE START
	
	
	# STUDENT CODE END
	
	return miss_distances
end

# ╔═╡ 7d0a77c8-9783-464b-9956-4bc67e6ddc8d
begin
    global m2_icon = "❌"
    global milestone_two_pass = false
    
    try
        # Create small test set of encounters
    	num_test_encounters = 5    
		test_encounters = [sample_encounter(initial_state_model, transition_model) for _ in 1:num_test_encounters]
        
        user_distances = get_miss_distances(test_encounters)

		empty_check = isempty(user_distances)
		type_check = false
		length_check = false
		values_match = false
        
        if !empty_check
			# Check 1: Returns correct type
			type_check = user_distances isa Vector{<:Real}
        
	        # Check 2: Correct length
	        length_check = length(user_distances) == length(test_encounters)
	        
	        # Check 3: Values match reference implementation
			true_distances = __get_miss_distances(test_encounters)
	        if type_check
				values_match = length(user_distances) == length(true_distances) &&
	            	          all(isapprox.(user_distances, true_distances, rtol=1e-10))
			end
				
		end
        
        if type_check && length_check && values_match
            global m2_icon = "✅"
            global milestone_two_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""
            Your miss distance calculator works correctly!
            - Returns vector of correct length
            - All distances properly calculated
            """]))
        else
            msg = md"""Your implementation isn't quite correct."""
            
            if empty_check
				msg = md"""$msg
                
                The returned vector is empty."""
			elseif !type_check
                msg = md"""$msg
                
                Function should return a vector of real numbers."""
            elseif !length_check
                msg = md"""$msg
                
                Length of returned vector ($(length(user_distances))) doesn't match number of encounters ($num_test_encounters)."""
            elseif !values_match
                msg = md"""$msg
                
                Calculated distances don't match expected values. Make sure you're using `get_min_separation` correctly for each encounter."""
            end
            
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [msg]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""
        There was an error running your code: $err"""]))
    end
end

# ╔═╡ 05bf6921-2ade-4aeb-87f5-b1c47bc73d7d
md"""
## $(m2_icon) Milestone Two Check
"""

# ╔═╡ cade9ad8-5073-11eb-1590-8778a2baa3c8
md"""
## Using your function
Let's plot the a histogram of the miss distances for the test encounter set we created in Milestone One.

Note: The following code only runs in both Milestone One and Milestone Two have passed.
"""

# ╔═╡ df79c3a0-5073-11eb-1fba-1b8ac9151259
if milestone_one_pass && milestone_two_pass
	test_miss_distances = get_miss_distances(test_encounter_set)
end

# ╔═╡ 1585febe-5074-11eb-08a0-1f852b60e37c
if milestone_one_pass && milestone_two_pass
	plot(histogram(test_miss_distances), ylabel="Number of Encounters", xlabel = "Miss Distance [m]", legend = false)
end

# ╔═╡ 6d4c7f7e-5074-11eb-1b7a-538a43191a4f
md"""
# 3️⃣ Milestone Three: Analyzing Near Midair Collisions (NMACs)
"""

# ╔═╡ 9e480706-5074-11eb-105f-f760a5507576
md"""
A metric typically used to analyze the safety of aircraft collision avoidance systems is the number of near midair collisions (NMACs) that occur with and without using the system. A collision avoidance system should significantly decrease the number of NMACs in an encounter set. 

**An NMAC is defined as a simultaneous loss of separation to <100ft vertically (our y-direction) and <500ft horizontally (our x-direction).**

Your final task is to analyze the number of NMACs in the encounter set with no collision avoidance system (i.e. the number of NMACs in the encounter set as it is currently). This number helps establish a baseline for evaluating collision avoidance systems.
"""

# ╔═╡ 632617f6-5076-11eb-084d-cbefa576587a
md"""
As a reminder reminder, here is the `AircraftState` and `EncounterState` types, which have been defined and loaded in for you:
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

# ╔═╡ 93072f28-2420-43ce-bf46-adf871c8e643
md"""
## Part 1: Determine if a State is an NMAC
"""

# ╔═╡ 89ef897c-5077-11eb-3f00-559f1a5c0576
md"""
### 💻 Task: Implement `is_nmac_state`

This function takes `enc_state::EncounterState` as an input and returns a `Bool`. We want to return `true` if the state is an NMAC and `false` otherwise.
"""

# ╔═╡ 04b987a8-5075-11eb-1952-836f96fa68db
function is_nmac_state(enc_state::EncounterState)
	nmac = false
	
	# STUDENT CODE START

	
	# STUDENT CODE END

	return nmac
end

# ╔═╡ 6ffaf6ca-9be4-4bc4-9e50-380b93bbf75d
begin
    global m3p1_icon = "❌"
    global milestone_three_part_1_pass = false
    
    try
        # Create test states with different separations
        # Note: Values in meters
        FEET_TO_METERS = 0.3048
        
        # Test cases: Each tuple is (Δx, Δy, expected_result)
        test_cases = [
            # Case 1: Clear NMAC (both separations less than threshold)
            (200 * FEET_TO_METERS, 50 * FEET_TO_METERS, true),
            
            # Case 2: Clear non-NMAC (both separations greater than threshold)
            (600 * FEET_TO_METERS, 150 * FEET_TO_METERS, false),
            
            # Case 3: Edge case - exactly at threshold
            (500 * FEET_TO_METERS, 100 * FEET_TO_METERS, false),
            
            # Case 4: Mixed case - vertical NMAC but horizontal safe
            (600 * FEET_TO_METERS, 50 * FEET_TO_METERS, false),
            
            # Case 5: Mixed case - horizontal NMAC but vertical safe
            (200 * FEET_TO_METERS, 150 * FEET_TO_METERS, false),
            
            # Case 6: Just inside NMAC
            (499 * FEET_TO_METERS, 99 * FEET_TO_METERS, true),

			# Case 7: Edge case - exactly at threshold
            (500 * FEET_TO_METERS, 99 * FEET_TO_METERS, false),

			# Case 8: Edge case - exactly at threshold
            (499 * FEET_TO_METERS, 100 * FEET_TO_METERS, false),
        ]
        
        # Create test states and check results
        results = []
        for (Δx, Δy, expected) in test_cases
            test_state = EncounterState(
                AircraftState(0.0, 0.0, 0.0, 0.0),
                AircraftState(Δx, Δy, 0.0, 0.0),
                0.0
            )
            push!(results, is_nmac_state(test_state) == expected)
        end

		results_xflip = []
		for (Δx, Δy, expected) in test_cases
            test_state = EncounterState(
                AircraftState(Δx, 0.0, 0.0, 0.0),
                AircraftState(0.0, Δy, 0.0, 0.0),
                0.0
            )
            push!(results_xflip, is_nmac_state(test_state) == expected)
        end

		results_yflip = []
		for (Δx, Δy, expected) in test_cases
            test_state = EncounterState(
                AircraftState(0.0, Δy, 0.0, 0.0),
                AircraftState(Δx, 0.0, 0.0, 0.0),
                0.0
            )
            push!(results_yflip, is_nmac_state(test_state) == expected)
        end

		results_bflip = []
		for (Δx, Δy, expected) in test_cases
            test_state = EncounterState(
                AircraftState(Δx, Δy, 0.0, 0.0),
                AircraftState(0.0, 0.0, 0.0, 0.0),
                0.0
            )
            push!(results_bflip, is_nmac_state(test_state) == expected)
        end
		
        
        all_pass = all(results) && all(results_xflip) && all(results_yflip) && all(results_bflip)
        
        if all_pass
            global m3p1_icon = "✅"
            global milestone_three_part_1_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""
            Your NMAC state checker works correctly for all test cases!
            - Correctly identifies NMAC states
            - Properly handles threshold cases
            - Uses correct unit conversions
            """]))
        else
			msg = md"""You correclty determined the NMAC state on $(sum(results) + sum(results_xflip)) of 32 cases tested."""
			
			if all(results) || all(results_xflip) || all(results_yflip) || all(results_bflip)
				msg = md"""$msg
				
				Does the sign of the separation matter? Meaning do we need to consider ``x_2 - x_1`` differently than ``x_1 - x_2``?"""
			end
				
			msg = md"""Your function isn't handling all cases correctly.
			
			$msg
			"""
			
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [msg]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""
        There was an error running your code: $err"""]))
    end
end

# ╔═╡ eac77f67-fa19-4fb3-a1ed-2aabef3a9c96
md"""
### $(m3p1_icon) Milestone Three - Part 1 Check
"""

# ╔═╡ 938c21aa-3916-49b1-a8de-43d11b0f09ac
md"""
## Part 2: Determine if an NMAC Occurs in an Encounter
"""

# ╔═╡ 2275ccb2-5077-11eb-158b-91d8fe4195e1
md"""
The `is_nmac_state` helps us to determine if a current state meets the criteria of a near midair collision. However, we care about the whole encounter. Now we need to implement a function that determines if an entire encounter contains any NMAC states.

Your next task is to write a function that uses your `is_nmac_state` function to determine if an encounter is an NMAC (contains at least one state that meets the NMAC criteria).
"""

# ╔═╡ 9225ec2e-5077-11eb-076b-c3b4d2898dec
md"""
## 💻 Task: Implement `is_nmac`

This function takes an encounter as an input an returns a Boolean indicating if the encounter contains any state meeting the NMAC criteria.

Note: `true` means there is a state that meets the NMAC criteria.
"""

# ╔═╡ 5d459eca-5075-11eb-0ea6-2974b785ae76
function is_nmac(enc::Encounter)
	is_nmac = false
	
	# STUDENT CODE START

	
	# STUDENT CODE END
	
	return is_nmac
end

# ╔═╡ b4d5e4af-0b54-4f01-aef0-2e357035831d


# ╔═╡ f2f49feb-239e-4128-b2c1-6118fb2c9da0
begin
    global m3p2_icon = "❌"
    global milestone_three_part_2_pass = false
    
    try
        # Create test states with known separations
        FEET_TO_METERS = 0.3048
        
        # Safe separation state (600ft horizontal, 150ft vertical)
        safe_state = EncounterState(
            AircraftState(0.0, 0.0, 0.0, 0.0),
            AircraftState(600 * FEET_TO_METERS, 150 * FEET_TO_METERS, 0.0, 0.0),
            0.0
        )
        
        # NMAC state (200ft horizontal, 50ft vertical)
        nmac_state = EncounterState(
            AircraftState(0.0, 0.0, 0.0, 0.0),
            AircraftState(200 * FEET_TO_METERS, 50 * FEET_TO_METERS, 0.0, 0.0),
            0.0
        )
        
        # Test encounters
        test_cases = [
            # Case 1: No NMAC
            (fill(safe_state, 51), false),
            
            # Case 2: NMAC at start
            ([nmac_state; fill(safe_state, 50)], true),
            
            # Case 3: NMAC at end
            ([fill(safe_state, 50); nmac_state], true),
            
            # Case 4: All NMACs
            (fill(nmac_state, 51), true)
        ]
        
        # Check results
        results = []
        for (test_enc, expected) in test_cases
            push!(results, is_nmac(test_enc) == expected)
        end
        
        if all(results)
            global m3p2_icon = "✅"
            global milestone_three_part_2_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""
            Your NMAC encounter checker works correctly!
            """]))
        else
            failed_cases = findall(.!results)
            msg = md"Your function isn't handling all cases correctly."

            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
            $msg
            
            Remember to check every state in the encounter.
            """]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""
        There was an error running your code: $err"""]))
    end
end

# ╔═╡ bf451037-0fe9-4b33-94a0-f6af008ff40a
md"""
### $(m3p2_icon) Milestone Three - Part 2 Check
"""

# ╔═╡ be382d9a-4ee9-4263-a23b-695bac53f47c
begin
	milestone_three_complete = (milestone_three_part_1_pass && milestone_three_part_2_pass)
	if milestone_three_complete
		md"""
		##  ✅ Milestone Three Complete!
		"""
	else
		md"""
		##  ❌ Milestone Three Incomplete!
		"""
	end
end

# ╔═╡ 76857390-4744-4c76-a1d7-ab61f7868ccf
md"""
## Counting NMACs

Now that we have generated a larger set of encounters, let's count how many NMACs we have. We do this with:
```julia
sum([is_nmac(enc) for enc in encounter_set])
```

When the encouner generation is complete, you should see the number of NMACs appear below.
"""

# ╔═╡ bd9a5159-e778-4dc5-990b-7f21ee1e56d5
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ aa474ed6-f9f2-4403-9019-6814138a5abb
begin
	start_code() = html"""
	<div class='container'><div class='line'></div><span class='text' style='color:#B1040E'><b><code>&lt;START CODE&gt;</code></b></span><div class='line'></div></div>
	<p> </p>
	<!-- START_CODE -->
	"""

	end_code() = html"""
	<!-- END CODE -->
	<p><div class='container'><div class='line'></div><span class='text' style='color:#B1040E'><b><code>&lt;END CODE&gt;</code></b></span><div class='line'></div></div></p>
	"""

	function combine_html_md(contents::Vector; return_html=true)
		process(str) = str isa HTML ? str.content : html(str)
		return join(map(process, contents))
	end

	function html_expand(title, content::Markdown.MD)
		return HTML("<details><summary>$title</summary>$(html(content))</details>")
	end

	function html_expand(title, contents::Vector)
		html_code = combine_html_md(contents; return_html=false)
		return HTML("<details><summary>$title</summary>$html_code</details>")
	end

	html_space() = html"<br><br><br><br><br><br><br><br><br><br><br><br><br><br>"
	html_half_space() = html"<br><br><br><br><br><br><br>"
	html_quarter_space() = html"<br><br><br>"

	Bonds = PlutoUI.BuiltinsNotebook.AbstractPlutoDingetjes.Bonds

	struct DarkModeIndicator
		default::Bool
	end
	
	DarkModeIndicator(; default::Bool=false) = DarkModeIndicator(default)

	function Base.show(io::IO, ::MIME"text/html", link::DarkModeIndicator)
		print(io, """
			<span>
			<script>
				const span = currentScript.parentElement
				span.value = window.matchMedia('(prefers-color-scheme: dark)').matches
			</script>
			</span>
		""")
	end

	Base.get(checkbox::DarkModeIndicator) = checkbox.default
	Bonds.initial_value(b::DarkModeIndicator) = b.default
	Bonds.possible_values(b::DarkModeIndicator) = [false, true]
	Bonds.validate_value(b::DarkModeIndicator, val) = val isa Bool
end

# ╔═╡ 58b5ff88-3365-4754-92af-9a71d30c97e7
html_quarter_space()

# ╔═╡ 2a45113a-6526-4a8f-9412-fc378611719e
html_expand("Hint: Creating vectors in Julia", md"""
There are several ways to build your vector of encounters:
```julia
# Method 1: Push to an empty vector
number_set = []
for i in 1:10
    push!(number_set, i)
end

# Method 2: List comprehension
number_set = [i for i in 1:10]

# Method 3: Pre-allocate vector (most efficient)
number_set = Vector{Int64}(undef, 10)
for i in 1:10
    number_set[i] = i
end
```
""")

# ╔═╡ d60370a4-d790-466c-a115-565bf53b38c6
html_expand("Hint: Remember functions from last assignment", md"""
Remember these key functions from Assignment 2:
- `sample_encounter(initial_state_model, transition_model)` generates a single encounter
- Both models (`initial_state_model` and `transition_model`) have already been loaded for you
""")

# ╔═╡ d60e33d2-a1d5-4704-8783-3f91d0ab1b1d
html_expand("Hint: Checking your implementation", md"""
Your implementation should:

- Generate the correct number of encounters
- Have each encounter be independent (different initial conditions and trajectories)
- Return encounters of with 50 timesteps in addition to the initial state

You can check these by:
```julia
# Check number of encounters
length(enc_set) == num_encs

# Check encounter length
length(enc_set[1]) == 51  # 50 timesteps plus initial state

# Check independence
enc_set[1] != enc_set[2]  # Different encounters should have different states
```
""")

# ╔═╡ aa1c8ed2-9689-4e4b-ace7-83e7a611d3a2
start_code()

# ╔═╡ cebaa4f0-9cfd-488e-a51f-ed1f3df1d9ee
end_code()

# ╔═╡ e2d45715-c578-47ee-b0ff-5b3d5035ccdc
html_quarter_space()

# ╔═╡ 5cd1cfa2-5072-11eb-2b0c-db0e41aeaa94
md"""
Control the encounter number: $(@bind enc_ind NumberField(1:100, default=1))
"""

# ╔═╡ a7727f73-c2ea-438e-ad5a-f5a60702bf5d
begin 
	if !isempty(test_encounter_set) 
		plot_encounter(test_encounter_set[enc_ind])
	end
end

# ╔═╡ 42c0d955-6b39-4180-9e00-efb5b6aa3eb3
html_half_space()

# ╔═╡ 75724533-1c74-41c7-bb73-e829941d990c
html_expand("Hint: Using `get_min_separation`", md"""
The `get_min_separation` function calculates the minimum separation distance for a single encounter. Example usage:

```julia
encounter = encounter_set[1]
min_dist = get_min_separation(encounter)  # Returns minimum distance in meters
```
""")

# ╔═╡ 7aaace56-07a8-4545-a9fa-56354b738e8f
html_expand("Hint: Verifying Your Results", md"""
Your results should make sense:

- All miss distances should be positive (can't have negative distance)
- Most encounters should have reasonable separation (100s or 1000s of meters)
- A few encounters might have very close approaches
- Vector length should match number of encounters
""")

# ╔═╡ ea326710-f9f4-4639-a46d-20a86bed13e9
start_code()

# ╔═╡ 5a46f317-9450-4bac-9b27-b09919b96dca
end_code()

# ╔═╡ b0e00b85-38c8-438c-ac66-08258d0faa8c
html_quarter_space()

# ╔═╡ 331ce939-84a3-4395-8466-d076bcb95aeb
html_half_space()

# ╔═╡ 6c26b591-44ff-48b4-a177-a3ed5d72167c
html_expand("Hint: NMAC Definition", md"""
NMAC (Near Mid-Air Collision) occurs when both of these conditions are met:
- Vertical separation (y value) < 100 feet
- Horizontal separation (x value) < 500 feet
""")

# ╔═╡ c6000a54-ecb9-4755-89c7-ff9afd04d88f
html_expand("Hint: Unit Conversions", md"""
Remember the units:

- Aircraft positions in `EncounterState` are in METERS
- NMAC criteria are in FEET
- Conversion: 1 foot = 0.3048 meters
""")

# ╔═╡ 58195836-b9b2-45d5-95dc-38d4e1f629c7
start_code()

# ╔═╡ f0be8ea8-6cb1-4b9c-a743-a19da9d75c05
end_code()

# ╔═╡ 0dc639c2-6f40-436b-a273-4aaf6d32d11c
html_quarter_space()

# ╔═╡ ffd940cb-359e-4c80-abed-bea0f1d8fa6d
html_expand("Hint: When is an encounter an NMAC?", md"""
An encounter is considered an NMAC if any state during the encounter qualifies as an NMAC state.

Example logic:

```julia
	# An encounter with an NMAC
enc_states = [
    state_1,  # not NMAC
    state_2,  # NMAC! 
    state_3,  # not NMAC
    state_4   # not NMAC
]
is_nmac(enc) # should return true (because of state_2)

# An encounter with no NMAC
enc_states = [
    state_1,  # not NMAC
    state_2,  # not NMAC
    state_3,  # not NMAC
    state_4   # not NMAC
]
is_nmac(enc) # should return false (no NMAC states)
```
""")

# ╔═╡ db8d36da-ea34-4956-bf03-dac84b1b8b65
html_expand("Hint: Encounter Data Structure", md"""
Remember that an `Encounter` is just a `Vector{EncounterState}`, so you can iterate through all states in the encounter directly:

```julia
# Given an encounter:
enc::Encounter  # This is a Vector{EncounterState}

# You can iterate through states directly:
for enc_state in enc
	# Do something with the state...
end
```
""")

# ╔═╡ 8852e117-495c-47df-8ac6-c1ba9da07b09
html_half_space()

# ╔═╡ 9c1f0e4a-5077-11eb-3546-354793b10551
md"""
# Analyzing Our Encounter Model

Now we can use the functions to investigate the encounters produced by our encounter models.

## Generating a Large Set of Encounters
Let's first generate a larger encounter set. We recommend approximately 1000 encounters. This might take a while when you run it. For 1000 encounters, it should take approximately 5-10 seconds

To generate the encounter set, 
1. Set this value to the desired encounter number: $(@bind num_enc_to_gen NumberField(100:100:10000, default=1000))
2. Click this box: Ready to Generate: $(@bind generate_set CheckBox(default=false))

To recompute a new encounter set, change the number of encounters or un-check the checkbox and then re-check it.

When the generation is complete, you should see a green box appear stating the generation is complete.
"""

# ╔═╡ d0a5d31a-429b-4f76-99bf-a2b1bdc9c363
if generate_set
	if !milestone_one_pass
		Markdown.MD(Markdown.Admonition("warning", "Not yet!", [md"""
		No need to try and generate the encounters until Milestones One is complete."""]))
	else
		global encounter_set = create_encounter_set(num_enc_to_gen)
		nothing
	end
end

# ╔═╡ 8baeda45-6128-4b64-99f2-ea8a140787e6
if generate_set && milestone_one_pass
	if length(encounter_set) < num_enc_to_gen
		Markdown.MD(Markdown.Admonition("warning", "Generating encounters...", [md"""
			Please be patient."""]))
	else
		Markdown.MD(Markdown.Admonition("correct", "Generation complete!", [md"""
			Your encounters are generated.
			"""]))
	end
end

# ╔═╡ 0a6db372-d4ef-47a3-a647-fbde3ecdf89d
if generate_set
	md"""
	!!! note
		If you are still working on different parts of the assignment, we _highly_ recommend making sure the "Ready to Generate" checkbox is _not_ checked. 
	
		Repeatedly generating the encounters can cause some computation issues. The reactive component of Pluto can cause the cell to re-run even when you don't want to recompute the encounters.
	"""
end

# ╔═╡ 74e42a05-e817-4ae8-8bae-6dd28cbd3f36
begin
	num_nmacs_in_set = -1
	if generate_set && milestone_one_pass && milestone_two_pass && milestone_three_complete
		
		num_nmacs_in_set = sum([is_nmac(enc) for enc in encounter_set])
	
	elseif generate_set && (!milestone_one_pass || !milestone_two_pass || !milestone_three_complete)
		Markdown.MD(Markdown.Admonition("warning", "Not yet!", [md"""
			Waiting on the Milestones to be complete."""]))
	end
	if num_nmacs_in_set > -1
		Markdown.MD(Markdown.Admonition("correct", "", [md"""
		Number of NMACS in the set is $num_nmacs_in_set. 
		
		Our model has an NMAC generation rate of $(round(num_nmacs_in_set / num_enc_to_gen * 100; digits=2)) %.
			"""]))
	end
end

# ╔═╡ e35709df-0f37-4798-9913-5b2209f22e94
html_half_space()

# ╔═╡ 8824a84c-1b8c-4783-ae3c-42824dd0edeb
html"""
	<style>
		h3 {
			border-bottom: 1px dotted var(--rule-color);
		}

		summary {
			font-weight: 500;
			font-style: italic;
		}

		.container {
	      display: flex;
	      align-items: center;
	      width: 100%;
	      margin: 1px 0;
	    }

	    .line {
	      flex: 1;
	      height: 2px;
	      background-color: #B83A4B;
	    }

	    .text {
	      margin: 0 5px;
	      white-space: nowrap; /* Prevents text from wrapping */
	    }

		h2hide {
			border-bottom: 2px dotted var(--rule-color);
			font-size: 1.8rem;
			font-weight: 700;
			margin-bottom: 0.5rem;
			margin-block-start: calc(2rem - var(--pluto-cell-spacing));
		    font-feature-settings: "lnum", "pnum";
		    color: var(--pluto-output-h-color);
		    font-family: Vollkorn, Palatino, Georgia, serif;
		    line-height: 1.25em;
		    margin-block-end: 0;
		    display: block;
		    margin-inline-start: 0px;
		    margin-inline-end: 0px;
		    unicode-bidi: isolate;
		}

		h3hide {
		    border-bottom: 1px dotted var(--rule-color);
			font-size: 1.6rem;
			font-weight: 600;
			color: var(--pluto-output-h-color);
		    font-feature-settings: "lnum", "pnum";
			font-family: Vollkorn, Palatino, Georgia, serif;
		    line-height: 1.25em;
			margin-block-start: 0;
		    margin-block-end: 0;
		    display: block;
		    margin-inline-start: 0px;
		    margin-inline-end: 0px;
		    unicode-bidi: isolate;
		}

		.styled-button {
			background-color: var(--pluto-output-color);
			color: var(--pluto-output-bg-color);
			border: none;
			padding: 10px 20px;
			border-radius: 5px;
			cursor: pointer;
			font-family: Alegreya Sans, Trebuchet MS, sans-serif;
		}
	</style>

	<script>
	const buttons = document.querySelectorAll('input[type="button"]');
	buttons.forEach(button => button.classList.add('styled-button'));
	</script>"""

# ╔═╡ f4030d1a-723c-46e8-af13-d6c8fd0b79da
PlutoUI.TableOfContents(title="Simulation")

# ╔═╡ Cell order:
# ╟─91ad6858-5045-11eb-3385-e5ba7a7a2d9f
# ╟─14963911-171a-4d32-aad8-7eb3c573ffc2
# ╟─d09528f0-7a28-4bba-bea8-da1c8c36e14f
# ╠═4b69e4fe-3de8-4b5f-bd8c-0ed007a1369d
# ╟─bc2c5fbc-5045-11eb-1feb-59d8ae410e61
# ╟─dd0bf9b8-5045-11eb-2099-43fa6e4e605c
# ╟─7a8500ad-9345-40f4-8296-d8a68a294014
# ╟─af326e38-0040-4b77-acfc-dab6e8a42f30
# ╠═1ff12898-36da-452f-b2cd-29b263c0f250
# ╟─58b5ff88-3365-4754-92af-9a71d30c97e7
# ╟─cc0afada-506b-11eb-3a25-ab4f136a54a5
# ╟─0aec56f2-506e-11eb-3125-33b8df57c7c9
# ╟─03180b30-5071-11eb-1b81-9d1e32e41dca
# ╟─d7c75c38-b490-4e32-bc0a-1e1c9bc52a66
# ╟─2a45113a-6526-4a8f-9412-fc378611719e
# ╟─d60370a4-d790-466c-a115-565bf53b38c6
# ╟─d60e33d2-a1d5-4704-8783-3f91d0ab1b1d
# ╟─aa1c8ed2-9689-4e4b-ace7-83e7a611d3a2
# ╠═7bd42806-5071-11eb-2dc7-a30af2d936cd
# ╟─cebaa4f0-9cfd-488e-a51f-ed1f3df1d9ee
# ╟─99ae977b-80e9-4f8e-9aeb-5e87e2a652d9
# ╟─f3879afb-4ccf-4d23-8e21-3ebc23b856f0
# ╟─e2d45715-c578-47ee-b0ff-5b3d5035ccdc
# ╟─dd3854d2-5071-11eb-24b2-f3df5296f75b
# ╠═fa42a514-5071-11eb-2240-d5aae0a6cd0f
# ╟─8a794c52-5072-11eb-1559-075bf1d86c55
# ╟─5cd1cfa2-5072-11eb-2b0c-db0e41aeaa94
# ╟─a7727f73-c2ea-438e-ad5a-f5a60702bf5d
# ╟─42c0d955-6b39-4180-9e00-efb5b6aa3eb3
# ╟─aa4f2df6-5072-11eb-30c3-2d52fc0e0072
# ╟─e7b5819a-5072-11eb-2ed2-e39a67e4203c
# ╟─81cba53e-5073-11eb-0e5b-4b1fd9e86bbb
# ╟─75724533-1c74-41c7-bb73-e829941d990c
# ╟─7aaace56-07a8-4545-a9fa-56354b738e8f
# ╟─ea326710-f9f4-4639-a46d-20a86bed13e9
# ╠═96480fb6-5073-11eb-0bcd-3b877ff5a879
# ╟─5a46f317-9450-4bac-9b27-b09919b96dca
# ╟─05bf6921-2ade-4aeb-87f5-b1c47bc73d7d
# ╟─7d0a77c8-9783-464b-9956-4bc67e6ddc8d
# ╟─b0e00b85-38c8-438c-ac66-08258d0faa8c
# ╟─cade9ad8-5073-11eb-1590-8778a2baa3c8
# ╠═df79c3a0-5073-11eb-1fba-1b8ac9151259
# ╠═1585febe-5074-11eb-08a0-1f852b60e37c
# ╟─331ce939-84a3-4395-8466-d076bcb95aeb
# ╟─6d4c7f7e-5074-11eb-1b7a-538a43191a4f
# ╟─9e480706-5074-11eb-105f-f760a5507576
# ╟─632617f6-5076-11eb-084d-cbefa576587a
# ╟─93072f28-2420-43ce-bf46-adf871c8e643
# ╟─89ef897c-5077-11eb-3f00-559f1a5c0576
# ╟─6c26b591-44ff-48b4-a177-a3ed5d72167c
# ╟─c6000a54-ecb9-4755-89c7-ff9afd04d88f
# ╟─58195836-b9b2-45d5-95dc-38d4e1f629c7
# ╠═04b987a8-5075-11eb-1952-836f96fa68db
# ╟─f0be8ea8-6cb1-4b9c-a743-a19da9d75c05
# ╟─eac77f67-fa19-4fb3-a1ed-2aabef3a9c96
# ╟─6ffaf6ca-9be4-4bc4-9e50-380b93bbf75d
# ╟─0dc639c2-6f40-436b-a273-4aaf6d32d11c
# ╟─938c21aa-3916-49b1-a8de-43d11b0f09ac
# ╟─2275ccb2-5077-11eb-158b-91d8fe4195e1
# ╟─9225ec2e-5077-11eb-076b-c3b4d2898dec
# ╟─ffd940cb-359e-4c80-abed-bea0f1d8fa6d
# ╟─db8d36da-ea34-4956-bf03-dac84b1b8b65
# ╠═5d459eca-5075-11eb-0ea6-2974b785ae76
# ╠═b4d5e4af-0b54-4f01-aef0-2e357035831d
# ╟─bf451037-0fe9-4b33-94a0-f6af008ff40a
# ╟─f2f49feb-239e-4128-b2c1-6118fb2c9da0
# ╟─be382d9a-4ee9-4263-a23b-695bac53f47c
# ╟─8852e117-495c-47df-8ac6-c1ba9da07b09
# ╟─9c1f0e4a-5077-11eb-3546-354793b10551
# ╟─d0a5d31a-429b-4f76-99bf-a2b1bdc9c363
# ╟─8baeda45-6128-4b64-99f2-ea8a140787e6
# ╟─0a6db372-d4ef-47a3-a647-fbde3ecdf89d
# ╟─76857390-4744-4c76-a1d7-ab61f7868ccf
# ╟─74e42a05-e817-4ae8-8bae-6dd28cbd3f36
# ╟─e35709df-0f37-4798-9913-5b2209f22e94
# ╟─bd9a5159-e778-4dc5-990b-7f21ee1e56d5
# ╟─aa474ed6-f9f2-4403-9019-6814138a5abb
# ╟─8824a84c-1b8c-4783-ae3c-42824dd0edeb
# ╟─f4030d1a-723c-46e8-af13-d6c8fd0b79da
# ╟─4bbd1d4d-2767-41e2-b9de-453468d576e6
