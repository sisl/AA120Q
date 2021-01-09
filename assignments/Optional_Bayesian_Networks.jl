### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 4bcea5e4-4fba-11eb-2457-e9a88f33bb3b
using PlutoUI

# ╔═╡ 18448f3a-4fc0-11eb-17f1-75aad8d77a1a
using Discretizers

# ╔═╡ e6f6ccd0-4fc0-11eb-3f23-5565eab5dcda
using Random, BayesNets

# ╔═╡ 1dbc3764-504d-11eb-30ba-33dbe3f63db6
using BSON: @save

# ╔═╡ 8d9a3482-4fbc-11eb-2f97-d7ddc84ed4cf
include("02_Track_Plotting.jl");

# ╔═╡ fe8b582e-4fb7-11eb-0588-a77025e0f59d
md"""
# Optional Assignment: Learning
"""

# ╔═╡ f87323c0-4fbe-11eb-27b2-0f627f703615
md"""
In this assignment, we will use the functions you implemented in your previous assignment on track plotting. **Please ensure that you have correct implementations before starting this assignment.** If the following cell shows an error, you likely have an issue in your previous assignment.
"""

# ╔═╡ 39598b60-4fb8-11eb-3b5c-b1819e12d80e
md"""
Your task is to write code for learning the parameters of an aircraft encounter model from data. Using the provided airplane trajectories you will:
1. Learn an initial scene model
2. Learn a dynamics model
We have already loaded in the data in [`flights.csv`](http://web.stanford.edu/class/aa120q/data/flights.txt) by loadingour notebook from the previous assignment.
"""

# ╔═╡ 6c3e6918-4fbf-11eb-0a03-939880feaa00
flights

# ╔═╡ 7969af32-4fb8-11eb-0807-5fe5e82bb4e8
md"""

### What is Turned In:
Edit the contents of this notebook and turn in our final Julia notebook file (.ipynb), and any associated code files you wrote to Coursework. Do not use any external code or Julia packages other than those used in the class materials.

"""

# ╔═╡ e7a2da00-4fb8-11eb-3313-a53e19b3cdac
md"""
## Milestone One: Initial Conditions Model

First, we implement a simple initial conditions model. From the figure below, we see that aircraft 1 is always considered to be at x=0.0 and and moves with horizontal speed $u_1$ which affects how close aircraft 2, or $\Delta x$ and vertical speed $v_1$, which affects $y_1$ and $\Delta y$. In general, we see that the initial conditions can be defined by $y_1$, $u_1$, $v_1$, $\Delta x$, and $\Delta y$.

You need to develop your own initial conditions model, then write your code here to implement the data structure for the probabilty distribution. We have provided the following starter code and would like you to use the speeds and positions of the aircraft at t=40s and go back linearly to determine intial positions at $t=0$ seconds, using the given speeds for both aircraft at 40 seconds.
"""

# ╔═╡ 24f31946-4fba-11eb-1b0f-d18002e3619f
PlutoUI.LocalResource("./figures/encounter_def.png")

# ╔═╡ 55f31492-4fba-11eb-15f2-ebaad23be77a
md"""
Again, this simple model thus defines a probability distribution as follows:

$$P(y_1, u_1, v_1, \Delta x, \Delta y, \Delta u, \Delta v)$$

We have learned the probability distribution over the initial conditions model for you already. First, in **Pull Raw Data**, we create a categorical distrubution and then with **Discretize Dataset**, as the name states, we discretize the continuous variables into bins that we have defined for you below. Finally, we train a discrete Bayesian network over the discrete dataset in **Fit Distributions**.

We have done this for the initial conditions model for you already. Please take the time to read through each step because you will be asked to go through this process for the Dynamics Model.
"""

# ╔═╡ 83edc23c-4fba-11eb-057d-61757cace62b
md"""
### Pulling the Raw Data
In this section, we obtain initial conditions for the first 100 encounters and store them in a dataframe.
"""

# ╔═╡ 8f8cd4c2-4fba-11eb-10c1-d50dab1ae735
encounters = [pull_encounter(flights, i) for i in 1:1000];

# ╔═╡ aa83ab78-4fba-11eb-0ad9-4385370390f2
N = length(encounters)

# ╔═╡ aa8442c4-4fba-11eb-05d9-c18a7fb06b54
#Initializes a data frame to store the inital conditions
data_initial = DataFrame(
    y1 = Float64[],
    u1 = Float64[],
    v1 = Float64[],
    Δx = Float64[],
    Δy = Float64[],
    Δu = Float64[],
    Δv = Float64[],
)

