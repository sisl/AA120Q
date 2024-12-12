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

# ╔═╡ 230e916a-507c-11eb-0ad5-fdc194565f6c
using PlutoUI

# ╔═╡ 26baa934-507c-11eb-019e-45e17952f5c5
using CSV, DataFrames

# ╔═╡ 2ff85eba-507c-11eb-282f-593b91749e79
using Plots; plotly()

# ╔═╡ c5b1a014-5078-11eb-083a-6b5ea8795a01
include("support_code/CAS_support_code.jl");

# ╔═╡ 2aae23e4-5078-11eb-321f-fbe32b39f01c
md"""
# Assignment 4: Simple CAS
"""

# ╔═╡ 7b045ab4-5078-11eb-33b9-ab772ff09af9
md"""
In this assignment, you will be implementing a simple collision avoidance system (CAS). Doing so will provide you with an idea of the challenges in creating a collision avoidance system that balances the tradeoffs between safety and operational efficiency.
"""

# ╔═╡ 08b19b88-5083-11eb-0daa-b5d1c148e2b3
md"""
## What is Turned In
Edit the contents of this notebook and turn in your final Pluto notebook file (.jl) to Canvas. Do not use any external code or Julia packages other than those used in the class materials.
"""

# ╔═╡ 0c3444ce-5083-11eb-160d-573b2c6afaaa
md"""
## Setup
"""

# ╔═╡ 3360b1ea-5083-11eb-09d7-6d37c99b65e2
md"""
We have implemented a number of functions for simulating and visualizing your collision avoidance system for you in the following file.

**Note:** Please do not look at the contents of this file until after you have turned in assignment 3. Doing so before turning in assignment 3 will be considered a
violation of the honor code. However, once you do turn in assignment 3, please feel free to check out the code inside the file if you are interested!
"""

# ╔═╡ 805b679c-5083-11eb-37fb-0becdfd29735
md"""
For simplicity, we will be evaluating our collision avoidance system on the original encounters contained in the [`flights.csv`](http://web.stanford.edu/class/aa120q/data/flights.txt) file we have been using in the previous assignments. However, if we wanted to be able to simlulate more than 1,000 encounters and create new encounter scenarios, we would want to develop a statistical encounter model similar to the one we played around with in the previous exercise.

Let's get an idea of the safety of this encounter set with no CAS running by using our `is_nmac` function (a correct implementation has already been loaded in for you). The following line will give us this metric.
"""

# ╔═╡ 37d81b2c-5084-11eb-0684-35d1f0c9f305
nmacs_no_cas = sum(is_nmac(enc) for enc in encounter_set)

# ╔═╡ 57422818-5084-11eb-3c44-cb5ce3ccbaa8
md"""
Looks like all of the encounters result in an NMAC! Your goal for the rest of this assignment is to decrease this number as much as possible.
"""

# ╔═╡ 7ea999b8-5084-11eb-291d-f50c50178142
md"""
## Milestone One: Simple CAS
Our collision avoidance system will be a Julia function that takes in an `EncounterState` and returns an symbol representing one of the following advisories:
- :COC - Clear of Conflict (no danger here, continue as planned!)
- :DESCEND - Descend at 1500 ft/min
- :CLIMB - Climb at 1500 ft/min

Let's first try to implement one of the simpest collision avoidance systems we can come up with: 
- if the other aircraft is below us, climb
- if the other aircraft is above us, descend

Your first task will be to implement `simple_cas`, which performs the function described above. Here is a reminder of the relevant data types that have been loaded in for you.

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

A couple other notes:
- Assume you are plane 1 (you control plane 1)
- The y-coordinate tells you the altitude (look at this to determine above and below)
"""

# ╔═╡ f0e8751e-508c-11eb-281d-b941c9bbe457
html"""
<h5><font color=crimson>💻 Fill in this function
<code>simple_cas(enc_state::EncounterState)</code></font></h5>
"""

# ╔═╡ 5e27ff70-507c-11eb-3658-9d6e96f55422
function simple_cas(enc_state::EncounterState)
	advisory = :COC # Change this with your code
	
	# STUDENT CODE START

	# STUDENT CODE END
	
	return advisory
end

