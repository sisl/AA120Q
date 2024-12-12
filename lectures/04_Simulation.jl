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

# ╔═╡ b5aee6fa-7ab3-4bfb-bb4c-a1f11cbbe503
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ ce9f5737-b699-4193-9cb2-0a4a9e0cf67b
begin
	using LinearAlgebra
	using Random
	using Distributions
	using Compose
	using Plots
	plotly()
end

# ╔═╡ d0efeeb0-38c5-11eb-3b9a-5bcbc9103863
md"""
# Simulation
AA120Q: *Building Trust in Autonomy*

Simulation is a powerful tool used to model, analyze, and predict the behavior of complex systems. By creating a virtual environment that replicates real-world dynamics, we can:
- Test hypotheses without risking resources or safety.
- Explore "what-if" scenarios to make better decisions.
- Validate models and algorithms in controlled settings.

## Why Simulate?
Simulations are particularly useful in systems that are:
- **Too expensive or dangerous** to experiment with in real life (e.g., aerospace systems, autonomous vehicles).
- **Highly complex**, involving multiple interacting components (e.g., multi-agent systems, weather models).
- **Stochastic or uncertain**, where randomness plays a critical role (e.g., market simulations, disease spread).

## What This Notebook Covers
This notebook introduces the key elements of simulation, including:
1. **Simulation Loop**: The core steps that drive any simulation.
2. **Stochastic Models**: Incorporating randomness using distributions and sampling techniques.
3. **Visualization**: Tools to analyze and present simulation results effectively.

By the end of this notebook, you will understand how to structure and implement simulations for both deterministic and stochastic systems, laying the groundwork for more advanced topics in modeling and autonomy.
"""

# ╔═╡ 106ae033-af16-49a5-8edf-bef905af8473
md"#### Packages Used in this Notebook"

# ╔═╡ e03d1a29-add9-4845-89b0-484bb6159fec
md"""
# The Simulation Loop

The driver of any simulation is the **simulation loop**, a repetitive process that evolves the state of a system over time. This loop allows us to model dynamic systems by:
1. **Updating the system's state** based on predefined rules (e.g., physical laws, agent behaviors).
2. **Observing the system's outputs** to analyze and evaluate performance.

The simulation loop typically consists of the following steps:
1. **Initialization**: Define the initial conditions and parameters of the system.
2. **Action**: Calculate how external forces or agents act on the system.
3. **State Propagation**: Update the system’s state based on the actions.
4. **Observation**: Record relevant data for analysis or visualization.
5. **Termination Check**: Repeat the loop until a stopping condition is met (e.g., end time or convergence).

This loop structure is flexible and can be tailored to both deterministic and stochastic systems.
"""

# ╔═╡ 6b48009d-8659-49b9-8cab-c2f371493088
md"""
### Steps in the Simulation Loop

#### 1. Initialization
Before starting the loop, we define the system's initial state and parameters. For example:
- The initial position and velocity of a bouncing ball.
- The number and initial positions of bodies in an $n$-body simulation.
- The initial beliefs or policies of agents in a multi-agent system.

#### 2. Action
In this step, the system responds to external forces or agent decisions:
- For physical systems, this could mean calculating gravitational or frictional forces.
- For agents, this could involve decision-making based on current beliefs or policies.

#### 3. State Propagation
The system's state is updated based on the computed actions. This step often involves:
- Solving equations of motion for physical systems.
- Updating beliefs or internal states for agents.

#### 4. Observation
Data is recorded for analysis or visualization. Examples include:
- The position and velocity of objects over time.
- Metrics like energy, distance, or system efficiency.

#### 5. Termination Check
The loop continues until a stopping condition is met, such as:
- Reaching a maximum number of iterations or a predefined end time.
- Achieving convergence or a steady-state condition.
"""

# ╔═╡ ad676bca-ddf7-4289-96b7-534cbbaa5705
md"""
### Example: Simple Simulation Loop

Below, we simulate a simple system where a particle moves under constant acceleration. The loop updates the position and velocity of the particle at each timestep.
"""