# ╔═╡ aa85306c-4fba-11eb-2a15-b11aa37d2d09
for enc in encounters
    P1 = enc[1].plane1
    P2 = enc[1].plane2
    
    y1, u1, v1 = P1.y, P1.u, P1.v
    Δx = P2.x - P1.x
    Δy = P2.y - P1.y
    Δu = P2.u - P1.u
    Δv = P2.v - P1.v
    if Δx < 0
        Δx *= -1
        Δu *= -1
    end
    
    push!(data_initial, [y1,u1,v1,Δx,Δy,Δu,Δv])
end

# ╔═╡ aa906d6a-4fba-11eb-0eb3-b1bb48e1edf3
data_initial

# ╔═╡ 0703f6e8-4fc0-11eb-0984-15dd64a25652
md"""
### Discretize Dataset
"""

# ╔═╡ 1eb0c744-4fc0-11eb-08c6-5985baf1332e
D = Dict{Symbol,LinearDiscretizer}(
    sym=>LinearDiscretizer(binedges(DiscretizeUniformWidth(6), data_initial[sym]))
    for sym in propertynames(data_initial))

# ╔═╡ b5f20820-4fc0-11eb-133a-492be429f675
for (sym, disc) in D
    data_initial[sym] = encode(disc, data_initial[sym]) 
end

# ╔═╡ be71c3d2-4fc0-11eb-0f29-5b260eedcf2f
ncategories = [nlabels(D[:y1]), nlabels(D[:u1]), nlabels(D[:v1]),
               nlabels(D[:Δx]), nlabels(D[:Δy]), nlabels(D[:Δu]), nlabels(D[:Δv])]

# ╔═╡ c9d69f7c-4fc0-11eb-3d2a-8d4380386dc5
data_initial

# ╔═╡ 05475f10-4fc1-11eb-06ac-37ca41101838
Random.seed!(0);

# ╔═╡ 0cfcc33a-4fc1-11eb-32ec-e7e37e8a5750
params = GreedyHillClimbing(ScoreComponentCache(data_initial), max_n_parents=3, prior=UniformPrior());

# ╔═╡ 1b008ad4-4fc1-11eb-153c-452d51b712ed
bn_initial = fit(DiscreteBayesNet, data_initial, params, ncategories=ncategories)

# ╔═╡ 6f53b220-4fc1-11eb-2124-d9436521f935
md"""
### Sampling
#### Sampling from initial to get initial scene
We now have to implement `Base.rand(model)` which should generate random Encounters from our given initial conditions model.
"""

# ╔═╡ 402862a6-4fc5-11eb-3a73-475718f216b3
struct DiscretizedBayesNet
    dbn::DiscreteBayesNet
    discs::Dict{Symbol, LinearDiscretizer}
end

# ╔═╡ 681eb74c-4fc5-11eb-3239-3313c508ee47
function Base.rand(bn::DiscretizedBayesNet)
    sample = rand(model.dbn) # pull from discrete Bayes net
    
    # convert discrete samples to continuous samples
    for (sym, disc) in bn.discs
        sample[sym] = decode(disc, sample[sym]) 
    end

    return sample
end

# ╔═╡ 6f74b822-4fc5-11eb-142a-9b9a352f94f2
md"""
## Milestone Two: Dynamics Model

Now that you are familiar with the implementation of the Initial Conditions Model, we would like you to train and learn over the probability distribution of a Dynamics Model. We can define the dynamics model by the horizontal and vertical accelerations given the change in distance and change in velocities. A simple uncorrelated dynamics model represents:

$$P(\Delta u_t, \Delta v_t \mid \Delta x_{t-1}, \Delta y_{t-1}, \Delta u_{t-1}, \Delta v_{t-1})$$

We will train:

$$P(\Delta u_t, \Delta v_t, \Delta x_{t-1}, \Delta y_{t-1}, \Delta u_{t-1}, \Delta v_{t-1})$$

Again, we would like to improve the model like how we did with the intial conditions model. Here are a few ways of improving the given model:
1. Add additional three conditional variables: acceleration, climbrate, and turnrate
2. Include other variables (current altitude, aircraft type, etc.)
Develop your own dynamics model of probability dsitribution using a Discrete Bayesian.

Use the following code as a starting point.
"""

# ╔═╡ 9666b50a-4fc5-11eb-1ebd-6dc7222d85b4
md"""
### Pull Raw Data

We would now like you to pull the data from the flights dataset in order to fill the `data_transition` data array. You can use the code from the initial model as a reference. We want to load the both the horizontal and vertical acceleration for both aircraft. Think in terms of how we could do that given u1, v1, and u2, v2. (Remember that acceleration is $\frac{\Delta velocity}{\Delta time}$.

We have provided the size of the array below and the DataFrame, now you just need to load the data in below. (Hint: you will find the findnext() function useful in a for loop while loading data from flights into data_transition)
"""

