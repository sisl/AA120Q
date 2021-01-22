### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ ed1e11b2-38bc-11eb-07a0-d9b89d86cdd3
begin
	using PlutoUI

	md"""
	# Learning
	AA120Q: *Building Trust in Autonomy*, Stanford University. 

	## Lecture 4

	Readings:
	- [Decision Making Under Uncertainty, Chapter 2.3, *Parameter Learning*](https://ieeexplore.ieee.org/document/7288676)
	"""
end

# ╔═╡ 86261830-38bd-11eb-3c82-d1b1a33d7e67
using RDatasets, Plots, Distributions

# ╔═╡ 484ccfe0-38bd-11eb-1024-2fc198591f32
md"""
# Parameter Learning
We will discuss how to learn the parameters and structure of probabilstic models from data.

"""

# ╔═╡ c81ca70e-5c42-11eb-3d53-6fbf67312c4c
plotly();

# ╔═╡ 9351ad30-38bd-11eb-3d7c-99b3f6e91c50
md"""
## Maximum likelihood parameter learning
The Iris dataset was used in Fisher's classic 1936 paper, [The Use of Multiple Measurements in Taxonomic Problems](http://rcs.chemometrics.ru/Tutorials/classification/Fisher.pdf). This is perhaps the best known database to be found in the pattern recognition literature. Fisher's paper is a classic in the field and is referenced frequently to this day. The data set contains 3 classes of 50 instances each, where each class refers to a type of iris plant. It includes three iris species with 50 samples each as well as some properties about each flower. One flower species is linearly separable from the other two, but the other two are not linearly separable from each other.
"""

# ╔═╡ ecf389d0-38bd-11eb-0fd2-73943a5e2aec
D = dataset("datasets", "iris")

# ╔═╡ 54155d00-38be-11eb-3674-b3f8c4bfc6ff
d = D[!,:SepalLength]

# ╔═╡ e4447420-2fc2-4979-84fb-c1b9975087da
histogram(d)

# ╔═╡ 866d8c00-38be-11eb-0011-296e57efb13d
dist = fit_mle(Normal, d)

# ╔═╡ c1985628-5694-4be8-a233-69a4394f9662
begin
	histogram(d, normalize=true)
	plot!(x->pdf(dist, x), xlim=xlims())
end

# ╔═╡ 8db197e0-38be-11eb-2822-0d804bbcf572
md"""
## Bayesian parameter learning
"""

# ╔═╡ da97c2de-38bf-11eb-01d3-39b22e344502
md"""
We can create a small helper function for plotting Beta distributions.
"""

# ╔═╡ f6d99b4e-38be-11eb-1b41-870b0b764993
Plots.plot(d::Beta) = plot(x->pdf(d,x), xlim=(0,1), label=nothing)

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

# ╔═╡ 184e500a-5d04-4bc3-af39-b45a176642c0
begin
	histogram(d, normalize=true, bins=30)
	plot!(p, xlim=(4,8))
end

# ╔═╡ 6541a7d0-38c0-11eb-194f-a50cc0f89f5f
bandwidths = [0.01, 0.1, 0.2, 0.5]

# ╔═╡ 9ad3152d-122a-47c3-919f-a12eb0d7373f
begin
	gp = []
	for bandwidth in bandwidths
		K(x) = pdf(Normal(0,bandwidth), x) # kernal
		p(x) = sum([K(x - o) for o in d])/length(d) # nonparametric density function
		histogram(d, normalize=true, bins=30, label=nothing)
		g′ = plot!(p, xlim=(4,8), label=bandwidth)
		push!(gp, g′)
	end
	plot(gp..., layout=@layout([a b; c d]))
end

# ╔═╡ 79e83a35-758f-4ccf-8125-7c77ef45209e
md"---"

# ╔═╡ b81f16d4-c01e-4228-8233-b81c8df42a51
PlutoUI.TableOfContents(title="Learning")

# ╔═╡ Cell order:
# ╟─ed1e11b2-38bc-11eb-07a0-d9b89d86cdd3
# ╟─484ccfe0-38bd-11eb-1024-2fc198591f32
# ╠═86261830-38bd-11eb-3c82-d1b1a33d7e67
# ╠═c81ca70e-5c42-11eb-3d53-6fbf67312c4c
# ╟─9351ad30-38bd-11eb-3d7c-99b3f6e91c50
# ╠═ecf389d0-38bd-11eb-0fd2-73943a5e2aec
# ╠═54155d00-38be-11eb-3674-b3f8c4bfc6ff
# ╠═e4447420-2fc2-4979-84fb-c1b9975087da
# ╠═866d8c00-38be-11eb-0011-296e57efb13d
# ╠═c1985628-5694-4be8-a233-69a4394f9662
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
# ╠═184e500a-5d04-4bc3-af39-b45a176642c0
# ╠═6541a7d0-38c0-11eb-194f-a50cc0f89f5f
# ╠═9ad3152d-122a-47c3-919f-a12eb0d7373f
# ╟─79e83a35-758f-4ccf-8125-7c77ef45209e
# ╠═b81f16d4-c01e-4228-8233-b81c8df42a51
