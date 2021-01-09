### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 6ec76820-07b1-11eb-1370-332e40369ea0
begin
	using PlutoUI

	md"""
	# Statistical Models
	AA120Q: *Building Trust in Autonomy*, Stanford University. 

	## Lecture 3
	We will introduce a variety of statistical models, their representations, and their properties.

	Readings:
	- [Decision Making Under Uncertainty, Chapter 2.1, Probabilistic Models](https://ieeexplore.ieee.org/document/7288676)
	"""
end

# ╔═╡ c713edf2-07b1-11eb-31e0-8d1bbd52df85
using Plots, Distributions

# ╔═╡ 18baf1ce-07b2-11eb-2f7c-772a9ebc3202
md"""
### Required Packages
"""

# ╔═╡ 91179d43-f4eb-448e-b0c1-db8032b0636c
pyplot()

# ╔═╡ 620bdd90-07b2-11eb-0eec-8b2cd40146fe
md"""
## Piecewise Constant Distributions
"""

# ╔═╡ 6e2f2a50-07b2-11eb-00da-f7471cea0159
md"""
Define a normal distribution with mean 3 and standard deviation 2.
"""

# ╔═╡ 67387b20-07b2-11eb-134f-fd357e966195
dist = Normal(3, 2)

# ╔═╡ 778155b0-07b2-11eb-36fc-dfaa5a5dccae
md"""
Generate 1000 samples.
"""

# ╔═╡ 7d3b1812-07b2-11eb-18d1-9b2b7fad09ec
normaldata = rand(dist, 1000)

# ╔═╡ 8c823a10-07b2-11eb-2218-0f413adc9742
md"""
Try out histogram with a variety of different number of bins.
"""

# ╔═╡ 9d27daa0-07b2-11eb-1219-83892809a84b
binlengths = [3 10 50 1000];

# ╔═╡ 1ffff2a0-07b3-11eb-3758-63bebdfbbd63
md"""
Of course, these plots are not of densities (they do not integrate to $1$).
"""

# ╔═╡ 2b146770-07b3-11eb-2bea-97a975211912
md"""
## Mixture Model
This example will focus on Gaussian mixture components, but the code can support components from other distributions.
"""

# ╔═╡ 51b66360-07b3-11eb-2223-cbbc34a3a5d7
mixture = MixtureModel([Normal(-3,1), Normal(4,2)], [0.8, 0.2])

# ╔═╡ 4a0f9e12-07b3-11eb-1cc1-37296c943a89
mixdata = rand(mixture, 1000);

# ╔═╡ 8e550590-17aa-4c3f-a2e5-0890fffe34d8
histogram(mixdata, bins=50, ylabel="Counts", size=(1000,400))

# ╔═╡ f9588302-07b3-11eb-06d7-e72744021ed9
md"""
> Note the two bumps!
"""

# ╔═╡ fd9b0eb0-07b3-11eb-0e39-f1efd8768dba
md"""
## Conditional Probability Distributions

### Binary
There are many types of conditional probability distributions. Here we'll focus on those with binary variables whose distribution can be specified using a table.

$$P(C \mid B, S)$$
"""

# ╔═╡ 1a635fc0-07b4-11eb-3822-5d56d9126102
target = :C

# ╔═╡ 25dcff00-07b4-11eb-2e0c-770744864b7f
parents = [:B, :S]

# ╔═╡ 3135a8c0-07b4-11eb-1361-f510714eecde
md"""
 $B$ and $S$ can each take on discrete values $1$ or $2$.
"""

# ╔═╡ 29821230-07b4-11eb-0942-eb1dc8923fb1
parental_ncategories = [2, 2]

# ╔═╡ 5526dc90-07b4-11eb-008c-e1f420f42e8b
md"""
$$P(C = \text{true} \mid B=1, S=1) = 0.8$$
"""

# ╔═╡ 44a62920-07b4-11eb-2717-f1cb9e23ff60
distributions = [Bernoulli(0.8), # B = 1, S = 1
	             Bernoulli(0.2), # B = 2, S = 1
	             Bernoulli(0.3), # B = 1, S = 2
	             Bernoulli(0.5)] # B = 2, S = 2

# ╔═╡ 85ef43d0-07b4-11eb-2405-c154277e0bfa
cpd = CategoricalCPD(target, parents, parental_ncategories, distributions)

# ╔═╡ a11de210-07b4-11eb-03fa-0768328171b3
md"""
Let's make an assignment of variables to values.
"""

# ╔═╡ aa921460-07b4-11eb-15e8-63ba9bae6f08
an = Assignment(:B=>1, :S=>2)

