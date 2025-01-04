### A Pluto.jl notebook ###
# v0.20.4

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

# ╔═╡ c8ff2c72-38fb-4571-bd57-0e3202c8b9e7
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ c46c649b-c77d-48a8-888e-52bff647e1d9
# ╠═╡ show_logs = false
begin
	using Plots
	using Distributions
	using Discretizers
	using Printf
	using Random
	
	plotlyjs();
end

# ╔═╡ 9380a110-38ec-11eb-19dc-bf52f53962ed
md"""
# Analysis of Autonomous Systems
AA120Q: *Building Trust in Autonomy*

v2025.0.1

An important component for building trust and ensuring safe, effective deployment of autonomous systems is rigorous analysis. When developing systems like collision avoidance algorithms, self-driving cars, or medical diagnosis tools, we need systematic methods to validate performance, understand behavior, compare different approaches, identify weaknesses, and verify robustness under varying conditions.

In this notebook, we'll explore techniques for analyzing autonomous systems. We'll examine both quantitative and qualitative analysis methods, discuss how to handle multiple competing objectives, explore statistical tools for comparing distributions, and learn about cross-validation techniques for model evaluation. Through these tools, we'll develop frameworks to evaluate whether systems are working correctly, determine appropriate performance metrics, balance competing objectives like safety and efficiency, and ensure our analysis generalizes to real-world conditions.

## Why Analysis Matters

Consider an autonomous collision avoidance system for aircraft. A thorough analysis must examine the frequency and severity of potential conflicts while evaluating the system's ability to maintain safe separation. We need to carefully consider the trade-off between safety and unnecessary alerts, compare the system's performance to other systems, and verify reliable operation across different conditions.

Without rigorous analysis, we risk missing critical failure modes or developing false confidence in system performance. Good analysis helps build trust by providing clear evidence of both system capabilities and limitations. Through careful examination of system behavior and performance, we can develop justified confidence in autonomous systems.
"""

# ╔═╡ 532aee86-520f-424f-a8e9-5233b6e61591
md"#### Packages Used in this Notebook"

# ╔═╡ b3587c10-38ec-11eb-3668-c19b178940bf
md"""
#  Measuring System Effectiveness

When evaluating autonomous systems, it's the designer's responsibility to assess real-world impact through both qualitative and quantitative measures. In our previous notebook on building and evaluating autonomous systems, we evaluated policies using cumulative reward as our metric - summing up the rewards obtained by different mountain car climbing strategies. While reward functions are useful for training and basic evaluation, they often do not tell the complete story.

## Beyond Reward Functions

Consider an autonomous system trained to maximize its reward function. High reward seems desirable, but this single metric can mask important considerations:

1. The real world rarely matches our simulation environment perfectly 
2. Our reward function may not capture everything we care about
3. Edge cases and rare failures may be overlooked despite good average performance

For example, in our mountain car scenario, consider a policy that results in stabilizing on the left side of the hill. The cumulative reward for this policy will be quite high. However, ... When deploying such systems in the real world, we need to consider factors beyond just the reward function.

For example, in our mountain car scenario, consider a policy that results in the car stabilizing on the left side of the hill. Since our reward was based on the car's height, this policy would achieve a relatively high cumulative reward. However, this completely fails to achieve our actual objective of reaching the top of the hill (the right side). This illustrates a common challenge in autonomous systems - a policy may optimize for the given reward function while missing the true intent of the task. When deploying such systems in the real world, we need to consider factors beyond just the reward function.

## Qualitative Analysis

Qualitative analysis deals with the overall behavior and characteristics of the system that may be hard to quantify. This includes:

- Examining individual failure cases to understand their root causes
- Assessing whether the policy's behavior appears reasonable and predictable 
- Gathering feedback from domain experts and users
- Identifying potential safety concerns or edge cases

## Quantitative Analysis

Quantitative analysis provides concrete metrics and measurements. This includes:

- Statistical performance measures (success rate, completion time, etc.)
- Safety metrics (collision rates, minimum distances maintained, etc.)
- Resource usage (energy consumption, computational cost, etc.)
- Comparison to baseline systems or human performance

The challenge lies in balancing and interpreting multiple metrics that may be in tension with each other, as we'll see in the next section on trade-offs and Pareto frontiers.

"""

