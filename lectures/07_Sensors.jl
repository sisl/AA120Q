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

# ╔═╡ 5787cad0-38e7-11eb-0b3e-b3e30d553dc6
begin
	using PlutoUI
	md"""
	# Robustness to Sensor Error
	AA120Q: *Building Trust in Autonomy*, Stanford University. 

	We will discuss methods for enhancing the robustness of autonomous systems to sensor error.
	
	**Assignment**: Enhance your collision avoidance system to accommodate sensor error and run it in simulation.
	"""
end

# ╔═╡ 63224310-38e8-11eb-0504-470fc81083d9
using AA120Q, Compose, Colors, Cairo

# ╔═╡ 8d355472-38e9-11eb-0d1b-4d837618f72a
include("mountaincar.jl")

# ╔═╡ d3c31370-38e7-11eb-3dd5-8d923a8e5461
md"""
## Types of Sensors

Sensors on your phone
- Accelerometers measure acceleration
- Gyroscopes measure angular rate
- Cameras measure light intensity in different wavelengths (they take photos)
- GPS measures your position

Sensors on autonomous cars
- Lidar obtains point clouds of the surrounding environment
- Radar obtains range rate of surrounding metal objects
- Odometry obtains precise wheel rates and positions

Sensors on planes
- Pitot-static tube measures fluid flow velocity
- IMU measures position and orientation using a combination of sensors
- Transponders allow aircraft to share information
"""

# ╔═╡ fa26cde2-38e7-11eb-220d-6ff100eae44a
md"""
## Filtering

Most sensors are imperfect. Filtering is a means of keeping track of your best estimate of the true state, or a belief over the possible true states.
"""

# ╔═╡ 0110abd0-38e8-11eb-173d-0f7d1a29d2b4
md"""
## Alpha-Beta Filter

The Alpha-Beta filter is a simple way to keep track of a noisy variable. It is easy to implement.

The Alpha-Beta filter models the tracked value using a position $x$ and a speed $v$. It has three paremeters, $\alpha$, $\beta$, and a timestep $\Delta t$.
"""

# ╔═╡ 0bbf8100-38e8-11eb-3903-4fc7b8ae3a74
mutable struct AlphaBetaFilter
    x::Float64  # "position" of tracked value
    v::Float64  # "speed" of tracked value
    α::Float64  # alpha parameter [0 < α < 1]
    β::Float64  # beta parameter [0 < β ≤ 2]
    dt::Float64 # timestep
end

# ╔═╡ 15458da2-38e8-11eb-3595-f18c331c7d3a
md"""
Absent of observation, the tracked value is assumed to propagate with constant speed:

$$x' \leftarrow x + \Delta t \cdot v$$

We then receive an observation $o$ of the new state. The difference between the observation and the predicted value is the _residual_:

$$r \leftarrow o - x'$$

The filter then adjusts its prediction based on the residual. The parameters $\alpha$ and $\beta$ are tuned based on how much you trust your prediction versus how much you trust the observation.

$$x' \leftarrow x' + \alpha r$$

$$v' \leftarrow v + \frac{\beta}{\Delta t} r$$
"""

# ╔═╡ 2ecc9660-38e8-11eb-3639-0122e4e99e31
function observe!(filter::AlphaBetaFilter, o::Float64)
    x, v, α, β, dt = filter.x, filter.v, filter.α, filter.β, filter.dt
    
    xp = x + dt*v   # predict based on constant speed
    r = o - xp      # compute residual
    xp = xp + α*r   # update position estimate
    vp = v + β/dt*r # update speed estimate
    
    filter.x = xp   # store for later
    filter.v = vp
    return filter
end

# ╔═╡ 37550920-38e8-11eb-0de7-e9db9a4e99ed
md"""
Now we apply the Alpha-Beta filter to tracking an undamped spring.
We observe it with random noise $N(0,{}^1/_{40})$.

The following displays the true circle alongside the noisy measurement.
"""

# ╔═╡ 6a3bbc80-38e8-11eb-31d6-7bda573ad22c
function animate(f, steps, i)
    ff = [f(i) for i in steps]
	return ff[i]
end