# ╔═╡ dde45b22-508c-11eb-04a6-bf0ee25ab2b9
md"""
### Check
Let's see how this system works. First, let's simulate our simple collision avoidance system on our encounter set and store the results. We have already written a simple simulation function for you that takes in an encounter and a CAS function and returns the results of the simulation. The results are tuples with the first value being the simulated encounter and the second value a vector of the advisories given at each time step.
"""

# ╔═╡ 447331c4-508d-11eb-0242-3781388628b0
sim_results = [simulate_encounter(enc, simple_cas) for enc in encounter_set]

# ╔═╡ 4c3eb9b4-508d-11eb-30b3-05a9ce05ca72
md"""
Next, let's check out our system in action by plotting some of the encounters. We have already loaded in the plotting code for you. Use the box below to flip through a few simulated encounters to see your collision avoidance system in action.
"""

# ╔═╡ 8ed3f244-508d-11eb-0ce6-693c50649772
md"""
Control the encounter number: $(@bind enc_ind NumberField(1:1000, default=1))
"""

# ╔═╡ b55dc11c-507f-11eb-094a-fbeb7f6b28a8
plot_encounter(sim_results[enc_ind]...)

# ╔═╡ c140572c-508d-11eb-1b21-27708685348a
md"""
This looks pretty decent but let's also look at some metrics. First, the new number of NMACs in this set with the collision avoidance system:
"""

# ╔═╡ deb0a104-508d-11eb-1dbe-838cc04dadd0
nmacs_simple_cas = sum(is_nmac(result[1]) for result in sim_results)

# ╔═╡ 112b0e4e-508e-11eb-2a4f-6379eaccc125
md"""
If you implemented your `simple_cas` function correctly, you should have 85 NMACs with your new collision avoidance system. Much better than the 1,000 NMACs we had with no collision avoidance system!

However, safety is not the only metric we care about when we design collision avoidance systems. Let's look at one more metric: the fraction of time steps that the collision avoidance system alerts:
"""

# ╔═╡ fba0844c-508e-11eb-2cc6-e9ee74d945ee
alert_fraction = sum(num_alerts(result[2]) for result in sim_results) / (50 * length(sim_results))

# ╔═╡ 230e1d30-508f-11eb-032b-4d7b4b500d6d
md"""
We alert 100% of the time! This is very much undesirable from an operational standpoint. If we alert too often, pilots will become desensitized to the alerts and may begin to ignore them. If we alert all the time, they will never get to where they were trying to go!

In the next section, we will try to fix this.
"""

# ╔═╡ 6d40e9f0-508f-11eb-2b60-b7f1a3979ca8
md"""
## Milestone Two: Constrained Simple CAS
One simple solution to the alerting problem is to simply only tell the collision avoidance system to alert if the intruding aircraft is within some prespecified distance (let's call it `threshold_dist`) of our own aircraft.
"""

# ╔═╡ c90d0a5c-508f-11eb-2184-812700a01e82
md"""
Your task is to implement a `constrained_simple_CAS` that is able to use a value for `threshold_dist` and output a collision avoidance advisory. Specifically, your function should handle two cases:
1. If the separation between the ownship and intruder aircraft is greater than `threshold_dist`, it should not alert (return `:COC`)
2. If the separation between the ownship and intruder aircraft is less than `threshold_dist`, it should alert in the same manner as `simple_cas` (based on relative altitude)

You may find the `get_separation(enc_state::EncounterState)` function useful, which has been loaded in for you.
"""

# ╔═╡ 945fe46a-5090-11eb-2ab1-f3277039c5e5
html"""
<h5><font color=crimson>💻 Fill in this function
<code>create_simple_cas_constrained(threshold_dist::Float64)</code></font></h5>
"""

# ╔═╡ 54062a9c-5090-11eb-086f-21ca29736c29
function create_simple_cas_constrained(threshold_dist::Float64)
	function simple_cas_constrained(enc_state::EncounterState)
		advisory = :COC # Change this with your code

		# STUDENT CODE START

		# STUDENT CODE END

		return advisory
	end
	return simple_cas_constrained
end

# ╔═╡ bd06461e-5090-11eb-3e4c-cf4290bec77e
md"""
### Check
Let's see how this system works. First, let's simulate our constrained simple collision avoidance system on our encounter set and store the results. We will start with a value of 500 meters for the `threshold_dist`.
"""

# ╔═╡ c5ec8f24-5093-11eb-2556-3f6c979ebdac
simple_cas_cons = create_simple_cas_constrained(500.0)

