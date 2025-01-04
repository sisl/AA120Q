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

# ╔═╡ f2d4b6c0-3f12-11eb-0b8f-abd68dc8ade7
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ 42224774-2746-4138-ac7e-4e428bed14ea
begin
	using DataFrames
	using CSV
	using Distributions
	using Plots
	using Discretizers
	using Random
	using BayesNets
	plotlyjs()

	if !@isdefined HW2_Support_Code
		include("support_code/02_hw_support_code.jl")
	end
end

# ╔═╡ 0db17351-97c4-4b2d-95f1-b57a77b45157
begin
	using Base64
	include_string(@__MODULE__, String(base64decode("IyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgojIERFQ09ESU5HIFRISVMgSVMgQSBWSU9MQVRJT04gT0YgVEhFIEhPTk9SIENPREUKIyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgoKZnVuY3Rpb24gX19leHRyYWN0X2luaXRpYWxfY29uZGl0aW9ucyhlbmNvdW50ZXI6OkVuY291bnRlclN0YXRlKQogICAgCiAgICB5MSA9IGVuY291bnRlci5wbGFuZTEueQogICAgdTEgPSBlbmNvdW50ZXIucGxhbmUxLnUKICAgIHYxID0gZW5jb3VudGVyLnBsYW5lMS52CiAgICAKICAgIM6UeCA9IGVuY291bnRlci5wbGFuZTIueCAtIGVuY291bnRlci5wbGFuZTEueAogICAgzpR5ID0gZW5jb3VudGVyLnBsYW5lMi55IC0gZW5jb3VudGVyLnBsYW5lMS55CiAgICDOlHUgPSBlbmNvdW50ZXIucGxhbmUyLnUgLSBlbmNvdW50ZXIucGxhbmUxLnUKICAgIM6UdiA9IGVuY291bnRlci5wbGFuZTIudiAtIGVuY291bnRlci5wbGFuZTEudgogICAgCiAgICAjIEVuc3VyZSDOlHggaXMgcG9zaXRpdmUgYnkgdHJhbnNmb3JtaW5nIGlmIG5lZWRlZAogICAgaWYgzpR4IDwgMAogICAgICAgIM6UeCA9IC3OlHgKICAgICAgICDOlHUgPSAtzpR1CiAgICBlbmQKICAgIAogICAgcmV0dXJuICh5MSwgdTEsIHYxLCDOlHgsIM6UeSwgzpR1LCDOlHYpCmVuZAoKZnVuY3Rpb24gX19jcmVhdGVfZGlzY3JldGl6ZWRfZGF0YXNldChlbmNvdW50ZXJzOjpWZWN0b3J7RW5jb3VudGVyfSkKICAgICMgQ3JlYXRlIERhdGFGcmFtZSBvZiBjb250aW51b3VzIHZhbHVlcwogICAgZGYgPSBEYXRhRnJhbWUoCiAgICAgICAgeTEgPSBGbG9hdDY0W10sCiAgICAgICAgdTEgPSBGbG9hdDY0W10sCiAgICAgICAgdjEgPSBGbG9hdDY0W10sCiAgICAgICAgzpR4ID0gRmxvYXQ2NFtdLAogICAgICAgIM6UeSA9IEZsb2F0NjRbXSwKICAgICAgICDOlHUgPSBGbG9hdDY0W10sCiAgICAgICAgzpR2ID0gRmxvYXQ2NFtdCiAgICApCiAgICAKICAgIHVuaXF1ZV9pZHMgPSB1bmlxdWUoZmxpZ2h0c1s6LCAiaWQiXSkKCWVuY291bnRlcnMgPSBbcHVsbF9lbmNvdW50ZXIoZmxpZ2h0cywgaWRfaSkgZm9yIGlkX2kgaW4gdW5pcXVlX2lkc10KCglmb3IgZW5jIGluIGVuY291bnRlcnMKCQlwdXNoIShkZiwgX19leHRyYWN0X2luaXRpYWxfY29uZGl0aW9ucyhlbmNbMV0pKQoJZW5kCgkKICAgIEQgPSBEaWN0e1N5bWJvbCxMaW5lYXJEaXNjcmV0aXplcn0oCiAgICAgICAgc3ltPT5MaW5lYXJEaXNjcmV0aXplcihiaW5lZGdlcyhEaXNjcmV0aXplVW5pZm9ybVdpZHRoKDYpLCBkZlshLCBzeW1dKSkKICAgICAgICBmb3Igc3ltIGluIHByb3BlcnR5bmFtZXMoZGYpCiAgICApCiAgICAKICAgIGZvciAoc3ltLCBkaXNjKSBpbiBECiAgICAgICAgZGZbISwgc3ltXSA9IGVuY29kZShkaXNjLCBkZlshLCBzeW1dKQogICAgZW5kCiAgICAKICAgIHJldHVybiBkZiwgRAplbmQKCgpmdW5jdGlvbiBfX2xlYXJuX25ldHdvcmsoZGY6OkRhdGFGcmFtZSwgRDo6RGljdHtTeW1ib2wsTGluZWFyRGlzY3JldGl6ZXJ9KQoKCWJuID0gRGlzY3JldGVCYXllc05ldCgpCiAgICBuY2F0ZWdvcmllcyA9IFtubGFiZWxzKERbc3ltXSkgZm9yIHN5bSBpbiBwcm9wZXJ0eW5hbWVzKGRmKV0KCglwYXJhbXMgPSBHcmVlZHlIaWxsQ2xpbWJpbmcoCiAgICAJU2NvcmVDb21wb25lbnRDYWNoZShkZiksCiAgICAJbWF4X25fcGFyZW50cz0zLAogICAgCXByaW9yPVVuaWZvcm1QcmlvcigpCgkpCgoJYm4gPSBmaXQoRGlzY3JldGVCYXllc05ldCwgZGYsIHBhcmFtczsgbmNhdGVnb3JpZXM9bmNhdGVnb3JpZXMpCgogICAgcmV0dXJuIGJuCmVuZAoKZnVuY3Rpb24gX19leHRyYWN0X3RyYW5zaXRpb25zKGVuY291bnRlcnM6OlZlY3RvcntFbmNvdW50ZXJ9KQogICAgZGYgPSBEYXRhRnJhbWUoCiAgICAgICAgYXUxID0gRmxvYXQ2NFtdLAogICAgICAgIGF2MSA9IEZsb2F0NjRbXSwKCQlhdTIgPSBGbG9hdDY0W10sCiAgICAgICAgYXYyID0gRmxvYXQ2NFtdLAogICAgICAgIM6UeCA9IEZsb2F0NjRbXSwgCiAgICAgICAgzpR5ID0gRmxvYXQ2NFtdLCAKICAgICAgICDOlHUgPSBGbG9hdDY0W10sIAogICAgICAgIM6UdiA9IEZsb2F0NjRbXSwgCiAgICApCgoJZm9yIGVuYyBpbiBlbmNvdW50ZXJzCiAgICAgICAgZm9yIGkgaW4gMToobGVuZ3RoKGVuYyktMSkKICAgICAgICAgICAgeDFfdCA9IGVuY1tpXS5wbGFuZTEueAogICAgICAgICAgICB5MV90ID0gZW5jW2ldLnBsYW5lMS55CiAgICAgICAgICAgIHgyX3QgPSBlbmNbaV0ucGxhbmUyLngKICAgICAgICAgICAgeTJfdCA9IGVuY1tpXS5wbGFuZTIueQogICAgICAgICAgICB1MV90ID0gZW5jW2ldLnBsYW5lMS51CiAgICAgICAgICAgIHYxX3QgPSBlbmNbaV0ucGxhbmUxLnYKICAgICAgICAgICAgdTJfdCA9IGVuY1tpXS5wbGFuZTIudQogICAgICAgICAgICB2Ml90ID0gZW5jW2ldLnBsYW5lMi52CiAgICAgICAgICAgIAogICAgICAgICAgICB1MV9uZXh0ID0gZW5jW2krMV0ucGxhbmUxLnUKICAgICAgICAgICAgdjFfbmV4dCA9IGVuY1tpKzFdLnBsYW5lMS52CiAgICAgICAgICAgIHUyX25leHQgPSBlbmNbaSsxXS5wbGFuZTIudQogICAgICAgICAgICB2Ml9uZXh0ID0gZW5jW2krMV0ucGxhbmUyLnYKICAgICAgICAgICAgCiAgICAgICAgICAgIM6UeCA9IHgyX3QgLSB4MV90CiAgICAgICAgICAgIM6UeSA9IHkyX3QgLSB5MV90CiAgICAgICAgICAgIM6UdSA9IHUyX3QgLSB1MV90CiAgICAgICAgICAgIM6UdiA9IHYyX3QgLSB2MV90CiAgICAgICAgICAgIAogICAgICAgICAgICBhdTEgPSB1MV9uZXh0IC0gdTFfdAoJCQlhdjEgPSB2MV9uZXh0IC0gdjFfdAoJCQlhdTIgPSB1Ml9uZXh0IC0gdTJfdAoJCQlhdjIgPSB2Ml9uZXh0IC0gdjJfdAogICAgICAgICAgICAKICAgICAgICAgICAgcHVzaCEoZGYsIChhdTEsIGF2MSwgYXUyLCBhdjIsIM6UeCwgzpR5LCDOlHUsIM6UdikpCiAgICAgICAgZW5kCiAgICBlbmQKCQogICAgcmV0dXJuIGRmCmVuZAoKCmZ1bmN0aW9uIF9fY3JlYXRlX2Rpc2NyZXRpemVkX3RyYW5zaXRpb25zKGVuY291bnRlcnM6OlZlY3RvcntFbmNvdW50ZXJ9KQogICAgZGYgPSBfX2V4dHJhY3RfdHJhbnNpdGlvbnMoZW5jb3VudGVycykKICAgIAogICAgRCA9IERpY3R7U3ltYm9sLExpbmVhckRpc2NyZXRpemVyfSgpCiAgICBEWzphdTFdID0gTGluZWFyRGlzY3JldGl6ZXIoY29sbGVjdChyYW5nZSgtMC41LCBzdG9wID0gMC41LCBsZW5ndGggPSA2KSkpCiAgICBEWzphdjFdID0gTGluZWFyRGlzY3JldGl6ZXIoY29sbGVjdChyYW5nZSgtMi41LCBzdG9wID0gMi41LCBsZW5ndGggPSA2KSkpCglEWzphdTJdID0gTGluZWFyRGlzY3JldGl6ZXIoY29sbGVjdChyYW5nZSgtMC41LCBzdG9wID0gMC41LCBsZW5ndGggPSA2KSkpCiAgICBEWzphdjJdID0gTGluZWFyRGlzY3JldGl6ZXIoY29sbGVjdChyYW5nZSgtMi41LCBzdG9wID0gMi41LCBsZW5ndGggPSA2KSkpCiAgICBEWzrOlHhdICA9IExpbmVhckRpc2NyZXRpemVyKGNvbGxlY3QocmFuZ2UoLTEwMDAuMCwgc3RvcCA9IDEwMDAuMCwgbGVuZ3RoID0gNikpKQogICAgRFs6zpR5XSAgPSBMaW5lYXJEaXNjcmV0aXplcihjb2xsZWN0KHJhbmdlKC0xMDAwLjAsIHN0b3AgPSAxMDAwLjAsIGxlbmd0aCA9IDYpKSkKICAgIERbOs6UdV0gID0gTGluZWFyRGlzY3JldGl6ZXIoY29sbGVjdChyYW5nZSgtMzAuMCwgc3RvcCA9IDMwLjAsIGxlbmd0aCA9IDYpKSkKICAgIERbOs6Udl0gID0gTGluZWFyRGlzY3JldGl6ZXIoY29sbGVjdChyYW5nZSgtMTAwLjAsIHN0b3AgPSAxMDAuMCwgbGVuZ3RoID0gNikpKQoJCiAgICBmb3IgKHN5bSwgZGlzYykgaW4gRAogICAgICAgIGRmWyEsIHN5bV0gPSBlbmNvZGUoZGlzYywgZGZbISwgc3ltXSkKICAgIGVuZAoJCiAgICByZXR1cm4gZGYsIEQKZW5kCgpmdW5jdGlvbiBfX2xlYXJuX3RyYW5zaXRpb25fbmV0d29yayhkZjo6RGF0YUZyYW1lLCBEOjpEaWN0e1N5bWJvbCxMaW5lYXJEaXNjcmV0aXplcn0pCgoJYm5fZHluYW1pY3MgPSBEaXNjcmV0ZUJheWVzTmV0KCkKCglwYXJhbXMgPSBHcmVlZHlIaWxsQ2xpbWJpbmcoCiAgICAJU2NvcmVDb21wb25lbnRDYWNoZShkZiksCiAgICAJbWF4X25fcGFyZW50cz0zLAogICAgCXByaW9yPVVuaWZvcm1QcmlvcigpCgkpCgoJbl90cmFuc19jYXRlZ29yaWVzID0gW25sYWJlbHMoRFtzeW1dKSBmb3Igc3ltIGluIHByb3BlcnR5bmFtZXMoZGYpXQoJCglibl9keW5hbWljcyA9IGZpdChEaXNjcmV0ZUJheWVzTmV0LCBkZiwgcGFyYW1zOyBuY2F0ZWdvcmllcz1uX3RyYW5zX2NhdGVnb3JpZXMpCgogICAgcmV0dXJuIGJuX2R5bmFtaWNzCmVuZAo=")))

	__extract_initial_conditions = __extract_initial_conditions
	__create_discretized_dataset = __create_discretized_dataset
	__create_discretized_transitions = __create_discretized_transitions
	__extract_transitions = __extract_transitions
	__learn_network = __learn_network
	__learn_transition_network = __learn_transition_network
	
	md""
