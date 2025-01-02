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

# ╔═╡ b4270d0f-a316-4781-a340-f6ec54f35a1b
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ 535c0573-63d1-464a-9780-3bd0e40e15d2
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

# ╔═╡ e2ad2cdf-c8ab-4e35-b6c0-724ebe9ec32b
begin
	using Base64
	include_string(@__MODULE__, String(base64decode("IyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgojIERFQ09ESU5HIFRISVMgSVMgQSBWSU9MQVRJT04gT0YgVEhFIEhPTk9SIENPREUKIyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgoKZnVuY3Rpb24gZ2V0X21pc3NfZGlzdGFuY2VzKGVuY291bnRlcl9zZXQ6OlZlY3RvcntFbmNvdW50ZXJ9KQoJbWlzc19kaXN0YW5jZXMgPSBbZ2V0X21pbl9zZXBhcmF0aW9uKGVuYykgZm9yIGVuYyBpbiBlbmNvdW50ZXJfc2V0XQoJcmV0dXJuIG1pc3NfZGlzdGFuY2VzCmVuZAoKZnVuY3Rpb24gaXNfbm1hY19zdGF0ZShlbmNfc3RhdGU6OkVuY291bnRlclN0YXRlKQkKCXgxID0gZW5jX3N0YXRlLnBsYW5lMS54Cgl5MSA9IGVuY19zdGF0ZS5wbGFuZTEueQoJeDIgPSBlbmNfc3RhdGUucGxhbmUyLngKCXkyID0gZW5jX3N0YXRlLnBsYW5lMi55CglubWFjID0gYWJzKHgxIC0geDIpIDwgNTAwICogMC4zMDQ4ICYmIGFicyh5MSAtIHkyKSA8IDEwMCAqIDAuMzA0OAoJcmV0dXJuIG5tYWMKZW5kCgpmdW5jdGlvbiBpc19ubWFjKGVuYzo6RW5jb3VudGVyKQoJZm9yIGVuY19zdGF0ZSBpbiBlbmMKICAgICAgICBpZiBpc19ubWFjX3N0YXRlKGVuY19zdGF0ZSkKICAgICAgICAgICAgcmV0dXJuIHRydWUKICAgICAgICBlbmQKICAgIGVuZAogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gX19zaW1wbGVfY2FzKGVuY19zdGF0ZTo6RW5jb3VudGVyU3RhdGUpCglpZiBlbmNfc3RhdGUucGxhbmUxLnkgLSBlbmNfc3RhdGUucGxhbmUyLnkgPiAwCgkJcmV0dXJuIDpDTElNQgogICAgZW5kCiAgICByZXR1cm4gOkRFU0NFTkQKZW5kCgpmdW5jdGlvbiBfX3Jldl9zaW1wbGVfY2FzKGVuY19zdGF0ZTo6RW5jb3VudGVyU3RhdGUpCglpZiBlbmNfc3RhdGUucGxhbmUxLnkgLSBlbmNfc3RhdGUucGxhbmUyLnkgPiAwCgkJcmV0dXJuIDpERVNDRU5ECiAgICBlbmQKICAgIHJldHVybiA6Q0xJTUIKZW5kCgpmdW5jdGlvbiBfX2NvbnN0cmFpbmVkX3NpbXBsZV9DQVMoZW5jX3N0YXRlOjpFbmNvdW50ZXJTdGF0ZSwgdGhyZXNob2xkX2Rpc3Q6OkZsb2F0NjQpCiAgICBpZiBnZXRfc2VwYXJhdGlvbihlbmNfc3RhdGUpIDwgdGhyZXNob2xkX2Rpc3QKICAgICAgICByZXR1cm4gX19zaW1wbGVfY2FzKGVuY19zdGF0ZSkKICAgIGVuZAogICAgcmV0dXJuIDpDT0MKZW5kCg==")))

	get_miss_distances = get_miss_distances
	is_nmac_state = is_nmac_state
	is_name = is_nmac
	
	md""
end

# ╔═╡ f3d1a84c-5113-11eb-08a2-938ec13fdcbc
md"""
# Assignment 6: Additional Analysis
v2025.0.1
"""

# ╔═╡ 0cbbb521-705d-4bff-9e9d-a4d8608df465
md"## Notebook Setup"

# ╔═╡ 298d750e-5114-11eb-3a5b-e72e7dba0b29
md"""
## Problem Description

In this assignment, you will look back at the collision avoidance system you designed in the previous assignment and perform additional analysis.
"""