# ╔═╡ b4744ac0-07b4-11eb-3cf0-c3856c679b7d
pdf(cpd(an), true)

# ╔═╡ bdc45340-07b4-11eb-228e-955251273328
md"""
### Linear Gaussian

$$\mathcal N(\mu=ax + b,\ \sigma)$$

The constructor of `CPDs.Normal` takes a function mapping an assignment to a tuple of parameters (i.e. mean and variance) for the Normal distribution.
"""

# ╔═╡ 0d3627a0-07b5-11eb-1483-37b47fc7cd2b
a = [5]; b = 0; σ = 1;

# ╔═╡ c1a7bd82-cfc1-40ef-96aa-70817ab72b4f
histogram(fill(normaldata, 4),
	      bins=binlengths,
	      label=binlengths,
	      layout=@layout([a b; c d]))

# ╔═╡ 19d5a940-07b5-11eb-184f-fd1cb3b4f9cc
lgcpd = LinearGaussianCPD(:y, [:x], a, b, σ)

# ╔═╡ e2ec86c2-ac0b-4a35-9781-ea490df78be7
plot(x->pdf(lgcpd(:x=>1), x), 0:0.1:10, size=(1000, 400))

# ╔═╡ da831bc8-00e6-4f16-845f-940b931c60ac
plot([[pdf(lgcpd(:x=>x), j) for j in -10:0.1:10] for x in -1:1],
	 layout=@layout([a b c]),
	 size=(1000, 300))

# ╔═╡ 76bed9b6-ce74-4674-b467-fab1e4dbc62c
md"---"

# ╔═╡ 7947ce84-0811-46f7-abda-57fe3803474e
PlutoUI.TableOfContents(title="Statistical Models")

# ╔═╡ Cell order:
# ╟─6ec76820-07b1-11eb-1370-332e40369ea0
# ╟─18baf1ce-07b2-11eb-2f7c-772a9ebc3202
# ╠═c713edf2-07b1-11eb-31e0-8d1bbd52df85
# ╠═91179d43-f4eb-448e-b0c1-db8032b0636c
# ╟─620bdd90-07b2-11eb-0eec-8b2cd40146fe
# ╟─6e2f2a50-07b2-11eb-00da-f7471cea0159
# ╠═67387b20-07b2-11eb-134f-fd357e966195
# ╟─778155b0-07b2-11eb-36fc-dfaa5a5dccae
# ╠═7d3b1812-07b2-11eb-18d1-9b2b7fad09ec
# ╟─8c823a10-07b2-11eb-2218-0f413adc9742
# ╠═9d27daa0-07b2-11eb-1219-83892809a84b
# ╠═c1a7bd82-cfc1-40ef-96aa-70817ab72b4f
# ╟─1ffff2a0-07b3-11eb-3758-63bebdfbbd63
# ╟─2b146770-07b3-11eb-2bea-97a975211912
# ╠═51b66360-07b3-11eb-2223-cbbc34a3a5d7
# ╠═4a0f9e12-07b3-11eb-1cc1-37296c943a89
# ╠═8e550590-17aa-4c3f-a2e5-0890fffe34d8
# ╟─f9588302-07b3-11eb-06d7-e72744021ed9
# ╟─fd9b0eb0-07b3-11eb-0e39-f1efd8768dba
# ╠═1a635fc0-07b4-11eb-3822-5d56d9126102
# ╠═25dcff00-07b4-11eb-2e0c-770744864b7f
# ╟─3135a8c0-07b4-11eb-1361-f510714eecde
# ╠═29821230-07b4-11eb-0942-eb1dc8923fb1
# ╟─5526dc90-07b4-11eb-008c-e1f420f42e8b
# ╠═44a62920-07b4-11eb-2717-f1cb9e23ff60
# ╠═85ef43d0-07b4-11eb-2405-c154277e0bfa
# ╟─a11de210-07b4-11eb-03fa-0768328171b3
# ╠═aa921460-07b4-11eb-15e8-63ba9bae6f08
# ╠═b4744ac0-07b4-11eb-3cf0-c3856c679b7d
# ╟─bdc45340-07b4-11eb-228e-955251273328
# ╠═0d3627a0-07b5-11eb-1483-37b47fc7cd2b
# ╠═19d5a940-07b5-11eb-184f-fd1cb3b4f9cc
# ╠═e2ec86c2-ac0b-4a35-9781-ea490df78be7
# ╠═da831bc8-00e6-4f16-845f-940b931c60ac
# ╟─76bed9b6-ce74-4674-b467-fab1e4dbc62c
# ╠═7947ce84-0811-46f7-abda-57fe3803474e
