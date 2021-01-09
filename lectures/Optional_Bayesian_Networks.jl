### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 87b6ba50-40c0-11eb-3e37-99699a3af348
begin
	using PlutoUI

	md"""
	# Bayesian Networks
	AA120Q: *Building Trust in Autonomy*, Stanford University.

	### Optional Lecture
	We will discuss Bayesian networks and how to perform inference.
	
	Readings:
	- [Decision Making Under Uncertainty, Chapter 2.4, *Structure Learning*](https://ieeexplore.ieee.org/document/7288676)
	"""
end

# ╔═╡ f5cc3a00-40c1-11eb-3702-a9c4a755e806
using BayesNets

# ╔═╡ f0087c34-54a1-48c6-89db-f9a353c04408
using Plots

# ╔═╡ f5c953d0-40c1-11eb-264a-1fb03c3eb399
md"""
## BayesNets.jl
This package provides a Bayesian network type (`BayesNet`) and associated algorithms in Julia.
"""

# ╔═╡ f5d22d6e-40c1-11eb-1370-63d289411645
bayesdata = DataFrame(c=[1,1,1,1,2,2,2,2,3,3],
	                  b=[1,1,1,2,2,2,2,1,1,2],
	                  a=[1,1,1,2,1,1,2,1,1,2])

# ╔═╡ c7ba38d2-40c4-11eb-2153-3d124f6da725
md"""
A *Bayesian network* is a directed acyclic graph (DAG) comprised of conditional probability distributions.
"""

# ╔═╡ f5d820e0-40c1-11eb-005f-3d5441e8f707
bn = fit(DiscreteBayesNet, bayesdata, (:a=>:b, :a=>:c, :b=>:c))

# ╔═╡ f5dded40-40c1-11eb-2aba-a3479f1d9706
md"""
Evaluate the probability density (PDF) of a specific assignment.
"""

# ╔═╡ f5df25c0-40c1-11eb-3f4f-0d0193915c3f
pdf(bn, :a=>1, :b=>1, :c=>2)

# ╔═╡ f5e6c6e2-40c1-11eb-2ad1-9f316a91057c
md"""
Sample the network to get an assignment.
"""

# ╔═╡ f5eba8e0-40c1-11eb-2bf9-e79b68132e6f
rand(bn)

# ╔═╡ f5f0d900-40c1-11eb-3b09-e17dc6ad4ed0
rand(bn, 5) # returns a DataFrame

# ╔═╡ b4df1a9e-40c4-11eb-34fd-29ac9eac9466
md"""
## Bayesian Networks as Statistical Models
"""

# ╔═╡ b4e7a622-40c4-11eb-165d-0371dea62ecf
bn2 = DiscreteBayesNet();

# ╔═╡ b4ef9560-40c4-11eb-224f-cf2c9bd452c5
begin
	push!(bn2, DiscreteCPD(:B, [0.1, 0.9]))
	push!(bn2, DiscreteCPD(:S, [0.5, 0.5]))
	push!(bn2, rand_cpd(bn2, 2, :E, [:B, :S]))
	push!(bn2, rand_cpd(bn2, 2, :D, [:E]))
	push!(bn2, rand_cpd(bn2, 2, :C, [:E]))
end

# ╔═╡ b4f64c20-40c4-11eb-0347-ebeabbffbc60
md"""
Let's compute the probabilty of an assignment using the chain rule.
"""

# ╔═╡ b4ff4cd0-40c4-11eb-0488-5d01d4472911
asgn = Assignment(:B=>1,
                  :S=>2,
                  :E=>1,
                  :D=>2,
                  :C=>2)

# ╔═╡ b5073c0e-40c4-11eb-1416-2f03cadd04f8
md"""
Here are the conditional probabilities.
"""

# ╔═╡ b5119c50-40c4-11eb-0553-5f213e284478
[pdf(get(bn2, name), asgn) for name in names(bn2)]

# ╔═╡ b51bae70-40c4-11eb-0c92-ddf4ad932b00
prod([pdf(get(bn2, name), asgn) for name in names(bn2)])

# ╔═╡ b524af20-40c4-11eb-2d93-cf309cd74995
md"""
The `BayesNets` library implements this for you.
"""

# ╔═╡ b53020d0-40c4-11eb-09d9-39577bef6846
pdf(bn2, asgn)

# ╔═╡ 370b6cd0-40c6-11eb-137c-2be69df81147
md"""
## Structure Learning
A *Bayesian network* is a graphical and condensed representation of a joint probability distribution. Each node in the network represents a random variable. Each directed edge indicates a relationship between nodes. Note that cycles are prohibited in Bayesian networks.

> **Bayesian networks** reduce the number of independent parameters we need to represent a joint distribution.
"""

# ╔═╡ 371753b0-40c6-11eb-32fb-c3ac5cf47021
begin
	bn3 = DiscreteBayesNet()
	push!(bn3, DiscreteCPD(:A, [0.5,0.5]))
	push!(bn3, DiscreteCPD(:B, [:A], [2],
			             [Categorical([0.5,0.5]), Categorical([0.45,0.55])]))
	push!(bn3, CategoricalCPD(:C, Categorical([0.5,0.5])))
