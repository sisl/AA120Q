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

# ╔═╡ 7453bdec-510e-11eb-1772-794082d11586
using PlutoUI

# ╔═╡ 7d96ebea-510e-11eb-38fd-33d6d488a90c
using CSV, DataFrames

# ╔═╡ 7f6b4cf6-510e-11eb-0765-e38b675a8faa
using Plots; plotly()

# ╔═╡ 93bd7a06-510e-11eb-1e64-030f5e704d1f
include("support_code/CAS_support_code.jl");

# ╔═╡ f219a34e-510a-11eb-3366-9f6ad716fb7e
md"""
# Assignment 5: CAS Design
"""

# ╔═╡ 236eb0c4-510b-11eb-1193-d765b686f6e2
md"""
In the previous assignment, you tested a very simple collision avoidance system and gained some intuition for the challenges that arise in CAS design. Think you can do better than out extremely simple system in the previous assignment? In this assignment, you have the opportunity to test this hypothesis by designing your own collision avoidance logic.
"""

# ╔═╡ f4e98cc8-510b-11eb-19a6-33c9e8f8902b
md"""
## What is Turned In
Edit the contents of this notebook and turn in your final Pluto notebook file (.jl) to Canvas. Do not use any external code or Julia packages other than those used in the class materials.

Once everyone has submitted their assignments, we will create a AA120Q class Pareto curve using the results of everyone's optimized collision avoidance systems!
"""

# ╔═╡ 5b4d67bc-510e-11eb-32f2-abde2fe44386
md"""
## Setup
Let's import the files and packages we will need for this assignment.
"""

# ╔═╡ 8fdaf6b6-510e-11eb-0bf2-87d8d20e92ec
md"""
We have implemented a number of functions for simulating and visualizing your collision avoidance system for you in the following file.

**Note:** Please do not look at the contents of this file until after you have turned in assignment 3. Doing so before turning in assignment 3 will be considered a
violation of the honor code. However, once you do turn in assignment 3, please feel free to check out the code inside the file if you are interested!
"""

# ╔═╡ 2449bdc6-510c-11eb-0a85-55c19b9c596d
md"""
## Milestone One: Designing your own CAS
Your first task is to design your own collision avoidance system subject to the following **design constraints**:
1. Your CAS must be a function that takes in an `EncounterState` and outputs an action as a symbol
2. Available actions are:
- `:COC` - clear of conflict
- `:CLIMB` - climb at 1500 ft/min
- `:DESCEND` - descend at 1500 ft/min

Here is a reminder of the relevant data types that have been loaded in for you.

```julia
struct AircraftState
    x::Float64  # horizontal position [m]
    y::Float64  # vertical position   [m]
    u::Float64  # horizontal speed    [m/s]
    v::Float64  # vertical speed      [m/s]
end

mutable struct EncounterState
    plane1::AircraftState
    plane2::AircraftState
    t::Float64
end
```

### Things to consider:
- We would like you to go through at least a few design iterations (one iteration would be coming up with a design, looking at some of the resulting encounter plots, analyzing the number of NMACs and alerts in the encounter set, and then going back to the design phase for improvements)
- Adding tunable parameters into your design simlar to the `threshold_dist` may help with quick design iterations
- Do we *always* want to climb if the intruder is below us and descend if they are above us? What if we are about to cross in altitude?
- Is a simple distance threshold the best way to decide whether or not to alert? What if we are near one another but our paths are diverging?
- Could projecting the encounter out some time into the future from our current state tell us important information?
"""

# ╔═╡ 27b88648-510e-11eb-2d11-8f4a01ffadd0
html"""
<h5><font color=crimson>💻 Fill in this function
<code>my_cas(enc_state::EncounterState)</code></font></h5>
"""

# ╔═╡ 3f3d3a7c-510e-11eb-0d63-67014ac1989e
function my_cas(enc_state::EncounterState)
	advisory = :COC # Change this with your code
	
	# STUDENT CODE START

	# STUDENT CODE END
	
	return advisory
end

# ╔═╡ c114119c-510e-11eb-2907-b3e0aca2569e
md"""
## Milestone Two: Testing Your CAS
Your next task is to analyze the performance of the CAS you designed. We will simulate your encounters on the same encounter set as the previous assignment. We will be looking at three performance metrics:
1. Plots of the encounters simulated with your CAS
2. Number of NMACs
3. Number of alerts
**Note:** You do not need to implement any code yourself for this milestone. Instead, we would like you to use the code we have written here to analyze the performance of your CAS. Be sure to flip through the encounter plots to gain some intuition for how your CAS is working.

First, let's simulate your CAS:
"""

# ╔═╡ 2765fe9a-510f-11eb-0217-0fe2c6939c4a
sim_results = [simulate_encounter(enc, my_cas) for enc in encounter_set]

# ╔═╡ 51b3524c-510f-11eb-1fa7-353405e78249
md"""
### Plot the Results
"""

# ╔═╡ a88f19ca-510f-11eb-1636-47508af9f1fd
md"""
Control the encounter number: $(@bind enc_ind NumberField(1:1000, default=1))
"""

# ╔═╡ aca3e324-510f-11eb-3965-217149ecac94
plot_encounter(sim_results[enc_ind]...)