# # Measuring System Effectiveness

# It is the designer's responsibility to go back to the field and assess the impact that the autonomous system is having. This measurement process must be both qualitative and quantitative.

# __Qualitative__: Deals with the _quality_ of a result. Does the policy followed by the agent look good? Is it behaving reasonably?

# __Quantitative__: Objective values that can be quantified. For example, with ACAS X, one should look at operational data on airborne collisions, near-misses, and separation after ACAS X has been put into place.

# ╔═╡ d1beecc2-38ec-11eb-3f97-3173a8f71e9e
md"""
## The Pareto Frontier

When optimizing real-world autonomous systems, we often need to balance multiple competing objectives. For instance, in an airborne collision avoidance system, consider these two candidate policies:

- Policy A: 1 collision and 1000 alerts per million flight hours
- Policy B: 2 collisions and 10 alerts per million flight hours

Which policy is better? This isn't a straightforward question. Reducing collisions is critical for safety, but too many alerts could lead to alert desensitization and other operational considerations. We need tools to understand and reason about these trade-offs.

### Understanding Trade-offs

When we have multiple objectives that we want to minimize (like collisions and alerts), we can plot them against each other. Consider a set of different policies and each point represents a possible policy:
"""

# ╔═╡ a47d1795-c181-453c-9104-6cbe1cacc908
scatter([0.5,0.75,1,1.5,2,3,1.8,0.8,2.5,1.2,0.7,1.4],
		[1e5,3e4,1e4,1e3,10,2,2e4,5e4,1e4,1.2e4,9e4,5e4],
		color=:black, label=nothing,
		xlabel="NMACs per million flight hours",
		ylabel="Alerts per million flight hours")

# ╔═╡ 3e710a78-f459-45a8-89fb-3a54b08906af
md"""
### The Pareto Optimal Frontier 

Some policies are strictly better than others. If policy X has both fewer collisions AND fewer alerts than policy Y, then X dominates Y. The Pareto frontier represents policies that cannot be improved in one objective without sacrificing performance in another:
"""

# ╔═╡ c28fa1bd-7bef-4ae9-b3c4-c8f24d2df5b8
begin
	plot([0.5,0.75,1,1.5,2,3],
		 [1e5,3e4,1e4,1e3,10,2],
		 color=:red, markerstrokecolor=:red, marker=:dot, label=nothing)
	scatter!([1.8,0.8,2.5,1.2,0.7,1.4],
			 [2e4,5e4,1e4,1.2e4,9e4,5e4],
			 color=:gray, markerstrokecolor=:gray, label=nothing,
			 xlabel="NMACs per million flight hours",
			 ylabel="Alerts per million flight hours")
	annotate!([(1.3, 7e4, text("Approx. Pareto Frontier", 14, :red)),
			   (1.8, 3e4, text("Suboptimal", 14, :gray)),
			   (0.7, 5e3, text("Infeasible", 14, :black))])
end

# ╔═╡ d372f473-9af0-43e4-b2e8-6d77d930a9dc
md"""
This visualization shows us three key regions:
1. The Pareto frontier (red line): These are the "optimal" policies where improving one metric requires sacrificing the other
2. The suboptimal region (gray points): These policies could be improved in both metrics
3. The infeasible region: The area below the frontier represents performance that isn't achievable given current constraints

### Making Design Decisions

Given a Pareto frontier, how do we choose the best operating point? This decision requires balancing multiple factors including regulatory requirements, safety standards, operational context, system reliability, and input from various stakeholders. No single point on the frontier is universally "best". The choice depends heavily on the specific application context.

For our collision avoidance example, the choice of operating point would depend on the airspace environment. We must also consider the capabilities of the aircraft and pilots who will use the system, the presence of complementary safety systems, and the real operational impact of false alerts. Ultimately, this decision typically involves careful consultation with domain experts who understand both the technical trade-offs and practical operational constraints.
"""

