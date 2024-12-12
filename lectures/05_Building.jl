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

# ╔═╡ f0ca431d-082b-4a25-8d07-8aea51517435
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ 359ce3ca-9fe3-4248-808e-52cd58b62bc6
# ╠═╡ show_logs = false
begin
	if !@isdefined MountainCar
		include("mountaincar.jl") # uses AA120Q, Cairo, Color, Printf
	end
end

# ╔═╡ 1ecaaeb0-38ce-11eb-2304-65c70a221e0a
md"""
# Building and Evaluating Autonomous Systems
AA120Q: *Building Trust in Autonomy*

## Why Build Autonomous Systems?

Autonomous systems are transforming industries, from aerospace to self-driving cars, by enabling machines to perform complex tasks with minimal human intervention. These systems must:
- Make intelligent decisions in dynamic, uncertain environments.
- Optimize outcomes while considering constraints like safety, efficiency, and resource limitations.

In this notebook, we will explore:
1. **Decision-making processes**: How we can model agents making decisions.
2. **Policy evaluation**: Comparing different strategies (policies) for solving a given problem.
"""

# ╔═╡ a6a13246-e465-4ebb-af2c-4eb998f334a9
md"#### Packages Used in this Notebook"

# ╔═╡ fe2c8100-38ce-11eb-281e-277e6848a981
md"""
# Decision-Making in Autonomous Systems

Decision-making is at the core of any intelligent system. It involves selecting the best course of action based on the system's goals and its understanding of the environment. An _intelligent agent_ interacts with the environment to achieve its objectives over time.

At its simplest, an _agent_ interacts with an environment by taking actions determined by its state:

$$a_t = \pi(s_t)$$
where $s_t$ is the state at time $t$, $a_t$ is the action at time $t$, and $\pi$ is the policy that maps states to actions.

However, in real-world scenarios, agents often operate with incomplete or uncertain information. In such cases, decision-making involves reasoning about the environment using observations. Agents often maintain a **belief** about the environment, which they update based on the previous action taken and the observation received:


$$b_t = \text{update}(b_{t-1}, a_{t-1}, o_{t-1})$$
$$a_t = \pi(b_t)$$
where $o_{t-1}$ is the observation received at $t-1$, $b_t$ is the belief at time $t$, and $\text{update}$ is a method to update our belief.

$(PlutoUI.LocalResource("./figures/agent_environment_interaction.png"))
"""

# ╔═╡ 26fabac1-76ac-4ed6-9032-03bfcbf2eaa1
md"""
# Mountain Car Problem

The [Mountain Car problem](https://en.wikipedia.org/wiki/Mountain_Car) is a fundamental benchmark in decision-making and reinforcement learning. An underpowered car must reach the top of a steep hill, but it lacks the power to climb directly. Instead, the car must employ a strategy to make it up the hill.

- **State**: The car's position $x$ and velocity $v$.
- **Actions**: Choose to accelerate left, right, or coast.
- **Reward**: Rewards can vary, such as receiving a positive value for reaching the goal or using the height of the car to encourage upward movement.

This problem is a simple example that illustrates the challenge of balancing immediate rewards with long-term strategy—a key concept in intelligent decision-making. We'll simulate the car's dynamics and evaluate different strategies!
"""

# ╔═╡ a7298c09-e0be-41ba-859e-1e523bc75cbf
md"""
## Problem Definition

The problem is defined in `mountaincar.jl` for us to use. We included this file at the top of this notebook.

### State
The file defines a `MountainCar` type with properties `x::Float64` and `v::Float64` for the position and velocity of the car. The position is restricted to ``x \in [-1.2, 0.6]`` and the velocity is restricted to ``v \in [-0.07, 0.07]``.

### Actions
The possible actions are acceleration represented as Symbols: `:left`, `:right`, and `:coast`. The magnitude of the acceleration is $0.001$ in the designated direction.

### Reward
The reward is defined as the height of the car with the lowest point in the terrain set at ``0``. The reward is defined by the function `reward(car::MountainCar, a::Symbol)` and return a `Float64`.

### Dynamics
The dynamics are provided by the function `update(car::MountainCar, a::Symbol)` and returns a `MountainCar` type with the updated position and velocity.
"""

# ╔═╡ 4129dd45-d0b0-48a0-ad94-0afc65bbc6c2
md"""
## Visualization of Mountain Car"""