# ╔═╡ 2e69dc10-f376-4137-9acd-20979cc4aa5c
begin
	# Parameters
	dt_simple = 0.1  # timestep
	t_max_simple = 10.0  # maximum simulation time
	a_simple = -9.81  # acceleration (gravity)
	v0_simple = 20.0  # initial velocity
	x0_simple = 0.0  # initial position
	
	# Initialization
	t_simple = 0.0
	x_simple = x0_simple
	v_simple = v0_simple
	
	# Vectors to store results
	positions_simple = Float64[]
	velocities_simple = Float64[]
	times_simple = Float64[]
	
	# Simulation loop
	while t_simple < t_max_simple && x_simple >= 0.0
	    push!(positions_simple, x_simple)
	    push!(velocities_simple, v_simple)
	    push!(times_simple, t_simple)
	
	    # Update state
	    v_simple += a_simple * dt_simple  # velocity update
	    x_simple += v_simple * dt_simple  # position update
	
	    # Update time
	    t_simple += dt_simple
	end
end

# ╔═╡ cfe7aba7-5e20-42a2-87c2-5a6eb37c6409
md"""
### Results of the Simulation
Below are the position and velocity of the particle over time:
"""

# ╔═╡ 739c7279-bec8-4cec-abcd-582488015529
begin
# Plot results
	plot(
		times_simple, positions_simple;
		label="Position (m)", 
		xlabel="Time (s)", 
		ylabel="Position (m) / Velocity (m/s)", 
		legend=:topright,
		title="Simple Example"
	)
	plot!(times_simple, velocities_simple, label="Velocity (m/s)")
end

# ╔═╡ 86f33071-deed-4daf-a564-ab7421d9da53
md"""
## Bouncing Ball

In this simulation, we model the motion of a ball under gravity as it bounces on a surface. The ball's behavior includes:
1. **Gravity**: A constant downward acceleration affecting the ball's velocity.
2. **Inelastic Collisions**: Energy loss upon impact with the surface, reducing the ball's velocity after each bounce.

We will simulate the ball's position and velocity over time using the simulation loop introduced earlier.
"""

# ╔═╡ 57133f48-3a8d-4b3e-af36-d849f89ed90e
md"""
### Dynamics of the Bouncing Ball

The motion of the ball is governed by:
1. **Position Update**: 
    ``
    x(t + \Delta t) = x(t) + v(t) \Delta t
    ``
2. **Velocity Update**:
    ``
    v(t + \Delta t) = v(t) + a \Delta t
    ``
3. **Collision Condition**:
    When the ball hits the surface (``x(t) \leq 0``):
    - Reverse the velocity direction.
    - Reduce the velocity magnitude using the restitution coefficient (``\zeta \leq 1``).
"""

# ╔═╡ ccb2275c-117e-4e6d-8ad1-3144c9d03407
begin
	# Parameters
	g_bb = -9.81  # acceleration due to gravity (m/s^2)
	dt_bb = 0.05  # time step (s)
	t_max_bb = 7.0  # total simulation time (s)
	ζ_bb = 0.8  # coefficient of restitution (energy loss factor)
	x0_bb = 5.0  # initial height (m)
	v0_bb = 0.0  # initial velocity (m/s)
	
	# Initialize state
	t_bb = 0.0
	x_bb = x0_bb
	v_bb = v0_bb
	
	# Storage for results
	times_bb = Float64[]
	positions_bb = Float64[]
	velocities_bb = Float64[]
	
	# Simulation loop
	while t_bb <= t_max_bb
	    # Record state
	    push!(times_bb, t_bb)
	    push!(positions_bb, x_bb)
	    push!(velocities_bb, v_bb)
	
	    # Update velocity and position
	    v_bb += g_bb * dt_bb
	    x_bb += v_bb * dt_bb
	
	    # Check for collision
	    if x_bb <= 0
	        x_bb = 0
	        v_bb = -v_bb * ζ_bb
	    end
	
	    # Increment time
	    t_bb += dt_bb
	end
end

# ╔═╡ 3d90ed79-bbde-4571-af45-2cf94c27c132
md"""
### Visualizing the Bouncing Ball
The plot below show the ball's position and velocity as it bounces.
"""

# ╔═╡ 98730e6a-b79c-4042-9cdc-fe1f8055f9d4
begin
	# Plot position and velocity over time
	plot(times_bb, positions_bb; 
		label="Position (m)", 
		xlabel="Time (s)", 
		ylabel="Position/Velocity", 
		legend=:topright,
		title="Bouncing Ball (ζ = $(ζ_bb))"
	)
	plot!(times_bb, velocities_bb, label="Velocity (m/s)")