end

# ╔═╡ d923dee0-3f12-11eb-0fb8-dffb2e9b3b2a
md"""
# Assignment 2: Learning Aircraft Encounter Models
v2025.0.1
"""

# ╔═╡ a3648e27-ede6-4941-82d4-3698d8be1407
md"## Notebook Setup"

# ╔═╡ 83374e4a-2662-47b0-ae6a-da33e12acccb
md"""
## Additional Readings (optional)

If you want to deepen your understanding of the concepts covered in this assignment, we recommend the following resources:

- Kochenderfer, M. J., Wheeler, T. A., & Wray, K. H. (2022). *Algorithms for Decision Making*
  - Chapters 3-5 cover probabilistic modeling, inference, and structure learning
  - Available open access at [algorithmsbook.com](https://algorithmsbook.com)

- Kochenderfer, M. J. (2015). *Decision Making Under Uncertainty: Theory and Application*
  - Chapter 2: Probabilistic Models
  - Available at [http://web.stanford.edu/group/sisl/public/dmu.pdf](http://web.stanford.edu/group/sisl/public/dmu.pdf)

- Koller, D., & Friedman, N. (2009). *Probabilistic Graphical Models: Principles and Techniques*
  - Comprehensive coverage of Bayesian networks and parameter learning
  - Recommended for deeper theoretical understanding

- [BayesNets.jl Documentation](https://sisl.github.io/BayesNets.jl/dev/)
  - Julia package documentation for representation, inference, and learning in Bayesian networks
  - Includes examples and API reference
"""

# ╔═╡ 081da510-4fb1-11eb-3334-63534dbae588
md"""
## Problem Description

In collision avoidance system development, we need models that can generate realistic aircraft encounters for testing and validation. Our task is to learn such a model from encounter data. Using provided aircraft trajectories, you will:

1. Learn an initial scene model -- capturing the distribution of how encounters typically begin
2. Learn a dynamics model -- describing how aircraft states evolve over time

Each encounter in our dataset contains 51 timesteps (50 seconds) of trajectory data for two aircraft. The initial scene model will capture the probability distribution over starting positions and velocities. The dynamics model will represent how aircraft states (position, velocity) change from one timestep to the next.

By learning these models, we can:
- Generate new encounter scenarios for testing collision avoidance systems
- Understand common patterns in how encounters develop
- Create more diverse test cases than available in recorded data

You will implement this using Discrete Bayesian Networks, learning both the structure and parameters from data. This assignment will not require any knowledge of the inner workings of Bayesian networks. However, you will be required to implement a function from the `BayesNets.jl` library. The hints should help guide you on how to implement this function.
"""

# ╔═╡ cfff9088-511c-11eb-36f4-936646282096
md"""
## ‼️ What is Turned In
1. Export this notebook as a PDF ([how-to in the documentation](https://plutojl.org/en/docs/export-pdf/))
2. Upload the PDF to [Gradescope](https://www.gradescope.com/)
3. Tag your pages correctly on Gradescope:
   - Tag the page containing your checks (with the ✅ or ❌) 

**Do not use any external code or Julia packages other than those used in the class materials.**
"""

