### A Pluto.jl notebook ###
# v0.20.4

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

# ╔═╡ 8d19fe20-addb-477c-8eee-4c32661bef6e
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ 9d5fd480-f87c-4521-914a-45434090d17b
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

# ╔═╡ 8b2e6846-da3d-4e14-a536-2794906e2af3
begin
	using Base64
	include_string(@__MODULE__, String(base64decode("IyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgojIERFQ09ESU5HIFRISVMgSVMgQSBWSU9MQVRJT04gT0YgVEhFIEhPTk9SIENPREUKIyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgoKZnVuY3Rpb24gZ2V0X21pc3NfZGlzdGFuY2VzKGVuY291bnRlcl9zZXQ6OlZlY3RvcntFbmNvdW50ZXJ9KQoJbWlzc19kaXN0YW5jZXMgPSBbZ2V0X21pbl9zZXBhcmF0aW9uKGVuYykgZm9yIGVuYyBpbiBlbmNvdW50ZXJfc2V0XQoJcmV0dXJuIG1pc3NfZGlzdGFuY2VzCmVuZAoKZnVuY3Rpb24gaXNfbm1hY19zdGF0ZShlbmNfc3RhdGU6OkVuY291bnRlclN0YXRlKQkKCXgxID0gZW5jX3N0YXRlLnBsYW5lMS54Cgl5MSA9IGVuY19zdGF0ZS5wbGFuZTEueQoJeDIgPSBlbmNfc3RhdGUucGxhbmUyLngKCXkyID0gZW5jX3N0YXRlLnBsYW5lMi55CglubWFjID0gYWJzKHgxIC0geDIpIDwgNTAwICogMC4zMDQ4ICYmIGFicyh5MSAtIHkyKSA8IDEwMCAqIDAuMzA0OAoJcmV0dXJuIG5tYWMKZW5kCgpmdW5jdGlvbiBpc19ubWFjKGVuYzo6RW5jb3VudGVyKQoJZm9yIGVuY19zdGF0ZSBpbiBlbmMKICAgICAgICBpZiBpc19ubWFjX3N0YXRlKGVuY19zdGF0ZSkKICAgICAgICAgICAgcmV0dXJuIHRydWUKICAgICAgICBlbmQKICAgIGVuZAogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gX19zaW1wbGVfY2FzKGVuY19zdGF0ZTo6RW5jb3VudGVyU3RhdGUpCglpZiBlbmNfc3RhdGUucGxhbmUxLnkgLSBlbmNfc3RhdGUucGxhbmUyLnkgPiAwCgkJcmV0dXJuIDpDTElNQgogICAgZW5kCiAgICByZXR1cm4gOkRFU0NFTkQKZW5kCgpmdW5jdGlvbiBfX3Jldl9zaW1wbGVfY2FzKGVuY19zdGF0ZTo6RW5jb3VudGVyU3RhdGUpCglpZiBlbmNfc3RhdGUucGxhbmUxLnkgLSBlbmNfc3RhdGUucGxhbmUyLnkgPiAwCgkJcmV0dXJuIDpERVNDRU5ECiAgICBlbmQKICAgIHJldHVybiA6Q0xJTUIKZW5kCgpmdW5jdGlvbiBfX2NvbnN0cmFpbmVkX3NpbXBsZV9DQVMoZW5jX3N0YXRlOjpFbmNvdW50ZXJTdGF0ZSwgdGhyZXNob2xkX2Rpc3Q6OkZsb2F0NjQpCiAgICBpZiBnZXRfc2VwYXJhdGlvbihlbmNfc3RhdGUpIDwgdGhyZXNob2xkX2Rpc3QKICAgICAgICByZXR1cm4gX19zaW1wbGVfY2FzKGVuY19zdGF0ZSkKICAgIGVuZAogICAgcmV0dXJuIDpDT0MKZW5kCg==")))

	get_miss_distances = get_miss_distances
	is_nmac_state = is_nmac_state
	is_name = is_nmac
	__simple_cas = __simple_cas
	__constrained_simple_CAS = __constrained_simple_CAS
	
	md""
end

# ╔═╡ f219a34e-510a-11eb-3366-9f6ad716fb7e
md"""
# Assignment 5: CAS Design
v2025.0.1
"""

# ╔═╡ 72123d2c-9d06-4a1d-b3b3-0621ae082aba
md"## Notebook Setup"