# ╔═╡ c5308938-510f-11eb-10b5-512e04841b45
md"""
Flip through some of the plots above to see your CAS in action! 

Plotting all of the encounters can be useful to gain intuition for how your system is working, but sometime we may only be interested in a subset of encounters. For example, if we want to figure out how to get rid of some of the remaining NMACs maybe we should just plot those. Let's do that next.
"""

# ╔═╡ 3840cf86-5111-11eb-3903-e57b77caabcd
nmac_inds = findall([is_nmac(result[1]) for result in sim_results]);

# ╔═╡ 8f0b2e42-5111-11eb-1b78-45112b031833
md"""
Use the arrow keys to flip between NMACs: $(@bind nmac_ind NumberField(1:length(nmac_inds), default=1))
"""

# ╔═╡ be513084-5111-11eb-3bb9-37acf9f94406
plot_encounter(sim_results[nmac_inds[nmac_ind]]...)

# ╔═╡ d7177882-5111-11eb-3d40-d16da022ea8c
md"""
Have an idea of what to fix? Go back and try to implement it!
"""

# ╔═╡ e780a34a-5111-11eb-3582-09b3e7d92ed8
md"""
### Number of NMACs
"""

# ╔═╡ f761d464-5111-11eb-1ef0-c726ae7cbf73
num_nmacs = length(nmac_inds)

# ╔═╡ 005a6090-5112-11eb-386f-9501cd41a86a
md"""
### Frequency of Alerts
"""

# ╔═╡ 1dec998c-5112-11eb-1b54-67fdf55f2180
alert_freq = sum(num_alerts(result[2]) for result in sim_results) / (50 * length(sim_results))

# ╔═╡ 7e7555fe-5112-11eb-0e0b-97648b001fad
md"""
Before turning in the assignment, **make sure to cycle through milestone one and two a few times**!
"""

# ╔═╡ 47d846ea-5114-11eb-0d34-9d77fbc42f6c
md"""
## Milestone Three: Summarize
Your final task is to write a few sentence (no need to write more than 3-5 sentences) summary of how the collision avoidance system you designed works. 
"""

# ╔═╡ 53435de6-5114-11eb-2f59-afe859ec5fd1
html"""
<h5><font color=crimson>💻 Write your summary in the box below</code></font></h5>
"""

# ╔═╡ e8d86b30-5114-11eb-2c55-e5e0b20bd9ba
md"""
Write your summary here!


"""

# ╔═╡ 93a744d8-d60a-4c06-ba4c-e03c2da705fe
md"""
### You have completed the assignment!
---
"""

# ╔═╡ ca249df8-1820-4faf-bf3d-63650a31f9ca
PlutoUI.TableOfContents(title="Collision Avoidance System")

# ╔═╡ Cell order:
# ╟─f219a34e-510a-11eb-3366-9f6ad716fb7e
# ╟─236eb0c4-510b-11eb-1193-d765b686f6e2
# ╟─f4e98cc8-510b-11eb-19a6-33c9e8f8902b
# ╟─5b4d67bc-510e-11eb-32f2-abde2fe44386
# ╠═7453bdec-510e-11eb-1772-794082d11586
# ╠═7d96ebea-510e-11eb-38fd-33d6d488a90c
# ╠═7f6b4cf6-510e-11eb-0765-e38b675a8faa
# ╟─8fdaf6b6-510e-11eb-0bf2-87d8d20e92ec
# ╠═93bd7a06-510e-11eb-1e64-030f5e704d1f
# ╟─2449bdc6-510c-11eb-0a85-55c19b9c596d
# ╟─27b88648-510e-11eb-2d11-8f4a01ffadd0
# ╠═3f3d3a7c-510e-11eb-0d63-67014ac1989e
# ╟─c114119c-510e-11eb-2907-b3e0aca2569e
# ╠═2765fe9a-510f-11eb-0217-0fe2c6939c4a
# ╟─51b3524c-510f-11eb-1fa7-353405e78249
# ╟─a88f19ca-510f-11eb-1636-47508af9f1fd
# ╠═aca3e324-510f-11eb-3965-217149ecac94
# ╟─c5308938-510f-11eb-10b5-512e04841b45
# ╠═3840cf86-5111-11eb-3903-e57b77caabcd
# ╟─8f0b2e42-5111-11eb-1b78-45112b031833
# ╠═be513084-5111-11eb-3bb9-37acf9f94406
# ╟─d7177882-5111-11eb-3d40-d16da022ea8c
# ╟─e780a34a-5111-11eb-3582-09b3e7d92ed8
# ╠═f761d464-5111-11eb-1ef0-c726ae7cbf73
# ╟─005a6090-5112-11eb-386f-9501cd41a86a
# ╠═1dec998c-5112-11eb-1b54-67fdf55f2180
# ╟─7e7555fe-5112-11eb-0e0b-97648b001fad
# ╟─47d846ea-5114-11eb-0d34-9d77fbc42f6c
# ╟─53435de6-5114-11eb-2f59-afe859ec5fd1
# ╠═e8d86b30-5114-11eb-2c55-e5e0b20bd9ba
# ╟─93a744d8-d60a-4c06-ba4c-e03c2da705fe
# ╠═ca249df8-1820-4faf-bf3d-63650a31f9ca