# ╔═╡ 0ef3bcb4-5115-11eb-385d-dfcaa74621f6
md"""
## ‼️ What is Turned In
1. Export this notebook as a PDF ([how-to in the documentation](https://plutojl.org/en/docs/export-pdf/))
2. Upload the PDF to [Gradescope](https://www.gradescope.com/)
3. Tag your pages correctly on Gradescope:
   - Milestone One: Tag the comments for each selected encounter
   - Milestone Two: Tag the discussions

**Do not use any external code or Julia packages other than those used in the class materials.**
"""

# ╔═╡ 4b41c514-5115-11eb-3283-d1daec5d0d8e
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

# ╔═╡ e5665562-7a0b-4ea3-a8e5-32ad154d6527
md"""
# 0️⃣ Milestone Zero: `my_cas` from Last Assignment

We are analyzing the collision avoidance system you implemented in Coding Assignment 5: CAS Design.
"""

# ╔═╡ 66d289f8-5115-11eb-31b8-b53a152f8751
md"""
Let's copy in and resimulate your CAS from the previous assigment so that we have some results to analyze.
"""

# ╔═╡ 88e155d8-5115-11eb-02ce-ffb1001a025d
md"""
## 💻 Task: Reimplement `my_cas`

Reimplement your `my_cas` function from last assignment here. You can copy and paste the code from the last assignment. Make sure you bring over any supporting functions you implemented as well!
"""

# ╔═╡ 9ab41aa2-5115-11eb-0e52-cfb017fa7f30
function my_cas(enc_state::EncounterState)
	advisory = :COC # Change this with your code
	
	# STUDENT CODE START

	
	
	# STUDENT CODE END
	
	return advisory
end

# ╔═╡ 378415a7-606f-4840-bb00-cc3fa21be250
md"""
## Simulating Results
Now we will collect an arrow of results from `simulate_encounter`. Remember that `simulate_encounter` returns a `Tuple` where the first entry is the simulated `Encounter` and the second entry is a `Vector` of the advisories issues.
"""

# ╔═╡ a3c2e22c-5115-11eb-0094-f9c26abc6eec
sim_results = [simulate_encounter(enc, my_cas) for enc in encounter_set];

# ╔═╡ ac1a33a0-5115-11eb-04e6-473cd31d90e0
md"""
# 1️⃣ Milestone One: Qualitative Analysis

Visual analysis is an important tool for understanding complex systems like collision avoidance. While aggregate metrics like NMAC rates provide high-level performance measures, plotting individual encounters helps reveal specific behaviors, edge cases, and failure modes that may be masked in the statistics.
Your first task is to select three "interesting" encounters from your simulated dataset and analyze them in detail. An "interesting" encounter could be:

- One that demonstrates your system working effectively to prevent a collision
- A case where your system generates unnecessary alerts or exhibits unexpected behavior
- An encounter that results in an NMAC despite the system's intervention
- A scenario that reveals limitations or assumptions in your approach

For each encounter you select, note the encounter index number for reference and comment on what is happening and why you deemed it "interesting". Please discuss whether the outcome is desirable and what it reveals about your system.

Below we've provided plots of all simulated encounters and plots of all NMAC encounters --- use the sliders to browse through them and identify cases worth examining more closely. Look for encounters that illustrate different aspects of your system's behavior or highlight areas for potential improvement.
"""

# ╔═╡ f6509949-b554-4b3f-9f43-f44eead0bec1
md"""
#### All Encounters
"""

# ╔═╡ 4a455495-dec6-4e09-83fa-89d3897d05d1
md"""
#### NMAC Encounters
"""

# ╔═╡ 7d9c5b4b-09a4-4094-94ec-35f843bf27e7
nmac_inds = findall([is_nmac(result[1]) for result in sim_results]);

# ╔═╡ 627ab28a-5116-11eb-2a3f-4335dedc5be3
md"""
## 💻 Task: List Interesting Indices

Fill in the encounter index of the three encounters you would like to highlight by changing the values below.
"""

# ╔═╡ 80c67666-5116-11eb-1327-ad61869eae97
begin
	# STUDENT CODE START
	
	highlight_index_1 = 1 # Change this value!!!
	highlight_index_2 = 2 # Change this value!!!
	highlight_index_3 = 3 # Change this value!!!

	# STUDENT CODE END
	md""
end

# ╔═╡ d5d34f9e-5116-11eb-0d99-df402ecd48ce
md"""
Your three encounters should now appear below. 

Below each plot, comment on what is happening and why you deemed it "interesting". Please discuss whether the outcome is desirable and what it reveals about your system. (minimum: 3-5 sentences).

"""

