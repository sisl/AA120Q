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

# ╔═╡ dad858ae-de03-4281-bc9d-bc2e97c1ae3f
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ 71305d14-2321-4778-9f6e-08374ba8a30c
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

	if !@isdefined HW4_Support_Code
		include("support_code/04_hw_support_code.jl")
	end
end

# ╔═╡ ce134dcd-cea1-444d-a660-4aeb089e8bc3
begin
	using Base64
	include_string(@__MODULE__, String(base64decode("IyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgojIERFQ09ESU5HIFRISVMgSVMgQSBWSU9MQVRJT04gT0YgVEhFIEhPTk9SIENPREUKIyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgoKZnVuY3Rpb24gZ2V0X21pc3NfZGlzdGFuY2VzKGVuY291bnRlcl9zZXQ6OlZlY3RvcntFbmNvdW50ZXJ9KQoJbWlzc19kaXN0YW5jZXMgPSBbZ2V0X21pbl9zZXBhcmF0aW9uKGVuYykgZm9yIGVuYyBpbiBlbmNvdW50ZXJfc2V0XQoJcmV0dXJuIG1pc3NfZGlzdGFuY2VzCmVuZAoKZnVuY3Rpb24gaXNfbm1hY19zdGF0ZShlbmNfc3RhdGU6OkVuY291bnRlclN0YXRlKQkKCXgxID0gZW5jX3N0YXRlLnBsYW5lMS54Cgl5MSA9IGVuY19zdGF0ZS5wbGFuZTEueQoJeDIgPSBlbmNfc3RhdGUucGxhbmUyLngKCXkyID0gZW5jX3N0YXRlLnBsYW5lMi55CglubWFjID0gYWJzKHgxIC0geDIpIDwgNTAwICogMC4zMDQ4ICYmIGFicyh5MSAtIHkyKSA8IDEwMCAqIDAuMzA0OAoJcmV0dXJuIG5tYWMKZW5kCgpmdW5jdGlvbiBpc19ubWFjKGVuYzo6RW5jb3VudGVyKQoJZm9yIGVuY19zdGF0ZSBpbiBlbmMKICAgICAgICBpZiBpc19ubWFjX3N0YXRlKGVuY19zdGF0ZSkKICAgICAgICAgICAgcmV0dXJuIHRydWUKICAgICAgICBlbmQKICAgIGVuZAogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gX19zaW1wbGVfY2FzKGVuY19zdGF0ZTo6RW5jb3VudGVyU3RhdGUpCglpZiBlbmNfc3RhdGUucGxhbmUxLnkgLSBlbmNfc3RhdGUucGxhbmUyLnkgPiAwCgkJcmV0dXJuIDpDTElNQgogICAgZW5kCiAgICByZXR1cm4gOkRFU0NFTkQKZW5kCgpmdW5jdGlvbiBfX3Jldl9zaW1wbGVfY2FzKGVuY19zdGF0ZTo6RW5jb3VudGVyU3RhdGUpCglpZiBlbmNfc3RhdGUucGxhbmUxLnkgLSBlbmNfc3RhdGUucGxhbmUyLnkgPiAwCgkJcmV0dXJuIDpERVNDRU5ECiAgICBlbmQKICAgIHJldHVybiA6Q0xJTUIKZW5kCgpmdW5jdGlvbiBfX2NvbnN0cmFpbmVkX3NpbXBsZV9DQVMoZW5jX3N0YXRlOjpFbmNvdW50ZXJTdGF0ZSwgdGhyZXNob2xkX2Rpc3Q6OkZsb2F0NjQpCiAgICBpZiBnZXRfc2VwYXJhdGlvbihlbmNfc3RhdGUpIDwgdGhyZXNob2xkX2Rpc3QKICAgICAgICByZXR1cm4gX19zaW1wbGVfY2FzKGVuY19zdGF0ZSkKICAgIGVuZAogICAgcmV0dXJuIDpDT0MKZW5kCg==")))

	get_miss_distances = get_miss_distances
	is_nmac_state = is_nmac_state
	is_name = is_nmac
	__simple_cas = __simple_cas
	__rev_simple_cas = __rev_simple_cas
	__constrained_simple_CAS = __constrained_simple_CAS
	
	md""