# ╔═╡ 31d14960-3f13-11eb-3d8a-7531c02990cf
md"""
## Aircraft Encounter Data
The dataset contains records of aircraft encounters -- situations where two aircraft come into close proximity. Each encounter consists of 50 seconds of trajectory data sampled at 1 Hz (51 total timesteps including t=0). The encounters represent scenarios that collision avoidance systems need to handle.

## Data Structure
The data file, `flights.csv` (in the AA120Q/data directory), contains a table with the following columns:

| Variable | Type | Description |
| -------- |:----:| ----------- |
| **id**   | Int    | encounter id |
| **t**    | Int    | time in 1s intervals from 0 to 50 |
| **x1**   | Float  | aircraft 1 position along x-axis |
| **x2**   | Float  | aircraft 2 position along x-axis |
| **y1**   | Float  | aircraft 1 position along y-axis |
| **y2**   | Float  | aircraft 2 position along y-axis |
| **u1**   | Float   | aircraft 1 horizontal speed [m/s] |
| **u2**   | Float   | aircraft 2 horizontal speed [m/s] |
| **v1**   | Float   | aircraft 1 vertical speed [m/s] |
| **v2**   | Float   | aircraft 2 vertical speed [m/s] |


## Provided Code Structure

To help you work with this encounter data, we provide a few data structures and helper functions. We also load the data to a variable `flights::DataFrame`.

### Data Types

#### `AircraftState`
Represents the state of a single aircraft:
```julia
struct AircraftState
    x::Float64  # horizontal position [m]
    y::Float64  # vertical position [m]
    u::Float64  # horizontal speed [m/s]
    v::Float64  # vertical speed [m/s]
end
```
#### `EncounterState`
Contains the information of the state of an encounter:

```julia
mutable struct EncounterState
    plane1::AircraftState
    plane2::AircraftState
    t::Float64
end
```

#### `Encounter`

```julia
const Encounter = Vector{EncounterState}
```

#### `DiscretizedBayesNet`
We will be discretizing our data and learning a Bayesian network. This struct will help us use our model by grouping the Bayesian network with the discretizers we used.

```julia
struct DiscretizedBayesNet
    dbn::DiscreteBayesNet
    discs::Dict{Symbol, LinearDiscretizer}
end
```

### Helper Function

#### `pull_encounter(flights::DataFrame, id::Int)`

Extracts data for a specific encounter ID from the flights DataFrame and converts it into an Encounter object. The `Encounter` returned is in order of the time progressing of the encounter. For example:
"""

# ╔═╡ eddfed22-c819-46c7-bc9b-f45d4871387f
encounter_1 = pull_encounter(flights, 1); # Get the encounter with ID of 1

# ╔═╡ 10cb1dd1-f60d-4701-8f88-a62e3eef5913
encounter_1[1] # First state of encounter_1 (at the first time step)

# ╔═╡ 746e2966-2e3f-4eb7-914e-91129f39a4a1
md"""
### Vector of all Encounters

Using `pull_encounter`, the provided code also creates a vector of all Encounters. This vector is `encounter_set` is a `Vector` of `Encounter` types. 

We know that the ids in the datasets are all unique and range from 1 to 1000. Therefore, it was created from:

```julia
encounter_set = [pull_encounter(flights, id) for id = 1:1000]
```
"""

# ╔═╡ 9a5ee79b-a593-46b2-a9de-732f36069ded
md"""
# 1️⃣ Milestone One: Initial Conditions Model

Our first task is to build a model that captures how aircraft encounters typically begin.
"""

# ╔═╡ 256a1650-a85c-484a-a4d9-384fce5f719e
md"""
## Part 1: Extract Initial Features
First, you'll need to extract the relevant initial features from each encounter. To help us with our modeling, we will define our encounters relative to one aircraft.

For each of our encounters we want:
- Aircraft 1 starts at (0, y1, u1, v1)
- Aircraft 2's position is defined relative to Aircraft 1 (Δx, Δy, Δu, Δv)
- Δx ≥ 0

The following picture should help visualize this.
"""

# ╔═╡ ead1b755-3a62-4843-b327-b107223a1072
PlutoUI.LocalResource("./figures/encounter_def.png")

# ╔═╡ 3623eaa8-0b38-4787-9839-c9aa959d1d3d
md"""
### 💻 **Task**: Implement the function `extract_initial_conditions`

This function has an input of an `EncounterState` and returns a Tuple defining the relative position as defined above. I.e. the function should return `(y1, u1, v1, Δx, Δy, Δu, Δv)`.
"""

# ╔═╡ 4d0a3c12-3410-4b4f-941a-1dfe6c9870bc
function extract_initial_conditions(encounter::EncounterState)
    # For our initial conditions model, we need:
    y1 = 0.0    # Initial y position of aircraft 1
    u1 = 0.0    # Initial horizontal velocity of aircraft 1
    v1 = 0.0    # Initial vertical velocity of aircraft 1
    Δx = 0.0    # Relative x position (x2 - x1)
    Δy = 0.0    # Relative y position (y2 - y1)
    Δu = 0.0    # Relative horizontal velocity (u2 - u1)
    Δv = 0.0    # Relative vertical velocity (v2 - v1)
    
    # STUDENT CODE START
	    # 1. Extract initial positions and velocities from encounter state
	    # 2. Calculate relative positions and velocities
	    # 3. Ensure Δx ≥ 0


    # STUDENT CODE END
	
    return (y1, u1, v1, Δx, Δy, Δu, Δv)
end

# ╔═╡ 151a5840-4f9b-415e-823f-322fd4ca194d
begin
	
	global m1p1_icon = "❌"
	global milestone_one_part_1_pass = false
	sampled_ids = collect(1:1000)

	test_encounters = [pull_encounter(flights, id_i) for id_i in sampled_ids]
	
	try
		user_defined_extractions = [extract_initial_conditions(enc_i[1]) for enc_i in test_encounters]

		true_extractions = [__extract_initial_conditions(enc_i[1]) for enc_i in test_encounters]

		individual_component_match = trues(length(true_extractions[1]))
		for ii in 1:length(true_extractions[1])
			for jj in 1:length(sampled_ids)
				if true_extractions[jj][ii] != user_defined_extractions[jj][ii]
					individual_component_match[ii] = false
					break
				end
			end
		end

		all_match = all(individual_component_match)
		
		if all_match
			global m1p1_icon = "✅"
			global milestone_one_part_1_pass = true
			Markdown.MD(Markdown.Admonition("correct", "🥳", [md"""Your function is correct!"""]))
		else
			milestone_one_msg = md"""Your function doesn't appear to be correct.

			Of $(length(test_encounters)) encounters tested, your function matched on $(sum(all_match)) and differed on the rest."""

			delta_x_vals = [user_defined_i[4] for user_defined_i in user_defined_extractions]
			if any(delta_x_vals .< 0)
			    milestone_one_msg = md"""$milestone_one_msg
					
					Check that Δx ≥ 0"""
			end
			
			if all(individual_component_match[1:3])
			    milestone_one_msg = md"""$milestone_one_msg

					Components y1, u1, and v1 match. Check the relative values."""
			end
			
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [milestone_one_msg]))
		end
	catch err
		Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err
		"""]))
	end
end

# ╔═╡ 541d34f6-7648-4ab2-96d3-ba3c3e49ce98
md"""
### $(m1p1_icon) Milestone One - Part 1 Check
"""

# ╔═╡ e74cfb06-933d-43d9-8bb2-5f0c40775ce6
md"""
## Part 2: Prepare Data to Learn Initial Conditions Model with Bayesian Networks

Now that we can extract initial features from encounters, we'll learn a Bayesian network to capture relationships between these variables. We'll first convert our continuous data into discrete bins.

