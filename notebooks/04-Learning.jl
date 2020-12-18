### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ ed1e11b2-38bc-11eb-07a0-d9b89d86cdd3
begin
	using PlutoUI
	# pkg"add https://github.com/shashankp/PlutoUI.jl#TableOfContents-element"

	md"""
	# Learning
	AA120Q: *Building Trust in Autonomy*, Stanford University. 

	## Lecture 4

	Readings:
	- [Decision Making Under Uncertainty, Chapter 2.3, *Parameter Learning*](https://ieeexplore.ieee.org/document/7288676)
	"""
end

# ╔═╡ 86261830-38bd-11eb-3c82-d1b1a33d7e67
using RDatasets, PGFPlots, Distributions

# ╔═╡ 0a3d5f90-38c1-11eb-0d44-512351fc824f
using BayesNets

# ╔═╡ 484ccfe0-38bd-11eb-1024-2fc198591f32
md"""
# Parameter Learning
We will discuss how to learn the parameters and structure of probabilstic models from data.

"""

# ╔═╡ 9351ad30-38bd-11eb-3d7c-99b3f6e91c50
md"""
## Maximum likelihood parameter learning
The Iris dataset was used in Fisher's classic 1936 paper, [The Use of Multiple Measurements in Taxonomic Problems](http://rcs.chemometrics.ru/Tutorials/classification/Fisher.pdf). This is perhaps the best known database to be found in the pattern recognition literature. Fisher's paper is a classic in the field and is referenced frequently to this day. The data set contains 3 classes of 50 instances each, where each class refers to a type of iris plant. It includes three iris species with 50 samples each as well as some properties about each flower. One flower species is linearly separable from the other two, but the other two are not linearly separable from each other.
"""

# ╔═╡ ecf389d0-38bd-11eb-0fd2-73943a5e2aec
D = dataset("datasets", "iris")

# ╔═╡ 54155d00-38be-11eb-3674-b3f8c4bfc6ff
d = D[:SepalLength]

# ╔═╡ 5be973e0-38be-11eb-16c7-7b1130512901
Plots.Histogram(d)

# ╔═╡ 866d8c00-38be-11eb-0011-296e57efb13d
dist = fit_mle(Normal, d)

# ╔═╡ 60a80d60-38be-11eb-06cc-d5dc62b09b2d
g = Axis([
		Plots.Histogram(d, density=true),
		Plots.Linear(x->pdf(dist,x), (4,8))])

# ╔═╡ 8db197e0-38be-11eb-2822-0d804bbcf572
md"""
## Bayesian parameter learning
"""

# ╔═╡ da97c2de-38bf-11eb-01d3-39b22e344502
md"""
We can create a small helper function for plotting Beta distributions.
"""

# ╔═╡ f6d99b4e-38be-11eb-1b41-870b0b764993
PGFPlots.plot(d::Beta) = plot(x->pdf(d,x), (0,1))

# ╔═╡ ef5c6190-38bf-11eb-11ad-298720051db2
prior = Beta(6,2)

# ╔═╡ f4172a80-38bf-11eb-0868-a762fea0b6d0
plot(prior)

# ╔═╡ f6b3a750-38bf-11eb-2445-352c9cf0d76b
posterior(d::Beta, x) = Beta(d.α + sum(x .== 1), d.β + sum(x .== 0))

# ╔═╡ 08e4c9e0-38c0-11eb-153a-6d5cdfc0ae6e
md"""
The posterior function is probided by `Distributions.jl`.
"""

# ╔═╡ 143a3f50-38c0-11eb-2165-57c0d0e46f94
post = posterior(prior, [0, 0, 1])

# ╔═╡ 22b42640-38c0-11eb-1989-9ded52991407
plot(post)

# ╔═╡ 252dffe0-38c0-11eb-0b9f-e19e63641d4a
md"""
## Nonparametric parameter learning
"""

