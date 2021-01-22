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

# ╔═╡ d0efeeb0-38c5-11eb-3b9a-5bcbc9103863
begin
	using PlutoUI
	# pkg"add https://github.com/shashankp/PlutoUI.jl#TableOfContents-element"

	md"""
	# Simulation
	AA120Q: *Building Trust in Autonomy*, Stanford University. 

	We will discuss how to structure and implement simulation frameworks.
	
	## Simulation loop
	Simulations require repeating the following porcedure for each agent, for each timestep:
	1. Actions have taken you to a new location
	2. Make observations
	3. Update your belief
	4. Assess your next action
	5. Act
	"""
end

# ╔═╡ 1c57d390-38c6-11eb-1516-e15b05666ff9
using Compose, Colors, Random

# ╔═╡ 0b899500-38c9-11eb-013b-f9c6614b1e4b
using LinearAlgebra

# ╔═╡ 282b0050-38cd-11eb-07c3-2fdb007a1e5c
using Distributions

# ╔═╡ 43b37e60-38cd-11eb-1238-c1f9485e589d
using Plots

# ╔═╡ 53cd4160-38c7-11eb-0d5a-1b9ae090cc30
md"""
## Bounding ball
With the systems we can derive the motion analytically.

$$y = 1 - \lvert \sin(t) \rvert$$
"""

# ╔═╡ 7ffb8710-38c7-11eb-0d37-e92dbf75eea2
function drawball(t)
	y = 1 - abs(sin(t)) # the y-coordinate
	compose(context(), circle(0.5, y, 0.04))
end

# ╔═╡ 8e9fb250-38c7-11eb-2676-6df68ccb5366
@bind t Slider(0:0.1:10)

# ╔═╡ 964c4400-38c7-11eb-129b-85913ba52576
drawball(t)

# ╔═╡ a4612790-38c7-11eb-2baf-3f03e9aabd00
md"""
##  $N$-body problem
The $n$-body problem refers to simulating orbiting bodies. With $n>2$ there is no analytical solution.

Let us set up an $n$-body simulator.
"""

# ╔═╡ c1a70d10-38c7-11eb-34bf-cfbd1015ceef
struct Pt
	x::Float64 # x-position
	y::Float64 # y-position
	u::Float64 # x-velicity
	v::Float64 # y-velocity
	color::Colorant
end

# ╔═╡ dc84a522-38c7-11eb-0dab-4b7137d2f0b2
mutable struct State
	pts::Vector{Pt}
end

# ╔═╡ e47592d0-38c7-11eb-256d-69c7aa69ad01
function render(pt::Pt)
	compose(context(), circle(pt.x, pt.y, 0.01), fill(pt.color))
end

# ╔═╡ f204f2b0-38c7-11eb-1a4c-4723491abf77
function render(s::State)
	compose(context(), map(render, s.pts))
end

# ╔═╡ fb8f9330-38c7-11eb-0774-29c039b2b8c6
function init()
	State([Pt(rand(), rand(), randn(), randn(), HSV(200+100*rand(), 0.6, 0.8)) for i = 1:100])
end

# ╔═╡ bb78e890-38c8-11eb-008d-39572f827023
render(init())

# ╔═╡ bd688390-38c8-11eb-0b7f-0b6fb5c072dd
md"""
Each agent acts according to the law of gravitation:

$$F_i = \sum_{j=1}^N G \frac{m_i m_j}{r^2_{j \to i}}\hat r_{j \to i}$$
"""

# ╔═╡ 0e63b710-38c9-11eb-0320-151af06547f9
function act!(i::Int, s::State, dt::Float64)
	force = [0.0, 0.0]
	I = s.pts[i]
	for (j,J) in enumerate(s.pts)
		if j != i
			u = [J.x - I.x, J.y - I.y]
			r = norm(u)
			u ./= r
			force += u ./ r^2
			force -= 0.1*u ./ r^3 # let's also include a `strong` force
		end
	end
	force .*= 0.01 # account for G and masses
	force = clamp!(force, -5, 5) # clamp to prevent explosions
	
	# adjust velocity according to force
	s.pts[i] = Pt(I.x, I.y, I.u + force[1]*dt, I.v + force[2]*dt, I.color)
end
			

# ╔═╡ 7ee486e0-38c9-11eb-10c7-ff75447d0850
function propagate!(i::Int, s::State, dt::Float64; friction=0.5, rebound=0.9)
	# update position based on velocity
	I = s.pts[i]
	x = I.x + I.u*dt
	y = I.y + I.v*dt
	u = I.u*friction
	v = I.v*friction
	
	# let's stay inside the box
	x = clamp(x, 0, 1)
	u = -u*rebound # lose energy on bounce and flip direction
	
	y = clamp(y, 0, 1)
	v = -v*rebound # lose energy on bounce and flip direction
	
	s.pts[i] = Pt(x, y, u, v, I.color)
	return s
end

# ╔═╡ f8ccb7c0-38c9-11eb-30e4-018c867da0c1
function animate(steps, dt=1/60)
	animation = Context[]
	s = init()
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

# ╔═╡ 16eafbe0-38ca-11eb-3c19-016eac239877
animation = animate(1000);

# ╔═╡ 36f88ce0-38ca-11eb-14a9-5bff1182f3c6
@bind aₜ Slider(1:length(animation))

# ╔═╡ 48afc480-38ca-11eb-1b69-b3398178811b
animation[aₜ]