### 💻 **Task**: Implement `create_discretized_dataset`
"""

# ╔═╡ d0366eb2-6829-4cce-9e9a-0954c547cb7c
function create_discretized_dataset(encounters::Vector{Encounter})
    # Create DataFrame of continuous values
    df = DataFrame(
        y1 = Float64[],
        u1 = Float64[],
        v1 = Float64[],
        Δx = Float64[],
        Δy = Float64[],
        Δu = Float64[],
        Δv = Float64[]
    )
	
    # STUDENT CODE START
	    # 1. Extract initial features from each encounter
	    # 2. Add features to DataFrame
	
	
	# STUDENT CODE END

    # Create discretizers and discretize data
    if !isempty(df)
		D = Dict{Symbol, LinearDiscretizer}(
	        sym=>LinearDiscretizer(binedges(DiscretizeUniformWidth(6), df[!, sym]))
	        for sym in propertynames(df)
	    )
	else
		D = Dict{Symbol, LinearDiscretizer}()
	end
    
    # Encode each column
    for (sym, disc) in D
        df[!, sym] = encode(disc, df[!, sym])
    end
    
    return df, D
end

# ╔═╡ 36abf386-9cd1-4090-b7a0-51db9d2302b5
begin
    
    global m1p21_icon = "❌"
    global milestone_one_part_21_pass = false

	m1p21_sampled_ids = collect(1:1000)

    m1p21_test_encounters = [pull_encounter(flights, id_i) for id_i in m1p21_sampled_ids]
    
    try
        user_df, user_D = create_discretized_dataset(m1p21_test_encounters)
        true_df, true_D = __create_discretized_dataset(m1p21_test_encounters)
        
        # Check DataFrame dimensions
        dims_match = size(user_df) == size(true_df)

		disc_match = false
		if dims_match
			# Check discretization matches
	        disc_match = true
	        for sym in propertynames(true_df)
	            if !all(user_df[!, sym] .== true_df[!, sym])
	                disc_match = false
	                break
	            end
	        end
		end
	
        if dims_match && disc_match
            global m1p21_icon = "✅"
            global milestone_one_part_21_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""Your discretization is correct!"""]))
        else
            m1p21_msg = md"""Your discretization doesn't appear to be correct."""

			if isempty(user_df)
				m1p21_msg = md"""$m1p21_msg
				
				Your DataFrame is empty."""
			elseif !dims_match
                m1p21_msg = md"""$m1p21_msg
				
				DataFrame dimensions don't match"""
            end
            if dims_match && !disc_match
                m1p21_msg = md"""$m1p21_msg
				
				Discretized values don't match"""
            end
            
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [m1p21_msg]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err"""]))
    end
end

# ╔═╡ d2d86873-76ff-49fe-a368-de8f3641d310
md"""
### $(m1p21_icon) Milestone One - Part 2 Check
"""

# ╔═╡ 5e9fca68-4016-40ee-b0ba-1db008efee99
md"""
## Part 3: Learn Bayesian Network Structure

Now that we have discretized our data, we can learn a Bayesian network that captures the relationships between variables in our initial conditions.

### 💻 **Task**: Implement `learn_network`
"""

# ╔═╡ a2029e97-7907-456f-baea-7fc4a7ac7feb
function learn_network(df::DataFrame, D::Dict{Symbol,LinearDiscretizer})

	bn = DiscreteBayesNet()

	# Set up algorithm parameters
	params = GreedyHillClimbing(
    	ScoreComponentCache(df),
    	max_n_parents=3,  # Maximum parents per node
    	prior=UniformPrior()
	)
	
	# Get number of categories for each variable
    ncategories = [nlabels(D[sym]) for sym in propertynames(df)]

	
    # STUDENT CODE START
    	# 1. Learn network structure and parameters

	
    # STUDENT CODE END

	# Return the Bayesian network
    return bn
end

# ╔═╡ 74e2f715-c62d-4003-87c8-3ab9c89f3813
begin
    
    global m1p3_icon = "❌"
    global milestone_one_part_3_pass = false
    
    try
        # First get discretized data
        local test_df, test_D = __create_discretized_dataset(m1p21_test_encounters)
        
        # Get student's network and solution network
        user_bn = learn_network(test_df, test_D)
        true_bn = __learn_network(test_df, test_D)
        
        # Compare network structures
        struct_match = user_bn.dag == true_bn.dag
        
        # Compare network parameters (CPTs)
		local params_match = true
        if struct_match  # Only check params if structure matches
        	if length(user_bn.cpds) != length(true_bn.cpds)
				params_match = false
			end

			for ii in 1:length(true_bn.cpds)
				if !params_match
					break
				end
				true_cpd = true_bn.cpds[ii]
				user_cpd = user_bn.cpds[ii]
				
				if !all(true_cpd.target .== user_cpd.target)
					params_match = false
				elseif !all(true_cpd.parental_ncategories .== user_cpd.parental_ncategories)
					params_match = false
				elseif !all(true_cpd.parents .== user_cpd.parents)
					params_match = false
				elseif !all(true_cpd.distributions .== user_cpd.distributions)
					params_match = false
				end
			end
			
        end

        if struct_match && params_match
            global m1p3_icon = "✅"
            global milestone_one_part_3_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""Your Bayesian network learning is correct!"""]))
        else
            m1p3_msg = md"""Your learned network doesn't appear to be correct.
            
            Check that you are passing the arguments to `fit` correctly. Expand on the hints for more information on the arguments and how to use `fit`."""
            
            if !struct_match
                m1p3_msg = md"""$m1p3_msg
                
                The network structure doesn't match the expected result."""
            elseif !params_match
                m1p3_msg = md"""$m1p3_msg
                
                The structure is correct, but the network parameters don't match the expected result. Ensure you are using the provided `params` when fitting the network."""
            end
            
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [m1p3_msg]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err"""]))
    end
end

# ╔═╡ 949de14f-8da1-4983-a2a4-637746b3bd37
md"""
### $(m1p3_icon) Milestone One - Part 3 Check
"""

# ╔═╡ 171b053d-df2a-42be-86ca-3616cbb58512
begin
	global milestone_one_complete = (milestone_one_part_1_pass && milestone_one_part_21_pass && milestone_one_part_3_pass)
	if milestone_one_complete
		md"""
		##  ✅ Milestone One Complete!
		"""
	else
		md"""
		##  ❌ Milestone One Incomplete!
		"""
	end
end

# ╔═╡ b0027ea8-54db-4db5-97dc-c7e961e71637
md"""
# Creating the Initial Conditions Model and Sampling

Now that we have the required functions, we can create our initial conditions model. We also want to create a function to allow us to sample initial conditions from the model.

## Creating the Model
The following two lines use your created functions to discretize the dataset and then learn a Bayesian network that we can sample from.
"""

# ╔═╡ 1f725083-c755-4a28-94b4-0a48aa70edad
begin
	if milestone_one_complete
		df, D = create_discretized_dataset(encounter_set)
		bn = learn_network(df, D)
	end
end

# ╔═╡ 42fa595a-c057-4feb-9396-594cbbd4140a
md"""
## Sampling from the Model

To sample from the model, we need both the Bayesian network and the dictionary of discretizers. We will use the `DiscretizedBayesNet` Type defined in the provided code to help us.
"""

# ╔═╡ 2b5fdf91-7a1d-4632-a6fc-d76ff9237179
md"""
Now we can use Julia's multiple dispatch to extend the `rand` function to sample from our model, which will be a `DiscretizedBayesNet`.
"""

# ╔═╡ 6fef1c72-971f-4734-9ed9-bfd99bab46f9
function Base.rand(model::DiscretizedBayesNet)
	sample = rand(model.dbn) # Sample from the Bayesian network

	# Convert the discrete samples to continuous samples
	for (sym, disc) in model.discs
		sample[sym] = decode(disc, sample[sym])
	end
	
	return sample
end

# ╔═╡ 95790cdf-9d36-4d3e-ac3d-ddcd87d0018d
md"""
### Example: Sampling

Let's create the model using our variables from above (i.e. `bn` and `D`).
"""

# ╔═╡ ea2c6b22-43c7-4b1c-a234-c9a861f6e6dd
if milestone_one_complete
	init_cond_model = DiscretizedBayesNet(bn, D)
end

# ╔═╡ 8d0406c5-44f7-4d41-a92b-c9463fd4ce9b
md"""Now let's sample from it."""

# ╔═╡ f6d8023a-c798-4935-9e9b-4f3ab9de099e
md"""The sample we get is not quite an EncounterState. Let's create a helper function that turns the sample into an EncounterState."""

# ╔═╡ c0e16644-bc8c-4193-a341-27864ed38717
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

# ╔═╡ d816892b-e277-47e6-8fb4-a9ec984d2a06
md"""
# 2️⃣ Milestone Two: Dynamics Model

Now that we've successfully implemented the Initial Conditions Model, we'll develop a Bayesian network to capture how aircraft behave during encounters. This Dynamics Model will focus on predicting the accelerations of each aircraft given the current relative state.

## Model Structure
Our dynamics model represents the probability distribution of relative accelerations given the current relative state. Specifically, we want:

$$P(a_{u_1}, a_{v_1}, a_{u_2}, a_{v_2} \mid \Delta x_{t-1}, \Delta y_{t-1}, \Delta u_{t-1}, \Delta v_{t-1})$$

and we can achieve that by learning:

$$P(a_{u_1}, a_{v_1}, a_{u_2}, a_{v_2}, \Delta x_{t-1}, \Delta y_{t-1}, \Delta u_{t-1}, \Delta v_{t-1})$$

and sampling from the network with evidence (given the relative state).

Note:
- ``a_{u_1}, a_{v_1}, a_{u_3}, a_{v_3}`` are the accelerations of the aircraft
- ``\Delta x_{t-1}, \Delta y_{t-1}, \Delta u_{t-1}, \Delta v_{t-1}`` are the previous relative positions and velocities

We'll follow the same steps as before:
1. Extract transition features from our encounters
2. Create a discretized dataset
3. Learn a Bayesian network (structure and parameters)

## Part 1: Extract Transitions
First, let's create a function that takes in all our encounters and returns a DataFrame containing all of the transitions. For each timestep in each encounter, we'll calculate the relative accelerations from the current timestep to the next and also record the relative state variables from the current timestep.

### 💻 **Task**: Implement `extract_transitions`
"""

