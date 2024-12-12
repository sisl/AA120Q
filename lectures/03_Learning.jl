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

# ╔═╡ 2bd87d5d-2a77-43b4-82af-ee54a3c2a6e2
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ 86261830-38bd-11eb-3c82-d1b1a33d7e67
begin
	using RDatasets
	using Plots
	using Distributions
	plotlyjs()
end

# ╔═╡ ed1e11b2-38bc-11eb-07a0-d9b89d86cdd3
begin
	md"""
	# Learning
	AA120Q: *Building Trust in Autonomy* 

	## Readings/Videos/References
	- [Decision Making Under Uncertainty, Chapter 2.3, *Parameter Learning*](https://ieeexplore.ieee.org/document/7288676)
	"""
end

# ╔═╡ ecdb3440-7cbf-49c6-baa4-57905c4ca9f2
md"#### Packages Used in this Notebook"

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
d = D[!,:SepalLength]

# ╔═╡ e4447420-2fc2-4979-84fb-c1b9975087da
histogram(d)

# ╔═╡ 0de7489d-092a-44ea-b0fc-0372ee54b7ae
md"""
Given a set of observed data and a model (e.g., a specific probability distribution), we can determine the model parameters that best "fit" the data. One common approach to achieve this is by maximizing the likelihood function. Specifically, we aim to maximize:

``
\mathcal{L}(\theta; \mathbf{X}) = P(\mathbf{X} \mid \theta),
``

where ``\mathbf{X}`` represents the observed data, and ``\theta`` represents the parameters being estimated.

In `Distributions.jl`, this can be done using the `fit_mle` function, which estimates the parameters that maximize the likelihood of the observed data.
"""

# ╔═╡ 866d8c00-38be-11eb-0011-296e57efb13d
dist = fit_mle(Normal, d)

# ╔═╡ b8f3e70d-0195-481e-be4c-ede947668f58
md"#### With other distributions"

# ╔═╡ ce2aab62-f260-4a9a-a0ad-74fdfca5c752
begin
	dist_gamma = fit_mle(Gamma, abs.(d))
	dist_logn = fit_mle(LogNormal, abs.(d))
end

# ╔═╡ 6f8baa52-d5ac-463a-9145-c5a061444dc0
md"""
#### Which is the best fit?
Let's look at the loglikelihood of each model (using the `loglikelihood` function).

- Normal: $(loglikelihood(dist, d))
- Gamma: $(loglikelihood(dist_gamma, d))
- LogNormal: $(loglikelihood(dist_logn, d))
"""

# ╔═╡ ee8702bc-fbaa-4961-80a4-30ce89ceba64
loglikelihood(dist_gamma, d)

# ╔═╡ da97c2de-38bf-11eb-01d3-39b22e344502
# md"""
# We can create a small helper function for plotting Beta distributions.
# """

md"""
## Bayesian Parameter Learning

Bayesian parameter learning takes a probabilistic approach to estimating parameters by combining prior knowledge about the parameters with information from observed data. This is done through **Bayes' Theorem**:

``
P(\theta \mid \mathbf{X}) = \frac{P(\mathbf{X} \mid \theta) P(\theta)}{P(\mathbf{X})},
``

where:
- ``P(\theta \mid \mathbf{X})`` is the posterior distribution of the parameters given the data.
- ``P(\mathbf{X} \mid \theta)`` is the likelihood, which measures how well the parameters explain the data.
- ``P(\theta)`` is the prior distribution, representing our belief about the parameters before observing any data.
- ``P(\mathbf{X})`` is the marginal likelihood, which acts as a normalization constant.

The key idea is that Bayesian parameter learning does not return a single "best" parameter estimate but instead provides a full posterior distribution, reflecting uncertainty about the parameters.
"""

# ╔═╡ ab66c05a-196f-4dbb-aa51-0fe3c0a4a8e4
md"""
### Example: Updating a Beta Prior with Data

Let's assume we are modeling the probability of success in a Bernoulli trial. The **Beta distribution** is often used as a prior for the success probability in such cases because it is the conjugate prior for the Bernoulli and Binomial likelihoods. A [Beta distribution](https://en.wikipedia.org/wiki/Beta_distribution) is defined by two parameters, ``\alpha`` and ``\beta``, which represent "prior counts" of successes and failures, respectively.

The formula for the Beta distribution is:

``
\text{Beta}(p; \alpha, \beta) = \frac{p^{\alpha - 1} (1 - p)^{\beta - 1}}{\text{B}(\alpha, \beta)},
``

where ``\text{B}(\alpha, \beta)`` is a normalization constant.

When we observe new data, the posterior distribution is updated by simply adding the observed counts of successes and failures to the prior parameters. For example:
- If ``x_1, x_2, ..., x_n`` are the observed Bernoulli trials (with 1 indicating success and 0 indicating failure), then:
  - The posterior parameter for successes is ``\alpha + \text{sum}(x)``.
  - The posterior parameter for failures is ``\beta + n - \text{sum}(x)``.

This makes Bayesian updating with the Beta distribution computationally efficient and conceptually intuitive.
"""

