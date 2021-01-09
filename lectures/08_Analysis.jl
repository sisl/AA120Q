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

# ╔═╡ 9380a110-38ec-11eb-19dc-bf52f53962ed
begin
	using PlutoUI
	# pkg"add https://github.com/shashankp/PlutoUI.jl#TableOfContents-element"

	md"""
	# Analysis of Autonomous Systems
	AA120Q: *Building Trust in Autonomy*, Stanford University. 

	## Lecture 8
	We will discuss a variety of methods for analyzing the behavior of autonomous systems.
	
	**Assignment**:
	- Run simulations to characterize collision avoidance performance against a variety of metrics; develop methods for visualizing the decision making behavior of your system.
	"""
end

# ╔═╡ f7ad7730-38ec-11eb-264e-7df6986ea713
using Plots

# ╔═╡ e15d3a00-38ed-11eb-0b0a-6198a2729f68
using Distributions

# ╔═╡ 3ecaefa0-3986-11eb-0acb-4b120b339d16
using Random

# ╔═╡ 94fdeed0-3987-11eb-1ecd-f18c99878e8c
using Discretizers

# ╔═╡ b6640af0-3987-11eb-2419-f566f5578055
using Printf

# ╔═╡ b3587c10-38ec-11eb-3668-c19b178940bf
md"""
# Measuring System Effectiveness

It is the designer's responsibility to go back to the field and assess the impact that the autonomous system is having. This measurement process must be both qualitative and quantitative.

__Qualitative__: Deals with the _quality_ of a result. Does the policy followed by the agent look good? Is it behaving reasonably?

__Quantitative__: Objective values that can be quantified. For example, with ACAS X, one should look at operational data on airborne collisions, near-misses, and separation after ACAS X has been put into place.
"""

# ╔═╡ c6aa02c2-38ec-11eb-2ab6-c9e0bb78c682
md"""
## Reward

Autonomous agents are often trained to maximize their reward. Does your agent receive high reward? That's all you care about, right?

Wrong.

We care about the performance of the system in the real world, and the real world is never perfectly modeled.

"""

# ╔═╡ d1beecc2-38ec-11eb-3f97-3173a8f71e9e
md"""
## The Pareto Frontier

When optimizing a real-world system one often must balance a large number of trade-offs.

Which of the following is better?

- an airborne collision avoidance system that has $1$ collision and $1000$ alerts per million flight hours
- an airborne collision avoidance system that has $2$ collisions and $10$ alerts per million flight hours
"""

# ╔═╡ 8465ff13-d4ea-416e-8ef2-8b64dfef0e02
scatter([1,2], [1000,10], color=:black, label=nothing,
	    xlabel="NMACs per million flight hours",
	    ylabel="Alerts per million flight hours")

# ╔═╡ 0d594190-38ed-11eb-1ff7-e35b4413f64d
md"""
Fewer collisions are good, and fewer alerts are good, but we cannot say which collision system is better without making a judgement on their relative value.

We know, therefore, that if we have a set of policies:
"""

# ╔═╡ a47d1795-c181-453c-9104-6cbe1cacc908
scatter([0.5,0.75,1,1.5,2,3,1.8,0.8,2.5,1.2,0.7,1.4],
		[1e5,3e4,1e4,1e3,10,2,2e4,5e4,1e4,1.2e4,9e4,5e4],
		color=:black, label=nothing,
		xlabel="NMACs per million flight hours",
		ylabel="Alerts per million flight hours")

# ╔═╡ 29628860-38ed-11eb-2522-35309354f407
md"""
The policies that are potentially the best are those which cannot be shifted to be made better in both respects:
"""

# ╔═╡ c28fa1bd-7bef-4ae9-b3c4-c8f24d2df5b8
begin
	plot([0.5,0.75,1,1.5,2,3],
		 [1e5,3e4,1e4,1e3,10,2],
		 color=:red, markerstrokecolor=:red, marker="*", label=nothing)
	scatter!([1.8,0.8,2.5,1.2,0.7,1.4],
			 [2e4,5e4,1e4,1.2e4,9e4,5e4],
			 color=:gray, markerstrokecolor=:gray, label=nothing,
			 xlabel="NMACs per million flight hours",
			 ylabel="Alerts per million flight hours")
	annotate!([(1.3, 7e4, text("Approx. Pareto Frontier", 14, :red)),
			   (1.8, 3e4, text("Suboptimal", 14, :gray)),
			   (0.7, 5e3, text("Infeasible", 14, :black))])