# ╔═╡ 2c160910-38c0-11eb-2c4f-0d68f045d2a5
bandwidth = 0.2

# ╔═╡ 3b4a1840-38c0-11eb-1724-2385d475868c
K(x) = pdf(Normal(0,bandwidth), x) # kernel

# ╔═╡ 44777d90-38c0-11eb-2b70-8bafca948d30
p(x) = sum([K(x - o) for o in d])/length(d) # nonparametric density function

# ╔═╡ 560226f0-38c0-11eb-0b09-81a12d2f5d4e
gₙₚ = Axis([
		Plots.Histogram(d, density=true, bins=30),
		Plots.Linear(p, (4,8))])

# ╔═╡ 6541a7d0-38c0-11eb-194f-a50cc0f89f5f
bandwidths = [0.01, 0.1, 0.2, 0.5]

# ╔═╡ 78b4c042-38c0-11eb-0ba5-ff8fc4bfa891
begin
	gp = GroupPlot(2,2)
	for bandwidth in bandwidths
		K(x) = pdf(Normal(0,bandwidth), x) # kernal
		p(x) = sum([K(x - o) for o in d])/length(d) # nonparametric density function
		g′ = Axis([
				Plots.Histogram(d, density=true, bins=30),
				Plots.Linear(p, (4,8))], title=bandwidth)
		push!(gp, g′)
	end
end

# ╔═╡ c77ac440-38c0-11eb-3eee-afbaf08d7bff
gp

# ╔═╡ c8b65180-38c0-11eb-12f4-959a32c434ac
md"""
# Structure learning
A *Bayesian network* is a graphical and condensed representation of a joint probability distribution. Each node in the network represents a random variable. Each directed edge indicates a relationship between nodes. Note that cycles are prohibited in Bayesian networks.

> **Bayesian networks** reduce the number of independent parameters we need to represent a joint distribution.
"""

# ╔═╡ 1326de10-38c1-11eb-2973-6b9cb97fe385
begin
	b = DiscreteBayesNet()
	push!(b, DiscreteCPD(:A, [0.5,0.5]))
	push!(b, DiscreteCPD(:B, [:A], [2],
			             [Categorical([0.5,0.5]), Categorical([0.45,0.55])]))
	push!(b, CategoricalCPD(:C, Categorical([0.5,0.5])))
end

# ╔═╡ 5858f2c0-38c1-11eb-3be9-e3903fe83070
rand(b, 5)

# ╔═╡ 64c8d8e0-38c1-11eb-1e23-01b78e1d2561
u_prior = UniformPrior()

# ╔═╡ 7cba9ba0-38c1-11eb-2dd9-530078f01506
begin
	using Random
	Random.seed!(0)
	
	# generate a lot of data
	data = rand(b, 10_000)
	sample_sizes = collect(1:1000:size(data,1))
	
	# unconnected
	b_unconnected = fit(DiscreteBayesNet, data, tuple())
	score_unconnected =
		[bayesian_score(b_unconnected, data[1:i, :], u_prior) for i in sample_sizes]
	
	# fully connected
	b_connected = fit(DiscreteBayesNet, data, (:A=>:B, :A=>:C, :B=>:C))
	score_connected =
		[bayesian_score(b_connected, data[1:i, :], u_prior) for i in sample_sizes]
	
	# truth values
	score_true = [bayesian_score(b, data[1:i, :], u_prior) for i in sample_sizes]
	
	# plot
	Axis(Plots.Plot[
			Plots.Linear(sample_sizes, score_unconnected - score_true,
				legendentry="unconnected"),
			Plots.Linear(sample_sizes, score_connected - score_true, 
				legendentry="connected")],
		xlabel="Number of samples", ylabel="Score relative to true model",
		width="25cm", height="8cm")
end

# ╔═╡ e592d160-38c1-11eb-198f-a3518a626d27
md"""
## Inference
Developing a probability distribution for a hidden (query) variable given a set of observations.

Here we use the `BayesNets` package.
"""