# ╔═╡ 236eb0c4-510b-11eb-1193-d765b686f6e2
md"""
## Problem Description

In the previous assignment, you tested a very simple collision avoidance system and gained some intuition for the challenges that arise in CAS design. Think you can do better than out extremely simple system in the previous assignment? In this assignment, you have the opportunity to test this hypothesis by designing your own collision avoidance logic.
"""

# ╔═╡ f4e98cc8-510b-11eb-19a6-33c9e8f8902b
md"""
## ‼️ What is Turned In
1. Export this notebook as a PDF ([how-to in the documentation](https://plutojl.org/en/docs/export-pdf/))
2. Upload the PDF to [Gradescope](https://www.gradescope.com/)
3. Tag your pages correctly on Gradescope:
   - Tag the page containing Milestone One Check (with the ✅ or ❌) 
   - Tag your written summary for Milestone Three

Once everyone has submitted their assignments, we will create a AA120Q class Pareto curve using the results of everyone's collision avoidance systems!

**Do not use any external code or Julia packages other than those used in the class materials.**
"""

# ╔═╡ 8980758f-fe2b-437f-ae2d-05435da539cf
Markdown.MD(Markdown.Admonition("warning", "Full Credit Requirement", [md"""
For full credit, you must develop a system that improves on the Pareto frontier we explored in Coding Assignment 4: Simple CAS.
"""]))

# ╔═╡ 13cf2970-c746-4d70-9d10-d32124cebb19
md"""
For reference, here is the Pareto frontier of the `constrained_simple_CAS` function across multiple distance thresholds. You can explore the values of the plots using your cursor or inspecting the `pareto_nmacs` and `pareto_alerts` variables.

We have also provided a helper function: `improves_cons_cas_frontier(num_nmacs::Float64, alert_freq::Float64)`. This function takes in the new design point and returns `true` if the point improves the Pareto frontier defined by `constrained_simple_CAS`.
"""

# ╔═╡ 23d15f34-8a2b-406f-b2de-ffff4b0d753e
begin
	pareto_thresholds = [1e5, 1000.0, 700.0, 600.0, 500.0, 450.0, 400.0, 350.0, 300.0, 250.0, 225.0, 200.0, 175.0, 150.0, 125.0, 100.0, 75.0, 50.0, 0.0]
	
	global pareto_nmacs = zeros(length(pareto_thresholds))
	global pareto_alerts = zeros(length(pareto_thresholds))
	
	for (ii, threshold) in enumerate(pareto_thresholds)
		cas_func(x) = __constrained_simple_CAS(x, threshold)
		sim_res = [simulate_encounter(enc, cas_func) for enc in encounter_set]
		pareto_nmacs[ii] = sum(is_nmac(result[1]) for result in sim_res)
		pareto_alerts[ii] = sum(num_alerts(result[2]) for result in sim_res) / (50 * length(sim_res))
	end


	plot(pareto_nmacs, pareto_alerts;
		color=:blue,
		markerstrokecolor=:blue,
		marker=:dot,
		xlabel="Number of NMACS", 
		ylabel="Alert Frequency", 
		legend=false,
		title="Number of NMACS vs Alert Frequency",
		size=(600,400)
	)
end

# ╔═╡ a10ee598-785b-4a7a-9647-298be4147053
md"""Examples  using `improves_cons_cas_frontier`:
"""

# ╔═╡ 88fee228-fd47-44ad-ac17-1f8a05ab365c
md"""
## Available Tools and Supporting Code

All of the provided code for Coding Assignments 02, 03, and 04 are also included here

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

# ╔═╡ 2449bdc6-510c-11eb-0a85-55c19b9c596d
md"""
# 1️⃣ Milestone One: Designing your own CAS

Your first task is to design your own collision avoidance system subject to the following **design constraints**:
1. Your CAS must be a function that takes in an `EncounterState` and outputs an action as a symbol
2. Available actions are:
   - `:COC` - clear of conflict
   - `:CLIMB` - climb at 1500 ft/min
   - `:DESCEND` - descend at 1500 ft/min

Remember that you are only issuing advisories for Plane 1.