end

# ╔═╡ 7c331820-38ed-11eb-290d-813158d5f7ef
md"""
The _Pareto Frontier_ is obtained by adjusting the tradeoff between your multiple objectives and optimizing models to trace out the curve.

The region closer to the origin than the Pareto Frontier is infeasible, whereas the region farther from the origin than the Pareto Frontier is suboptimal.
"""

# ╔═╡ 8202d380-38ed-11eb-25c5-c9a544d969d9
md"""
Given a Pareto Frontier, how do we choose the best policy?

This is often a subjective question, and often requires the careful consideration of factors that are not in your optimization objective. Domain experts are often consulted.
"""

# ╔═╡ 8caface0-38ed-11eb-1bf7-c9519bd208b3
md"""
## Inspect the Decision Making Behavior

Has your agent really learned to do what it was designed to do?

If you have trained a neural network to recognize cats, how do you know whether the neural network has really learned what a cat is?

Below we see the result of optimizing a neural network trained to recognize dumbbells. It turns out that the net sees dumbbells as _dumbbells with forearms_.
"""

# ╔═╡ 90a1f5b0-38ed-11eb-024a-0119c06d5b87
PlutoUI.LocalResource("./figures/dumbbell.png")

# ╔═╡ 9c506090-38ed-11eb-0216-2f7e2609ef54
md"""
## The Black Swan Problem

This problem is known as the Black Swan Problem. The problem gets its name from the black swans of Australia and New Zealand, and the incorrect induction followed by a European:

_All swans I have seen are white, therefore all swans are white_

Of course, once said European goes to southern Australia and sees a black swan they can either change their belief or forever categorize the black swan as an entirely different species.

With autonomous agents we want to make sure that they identify the correct categories. It is often a non-trivial problem.

### For an Autonomous Car, are these Pedestrians?
"""

# ╔═╡ a2d191a0-38ed-11eb-2129-63f199018437
md"""
$(PlutoUI.LocalResource("./figures/pedestrian_1.jpeg"))

Sure looks like a pedestrian.

$(PlutoUI.LocalResource("./figures/pedestrian_2.jpg"))

Also a pedestrian---but this one also has a bike. Maybe our definition should be "A person walking across the street".

$(PlutoUI.LocalResource("./figures/pedestrian_3.jpg"))

Whoops! That didn't work. Hmm. Harder than we thought!
"""

# ╔═╡ cf9587a0-38ed-11eb-00bf-f10725c0dd6b
md"""
### How to Get Past the Black Swan Problem

The Black Swan problem is a fundamental problem in artificial intelligence and machine learning. The best way around it is to have as large and comprehensive dataset as possible and to test on as many corner cases as possible. Visualize your agent's decision making process!
"""

# ╔═╡ d435eac0-38ed-11eb-3ada-73fb39e6d923
md"""
# Cross Validation

In this class you are trying to optimize an airborne collision avoidance system. You have been given a dataset of encounters. How do you go about tuning your model parameters for maximum performance?

- Maximize Performance on the Given Dataset

This option is very tempting. You simply optimize the system to maximize the reward when run in simulation on the training set. What could go wrong?

Let us provide an illustrative example: adjusting the number of histogram bins to get the best fit for a distribution.

Consider the following true distribution:
"""

# ╔═╡ b79d8740-3985-11eb-0f95-1b8a9d1ef77a
true_dist = MixtureModel(
	[Normal(0.0, 0.3), Normal(-1.0, 0.3), Normal(0.0, 1.0)],
	[0.125, 0.125, 0.75])

# ╔═╡ d14c47c7-2527-4bf5-a5a7-bf3aef954548
begin
	x_vals = range(-3, stop=3, length=201)
	y_vals = map(x->pdf(true_dist, x), x_vals)

	plot(x_vals, y_vals,
		 color=:black,
		 linewidth=2,
		 label=nothing,
	     xlabel="x",
		 ylabel="pdf(x)")
end

# ╔═╡ 31e4c80e-3986-11eb-3e3c-efe073a150c7
md"""
You want to get the _best_ model for this distribution. The problem is, all you have to train on is a sample dataset:
"""

# ╔═╡ 41730530-3986-11eb-23cd-cdc38b42393a
Random.seed!(0);

# ╔═╡ 44e03f80-3986-11eb-0faf-a115cf8b245a
samples = rand(true_dist, 100)

# ╔═╡ ee2bb4cc-e22f-427d-89f2-93eb023d5704
histogram(samples, bins=20, normalize=true, xlabel="x", ylabel="pdf(x)")