end

# ╔═╡ 3721b3f0-40c6-11eb-2a5b-1391247d32b2
rand(bn3, 5)

# ╔═╡ 372efa60-40c6-11eb-2937-858f50ad50d8
u_prior = UniformPrior()

# ╔═╡ 373710b0-40c6-11eb-3242-f5f6e86ac66f
begin
	using Random
	Random.seed!(0)
	
	# generate a lot of data
	data = rand(bn3, 10_000)
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
	score_true = [bayesian_score(bn3, data[1:i, :], u_prior) for i in sample_sizes]
	
	# plot
	plot(sample_sizes,
		 score_unconnected - score_true,
		 marker=".",
		 markersize=3,
		 label="unconnected")
	plot!(sample_sizes,
		  score_connected - score_true,
		  marker=".",
		  markersize=3,
		  label="connected",
		  xlabel="Number of samples",
		  ylabel="Score relative to true model")
end

# ╔═╡ 373e8ac0-40c6-11eb-1e56-6573521ae2bd
md"""
## Inference
Developing a probability distribution for a hidden (query) variable given a set of observations.

Here we use the `BayesNets` package.
"""

# ╔═╡ 3749fc70-40c6-11eb-3094-a905e1201827
md"""
### Inference for classification
"""

# ╔═╡ 37539960-40c6-11eb-2dbc-279bc7387dcb
bn4 = BayesNet();

# ╔═╡ 375b3a80-40c6-11eb-1eaa-5117b25e3c8a
push!(bn4, StaticCPD(:Class, NamedCategorical(["bird", "aircraft"], [0.5, 0.5])));

# ╔═╡ 3764fe80-40c6-11eb-063d-edfe6c8db34e
function fluctuation_distributions(a::Assignment)
	fluctation_states = ["low", "high"]
	if a[:Class] == "bird"
		return NamedCategorical(fluctation_states, [0.1, 0.9])
	else
		return NamedCategorical(fluctation_states, [0.9, 0.1])
	end
end

# ╔═╡ 376f5ebe-40c6-11eb-1ea4-d51b32e51c66
push!(bn4, FunctionalCPD{NamedCategorical}(
		:Fluctuation, [:Class], fluctuation_distributions))

# ╔═╡ 3777c330-40c6-11eb-0917-8b0978cf8ca2
md"""
Function for plotting CPDs (don't worry about the details here).
"""

# ╔═╡ 378298a0-40c6-11eb-316d-4be2bab82b66
function plotCPD(cpd::CPD, range::Tuple{Real,Real}, assignments)
	convert_assignment_to_string(a) = string(["$k = $v, " for (k,v) in a]...)[1:end-2]
	local p = plot()
	for a in assignments
		p = plot!(x->pdf(cpd(a), x), xlim=range,
			      label=convert_assignment_to_string(a))
	end
	return p
end

# ╔═╡ 378a87e0-40c6-11eb-187e-2f6a430e696e
md"""
- If *bird*, then  $\text{airspeed} \approx \mathcal{N}(45, 10)$.
- If *aircraft*, then  $\text{airspeed} \approx \mathcal{N}(100, 40)$.
"""

# ╔═╡ 379472f0-40c6-11eb-3f85-9f8742896a8e
airspeed_distributions(a::Assignment) =
	a[:Class] == "bird" ? Normal(45,10) : Normal(100,40)

# ╔═╡ 379c6230-40c6-11eb-1ebd-1f1fffbb7a52
push!(bn4, FunctionalCPD{Normal}(:Airspeed, [:Class], airspeed_distributions))

# ╔═╡ 37a67450-40c6-11eb-1629-57e064964a93
plotCPD(get(bn4, :Airspeed), (0.0, 100.0),
	    [Assignment(:Class=>c) for c in ["bird", "aircraft"]])

# ╔═╡ 37b8c3d0-40c6-11eb-2eb2-b3826ea552bd
pb = pdf(bn4, :Class=>"bird", :Airspeed=>65, :Fluctuation=>"low")

# ╔═╡ 37c2aede-40c6-11eb-0d6f-e97a4da09500
md"""
Probability of an aircraft given data.
"""

# ╔═╡ 37d3ecf0-40c6-11eb-3416-6decf21807c0
begin
	pa = pdf(bn4, :Class=>"aircraft", :Airspeed=>65, :Fluctuation=>"low")
	pa / (pa + pb)
end

# ╔═╡ 37e244d0-40c6-11eb-14e8-93671cf72680
md"""
View (unnormalized) distribution as a vector.
"""

# ╔═╡ 37f0ead2-40c6-11eb-2271-d9f9962b487a
distr = [pb, pa]

# ╔═╡ 38029e10-40c6-11eb-28ee-0dfb662f4c83
md"""
Now normalize.
"""

# ╔═╡ 3810cee0-40c6-11eb-2d66-472b5554b2e9
distr / sum(distr)

# ╔═╡ faedff1e-9dbf-4d79-9ce5-a32b23e15da5
md"""
## Sampling from Bayesian network
"""