## Things to consider:
- We would like you to go through at least a few design iterations (one iteration would be coming up with a design, looking at some of the resulting encounter plots, analyzing the number of NMACs and alerts in the encounter set, and then going back to the design phase for improvements)
- Adding tunable parameters into your design simlar to the `threshold_dist` may help with quick design iterations
- Do we *always* want to climb if the intruder is below us and descend if they are above us? What if we are about to cross in altitude?
- Is a simple distance threshold the best way to decide whether or not to alert? What if we are near one another but our paths are diverging?
- Could projecting the encounter out some time into the future from our current state tell us important information?
"""

# ╔═╡ 27b88648-510e-11eb-2d11-8f4a01ffadd0
md"""
## 💻 Task: Implement `my_cas(enc_state::EncounterState)`

Implement your own collision avoidance system while meeting the above design constraints.
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
# 2️⃣ Milestone Two: Testing Your CAS

Your next task is to analyze the performance of the CAS you designed. We will simulate your encounters on the same encounter set as the previous assignment. We will be looking at three performance metrics:
1. Plots of the encounters simulated with your CAS
2. Number of NMACs
3. Number of alerts (alert frequency)

!!! note
	You do not need to implement any code yourself for this milestone. Instead, we would like you to use the code we have written here to analyze the performance of your CAS. Be sure to look through the encounter plots to gain intuition for how your CAS is working.
"""

# ╔═╡ 2765fe9a-510f-11eb-0217-0fe2c6939c4a
sim_results = [simulate_encounter(enc, my_cas) for enc in encounter_set];

# ╔═╡ 51b3524c-510f-11eb-1fa7-353405e78249
md"""
## Plot the Results
"""

# ╔═╡ c5308938-510f-11eb-10b5-512e04841b45
md"""
Look through some of the plots above to see your CAS in action! 

Plotting all of the encounters can be useful to gain intuition for how your system is working, but sometime we may only be interested in a subset of encounters. For example, if we want to figure out how to get rid of some of the remaining NMACs maybe we should just plot those.

The following plots are only plots of the NMACs.
"""

# ╔═╡ 3840cf86-5111-11eb-3903-e57b77caabcd
nmac_inds = findall([is_nmac(result[1]) for result in sim_results]);

# ╔═╡ e780a34a-5111-11eb-3582-09b3e7d92ed8
md"""
## Calculate Metrics

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

# ╔═╡ 807fed51-7371-4539-8ba5-3a59e8f4d564
md"""
### Metric Summary
"""

# ╔═╡ 7e7555fe-5112-11eb-0e0b-97648b001fad
md"""
## Iterate

Have an idea of what to fix? Go back and try to implement it!

Before turning in the assignment, **make sure to cycle through milestone one and two a few times**!

"""

# ╔═╡ 47d846ea-5114-11eb-0d34-9d77fbc42f6c
md"""
# 3️⃣ Milestone Three: Summary

The last task is to write a few sentences summarizing how the collision avoidance system you designed works. Please be descriptive, but concise. There is no need to write more than 3-5 sentences.
"""

# ╔═╡ 53435de6-5114-11eb-2f59-afe859ec5fd1
md"""
## 💻 Task: Write your summary in the box below
"""

# ╔═╡ e8d86b30-5114-11eb-2c55-e5e0b20bd9ba
md"""
Write your summary here!


"""

# ╔═╡ 93a744d8-d60a-4c06-ba4c-e03c2da705fe
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ 867f6860-85c6-41f5-ab63-9fdeb19b2f58
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

# ╔═╡ e5ea39ab-da14-413b-b450-c8ad5ceb22ac
html_quarter_space()

# ╔═╡ 8168e3ee-ebbf-4af0-83a7-bd3329dcdecd
start_code()

# ╔═╡ 5292c8c8-2494-41d9-9307-7152b4da92c9
end_code()

# ╔═╡ 15531e1a-e2e7-4530-a956-18673b9e28b0
html_half_space()

# ╔═╡ a88f19ca-510f-11eb-1636-47508af9f1fd
md"""
Control the encounter number: $(@bind enc_ind NumberField(1:1000, default=1))
"""

# ╔═╡ aca3e324-510f-11eb-3965-217149ecac94
plot_encounter(sim_results[enc_ind]...)

# ╔═╡ 8f0b2e42-5111-11eb-1b78-45112b031833
md"""
Use the arrow keys to flip between NMACs: $(@bind nmac_ind NumberField(1:length(nmac_inds), default=1))
"""

# ╔═╡ be513084-5111-11eb-3bb9-37acf9f94406
plot_encounter(sim_results[nmac_inds[nmac_ind]]...)

# ╔═╡ 27879802-0b16-4665-a2ef-7fb7ea355620
html_half_space()