# ╔═╡ 61b7f9e2-3986-11eb-328f-3b5d75c1fceb
md"""
Suppose we want to use a piecewise uniform distribution with even bin widths. Above I used 20 bins to create one. How do we select the _best_ number of bins?
"""

# ╔═╡ 68bb2c30-3986-11eb-37a7-1de9363d2461
@bind nbins Select(map(b->Pair(string(b), b), [1,2,3,4,5,10,20,50,100]))

# ╔═╡ eae35be5-5ac0-4d64-a8a1-9d02c6736bcc
begin
	histogram(samples, bins=parse(Int,nbins), normalize=true)
	plot!(x_vals, y_vals, color=:black, linewidth=2)
end

# ╔═╡ 77f9cd40-3987-11eb-21fd-af5508ccffae
md"""
Clearly the correct number is somewhere between 5 and 100, but what should we use? Remember, we don't have access to the true distribution.

One approach to use is to do a _train-test split_.

This involves taking the available data and using some to fit the distribution and the rest to check the fitness:
"""

# ╔═╡ 7995a2f0-3987-11eb-048e-39e11ee85467
samples_train = samples[1:90];

# ╔═╡ 8655f300-3987-11eb-1076-6b24adc1425a
samples_test = samples[91:end];

# ╔═╡ 8e4978c0-3987-11eb-07b5-0543a6de1296
md"""
We can then use some metric, perhaps the likelihood of the test data under the learned model, to select the preferred nbins.

This approach tests the ability of your model to generalize to unseen data.
"""

# ╔═╡ 9de1ef10-3987-11eb-3af9-ab5d6200cf0f
function get_likelihood(samples_train, nbins, samples_test)
    lo, hi = extrema([samples_train; samples_test])
    disc = LinearDiscretizer(range(lo, stop=hi,length=nbins+1))
    counts = zeros(Int, nbins)
	for v in samples_train
        counts[encode(disc, v)] += 1
    end
    
    N = sum(counts)
    likelihood = 1.0
    for v in samples_test
        bin = encode(disc, v)
        prob_of_bin = counts[bin] / N
        prob_within_bin = 1/binwidth(disc, bin)
        likelihood *= prob_of_bin * prob_within_bin
    end
    return likelihood
end

# ╔═╡ ba643670-3987-11eb-0b60-0b3e746d61e5
@bind nbinsₜᵣₐᵢₙ Select(map(b->Pair(string(b), b), [1,2,3,4,5,10,20,50,100]))

# ╔═╡ cf3928d0-3987-11eb-11f3-071958340954
begin
	nbins_int = parse(Int, nbinsₜᵣₐᵢₙ)
	likelihood = get_likelihood(samples_train, nbins_int, samples_test)

	histogram(samples_train, bins=nbins_int, normalize=true,
		      title=@sprintf("Likelihood: %10.8f", likelihood))
	plot!(x_vals, y_vals, color=:black, linewidth=2)
end

# ╔═╡ 6426ec20-3988-11eb-285b-6bd07a0578cb
begin
	x_bins = collect(1:100)
	y_likelihoods = map(i->get_likelihood(samples_train, i, samples_test), x_bins)

	plot(x_bins, y_likelihoods, marker=".", markersize=2,
		 xlabel="number of bins",
		 ylabel="test likelihood")
end

# ╔═╡ bd2583e0-3988-11eb-31bd-cd9e862729c1
md"""
Two things:

1. Notice how small the likelihoods are? Maximizing the log-likelihood gives the same result but with nicer numbers
2. Notice those zeros? Those occur whenever we have a training sample with zero likelihood. We can add a _prior_ of one count to each bin to ensure that we get some support. This is also called _Laplace smoothing_.
"""

# ╔═╡ d69b2780-3988-11eb-00e5-ebfcf99ae487
function get_loglikelihood(samples_train, nbins, samples_test)
    lo, hi = extrema([samples_train; samples_test])
    disc = LinearDiscretizer(range(lo, stop=hi, length=nbins+1))
    counts = ones(Int, nbins) # add Laplace smoothing
    for v in samples_train
        counts[encode(disc, v)] += 1
    end
    
    N = sum(counts)
    loglikelihood = 0.0
    for v in samples_test
        bin = encode(disc, v)
        prob_of_bin = counts[bin] / N
        prob_within_bin = 1/binwidth(disc, bin)
        loglikelihood += log(prob_of_bin) + log(prob_within_bin)
    end
    return loglikelihood
