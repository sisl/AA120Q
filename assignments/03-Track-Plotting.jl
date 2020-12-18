### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ f2d4b6c0-3f12-11eb-0b8f-abd68dc8ade7
using PlutoUI

# ╔═╡ 22e45fde-3f14-11eb-304e-917d13dccee4
# Load flights.csv as a DataFrame
using DataFrames, CSV

# ╔═╡ 564e3080-3f15-11eb-1fb6-5b851a6e23ad
using Plots; gr()

# ╔═╡ c3104aa0-3f15-11eb-2b59-cfa5ec97547d
using LinearAlgebra # for `norm`

# ╔═╡ d923dee0-3f12-11eb-0fb8-dffb2e9b3b2a
md"""
# Assignment 2: TCAS Encounters
"""

# ╔═╡ f4ae58c0-3f12-11eb-2d1b-65a2947915e3
PlutoUI.LocalResource("./figures/TCAS_Volume.png")

# ╔═╡ 01fba690-3f13-11eb-0b60-a14415602118
md"""
## Week 3 Assignment: Encounter Plotting

### **Your task is to:**

1.  Load example aircraft tracks from a file and plot them.
2.  Propose a statistical model for capturing features from the data.

### **What is turned in:**
Edit the contents of this notebook and turn in your final Julia notebook file (.jl), and any associated code files you wrote to Coursework. Do not use any external code or Julia packages other than those used in the class materials. For the second part of this assignment, please submit a document describing your proposed statistical model. 

"""

# ╔═╡ 31d14960-3f13-11eb-3d8a-7531c02990cf
md"""
### Aircraft Tracks

$(PlutoUI.LocalResource("./figures/encounter_plot.png"))

An airspace encounter consists of two components: the initial conditions and the transitions over time.
One file is provided for each.

The data file, [`flights.csv`](http://web.stanford.edu/class/aa120q/data/flights.txt), contains a table with the following columns:

| Variable | Type | Description |
| -------- |:----:| ----------- |
| **id**   | Int    | trace id, same as in `initial.txt` |
| **t**    | Int    | time in 1s intervals from 0 to 50 |
| **x1**   | Float  | aircraft 1 position along x-axis |
| **x2**   | Float  | aircraft 2 position along x-axis |
| **y1**   | Float  | aircraft 1 position along y-axis |
| **y2**   | Float  | aircraft 2 position along y-axis |
| **u1**   | Float   | airplane 1 vertical speed [m/s] |
| **u2**   | Float   | airplane 2 vertical speed [m/s] |
| **v1**   | Float   | airplane 1 horizontal speed [m/s] |
| **v2**   | Float   | airplane 2 horizontal speed [m/s] |
"""

# ╔═╡ b325cea0-3f13-11eb-2b57-4dc1b8fb3bb5
md"""
Write a program to load these trajectories and plot them.

1.  Your algorithm must be implemented from scratch in Julia.
2.  Although you may discuss your algorithm with others, you must not share code.

Directions

* Implement `pull_trajectory` to load a specific `Trajectory` from flights
* Modify `plot_trajectory` to indicate the location of minimim separation
"""

# ╔═╡ c01ff35e-3f13-11eb-0c18-8d438600c210
md"""
# Milestone One: Implement Pull_Trajectory

Your task is to implement `pull_trajectory(flights::DataFrame, id::Int)`. The function `pull_encounter` takes in two parameters, the `DataFrame` that stores the transitions over time and the trace `id`. This function will prepare an "Encounter" data structure for plotting, by initializing an array of 51 `EncounterStates` that reveals the `AircraftState` of both airplanes at each second in the 51 second time interval. 
"""

# ╔═╡ e9f18460-3f13-11eb-315b-1f0dedb99c48
md"""
## Data Structures

Below, we will first load the data from our "flights.csv" text file which stores information about the position and velocities of both aircraftat at each time step. We have also defined two types, `AircraftState` which describes the position and velocity of an aircraft and `EncounterState`, which defines the states of both aircraft at a given time step. We also have a constant called `Trajectory` which is a vector of `EncounterStates`. You will be using the data structure along with these two types to load the data into the `Trajectory` constant and analyze the trajectories of both aircraft.
"""