# ╔═╡ acfa6318-37b8-471c-a839-d2c9e9f50792
start_code()

# ╔═╡ 93333ad1-0d8c-4b60-9f88-4dac9b246ab6
end_code()

# ╔═╡ 68db1154-9c2b-4983-a2e4-ccd8435ce327
html_half_space()

# ╔═╡ 2200063d-7b94-4ea9-8000-c333bb227057
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

# ╔═╡ fe0d0984-d266-43ee-a7fb-57c5045e550a
function improves_pareto_frontier(x_frontier::Vector{Float64}, y_frontier::Vector{Float64}, new_point::Tuple{Float64, Float64})::Bool
    x_new, y_new = new_point

    # Ensure the frontier is sorted in ascending order of x
    sorted_indices = sortperm(x_frontier)
    x_frontier = x_frontier[sorted_indices]
    y_frontier = y_frontier[sorted_indices]

    # Check if the new point is dominated or not
    for i in 1:(length(x_frontier) - 1)
        x1, y1 = x_frontier[i], y_frontier[i]
        x2, y2 = x_frontier[i + 1], y_frontier[i + 1]

        # Skip if new_point's x is outside the range of the segment
        if x1 <= x_new <= x2
            # Linear interpolation to find the y-coordinate of the frontier at x_new
            y_interp = y1 + (y2 - y1) * (x_new - x1) / (x2 - x1)

            # Check if the new point is below the frontier
            if y_new < y_interp
                return true
            end
        end
    end

    # If the new point is outside the frontier segments
    if x_new < x_frontier[1] && y_new < y_frontier[1]
        return true
    elseif x_new > x_frontier[end] && y_new < y_frontier[end]
        return true
    end

    return false
end;

# ╔═╡ 0e4866e4-05d0-4919-9066-828aecf983ba
function improves_cons_cas_frontier(num_nmacs::Float64, alert_freq::Float64)::Bool
	return improves_pareto_frontier(pareto_nmacs, pareto_alerts, (num_nmacs, alert_freq))
end;

# ╔═╡ fed3aaa8-a63c-446c-9728-96b4301622c3
function improves_cons_cas_frontier(num_nmacs::R, alert_freq::T) where {R<:Real, T<:Real}
    improves_cons_cas_frontier(Float64(num_nmacs), Float64(alert_freq))
end;

# ╔═╡ df340845-d558-420d-ae32-15dd0ac81404
improves_cons_cas_frontier(200.0, 0.25) # true

# ╔═╡ 932023f1-e24c-4161-8b0a-bce3d6bd3c23
improves_cons_cas_frontier(400.0, 0.5) # false

# ╔═╡ 69782162-403d-450c-a8bd-b2462a46830e
begin
    global m1_icon = "❌"
    global milestone_one_pass = false
    
    try
		m1_sim_res = [simulate_encounter(enc, my_cas) for enc in encounter_set]
		m1_nmacs = sum(is_nmac(result[1]) for result in m1_sim_res)
		m1_alerts = sum(num_alerts(result[2]) for result in m1_sim_res) / (50 * length(m1_sim_res))

		if improves_cons_cas_frontier(m1_nmacs, m1_alerts)
            global m1_icon = "✅"
            global milestone_one_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉 Milestone One Full Credit!", [md"""
Your CAS improves the `constrained_simple_CAS` Pareto front!

- Number of NMACS: $m1_nmacs