end

# ╔═╡ e49c34f0-3988-11eb-28c9-3d1eb163709f
begin
	y_loglikelihoods =
		map(i->get_loglikelihood(samples_train, i, samples_test), x_bins)

	plot(x_bins, y_loglikelihoods, marker=".", markersize=2,
		 xlabel="number of bins",
		 ylabel="test log likelihood")
end

# ╔═╡ 1b1c89d0-3989-11eb-284c-1996a3fe88a2
md"""
Train-test splitting is pretty good, but we can do even better if we do this over multiple train-test splits. _Cross validation_ is one common way of doing this.

In $k$-fold cross validation, you take your training data and divide it into $k$ even chunks. For each chunk, you

- train on all of the $k-1$ other chunks
- test on the chunk

And then take the average over all $k$ validation scores to get your cross-validated score.
"""

# ╔═╡ 356a8c10-3989-11eb-219a-09a2063acde1
begin
	fold1 = samples[ 1:25]
	fold2 = samples[25:50]
	fold3 = samples[50:75]
	fold4 = samples[75:100]

	function get_cv_score(nbins)
		score1 = get_loglikelihood([fold1; fold2; fold3], nbins, fold4)
		score2 = get_loglikelihood([fold2; fold3; fold4], nbins, fold1)
		score3 = get_loglikelihood([fold3; fold4; fold1], nbins, fold2)
		score4 = get_loglikelihood([fold4; fold1; fold2], nbins, fold3)
		mean([score1, score2, score3, score4])
	end

	plot(1:100, map(get_cv_score, 1:100), marker=".", markersize=2,
		 xlabel="number of bins", ylabel="cross-validated log likelihood")
end

# ╔═╡ 4862cf30-3989-11eb-1411-dbb29de448e8
md"""
## Measuring the 'Closeness' of Distributions

One often needs to measure the closeness of two distributions, such as when comparing distributions over emergent metrics to their real-world counterparts.

For example, if you create a car that is supposed to drive like a human, does it tend to drive with the same following distance as a real car does?

We can all agree that the following two distributions are close.
"""

# ╔═╡ 5eea0570-3989-11eb-0b22-d92ddec7684c
real = Normal(0.0, 1.0)

# ╔═╡ 597673d0-3989-11eb-23cc-9f0f87e9522c
function plot_distr(sim, x_vals; title="")
	style = "mark=none, ultra thick"
	plot(x_vals, map(x->pdf(real, x), x_vals), linewidth=2)
	plot!(x_vals, map(x->pdf(sim, x), x_vals), linewidth=2,
		  xlabel="x",
		  ylabel="pdf(x)",
		  title=title)
end

# ╔═╡ 8c943cc2-3989-11eb-10ff-23707e49ebee
plot_distr(Normal(0.1, 1.0), range(-3.0, stop=3.0, length=101))

# ╔═╡ df514480-3989-11eb-2a36-9f9573bc6f80
md"""
We can all agree that the following two distributions are less close.
"""

# ╔═╡ e314dc30-3989-11eb-3914-737f9f1e13bc
plot_distr(Normal(2.0, 1.0), range(-3.0, stop=5.0, length=101))

# ╔═╡ e91b10e0-3989-11eb-05de-8f723cc1cf38
md"""
How close are these distributions?
"""

# ╔═╡ ea40cc30-3989-11eb-2f2c-2d596afb3793
plot_distr(Normal(0.0, 2.0), range(-5.0, stop=5.0, length=101))

# ╔═╡ eff66fe0-3989-11eb-2ae7-97df3ea96db8
plot_distr(MixtureModel([Normal(-1.5, 1.0), Normal(1.5, 1.0)]),
	       range(-5.0, stop=5.0, length=101))

# ╔═╡ 0c6c5b32-398a-11eb-1f2c-2b48efe703ad
sim = MixtureModel([Cauchy(-5, 1.8), Cauchy(-4, 0.8), Cauchy(-1, 0.3), Cauchy(2, 0.8), Cauchy(4, 1.5)], [0.1, 0.4, 0.15, 0.2, 0.15])

# ╔═╡ 1ac573ae-398a-11eb-1979-995ca2fbb1a8
plot_distr(sim, range(-10.0, stop=10.0, length=101))