end

# ╔═╡ 2aae23e4-5078-11eb-321f-fbe32b39f01c
md"""
# Assignment 4: Simple CAS
v2025.0.1
"""

# ╔═╡ fbd332de-9d52-4fa6-8262-8784799e0c74
md"## Notebook Setup"

# ╔═╡ 7b045ab4-5078-11eb-33b9-ab772ff09af9
md"""
## Problem Description

In this assignment, you will implement a simple collision avoidance system (CAS). This process will introduce you to key challenges in developing systems that balance safety and operational efficiency tradeoffs.

"""

# ╔═╡ 08b19b88-5083-11eb-0daa-b5d1c148e2b3
md"""
## ‼️ What is Turned In
1. Export this notebook as a PDF ([how-to in the documentation](https://plutojl.org/en/docs/export-pdf/))
2. Upload the PDF to [Gradescope](https://www.gradescope.com/)
3. Tag your pages correctly on Gradescope:
   - Tag the page containing your checks (with the ✅ or ❌) 

**Do not use any external code or Julia packages other than those used in the class materials.**
"""

# ╔═╡ a7274112-a7ae-4026-a070-a88b1a4d0266
md"""
## Available Tools and Supporting Code

### Code from Earlier Assignments

All of the provided code for Coding Assignments 02 and 03 are also included here. We also have provided implementations of functions you worked on last assignment:
- `get_miss_distances(encounter_set::Vector{Encounter})`: Returns the miss distance for each encounter in the set of encounters. 
- `get_separation(state::EncounterState)`: Returns the distance between the two aircraft (returns the Euclidean distance in meters)
- `is_nmac_state(enc_state::EncounterState)`: Determines if a given `EncounterState` meets the NMAC criteria.
- `is_nmac(enc::Encounter)`: Returns a Boolean indication if the encounter contains any state meeting the NMAC criteria.

### `simulate_encounter`

Another important function we have provided is `simulate_encounter(enc::Encounter, cas_function::Function)`. This function takes in an `Encounter` and a function representing a collision avoidance system (CAS) and returns a tuple of the simulated encounter and a vector of advisories issued during the encounter.

The CAS function must take an `EncounterState` as an input and return a Symbol for the advisory. The CAS system is only for Plane 1 an Plane 2 will always follow its given trajectory in the provided encounter. The CAS must return `:COC`, `:DESCENT`, or `:CLIMB`. See Milestone One for more details on the advisories.

When the CAS function issues an `:CLIMB` or `:DESCEND` advisory, Plane 1 immediately begins climbing or or descending at its commanded rate. Once an advisory is terminated (advisory moves to `:COC` after a `:CLIMB` or `:DESCEND`), Plane 1 immediately maintains its altitude with a verticla rate of 0 m/s.

Reference `03_hw_support_code.jl` for the exact implementation.

### Additional Code and Reminders
Other functions provided:
- `is_alert(advisories::Vector{Symbol})`: Returns `true` if any advisory is other than `:COC`
- `num_alerts(advisories::Vector{Symbol})`: Counds the number of non `:COC` advisories.
- `plot_encounter(enc::Encounter, advisories::Vector{Symbol})`: We extended the plotting function to help us visualize advisories issued by our CAS.


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
"""

# ╔═╡ 805b679c-5083-11eb-37fb-0becdfd29735
md"""
## Encounter Model
Instead of using the generated encounters from last time, we will be evaluating our collision avoidance system on the original encounters contained in the `flights.csv` file (in the AA120Q/data directory). This file is the same file we used to train our encounter model and consists of 1,000 encounters.

If we wanted to simulate more than the 1,000 encounters the file contains, we could create more by sampling from our encounter model and extending our dataset (reference last assignment).
"""