# ╔═╡ 668cbea8-b56c-491a-9907-513fe37e5861
function extract_transitions(encounters::Vector{Encounter})
    # Initialize DataFrame to store transitions
    df = DataFrame(
        au1 = Float64[],  # horizontal acceleration [m/s²] of aircraft 1
        av1 = Float64[],  # vertical acceleration [m/s²] of aircraft 1
		au2 = Float64[],  # horizontal acceleration [m/s²] of aircraft 2
        av2 = Float64[],  # vertical acceleration [m/s²] of aircraft 2
        Δx = Float64[],   # relative x position [m]
        Δy = Float64[],   # relative y position [m]
        Δu = Float64[],   # relative horizontal velocity [m/s]
        Δv = Float64[],   # relative vertical velocity [m/s]
    )
    
    # STUDENT CODE START
	    # For each encounter:
	    #   For each consecutive pair of timesteps:
	    #     1. Calculate relative accelerations between t and t+1
	    #     2. Record relative state at time t
	    #     3. Add to DataFrame

	
	# STUDENT CODE END
	
    return df
end

# ╔═╡ dea3d3ee-40d3-4098-8c1f-8192ffb4ebd7
begin
    
    global m2p1_icon = "❌"
    global milestone_two_part_1_pass = false
    
    try
        user_df = extract_transitions(test_encounters)
        true_df = __extract_transitions(test_encounters)
        
        # Check DataFrame dimensions
        dims_match = size(user_df) == size(true_df)
        
        # Check values match within tolerance
        vals_match = true
        if dims_match
            for col in names(true_df)
                if !all(isapprox.(user_df[!, col], true_df[!, col], rtol=1e-10))
                    vals_match = false
                    break
                end
            end
        end
        
        if dims_match && vals_match
            global m2p1_icon = "✅"
            global milestone_two_part_1_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""Your transition extraction is correct!"""]))
        else
            if !dims_match
                Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""Your transition extraction doesn't appear to be correct.
                
DataFrame has incorrect dimensions. Check that you're extracting transitions from every valid timestep.
"""]))
            elseif !vals_match
                # Build column information string
                col_matches = []
				cols = names(true_df)
                for col in names(true_df)
                    matches = sum(isapprox.(user_df[!, col], true_df[!, col], rtol=1e-10))
                    push!(col_matches, "$col: $matches/$(size(true_df, 1)) values match")
                end
                
                Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""Your transition extraction doesn't appear to be correct.
				
Values don't match expected results:
- $(col_matches[1])
- $(col_matches[2])
- $(col_matches[3])
- $(col_matches[4])
- $(col_matches[5])
- $(col_matches[6])
                
Check your calculations for relative states and accelerations.
"""]))
            end
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err"""]))
    end
end

# ╔═╡ 260a8b0f-9620-4c6b-be6e-ada7021ac201
md"""
### $(m2p1_icon) Milestone Two - Part 1 Check
"""

# ╔═╡ 4081909a-c8df-4d44-a3da-24ef1a0c0700
md"""
## Part 2: Learn Transition Model with Bayesian Networks

Now that we can extract transitions from our encounters, we'll learn a Bayesian network to capture how accelerations depend on the current state. Similar to Part 1 of Milestone One, we'll create a discretized dataset using predefined bin edges.

### 💻 **Task**: Implement `create_discretized_transitions`
"""

# ╔═╡ 0c2f2e20-948b-4b45-b83c-db692d028c1d
function create_discretized_transitions(encounters::Vector{Encounter})
    # Get raw transition data
    df = extract_transitions(encounters)
    
    # Create discretizers with predefined edges
    D = Dict{Symbol,LinearDiscretizer}()
    D[:au1] = LinearDiscretizer(collect(range(-0.5, stop = 0.5, length = 6)))
    D[:av1] = LinearDiscretizer(collect(range(-2.5, stop = 2.5, length = 6)))
	D[:au2] = LinearDiscretizer(collect(range(-0.5, stop = 0.5, length = 6))) 
    D[:av2] = LinearDiscretizer(collect(range(-2.5, stop = 2.5, length = 6))) 
    D[:Δx]  = LinearDiscretizer(collect(range(-1000.0, stop = 1000.0, length = 6)))
    D[:Δy]  = LinearDiscretizer(collect(range(-1000.0, stop = 1000.0, length = 6)))
    D[:Δu]  = LinearDiscretizer(collect(range(-30.0, stop = 30.0, length = 6)))
    D[:Δv]  = LinearDiscretizer(collect(range(-100.0, stop = 100.0, length = 6)))
	
	# STUDENT CODE START
		# Encode each column

	
	# STUDENT CODE END

	
    return df, D
end

# ╔═╡ 778f308b-f448-4685-8f11-cdb071784bc1
begin
    
    global m2p2_icon = "❌"
    global milestone_two_part_2_pass = false
    
    try 
        m2p2_user_df, m2p2_user_D = create_discretized_transitions(test_encounters)
        
        m2p2_true_df, m2p2_true_D = __create_discretized_transitions(test_encounters)
        
        # Check DataFrame dimensions
        m2p2_dims_match = size(m2p2_user_df) == size(m2p2_true_df)
        
        local m2p2_vals_match = true
        if m2p2_dims_match
            for col in names(m2p2_true_df)
                if !all(m2p2_user_df[!, col] .== m2p2_true_df[!, col])
                    m2p2_vals_match = false
                    break
                end
            end
        end
        
        if m2p2_dims_match && m2p2_vals_match
            global m2p2_icon = "✅"
            global milestone_two_part_2_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""Your discretization of transitions is correct!"""]))
        else
            m2p2_msg = md"""Your discretization of transitions doesn't appear to be correct."""
            
            if !m2p2_dims_match
                m2p2_msg = md"""$m2p2_msg
                
                DataFrame dimensions don't match."""
            end
            
            if m2p2_dims_match && !m2p2_vals_match
                # Build column mismatch details
                col_mismatches = String[]
                for col in names(m2p2_true_df)
                    if !all(m2p2_user_df[!, col] .== m2p2_true_df[!, col])
                        push!(col_mismatches, "Column $col does not match")
                    end
                end
                
                m2p2_msg = md"""$m2p2_msg
                
                Discretized values don't match:
                $(join(col_mismatches, ";\n"))
                
                Check your discretization process carefully."""
            end
            
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [m2p2_msg]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err"""]))
    end
end


# ╔═╡ aac9e56b-008b-40f0-b168-3e8bfc4adb36
md"""
### $(m2p2_icon) Milestone Two - Part 2 Check
"""

# ╔═╡ 9ebb3a2a-9a74-4084-b570-20edcc5b78af
md"""
## Part 3: Learn Bayesian Network Structure

Similar to before, now that we have discretized our data, we can learn a Bayesian network that captures the relationships between variables in our transition.