# ╔═╡ e30f9d56-5090-11eb-32b3-a99d6ec39c72
sim_results_constrained = [simulate_encounter(enc, simple_cas_cons) for enc in encounter_set]

# ╔═╡ b1ff3ebe-5091-11eb-0bea-fde0cd407366
md"""
Let's plot the new results to see if we notice a difference in the alerts.
"""

# ╔═╡ da35150a-5091-11eb-1ded-eb2e605c934e
md"""
Control the encounter number: $(@bind enc_ind_cons NumberField(1:1000, default=1))
"""

# ╔═╡ ef17fd5e-5091-11eb-3907-d7190a3dc1cb
plot_encounter(sim_results_constrained[enc_ind_cons]...)

# ╔═╡ 6377b2ac-5092-11eb-388d-31204864fc3d
md"""
If your implementation is correct, you should see that we no longer alert for the entire duration of every encounter! This certainly seems a bit more reasonable. Let's look at our quantitative metrics for safety (NMACs) and efficiency (alerts).
"""

# ╔═╡ a450a6bc-5092-11eb-19dd-c7d5df824810
nmacs_constrained_cas = sum(is_nmac(result[1]) for result in sim_results_constrained)

# ╔═╡ b4002756-5092-11eb-1231-b127ea9f048b
alert_fraction_constrained = sum(num_alerts(result[2]) for result in sim_results_constrained) / (50 * length(sim_results_constrained))

# ╔═╡ c6b288c4-5092-11eb-1245-b905feea845a
md"""
The alert rate went down! ..but the number of NMACs went up. This is classic example of the tradeoff between safety and efficiency. Obtaining the right balance for flight-ready collision avoidance systems involves a significant amount of effort. In the final portion of this assignment, we will work through one technique engineers use to tackle this problem.
"""

# ╔═╡ 29a7ec06-5095-11eb-2718-6b26fdf66ca1
md"""
## Milestone Three: Generating a Pareto Curve
Although we simply chose 500 meters as a test value for our `threshold_dist`, we would of course expect that changing this value will change our results. For example, if we increase the `threshold_dist` we will likely be safer but alert more often. If we decrease it, we will alert less often but may sacrifice safety.

We can visualize this tradeoff by varying this threshold, running the simulations, and plotting the results. The resulting plot generates a [Pareto curve](https://en.wikipedia.org/wiki/Pareto_principle), which is a tool used frequently in multi-objective optimization problems. 
"""

# ╔═╡ 02ad6616-5096-11eb-1bab-b184c0fbe70a
md"""
The code below gathers data from simulations of five different threshold values.
"""

# ╔═╡ 19235656-5093-11eb-1bd4-911b64580771
thresholds = [1000.0, 500.0, 200.0, 100.0, 50.0];

# ╔═╡ 36711f30-5094-11eb-1444-cfcf1dc0cf92
nmacs = zeros(length(thresholds));

# ╔═╡ 3773608c-5094-11eb-36c3-878d656f5bab
alerts = zeros(length(thresholds));

# ╔═╡ 4507d2ce-5093-11eb-12f8-51e99c090421
for (i,threshold) in enumerate(thresholds)
	cas_func = create_simple_cas_constrained(threshold)
	sim_res = [simulate_encounter(enc, cas_func) for enc in encounter_set]
	nmacs[i] = sum(is_nmac(result[1]) for result in sim_res)
	alerts[i] = sum(num_alerts(result[2]) for result in sim_res) / (50 * length(sim_res))
end

# ╔═╡ 3abb4816-5096-11eb-1d3e-e37937557272
md"""
Your final task is to generate the Pareto curve from the data. Simply create a plot with the data in the NMACs array on the x-axis and the data from the alerts array on the y-axis. Please include axis labels.
"""

# ╔═╡ 286dfd2c-5096-11eb-31f2-878035167af7
html"""
<h5><font color=crimson>💻 Generate the Pareto curve</code></font></h5>
"""

# ╔═╡ 5e31d030-5096-11eb-1257-834c5ec9d53c
# STUDENT CODE START

# STUDENT CODE END

# ╔═╡ 96224c88-5096-11eb-2e6f-2d5908c1c245
md"""
Now, we can easily visualize the tradeoff between safety and efficiency! How do we select a point? We may present this to regulators so that they can decide where on the curve they would like to be based on their preferred balance between safety and efficiency.
"""