# ╔═╡ 6697b805-c76c-469e-a278-e9d950a88967
begin
	bn5 = BayesNet()
	push!(bn5, StaticCPD(:a, Normal(0,1))) # N(0,1)
	push!(bn5, LinearGaussianCPD(:b, [:a], [2.0], 3.0, 1.0)) # N(2a + 3, 1)
end

# ╔═╡ 4dd8bfdb-6ae5-4f0c-9855-c98cffc9e7a4
rand(bn5) # random assignment

# ╔═╡ 324e0b33-24af-4246-b597-47d820b2fc59
rand(bn5, 5)

# ╔═╡ c62ca870-5232-11eb-24ac-d5a957a8a882
md"""
### You have completed the assignment!
---
"""

# ╔═╡ c5fb864e-5232-11eb-3fb5-990f55a3ba58
PlutoUI.TableOfContents(title="Bayesian Networks")

# ╔═╡ Cell order:
# ╟─87b6ba50-40c0-11eb-3e37-99699a3af348
# ╟─f5c953d0-40c1-11eb-264a-1fb03c3eb399
# ╠═f5cc3a00-40c1-11eb-3702-a9c4a755e806
# ╠═f5d22d6e-40c1-11eb-1370-63d289411645
# ╟─c7ba38d2-40c4-11eb-2153-3d124f6da725
# ╠═f5d820e0-40c1-11eb-005f-3d5441e8f707
# ╟─f5dded40-40c1-11eb-2aba-a3479f1d9706
# ╠═f5df25c0-40c1-11eb-3f4f-0d0193915c3f
# ╟─f5e6c6e2-40c1-11eb-2ad1-9f316a91057c
# ╠═f5eba8e0-40c1-11eb-2bf9-e79b68132e6f
# ╠═f5f0d900-40c1-11eb-3b09-e17dc6ad4ed0
# ╟─b4df1a9e-40c4-11eb-34fd-29ac9eac9466
# ╠═b4e7a622-40c4-11eb-165d-0371dea62ecf
# ╠═b4ef9560-40c4-11eb-224f-cf2c9bd452c5
# ╟─b4f64c20-40c4-11eb-0347-ebeabbffbc60
# ╠═b4ff4cd0-40c4-11eb-0488-5d01d4472911
# ╟─b5073c0e-40c4-11eb-1416-2f03cadd04f8
# ╠═b5119c50-40c4-11eb-0553-5f213e284478
# ╠═b51bae70-40c4-11eb-0c92-ddf4ad932b00
# ╟─b524af20-40c4-11eb-2d93-cf309cd74995
# ╠═b53020d0-40c4-11eb-09d9-39577bef6846
# ╟─370b6cd0-40c6-11eb-137c-2be69df81147
# ╠═371753b0-40c6-11eb-32fb-c3ac5cf47021
# ╠═3721b3f0-40c6-11eb-2a5b-1391247d32b2
# ╠═372efa60-40c6-11eb-2937-858f50ad50d8
# ╠═f0087c34-54a1-48c6-89db-f9a353c04408
# ╠═373710b0-40c6-11eb-3242-f5f6e86ac66f
# ╟─373e8ac0-40c6-11eb-1e56-6573521ae2bd
# ╟─3749fc70-40c6-11eb-3094-a905e1201827
# ╠═37539960-40c6-11eb-2dbc-279bc7387dcb
# ╠═375b3a80-40c6-11eb-1eaa-5117b25e3c8a
# ╠═3764fe80-40c6-11eb-063d-edfe6c8db34e
# ╠═376f5ebe-40c6-11eb-1ea4-d51b32e51c66
# ╟─3777c330-40c6-11eb-0917-8b0978cf8ca2
# ╠═378298a0-40c6-11eb-316d-4be2bab82b66
# ╟─378a87e0-40c6-11eb-187e-2f6a430e696e
# ╠═379472f0-40c6-11eb-3f85-9f8742896a8e
# ╠═379c6230-40c6-11eb-1ebd-1f1fffbb7a52
# ╠═37a67450-40c6-11eb-1629-57e064964a93
# ╠═37b8c3d0-40c6-11eb-2eb2-b3826ea552bd
# ╟─37c2aede-40c6-11eb-0d6f-e97a4da09500
# ╠═37d3ecf0-40c6-11eb-3416-6decf21807c0
# ╟─37e244d0-40c6-11eb-14e8-93671cf72680
# ╠═37f0ead2-40c6-11eb-2271-d9f9962b487a
# ╟─38029e10-40c6-11eb-28ee-0dfb662f4c83
# ╠═3810cee0-40c6-11eb-2d66-472b5554b2e9
# ╟─faedff1e-9dbf-4d79-9ce5-a32b23e15da5
# ╠═6697b805-c76c-469e-a278-e9d950a88967
# ╠═4dd8bfdb-6ae5-4f0c-9855-c98cffc9e7a4
# ╠═324e0b33-24af-4246-b597-47d820b2fc59
# ╟─c62ca870-5232-11eb-24ac-d5a957a8a882
# ╠═c5fb864e-5232-11eb-3fb5-990f55a3ba58