- Alert Frequency: $m1_alerts
            """]))
		else
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
Your CAS does not outperform constrained simple CAS. The performance of your system is currently falling on or above/right of the constrained simple CAS Pareto front.

For full credit, keep iterating!

- Number of NMACS: $m1_nmacs

- Alert Frequency: $m1_alerts
            """]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""
        There was an error running your code: $err"""]))
    end
end

# ╔═╡ 5288cfd4-ba64-4246-8632-8e4359fcd2ca
md"""
## $(m1_icon) Milestone One Check
"""

# ╔═╡ 36ab1fd0-76ec-44be-b2de-4a942c287a58
if improves_cons_cas_frontier(num_nmacs, alert_freq)
	Markdown.MD(Markdown.Admonition("correct", "", [md"""
	Number of NMACS: $num_nmacs
	
	Alert Frequency: $alert_freq
	"""]))
else
	Markdown.MD(Markdown.Admonition("warning", "", [md"""
	Number of NMACS: $num_nmacs
	
	Alert Frequency: $alert_freq
	"""]))
end

# ╔═╡ ca249df8-1820-4faf-bf3d-63650a31f9ca
PlutoUI.TableOfContents(title="Collision Avoidance System")

# ╔═╡ Cell order:
# ╟─f219a34e-510a-11eb-3366-9f6ad716fb7e
# ╟─72123d2c-9d06-4a1d-b3b3-0621ae082aba
# ╟─8d19fe20-addb-477c-8eee-4c32661bef6e
# ╠═9d5fd480-f87c-4521-914a-45434090d17b
# ╟─236eb0c4-510b-11eb-1193-d765b686f6e2
# ╟─f4e98cc8-510b-11eb-19a6-33c9e8f8902b
# ╟─8980758f-fe2b-437f-ae2d-05435da539cf
# ╟─13cf2970-c746-4d70-9d10-d32124cebb19
# ╟─23d15f34-8a2b-406f-b2de-ffff4b0d753e
# ╟─a10ee598-785b-4a7a-9647-298be4147053
# ╠═df340845-d558-420d-ae32-15dd0ac81404
# ╠═932023f1-e24c-4161-8b0a-bce3d6bd3c23
# ╟─88fee228-fd47-44ad-ac17-1f8a05ab365c
# ╟─e5ea39ab-da14-413b-b450-c8ad5ceb22ac
# ╟─2449bdc6-510c-11eb-0a85-55c19b9c596d
# ╟─27b88648-510e-11eb-2d11-8f4a01ffadd0
# ╟─8168e3ee-ebbf-4af0-83a7-bd3329dcdecd
# ╠═3f3d3a7c-510e-11eb-0d63-67014ac1989e
# ╟─5292c8c8-2494-41d9-9307-7152b4da92c9
# ╟─5288cfd4-ba64-4246-8632-8e4359fcd2ca
# ╟─69782162-403d-450c-a8bd-b2462a46830e
# ╟─15531e1a-e2e7-4530-a956-18673b9e28b0
# ╟─c114119c-510e-11eb-2907-b3e0aca2569e
# ╠═2765fe9a-510f-11eb-0217-0fe2c6939c4a
# ╟─51b3524c-510f-11eb-1fa7-353405e78249
# ╟─a88f19ca-510f-11eb-1636-47508af9f1fd
# ╟─aca3e324-510f-11eb-3965-217149ecac94
# ╟─c5308938-510f-11eb-10b5-512e04841b45
# ╠═3840cf86-5111-11eb-3903-e57b77caabcd
# ╟─8f0b2e42-5111-11eb-1b78-45112b031833
# ╠═be513084-5111-11eb-3bb9-37acf9f94406
# ╟─e780a34a-5111-11eb-3582-09b3e7d92ed8
# ╠═f761d464-5111-11eb-1ef0-c726ae7cbf73
# ╟─005a6090-5112-11eb-386f-9501cd41a86a
# ╠═1dec998c-5112-11eb-1b54-67fdf55f2180
# ╟─807fed51-7371-4539-8ba5-3a59e8f4d564
# ╟─36ab1fd0-76ec-44be-b2de-4a942c287a58
# ╟─7e7555fe-5112-11eb-0e0b-97648b001fad
# ╟─27879802-0b16-4665-a2ef-7fb7ea355620
# ╟─47d846ea-5114-11eb-0d34-9d77fbc42f6c
# ╟─53435de6-5114-11eb-2f59-afe859ec5fd1
# ╟─acfa6318-37b8-471c-a839-d2c9e9f50792
# ╠═e8d86b30-5114-11eb-2c55-e5e0b20bd9ba
# ╟─93333ad1-0d8c-4b60-9f88-4dac9b246ab6
# ╟─68db1154-9c2b-4983-a2e4-ccd8435ce327
# ╟─93a744d8-d60a-4c06-ba4c-e03c2da705fe
# ╟─867f6860-85c6-41f5-ab63-9fdeb19b2f58
# ╟─2200063d-7b94-4ea9-8000-c333bb227057
# ╟─8b2e6846-da3d-4e14-a536-2794906e2af3
# ╟─fe0d0984-d266-43ee-a7fb-57c5045e550a
# ╟─0e4866e4-05d0-4919-9066-828aecf983ba
# ╟─fed3aaa8-a63c-446c-9728-96b4301622c3
# ╟─ca249df8-1820-4faf-bf3d-63650a31f9ca
