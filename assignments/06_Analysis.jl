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

# ╔═╡ 3632a06c-5115-11eb-1be3-8d611f9ce35d
using PlutoUI

# ╔═╡ 442d1b8e-5115-11eb-3c3d-fb492c61b902
using CSV, DataFrames

# ╔═╡ 45f36978-5115-11eb-0540-33937e278f6d
using Plots; plotly()

# ╔═╡ 578b9c82-5115-11eb-2db9-bf97dae1bcdd
include("support_code/CAS_support_code.jl");

# ╔═╡ f3d1a84c-5113-11eb-08a2-938ec13fdcbc
md"""
# Assignment 6: Analysis
"""

# ╔═╡ 298d750e-5114-11eb-3a5b-e72e7dba0b29
md"""
In this assignment, you will look back at the collision avoidance system you designed in the previous assignment and perform some extra analysis.
"""

# ╔═╡ 0ef3bcb4-5115-11eb-385d-dfcaa74621f6
md"""
## What is Turned In
Edit the contents of this notebook and turn in your final Pluto notebook file (.jl) to Canvas. Do not use any external code or Julia packages other than those used in the class materials.
"""

# ╔═╡ 1c3b904c-5115-11eb-0148-93ba4a0c0fe1
md"""
## Setup
Let's import the files and packages we will need for this assignment.
"""

# ╔═╡ 4b41c514-5115-11eb-3283-d1daec5d0d8e
md"""
We have implemented a number of functions for simulating and visualizing your collision avoidance system for you in the following file.

**Note:** Please do not look at the contents of this file until after you have turned in assignment 3. Doing so before turning in assignment 3 will be considered a
violation of the honor code. However, once you do turn in assignment 3, please feel free to check out the code inside the file if you are interested!
"""

# ╔═╡ 66d289f8-5115-11eb-31b8-b53a152f8751
md"""
Let's copy in and resimulate your CAS from the previous assigment so that we have some results to analyze.
"""

# ╔═╡ 88e155d8-5115-11eb-02ce-ffb1001a025d
html"""
<h5><font color=crimson>💻 Copy in your function
<code>my_cas(enc_state::EncounterState)</code></font></h5>
"""

# ╔═╡ 9ab41aa2-5115-11eb-0e52-cfb017fa7f30
function my_cas(enc_state::EncounterState)
	advisory = :COC # Change this with your code
	
	# STUDENT CODE START

	# STUDENT CODE END
	
	return advisory
end

# ╔═╡ a3c2e22c-5115-11eb-0094-f9c26abc6eec
sim_results = [simulate_encounter(enc, my_cas) for enc in encounter_set]

# ╔═╡ ac1a33a0-5115-11eb-04e6-473cd31d90e0
md"""
## Milestone One: Analyzing Encounter Plots
An important debugging tool for understanding the strengths and weaknesses of your collision avoidance system are the encounter plot. Your first task will be to select three "interesting" encounters from the set of encounters simulated with your collision avoidance system and describe what you see happening in each. "Interesting" encounters may include times where you think your system is working particularly well, encounters that result in an NMAC, etc.

We have plotted all of your results for you below so you can flip through and note the indices of the encounters you would like to highlight.
"""

# ╔═╡ 4dd4b218-5116-11eb-10c0-8d575804e4bd
md"""
Control the encounter number: $(@bind enc_ind NumberField(1:1000, default=1))
"""

# ╔═╡ 57e82972-5116-11eb-321a-4b468f1674d1
plot_encounter(sim_results[enc_ind]...)

# ╔═╡ 627ab28a-5116-11eb-2a3f-4335dedc5be3
html"""
<h5><font color=crimson>💻 Fill in the indices of the encounters you would like to highlight by changing the values below</code></font></h5>
"""

# ╔═╡ 80c67666-5116-11eb-1327-ad61869eae97
# STUDENT CODE START
begin
	highlight_index_1 = 1 # Change this value!!!
	highlight_index_2 = 2 # Change this value!!!
	highlight_index_3 = 3 # Change this value!!!
end
# STUDENT CODE END

# ╔═╡ d5d34f9e-5116-11eb-0d99-df402ecd48ce
md"""
Your three encounters should now appear below. Below each plot you will be asked to write a description of what your CAS is doing in the encounter (1-2 sentences is fine).
"""

# ╔═╡ f872cb06-5116-11eb-2a10-8d370af59754
plot_encounter(sim_results[highlight_index_1]...)

# ╔═╡ 0de189be-5117-11eb-1199-3d478dfcb705
html"""
<h5><font color=crimson>💻 Write your description of your first highlighted encounter in the box below.</code></font></h5>
"""

# ╔═╡ 3e1d90be-5117-11eb-2ef1-3928b154f9ea
md"""
Write your summary here!

"""

# ╔═╡ f97094f2-5116-11eb-143f-9fba4377f713
plot_encounter(sim_results[highlight_index_2]...)

# ╔═╡ 327609ce-5117-11eb-1031-c3a88dc0869b
html"""
<h5><font color=crimson>💻 Write your description of your second highlighted encounter in the box below.</code></font></h5>
"""

# ╔═╡ 44de014a-5117-11eb-0ef5-bf5137132a88
md"""
Write your summary here!

"""

# ╔═╡ fa38e4f2-5116-11eb-0f88-f9af477959f5
plot_encounter(sim_results[highlight_index_3]...)

# ╔═╡ 38a390f2-5117-11eb-3607-19028d7c0157
html"""
<h5><font color=crimson>💻 Write your description of your third highlighted encounter in the box below.</code></font></h5>
"""

# ╔═╡ 47059438-5117-11eb-3b69-3d9687e5922a
md"""
Write your summary here!

"""