# ╔═╡ 81de4dd0-38e8-11eb-0394-63e9107c6ba1
steps = 0:0.1:10

# ╔═╡ 75bcd5d0-38e8-11eb-0b95-9398ad37a65c
@bind i Slider(1:length(steps))

# ╔═╡ 611471b0-38e8-11eb-364b-87ecbaae5610
function drawspring(t)
    x = sin(t)/3 + 0.5
    o = x + randn()/40
    c_true = compose(context(), Compose.circle(x, 0.5, 0.05), fill(colorant"black"))
    c_obs = compose(context(), Compose.circle(o, 0.5, 0.04), fill(colorant"gray"))
    compose(context(), c_obs, c_true)
end

# ╔═╡ bd9bbb00-38e8-11eb-2276-838d5fc09c83
md"""
Here we show the true circle alongside the filtered location.

> **Students!** Suggest changes to the filter parameters to try to improve the filter behavior.
"""

# ╔═╡ 027c2d40-38e9-11eb-1015-4d23d7cca585
@bind i₂ Slider(1:length(steps))

# ╔═╡ 1cd33030-38e9-11eb-0c88-196d87a42505
md"""
## Moving Average

Another simple technique for filtering is to take a moving average. Perhaps the easiest is take a linear combination between your current prediction and your next value. This is an exponential moving average.

$$x' \leftarrow \gamma o + (1-\gamma) x$$
"""

# ╔═╡ 27a544d0-38e9-11eb-3295-c595e9c2cf7f
mutable struct SimpleMovingAverager
    x::Float64
    γ::Float64
end

# ╔═╡ 2bd1d780-38e9-11eb-0049-697616239aa8
function observe!(filter::SimpleMovingAverager, o::Float64)
    x, γ = filter.x, filter.γ
    xp = γ*o + (1-γ)*x
    filter.x = xp
    return filter
end

# ╔═╡ d5e38d00-38e8-11eb-3db0-7f0bfddc1f39
function drawspring(t, filter::AlphaBetaFilter)
	x = sin(t)/3+0.5
	o = x + randn()/40
	observe!(filter, o)

	c_true = compose(context(), Compose.circle(x, 0.5, 0.05), fill(colorant"black"))
	c_obs = compose(context(), Compose.circle(o, 0.5, 0.04), fill(colorant"gray"))
	c_filter =
		compose(context(), Compose.circle(filter.x, 0.5, 0.03), fill(colorant"blue"))
	compose(context(), c_filter, c_obs, c_true)
end


# ╔═╡ 39321110-38e9-11eb-3c69-89e2400dcd03
function drawspring(t, γfilter::SimpleMovingAverager)
	x = sin(t)/3+0.5
	o = x + randn()/40
	observe!(γfilter, o)

	c_true = compose(context(), Compose.circle(x, 0.5, 0.05), fill(colorant"black"))
	c_obs = compose(context(), Compose.circle(o, 0.5, 0.04), fill(colorant"gray"))
	c_filter =
		compose(context(), Compose.circle(γfilter.x, 0.5, 0.03), fill(colorant"blue"))
	compose(context(), c_filter, c_obs, c_true)
end


# ╔═╡ 8dd9ee4e-38e8-11eb-29e0-3b244362e6dd
animate(drawspring, steps, i)

# ╔═╡ cd655370-38e8-11eb-2b22-c13c5229da55
begin
	x = 0.5
	v = 0.0
	α = 0.5
	β = 0.5
	dt = 1/30
	abfilter = AlphaBetaFilter(x, v, α, β, dt)

	animate(t->drawspring(t, abfilter), steps, i₂)
end

# ╔═╡ 4a74dc00-38e9-11eb-2912-8f67a686d161
@bind i₃ Slider(1:length(steps))

# ╔═╡ 33193ec0-38e9-11eb-2b26-59579c4f1e09
begin
	γ = 0.5
	γfilter = SimpleMovingAverager(0.5, γ)
	animate(t->drawspring(t, γfilter), steps, i₃)
end