# ╔═╡ 95e9de44-2f85-4975-a476-2de6cf2d89ff
md"""
### NMACs without a CAS
Let's get an idea of the safety of this encounter set with no CAS running by using the `is_nmac` function (a correct implementation has been loaded in for you).
"""

# ╔═╡ 37d81b2c-5084-11eb-0684-35d1f0c9f305
nmacs_no_cas = sum(is_nmac(enc) for enc in encounter_set)

# ╔═╡ 57422818-5084-11eb-3c44-cb5ce3ccbaa8
md"""
**All** of the encounters result in an NMAC!! 

Your goal for the rest of this assignment is to decrease this number as much as possible.
"""

# ╔═╡ 7ea999b8-5084-11eb-291d-f50c50178142
md"""
# 1️⃣ Milestone One: Simple CAS

Our collision avoidance system will be a Julia function that takes in an `EncounterState` and returns a symbol representing one of the following advisories:
- `:COC` - Clear of Conflict (no danger here, continue as planned!)
- `:DESCEND` - Descend at 1500 ft/min
- `:CLIMB` - Climb at 1500 ft/min

For this Milesone, you will implement a simple collision avoidance system. For this system, we want to issue advisories such that: 
- If the other aircraft is below us, climb
- If the other aircraft is above us, descend
- If we are level with the other aircraft, descend
"""

# ╔═╡ f0e8751e-508c-11eb-281d-b941c9bbe457
md"""
## 💻 Task: Implement `simple_cas`

This function takes an `EncounterState` as an input and returns an advisory based on the simple logic described above. This system will act as if you are only controlling Plane 1. Therefore, return advisories for Plane 1.
"""

# ╔═╡ 5e27ff70-507c-11eb-3658-9d6e96f55422
function simple_cas(enc_state::EncounterState)
	advisory = :COC # Change this with your code
	
	# STUDENT CODE START


	# STUDENT CODE END
	
	return advisory
end

# ╔═╡ 6831a572-db62-442a-bae1-9d2eda71cf96
begin
    global m1_icon = "❌"
    global milestone_one_pass = false
    
    try

		m1_num_tests = 1000
		results_m1 = falses(m1_num_tests + 1)
		results_m1_rev = falses(m1_num_tests + 1)

		for ii in 1:m1_num_tests
			ac_1_i = AircraftState((rand(4).-0.5)...)
			ac_2_i = AircraftState((rand(4).-0.5)...)
			t_i = rand(0:50)
			enc_i = EncounterState(ac_1_i, ac_2_i, t_i)

			results_m1[ii] = simple_cas(enc_i) == __simple_cas(enc_i)
			results_m1_rev[ii] = simple_cas(enc_i) == __rev_simple_cas(enc_i)
		end
		
		ac_0 = AircraftState(0.0, 0.0, 0.0, 0.0)
		enc_0 = EncounterState(ac_0, ac_0, 0.0)
		results_m1[end] = simple_cas(enc_0) == :DESCEND
		results_m1_rev[end] = simple_cas(enc_0) == :DESCEND
        
        if all(results_m1)
            global m1_icon = "✅"
            global milestone_one_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""
            Your simple CAS is implemented correctly!
            """]))
		elseif all(results_m1_rev)
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
Your simple CAS doesn't appear to be implemented correctly. 
			
Make sure you are issuing advisories from Plane 1's perspective!
            """]))
		elseif all(results_m1[1:end-1]) && !results_m1[end]
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
Your simple CAS doesn't appear to be implemented correctly.

Check what advisory you issue when the planes are level.
            """]))
		else
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
            Your simple CAS doesn't appear to be implemented correctly.
            """]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""
        There was an error running your code: $err"""]))
    end
end

# ╔═╡ 631fbf88-0fa4-4f41-b8d0-680df34c2c58
md"""
## $(m1_icon) Milestone One Check
"""

# ╔═╡ dde45b22-508c-11eb-04a6-bf0ee25ab2b9
md"""
## Simulating/Analyzing Your Simple CAS