# ╔═╡ df864630-38e4-11eb-227e-4be958de9558
md"""
## Policy Evaluation

One way to evaluate a policy is by simulating it and analyzing the resulting metrics. 

In **deterministic environments**, a single simulation run is often sufficient to assess a policy's performance since the outcome is consistent. However, in **stochastic environments**, where outcomes vary due to randomness, evaluating a policy typically requires running multiple simulations and aggregating results. This approach helps estimate the policy's expected performance and provides insights into its robustness under uncertainty.

For example, given a policy $\pi(s) \rightarrow a$ and a distribution over the initial states, we can simulate the policy across many scenarios, compute the reward for each run, and use the mean reward as an evaluation metric.

In the case of the **Mountain Car domain**, which is deterministic, we only need to perform one simulation to evaluate a policy. Here, we use the sum of rewards over a fixed number of steps as our metric of interest.
"""

# ╔═╡ aa87ed01-6a92-4dbf-8a60-b8a57767845e
md"""
### Policy 1: _Floor It!_

The first policy we will consider is the simplest possible strategy: always accelerate towards the peak on the right.

This policy does not consider the car's velocity or position—it just applies maximum acceleration to the right at all times.
"""

# ╔═╡ 8df03a10-771e-4998-b442-b370a0744982
function policy_floor_it(car::MountainCar)
	return :right # Always accelerate to the right!
end

# ╔═╡ 9e515a61-efc2-4aaf-9b62-268b41eaa3b4
md"""
### Policy 2: _Accelerate in the Direction of Velocity_

The second policy uses the car's current velocity. This policy accelerates in the direction the car is already traveling, aiming to maintain or increase its speed.

- If the car's velocity is negative, the policy accelerates left.
- If the velocity is zero or positive, it accelerates right.
"""

# ╔═╡ 117c546b-3fa2-4ad4-9f7c-5c5acd2b74c7
function policy_accel_in_direc_vel(car::MountainCar)
	if car.v < 0
		return :left
	else # car.v ≥ 0
		return :right
	end
end

# ╔═╡ bf7395e4-5ce7-48c2-9804-5ada290b691c
md"""
### Policy Evaluation
Now that we have our policies, we need to evaluate them. We can do this by simulating them and collecting the rewards during the simulation.
"""

# ╔═╡ 07e0217c-6215-4c20-95a2-b91a6a3a0db7
function run_single_simulation(policy::Function; number_steps=500)
	rewards = zeros(number_steps) # Vector to hold rewards
	states = Vector{MountainCar}(undef, number_steps) # Vector to hold states
	actions = Vector{Symbol}(undef, number_steps) # Vector to hold actions taken
	sₜ = MountainCar(-0.5, 0.0) # Start at x = -0.5, v = 0.0
	step_num = 0
	while step_num < number_steps
		step_num += 1
		aₜ = policy(sₜ)
		sₜ = update(sₜ, aₜ)
		rₜ = reward(sₜ, aₜ)
		rewards[step_num] = rₜ # store reward
		states[step_num] = sₜ # store state
		actions[step_num] = aₜ # store action
	end
	return rewards, states, actions
end

# ╔═╡ cd67112a-d161-42fc-829e-7713d39ef6fe
function evaluate_policy(policy::Function; 
	number_steps=500, number_of_simulations=1
)
	rewards = zeros(number_of_simulations)
	for sim_num in 1:number_of_simulations
		sim_rewards, _, _ = run_single_simulation(policy; number_steps=number_steps)
		sum_of_rewards = sum(sim_rewards)
		rewards[sim_num] = sum_of_rewards
	end
	if number_of_simulations == 1
		return rewards[1]
	else
		return rewards
	end
end

# ╔═╡ 171f5bf8-d210-4f41-9772-191bd9f92368
rewards_policy_1 = evaluate_policy(policy_floor_it)

# ╔═╡ 19480506-a380-4b10-998a-ffd569f7569a
rewards_policy_2 = evaluate_policy(policy_accel_in_direc_vel)

# ╔═╡ 836e7602-b0eb-4265-8cb3-ea75259d9497
md"""
### Visualize the Policy

While metrics are essential for evaluating a policy's performance, visualizing the policy or its behavior in action can provide additional, critical insights. Visualizations help us identify patterns, inefficiencies, or unexpected behavior that metrics alone might not reveal.
"""

# ╔═╡ 1c7a90d3-0d3a-4a1a-8024-551640478d74
function animate(policy::Function; number_steps=200)
	rewards, states, actions = run_single_simulation(policy; number_steps=number_steps)

	frames = []
	for (rₜ, sₜ, aₜ) in zip(rewards, states, actions)
		frame_t = render_mountain_car(sₜ; render_pos_overlay=true, reward=rₜ, action=aₜ)
		push!(frames, frame_t)
	end
	
	return frames
end;

# ╔═╡ 3bafccd4-a910-4131-bbb8-6ea11fd93eb4
animation_floor_it = animate(policy_floor_it);

# ╔═╡ 3e323c6a-a07b-47a8-b9f8-bf83a805ccf6
md"#### Animation of Policy 1: Floor It!"