### 💻 **Task**: Implement `learn_transition_network`
"""

# ╔═╡ b3bebc6c-a0fb-4ed2-b9e6-c325786ec1fe
function learn_transition_network(df::DataFrame, D::Dict{Symbol,LinearDiscretizer})

	bn_dynamics = DiscreteBayesNet()

	# Set up algorithm parameters
	params = GreedyHillClimbing(
    	ScoreComponentCache(df),
    	max_n_parents=3,
    	prior=UniformPrior()
	)
	
    # STUDENT CODE START
	    # 1. Get the number of categories for each variable for our dynamics model
		# 2. Learn network structure and parameters

	
    # STUDENT CODE END

	# Return the Bayesian network
    return bn_dynamics
end

# ╔═╡ 9290ab5e-6418-4c8a-b017-0db1705cd5cc
begin    
    global m2p3_icon = "❌"
    global milestone_two_part_3_pass = false
    
    try
        # First get discretized data
        local test_df, test_D = __create_discretized_dataset(m1p21_test_encounters)
        
        # Get student's network and solution network
        user_bn = learn_transition_network(test_df, test_D)
        true_bn = __learn_transition_network(test_df, test_D)
        
        # Compare network structures
        struct_match = user_bn.dag == true_bn.dag
        
        # Compare network parameters (CPTs)
		local params_match = true
        if struct_match  # Only check params if structure matches
        	if length(user_bn.cpds) != length(true_bn.cpds)
				params_match = false
			end

			for ii in 1:length(true_bn.cpds)
				if !params_match
					break
				end
				true_cpd = true_bn.cpds[ii]
				user_cpd = user_bn.cpds[ii]
				
				if !all(true_cpd.target .== user_cpd.target)
					params_match = false
				elseif !all(true_cpd.parental_ncategories .== user_cpd.parental_ncategories)
					params_match = false
				elseif !all(true_cpd.parents .== user_cpd.parents)
					params_match = false
				elseif !all(true_cpd.distributions .== user_cpd.distributions)
					params_match = false
				end
			end
			
        end

        if struct_match  && params_match
            global m2p3_icon = "✅"
            global milestone_two_part_3_pass = true
            Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""Your Bayesian network learning is correct!"""]))
        else
            m2p3_msg = md"""Your learned network doesn't appear to be correct.
            
            Check that you are passing the arguments to `fit` correctly. Expand on the hints for more information on the arguments and how to use `fit`."""
            
            if !struct_match
                m2p3_msg = md"""$m2p3_msg
                
                The network structure doesn't match the expected result."""
            elseif !params_match
                m2p3_msg = md"""$m2p3_msg
                
                The structure is correct, but the network parameters don't match the expected result. Ensure you are using the provided `params` when fitting the network."""
            end
            
            Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [m2p3_msg]))
        end
    catch err
        Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err"""]))
    end
end

# ╔═╡ cca93968-f983-4513-9aa9-2dd93a8dce4c
md"""
### $(m2p3_icon) Milestone Two - Part 3 Check
"""

# ╔═╡ 7320d945-29f6-4356-ad64-5408532645c6
begin
	milestone_two_complete = (milestone_two_part_1_pass && milestone_two_part_2_pass && milestone_two_part_3_pass)
	if milestone_two_complete
		md"""
		##  ✅ Milestone Two Complete!
		"""
	else
		md"""
		##  ❌ Milestone Two Incomplete!
		"""
	end
end

# ╔═╡ d6b0c927-c800-4c90-bde8-f6d33e5334c7
md"""
# Creating and Using the Transition Model

Similar to our initial conditions model, our model is made up of a Bayesian network and discretizers. Therefore, our model is a `DiscretizedBayesNet` type that was defined in the provided code.
"""

# ╔═╡ 006d8885-09d1-4f11-87b7-6e64d308620a
md"""
Let's create our transition model using the encounters data:
"""


# ╔═╡ 0aa04646-e140-4ac5-beac-ac550b76c707
begin
	transitions_df, transitions_D = create_discretized_transitions(encounter_set)
	transitions_bn = learn_transition_network(transitions_df, transitions_D)

	trans_model = DiscretizedBayesNet(transitions_bn, transitions_D)
end

# ╔═╡ c9856f5e-b4f9-43ad-a0b9-2cea19596d8d
trans_model.dbn

# ╔═╡ e0366556-5913-4a29-b282-f979acb7b0af
md"""
## Sampling from the Model
We extended Julia's `rand` function to work with a `DiscretizedBayesNet`. However, we are looking to sample from $$P(a_{u_1}, a_{v_1}, a_{u_2}, a_{v_2} \mid \Delta x_{t-1}, \Delta y_{t-1}, \Delta u_{t-1}, \Delta v_{t-1})$$. We can do this by passing the known quantities as evidence as we sample from our Bayesian network. Therefore, we need to extend `rand` to work with both a `DiscretizedBayesNet` and evidence, which we will represent as a Dictionary.
"""

# ╔═╡ 2ebc02ce-765c-46fb-baf2-02e5c290284f
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

# ╔═╡ 93cf8a9b-a242-4b7e-a618-8ff91221fd06
if milestone_one_complete
	rand(init_cond_model)
end

# ╔═╡ cf15e39f-88af-4316-8b5c-d2e53178fb13
md"""
Our transition model samples accelerations (``a_{u_1}, a_{v_1}, a_{u_2}, a_{v_2}``) given the current relative state (Δx, Δy, Δu, Δv). For example:
"""

# ╔═╡ 724581de-9c00-4a99-b87b-a9de3bc46532
begin
	if milestone_two_complete
		# Example relative state
		Δx = 500.0
		Δy = 200.0
		Δu = -10.0
		Δv = 5.0
		
		# Sample accelerations
		trans_sample_ex = rand(trans_model, Dict(:Δx=>Δx, :Δy=>Δy, :Δu=>Δu, :Δv=>Δv))
		trans_sample_ex
	end
end

# ╔═╡ 5904be01-ccb4-4f37-9b4a-9851c4f870dc
md"""
# Simulating Complete Encounters

To generate a full encounter, we need both models; we will use the initial conditions model to get starting positions and velocities and then use the tansition model to evolve the encounter over time.
"""

# ╔═╡ 2df144f3-d376-4f30-b7e8-07dc2a6e0bb6
md"""
## `sample_step`
We first need a function that takes the transition model and the current state and returns a new state based on the sample accelerations.
"""

# ╔═╡ 14ef69f8-bdfc-4251-9089-6f25c9b90e4f
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

# ╔═╡ 2a1c2e54-a9c1-4517-a62f-1c9ef8240aee
md"""
## `sample_encounter`

Now we can start with an initial state, and get a new state using `sample_step`. Then we can repeat this process for as many steps as we would like to create an encounter! The `sapmle_encounter` function implements this process.
"""

# ╔═╡ 64bffe70-6b71-49e9-a01f-5c0c296504bb
function sample_encounter(initial_state::EncounterState, tx_model::DiscretizedBayesNet; steps=50)
    
	trajectory = Vector{EncounterState}(undef, steps + 1)
    trajectory[1] = initial_state
    
    for i in 1:steps
        trajectory[i+1] = sample_step(tx_model, trajectory[i])
    end
    
    return trajectory
end

# ╔═╡ 7e5f8806-31cb-46fd-a1dc-f86942634f41
md"""
Since we have an initial condition model, we can sample an initial state from that model and then create an encounter from that initial state. We can extend our `sample_encounter` function to take both of our learned models as inputs and generate a new encounter each time.
"""

# ╔═╡ 3456ebff-2f47-4bf1-a1d5-bbcf426aadd1
function sample_encounter(init_model::DiscretizedBayesNet, tx_model::DiscretizedBayesNet; kwargs...)

	init_sample = rand(init_model)
	init_state = encounter_from_init_sample(init_sample)
	return sample_encounter(init_state, tx_model; kwargs...)
end

# ╔═╡ 8d409570-a554-45c3-b834-bb6b916375ce
if milestone_one_complete && milestone_two_complete
	encounter_sample = sample_encounter(init_cond_model, trans_model);
end

# ╔═╡ 056fbfea-037c-420b-bfd0-c42f1d91c55e
md"""Now, let's visulize the sampled encounter using the supplied funtion `plot_encounter`."""

# ╔═╡ 679b91f6-9a36-4f06-8c8b-f7a8644e1883
if milestone_one_complete && milestone_two_complete
	plot_encounter(encounter_sample)
end

# ╔═╡ 6bdf5bbf-33f7-48ca-993d-6758a3d301a8
md"""Let's also visualize the learned network as well"""

# ╔═╡ 7b20f7f2-4260-4b62-b0d9-4857b4350b4e
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ 7a543405-d0fe-4bee-b3e1-a01a33246974
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

# ╔═╡ de5812e4-1ef5-4076-bec4-294ee07da043
html_quarter_space()

# ╔═╡ ae9bc41a-09a5-4217-a14d-5c15e2dca164
md"""
# Dataset Description

#### Example Encounters

Click the button below to view different encounters from the dataset.

$(@bind go2 Button("New Encounter"))

"""

# ╔═╡ 4c7eb92a-954e-47a4-ac32-01ea61ae548b
let
	go2
	plot_encounter(pull_encounter(flights, rand(1:1000)))
end

# ╔═╡ cf9f262f-8e57-41d8-b0d1-473845948f0e
html_half_space()

# ╔═╡ d80a50f0-dbf0-41fa-b287-5beb4edc01aa
html_expand("Expand for hint on how to ensure Δx ≥ 0", md"""
Think about what Δx represents in the encounter geometry:
- What does a negative Δx mean about the relative positioning of the aircraft?
- How could you view the same encounter from a different perspective to make Δx positive?
- If you "change your viewpoint" in this way, what other variables need to be adjusted to maintain a consistent encounter representation?

The underlying encounter geometry stays the same - we're just choosing how to describe it.
""")