# ╔═╡ 8a46226d-829d-42c9-ab6a-985e53c26503
# Define prior
prior = Beta(3, 3)

# ╔═╡ 1f9a229c-38b3-4cdb-8e23-c59e35fabe1f
# Function to update our posterior with observed data
posterior(d::Beta, x) = Beta(d.α + sum(x .== 1), d.β + sum(x .== 0))

# ╔═╡ 96f52385-5bdf-4385-ae19-47f0b164d70c
# Helper functions to plot Beta distributions
begin
	Plots.plot(d::Beta; kwargs...) = plot(x->pdf(d,x); xlim=(0,1), kwargs...)
	Plots.plot!(d::Beta; kwargs...) = plot!(x->pdf(d,x); kwargs...)
end

# ╔═╡ c1985628-5694-4be8-a233-69a4394f9662
begin
	histogram(d, normalize=true, label="Data")
	plot!(x->pdf(dist, x), linewidth=3, ylims=(0, 0.51), label="Fit Distribution")
end

# ╔═╡ 2d6eac6b-fdb5-4d3b-8e3e-a6eed040508a
begin
	histogram(d, normalize=true, label="Data")
	plot!(x->pdf(dist, x), label="Normal", linewidth=2)
	plot!(x->pdf(dist_gamma, x), label="Gamma", linewidth=2)
	plot!(x->pdf(dist_logn, x), label="LogNormal", linewidth=2)
end

# ╔═╡ b54ead52-5171-4101-8a7a-908acff2806e
md"#### Prior Distribution"

# ╔═╡ c885d5f6-65bf-449d-9d2a-08f8a2f2cc58
plot(prior; label="Prior")

# ╔═╡ f9b19d81-bc92-4d78-96ab-cba52880ebbb
md"#### Simulated Data"

# ╔═╡ ac708ccf-f5c2-4253-bf4f-234bd7bd1dc3
data = [1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1]

# ╔═╡ d876c747-2642-4147-bca3-29689d5f7664
md"#### Posterior Distribution"

# ╔═╡ e7601193-b537-4bb7-a79e-b6b29db81841
post = posterior(prior, data)

# ╔═╡ 22b42640-38c0-11eb-1989-9ded52991407
plot(post; label="Posterior")

# ╔═╡ cc065972-75a8-4952-8650-f6928b100d67
md"""
#### Comparison of Prior and Posterior
We can see how the prior distribution updates based on the observed data. In this case, the posterior reflects a higher probability of success as more successes were observed in the data.
"""

# ╔═╡ 46033dde-19c2-4f7e-b511-90adc5ecaa50
begin
	plot(prior; label="Prior")
	plot!(post; label="Posterior")
end

# ╔═╡ 3a1f6f20-f3b2-43e7-98ee-9c8f5299cedd
md"""
### Key Takeaways
1. Bayesian parameter learning integrates prior knowledge with observed data, making it particularly useful when data is limited or noisy.
2. The posterior distribution provides not only point estimates (e.g., mean or mode) but also uncertainty quantification about the parameters.
3. The choice of prior distribution can significantly affect the posterior, especially when the dataset is small.

In this example, the Beta distribution is a conjugate prior for the Bernoulli likelihood, making the computations simple and intuitive.
"""

# ╔═╡ 462b7734-c3e0-44b2-8555-3d40c1bf0cd4
md"""
### Try It Yourself

You can experiment with different prior parameters (``\alpha, \beta``) or datasets to see how they affect the posterior distribution.
"""

# ╔═╡ 7cb4767f-aee8-4021-adfd-9416ca06cbab
md"""
##### Prior
- α: $(@bind α Slider(1:100; default=2, show_value=true))
- β: $(@bind β Slider(1:100; default=2, show_value=true))

##### Data
- Number of successes (s): $(@bind s Slider(0:100; default=0, show_value=true))
- Number of failures (f): $(@bind f Slider(0:100; default=5, show_value=true))
"""