# ╔═╡ f7d1267c-4fc5-11eb-036b-1b7c0cfc386f
data_transition = DataFrame(
    du2 = Float64[], # current change in horizontal accel  [m/s2]
    dv2 = Float64[], # currenct change in vertical accel   [m/s2]
    du1 = Float64[], # previous change in horizontal speed  [m/s2]
    dv1 = Float64[], # previous change in vertical speed   [m/s2]
)

# ╔═╡ 473bc906-4fc6-11eb-157b-13ca9d4425a4
html"""
<h5><font color=crimson>💻 Fill in <code>data_transition</code></font></h5>
"""

# ╔═╡ 0284a940-4fc6-11eb-3605-79bf870f9505
# STUDENT CODE START
for enc in encounters
    for i = 1:50
		P1 = enc[i].plane1
		P2 = enc[i].plane2
		
		P1_next = enc[i+1].plane1
		P2_next = enc[i+1].plane2

		du2 = P2_next.u - P2.u
		dv2 = P2_next.v - P2.v
		du1 = P1_next.u - P1.u
		dv1 = P1_next.v - P1.v

		push!(data_transition, [du2, dv2, du1, dv1])
	end
end
# STUDENT CODE END

# ╔═╡ d83e829a-5048-11eb-05aa-457181d23025
data_transition

# ╔═╡ c3547144-504a-11eb-28ed-6f5dd835c681
maximum(data_transition[:, :du1])

# ╔═╡ ace2355a-504b-11eb-27a1-67f2b71adbd1
minimum(data_transition[:, :du1])

# ╔═╡ 4ae66b6a-5048-11eb-3f8a-cd7afabcea30
md"""
### Discretize data
"""

# ╔═╡ 4645d214-504b-11eb-1d41-33ec5d1a4bfb
begin
	D_trans = Dict{Symbol,LinearDiscretizer}()
	D_trans[:du2] = 
		LinearDiscretizer(collect(range(-0.5, stop = 0.5, length = 6))) # [m/s2]
	D_trans[:dv2] = 
		LinearDiscretizer(collect(range(-2.3, stop = 2.6, length = 6))) # [m/s2]
	D_trans[:du1] = 
		LinearDiscretizer(collect(range(-0.5, stop = 0.5, length = 6))) # [m/s2]
	D_trans[:dv1] = 
		LinearDiscretizer(collect(range(-2.3, stop = 2.6, length = 6))) # [m/s2]
end

# ╔═╡ 6b2ccbcc-504c-11eb-1734-8308c1b46be6
for (sym, disc) in D_trans
    data_transition[sym] = encode(disc, data_transition[sym]) 
end

# ╔═╡ 71938726-504c-11eb-2457-ab597399f142
n_trans_categories = [nlabels(D_trans[:du2]), nlabels(D_trans[:dv2]),
                      nlabels(D_trans[:du1]), nlabels(D_trans[:dv1])];

# ╔═╡ 8778ebbc-504c-11eb-09bf-2da426e46ccf
data_transition

# ╔═╡ 8be03888-504c-11eb-3715-e9381c725d93
md"""
## Fit Distributions
"""

# ╔═╡ 9a0aa4d2-504c-11eb-2424-0368d7c060e0
params_trans = GreedyHillClimbing(ScoreComponentCache(data_transition), max_n_parents=3, 
prior=UniformPrior())

# ╔═╡ d1ddc452-504c-11eb-2aa3-8508f8758212
bn_transition = fit(DiscreteBayesNet, data_transition, params_trans, ncategories=n_trans_categories)

# ╔═╡ ef5f6508-504c-11eb-057c-7d3f3ee2ac9b
md"""
### Sampling
"""

# ╔═╡ f971e872-504c-11eb-0e93-2b259d1a3589
function Base.rand(bn::DiscretizedBayesNet, evidence::Assignment)
    
    # discretize the assignment
    for (sym, disc) in bn.discs
        evidence[sym] = encode(disc, evidence[sym]) 
    end
    
    sample = rand(model.dbn, evidence) # pull from discrete Bayes net
    
    # convert discrete samples to continuous samples
    
    # STUDENT CODE START
    for (sym, disc) in bn.discs
        sample[sym] = decode(disc, sample[sym]) 
    end
    # STUDENT CODE END
    
    return sample
end

# ╔═╡ 4cd1091c-504d-11eb-3a55-252b479bc4ef
D_initial = D

# ╔═╡ 6c6c7aae-504d-11eb-0b45-4158ced31329
D_transition = D_trans

# ╔═╡ 2c4fdf06-504d-11eb-1eb1-dda2dfb6c84a
@save "myencountermodel.bson" bn_initial D_initial bn_transition D_transition