Let's see how this system works!

First, let's simulate our simple collision avoidance system on every encounter in our encounter set and store the results. We will use the `simulate_encounter` function discussed previously.
"""

# ╔═╡ 447331c4-508d-11eb-0242-3781388628b0
sim_results = [simulate_encounter(enc, simple_cas) for enc in encounter_set];

# ╔═╡ 4c3eb9b4-508d-11eb-30b3-05a9ce05ca72
md"""
Next, let's check out our system in action by plotting some of the encounters. Use the box below to look through a few simulated encounters to see your collision avoidance system in action.
"""

# ╔═╡ 70fd6ccc-1ccd-474e-a74b-0e9aadb3cd69


# ╔═╡ c140572c-508d-11eb-1b21-27708685348a
md"""
The performance might look good, but we can gain more insight by looking at metrics as well. 

The new number of NMACs in this set with the collision avoidance system:
"""

# ╔═╡ deb0a104-508d-11eb-1dbe-838cc04dadd0
nmacs_simple_cas = sum(is_nmac(result[1]) for result in sim_results)

# ╔═╡ 112b0e4e-508e-11eb-2a4f-6379eaccc125
md"""
If you implemented your `simple_cas` function correctly, you should have 85 NMACs with your new collision avoidance system. Although simple, this system performs much better than no CAS where we had 1,000 NMACs!

However, safety is not the only metric we care about when we design collision avoidance systems. Let's look at one more metric: the fraction of time steps that the collision avoidance system alerts:
"""

# ╔═╡ fba0844c-508e-11eb-2cc6-e9ee74d945ee
alert_fraction = sum(num_alerts(result[2]) for result in sim_results) / (50 * length(sim_results))

# ╔═╡ 230e1d30-508f-11eb-032b-4d7b4b500d6d
md"""
We alert **100%** of the time! 

This is not desirable from an operational standpoint. If we alert too often, pilots might become desensitized to the alerts and may begin to ignore them. Additionally, ff we continuously alert, then the the plane will be constantly climbing or descending!
"""

# ╔═╡ 6d40e9f0-508f-11eb-2b60-b7f1a3979ca8
md"""
# 2️⃣ Milestone Two: Constrained Simple CAS
One idea to help with the high alert rate is to only alert if the intruding aircraft is within some prespecified distance (let's call it `threshold_dist`) of our own aircraft.
"""

# ╔═╡ c90d0a5c-508f-11eb-2184-812700a01e82
md"""
For this Milestone, you will implement `constrained_simple_CAS`, which introduces a constraint on the simple CAS idea. For this system, we want to issue advisories similar to `simple_CAS`, but not alert (i.e. return `:COC`) when the planes are greater than some threshold distance apart.
"""

# ╔═╡ 945fe46a-5090-11eb-2ab1-f3277039c5e5
md"""
## 💻 Task: Implement `constrained_simple_CAS`

This function takes an `EncounterState` and `threshold_dist::Float64` as inputs and returns an advisory (`:COC`, `:CLIMB`, `:DESCEND`). `threshold_dist` is in meters.

The function should:
- Not alert (return `:COC`) if the separation between the ownship and intruder aircraft is greater than or equal to `threshold_dist`
- If the separation is less than `threshold_dist`, use the same logic as `simple_cas` to determine the advisory

"""

# ╔═╡ 54062a9c-5090-11eb-086f-21ca29736c29
function constrained_simple_CAS(enc_state::EncounterState, threshold_dist::Float64)
	advisory = :COC

	# STUDENT CODE START

	
	# STUDENT CODE END

	return advisory
end

# ╔═╡ 00f835e2-c5f7-4e0f-8fb5-5f63e040dd9b
begin
    global m2_icon = "❌"
    global milestone_two_pass = false
    
    try
		m2_num_tests = 10_000
		results_m2 = falses(m2_num_tests + 1)
		thresh_test = 3_000.0

		for ii in 1:m2_num_tests
			ac_1_i = AircraftState(((rand(4).-0.5).*5_000)...)
			ac_2_i = AircraftState(((rand(4).-0.5).*5_000)...)
			t_i = rand(0:50)
			enc_i = EncounterState(ac_1_i, ac_2_i, t_i)

			results_m2[ii] = constrained_simple_CAS(enc_i, thresh_test) == __constrained_simple_CAS(enc_i, thresh_test)
		end
		
		ac_0 = AircraftState(0.0, 0.0, 0.0, 0.0)
		ac_th = AircraftState(thresh_test, 0.0, 0.0, 0.0)
		enc_0 = EncounterState(ac_0, ac_th, 0.0)
		results_m2[end] = constrained_simple_CAS(enc_0, thresh_test) == __constrained_simple_CAS(enc_0, thresh_test)
        
        if all(results_m2)
            global m2_icon = "✅"
            global milestone_two_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""
            Your constrained simple CAS is implemented correctly!
            """]))
		elseif all(results_m2[1:end-1]) && !results_m2[end]
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
Your constrained simple CAS doesn't appear to be implemented correctly.