# ╔═╡ 0b426ad0-3f14-11eb-3ec3-d9d0697376eb
md"""
### DataFrames

Remember that an airplane encounter consists of the initial conditions and the transitions over time. To implement `pull_encounter`, you will be given one data frame `EncounterState`, that stores the states of both aircraft over each second of the time interval. You will need to load an array with the values of both aircraft states.
"""

# ╔═╡ 1e76f3a0-3f14-11eb-0ac6-73acb51003b1
md"""
#### Inital Conditions DataFrame
"""

# ╔═╡ 258a2b80-3f14-11eb-0e0e-5f5d5d2c9de2
flights = CSV.read(joinpath(@__DIR__, "..", "data", "flights.csv"), DataFrame)

# ╔═╡ 75f490b0-3f14-11eb-12be-27f3646793f1
md"""
### Types

##### `AircraftState`

This is a type which describes the aircraft state. You will need to create air craft states for each time step given by the data set above. 
"""

# ╔═╡ 832be580-3f14-11eb-1432-45c804cfef07
struct AircraftState
    x::Float64  # horizontal position [m]
    y::Float64  # veritcal position   [m]
    u::Float64  # horizontal speed    [m/s]
    v::Float64  # vertical speed      [m/s]
end

# ╔═╡ 89fbf9e0-3f14-11eb-3356-8976f78ac06e
md"""
##### `EncounterState`

This is a type which describes an encounter between two aircraft by defining the two aircrafts's current state at the given time interval. This is the data structure that you will need to initialize in `pull_encoutner`.
"""

# ╔═╡ 9a3a2610-3f14-11eb-39c5-4f8d78790b10
mutable struct EncounterState
    plane1::AircraftState
    plane2::AircraftState
    t::Float64
end

# ╔═╡ 9ebc79e0-3f14-11eb-3ba2-59f292cf3cd6
md"""
##### `Trajectory`
"""

# ╔═╡ a1bcc190-3f14-11eb-2663-9bf3dc4e4ab7
const Trajectory = Vector{EncounterState}

# ╔═╡ adef026e-3f14-11eb-10e2-3b600bdc9b28
md"""
## `pull_trajectory`

We have already loaded the data from "flights.csv" into a variable called flights above. Your task now is to get the data in flights, and store it into a `Trajectory` constant. This means that you will need to go through each time step and store the state of both aircraft into an `EncounterState` and load that into a vector. Your function should produce a vector of length 51 for each state of both your ego and intruder from time 0 to 50. 

This function will return a `Trajectory`, or a vector of `EncounterStates`. You will need to initialize the trajectory vector with the data from the flights.csv file that we loaded above. You will load them into a vector of 51 elements, one for each time step. 
"""

# ╔═╡ cbeee920-3f14-11eb-399e-e58572fdee25
html"""
<h5><font color=crimson>💻 Implement this function <code>pull_trajectory(flights::DataFrame, id::Int)</code></font></h5>
"""

# ╔═╡ d0557792-3f14-11eb-2771-41457c500985
function pull_trajectory(flights::DataFrame, id::Int)

    flightids = flights[:id] # Gets the data from the specific ID we pass in	
	traj = Trajectory()

    # STUDENT CODE START
    # STUDENT CODE END

    return traj # returns the vector of EncounterStates
end

# ╔═╡ 2a1d04a2-3f15-11eb-1906-6560c5a1ed28
pull_trajectory(flights, 1) # Test if function works

# ╔═╡ 2fb1b2d0-3f15-11eb-3e08-17fec41f2ff8
md"""
## Implement `plot_separations`

Now that you have the aircraft states loaded into an array you can graphically display the trajectories of the two aircraft over a period of time. We have done this for you with the plot_trajectory function below have given you the code. We would now like you to implement plot_separations, which will display the horizontal, vertical, and total separations of the two aircraft on the same plot. 

Take time to step through the function yourself and see how it is implemented because in the next part you will be asked to implement plot_separations, which will display the distance between the two aircraft horizontally, vertically, and in total.

### `plot_trajectory`

This is the plot for the trajectories of both aircraft. It displays the path that both aircraft follow on an x-y plane. 

(Use the code provided below as a reference for your implementation of `plot_separations`)
"""