# ╔═╡ a3b564aa-2e6e-4ede-bad2-1dcc1ce9ab0c
html_expand("Expand for a more explicit hint on how to ensure Δx ≥ 0", md"""
If Δx is negative, you can view the encounter from the opposite direction by reversing the sign of Δx. When you do this transformation, think about what happens to Δu:
  - If aircraft 2 was moving rightward relative to aircraft 1 before...What direction is it moving after we flip our perspective?

Try working through a simple example with two aircraft and see what happens to their relative velocity when you "flip" your viewpoint!
""")

# ╔═╡ ea332118-52da-4dee-ac3e-73d23609a3f5
start_code()

# ╔═╡ dc04a0e8-1bcb-472b-8297-b66e5c4afc9f
end_code()

# ╔═╡ b9741f71-1157-4af2-ae63-d9d5cb8acc53
html_quarter_space()

# ╔═╡ 775a17e1-8eb9-497f-98bb-19896400b96c
start_code()

# ╔═╡ 64ad7c01-3df7-4c55-be82-e88e135dc554
end_code()

# ╔═╡ 0ea7a90e-3571-4ff9-b30b-504cad2c5c1b
html_quarter_space()

# ╔═╡ ad2c2e63-bbf8-4fa9-a095-c300eb7b1363
html_expand("Hint: Learning Network Structure", md"""
Use the `fit` function to learn both structure and parameters. 

The documentation and examples can be found [here](https://sisl.github.io/BayesNets.jl/dev/usage/#Parameter-Learning).
""")


# ╔═╡ e5ff92f4-26ba-465d-83ff-8bfd3e8171c9
html_expand("Hint: More details on using fit with BayesNets", md"""
The `fit` function returns a Bayesian network and requires the following arguments:
1. The type of network to learn (`DiscreteBayesNet`)
2. The data to learn from (`df`)
3. The learning parameters (`params`)
4. The number of categories for each variable (`ncategories`)

Make sure these are passed in the correct order!
""")

# ╔═╡ fdd4a73c-c91f-4d5f-93df-101f93a3ca4a
start_code()

# ╔═╡ bff41c61-e1b1-446c-86a9-f27866623c96
end_code()

# ╔═╡ 819b133f-d94c-48bb-a9c7-b8cdf7df6eb4
html_quarter_space()

# ╔═╡ 3360b202-9289-4640-9db8-892ab09d3094
html_half_space()

# ╔═╡ ab9dbda5-8e9b-47e2-b16b-58e62c4ea57e
html_expand("Hint: Think About Time Steps", md"""
For each encounter we need to:
1. Look at pairs of consecutive timesteps (t and t+1)
2. Calculate how relative velocity changes between these timesteps
3. Record what the relative state was at time t
""")

# ╔═╡ afc5bd91-9693-4fa7-96c0-4cb451d6b068
html_expand("Hint: Calculating Relative Values", md"""
Remember:
- Relative position: position of aircraft 2 minus position of aircraft 1
- Relative velocity: velocity of aircraft 2 minus velocity of aircraft 1
- Relative acceleration: how relative velocity changes between timesteps

Remember that acceleration is $\frac{\Delta velocity}{\Delta time}$
""")

# ╔═╡ 059bdbcb-2a77-4be1-b9d3-1e18ef74559f
html_expand("Hint: Detailed Steps", md"""
For each pair of consecutive timesteps:
1. At time t:
   - Calculate relative positions (Δx, Δy)
   - Calculate relative velocities (Δu, Δv)
2. Calculate relative velocities at time t+1
3. Relative acceleration is the change in relative velocity
4. Store these values in the DataFrame
""")

# ╔═╡ de12686f-333c-43ab-aa48-517c369f76e9
start_code()

# ╔═╡ c0a02da5-99e1-4452-ac08-8bfc01d2a6e8
end_code()

# ╔═╡ c87dfa08-39cf-4b87-b3cc-38aa47beda75
html_quarter_space()

# ╔═╡ 3cf62e5c-69b6-4e4b-86ff-74c7bf855c2f
html_expand("Hint: Using LinearDiscretizer", md"""
The `LinearDiscretizer` type has two key functions:
- `encode`: converts continuous values to bin numbers
- `decode`: converts bin numbers back to continuous values

Check the lecture notebooks and the documentation for examples.
""")

# ╔═╡ 2a6e6f20-082a-4277-8f52-32ee984e3f80
html_expand("Hint: Encoding DataFrame Columns", md"""
For each column in your DataFrame:
1. Get the appropriate discretizer for that column
2. Use the discretizer to convert the continuous values to bin numbers
3. Replace the column with the encoded values

Remember: 
- The `encode` function can handle vectors of values.
- To access a column in a DataFrame, we can use `df[!, column_symbol]`
""")

# ╔═╡ 967947f3-6a57-493f-b8f5-71b8fb48fe31
html_expand("Hint: Iterating Through a Dictionary", md"""
The dictionary `D` contains pairs of column names (Symbols) and their discretizers:
```julia
# Example of what D contains:
D = Dict(
    :Δx => some_discretizer,
    :Δy => another_discretizer,
    ...)
```
To process each pair, we can iterate through the dictionary using:
```julia
for (key, value) in dict
	# some code
end
```
where:
- `key` will be the Symbol (like `:Δx`)
- `value` will be the corresponding `LinearDiscretizer`
""")



# ╔═╡ a4772b95-07a5-42d6-be65-d1e12402f3ba
start_code()

# ╔═╡ b300f901-2e8e-49ab-9e4b-dd34fe761637
end_code()

# ╔═╡ a84aa8ab-6f75-40eb-9dfb-372668584954
html_quarter_space()

# ╔═╡ 565d70e4-a6eb-4598-906c-4939b4e70e9c
html_expand("Hint: Learning Network Structure", md"""
Use the `fit` function to learn both structure and parameters. 

The documentation and examples can be found [here](https://sisl.github.io/BayesNets.jl/dev/usage/#Parameter-Learning).
""")


# ╔═╡ 8f459152-d2f7-466c-9da2-ddf603fc308a
html_expand("Hint: More details on using fit with BayesNets", md"""
The `fit` function returns a Bayesian network and requires the following arguments:
1. The type of network to learn (`DiscreteBayesNet`)
2. The data to learn from (`df`)
3. The learning parameters (`params`)
4. The number of categories for each variable

Make sure these are passed in the correct order!
""")

# ╔═╡ 84cf4097-e3b3-4c5a-869a-f3f10e2e109a
html_expand("Hint: Determining `ncategories`", md"""
The `nlabels` function returns the number of categories associated with a discretizer.

Reference the starter code for Milestone One - Part 2 on a way to apply this function to each column of the DataFrame.
""")

# ╔═╡ f7d43c27-46b5-4dc6-8db1-3f6e7e4be5e8
start_code()

# ╔═╡ fc762362-baf3-4c3d-9732-019d4041145a
end_code()

# ╔═╡ bdb1a199-9863-4de5-a8a0-eac964efb862
html_quarter_space()

# ╔═╡ 7c601832-2338-4561-a221-5d958bf36098
md"""
### Visualizing Encounters

To explore different encounters, click the button below to sample different encounters from *__your__* encounter model!

$(@bind go Button("New Encounter"))

"""

# ╔═╡ 312a6a33-edf7-4328-b7f8-9a1c08b7361a
let
	go

	if milestone_one_complete && milestone_two_complete
		plot_encounter(sample_encounter(init_cond_model, trans_model))
	end
end

# ╔═╡ 2854ec86-618d-4ece-9064-572192ef2152
html_half_space()

# ╔═╡ e8cbf2ad-200f-49e5-8f0f-5358287b39ca
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

# ╔═╡ f6a02068-1544-4656-ab70-638c456f949f
PlutoUI.TableOfContents()