# ╔═╡ 0de189be-5117-11eb-1199-3d478dfcb705
md"""
## 💻 Task: Comments on Selected Encounter 1
"""

# ╔═╡ f872cb06-5116-11eb-2a10-8d370af59754
plot_encounter(sim_results[highlight_index_1]...)

# ╔═╡ 3e1d90be-5117-11eb-2ef1-3928b154f9ea
md"""
### Selected Encounter 1 Comments

Write your comments here!

"""

# ╔═╡ add2229d-1b3e-49df-838a-0998636abd48
md"""
## 💻 Task: Comments on Selected Encounter 2
"""

# ╔═╡ f97094f2-5116-11eb-143f-9fba4377f713
plot_encounter(sim_results[highlight_index_2]...)

# ╔═╡ c38dece1-43ec-4bf1-a4cf-0dc396e109d7
md"""
### Selected Encounter 2 Comments

Write your comments here!

"""

# ╔═╡ 327609ce-5117-11eb-1031-c3a88dc0869b
md"""
## 💻 Task: Comments on Selected Encounter 3
"""

# ╔═╡ fa38e4f2-5116-11eb-0f88-f9af477959f5
plot_encounter(sim_results[highlight_index_3]...)

# ╔═╡ 47059438-5117-11eb-3b69-3d9687e5922a
md"""
### Selected Encounter 3 Comments

Write your comments here!

"""

# ╔═╡ 49ca25d0-5117-11eb-213f-cb761b37d5b5
md"""
# 2️⃣ Milestone Two: Future Testing and Validation Requirements
We have made significant progress in developing a basic collision avoidance system, from initial design through multiple iterations and analysis. However, real-world collision avoidance systems like ACAS X require years of rigorous development and testing before deployment. While we can't match that level of thoroughness in AA120Q, we can think critically about what additional work would be needed to create a more robust and reliable system.

Unfortuantely, we don't have that kind of time in AA120Q, so let's brainstorm what else we would need to do to continue to test and improve our system. 


For your final task, consider the following two questions:
"""

# ╔═╡ 99a254d2-5118-11eb-0ca1-7501ea254a28
md"""
## 💻 Task: Discuss Additional Performance Metrics

While our current metrics of NMACs and alert rates provide important information, they don't capture all aspects of system performance. For example, they wouldn't detect a system that rapidly switches between climb and descend advisories --- behavior that could be problematic in practice.

What other metrics should we track to better evaluate our system?
"""

# ╔═╡ c1e61a14-5118-11eb-16ab-eb980f555c5c
md"""
### Additional Performance Metrics

Write your summary here!

"""

# ╔═╡ b0e4c16a-5119-11eb-1aa7-513244ba1a7d
md"""
## 💻 Task: Discuss Expansion of Test Coverage

Our current testing uses 1,000 encounters that all result in NMACs without intervention. This limited dataset, while useful for initial development, has significant blind spots. For instance, it cannot reveal induced collisions --- cases where our system actually causes an NMAC that wouldn't have occurred otherwise.

What additional testing would help validate our system? 
"""

# ╔═╡ bda9d58e-5119-11eb-3192-1786a830c084
md"""
### Expanding Test Coverage

Write your summary here!

"""

# ╔═╡ 0b6380f7-e251-48dc-aeb9-be1a5b388d62
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ 5f313522-55a4-4eb5-95cd-eb2c6cd03a9a
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

# ╔═╡ 786e1531-7a74-44fa-ba34-e8489c8af8f4
html_quarter_space()

# ╔═╡ 398b520c-511b-44f3-8a9a-964a95baba45
start_code()

# ╔═╡ 6a8d4da7-4256-42f3-98c2-817497570273
end_code()

# ╔═╡ 94d3b376-4299-41b6-b8f5-2096b480db56
html_half_space()

# ╔═╡ 4dd4b218-5116-11eb-10c0-8d575804e4bd
md"""
Use the arrow keys to move between encounters: $(@bind enc_ind NumberField(1:1000, default=1))

Number of encounters: $(length(sim_results))
"""

# ╔═╡ a4320530-f20a-4837-80e9-7933a1631471
md"""
#### Encounter Index: $enc_ind
"""

# ╔═╡ 57e82972-5116-11eb-321a-4b468f1674d1
plot_encounter(sim_results[enc_ind]...)