# ╔═╡ 22b57700-398a-11eb-1a3c-89570be35d12
md"""
The _Kullbeck--Leibler divergence_ is one way to measure closeness. It actually measures divergence, the opposite of closeness.

$$D_{KL}(p \mid\mid q) = \int_{-\infty}^{\infty} p(x) \log \frac{p(x)}{q(x)} \, dx$$

It is $0$ if the two distributions are the same and increases if they are different.

Note that it is non-symmetric, so $D_{KL}(p \mid\mid q) \neq D_{KL}(q \mid\mid p)$.  Here, $p$ is the true distribution and $q$ is what is being used to approximate $p$.
"""

# ╔═╡ 1fdf3010-398b-11eb-2038-991c3fb67e2e
function kldivergence(p::Normal, q::Normal) # KL divergence for two Gaussians
	μ₁, σ₁ = p.μ, p.σ
	μ₂, σ₂ = q.μ, q.σ
	return log(σ₂/σ₁) + (σ₁^2 + (μ₁ - μ₂)^2)/(2σ₂^2) - 0.5
end

# ╔═╡ ebe6c1c2-398e-11eb-1b11-0fef009d4cfc
md"""
The KL divergence for two Gaussian distributions $p=\mathcal{N}(\mu_1, \sigma_1)$ and $q = \mathcal{N}(\mu_2, \sigma_2)$ is:

$$D_{KL}(p \mid\mid q) = \log\left(\frac{\sigma_2}{\sigma_1}\right) + \frac{\sigma_1^2 + (\mu_1 - \mu_2)^2}{2\sigma_2^2} - \frac{1}{2}$$
"""

# ╔═╡ 618f1850-398a-11eb-3567-5fa878048466
x_values = range(-5.0, stop=5.0, length=101)

# ╔═╡ 85fd1d40-398a-11eb-3dcf-d1f72c220fe9
@bind μ Slider(range(-2, stop=2, length=11), show_value=true, default=0)

# ╔═╡ 88d14be0-398a-11eb-08ff-35693b9bcadf
@bind σ Slider(range(0.1, stop=4.0, length=11), show_value=true, default=0.88)

# ╔═╡ 6426b320-398a-11eb-03b3-6542fd5a167a
begin
	p = real # Normal(0, 1)
	q = Normal(μ, σ)
	kl_div = @sprintf("KL divergence = %.3f", kldivergence(p, q))
	ax = plot_distr(q, range(-10.0, stop=10.0, length=101), title=kl_div)
	ylims = (0, 0.5)
    ax
end

# ╔═╡ b11c15d0-398a-11eb-2099-b105de6da150
md"""
# Assignment

Your homework is to:

- Run your collision avoidance system on the training set and pick three encounters where the system fails. Why does it fail? Is this a problem with your design? How might it be fixed?
- Run your collision avoidance system on the training set and compute:
   - the number of NMACs
   - the number of NMACs in which no advisory was issued
   - a histogram over the aircraft separation distance when advisories were issued
   - a scatter plot of relative horizontal separation vs. relative vertical separation when advisories were issued
   - a scatter plot of vehicle bearing the clockwise bearing from your craft to the intruder at the encounter start vs. the clockwise heading of the intruder relative to the positive north axis (See Lecture 4) for when advisories were issued
- Choose a meaninful tuneable parameter in your collision avoidance system, or change your system to include a meaningful tuneable parameter. (For example, a parameter in the Alpha-Beta filter). Use $5$-fold cross validation over the training dataset and plot the cross-validated-normalized-penalty with respect to the tuneable parameter.

Turn in your code and writeup (preferably a single Julia Notebook) to Canvas.
"""

# ╔═╡ 72b35c3a-00da-4fb6-9ae8-b31efca9b587
md"---"

# ╔═╡ b33467f8-d13b-4a6f-a275-e7d97fd0a9a6
PlutoUI.TableOfContents(title="Analysis")