# ╔═╡ 53a12fe0-38e9-11eb-2c88-239705b5d148
md"""
## Noisy Mountain Car

We extend the Mountain Car example from last week with sensor uncertainty. The car now obtains an _observation_ at every frame which it uses to make its decision.

Let us assume that the car has an odometer, but it doesn't work so well. The observation is the true velocity plus zero-mean Gaussian noise:

$$\begin{align}
o &= v + \varepsilon\\
  &= v + \mathcal{N}\bigl(\mu = 0,\, \sigma={}^{1}/_{4}\bigr)
\end{align}$$

The car doesn't have a GPS, so it doesn't get a position estimate.
"""

# ╔═╡ 90b860b0-38e9-11eb-18cf-dd11ca2d32ff
observation(car::MountainCar) = car.v + randn()/4

# ╔═╡ 98f91c10-38e9-11eb-3c9b-d799e95b11b8
function tick!(car, R, Δt)
    o = observation(car)
    a = o > 0.0 ? :right : :left
    car = AA120Q.update!(car, a)
    R = R*0.99 + reward(car, a)
    render = render_mountain_car(car, render_pos_overlay=true, reward=R)
	return car, R, render
end


# ╔═╡ a50d4d9e-38e9-11eb-3d09-0f6309b5915c
@bind i₄ Slider(1:length(steps))

# ╔═╡ fa1a86f0-38e9-11eb-18dc-4356cc6c79ce
md"""
Let's run a few simulations and compute the mean reward over that time. This lets us estimate the policy performance.
"""

# ╔═╡ 9380a870-38e9-11eb-138b-ef37abc9352a
function get_reward(nsteps::Int)
    car = MountainCar(0.0,0.0)
    R = 0.0
    for t in 1 : nsteps
        o = observation(car)
        a = o > 0.0 ? :right : :left # our policy
        car = AA120Q.update!(car, a)
        R += reward(car, a)
    end
    return R
end

# ╔═╡ 0bcb2ee2-38ea-11eb-2dc6-e10eda47323a
md"""
Now here is the performance of a policy using an exponential moving average:
"""

# ╔═╡ 1b74e340-38ea-11eb-063e-355ce66dd65e
function get_reward(nsteps::Int, γfilter::SimpleMovingAverager)
	car = MountainCar(0.0,0.0)
	R = 0.0
	for t in 1 : nsteps
		o = observation(car)
		observe!(γfilter, o)
		a = γfilter.x > 0.0 ? :right : :left
		car = AA120Q.update!(car, a)
		R += reward(car, a)
	end
	return R
end


# ╔═╡ ff6dbf50-38e9-11eb-2a96-09b5f6eebba1
begin
	nsteps = 1000
	nsimulations = 10
	mean([get_reward(nsteps) for i in 1:nsimulations])
end

# ╔═╡ 0f11f570-38ea-11eb-1253-43efca99fd02
begin
	γ₂ = 0.1
	γfilter₂ = SimpleMovingAverager(0.5, γ)
	nsteps₂ = 1000
	nsimulations₂ = 10
	mean([get_reward(nsteps₂, γfilter₂) for i in 1:nsimulations₂])
end

# ╔═╡ 4551e5ee-38ea-11eb-0343-4bef202b19a7
md"""
That is a _huge_ difference!
"""

# ╔═╡ 56dae1a0-38ea-11eb-0b33-f992edcc1d61
function tick!(car, R, γfilter, Δt)
	o = observation(car)
	observe!(γfilter, o)
	a = γfilter.x > 0.0 ? :right : :left
	car = AA120Q.update!(car, a)
	R = R*0.99 + reward(car, a)
	render = render_mountain_car(car, render_pos_overlay=true, reward=R)
	return car, R, render
end

# ╔═╡ c665ae20-38e9-11eb-29ce-611242d7baf2
begin
	car = MountainCar(0.0,0.0)
	R = 0.0
	animate(dt->(car,R,render)=tick!(car, R, dt), steps, i₄)
	render
end

# ╔═╡ a4c0e5e0-38ea-11eb-0fc5-fbf62ad8579a
steps₅ = 0:0.1:20

# ╔═╡ 9d387e00-38ea-11eb-1631-81b4f6ae1b13
@bind i₅ Slider(1:length(steps₅))