# ╔═╡ ef7081cf-0d98-461e-8764-c6fa332298e4
begin
	prior_try = Beta(α, β)
	data_success = ones(s)
	data_failure = zeros(f)
	data_try = [data_success; data_failure]

	# Update and plot
	post_try = posterior(prior_try, data_try)
	plot(prior_try, label="Prior", legend=:topright)
	plot!(post_try, label="Posterior")
	y_limits = ylims()
	plot!(; ylims=(0.0, y_limits[2]))
end

# ╔═╡ 252dffe0-38c0-11eb-0b9f-e19e63641d4a
md"""
## Nonparametric Parameter Learning

Nonparametric parameter learning refers to methods that do not assume a fixed parametric form for the underlying data distribution. Instead, these methods let the data dictate the structure of the model. One common approach is **Kernel Density Estimation (KDE)**, which estimates the probability density function of a random variable by placing a smooth kernel (e.g., a Gaussian) at each data point.

Key features of nonparametric learning:
- **Flexibility**: Captures complex patterns in the data that parametric models might miss.
- **Data-driven**: Does not require specifying a distribution beforehand.
- **Sensitivity**: Requires careful selection of hyperparameters like bandwidth, which control the smoothness of the estimate.

However, nonparametric methods often struggle with high-dimensional data due to the "curse of dimensionality."
"""

# ╔═╡ 09ea445c-cd6a-40d4-8585-92645f06a685
md"""
### Example: Kernel Density Estimation

Kernel Density Estimation (KDE) uses a kernel function to approximate the probability density function of data. The kernel is a smooth, symmetric function (e.g., Gaussian), and the bandwidth parameter controls the smoothness of the estimate. The KDE formula is:

``
\hat{f}(x) = \frac{1}{n h} \sum_{i=1}^n K\left(\frac{x - x_i}{h}\right),
``

where:
- ``n`` is the number of data points,
- ``h`` is the bandwidth,
- ``K`` is the kernel function (e.g., Gaussian).

In this notebook, we'll use Gaussian kernels to estimate the density of Sepal Lengths from the Iris dataset.
"""

# ╔═╡ 7a694323-0ea1-478a-8aff-9cb33a41d583
md"""
#### Interactive KDE Plot
Use the slider below to adjust the bandwidth and observe its effect on the KDE.
"""

# ╔═╡ 1677fd3f-6d2d-431e-a85c-7c2e2c82d390
# Interactive bandwidth slider
@bind bandwidth Slider(0.01:0.01:1.0, show_value=true, default=0.2)

# ╔═╡ 3b4a1840-38c0-11eb-1724-2385d475868c
K(x) = pdf(Normal(0, bandwidth), x) # kernel

# ╔═╡ 44777d90-38c0-11eb-2b70-8bafca948d30
p(x) = sum([K(x - o) for o in d]) / length(d) # nonparametric density function

# ╔═╡ 184e500a-5d04-4bc3-af39-b45a176642c0
begin
	histogram(d, normalize=true, bins=30)
	plot!(p, xlim=(4,8))
end

# ╔═╡ 9b9800d0-1e07-49fb-b97b-7c5ce30f6e84
md"""
#### Effect of Bandwidth on KDE
Compare KDEs with different bandwidths to see how they capture different levels of detail in the data.
"""

# ╔═╡ 6541a7d0-38c0-11eb-194f-a50cc0f89f5f
# Predefined bandwidths
bandwidths = [0.01, 0.1, 0.5, 1.0]

# ╔═╡ 9ad3152d-122a-47c3-919f-a12eb0d7373f
# Generate plots for each bandwidth
begin
    gp = []
    for h in bandwidths
        K(x) = pdf(Normal(0, h), x)
        p(x) = sum([K(x - o) for o in d]) / length(d)
        histogram(d, normalize=true, bins=30, label=nothing)
        g′ = plot!(p, xlim=(4, 8), label=nothing, title="Bandwidth = $(h)")
        push!(gp, g′)
    end
    plot(gp..., layout=@layout([a b; c d]))
end

# ╔═╡ 66acb3bb-0478-4207-aa6f-ba8cdacbd23f
md"""
### Key Takeaways
1. Nonparametric methods like KDE are powerful tools for exploring data without strong distributional assumptions.
2. The choice of bandwidth critically affects the smoothness of the estimated density:
   - Small bandwidths can overfit (high variance).
   - Large bandwidths can underfit (high bias).
3. Nonparametric methods work best in low-dimensional spaces and may struggle with large datasets or high-dimensional data.

Experiment with different kernels or apply KDE to other features in the Iris dataset for further exploration!
"""