end

# ╔═╡ 1c1783ce-7670-42e8-9c3d-22dfd6210737
md"#### Animation of the Bouncing Ball"

# ╔═╡ 4eafbe24-d563-411f-b45c-3beff2971885
@bind t_idx PlutoUI.Clock(interval=dt_bb, max_value=length(times_bb))

# ╔═╡ 40d9c76e-04fa-442d-8ac2-a27cbc6f67e9
begin
	scatter([positions_bb[t_idx]], 
		markersize=15,
		ylims=(-0.2, x0_bb + 0.5), 
		xlims=(0.95, 1.05),
		legend=nothing,
		xticks=[],
		xlabel="",
		size=(100, 500)
	)
end

# ╔═╡ 91bbb545-66d9-4660-aa72-1e6c0d01e151
md"""
## ``N``-body Problem

The ``N``-body problem involves simulating the motion of ``N`` particles under mutual interactions, such as gravitational forces. This problem is central to many fields, including:
- **Astrophysics**: Simulating star clusters, galaxies, or planetary systems.
- **Molecular Dynamics**: Modeling interactions between atoms or molecules.
- **Game Physics**: Animating particles in video games.

### Background
For ``N > 2``, there is no general analytical solution, so we rely on numerical simulations.

1. **Newton's Law of Gravitation**:
    ``
    F_{ij} = G \frac{m_i m_j}{r_{ij}^2} \hat{r}_{ij}
    ``
    where:
    - ``F_{ij}``: Force on particle $i$ due to particle ``j``.
    - ``G``: Gravitational constant.
    - ``m_i, m_j``: Masses of the particles.
    - ``r_{ij}``: Distance between particles ``i`` and ``j``.
    - ``\hat{r}_{ij}``: Unit vector from ``i`` to ``j``.

2. **Superposition Principle**: The total force on a particle is the vector sum of the forces exerted by all other particles.

3. **Numerical Integration**: The positions and velocities of particles are updated iteratively using the equations of motion.
"""

# ╔═╡ a4612790-38c7-11eb-2baf-3f03e9aabd00
md"""
###  Simulation

Let us set up an $n$-body simulator.
"""

# ╔═╡ c1a70d10-38c7-11eb-34bf-cfbd1015ceef
mutable struct Pt
    x::Float64   # x-position
    y::Float64   # y-position
    u::Float64   # x-velocity
    v::Float64   # y-velocity
    m::Float64   # mass
    color::Colorant
end

# ╔═╡ dc84a522-38c7-11eb-0dab-4b7137d2f0b2
mutable struct State
	pts::Vector{Pt}
end

# ╔═╡ e47592d0-38c7-11eb-256d-69c7aa69ad01
function render(pt::Pt)
	compose(context(), circle(pt.x, pt.y, 10^-7.5*pt.m), fill(pt.color))
end

# ╔═╡ f204f2b0-38c7-11eb-1a4c-4723491abf77
function render(s::State)
	compose(context(), map(render, s.pts))
end

# ╔═╡ 651ca990-82d7-4940-a239-8103e8ea6cea
md"#### Initilization"

# ╔═╡ fb8f9330-38c7-11eb-0774-29c039b2b8c6
function init_particles(N::Int; rng::AbstractRNG=Random.GLOBAL_RNG)
    init_state = State([Pt(
        rand(rng), rand(rng),  # Random initial position
        randn(rng) * 0.05, randn(rng) * 0.05,  # Small random initial velocity
        rand(rng) * 10^6,  # Random mass between 0 and 10^6
        HSV(rand(rng) * 360, 0.8, 0.8)  # Random color
    ) for i in 1:N])
	init_state.pts[1] = Pt(0.5, 0.5, 0, 0, 0.1, HSV(rand(rng) * 360, 0.8, 0.8))
	return init_state
end

# ╔═╡ bb78e890-38c8-11eb-008d-39572f827023
render(init_particles(10))

# ╔═╡ 1b463c9b-88cd-4da0-bf7e-b8e69d744241
md"""
#### Action/State Propagation
We apply Newton's Law of Gravitation and superposition:
"""

