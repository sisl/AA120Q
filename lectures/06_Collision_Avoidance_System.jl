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

# ╔═╡ 1ecaaeb0-38ce-11eb-2304-65c70a221e0a
begin
	using PlutoUI
	# pkg"add https://github.com/shashankp/PlutoUI.jl#TableOfContents-element"

	md"""
	# Building Autonomous Systems
	AA120Q: *Building Trust in Autonomy*, Stanford University. 

	We will discuss a variety of approaches to building autonomous systems.
	"""
end

# ╔═╡ b55a93d0-38cf-11eb-269d-917ada180999
using AA120Q, TikzPictures

# ╔═╡ c40dff50-38e5-11eb-01e3-5bc7a839b947
using Compose

# ╔═╡ 1b9f67f0-38e5-11eb-15f5-f958b083c92e
include("mountaincar.jl")

# ╔═╡ fe2c8100-38ce-11eb-281e-277e6848a981
md"""
# Decision Making

Decision making is the process of deciding what to do.

An _agent_ takes _actions_ in an environment. Decision making requires choosing the actions.


$$\text{action} = \operatorname{act}(\text{agent}, \text{state})$$

Oftentimes the agent has to make decisions with incomplete information.

$$\text{action} = \operatorname{act}(\text{agent}, \text{state}, \text{belief})$$

An _intelligent_ agent interacts with the world such that it achieves its objectives over time.

$(PlutoUI.LocalResource("./figures/agent_environment_interaction.png"))
"""

# ╔═╡ 686690ae-38cf-11eb-3a52-1b0fac0d4551
md"""
## Traffic Alert and Collision Avoidance System

TCAS is an onboard collision avoidance system for all medium -- large aircraft. The system provides resolution advisories to pilots, instructing them to adjust their climb or descent rate to avoid collision.

$(PlutoUI.LocalResource("./figures/pic_tcas_001.jpg"))
"""

# ╔═╡ 6de2fbee-38cf-11eb-37f8-e7e8ea56f9e5
md"""
TCAS is the final line of defense before a collision. Many safety systems and protocols must fail before it comes into effect.

$(PlutoUI.LocalResource("./figures/protected-area.jpg"))
"""

# ╔═╡ a71d8ed0-38cf-11eb-1d69-c3a5a21c5ae2
md"""
TCAS looks at the approach rate and decides whether to have the airplane pull up or down. A simplified implementation is given in `AA120Q.jl`.
"""

# ╔═╡ 0c940582-38dc-11eb-193a-29e492c5d688
agent = TCAS()

# ╔═╡ 2c5d6190-38dc-11eb-2cb6-cd90210d7095
md"""
The TCAS agent is a `FullyObservableCollisionAvoidanceSystem`, meaning it assumes perfect state information.

```julia
TCAS <: FullyObservableCollisionAvoidanceSystem
```

It implements two functions: `reset!` and `update!`
"""

# ╔═╡ 6a1fed90-38dc-11eb-1cea-e9b5ca2f2b5e
# reset the TCAS agent to its initial state
function reset!(tcas::TCAS)
	tcas.advisory = ADVISORY_NONE
	return tcas
end

# ╔═╡ 7ce20580-38dc-11eb-3628-ab2ee11214a6
# update! contains the real logic
function update!(tcas::TCAS,
		         s1::AircraftState,
		         s2::AircraftState,
		         params::EncounterSimParams)
	# ... collision avoidance logic ...
	return tcas.advisory
end

# ╔═╡ b25dbba0-38dc-11eb-2941-c7397554223c
md"""
Note that TCAS is completely deterministic.

The next-generation collision avoidance system (ACAS X) was developed with stochasticity in mind.

$(PlutoUI.LocalResource("./figures/decision_theoretic_planning.png"))
"""

# ╔═╡ e50bd2d0-38dc-11eb-3aa7-69da24bdef12
md"""
In this class you will build your own collision avoidance system for aircraft.
"""

# ╔═╡ df864630-38e4-11eb-227e-4be958de9558
md"""
## Policy Evaluation in Continuous Spaces

For continuous spaces you often cannot use discrete solving methods.
Instead, if you have a policy $\pi(s) \rightarrow a$ and a distribution over the initial state, you can evaluate it by running a lot of simulations and returning the mean reward.
"""

# ╔═╡ 03b630ae-38e5-11eb-2017-1d40137afb6c
md"""
### Moutain Car

An [under-powered car must drive up a steep hill](https://en.wikipedia.org/wiki/Mountain_Car). Simply holding the throttle isn't good enough.

- **State**: position $x$ and velocity $v$
"""

# ╔═╡ 0f7d53ae-38e5-11eb-226e-994786307178
mutable struct MountainCar
	x::Float64 # position
	v::Float64 # speed
end

# ╔═╡ 365c58a0-38e5-11eb-2652-7f33ce2a63ab
@bind x Slider(-1.5:0.1:1.5)

# ╔═╡ 3e55d1d0-38e5-11eb-174b-a365b7cae51c
@bind y Slider(-1.0:0.25:1.0)

# ╔═╡ 45e3b7f0-38e5-11eb-2688-0782700d5bb8
render_mountain_car(MountainCar(x,y), render_pos_overlay=true)

# ╔═╡ 65e0f540-38e5-11eb-1e7e-6362d55b0888
md"""
- **Actions**: accelerate left, right, or coast.
"""

# ╔═╡ 6cf03580-38e5-11eb-3a80-8151934dd912
function update!(car::MountainCar, a::Symbol)
	act = (a == :left ? -1 : (a == :right ? 1 : 0))
	v2 = car.v + act*0.001 - sin((car.x/1.5 + 1)*pi) * -0.0025
	x2 = clamp(car.x + v2, -1.5, 1.5)
	return MountainCar(x2, v2)