# ╔═╡ d435eac0-38ed-11eb-3ada-73fb39e6d923
md"""

# Cross Validation

You are trying to optimize an airborne collision avoidance system in this class. You have been given a dataset of encounters. How do you go about tuning your model parameters for maximum performance?

When optimizing autonomous systems, we need robust methods to evaluate performance. Simply maximizing performance on a given test dataset can be misleading - we want our system to perform well on new, unseen scenarios.

Let's explore this concept through a simple example. Consider trying to model an underlying probability distribution using histogram bins. While we don't know the true distribution, we do have some sample data from it.

Our true distribution is a mixture of three normal distributions:
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

# ╔═╡ 9c79118a-fe34-4eb0-a7d1-aed9a3f2c174
md"""
In practice, we only have access to a limited sample of data points drawn from this distribution:
"""

# ╔═╡ 04a9bdcb-92a6-4379-b6a2-dafacbe3041d
begin
	Random.seed!(0)
	samples = rand(true_dist, 100)
end

# ╔═╡ ee2bb4cc-e22f-427d-89f2-93eb023d5704
histogram(samples, bins=20, normalize=true, xlabel="x", ylabel="pdf(x)")

# ╔═╡ 61b7f9e2-3986-11eb-328f-3b5d75c1fceb
md"""
Suppose we want to use a piecewise uniform distribution with even bin widths. Above I used 20 bins to create one. How do we select the _best_ number of bins? This is analogous to many tuning decisions in autonomous systems. We want to choose parameters that will generalize well to new data, not just fit our current samples perfectly.
"""

# ╔═╡ c358e584-6dfe-4cd2-9646-8e88481d05a2
md"""
## Train-Test Split

One approach is to split our available data into two sets:
- A training set used to fit the model
- A test set used to evaluate performance

We can then use some metric, perhaps the likelihood of the test data under the learned model (learned  using the training set), to select the preferred number of bins. This lets us estimate how well our model will perform on new, unseen data.
"""

# ╔═╡ cd099c89-22cf-4ac5-b85b-3bc96fcdf7a5
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

# ╔═╡ ed8d5137-13af-4bce-af2d-9f707c0af6c2
md"Let's split the samples into a training set and test set."

# ╔═╡ 7995a2f0-3987-11eb-048e-39e11ee85467
samples_train = samples[1:90];

# ╔═╡ 8655f300-3987-11eb-1076-6b24adc1425a
samples_test = samples[91:end];

# ╔═╡ 4ed51dfb-f6c0-44f1-a3f5-56c75100b312
md"Now let's look at the likelihood of different number of bins"

# ╔═╡ 23b2e794-f92d-4b69-a29d-0660ca95cb79
md"Let's compute the likelihood of the test data for all bin numbers 1 to 100"

# ╔═╡ 6426ec20-3988-11eb-285b-6bd07a0578cb
begin
	x_bins = collect(1:100)
	y_likelihoods = map(i->get_likelihood(samples_train, i, samples_test), x_bins)

	plot(x_bins, y_likelihoods, marker=:circle, markersize=2,
		 xlabel="number of bins",
		 ylabel="test likelihood")
end

# ╔═╡ bd2583e0-3988-11eb-31bd-cd9e862729c1
md"""
The likelihood values we're seeing are extremely small, which can cause numerical issues. We can address two practical challenges here:

- Working with these tiny likelihoods directly is unwieldy. A standard solution is to work with log-likelihoods instead. Since logarithm is a monotonic function, maximizing the log-likelihood yields the same optimal parameters while giving us more manageable numbers to work with.

- We sometimes see zero likelihood scores when a test point falls in a bin that had no training examples. This is clearly too harsh - just because we haven't seen a value in our limited training data doesn't mean it's impossible. We can address this by adding what's called a Laplace smoothing prior: we simply add one count to each bin before calculating probabilities. This ensures every bin has at least some small probability, making our model more robust to unseen data.
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

	plot(x_bins, y_loglikelihoods, marker=:circle, markersize=2,
		 xlabel="number of bins",
		 ylabel="test log likelihood")
end