# ╔═╡ 683e8e20-04dc-4f1c-bd95-fd7ebb796f3d
md"""
Use the arrow keys to move between NMAC encounters: $(@bind nmac_ind NumberField(1:length(nmac_inds), default=1))

Number of NMAC encounters: $(length(nmac_inds))

*Note*: Please note the **encounter index** (not the number in the box)
"""

# ╔═╡ af33e451-a882-4b77-a414-72e9e13f3941
md"""
#### Encounter Index: $(nmac_inds[nmac_ind])


"""

# ╔═╡ 03d4ee3b-fb29-4644-b296-b00bb8162c81
plot_encounter(sim_results[nmac_inds[nmac_ind]]...)

# ╔═╡ 72e726bc-380d-4e46-9da8-039a5b8dde11
start_code()

# ╔═╡ 999260d8-2285-4542-a324-156ad924385a
end_code()

# ╔═╡ 4f046c6c-045d-425c-8794-6b0acc008fd2
html_quarter_space()

# ╔═╡ 7bf4fda9-fda2-49e5-a80b-a058108c9b05
start_code()

# ╔═╡ d4722740-3e73-459d-aaa9-83a7e9e1a4b7
end_code()

# ╔═╡ 9e5490b1-5ab1-4245-8800-b726d0528b14
html_quarter_space()

# ╔═╡ 0a391a3e-629a-46bd-be0e-954a9381d5e6
start_code()

# ╔═╡ e714189f-0a4d-4f8e-805a-8a185d3cc3d9
end_code()

# ╔═╡ 5e59b0e3-ff23-47a1-be1c-deca4fc3e01d
html_quarter_space()

# ╔═╡ e523fefe-820d-4d1d-9ddd-69f80a3ef9a7
start_code()

# ╔═╡ f2eb2bf2-bc69-499f-8369-9a00a4d7d9a8
end_code()

# ╔═╡ 0d3bc404-24be-4dc7-873f-9a34c0668ab0
html_half_space()

# ╔═╡ ad2c6577-0477-4dba-a31c-73c0b0a9ab12
html_expand("Hint: Expand for ideas to consider", md"""
Consider:
- Pilot/operational factors (e.g., advisory reversals, response time)
- Safety beyond just NMACs (e.g., close encounters, vertical separation)
- System behavior characteristics (e.g., alert timing, decision consistency)
- Efficiency measures (e.g., fuel usage, deviation from planned route)
""")

# ╔═╡ fa307504-3035-494a-9a89-9d239c2f750a
start_code()

# ╔═╡ 243c403e-90f9-4a95-8812-fbecc3cc0fcb
end_code()

# ╔═╡ c9b16ef1-5f3f-4dba-8b94-67f732e61c82
html_expand("Hind: Expand for ideas to consider", md"""
Consider:
- Different encounter types (non-NMAC scenarios, various geometries)
- Real-world complications (sensor noise, communication delays)
- Edge cases and failure modes
- Operational conditions (weather, aircraft performance limits)
- Integration with other systems and procedures
""")

# ╔═╡ 6f3d799b-eaaf-4871-b1fb-0da99529839c
start_code()

# ╔═╡ 8068bb96-2188-42bd-8646-822423ee2eff
end_code()

# ╔═╡ d91245fe-5119-11eb-3c29-516d33c9525f
html_half_space()

# ╔═╡ 40eac222-0dab-4450-9473-ed5add0937c5
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

# ╔═╡ 14655844-ce61-4261-a02f-70c020c7d439
PlutoUI.TableOfContents(title="Simulation")