Check what advisory you issue when the separation between planes is equal to the threshold distance.
            """]))
		else
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
            Your simple CAS doesn't appear to be implemented correctly.
            """]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""
        There was an error running your code: $err"""]))
    end
end

# ╔═╡ 662ccdf8-27fe-4bab-ab8e-0abc791c45c0
md"""
## $(m2_icon) Milestone Two Check
"""

# ╔═╡ bd06461e-5090-11eb-3e4c-cf4290bec77e
md"""
## Simulating/Analyzing Constrained Simple CAS

Similar to before, we will simulate our constrained simple collision avoidance system on our encounter set and store the results. 

We will start with a value of 500 meters for the `threshold_dist`.

Our `simulate_encounter` function only accepts a CAS function that takes the encounter state as the only input. So let's create a function and set our desired threshold:
"""

# ╔═╡ dfb2b52d-ea7a-4344-a4d6-923b6c6eed1a
constraiend_simple_CAS_500(enc_state::EncounterState) = constrained_simple_CAS(enc_state, 500.0)

# ╔═╡ e30f9d56-5090-11eb-32b3-a99d6ec39c72
sim_results_constrained = [simulate_encounter(enc, constraiend_simple_CAS_500) for enc in encounter_set];

# ╔═╡ b1ff3ebe-5091-11eb-0bea-fde0cd407366
md"""
Let's plot the new results to see if we notice a difference in the alerts.
"""

# ╔═╡ 6377b2ac-5092-11eb-388d-31204864fc3d
md"""
If your implementation is correct, you should see that we no longer alert for the entire duration of every encounter! 

This certainly seems a bit more reasonable. Let's now look at our quantitative metrics for safety (NMACs) and efficiency (alerts).
"""

# ╔═╡ a450a6bc-5092-11eb-19dd-c7d5df824810
nmacs_constrained_cas = sum(is_nmac(result[1]) for result in sim_results_constrained)

# ╔═╡ b4002756-5092-11eb-1231-b127ea9f048b
alert_fraction_constrained = sum(num_alerts(result[2]) for result in sim_results_constrained) / (50 * length(sim_results_constrained))

# ╔═╡ c6b288c4-5092-11eb-1245-b905feea845a
md"""
The alert rate went down! However, the number of NMACs went up. 

This is classic example of the tradeoff between safety and efficiency. Obtaining the right balance for flight-ready collision avoidance systems involves a significant amount of effort. 