# ╔═╡ 79e83a35-758f-4ccf-8125-7c77ef45209e
md"---"

# ╔═╡ b81f16d4-c01e-4228-8233-b81c8df42a51
PlutoUI.TableOfContents(title="Learning")

# ╔═╡ Cell order:
# ╟─ed1e11b2-38bc-11eb-07a0-d9b89d86cdd3
# ╟─2bd87d5d-2a77-43b4-82af-ee54a3c2a6e2
# ╟─ecdb3440-7cbf-49c6-baa4-57905c4ca9f2
# ╠═86261830-38bd-11eb-3c82-d1b1a33d7e67
# ╟─484ccfe0-38bd-11eb-1024-2fc198591f32
# ╟─9351ad30-38bd-11eb-3d7c-99b3f6e91c50
# ╠═ecf389d0-38bd-11eb-0fd2-73943a5e2aec
# ╠═54155d00-38be-11eb-3674-b3f8c4bfc6ff
# ╠═e4447420-2fc2-4979-84fb-c1b9975087da
# ╟─0de7489d-092a-44ea-b0fc-0372ee54b7ae
# ╠═866d8c00-38be-11eb-0011-296e57efb13d
# ╠═c1985628-5694-4be8-a233-69a4394f9662
# ╟─b8f3e70d-0195-481e-be4c-ede947668f58
# ╠═ce2aab62-f260-4a9a-a0ad-74fdfca5c752
# ╠═2d6eac6b-fdb5-4d3b-8e3e-a6eed040508a
# ╟─6f8baa52-d5ac-463a-9145-c5a061444dc0
# ╠═ee8702bc-fbaa-4961-80a4-30ce89ceba64
# ╟─da97c2de-38bf-11eb-01d3-39b22e344502
# ╟─ab66c05a-196f-4dbb-aa51-0fe3c0a4a8e4
# ╠═8a46226d-829d-42c9-ab6a-985e53c26503
# ╠═1f9a229c-38b3-4cdb-8e23-c59e35fabe1f
# ╠═96f52385-5bdf-4385-ae19-47f0b164d70c
# ╟─b54ead52-5171-4101-8a7a-908acff2806e
# ╠═c885d5f6-65bf-449d-9d2a-08f8a2f2cc58
# ╟─f9b19d81-bc92-4d78-96ab-cba52880ebbb
# ╠═ac708ccf-f5c2-4253-bf4f-234bd7bd1dc3
# ╟─d876c747-2642-4147-bca3-29689d5f7664
# ╠═e7601193-b537-4bb7-a79e-b6b29db81841
# ╠═22b42640-38c0-11eb-1989-9ded52991407
# ╟─cc065972-75a8-4952-8650-f6928b100d67
# ╠═46033dde-19c2-4f7e-b511-90adc5ecaa50
# ╟─3a1f6f20-f3b2-43e7-98ee-9c8f5299cedd
# ╟─462b7734-c3e0-44b2-8555-3d40c1bf0cd4
# ╟─7cb4767f-aee8-4021-adfd-9416ca06cbab
# ╟─ef7081cf-0d98-461e-8764-c6fa332298e4
# ╟─252dffe0-38c0-11eb-0b9f-e19e63641d4a
# ╟─09ea445c-cd6a-40d4-8585-92645f06a685
# ╟─7a694323-0ea1-478a-8aff-9cb33a41d583
# ╠═1677fd3f-6d2d-431e-a85c-7c2e2c82d390
# ╠═3b4a1840-38c0-11eb-1724-2385d475868c
# ╠═44777d90-38c0-11eb-2b70-8bafca948d30
# ╠═184e500a-5d04-4bc3-af39-b45a176642c0
# ╟─9b9800d0-1e07-49fb-b97b-7c5ce30f6e84
# ╠═6541a7d0-38c0-11eb-194f-a50cc0f89f5f
# ╠═9ad3152d-122a-47c3-919f-a12eb0d7373f
# ╟─66acb3bb-0478-4207-aa6f-ba8cdacbd23f
# ╟─79e83a35-758f-4ccf-8125-7c77ef45209e
# ╠═b81f16d4-c01e-4228-8233-b81c8df42a51