# ╔═╡ c46eef82-af45-46dc-857d-6cd3c4f8018c
md"""
## K-Fold Cross Validation 

Train-test splitting is useful, but it doesn't make the most efficient use of our limited data. K-fold cross validation provides a more robust evaluation by:
1. Dividing data into K equal parts
2. Training on K-1 parts and testing on the remaining part
3. Repeating this process K times, using each part as the test set once
4. Averaging the results

This approach gives us a more reliable estimate of how our model will perform on new data while making use of all available samples for both training and testing.
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

	plot(1:100, map(get_cv_score, 1:100), marker=:circle, markersize=2,
		 xlabel="number of bins", ylabel="cross-validated log likelihood")
end

# ╔═╡ 4862cf30-3989-11eb-1411-dbb29de448e8
md"""
## Measuring Distribution Similarity

When analyzing autonomous systems, we often need to compare distributions - perhaps comparing our system's behavior to real-world data, or validating that our simulator produces realistic scenarios. For example, in our collision avoidance system, we might want to compare:

- The distribution of aircraft encounter geometries in our test cases vs actual airspace
- How closely our simulated pilot response matches human pilot responses
- The distribution of alert ranges in simulation vs real flights

Let's examine this concept with some examples. Consider these two normal distributions:
"""

# ╔═╡ 597673d0-3989-11eb-23cc-9f0f87e9522c
function plot_distr(dist1, dist2, x_vals; title="")
	style = "mark=none, ultra thick"
	plot(x_vals, map(x->pdf(dist1, x), x_vals), linewidth=2)
	plot!(x_vals, map(x->pdf(dist2, x), x_vals), linewidth=2,
		  xlabel="x",
		  ylabel="pdf(x)",
		  title=title)
end;

# ╔═╡ 8c943cc2-3989-11eb-10ff-23707e49ebee
plot_distr(Normal(0.0, 1.0), Normal(0.1, 1.0), range(-3.0, stop=3.0, length=101))

# ╔═╡ df514480-3989-11eb-2a36-9f9573bc6f80
md"""
Visually, these distributions look quite similar. Now consider these distributions:
"""

# ╔═╡ e314dc30-3989-11eb-3914-737f9f1e13bc
plot_distr(Normal(0.0, 1.0), Normal(2.0, 1.0), range(-3.0, stop=5.0, length=101))

# ╔═╡ e91b10e0-3989-11eb-05de-8f723cc1cf38
md"""
These are clearly more different. But what about the following distributions?
"""

# ╔═╡ ea40cc30-3989-11eb-2f2c-2d596afb3793
plot_distr(Normal(0.0, 1.0), Normal(0.0, 2.0), range(-5.0, stop=5.0, length=101))

# ╔═╡ eff66fe0-3989-11eb-2ae7-97df3ea96db8
plot_distr(Normal(0.0, 1.0), MixtureModel([Normal(-1.5, 1.0), Normal(1.5, 1.0)]),
	       range(-5.0, stop=5.0, length=101))

# ╔═╡ 0c6c5b32-398a-11eb-1f2c-2b48efe703ad
sim = MixtureModel([Cauchy(-5, 1.8), Cauchy(-4, 0.8), Cauchy(-1, 0.3), Cauchy(2, 0.8), Cauchy(4, 1.5)], [0.1, 0.4, 0.15, 0.2, 0.15])

# ╔═╡ 1ac573ae-398a-11eb-1979-995ca2fbb1a8
plot_distr(Normal(0.0, 1.0), sim, range(-10.0, stop=10.0, length=101))

# ╔═╡ 22b57700-398a-11eb-1a3c-89570be35d12
md"""
How can we quantify this difference? Visual comparison only gets us so far - we need mathematical tools to measure distribution similarity.

### The Kullback-Leibler Divergence

The Kullback-Leibler (KL) divergence provides a mathematical measure of the difference between two probability distributions. For two distributions p and q, it is defined as:

$D_{KL}(p \mid\mid q) = \int_{-\infty}^{\infty} p(x) \log \frac{p(x)}{q(x)} \, dx$

The KL divergence has several important properties:
- It equals zero if and only if the distributions are identical
- Larger values indicate more different distributions
- It is asymmetric: $D_{KL}(p \mid\mid q) \neq D_{KL}(q \mid\mid p)$

For Gaussian distributions $p=\mathcal{N}(\mu_1, \sigma_1)$ and $q = \mathcal{N}(\mu_2, \sigma_2)$, this has a closed form:

$$D_{KL}(p \mid\mid q) = \log\left(\frac{\sigma_2}{\sigma_1}\right) + \frac{\sigma_1^2 + (\mu_1 - \mu_2)^2}{2\sigma_2^2} - \frac{1}{2}$$
"""

# ╔═╡ 1fdf3010-398b-11eb-2038-991c3fb67e2e
function kldivergence(p::Normal, q::Normal) # KL divergence for two Gaussians
	μ₁, σ₁ = p.μ, p.σ
	μ₂, σ₂ = q.μ, q.σ
	return log(σ₂/σ₁) + (σ₁^2 + (μ₁ - μ₂)^2)/(2σ₂^2) - 0.5
end

# ╔═╡ 38fb10d6-0af2-49d5-b5b5-e82d5ef2e486
md"""
### Other Distribution Metrics

While we focused on KL divergence, it's just one of many ways to measure the similarity between probability distributions. Many of these measures belong to a broader family called f-divergences, which have different mathematical properties that may be more suitable for specific applications.

Some other common distribution metrics include:
- **Jensen-Shannon divergence**: A symmetric version of KL divergence
- **Hellinger distance**: Always bounded between 0 and 1, making comparisons easier
- **Bhattacharyya distance**: Related to the amount of overlap between distributions
- **Total variation distance**: Maximum difference in probabilities over all events

Each metric has its own strengths and applications. While properties like symmetry, boundedness, and computational tractability are important considerations, the choice of metric often depends primarily on the specific problem domain and what differences between distributions are most meaningful for your application.