# ╔═╡ da21bc9e-38cc-11eb-0a24-c59697d8e311
md"""
## Sampling
Many simulations require random numbers, whether for random initialization, sampling from stochastic models, or for other purposes.
"""

# ╔═╡ ec7693d0-38cc-11eb-1901-bb4359ecf6ed
rand() # random number from 0 to 1

# ╔═╡ fac54c10-38cc-11eb-1b83-01ff4d231c31
rand(5) # five samples from `rand`

# ╔═╡ 028d5500-38cd-11eb-2367-6b1899e11202
randn() # normally distributed number (Gaussian with mean 0 and stdev 1)

# ╔═╡ 0c1a8d8e-38cd-11eb-0677-213f6236cb18
2 + 3*randn() # mean 2, stdev 3

# ╔═╡ 9ea9c770-38cd-11eb-22ea-b93e7fd72df0
md"""
### Sample from distributions
"""

# ╔═╡ 120daf70-38cd-11eb-12de-d794098b4f2a
md"""
The `Distributions` package provides a large number of distributions for your use. We have already seen many of them. You can sample from them with `rand`.
"""

# ╔═╡ 30b065d0-38cd-11eb-22da-81cead2bf7f1
N = Normal(2, 3) # mean 2, stdev 3

# ╔═╡ 340a1820-38cd-11eb-3f73-070ec039aa57
rand(N)

# ╔═╡ 36088030-38cd-11eb-238b-b18f52b41f00
rand(N, 5) # five samples from N

# ╔═╡ cfc6f200-5c46-11eb-388a-3ff00076a41f
plotly();

# ╔═╡ 47bf42a0-38cd-11eb-2859-fffd932ca0b8
begin
	Random.seed!(0)
	data = [randn(500) .* 1.8 .+ -5;
		    randn(2000) .* 0.8 .+ -4;
		    randn(500) .* 0.3 .+ -1;
		    randn(1000) .* 0.8 .+ 2;
		    randn(500) .* 1.5 .+ 4]
	data = filter!(x->-15 < x < 15, data)
	histogram(data, bins=100, size=(600,200), label=nothing)
end

# ╔═╡ d7ce08a0-38cc-11eb-1246-a9105983f2e6
md"""
---
"""

# ╔═╡ 616636d2-38ca-11eb-2823-2fd57ad86cea
PlutoUI.TableOfContents(title="Simulation")

# ╔═╡ Cell order:
# ╟─d0efeeb0-38c5-11eb-3b9a-5bcbc9103863
# ╟─53cd4160-38c7-11eb-0d5a-1b9ae090cc30
# ╠═1c57d390-38c6-11eb-1516-e15b05666ff9
# ╠═7ffb8710-38c7-11eb-0d37-e92dbf75eea2
# ╠═8e9fb250-38c7-11eb-2676-6df68ccb5366
# ╠═964c4400-38c7-11eb-129b-85913ba52576
# ╟─a4612790-38c7-11eb-2baf-3f03e9aabd00
# ╠═c1a70d10-38c7-11eb-34bf-cfbd1015ceef
# ╠═dc84a522-38c7-11eb-0dab-4b7137d2f0b2
# ╠═e47592d0-38c7-11eb-256d-69c7aa69ad01
# ╠═f204f2b0-38c7-11eb-1a4c-4723491abf77
# ╠═fb8f9330-38c7-11eb-0774-29c039b2b8c6
# ╠═bb78e890-38c8-11eb-008d-39572f827023
# ╟─bd688390-38c8-11eb-0b7f-0b6fb5c072dd
# ╠═0b899500-38c9-11eb-013b-f9c6614b1e4b
# ╠═0e63b710-38c9-11eb-0320-151af06547f9
# ╠═7ee486e0-38c9-11eb-10c7-ff75447d0850
# ╠═f8ccb7c0-38c9-11eb-30e4-018c867da0c1
# ╠═16eafbe0-38ca-11eb-3c19-016eac239877
# ╠═36f88ce0-38ca-11eb-14a9-5bff1182f3c6
# ╠═48afc480-38ca-11eb-1b69-b3398178811b
# ╟─da21bc9e-38cc-11eb-0a24-c59697d8e311
# ╠═ec7693d0-38cc-11eb-1901-bb4359ecf6ed
# ╠═fac54c10-38cc-11eb-1b83-01ff4d231c31
# ╠═028d5500-38cd-11eb-2367-6b1899e11202
# ╠═0c1a8d8e-38cd-11eb-0677-213f6236cb18
# ╟─9ea9c770-38cd-11eb-22ea-b93e7fd72df0
# ╟─120daf70-38cd-11eb-12de-d794098b4f2a
# ╠═282b0050-38cd-11eb-07c3-2fdb007a1e5c
# ╠═30b065d0-38cd-11eb-22da-81cead2bf7f1
# ╠═340a1820-38cd-11eb-3f73-070ec039aa57
# ╠═36088030-38cd-11eb-238b-b18f52b41f00
# ╠═43b37e60-38cd-11eb-1238-c1f9485e589d
# ╠═cfc6f200-5c46-11eb-388a-3ff00076a41f
# ╠═47bf42a0-38cd-11eb-2859-fffd932ca0b8
# ╟─d7ce08a0-38cc-11eb-1246-a9105983f2e6
# ╠═616636d2-38ca-11eb-2823-2fd57ad86cea