In the final portion of this assignment, we will work through one technique engineers use to tackle this problem.
"""

# ╔═╡ 29a7ec06-5095-11eb-2718-6b26fdf66ca1
md"""
# Generating a Pareto Curve
This section foreshadows a more in-depth discussion we will have for during Code Lecture 6: Analysis of Autonomous Systems.


Although we simply chose 500 meters as a test value for our `threshold_dist`, we could have picked any value. We would expect that changing this value will also change our results. For example, if we increase the `threshold_dist` we will likely be safer but alert more often. If we decrease it, we will alert less often but may sacrifice safety.

We can visualize this tradeoff by varying this threshold, running the simulations, and plotting the results. The resulting plot generates a [Pareto curve](https://en.wikipedia.org/wiki/Pareto_principle), which is a tool used frequently in multi-objective optimization problems. 
"""

# ╔═╡ 02ad6616-5096-11eb-1bab-b184c0fbe70a
md"""
The code below gathers data from simulations of different threshold values. The thresholds were chosen to span the range of both very conservative and very aggressive alerting distances.
"""

# ╔═╡ 19235656-5093-11eb-1bd4-911b64580771
begin 
	thresholds = [1e5, 1000.0, 700.0, 600.0, 500.0, 450.0, 400.0, 350.0, 300.0, 250.0, 225.0, 200.0, 175.0, 150.0, 125.0, 100.0, 75.0, 50.0, 0.0]
	nmacs = zeros(length(thresholds))
	alerts = zeros(length(thresholds))

	for (ii, threshold) in enumerate(thresholds)
		cas_func(x) = constrained_simple_CAS(x, threshold)
		sim_res = [simulate_encounter(enc, cas_func) for enc in encounter_set]
		nmacs[ii] = sum(is_nmac(result[1]) for result in sim_res)
		alerts[ii] = sum(num_alerts(result[2]) for result in sim_res) / (50 * length(sim_res))
	end
end

# ╔═╡ 3abb4816-5096-11eb-1d3e-e37937557272
md"""
The Pareto curve is a plot with the performance of the competing objectives on each axis.

In our case we have the number of NMACs along the x-axis and the alert frequency along the y-axis.
"""

# ╔═╡ 5e31d030-5096-11eb-1257-834c5ec9d53c
if milestone_one_pass && milestone_two_pass
	plot(nmacs, alerts;
		color=:blue,
		markerstrokecolor=:blue,
		marker=:dot,
		xlabel="Number of NMACS", 
		ylabel="Alert Frequency", 
		legend=false,
		title="Number of NMACS vs Alert Frequency",
		size=(600,400)
	)
else
	Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
		Complete Milestone One and Milestone Two to generate the plot.
		"""]))
end

# ╔═╡ 96224c88-5096-11eb-2e6f-2d5908c1c245
md"""
Using this plot we can visualize the tradeoff between safety and efficiency as we change our alerting distance threshold.

How do we select what threshold to use? We will discuss this in more detail during Coding Lecture 6: Analysis of Autonomous Systems.
"""

# ╔═╡ e873645c-ad98-480f-aaca-5c004bd9d1c7
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ 768ab4fb-5f69-435a-9358-59e0dc68f946
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

# ╔═╡ d66c8c36-f47d-4173-bcbe-30068675fbbb
html_quarter_space()

# ╔═╡ 408febc2-fb02-43eb-ac15-5722c09f2d94
html_expand("Hint: Symbols in Julia", md"""
[Symbols](https://docs.julialang.org/en/v1/manual/metaprogramming/#Symbols) in Julia are represented by colons followed by a valid identifier.

Examples:

```julia
:this_is_a_symbol
:Another_Symbol
:COC
:DESCEND
:CLIMB
```
""")

# ╔═╡ 03a0f38b-ef50-45c2-893e-974442f5eda3
start_code()

# ╔═╡ ff4838c6-0f8b-4e5c-a31d-7c84d8493ad2
end_code()

# ╔═╡ 9fd4cc5e-5b7e-4fd0-b91f-95705293c49c
html_quarter_space()