# ╔═╡ 49ca25d0-5117-11eb-213f-cb761b37d5b5
md"""
## Milestone Two: Other Metrics and Tests
We have come pretty far since we first set out to design a collision avoidance system in assignment 2! We now have a fully working system with a few design iterations and some analysis behind us. Of course, there is much more work to be done if this were ever to become a viable collision avoidance system that can be deployed in our airspace. ACAS X took over a decade of development effort to be accepted as an international standard!

Of couse, we don't have that kind of time in AA120Q, so we will just brainstorm what else we would need to do to continue to test and improve our system. In your final task, we will ask you to answer two questions. 

First, **what other metrics should we be considering?** NMACs and alerts were a good start, but they certainly do not paint the entire pictures. For example, what if we find out that our CAS is reversing its advisory from climb to descend and then back to climb every second. This would certainly be undesirable behavior, but it would not be captured in our current metrics. Thus, we may want to add a metric that captures the number of reversals that occur in the encounter set. What else should we add?
"""

# ╔═╡ 99a254d2-5118-11eb-0ca1-7501ea254a28
html"""
<h5><font color=crimson>💻 Write 3-4 sentences about other metrics that we may consider when designing a CAS in the box below.</code></font></h5>
"""

# ╔═╡ c1e61a14-5118-11eb-16ab-eb980f555c5c
md"""
Write your summary here!

"""

# ╔═╡ c8d5318c-5118-11eb-0e9b-d54734bf2b2b
md"""
Second, **what other tests should we run?** We have been testing our CAS by running simulations on encounters from a specific set of 1,000 encounters that all result in NMACs. Clearly, we cannot tell how our system would perform throughout the entire airspace with just this set. For example, it is missing the ability to identify *induced NMACs*, or NMACs that occur with our CAS that would not have occured without a CAS. If we only test on NMAC encounters, we will never find these. Thus, we should test on an encounter set in which some of the encounters do not result in NMACs nominally. What other tests should we run? Think about things we have not taken into account in our simulation (e.g. what if we have noisy sensors?).
"""

# ╔═╡ b0e4c16a-5119-11eb-1aa7-513244ba1a7d
html"""
<h5><font color=crimson>💻 Write 3-4 sentences about other tests that we may run when designing a CAS in the box below.</code></font></h5>
"""

# ╔═╡ bda9d58e-5119-11eb-3192-1786a830c084
md"""
Write your summary here!

"""

# ╔═╡ d91245fe-5119-11eb-3c29-516d33c9525f
md"""
---
> **Congrats! You have completed the Pluto portion of the AA120Q assignments!**
"""

# ╔═╡ 7d61000f-d6c4-4181-bcd6-06b7589fdc26
PlutoUI.TableOfContents(title="Analysis")

# ╔═╡ Cell order:
# ╟─f3d1a84c-5113-11eb-08a2-938ec13fdcbc
# ╟─298d750e-5114-11eb-3a5b-e72e7dba0b29
# ╟─0ef3bcb4-5115-11eb-385d-dfcaa74621f6
# ╟─1c3b904c-5115-11eb-0148-93ba4a0c0fe1
# ╠═3632a06c-5115-11eb-1be3-8d611f9ce35d
# ╠═442d1b8e-5115-11eb-3c3d-fb492c61b902
# ╠═45f36978-5115-11eb-0540-33937e278f6d
# ╟─4b41c514-5115-11eb-3283-d1daec5d0d8e
# ╠═578b9c82-5115-11eb-2db9-bf97dae1bcdd
# ╟─66d289f8-5115-11eb-31b8-b53a152f8751
# ╟─88e155d8-5115-11eb-02ce-ffb1001a025d
# ╠═9ab41aa2-5115-11eb-0e52-cfb017fa7f30
# ╠═a3c2e22c-5115-11eb-0094-f9c26abc6eec
# ╟─ac1a33a0-5115-11eb-04e6-473cd31d90e0
# ╟─4dd4b218-5116-11eb-10c0-8d575804e4bd
# ╠═57e82972-5116-11eb-321a-4b468f1674d1
# ╟─627ab28a-5116-11eb-2a3f-4335dedc5be3
# ╠═80c67666-5116-11eb-1327-ad61869eae97
# ╟─d5d34f9e-5116-11eb-0d99-df402ecd48ce
# ╠═f872cb06-5116-11eb-2a10-8d370af59754
# ╟─0de189be-5117-11eb-1199-3d478dfcb705
# ╠═3e1d90be-5117-11eb-2ef1-3928b154f9ea
# ╠═f97094f2-5116-11eb-143f-9fba4377f713
# ╟─327609ce-5117-11eb-1031-c3a88dc0869b
# ╠═44de014a-5117-11eb-0ef5-bf5137132a88
# ╠═fa38e4f2-5116-11eb-0f88-f9af477959f5
# ╟─38a390f2-5117-11eb-3607-19028d7c0157
# ╠═47059438-5117-11eb-3b69-3d9687e5922a
# ╟─49ca25d0-5117-11eb-213f-cb761b37d5b5
# ╟─99a254d2-5118-11eb-0ca1-7501ea254a28
# ╠═c1e61a14-5118-11eb-16ab-eb980f555c5c
# ╟─c8d5318c-5118-11eb-0e9b-d54734bf2b2b
# ╟─b0e4c16a-5119-11eb-1aa7-513244ba1a7d
# ╠═bda9d58e-5119-11eb-3192-1786a830c084
# ╟─d91245fe-5119-11eb-3c29-516d33c9525f
# ╠═7d61000f-d6c4-4181-bcd6-06b7589fdc26