# ╔═╡ Cell order:
# ╟─d923dee0-3f12-11eb-0fb8-dffb2e9b3b2a
# ╟─a3648e27-ede6-4941-82d4-3698d8be1407
# ╟─f2d4b6c0-3f12-11eb-0b8f-abd68dc8ade7
# ╠═42224774-2746-4138-ac7e-4e428bed14ea
# ╟─83374e4a-2662-47b0-ae6a-da33e12acccb
# ╟─081da510-4fb1-11eb-3334-63534dbae588
# ╟─cfff9088-511c-11eb-36f4-936646282096
# ╟─de5812e4-1ef5-4076-bec4-294ee07da043
# ╟─ae9bc41a-09a5-4217-a14d-5c15e2dca164
# ╟─4c7eb92a-954e-47a4-ac32-01ea61ae548b
# ╟─31d14960-3f13-11eb-3d8a-7531c02990cf
# ╠═eddfed22-c819-46c7-bc9b-f45d4871387f
# ╠═10cb1dd1-f60d-4701-8f88-a62e3eef5913
# ╟─746e2966-2e3f-4eb7-914e-91129f39a4a1
# ╟─cf9f262f-8e57-41d8-b0d1-473845948f0e
# ╟─9a5ee79b-a593-46b2-a9de-732f36069ded
# ╟─256a1650-a85c-484a-a4d9-384fce5f719e
# ╟─ead1b755-3a62-4843-b327-b107223a1072
# ╟─3623eaa8-0b38-4787-9839-c9aa959d1d3d
# ╟─d80a50f0-dbf0-41fa-b287-5beb4edc01aa
# ╟─a3b564aa-2e6e-4ede-bad2-1dcc1ce9ab0c
# ╟─ea332118-52da-4dee-ac3e-73d23609a3f5
# ╠═4d0a3c12-3410-4b4f-941a-1dfe6c9870bc
# ╟─dc04a0e8-1bcb-472b-8297-b66e5c4afc9f
# ╟─541d34f6-7648-4ab2-96d3-ba3c3e49ce98
# ╟─151a5840-4f9b-415e-823f-322fd4ca194d
# ╟─b9741f71-1157-4af2-ae63-d9d5cb8acc53
# ╟─e74cfb06-933d-43d9-8bb2-5f0c40775ce6
# ╟─775a17e1-8eb9-497f-98bb-19896400b96c
# ╠═d0366eb2-6829-4cce-9e9a-0954c547cb7c
# ╟─64ad7c01-3df7-4c55-be82-e88e135dc554
# ╟─d2d86873-76ff-49fe-a368-de8f3641d310
# ╟─36abf386-9cd1-4090-b7a0-51db9d2302b5
# ╟─0ea7a90e-3571-4ff9-b30b-504cad2c5c1b
# ╟─5e9fca68-4016-40ee-b0ba-1db008efee99
# ╟─ad2c2e63-bbf8-4fa9-a095-c300eb7b1363
# ╟─e5ff92f4-26ba-465d-83ff-8bfd3e8171c9
# ╟─fdd4a73c-c91f-4d5f-93df-101f93a3ca4a
# ╠═a2029e97-7907-456f-baea-7fc4a7ac7feb
# ╟─bff41c61-e1b1-446c-86a9-f27866623c96
# ╟─949de14f-8da1-4983-a2a4-637746b3bd37
# ╟─74e2f715-c62d-4003-87c8-3ab9c89f3813
# ╟─171b053d-df2a-42be-86ca-3616cbb58512
# ╟─819b133f-d94c-48bb-a9c7-b8cdf7df6eb4
# ╟─b0027ea8-54db-4db5-97dc-c7e961e71637
# ╠═1f725083-c755-4a28-94b4-0a48aa70edad
# ╟─42fa595a-c057-4feb-9396-594cbbd4140a
# ╟─2b5fdf91-7a1d-4632-a6fc-d76ff9237179
# ╠═6fef1c72-971f-4734-9ed9-bfd99bab46f9
# ╟─95790cdf-9d36-4d3e-ac3d-ddcd87d0018d
# ╠═ea2c6b22-43c7-4b1c-a234-c9a861f6e6dd
# ╟─8d0406c5-44f7-4d41-a92b-c9463fd4ce9b
# ╠═93cf8a9b-a242-4b7e-a618-8ff91221fd06
# ╟─f6d8023a-c798-4935-9e9b-4f3ab9de099e
# ╠═c0e16644-bc8c-4193-a341-27864ed38717
# ╟─3360b202-9289-4640-9db8-892ab09d3094
# ╟─d816892b-e277-47e6-8fb4-a9ec984d2a06
# ╟─ab9dbda5-8e9b-47e2-b16b-58e62c4ea57e
# ╟─afc5bd91-9693-4fa7-96c0-4cb451d6b068
# ╟─059bdbcb-2a77-4be1-b9d3-1e18ef74559f
# ╟─de12686f-333c-43ab-aa48-517c369f76e9
# ╠═668cbea8-b56c-491a-9907-513fe37e5861
# ╟─c0a02da5-99e1-4452-ac08-8bfc01d2a6e8
# ╟─260a8b0f-9620-4c6b-be6e-ada7021ac201
# ╟─dea3d3ee-40d3-4098-8c1f-8192ffb4ebd7
# ╟─c87dfa08-39cf-4b87-b3cc-38aa47beda75
# ╟─4081909a-c8df-4d44-a3da-24ef1a0c0700
# ╟─3cf62e5c-69b6-4e4b-86ff-74c7bf855c2f
# ╟─2a6e6f20-082a-4277-8f52-32ee984e3f80
# ╟─967947f3-6a57-493f-b8f5-71b8fb48fe31
# ╟─a4772b95-07a5-42d6-be65-d1e12402f3ba
# ╠═0c2f2e20-948b-4b45-b83c-db692d028c1d
# ╟─b300f901-2e8e-49ab-9e4b-dd34fe761637
# ╟─aac9e56b-008b-40f0-b168-3e8bfc4adb36
# ╟─778f308b-f448-4685-8f11-cdb071784bc1
# ╟─a84aa8ab-6f75-40eb-9dfb-372668584954
# ╟─9ebb3a2a-9a74-4084-b570-20edcc5b78af
# ╟─565d70e4-a6eb-4598-906c-4939b4e70e9c
# ╟─8f459152-d2f7-466c-9da2-ddf603fc308a
# ╟─84cf4097-e3b3-4c5a-869a-f3f10e2e109a
# ╟─f7d43c27-46b5-4dc6-8db1-3f6e7e4be5e8
# ╠═b3bebc6c-a0fb-4ed2-b9e6-c325786ec1fe
# ╟─fc762362-baf3-4c3d-9732-019d4041145a
# ╟─cca93968-f983-4513-9aa9-2dd93a8dce4c
# ╟─9290ab5e-6418-4c8a-b017-0db1705cd5cc
# ╟─7320d945-29f6-4356-ad64-5408532645c6
# ╟─bdb1a199-9863-4de5-a8a0-eac964efb862
# ╟─d6b0c927-c800-4c90-bde8-f6d33e5334c7
# ╟─006d8885-09d1-4f11-87b7-6e64d308620a
# ╠═0aa04646-e140-4ac5-beac-ac550b76c707
# ╠═c9856f5e-b4f9-43ad-a0b9-2cea19596d8d
# ╟─e0366556-5913-4a29-b282-f979acb7b0af
# ╠═2ebc02ce-765c-46fb-baf2-02e5c290284f
# ╟─cf15e39f-88af-4316-8b5c-d2e53178fb13
# ╠═724581de-9c00-4a99-b87b-a9de3bc46532
# ╟─5904be01-ccb4-4f37-9b4a-9851c4f870dc
# ╟─2df144f3-d376-4f30-b7e8-07dc2a6e0bb6
# ╠═14ef69f8-bdfc-4251-9089-6f25c9b90e4f
# ╟─2a1c2e54-a9c1-4517-a62f-1c9ef8240aee
# ╠═64bffe70-6b71-49e9-a01f-5c0c296504bb
# ╟─7e5f8806-31cb-46fd-a1dc-f86942634f41
# ╠═3456ebff-2f47-4bf1-a1d5-bbcf426aadd1
# ╠═8d409570-a554-45c3-b834-bb6b916375ce
# ╟─056fbfea-037c-420b-bfd0-c42f1d91c55e
# ╠═679b91f6-9a36-4f06-8c8b-f7a8644e1883
# ╟─6bdf5bbf-33f7-48ca-993d-6758a3d301a8
# ╟─7c601832-2338-4561-a221-5d958bf36098
# ╟─312a6a33-edf7-4328-b7f8-9a1c08b7361a
# ╟─2854ec86-618d-4ece-9064-572192ef2152
# ╟─7b20f7f2-4260-4b62-b0d9-4857b4350b4e
# ╟─7a543405-d0fe-4bee-b3e1-a01a33246974
# ╟─e8cbf2ad-200f-49e5-8f0f-5358287b39ca
# ╟─f6a02068-1544-4656-ab70-638c456f949f
# ╟─0db17351-97c4-4b2d-95f1-b57a77b45157