# ╔═╡ Cell order:
# ╟─f3d1a84c-5113-11eb-08a2-938ec13fdcbc
# ╟─0cbbb521-705d-4bff-9e9d-a4d8608df465
# ╟─b4270d0f-a316-4781-a340-f6ec54f35a1b
# ╠═535c0573-63d1-464a-9780-3bd0e40e15d2
# ╟─298d750e-5114-11eb-3a5b-e72e7dba0b29
# ╟─0ef3bcb4-5115-11eb-385d-dfcaa74621f6
# ╟─4b41c514-5115-11eb-3283-d1daec5d0d8e
# ╟─786e1531-7a74-44fa-ba34-e8489c8af8f4
# ╟─e5665562-7a0b-4ea3-a8e5-32ad154d6527
# ╟─66d289f8-5115-11eb-31b8-b53a152f8751
# ╟─88e155d8-5115-11eb-02ce-ffb1001a025d
# ╟─398b520c-511b-44f3-8a9a-964a95baba45
# ╠═9ab41aa2-5115-11eb-0e52-cfb017fa7f30
# ╟─6a8d4da7-4256-42f3-98c2-817497570273
# ╟─378415a7-606f-4840-bb00-cc3fa21be250
# ╠═a3c2e22c-5115-11eb-0094-f9c26abc6eec
# ╟─94d3b376-4299-41b6-b8f5-2096b480db56
# ╟─ac1a33a0-5115-11eb-04e6-473cd31d90e0
# ╟─f6509949-b554-4b3f-9f43-f44eead0bec1
# ╟─4dd4b218-5116-11eb-10c0-8d575804e4bd
# ╟─a4320530-f20a-4837-80e9-7933a1631471
# ╟─57e82972-5116-11eb-321a-4b468f1674d1
# ╟─4a455495-dec6-4e09-83fa-89d3897d05d1
# ╟─7d9c5b4b-09a4-4094-94ec-35f843bf27e7
# ╟─683e8e20-04dc-4f1c-bd95-fd7ebb796f3d
# ╟─af33e451-a882-4b77-a414-72e9e13f3941
# ╟─03d4ee3b-fb29-4644-b296-b00bb8162c81
# ╟─627ab28a-5116-11eb-2a3f-4335dedc5be3
# ╟─72e726bc-380d-4e46-9da8-039a5b8dde11
# ╠═80c67666-5116-11eb-1327-ad61869eae97
# ╟─999260d8-2285-4542-a324-156ad924385a
# ╟─d5d34f9e-5116-11eb-0d99-df402ecd48ce
# ╟─4f046c6c-045d-425c-8794-6b0acc008fd2
# ╟─0de189be-5117-11eb-1199-3d478dfcb705
# ╟─f872cb06-5116-11eb-2a10-8d370af59754
# ╟─7bf4fda9-fda2-49e5-a80b-a058108c9b05
# ╠═3e1d90be-5117-11eb-2ef1-3928b154f9ea
# ╟─d4722740-3e73-459d-aaa9-83a7e9e1a4b7
# ╟─9e5490b1-5ab1-4245-8800-b726d0528b14
# ╠═add2229d-1b3e-49df-838a-0998636abd48
# ╟─f97094f2-5116-11eb-143f-9fba4377f713
# ╟─0a391a3e-629a-46bd-be0e-954a9381d5e6
# ╠═c38dece1-43ec-4bf1-a4cf-0dc396e109d7
# ╟─e714189f-0a4d-4f8e-805a-8a185d3cc3d9
# ╟─5e59b0e3-ff23-47a1-be1c-deca4fc3e01d
# ╟─327609ce-5117-11eb-1031-c3a88dc0869b
# ╟─fa38e4f2-5116-11eb-0f88-f9af477959f5
# ╟─e523fefe-820d-4d1d-9ddd-69f80a3ef9a7
# ╠═47059438-5117-11eb-3b69-3d9687e5922a
# ╟─f2eb2bf2-bc69-499f-8369-9a00a4d7d9a8
# ╟─0d3bc404-24be-4dc7-873f-9a34c0668ab0
# ╟─49ca25d0-5117-11eb-213f-cb761b37d5b5
# ╟─99a254d2-5118-11eb-0ca1-7501ea254a28
# ╟─ad2c6577-0477-4dba-a31c-73c0b0a9ab12
# ╟─fa307504-3035-494a-9a89-9d239c2f750a
# ╠═c1e61a14-5118-11eb-16ab-eb980f555c5c
# ╟─243c403e-90f9-4a95-8812-fbecc3cc0fcb
# ╟─b0e4c16a-5119-11eb-1aa7-513244ba1a7d
# ╟─c9b16ef1-5f3f-4dba-8b94-67f732e61c82
# ╟─6f3d799b-eaaf-4871-b1fb-0da99529839c
# ╠═bda9d58e-5119-11eb-3192-1786a830c084
# ╟─8068bb96-2188-42bd-8646-822423ee2eff
# ╟─d91245fe-5119-11eb-3c29-516d33c9525f
# ╟─0b6380f7-e251-48dc-aeb9-be1a5b388d62
# ╟─5f313522-55a4-4eb5-95cd-eb2c6cd03a9a
# ╟─40eac222-0dab-4450-9473-ed5add0937c5
# ╟─14655844-ce61-4261-a02f-70c020c7d439
# ╟─e2ad2cdf-c8ab-4e35-b6c0-724ebe9ec32b