# ╔═╡ b47c7130-38c1-11eb-1112-83087c77df87
md"""
### Inference for classification
"""

# ╔═╡ ca9538c0-38c2-11eb-2b2c-b33b0b8b0257
bn = BayesNet();

# ╔═╡ d755d6f0-38c2-11eb-0c7d-738043cee25d
push!(bn, StaticCPD(:Class, NamedCategorical(["bird", "aircraft"], [0.5, 0.5])))

# ╔═╡ 9861bde0-38c4-11eb-081b-e5ae7eb6b613
function fluctuation_distributions(a::Assignment)
	fluctation_states = ["low", "high"]
	if a[:Class] == "bird"
		return NamedCategorical(fluctation_states, [0.1, 0.9])
	else
		return NamedCategorical(fluctation_states, [0.9, 0.1])
	end
end

# ╔═╡ f26ac0c2-38c4-11eb-1761-1d403c88bac9
push!(bn, FunctionalCPD{NamedCategorical}(
		:Fluctuation, [:Class], fluctuation_distributions))

# ╔═╡ cc001360-38c2-11eb-1d98-cb53c91fc08e
md"""
Function for plotting CPDs (don't worry about the details here).
"""

# ╔═╡ f62d58f0-38c2-11eb-318a-21b55797020e
function plotCPD(cpd::CPD, range::Tuple{Real,Real}, assignments)
	convert_assignment_to_string(a) = string(["$k = $v, " for (k,v) in a]...)[1:end-2]
	Axis(Plots.Plot[
			Plots.Linear(x->pdf(cpd(a), x), range,
				legendentry=convert_assignment_to_string(a)) for a in assignments],
		width="25cm", height="8cm")
end

# ╔═╡ 3379a380-38c3-11eb-2b10-29107a7e5ffd
md"""
- If *bird*, then  $\text{airspeed} \approx \mathcal{N}(45, 10)$.
- If *aircraft*, then  $\text{airspeed} \approx \mathcal{N}(100, 40)$.
"""

# ╔═╡ 880d4000-38c3-11eb-2841-696675dd3d14
airspeed_distributions(a::Assignment) =
	a[:Class] == "bird" ? Normal(45,10) : Normal(100,40)

# ╔═╡ ad5662b0-38c3-11eb-30ff-895b109dc0a7
push!(bn, FunctionalCPD{Normal}(:Airspeed, [:Class], airspeed_distributions))

# ╔═╡ 81122400-38c3-11eb-3062-0d12a5ac9d45
plotCPD(get(bn, :Airspeed), (0.0, 100.0),
	    [Assignment(:Class=>c) for c in ["bird", "aircraft"]])

# ╔═╡ fae482f0-38c3-11eb-3e75-61a596b49c28
pb = pdf(bn, :Class=>"bird", :Airspeed=>65, :Fluctuation=>"low")

# ╔═╡ 1f353be0-38c4-11eb-29ca-8b3f9208cd55
md"""
Probability of an aircraft given data.
"""

# ╔═╡ 0c41dac0-38c4-11eb-04f6-fd70b4125216
begin
	pa = pdf(bn, :Class=>"aircraft", :Airspeed=>65, :Fluctuation=>"low")
	pa / (pa + pb)
end

# ╔═╡ 2d51f230-38c5-11eb-09cd-3d85c3f1df48
md"""
View (unnormalized) distribution as a vector.
"""

# ╔═╡ 40781890-38c4-11eb-167b-1ff6007421c6
distr = [pb, pa]

# ╔═╡ 29b9d752-38c5-11eb-0167-fd5237f39f73
md"""
Now normalize.
"""

# ╔═╡ 395cade0-38c5-11eb-2a83-8b2939127916
distr / sum(distr)

