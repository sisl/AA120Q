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
plotly()

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

# ╔═╡ c1a7bd82-cfc1-40ef-96aa-70817ab72b4f
histogram(fill(normaldata, 4),
	      bins=binlengths,
	      label=binlengths,
	      layout=@layout([a b; c d]))

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
histogram(mixdata, bins=50, ylabel="Counts", size=(650,300))

# ╔═╡ f9588302-07b3-11eb-06d7-e72744021ed9
md"""
> Note the two bumps!
"""

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
# ╟─76bed9b6-ce74-4674-b467-fab1e4dbc62c
# ╠═7947ce84-0811-46f7-abda-57fe3803474e