# ╔═╡ 4b357770-38ea-11eb-0c4d-85ce17c1acf2
begin
	γfilter₅ = SimpleMovingAverager(0.5, γ)
	car₅ = MountainCar(0.0,0.0)
	R₅ = 0.0
	animate(dt->(car₅,R₅,render)=tick!(car₅, R₅, γfilter₅, dt), steps₅, i₅)
	render
end

# ╔═╡ eacc2cc5-c7a5-4493-a672-cbc0b5178222
md"---"

# ╔═╡ 02b5d2de-e4d5-4ebb-8f5f-96d4a3e0696e
PlutoUI.TableOfContents(title="Sensors")

# ╔═╡ Cell order:
# ╟─5787cad0-38e7-11eb-0b3e-b3e30d553dc6
# ╟─d3c31370-38e7-11eb-3dd5-8d923a8e5461
# ╟─fa26cde2-38e7-11eb-220d-6ff100eae44a
# ╟─0110abd0-38e8-11eb-173d-0f7d1a29d2b4
# ╠═0bbf8100-38e8-11eb-3903-4fc7b8ae3a74
# ╟─15458da2-38e8-11eb-3595-f18c331c7d3a
# ╠═2ecc9660-38e8-11eb-3639-0122e4e99e31
# ╟─37550920-38e8-11eb-0de7-e9db9a4e99ed
# ╠═63224310-38e8-11eb-0504-470fc81083d9
# ╠═6a3bbc80-38e8-11eb-31d6-7bda573ad22c
# ╠═81de4dd0-38e8-11eb-0394-63e9107c6ba1
# ╠═75bcd5d0-38e8-11eb-0b95-9398ad37a65c
# ╠═611471b0-38e8-11eb-364b-87ecbaae5610
# ╠═8dd9ee4e-38e8-11eb-29e0-3b244362e6dd
# ╟─bd9bbb00-38e8-11eb-2276-838d5fc09c83
# ╠═d5e38d00-38e8-11eb-3db0-7f0bfddc1f39
# ╠═027c2d40-38e9-11eb-1015-4d23d7cca585
# ╠═cd655370-38e8-11eb-2b22-c13c5229da55
# ╟─1cd33030-38e9-11eb-0c88-196d87a42505
# ╠═27a544d0-38e9-11eb-3295-c595e9c2cf7f
# ╠═2bd1d780-38e9-11eb-0049-697616239aa8
# ╠═39321110-38e9-11eb-3c69-89e2400dcd03
# ╠═4a74dc00-38e9-11eb-2912-8f67a686d161
# ╠═33193ec0-38e9-11eb-2b26-59579c4f1e09
# ╟─53a12fe0-38e9-11eb-2c88-239705b5d148
# ╠═8d355472-38e9-11eb-0d1b-4d837618f72a
# ╠═90b860b0-38e9-11eb-18cf-dd11ca2d32ff
# ╠═98f91c10-38e9-11eb-3c9b-d799e95b11b8
# ╠═a50d4d9e-38e9-11eb-3d09-0f6309b5915c
# ╠═c665ae20-38e9-11eb-29ce-611242d7baf2
# ╟─fa1a86f0-38e9-11eb-18dc-4356cc6c79ce
# ╠═9380a870-38e9-11eb-138b-ef37abc9352a
# ╠═ff6dbf50-38e9-11eb-2a96-09b5f6eebba1
# ╟─0bcb2ee2-38ea-11eb-2dc6-e10eda47323a
# ╠═1b74e340-38ea-11eb-063e-355ce66dd65e
# ╠═0f11f570-38ea-11eb-1253-43efca99fd02
# ╟─4551e5ee-38ea-11eb-0343-4bef202b19a7
# ╠═56dae1a0-38ea-11eb-0b33-f992edcc1d61
# ╠═a4c0e5e0-38ea-11eb-0fc5-fbf62ad8579a
# ╠═9d387e00-38ea-11eb-1631-81b4f6ae1b13
# ╠═4b357770-38ea-11eb-0c4d-85ce17c1acf2
# ╟─eacc2cc5-c7a5-4493-a672-cbc0b5178222
# ╠═02b5d2de-e4d5-4ebb-8f5f-96d4a3e0696e