# ╔═╡ 8ed3f244-508d-11eb-0ce6-693c50649772
md"""
Control the encounter number: $(@bind enc_ind NumberField(1:1000, default=1))
"""

# ╔═╡ b55dc11c-507f-11eb-094a-fbeb7f6b28a8
plot_encounter(sim_results[enc_ind]...)

# ╔═╡ b417d481-46a7-4702-a0f2-36c4e65f5080
html_half_space()

# ╔═╡ 2915ed7e-7e55-48ce-86da-5a21ef615996
html_expand("Hint: Finding separation distance", md"""
Remember the `get_separation(enc_state::EncounterState)` function has been provided. This function returns the Euclidean distance between the two aircraft for a given state.
""")

# ╔═╡ dfb56918-44fe-48cc-83d7-b559a5c9e64f
html_expand("Hint: Alerting the same as `simple_cas`", md"""
One option is to reimplement the logic of `simple_cas`. Another option, is to use your work developing `simple_cas` in your new function.

You can call functions from within other functions.

For example, let's say we have `some_awesome_function(input1::Type1)` and we want to use it within another function:

```julia
function another_awesome_function(intput1::Type1, input2::Bool)
	if input2
		return some_awesome_function(input1)
	else
		return 42
	end
end
```
""")

# ╔═╡ 468d7423-6e73-46d8-a30b-ad5fcf40448a
start_code()

# ╔═╡ 80b0f408-d66c-45a9-bcf5-8d1d79fb08e6
end_code()

# ╔═╡ f7e7b7fb-f613-4719-9152-5e6bc1340fdd
html_quarter_space()

# ╔═╡ da35150a-5091-11eb-1ded-eb2e605c934e
md"""
Control the encounter number: $(@bind enc_ind_cons NumberField(1:1000, default=1))
"""

# ╔═╡ ef17fd5e-5091-11eb-3907-d7190a3dc1cb
plot_encounter(sim_results_constrained[enc_ind_cons]...)

# ╔═╡ 23e7421b-8180-4cb0-b70f-976544b61b6e
html_half_space()

# ╔═╡ 47b4fbb9-b80e-4b10-b55e-d1340faa7b53
html_half_space()

# ╔═╡ d5407b1e-a117-4115-aed7-139932748c28
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

# ╔═╡ ad1c7a91-ff4b-414d-8f48-ef413326fd87
PlutoUI.TableOfContents(title="Simulation")