# ╔═╡ e873645c-ad98-480f-aaca-5c004bd9d1c7
md"""
### You have completed the assignment!
---
"""

# ╔═╡ 768ab4fb-5f69-435a-9358-59e0dc68f946
PlutoUI.TableOfContents(title="Collision Avoidance System")

# ╔═╡ Cell order:
# ╟─2aae23e4-5078-11eb-321f-fbe32b39f01c
# ╟─7b045ab4-5078-11eb-33b9-ab772ff09af9
# ╟─08b19b88-5083-11eb-0daa-b5d1c148e2b3
# ╟─0c3444ce-5083-11eb-160d-573b2c6afaaa
# ╠═230e916a-507c-11eb-0ad5-fdc194565f6c
# ╠═26baa934-507c-11eb-019e-45e17952f5c5
# ╠═2ff85eba-507c-11eb-282f-593b91749e79
# ╟─3360b1ea-5083-11eb-09d7-6d37c99b65e2
# ╠═c5b1a014-5078-11eb-083a-6b5ea8795a01
# ╟─805b679c-5083-11eb-37fb-0becdfd29735
# ╠═37d81b2c-5084-11eb-0684-35d1f0c9f305
# ╟─57422818-5084-11eb-3c44-cb5ce3ccbaa8
# ╟─7ea999b8-5084-11eb-291d-f50c50178142
# ╟─f0e8751e-508c-11eb-281d-b941c9bbe457
# ╠═5e27ff70-507c-11eb-3658-9d6e96f55422
# ╟─dde45b22-508c-11eb-04a6-bf0ee25ab2b9
# ╠═447331c4-508d-11eb-0242-3781388628b0
# ╟─4c3eb9b4-508d-11eb-30b3-05a9ce05ca72
# ╟─8ed3f244-508d-11eb-0ce6-693c50649772
# ╠═b55dc11c-507f-11eb-094a-fbeb7f6b28a8
# ╟─c140572c-508d-11eb-1b21-27708685348a
# ╠═deb0a104-508d-11eb-1dbe-838cc04dadd0
# ╟─112b0e4e-508e-11eb-2a4f-6379eaccc125
# ╠═fba0844c-508e-11eb-2cc6-e9ee74d945ee
# ╟─230e1d30-508f-11eb-032b-4d7b4b500d6d
# ╟─6d40e9f0-508f-11eb-2b60-b7f1a3979ca8
# ╟─c90d0a5c-508f-11eb-2184-812700a01e82
# ╟─945fe46a-5090-11eb-2ab1-f3277039c5e5
# ╠═54062a9c-5090-11eb-086f-21ca29736c29
# ╟─bd06461e-5090-11eb-3e4c-cf4290bec77e
# ╠═c5ec8f24-5093-11eb-2556-3f6c979ebdac
# ╠═e30f9d56-5090-11eb-32b3-a99d6ec39c72
# ╟─b1ff3ebe-5091-11eb-0bea-fde0cd407366
# ╟─da35150a-5091-11eb-1ded-eb2e605c934e
# ╠═ef17fd5e-5091-11eb-3907-d7190a3dc1cb
# ╟─6377b2ac-5092-11eb-388d-31204864fc3d
# ╠═a450a6bc-5092-11eb-19dd-c7d5df824810
# ╠═b4002756-5092-11eb-1231-b127ea9f048b
# ╟─c6b288c4-5092-11eb-1245-b905feea845a
# ╟─29a7ec06-5095-11eb-2718-6b26fdf66ca1
# ╟─02ad6616-5096-11eb-1bab-b184c0fbe70a
# ╠═19235656-5093-11eb-1bd4-911b64580771
# ╠═36711f30-5094-11eb-1444-cfcf1dc0cf92
# ╠═3773608c-5094-11eb-36c3-878d656f5bab
# ╠═4507d2ce-5093-11eb-12f8-51e99c090421
# ╟─3abb4816-5096-11eb-1d3e-e37937557272
# ╟─286dfd2c-5096-11eb-31f2-878035167af7
# ╠═5e31d030-5096-11eb-1257-834c5ec9d53c
# ╟─96224c88-5096-11eb-2e6f-2d5908c1c245
# ╟─e873645c-ad98-480f-aaca-5c004bd9d1c7
# ╠═768ab4fb-5f69-435a-9358-59e0dc68f946