# ╔═╡ Cell order:
# ╟─ed1e11b2-38bc-11eb-07a0-d9b89d86cdd3
# ╟─484ccfe0-38bd-11eb-1024-2fc198591f32
# ╠═86261830-38bd-11eb-3c82-d1b1a33d7e67
# ╟─9351ad30-38bd-11eb-3d7c-99b3f6e91c50
# ╠═ecf389d0-38bd-11eb-0fd2-73943a5e2aec
# ╠═54155d00-38be-11eb-3674-b3f8c4bfc6ff
# ╠═5be973e0-38be-11eb-16c7-7b1130512901
# ╠═866d8c00-38be-11eb-0011-296e57efb13d
# ╠═60a80d60-38be-11eb-06cc-d5dc62b09b2d
# ╟─8db197e0-38be-11eb-2822-0d804bbcf572
# ╟─da97c2de-38bf-11eb-01d3-39b22e344502
# ╠═f6d99b4e-38be-11eb-1b41-870b0b764993
# ╠═ef5c6190-38bf-11eb-11ad-298720051db2
# ╠═f4172a80-38bf-11eb-0868-a762fea0b6d0
# ╠═f6b3a750-38bf-11eb-2445-352c9cf0d76b
# ╟─08e4c9e0-38c0-11eb-153a-6d5cdfc0ae6e
# ╠═143a3f50-38c0-11eb-2165-57c0d0e46f94
# ╠═22b42640-38c0-11eb-1989-9ded52991407
# ╟─252dffe0-38c0-11eb-0b9f-e19e63641d4a
# ╠═2c160910-38c0-11eb-2c4f-0d68f045d2a5
# ╠═3b4a1840-38c0-11eb-1724-2385d475868c
# ╠═44777d90-38c0-11eb-2b70-8bafca948d30
# ╠═560226f0-38c0-11eb-0b09-81a12d2f5d4e
# ╠═6541a7d0-38c0-11eb-194f-a50cc0f89f5f
# ╠═78b4c042-38c0-11eb-0ba5-ff8fc4bfa891
# ╠═c77ac440-38c0-11eb-3eee-afbaf08d7bff
# ╟─c8b65180-38c0-11eb-12f4-959a32c434ac
# ╠═0a3d5f90-38c1-11eb-0d44-512351fc824f
# ╠═1326de10-38c1-11eb-2973-6b9cb97fe385
# ╠═5858f2c0-38c1-11eb-3be9-e3903fe83070
# ╠═64c8d8e0-38c1-11eb-1e23-01b78e1d2561
# ╠═7cba9ba0-38c1-11eb-2dd9-530078f01506
# ╟─e592d160-38c1-11eb-198f-a3518a626d27
# ╟─b47c7130-38c1-11eb-1112-83087c77df87
# ╠═ca9538c0-38c2-11eb-2b2c-b33b0b8b0257
# ╠═d755d6f0-38c2-11eb-0c7d-738043cee25d
# ╠═9861bde0-38c4-11eb-081b-e5ae7eb6b613
# ╠═f26ac0c2-38c4-11eb-1761-1d403c88bac9
# ╟─cc001360-38c2-11eb-1d98-cb53c91fc08e
# ╠═f62d58f0-38c2-11eb-318a-21b55797020e
# ╟─3379a380-38c3-11eb-2b10-29107a7e5ffd
# ╠═880d4000-38c3-11eb-2841-696675dd3d14
# ╠═ad5662b0-38c3-11eb-30ff-895b109dc0a7
# ╠═81122400-38c3-11eb-3062-0d12a5ac9d45
# ╠═fae482f0-38c3-11eb-3e75-61a596b49c28
# ╟─1f353be0-38c4-11eb-29ca-8b3f9208cd55
# ╠═0c41dac0-38c4-11eb-04f6-fd70b4125216
# ╟─2d51f230-38c5-11eb-09cd-3d85c3f1df48
# ╠═40781890-38c4-11eb-167b-1ff6007421c6
# ╟─29b9d752-38c5-11eb-0167-fd5237f39f73
# ╠═395cade0-38c5-11eb-2a83-8b2939127916