# ╔═╡ Cell order:
# ╟─2aae23e4-5078-11eb-321f-fbe32b39f01c
# ╟─fbd332de-9d52-4fa6-8262-8784799e0c74
# ╟─dad858ae-de03-4281-bc9d-bc2e97c1ae3f
# ╠═71305d14-2321-4778-9f6e-08374ba8a30c
# ╟─7b045ab4-5078-11eb-33b9-ab772ff09af9
# ╟─08b19b88-5083-11eb-0daa-b5d1c148e2b3
# ╟─a7274112-a7ae-4026-a070-a88b1a4d0266
# ╟─805b679c-5083-11eb-37fb-0becdfd29735
# ╟─95e9de44-2f85-4975-a476-2de6cf2d89ff
# ╠═37d81b2c-5084-11eb-0684-35d1f0c9f305
# ╟─57422818-5084-11eb-3c44-cb5ce3ccbaa8
# ╟─d66c8c36-f47d-4173-bcbe-30068675fbbb
# ╟─7ea999b8-5084-11eb-291d-f50c50178142
# ╟─f0e8751e-508c-11eb-281d-b941c9bbe457
# ╟─408febc2-fb02-43eb-ac15-5722c09f2d94
# ╟─03a0f38b-ef50-45c2-893e-974442f5eda3
# ╠═5e27ff70-507c-11eb-3658-9d6e96f55422
# ╟─ff4838c6-0f8b-4e5c-a31d-7c84d8493ad2
# ╟─631fbf88-0fa4-4f41-b8d0-680df34c2c58
# ╟─6831a572-db62-442a-bae1-9d2eda71cf96
# ╟─9fd4cc5e-5b7e-4fd0-b91f-95705293c49c
# ╟─dde45b22-508c-11eb-04a6-bf0ee25ab2b9
# ╠═447331c4-508d-11eb-0242-3781388628b0
# ╟─4c3eb9b4-508d-11eb-30b3-05a9ce05ca72
# ╟─8ed3f244-508d-11eb-0ce6-693c50649772
# ╟─b55dc11c-507f-11eb-094a-fbeb7f6b28a8
# ╟─70fd6ccc-1ccd-474e-a74b-0e9aadb3cd69
# ╟─c140572c-508d-11eb-1b21-27708685348a
# ╠═deb0a104-508d-11eb-1dbe-838cc04dadd0
# ╟─112b0e4e-508e-11eb-2a4f-6379eaccc125
# ╠═fba0844c-508e-11eb-2cc6-e9ee74d945ee
# ╟─230e1d30-508f-11eb-032b-4d7b4b500d6d
# ╟─b417d481-46a7-4702-a0f2-36c4e65f5080
# ╟─6d40e9f0-508f-11eb-2b60-b7f1a3979ca8
# ╟─c90d0a5c-508f-11eb-2184-812700a01e82
# ╟─945fe46a-5090-11eb-2ab1-f3277039c5e5
# ╟─2915ed7e-7e55-48ce-86da-5a21ef615996
# ╟─dfb56918-44fe-48cc-83d7-b559a5c9e64f
# ╟─468d7423-6e73-46d8-a30b-ad5fcf40448a
# ╠═54062a9c-5090-11eb-086f-21ca29736c29
# ╟─80b0f408-d66c-45a9-bcf5-8d1d79fb08e6
# ╟─662ccdf8-27fe-4bab-ab8e-0abc791c45c0
# ╟─00f835e2-c5f7-4e0f-8fb5-5f63e040dd9b
# ╟─f7e7b7fb-f613-4719-9152-5e6bc1340fdd
# ╟─bd06461e-5090-11eb-3e4c-cf4290bec77e
# ╠═dfb2b52d-ea7a-4344-a4d6-923b6c6eed1a
# ╠═e30f9d56-5090-11eb-32b3-a99d6ec39c72
# ╟─b1ff3ebe-5091-11eb-0bea-fde0cd407366
# ╟─da35150a-5091-11eb-1ded-eb2e605c934e
# ╟─ef17fd5e-5091-11eb-3907-d7190a3dc1cb
# ╟─6377b2ac-5092-11eb-388d-31204864fc3d
# ╠═a450a6bc-5092-11eb-19dd-c7d5df824810
# ╠═b4002756-5092-11eb-1231-b127ea9f048b
# ╟─c6b288c4-5092-11eb-1245-b905feea845a
# ╟─23e7421b-8180-4cb0-b70f-976544b61b6e
# ╟─29a7ec06-5095-11eb-2718-6b26fdf66ca1
# ╟─02ad6616-5096-11eb-1bab-b184c0fbe70a
# ╠═19235656-5093-11eb-1bd4-911b64580771
# ╟─3abb4816-5096-11eb-1d3e-e37937557272
# ╟─5e31d030-5096-11eb-1257-834c5ec9d53c
# ╟─96224c88-5096-11eb-2e6f-2d5908c1c245
# ╟─47b4fbb9-b80e-4b10-b55e-d1340faa7b53
# ╟─e873645c-ad98-480f-aaca-5c004bd9d1c7
# ╟─768ab4fb-5f69-435a-9358-59e0dc68f946
# ╟─d5407b1e-a117-4115-aed7-139932748c28
# ╟─ad1c7a91-ff4b-414d-8f48-ef413326fd87
# ╟─ce134dcd-cea1-444d-a660-4aeb089e8bc3