# ╔═╡ 0e63b710-38c9-11eb-0320-151af06547f9
function act!(i::Int, s::State, dt::Float64)
	force = [0.0, 0.0]
	I = s.pts[i]
	for (j, J) in enumerate(s.pts)
		if j != i
			r_vec = [J.x - I.x, J.y - I.y] # Vector from i to j
			r = norm(r_vec) + eps(Float64) # Avoid division by zero
			r_unit = r_vec / r
			F_ij = (6.67 * 10^-11 * I.m * J.m) / r^2 * r_unit # Gravitational force
			force += F_ij
		end
	end
	# Update velocities based on force
	I.u += force[1] * dt / I.m
	I.v += force[2] * dt / I.m
	
	# Clamp to control explosions (when r = 0)
	I.u = clamp(I.u, -1e-1, 1e-1)
	I.v = clamp(I.v, -1e-1, 1e-1)
end
			

# ╔═╡ 7ee486e0-38c9-11eb-10c7-ff75447d0850
function propagate!(i::Int, s::State, dt::Float64; rebound=0.9)
	# update position based on velocity
	I = s.pts[i]
	x′ = I.x + I.u * dt
	y′ = I.y + I.v * dt

	u′ = I.u
	v′ = I.v
	
	# let's stay inside the box
	if x′ != clamp(x′, 0, 1)
		u′ = -u′ * rebound # lose energy on bounce and flip direction
		x′ = clamp(x′, 0, 1)
	end
	
	if y′ != clamp(y′, 0, 1)
		v′ = -v′ * rebound # lose energy on bounce and flip direction
		y′ = clamp(y′, 0, 1)
	end
	
	s.pts[i] = Pt(x′, y′, u′, v′, I.m, I.color)
	return s
end

# ╔═╡ f8ccb7c0-38c9-11eb-30e4-018c867da0c1
function animate(steps, dt=1/60; num_bodies=10, rng::AbstractRNG=Random.GLOBAL_RNG)
	animation = Context[]
	s = init_particles(num_bodies; rng=rng)
	for t in 1:steps
		for i in 1:length(s.pts)
			act!(i, s, dt)
		end
		for i in 1:length(s.pts)
			propagate!(i, s, dt)
		end
		push!(animation, render(s))
	end
	return animation
end

# ╔═╡ fc17d0a5-3290-4e08-baf5-37df23efe863
md"""
#### Simulate and Visualize

Size of the circles correspond to the mass of each body
"""

# ╔═╡ 16eafbe0-38ca-11eb-3c19-016eac239877
animation = animate(10_000; num_bodies=15, rng=MersenneTwister(13));

# ╔═╡ 9c74331b-adfe-41a8-931b-9881c9f09527
@bind aₜ PlutoUI.Clock(interval=1/60, max_value=length(animation))

# ╔═╡ 48afc480-38ca-11eb-1b69-b3398178811b
animation[aₜ]

# ╔═╡ 7aa78a8f-694b-405d-bdf9-2785208b8dfe
md"""
## Sampling
Sampling is a fundamental concept in simulations, enabling us to incorporate randomness and model stochastic behavior. It is widely used in:
- **Random Initialization**: For example, setting initial positions and velocities in particle simulations.
- **Stochastic Models**: Capturing uncertainty in probabilistic systems like weather forecasts or market simulations.
- **Monte Carlo Methods**: Approximating integrals, probabilities, and distributions through repeated random sampling.

By leveraging random number generators and probability distributions, we can simulate complex systems and explore their behavior under uncertainty.
"""

# ╔═╡ 0548253f-018f-481f-b041-b715648f1a25
md"""
### Random Number Generation
The basis of all sampling is the ability to generate random numbers. In Julia, we can generate:
- Uniform random numbers in the range $[0, 1]$ using `rand()`.
- Normally distributed random numbers (mean = 0, variance = 1) using `randn()`.

**Examples**:
"""

# ╔═╡ ec7693d0-38cc-11eb-1901-bb4359ecf6ed
rand() # random number from 0 to 1

# ╔═╡ fac54c10-38cc-11eb-1b83-01ff4d231c31
rand(5) # five samples from `rand`