# ╔═╡ a243f7f8-a499-4cce-a915-2068b2e89a19
md"""
### You have completed the assignment!
---
"""

# ╔═╡ 382c475d-5d44-44d6-af7e-c5c281fcdb8b
PlutoUI.TableOfContents(title="Bayesian Networks")

# ╔═╡ Cell order:
# ╟─fe8b582e-4fb7-11eb-0588-a77025e0f59d
# ╠═4bcea5e4-4fba-11eb-2457-e9a88f33bb3b
# ╟─f87323c0-4fbe-11eb-27b2-0f627f703615
# ╠═8d9a3482-4fbc-11eb-2f97-d7ddc84ed4cf
# ╟─39598b60-4fb8-11eb-3b5c-b1819e12d80e
# ╠═6c3e6918-4fbf-11eb-0a03-939880feaa00
# ╟─7969af32-4fb8-11eb-0807-5fe5e82bb4e8
# ╟─e7a2da00-4fb8-11eb-3313-a53e19b3cdac
# ╟─24f31946-4fba-11eb-1b0f-d18002e3619f
# ╟─55f31492-4fba-11eb-15f2-ebaad23be77a
# ╟─83edc23c-4fba-11eb-057d-61757cace62b
# ╠═8f8cd4c2-4fba-11eb-10c1-d50dab1ae735
# ╠═aa83ab78-4fba-11eb-0ad9-4385370390f2
# ╠═aa8442c4-4fba-11eb-05d9-c18a7fb06b54
# ╠═aa85306c-4fba-11eb-2a15-b11aa37d2d09
# ╠═aa906d6a-4fba-11eb-0eb3-b1bb48e1edf3
# ╟─0703f6e8-4fc0-11eb-0984-15dd64a25652
# ╠═18448f3a-4fc0-11eb-17f1-75aad8d77a1a
# ╠═1eb0c744-4fc0-11eb-08c6-5985baf1332e
# ╠═b5f20820-4fc0-11eb-133a-492be429f675
# ╠═be71c3d2-4fc0-11eb-0f29-5b260eedcf2f
# ╠═c9d69f7c-4fc0-11eb-3d2a-8d4380386dc5
# ╠═e6f6ccd0-4fc0-11eb-3f23-5565eab5dcda
# ╠═05475f10-4fc1-11eb-06ac-37ca41101838
# ╠═0cfcc33a-4fc1-11eb-32ec-e7e37e8a5750
# ╠═1b008ad4-4fc1-11eb-153c-452d51b712ed
# ╟─6f53b220-4fc1-11eb-2124-d9436521f935
# ╠═402862a6-4fc5-11eb-3a73-475718f216b3
# ╠═681eb74c-4fc5-11eb-3239-3313c508ee47
# ╟─6f74b822-4fc5-11eb-142a-9b9a352f94f2
# ╟─9666b50a-4fc5-11eb-1ebd-6dc7222d85b4
# ╠═f7d1267c-4fc5-11eb-036b-1b7c0cfc386f
# ╟─473bc906-4fc6-11eb-157b-13ca9d4425a4
# ╠═0284a940-4fc6-11eb-3605-79bf870f9505
# ╠═d83e829a-5048-11eb-05aa-457181d23025
# ╠═c3547144-504a-11eb-28ed-6f5dd835c681
# ╠═ace2355a-504b-11eb-27a1-67f2b71adbd1
# ╟─4ae66b6a-5048-11eb-3f8a-cd7afabcea30
# ╠═4645d214-504b-11eb-1d41-33ec5d1a4bfb
# ╠═6b2ccbcc-504c-11eb-1734-8308c1b46be6
# ╠═71938726-504c-11eb-2457-ab597399f142
# ╠═8778ebbc-504c-11eb-09bf-2da426e46ccf
# ╟─8be03888-504c-11eb-3715-e9381c725d93
# ╠═9a0aa4d2-504c-11eb-2424-0368d7c060e0
# ╠═d1ddc452-504c-11eb-2aa3-8508f8758212
# ╟─ef5f6508-504c-11eb-057c-7d3f3ee2ac9b
# ╠═f971e872-504c-11eb-0e93-2b259d1a3589
# ╠═1dbc3764-504d-11eb-30ba-33dbe3f63db6
# ╠═4cd1091c-504d-11eb-3a55-252b479bc4ef
# ╠═6c6c7aae-504d-11eb-0b45-4158ced31329
# ╠═2c4fdf06-504d-11eb-1eb1-dda2dfb6c84a
# ╟─a243f7f8-a499-4cce-a915-2068b2e89a19
# ╠═382c475d-5d44-44d6-af7e-c5c281fcdb8b