# ╔═╡ b9af3a4d-6cc8-4d4d-893a-9447601294fd
animation_accel_in_d = animate(policy_accel_in_direc_vel);

# ╔═╡ ba84676f-7427-4126-845e-b21806b48aba
md"#### Animation of Policy 2: Accelerate in the Direction of Velocity"

# ╔═╡ 58869265-0fe0-470a-bf03-1fe4f887718f
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ 2c3b3292-38e7-11eb-2ee1-518ce8840823
PlutoUI.TableOfContents()

# ╔═╡ dd82ccdb-4565-48a1-b037-2b8596e05157
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

# ╔═╡ 365c58a0-38e5-11eb-2652-7f33ce2a63ab
md"""
Position: $(@bind pos Slider(-1.2:0.1:0.6; default=-0.5))
Velocity: $(@bind vel Slider(-0.070:0.01:0.07; default=0.0))
Action: $(@bind act Select([:left, :right, :coast]))
"""

# ╔═╡ 45e3b7f0-38e5-11eb-2688-0782700d5bb8
render_mountain_car(MountainCar(pos, vel); render_pos_overlay=true, action=act)

# ╔═╡ 3854a2b4-3fc7-45a0-980c-f97a4c517efa
@bind t_1 PlutoUI.Clock(interval=1/10, max_value=length(animation_floor_it))

# ╔═╡ 4a64a3eb-6eed-4839-abe2-68163ac0da54
animation_floor_it[t_1]

# ╔═╡ b1bc3676-4764-464c-a5fa-98f4d5f3f677
@bind t_2 PlutoUI.Clock(interval=1/10, max_value=length(animation_accel_in_d))

# ╔═╡ 335e61e8-db8d-4a0d-a0f8-ccd38a2b7ae5
animation_accel_in_d[t_2]

# ╔═╡ 2b1661a0-38e7-11eb-0e0a-45a7964fa12f
html_half_space()

# ╔═╡ e02824f3-1728-460c-8f65-a96ce5572778
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

# ╔═╡ Cell order:
# ╟─1ecaaeb0-38ce-11eb-2304-65c70a221e0a
# ╟─f0ca431d-082b-4a25-8d07-8aea51517435
# ╟─a6a13246-e465-4ebb-af2c-4eb998f334a9
# ╠═359ce3ca-9fe3-4248-808e-52cd58b62bc6
# ╟─fe2c8100-38ce-11eb-281e-277e6848a981
# ╟─26fabac1-76ac-4ed6-9032-03bfcbf2eaa1
# ╟─a7298c09-e0be-41ba-859e-1e523bc75cbf
# ╟─4129dd45-d0b0-48a0-ad94-0afc65bbc6c2
# ╟─365c58a0-38e5-11eb-2652-7f33ce2a63ab
# ╟─45e3b7f0-38e5-11eb-2688-0782700d5bb8
# ╟─df864630-38e4-11eb-227e-4be958de9558
# ╟─aa87ed01-6a92-4dbf-8a60-b8a57767845e
# ╠═8df03a10-771e-4998-b442-b370a0744982
# ╟─9e515a61-efc2-4aaf-9b62-268b41eaa3b4
# ╠═117c546b-3fa2-4ad4-9f7c-5c5acd2b74c7
# ╟─bf7395e4-5ce7-48c2-9804-5ada290b691c
# ╠═07e0217c-6215-4c20-95a2-b91a6a3a0db7
# ╠═cd67112a-d161-42fc-829e-7713d39ef6fe
# ╠═171f5bf8-d210-4f41-9772-191bd9f92368
# ╠═19480506-a380-4b10-998a-ffd569f7569a
# ╟─836e7602-b0eb-4265-8cb3-ea75259d9497
# ╟─1c7a90d3-0d3a-4a1a-8024-551640478d74
# ╟─3bafccd4-a910-4131-bbb8-6ea11fd93eb4
# ╟─3e323c6a-a07b-47a8-b9f8-bf83a805ccf6
# ╟─3854a2b4-3fc7-45a0-980c-f97a4c517efa
# ╟─4a64a3eb-6eed-4839-abe2-68163ac0da54
# ╟─b9af3a4d-6cc8-4d4d-893a-9447601294fd
# ╟─ba84676f-7427-4126-845e-b21806b48aba
# ╟─b1bc3676-4764-464c-a5fa-98f4d5f3f677
# ╟─335e61e8-db8d-4a0d-a0f8-ccd38a2b7ae5
# ╟─2b1661a0-38e7-11eb-0e0a-45a7964fa12f
# ╟─58869265-0fe0-470a-bf03-1fe4f887718f
# ╟─2c3b3292-38e7-11eb-2ee1-518ce8840823
# ╟─dd82ccdb-4565-48a1-b037-2b8596e05157
# ╟─e02824f3-1728-460c-8f65-a96ce5572778