# ╔═╡ 028d5500-38cd-11eb-2367-6b1899e11202
randn() # normally distributed number (Gaussian with mean 0 and stdev 1)

# ╔═╡ 0c1a8d8e-38cd-11eb-0677-213f6236cb18
2 + 3*randn() # mean 2, stdev 3

# ╔═╡ 342c4ff2-d764-4c32-a74f-cb5bfa489a2d
md"""
### Sampling from Distributions
Using the `Distributions` package, we can sample from a wide range of probability distributions. For example:
- **Normal Distribution**: Captures natural phenomena like heights or measurement errors.
- **Uniform Distribution**: Commonly used for initializing variables or selecting random indices.
- **Exponential Distribution**: Models the time between events in a Poisson process (e.g., customer arrivals).

**Examples**:
"""

# ╔═╡ 30b065d0-38cd-11eb-22da-81cead2bf7f1
N = Normal(5, 2)  # Normal distribution with mean=5, stddev=2

# ╔═╡ 340a1820-38cd-11eb-3f73-070ec039aa57
rand(N) # Single sample from N

# ╔═╡ 36088030-38cd-11eb-238b-b18f52b41f00
rand(N, 10)  # Generate 10 samples from N

# ╔═╡ 136d2338-6c11-4a9f-b461-59e055cd7d5c
U = Uniform(0, 10)  # Uniform distribution between 0 and 10

# ╔═╡ 2fb29dc0-e69f-40f5-9f05-a480b20317dc
rand(U, 5)  # Generate 5 samples from U

# ╔═╡ 47bf42a0-38cd-11eb-2859-fffd932ca0b8
begin
	Random.seed!(0)
	data = [rand(Normal(-5, 1.8), 500);
		    rand(Normal(-4, 0.8), 2000);
		    rand(Normal(-1, 0.3), 500);
		    rand(Uniform(5, 7), 1500);
		    rand(Normal(4, 1.5), 1000)]
	data = filter!(x->-15 < x < 15, data)
	histogram(data, bins=100, size=(600,200), label=nothing)
end

# ╔═╡ c539b812-76b0-4e30-88e1-98eeeb36bc3c
md"""
### Controlling Randomness with RNGs

Random number generation in Julia is controlled by a **Random Number Generator (RNG)**. By explicitly passing an RNG to functions like `rand`, we can:
- Ensure reproducibility of results.
- Isolate randomness for different parts of the simulation.
- Use multiple independent RNG streams.

#### Why Use Explicit RNGs?
- **Reproducibility**: Fixing the seed of an RNG ensures that the same sequence of random numbers is generated each time.
- **Parallelism**: Independent RNGs can be used in parallel simulations to avoid conflicts or repeated sequences.

#### Examples
"""

# ╔═╡ 281dc30c-4809-478f-8316-33d7a3252546
# Create an RNG with a fixed seed
rng = MersenneTwister(42)

# ╔═╡ bfd643b1-c4ad-4664-ae13-f2ebe7fa6a80
rand(rng)       # Generate a single random number

# ╔═╡ b529a6c8-bb73-4951-a2fd-3656ffb718fa
rand(rng, 5)    # Generate an array of 5 random numbers

# ╔═╡ 42d0b00f-42b9-4042-8633-40050098b6c2
begin
	rng2 = MersenneTwister(42)
	rand(rng2, 6)
end

# ╔═╡ eb124f23-dd38-475a-bc8c-c624d26c4976
rand(MersenneTwister(0xAA120), 10)

# ╔═╡ 9b1490bf-e7b7-4e02-ad09-cf1f78552cda
rand(MersenneTwister(0xAA120), 10)

# ╔═╡ d7ce08a0-38cc-11eb-1246-a9105983f2e6
md"""
---
"""

# ╔═╡ 616636d2-38ca-11eb-2823-2fd57ad86cea
PlutoUI.TableOfContents(title="Simulation")