For more details on these metrics and their mathematical properties, see the [f-divergence article on Wikipedia](https://en.wikipedia.org/wiki/F-divergence).
"""

# ╔═╡ 631c69d5-e89c-4c2a-bfac-d84c167b166f
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ b33467f8-d13b-4a6f-a275-e7d97fd0a9a6
PlutoUI.TableOfContents()

# ╔═╡ 74ceaaa7-63d3-4bac-8e93-e1dfdf6cb389
begin
	start_code() = html"""
	<div class='container'><div class='line'></div><span class='text' style='color:#B1040E'><b><code>&lt;START CODE&gt;</code></b></span><div class='line'></div></div>
	<p> </p>
	<!-- START_CODE -->
	"""

	end_code() = html"""
	<!-- END CODE -->
	<p><div class='container'><div class='line'></div><span class='text' style='color:#B1040E'><b><code>&lt;END CODE&gt;</code></b></span><div class='line'></div></div></p>
	"""

	function combine_html_md(contents::Vector; return_html=true)
		process(str) = str isa HTML ? str.content : html(str)
		return join(map(process, contents))
	end

	function html_expand(title, content::Markdown.MD)
		return HTML("<details><summary>$title</summary>$(html(content))</details>")
	end

	function html_expand(title, contents::Vector)
		html_code = combine_html_md(contents; return_html=false)
		return HTML("<details><summary>$title</summary>$html_code</details>")
	end

	html_space() = html"<br><br><br><br><br><br><br><br><br><br><br><br><br><br>"
	html_half_space() = html"<br><br><br><br><br><br><br>"
	html_quarter_space() = html"<br><br><br>"

	Bonds = PlutoUI.BuiltinsNotebook.AbstractPlutoDingetjes.Bonds

	struct DarkModeIndicator
		default::Bool
	end
	
	DarkModeIndicator(; default::Bool=false) = DarkModeIndicator(default)

	function Base.show(io::IO, ::MIME"text/html", link::DarkModeIndicator)
		print(io, """
			<span>
			<script>
				const span = currentScript.parentElement
				span.value = window.matchMedia('(prefers-color-scheme: dark)').matches
			</script>
			</span>
		""")
	end

	Base.get(checkbox::DarkModeIndicator) = checkbox.default
	Bonds.initial_value(b::DarkModeIndicator) = b.default
	Bonds.possible_values(b::DarkModeIndicator) = [false, true]
	Bonds.validate_value(b::DarkModeIndicator, val) = val isa Bool
end

# ╔═╡ 68bb2c30-3986-11eb-37a7-1de9363d2461
md"""
Number of bins: $(@bind nbins Select(map(b -> string(b), [2,4,6,10,20,50,100])))
"""

# ╔═╡ eae35be5-5ac0-4d64-a8a1-9d02c6736bcc
begin
	histogram(samples, bins=parse(Int, nbins), normalize=true)
	plot!(x_vals, y_vals, color=:black, linewidth=2, legend=false)
end

# ╔═╡ ba643670-3987-11eb-0b60-0b3e746d61e5
md"""
Number of train bins: $(@bind nbinsₜᵣₐᵢₙ Select(map(b -> string(b), [2,4,6,10,20,50,100])))
"""

# ╔═╡ cf3928d0-3987-11eb-11f3-071958340954
begin
	nbins_int = parse(Int, nbinsₜᵣₐᵢₙ)
	likelihood = get_likelihood(samples_train, nbins_int, samples_test)

	histogram(samples_train, bins=nbins_int, normalize=true,
		      title=@sprintf("Likelihood: %10.8f", likelihood))
	plot!(x_vals, y_vals, color=:black, linewidth=2)
end

# ╔═╡ 85fd1d40-398a-11eb-3dcf-d1f72c220fe9
md"""
Let's explore how the KL divergence changes as we adjust the parameters of two Gaussian distributions. You can modify the mean (μ) and standard deviation (σ) of each distribution to build intuition about:
- How shifts in mean affect the divergence
- How changes in variance impact the measure
- Why the divergence is asymmetric

Try adjusting these parameters:

μ₁ $(@bind μ₁ Slider(-3:0.5:3; show_value=true, default=0.0))
σ₁ $(@bind σ₁ Slider(0.1:0.1:4; show_value=true, default=1.0))

μ₂ $(@bind μ₂ Slider(-3:0.5:3; show_value=true, default=0))
σ₂ $(@bind σ₂ Slider(0.1:0.1:4; show_value=true, default=0.8))
"""

# ╔═╡ 6426b320-398a-11eb-03b3-6542fd5a167a
begin
	p = Normal(μ₁, σ₁)
	q = Normal(μ₂, σ₂)
	kl_div = @sprintf("KL divergence = %.3f", kldivergence(p, q))
	ax = plot_distr(p, q, range(-10.0, stop=10.0, length=101); title=kl_div)
	ylims = (0, 0.5)
    ax
end

# ╔═╡ 72b35c3a-00da-4fb6-9ae8-b31efca9b587
html_half_space()

# ╔═╡ ddd15d68-6448-4771-a9a5-93c773209e36
html"""
	<style>
		h3 {
			border-bottom: 1px dotted var(--rule-color);
		}

		summary {
			font-weight: 500;
			font-style: italic;
		}

		.container {
	      display: flex;
	      align-items: center;
	      width: 100%;
	      margin: 1px 0;
	    }

	    .line {
	      flex: 1;
	      height: 2px;
	      background-color: #B83A4B;
	    }

	    .text {
	      margin: 0 5px;
	      white-space: nowrap; /* Prevents text from wrapping */
	    }

		h2hide {
			border-bottom: 2px dotted var(--rule-color);
			font-size: 1.8rem;
			font-weight: 700;
			margin-bottom: 0.5rem;
			margin-block-start: calc(2rem - var(--pluto-cell-spacing));
		    font-feature-settings: "lnum", "pnum";
		    color: var(--pluto-output-h-color);
		    font-family: Vollkorn, Palatino, Georgia, serif;
		    line-height: 1.25em;
		    margin-block-end: 0;
		    display: block;
		    margin-inline-start: 0px;
		    margin-inline-end: 0px;
		    unicode-bidi: isolate;
		}

		h3hide {
		    border-bottom: 1px dotted var(--rule-color);
			font-size: 1.6rem;
			font-weight: 600;
			color: var(--pluto-output-h-color);
		    font-feature-settings: "lnum", "pnum";
			font-family: Vollkorn, Palatino, Georgia, serif;
		    line-height: 1.25em;
			margin-block-start: 0;
		    margin-block-end: 0;
		    display: block;
		    margin-inline-start: 0px;
		    margin-inline-end: 0px;
		    unicode-bidi: isolate;
		}

		.styled-button {
			background-color: var(--pluto-output-color);
			color: var(--pluto-output-bg-color);
			border: none;
			padding: 10px 20px;
			border-radius: 5px;
			cursor: pointer;
			font-family: Alegreya Sans, Trebuchet MS, sans-serif;
		}
	</style>

	<script>
	const buttons = document.querySelectorAll('input[type="button"]');
	buttons.forEach(button => button.classList.add('styled-button'));
	</script>"""

# ╔═╡ Cell order:
# ╟─9380a110-38ec-11eb-19dc-bf52f53962ed
# ╟─c8ff2c72-38fb-4571-bd57-0e3202c8b9e7
# ╟─532aee86-520f-424f-a8e9-5233b6e61591
# ╠═c46c649b-c77d-48a8-888e-52bff647e1d9
# ╟─b3587c10-38ec-11eb-3668-c19b178940bf
# ╟─d1beecc2-38ec-11eb-3f97-3173a8f71e9e
# ╟─a47d1795-c181-453c-9104-6cbe1cacc908
# ╟─3e710a78-f459-45a8-89fb-3a54b08906af
# ╟─c28fa1bd-7bef-4ae9-b3c4-c8f24d2df5b8
# ╟─d372f473-9af0-43e4-b2e8-6d77d930a9dc
# ╟─d435eac0-38ed-11eb-3ada-73fb39e6d923
# ╠═b79d8740-3985-11eb-0f95-1b8a9d1ef77a
# ╟─d14c47c7-2527-4bf5-a5a7-bf3aef954548
# ╟─9c79118a-fe34-4eb0-a7d1-aed9a3f2c174
# ╠═04a9bdcb-92a6-4379-b6a2-dafacbe3041d
# ╠═ee2bb4cc-e22f-427d-89f2-93eb023d5704
# ╟─61b7f9e2-3986-11eb-328f-3b5d75c1fceb
# ╟─68bb2c30-3986-11eb-37a7-1de9363d2461
# ╟─eae35be5-5ac0-4d64-a8a1-9d02c6736bcc
# ╟─c358e584-6dfe-4cd2-9646-8e88481d05a2
# ╠═cd099c89-22cf-4ac5-b85b-3bc96fcdf7a5
# ╟─ed8d5137-13af-4bce-af2d-9f707c0af6c2
# ╠═7995a2f0-3987-11eb-048e-39e11ee85467
# ╠═8655f300-3987-11eb-1076-6b24adc1425a
# ╟─4ed51dfb-f6c0-44f1-a3f5-56c75100b312
# ╟─ba643670-3987-11eb-0b60-0b3e746d61e5
# ╟─cf3928d0-3987-11eb-11f3-071958340954
# ╟─23b2e794-f92d-4b69-a29d-0660ca95cb79
# ╠═6426ec20-3988-11eb-285b-6bd07a0578cb
# ╟─bd2583e0-3988-11eb-31bd-cd9e862729c1
# ╠═d69b2780-3988-11eb-00e5-ebfcf99ae487
# ╠═e49c34f0-3988-11eb-28c9-3d1eb163709f
# ╟─c46eef82-af45-46dc-857d-6cd3c4f8018c
# ╠═356a8c10-3989-11eb-219a-09a2063acde1
# ╟─4862cf30-3989-11eb-1411-dbb29de448e8
# ╟─597673d0-3989-11eb-23cc-9f0f87e9522c
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
# ╟─85fd1d40-398a-11eb-3dcf-d1f72c220fe9
# ╠═6426b320-398a-11eb-03b3-6542fd5a167a
# ╟─38fb10d6-0af2-49d5-b5b5-e82d5ef2e486
# ╟─72b35c3a-00da-4fb6-9ae8-b31efca9b587
# ╟─631c69d5-e89c-4c2a-bfac-d84c167b166f
# ╟─b33467f8-d13b-4a6f-a275-e7d97fd0a9a6
# ╟─74ceaaa7-63d3-4bac-8e93-e1dfdf6cb389
# ╟─ddd15d68-6448-4771-a9a5-93c773209e36