# ╔═╡ 59e86e40-3f15-11eb-3866-bb34687092e7
# Finds the overall serparation between two aircraft
get_separation(state::EncounterState) = hypot(state.plane1.x - state.plane2.x,
                                              state.plane1.y - state.plane2.y)

# ╔═╡ 62fe05d0-3f15-11eb-2d82-a150166203f5
# Determines what is the minimum serparation between the two aircraft
get_min_separation(traj::Trajectory) = minimum(get_separation(s) for s in traj) 

# ╔═╡ 67ca5af2-3f15-11eb-0216-7d861a98b690
# Finds the index of the minimum serparation 
find_min_separation(traj::Trajectory) = argmin([get_separation(s) for s in traj])

# ╔═╡ 53961560-3f15-11eb-2417-373528498f93
function plot_trajectory(traj::Trajectory) 
    d = get_min_separation(traj)  # closest dist 
    i = find_min_separation(traj) # index of closest dist

    palette=[colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = collect(1:length(traj)) .- 1 # time interval
    
    # Gets the x and y values for both planes 
    x1_arr = map(s->s.plane1.x, traj)
    y1_arr = map(s->s.plane1.y, traj)
    x2_arr = map(s->s.plane2.x, traj)
    y2_arr = map(s->s.plane2.y, traj)

    # Plots the trajectories 
    p1 = plot(Vector{Float64}[x1_arr, x2_arr, [traj[i].plane1.x, traj[i].plane2.x]],
              Vector{Float64}[y1_arr, y2_arr, [traj[i].plane1.y, traj[i].plane2.y]],
              xlabel="x [m]", ylabel="y [m]",
		      label=["Plane1" "Plane2" "Min Separation"],
              palette=palette, linewidth=4)
    
    # Plots the point where the minimum separation occurs 
    scatter!(p1, Vector{Float64}[Float64[traj[1].plane1.x],
			 Float64[traj[1].plane2.x]],
		     Vector{Float64}[Float64[traj[1].plane1.y], Float64[traj[1].plane2.y]],
             label=["Plane1 Initial", "Plane2 Initial"])

    plot(p1, size=(800,400))
end

# ╔═╡ 84cafa12-3f15-11eb-2954-d52c7b90ed68
# To test function
trajectory = pull_trajectory(flights,1)

# ╔═╡ 90c64c70-3f15-11eb-0962-49d8ea62f6b0
plot_trajectory(trajectory) # this will fail if `trajectory` is an empty vector

# ╔═╡ 9d2a4bb0-3f15-11eb-2f79-2bb801a6582e
md"""
Now that you are familiar with `plot_trajectory`, you will need to implement `plot_separation`, which plots the distance between the two aircraft over time time. To implement the separation vs. time graph, we would like you to plot three lines:

1. the total seperation  $\left(\sqrt{\Delta x^2 + \Delta y^2}\right)$
2. x-position separation $\left(\Delta x\right)$
3. y-position separation $\left(\Delta y\right)$

**Note:** You'll find `hypot`, `abs`, `indmin`, and `norm` useful in your implementation. If you're unfamiliar with these functions, look them up on the Julia documentation. 
"""

# ╔═╡ ee4dc7b0-3f15-11eb-2824-716bcf3a5c6c
md"""
Make use of these functions in your implementation:
- `get_min_separation`
- `find_min_separation`.
"""

# ╔═╡ e15af5f0-3f15-11eb-3588-d90ea5b66545
html"""
<h5><font color=crimson>💻 Implement this function <code>plot_separations(traj::Trajectory)</code></font></h5>
"""

# ╔═╡ e682b180-3f15-11eb-1244-edbee1195ed2
function plot_separations(traj::Trajectory)
    
    palette = [colorant"0x52E3F6", colorant"0x79ABFF", colorant"0xFF007F"]
    t_arr = collect(1:length(traj)) .- 1
    
    # REPLACE THE COMMENTS WITH YOUR CODE
    
    # sep_arr =    # total separation for each time interval
    # sep_x_arr =  # x-position separation for each time interval
    # sep_y_arr =  # y-position separation for each time interval
    
    # STUDENT CODE START
    # STUDENT CODE END
    
    # Plots the three separations
    plot(t_arr, Vector{Float64}[sep_arr, sep_x_arr, sep_y_arr],
         xlabel="Time [s]",
		 ylabel="Separation [m]", 
         lab=["Total Separation [m]",
			  "Horizontal Separation [m]",
			  "Vertical Separation [m]"],
         palette=palette, linewidth=4,size=(800,400))
end

# ╔═╡ 9fead5d0-3f16-11eb-3ace-dd3c5998d723
trajectory2 = pull_trajectory(flights,1)

# ╔═╡ a64ee1f0-3f16-11eb-14e6-ab43afc20b77
plot_separations(trajectory2) # test (will fail if not fully implemented yet)

# ╔═╡ bf9697c0-3f16-11eb-2f00-23dd7b44cba4
md"""
## Propose an Encounter Model

Now that you are familiar with the Probabilistic Models discussed in class (and described in section 2.1 of DMU), you will propose an encounter model. Your model should be designed such that you can sample from it and produce initial positions for each aircraft. Your model should also support propagating the aircraft forward — i.e. describe how the encounter changes over time from the initial setup.

You must explain the reasoning behind your decision, how it captures the initial and transition distributions, and how it can be learned from large initial and transition data tables.
"""

# ╔═╡ Cell order:
# ╟─d923dee0-3f12-11eb-0fb8-dffb2e9b3b2a
# ╠═f2d4b6c0-3f12-11eb-0b8f-abd68dc8ade7
# ╠═f4ae58c0-3f12-11eb-2d1b-65a2947915e3
# ╟─01fba690-3f13-11eb-0b60-a14415602118
# ╟─31d14960-3f13-11eb-3d8a-7531c02990cf
# ╟─b325cea0-3f13-11eb-2b57-4dc1b8fb3bb5
# ╟─c01ff35e-3f13-11eb-0c18-8d438600c210
# ╟─e9f18460-3f13-11eb-315b-1f0dedb99c48
# ╟─0b426ad0-3f14-11eb-3ec3-d9d0697376eb
# ╟─1e76f3a0-3f14-11eb-0ac6-73acb51003b1
# ╠═22e45fde-3f14-11eb-304e-917d13dccee4
# ╠═258a2b80-3f14-11eb-0e0e-5f5d5d2c9de2
# ╟─75f490b0-3f14-11eb-12be-27f3646793f1
# ╠═832be580-3f14-11eb-1432-45c804cfef07
# ╟─89fbf9e0-3f14-11eb-3356-8976f78ac06e
# ╠═9a3a2610-3f14-11eb-39c5-4f8d78790b10
# ╟─9ebc79e0-3f14-11eb-3ba2-59f292cf3cd6
# ╠═a1bcc190-3f14-11eb-2663-9bf3dc4e4ab7
# ╟─adef026e-3f14-11eb-10e2-3b600bdc9b28
# ╟─cbeee920-3f14-11eb-399e-e58572fdee25
# ╠═d0557792-3f14-11eb-2771-41457c500985
# ╠═2a1d04a2-3f15-11eb-1906-6560c5a1ed28
# ╟─2fb1b2d0-3f15-11eb-3e08-17fec41f2ff8
# ╠═564e3080-3f15-11eb-1fb6-5b851a6e23ad
# ╠═59e86e40-3f15-11eb-3866-bb34687092e7
# ╠═62fe05d0-3f15-11eb-2d82-a150166203f5
# ╠═67ca5af2-3f15-11eb-0216-7d861a98b690
# ╠═53961560-3f15-11eb-2417-373528498f93
# ╠═84cafa12-3f15-11eb-2954-d52c7b90ed68
# ╠═90c64c70-3f15-11eb-0962-49d8ea62f6b0
# ╟─9d2a4bb0-3f15-11eb-2f79-2bb801a6582e
# ╠═c3104aa0-3f15-11eb-2b59-cfa5ec97547d
# ╟─ee4dc7b0-3f15-11eb-2824-716bcf3a5c6c
# ╟─e15af5f0-3f15-11eb-3588-d90ea5b66545
# ╠═e682b180-3f15-11eb-1244-edbee1195ed2
# ╠═9fead5d0-3f16-11eb-3ace-dd3c5998d723
# ╠═a64ee1f0-3f16-11eb-14e6-ab43afc20b77
# ╟─bf9697c0-3f16-11eb-2f00-23dd7b44cba4