# ╔═╡ Cell order:
# ╟─9380a110-38ec-11eb-19dc-bf52f53962ed
# ╟─b3587c10-38ec-11eb-3668-c19b178940bf
# ╟─c6aa02c2-38ec-11eb-2ab6-c9e0bb78c682
# ╟─d1beecc2-38ec-11eb-3f97-3173a8f71e9e
# ╠═f7ad7730-38ec-11eb-264e-7df6986ea713
# ╠═8465ff13-d4ea-416e-8ef2-8b64dfef0e02
# ╟─0d594190-38ed-11eb-1ff7-e35b4413f64d
# ╠═a47d1795-c181-453c-9104-6cbe1cacc908
# ╟─29628860-38ed-11eb-2522-35309354f407
# ╠═c28fa1bd-7bef-4ae9-b3c4-c8f24d2df5b8
# ╟─7c331820-38ed-11eb-290d-813158d5f7ef
# ╟─8202d380-38ed-11eb-25c5-c9a544d969d9
# ╟─8caface0-38ed-11eb-1bf7-c9519bd208b3
# ╠═90a1f5b0-38ed-11eb-024a-0119c06d5b87
# ╟─9c506090-38ed-11eb-0216-2f7e2609ef54
# ╟─a2d191a0-38ed-11eb-2129-63f199018437
# ╟─cf9587a0-38ed-11eb-00bf-f10725c0dd6b
# ╟─d435eac0-38ed-11eb-3ada-73fb39e6d923
# ╠═e15d3a00-38ed-11eb-0b0a-6198a2729f68
# ╠═b79d8740-3985-11eb-0f95-1b8a9d1ef77a
# ╠═d14c47c7-2527-4bf5-a5a7-bf3aef954548
# ╟─31e4c80e-3986-11eb-3e3c-efe073a150c7
# ╠═3ecaefa0-3986-11eb-0acb-4b120b339d16
# ╠═41730530-3986-11eb-23cd-cdc38b42393a
# ╠═44e03f80-3986-11eb-0faf-a115cf8b245a
# ╠═ee2bb4cc-e22f-427d-89f2-93eb023d5704
# ╟─61b7f9e2-3986-11eb-328f-3b5d75c1fceb
# ╠═68bb2c30-3986-11eb-37a7-1de9363d2461
# ╠═eae35be5-5ac0-4d64-a8a1-9d02c6736bcc
# ╟─77f9cd40-3987-11eb-21fd-af5508ccffae
# ╠═7995a2f0-3987-11eb-048e-39e11ee85467
# ╠═8655f300-3987-11eb-1076-6b24adc1425a
# ╟─8e4978c0-3987-11eb-07b5-0543a6de1296
# ╠═94fdeed0-3987-11eb-1ecd-f18c99878e8c
# ╠═9de1ef10-3987-11eb-3af9-ab5d6200cf0f
# ╠═b6640af0-3987-11eb-2419-f566f5578055
# ╠═ba643670-3987-11eb-0b60-0b3e746d61e5
# ╠═cf3928d0-3987-11eb-11f3-071958340954
# ╠═6426ec20-3988-11eb-285b-6bd07a0578cb
# ╟─bd2583e0-3988-11eb-31bd-cd9e862729c1
# ╠═d69b2780-3988-11eb-00e5-ebfcf99ae487
# ╠═e49c34f0-3988-11eb-28c9-3d1eb163709f
# ╟─1b1c89d0-3989-11eb-284c-1996a3fe88a2
# ╠═356a8c10-3989-11eb-219a-09a2063acde1
# ╟─4862cf30-3989-11eb-1411-dbb29de448e8
# ╠═5eea0570-3989-11eb-0b22-d92ddec7684c
# ╠═597673d0-3989-11eb-23cc-9f0f87e9522c
# ╠═8c943cc2-3989-11eb-10ff-23707e49ebee
# ╟─df514480-3989-11eb-2a36-9f9573bc6f80
# ╠═e314dc30-3989-11eb-3914-737f9f1e13bc
# ╟─e91b10e0-3989-11eb-05de-8f723cc1cf38
# ╠═ea40cc30-3989-11eb-2f2c-2d596afb3793
# ╠═eff66fe0-3989-11eb-2ae7-97df3ea96db8
# ╠═0c6c5b32-398a-11eb-1f2c-2b48efe703ad
# ╠═1ac573ae-398a-11eb-1979-995ca2fbb1a8
# ╟─22b57700-398a-11eb-1a3c-89570be35d12
# ╠═1fdf3010-398b-11eb-2038-991c3fb67e2e
# ╟─ebe6c1c2-398e-11eb-1b11-0fef009d4cfc
# ╠═618f1850-398a-11eb-3567-5fa878048466
# ╠═85fd1d40-398a-11eb-3dcf-d1f72c220fe9
# ╠═88d14be0-398a-11eb-08ff-35693b9bcadf
# ╠═6426b320-398a-11eb-03b3-6542fd5a167a
# ╟─b11c15d0-398a-11eb-2099-b105de6da150
# ╟─72b35c3a-00da-4fb6-9ae8-b31efca9b587
# ╠═b33467f8-d13b-4a6f-a275-e7d97fd0a9a6