end

# ╔═╡ 95c64f82-38e5-11eb-01f1-435170afdb87
md"""
- **Reward**: $R(s,a) = y$
"""

# ╔═╡ 9e646d20-38e5-11eb-2186-b765f3fa3a4f
reward(car::MountainCar, a::Symbol) = -cos(car.x/1.5*pi)

# ╔═╡ ac4c2630-38e5-11eb-237f-cdd7baebb6ff
md"""
#### Policy: _floor it_
"""

# ╔═╡ c80725f0-38e5-11eb-1646-0397917c6b3f
function animate_floor(steps)
	car = MountainCar(0.0, 0.0)
	frames = []
	R = 0
	for t in 1:steps
		a = :right
		car = update!(car, a)
		R = R*0.99 + reward(car, a)
		push!(frames, render_mountain_car(car, render_pos_overlay=true, reward=R))
	end
	return frames
end

# ╔═╡ e5ccc2c0-38e5-11eb-02bb-21e3dee3fc6c
animation_floor = animate_floor(200);

# ╔═╡ e975cd8e-38e5-11eb-3e9d-11a9ccb0beb1
@bind car_floorᵢ Slider(1:length(animation_floor))

# ╔═╡ f7dec490-38e5-11eb-36e9-d1008bc96a41
animation_floor[car_floorᵢ]

# ╔═╡ fe9647e0-38e5-11eb-1af6-091fd48ff8b6
md"""
#### Policy: _boost in direction of your velocity_
"""

# ╔═╡ 11f6e9c0-38e6-11eb-1e53-e1861f2ec821
function animate_boost(steps)
	car = MountainCar(0.0, 0.0)
	frames = []
	R = 0
	for t in 1:steps
		a = car.v > 0 ? :right : :left
		car = update!(car, a)
		R = R*0.99 + reward(car, a)
		push!(frames, render_mountain_car(car, render_pos_overlay=true, reward=R))
	end
	return frames
end

# ╔═╡ 41a666f0-38e6-11eb-1844-c5c615b9828f
animation_boost = animate_boost(200);

# ╔═╡ 478febe0-38e6-11eb-13e4-65132a64605f
@bind car_boostᵢ Slider(1:length(animation_boost))

# ╔═╡ 22f1af30-38e6-11eb-344c-af40be2d5716
animation_boost[car_boostᵢ]

# ╔═╡ 2b1661a0-38e7-11eb-0e0a-45a7964fa12f
md"""
---
"""

# ╔═╡ 2c3b3292-38e7-11eb-2ee1-518ce8840823
PlutoUI.TableOfContents(title="Building Autonomous Systems")

# ╔═╡ Cell order:
# ╟─1ecaaeb0-38ce-11eb-2304-65c70a221e0a
# ╟─fe2c8100-38ce-11eb-281e-277e6848a981
# ╟─686690ae-38cf-11eb-3a52-1b0fac0d4551
# ╟─6de2fbee-38cf-11eb-37f8-e7e8ea56f9e5
# ╟─a71d8ed0-38cf-11eb-1d69-c3a5a21c5ae2
# ╠═b55a93d0-38cf-11eb-269d-917ada180999
# ╠═0c940582-38dc-11eb-193a-29e492c5d688
# ╟─2c5d6190-38dc-11eb-2cb6-cd90210d7095
# ╠═6a1fed90-38dc-11eb-1cea-e9b5ca2f2b5e
# ╠═7ce20580-38dc-11eb-3628-ab2ee11214a6
# ╟─b25dbba0-38dc-11eb-2941-c7397554223c
# ╟─e50bd2d0-38dc-11eb-3aa7-69da24bdef12
# ╟─df864630-38e4-11eb-227e-4be958de9558
# ╟─03b630ae-38e5-11eb-2017-1d40137afb6c
# ╠═0f7d53ae-38e5-11eb-226e-994786307178
# ╠═1b9f67f0-38e5-11eb-15f5-f958b083c92e
# ╠═365c58a0-38e5-11eb-2652-7f33ce2a63ab
# ╠═3e55d1d0-38e5-11eb-174b-a365b7cae51c
# ╠═45e3b7f0-38e5-11eb-2688-0782700d5bb8
# ╟─65e0f540-38e5-11eb-1e7e-6362d55b0888
# ╠═6cf03580-38e5-11eb-3a80-8151934dd912
# ╟─95c64f82-38e5-11eb-01f1-435170afdb87
# ╠═9e646d20-38e5-11eb-2186-b765f3fa3a4f
# ╟─ac4c2630-38e5-11eb-237f-cdd7baebb6ff
# ╠═c40dff50-38e5-11eb-01e3-5bc7a839b947
# ╠═c80725f0-38e5-11eb-1646-0397917c6b3f
# ╠═e5ccc2c0-38e5-11eb-02bb-21e3dee3fc6c
# ╠═e975cd8e-38e5-11eb-3e9d-11a9ccb0beb1
# ╠═f7dec490-38e5-11eb-36e9-d1008bc96a41
# ╟─fe9647e0-38e5-11eb-1af6-091fd48ff8b6
# ╠═11f6e9c0-38e6-11eb-1e53-e1861f2ec821
# ╠═41a666f0-38e6-11eb-1844-c5c615b9828f
# ╠═478febe0-38e6-11eb-13e4-65132a64605f
# ╠═22f1af30-38e6-11eb-344c-af40be2d5716
# ╟─2b1661a0-38e7-11eb-0e0a-45a7964fa12f
# ╠═2c3b3292-38e7-11eb-2ee1-518ce8840823