# ╔═╡ Cell order:
# ╟─d0efeeb0-38c5-11eb-3b9a-5bcbc9103863
# ╟─b5aee6fa-7ab3-4bfb-bb4c-a1f11cbbe503
# ╟─106ae033-af16-49a5-8edf-bef905af8473
# ╠═ce9f5737-b699-4193-9cb2-0a4a9e0cf67b
# ╟─e03d1a29-add9-4845-89b0-484bb6159fec
# ╟─6b48009d-8659-49b9-8cab-c2f371493088
# ╟─ad676bca-ddf7-4289-96b7-534cbbaa5705
# ╠═2e69dc10-f376-4137-9acd-20979cc4aa5c
# ╟─cfe7aba7-5e20-42a2-87c2-5a6eb37c6409
# ╠═739c7279-bec8-4cec-abcd-582488015529
# ╟─86f33071-deed-4daf-a564-ab7421d9da53
# ╟─57133f48-3a8d-4b3e-af36-d849f89ed90e
# ╠═ccb2275c-117e-4e6d-8ad1-3144c9d03407
# ╟─3d90ed79-bbde-4571-af45-2cf94c27c132
# ╠═98730e6a-b79c-4042-9cdc-fe1f8055f9d4
# ╟─1c1783ce-7670-42e8-9c3d-22dfd6210737
# ╠═4eafbe24-d563-411f-b45c-3beff2971885
# ╠═40d9c76e-04fa-442d-8ac2-a27cbc6f67e9
# ╟─91bbb545-66d9-4660-aa72-1e6c0d01e151
# ╟─a4612790-38c7-11eb-2baf-3f03e9aabd00
# ╠═c1a70d10-38c7-11eb-34bf-cfbd1015ceef
# ╠═dc84a522-38c7-11eb-0dab-4b7137d2f0b2
# ╠═e47592d0-38c7-11eb-256d-69c7aa69ad01
# ╠═f204f2b0-38c7-11eb-1a4c-4723491abf77
# ╟─651ca990-82d7-4940-a239-8103e8ea6cea
# ╠═fb8f9330-38c7-11eb-0774-29c039b2b8c6
# ╠═bb78e890-38c8-11eb-008d-39572f827023
# ╟─1b463c9b-88cd-4da0-bf7e-b8e69d744241
# ╠═0e63b710-38c9-11eb-0320-151af06547f9
# ╠═7ee486e0-38c9-11eb-10c7-ff75447d0850
# ╠═f8ccb7c0-38c9-11eb-30e4-018c867da0c1
# ╟─fc17d0a5-3290-4e08-baf5-37df23efe863
# ╠═16eafbe0-38ca-11eb-3c19-016eac239877
# ╠═9c74331b-adfe-41a8-931b-9881c9f09527
# ╠═48afc480-38ca-11eb-1b69-b3398178811b
# ╟─7aa78a8f-694b-405d-bdf9-2785208b8dfe
# ╟─0548253f-018f-481f-b041-b715648f1a25
# ╠═ec7693d0-38cc-11eb-1901-bb4359ecf6ed
# ╠═fac54c10-38cc-11eb-1b83-01ff4d231c31
# ╠═028d5500-38cd-11eb-2367-6b1899e11202
# ╠═0c1a8d8e-38cd-11eb-0677-213f6236cb18
# ╟─342c4ff2-d764-4c32-a74f-cb5bfa489a2d
# ╠═30b065d0-38cd-11eb-22da-81cead2bf7f1
# ╠═340a1820-38cd-11eb-3f73-070ec039aa57
# ╠═36088030-38cd-11eb-238b-b18f52b41f00
# ╠═136d2338-6c11-4a9f-b461-59e055cd7d5c
# ╠═2fb29dc0-e69f-40f5-9f05-a480b20317dc
# ╠═47bf42a0-38cd-11eb-2859-fffd932ca0b8
# ╟─c539b812-76b0-4e30-88e1-98eeeb36bc3c
# ╠═281dc30c-4809-478f-8316-33d7a3252546
# ╠═bfd643b1-c4ad-4664-ae13-f2ebe7fa6a80
# ╠═b529a6c8-bb73-4951-a2fd-3656ffb718fa
# ╠═42d0b00f-42b9-4042-8633-40050098b6c2
# ╠═eb124f23-dd38-475a-bc8c-c624d26c4976
# ╠═9b1490bf-e7b7-4e02-ad09-cf1f78552cda
# ╟─d7ce08a0-38cc-11eb-1246-a9105983f2e6
# ╠═616636d2-38ca-11eb-2823-2fd57ad86cea
