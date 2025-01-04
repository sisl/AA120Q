### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ dbfbadd3-a283-4484-8bb1-ab8aff6433b7
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
end

# ╔═╡ 15ff38d2-3f0b-11eb-3b70-110e0233924e
begin
	using StatsBase
	using Plots
	plotlyjs();
end

# ╔═╡ d3f66622-b417-46c3-bbb2-bd9cf09ff0ed
begin
	using Base64
	include_string(@__MODULE__, String(base64decode("IyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgojIERFQ09ESU5HIFRISVMgSVMgQSBWSU9MQVRJT04gT0YgVEhFIEhPTk9SIENPREUKIyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgoKZnVuY3Rpb24gX190aHJvd19uZWVkbGUoKQogICAgeCA9IDAKCc64ID0gMAoJCgkjIFNUVURFTlQgQ09ERSBTVEFSVAoJeCA9IHJhbmQoKSAqIDUgIyByYW5kb20gbnVtYmVyIGJldHdlZW4gMCBhbmQgNQoJzrggPSByYW5kKCkgKiDPgCAjIHJhbmRvbSBudW1iZXIgYmV0d2VlbiAwIGFuZCDPgAogICAgIyBTVFVERU5UIENPREUgRU5ECgogICAgcmV0dXJuICh4LM64KSAjIHJldHVybnMgdmFsdWVzCmVuZAoKZnVuY3Rpb24gX19uZWVkbGVfb3ZlcmxhcHMoeDo6RmxvYXQ2NCwgzrg6OkZsb2F0NjQpCglvdmVybGFwcyA9IHRydWUKCQoJIyBTVFVERU5UIENPREUgU1RBUlQKCXRpcF8xID0geCArIDAuNSAqIGNvcyjOuCkgIyB4IHBvc2l0aW9uIG9mIG9uZSB0aXAgb2YgdGhlIG5lZWRsZQoJdGlwXzIgPSB4IC0gMC41ICogY29zKM64KSAjIHggcG9zaXRpb24gb2YgdGhlIG90aGVyIHRpcAoJCgkjIFdlIGNhbiBkZXRlcm1pbmUgdGhlIHNlY3Rpb24gdGhlIHRpcHMgbGllIGluIGJ5IGZsb29yaW5nIHRoZWlyIHggbG9jYXRpb25zCglzZWN0aW9uXzEgPSBmbG9vcih0aXBfMSkKCXNlY3Rpb25fMiA9IGZsb29yKHRpcF8yKQoJCgkjIFRoZSBuZWVkbGUgb3ZlcmxhcHMgYSBib3JkZXIgaWYgdGhlIHRpcHMgYXJlIGluIGRpZmZlcmVudCBzZWN0aW9ucwoJb3ZlcmxhcHMgPSBzZWN0aW9uXzEgIT0gc2VjdGlvbl8yCiAgICAjIFNUVURFTlQgQ09ERSBFTkQKCQoJcmV0dXJuIG92ZXJsYXBzCmVuZAo=")))

	__throw_needle = __throw_needle
	__needle_overlaps = __needle_overlaps
	
	md""
end

# ╔═╡ 2ed7b212-3f0b-11eb-21f0-3d47dc28865b
md"""
# Assignment 1: Estimating $\pi$
v2025.0.1
"""

# ╔═╡ 1cf22288-de2e-408a-ac8b-7b2470da7271
md"## Notebook Setup"

# ╔═╡ a150639b-6e23-4815-8d38-54b5b55e5f83
md"## Problem Description"

# ╔═╡ 1f625420-3f0b-11eb-1a97-73752639a1cd
PlutoUI.LocalResource("figures/buffon.png")

# ╔═╡ b583aae0-3f0a-11eb-1560-03c21f877727
md"""
Buffon's Needle Problem was first proposed by Georges Buffon in 1737. By randomly throwing needles onto a hard floor marked with equally spaced lines, Buffon was able to derive a mathematial expression which could be used to calculate the value of $\pi$. Specifically, the probability that a needle of length equal to the width of parallel boards overlaps with a board edge is $\frac{2}{\pi}$. 

One can estimate pi by dropping a large number of pins and using the ratio of overlaps to non-overlaps to estimate pi.
The accuracy of this experimental value of pi increases with an increasing number of random throws.  See [Wikipedia](https://en.wikipedia.org/wiki/Buffon%27s_needle) for a detailed problem description and background.

In this assignment, you will develop an algorithm that estimates $\pi$ based on the above description, and write a program to implement this  algorithm.

1. Your algorithm will be implemented in Julia.
2. Your main function will have the following signature: `buffon(n::Int)`.
3. Your main function will return $\hat{\pi}$, your estimate for pi.
4. You will plot how your algorithm converges as the sample count is increased using [Plots.jl](https://github.com/tbreloff/Plots.jl)
5. Although you may discuss your algorithm with others, you must not share code.
"""

# ╔═╡ b97e1c52-511b-11eb-0dfe-410b622089cc
md"""
## ‼️ What is Turned In
1. Export this notebook as a PDF ([how-to in the documentation](https://plutojl.org/en/docs/export-pdf/))
2. Upload the PDF to [Gradescope](https://www.gradescope.com/)
3. Tag your pages correctly on Gradescope:
   - Tag the pages containing your Milestone One Part 1, 2, and 3 checks (with the ✅ or ❌)
   - Tag the page containing your final convergence plot

**Do not use any external code or Julia packages other than those used in the class materials.**
"""

# ╔═╡ 5b66dc70-3f0b-11eb-00e3-6910d8ffaf21
md"""
# 1️⃣ Milestone One: Implementing `buffon(n::Int)`

Our goal is to implement a function, `buffon(n::Int)`. The function `buffon(n::Int)` takes in an integer parameter `n` as the number of trials run, returning an estimate for pi based on the number of trials. We can divide the implementation of the function `buffon(n::Int)` into three parts: 
1. Throwing a needle
2. Checking whether the needle overlaps with a floorboard line
3. Use your result to estimate ${\pi}$
"""

# ╔═╡ 890f8d20-3f0b-11eb-0ab6-b54cd1c0f0e7
md"""
## Part 1: Throwing a Needle

To throw a needle, we can keep track of where it lands and how it lands. To do so, choose random x to specify the location of the center of the needle (the y location does not matter - make sure that makes sense to you before moving on) and an angle $\theta$ to specify in what orientation the needle lies once it lands. Since we are simulating throws, choose random values for x and $\theta$. The `rand()` function selects a random number between 0 and 1.
"""

# ╔═╡ 8cc8f630-3f0c-11eb-2906-9ffe051b6fb8
md"""
### 💻 **Task**: Implement the function `throw_needle()`

Returns the $x$ and $\theta$ value for a randomly thrown needle onto a board that has a total of five sections of width $1$ (you can use the figure at the top of the page as a visual guide). The needle also has length $1$. Let's define the leftmost border of the floor to correspond to $x = 0$ and the rightmost border to correspond to $x = 5$. Based on this definition of our coordinates, it is up to you to specify the correct domain for $x$ and $\theta$.
"""

# ╔═╡ a689a200-3f0b-11eb-2354-357e2b8a25aa
function throw_needle()
    x = 0
	θ = 0
	
	# STUDENT CODE START
	
    # STUDENT CODE END

    return (x,θ) # returns values
end

# ╔═╡ 2fab5623-cba7-4bc1-8526-d17b4944a5c0
begin
	global m1p1_icon = "❌"
	global milestone_one_part_1_pass = false
	m1p1_num_samples = 150000
	m1p1_accuracy = 0.01
	
	try
		
		x_samples = Vector{Float64}(undef, m1p1_num_samples)
		θ_samples = Vector{Float64}(undef, m1p1_num_samples)

		for ii in 1:m1p1_num_samples
			x_i, θ_i = throw_needle()
			x_samples[ii] = x_i
			θ_samples[ii] = θ_i
		end

		x_mean = mean(x_samples)
		x_std = std(x_samples)
		x_skewness = skewness(x_samples)
		x_kurtosis = kurtosis(x_samples)

		θ_mean = mean(θ_samples)
		θ_std = std(θ_samples)
		θ_skewness = skewness(θ_samples)
		θ_kurtosis = kurtosis(θ_samples)

		x_win_bounds = all(x_samples .>= 0.0) && all(x_samples .<= 5.0)
		θ_win_bounds = all(θ_samples .>= 0.0) && all(θ_samples .<= π)

		x_dist_match = isapprox(x_mean, 2.5; atol=m1p1_accuracy) &&
						isapprox(x_std, 5 / sqrt(12); atol=m1p1_accuracy) &&
						isapprox(x_skewness, 0.0; atol=m1p1_accuracy) &&
						isapprox(x_kurtosis, -6/5; atol=m1p1_accuracy)

		θ_dist_match = isapprox(θ_mean, π/2; atol=m1p1_accuracy) &&
						isapprox(θ_std, π / sqrt(12); atol=m1p1_accuracy) &&
						isapprox(θ_skewness, 0.0; atol=m1p1_accuracy) &&
						isapprox(θ_kurtosis, -6/5; atol=m1p1_accuracy)

		if x_win_bounds && θ_win_bounds && x_dist_match && θ_dist_match
			global m1p1_icon = "✅"
			global milestone_one_part_1_pass = true
			Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""Your samples produce correct distributions!"""]))
		elseif !x_win_bounds && !θ_win_bounds
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""The bounds of the values returned are not correct."""]))
		elseif !θ_win_bounds
			if all(θ_samples .> 0) && all(θ_samples .<= 2*π)
				Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""The bounds of the values returned for θ are not correct.
				
				Think about the maximum value for θ we need to consider. Do we need all 2π radians?"""]))
			else
				Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""The bounds of the values returned for θ are not correct."""]))
			end
		elseif !x_win_bounds
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""The bounds of the values returned for x are not correct.
			
			Think about the minimum and maximum values for x we need to consider."""]))
		elseif !x_dist_match && !θ_dist_match
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""The distribution returned over multiple samples for both variables are not correct."""]))
		elseif !x_dist_match
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""The distribution returned over multiple samples for x is not correct."""]))
		elseif !θ_dist_match
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""The distribution returned over multiple samples for θ is not correct."""]))
		else
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""
			
			Something with your code is not quite correct.
			"""]))
		end
	catch err
		Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err
		"""]))
	end
end

# ╔═╡ db139d96-4bc3-4863-b83b-de3325ba7e35
md"""
### $(m1p1_icon) Milestone One - Part 1 Check
"""

# ╔═╡ c1171e40-3f0b-11eb-311b-337430ba84ac
md"""
## Part 2: Determine Overlap

After you have implemented a means of throwing a needle, you will need to decide whether or not it overlaps with a board edge. Think about the coordinate system we defined for our floor. You will want to make use of conditionals such as if statements. (Think about which condition you really need to check within the if statement)
"""

# ╔═╡ fd1e7040-3f0c-11eb-3b27-69a7f8aee903
md"""
### 💻 **Task**: Implement `needle_overlaps(x::Float64, θ::Float64)`

Check if the needle overlaps with a board edge and return `true` if so and `false` if not.
"""

# ╔═╡ 1c42b2b0-3f0d-11eb-1b92-4b252ac6c319
function needle_overlaps(x::Float64, θ::Float64)
	overlaps = true
	
	# STUDENT CODE START
	
    # STUDENT CODE END
	
	return overlaps
end

# ╔═╡ 73484a0c-f416-4074-883e-265d9ac5998b
begin
	global m1p2_icon = "❌"
	global milestone_one_part_2_pass = false
	m1p2_num_samples = 15000
	
	try
		
		m1p2_throws = [__throw_needle() for _ in 1:m1p2_num_samples]
		true_overlaps = falses(m1p2_num_samples)
		user_overlaps = falses(m1p2_num_samples)
		for (ii, (xi, θi)) in enumerate(m1p2_throws)
			true_overlaps[ii] = __needle_overlaps(xi, θi)
			user_overlaps[ii] = needle_overlaps(xi, θi)
		end

		all_match = all(true_overlaps .== user_overlaps)
		true_mask = true_overlaps .== true
		false_mask = true_overlaps .== false

		trues_match = all(true_overlaps[true_mask] .== user_overlaps[true_mask])
		falses_match = all(true_overlaps[false_mask] .== user_overlaps[false_mask])
		
		if all_match
			global m1p2_icon = "✅"
			global milestone_one_part_2_pass = true
			Markdown.MD(Markdown.Admonition("correct", "🎉", [md"""Your algorithm correctly determines needle overlaps!"""]))
		elseif trues_match
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""Your function is not properly identifying when a needle does not overlap a board edge."""]))
		elseif falses_match
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""Your function is not properly identifying when a needle overlaps a board edge."""]))
		else
			num_correct = sum(true_overlaps .== user_overlaps)
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""Of $m1p2_num_samples, needles thrown, your function only correctly determined overlaps on $(round(num_correct/m1p2_num_samples * 100; digits=2))% of them."""]))
		end
		
	catch err
		Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err
		"""]))
	end
end

# ╔═╡ 954d7212-5557-49c9-812b-f5addd2ac9fc
md"""
### $(m1p2_icon) Milestone One - Part 2 Check
"""

# ╔═╡ 2416a280-3f0d-11eb-04c2-b34b546b1d50
md"""
## Part 3: Estimating $\pi$

It is now time to use the two function we wrote the get an estimate for $\pi$. Recall that Buffon's Needles Problem tells us that the ratio of overlaps to nonoverlaps is $\frac{2}{\pi}$. Once that you are able to run the specified number of trials, you have an estimate for $\frac{2}{\pi}$ and with some algebra we can then get an estimate for ${\pi}$.
"""

# ╔═╡ 57ff0e70-3f0d-11eb-0c5a-4759bf1fbc99
md"""
### 💻 **Task**: Implement `buffon_calc(n::Int)`

Estimate $\pi$ using `n` thrown needles.
"""

# ╔═╡ 41787470-3f0d-11eb-0e8c-9bf6be69db81
function buffon_calc(n::Int)
	estimated_pi = 0
	
	# STUDENT CODE START
	
    # STUDENT CODE END

	return estimated_pi # returns your calculated estimate for π
end

# ╔═╡ 6b3b1150-3f0d-11eb-23d5-532804c11870
md"""
### Test Your Code
Your code should produce a value close to $\pi$.
"""

# ╔═╡ 6cc6e170-3f0d-11eb-1632-0b4d6e0cf9d8
buffon_calc(20000)

# ╔═╡ 07ae7f44-b1cd-4f52-9d98-86ce6863adc1
begin
	global m1p3_icon = "❌"
	global milestone_one_part_3_pass = false
	num_throws = 150000
	accuracy = 0.02
	try
		test_est_π = buffon_calc(num_throws)
		if isapprox(test_est_π, π; atol=accuracy)
			global m1p3_icon = "✅"
			global milestone_one_part_3_pass = true
			Markdown.MD(Markdown.Admonition("correct", "🍰", [md"""Using $num_throws needles, your estimate is within $accuracy of π!"""]))
		elseif isapprox(2 / test_est_π, π; atol=accuracy)
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""Remember that probability that a needle overlaps a board edge is 2 / π.
			"""]))
		else
			Markdown.MD(Markdown.Admonition("warning", "Keep working on it!", [md"""Your estimate using $num_throws needles (π̂ = $(test_est_π)) is not quite to the accuracy we need.
			
			The absolute value of the difference is currently $(abs(test_est_π - π)) and we need it to be less than $accuracy.
			"""]))
		end
	catch err
		Markdown.MD(Markdown.Admonition("danger", "Error", [md"""There is an error with your code: $err
		"""]))
	end
end

# ╔═╡ 27494c35-1bd9-4ae2-8590-bb4a9cf9eb9c
md"""
### $(m1p3_icon) Milestone One - Part 3 Check
"""

# ╔═╡ 2f1a021d-d69b-4be7-90c3-df00af75c9cb
begin
	global milestone_one_complete = (milestone_one_part_1_pass && milestone_one_part_2_pass && milestone_one_part_3_pass)
	if milestone_one_complete
		md"""
		##  ✅ Milestone One Complete!
		"""
	else
		md"""
		##  ❌ Milestone One Incomplete!
		"""
	end
end

# ╔═╡ 88f0a890-3f0d-11eb-3b3f-a3a2150323ae
md"""
# 2️⃣ Milestone Two: Create a convergence plot

Now that you have the algorithm for estimating pi with the help of Buffon’s Needles Problem, we will use it to create a convergence plot for our data. The x-axis of the plot will be the number of samples and we will generate 15 different sample sizes using log space from 1 to 10,000 samples, which is given by: 

	nsamples = round.(Int, collect(exp10.(range(1, stop=5, length=15))))
                    
The y-axis will be the estimated value of $\pi$ we get from various sample sizes. 
 
We will then plot the mean estimate for $\pi$ for each of 100 trials of the 15 different sample sizes with 95% confidence intervals. 
"""

# ╔═╡ ab4b84f0-3f0d-11eb-246d-894db1e511dd
md"""

## Part 1: Run Trials, Calculate Mean, and Standard Error 

The `run_trials()` function needs to calculate mean estimates of π and their standard errors for different sample sizes. Here's what the function should do:

1. Use the provided `nsamples` array, which contains 15 different sample sizes from ``10^1`` to ``10^5``
2. For each sample size in `nsamples`:
   - Run 100 trials using `buffon_calc` with that sample size
   - Calculate the mean of those 100 estimates (store in `mean_y`)
   - Calculate the standard error of those 100 estimates (store in `stderr_y`)
"""

# ╔═╡ f48a9660-3f0d-11eb-3244-2bedb4858323
md"""
### 💻 **Task**: Implement `run_trials()`
"""

# ╔═╡ 0d43eca0-4f8b-11eb-0c89-5d63aeb992cd
function run_trials()

    # 15 sample sizes
    nsamples = round.(Int, collect(exp10.(range(1, stop=5, length=15))))
	
	# Populate these arrays with the results from the trials
	mean_y = zeros(15)
	stderr_y = zeros(15)

	# Implement so that you run 100 trials for each of the 15 sample sizes
    # STUDENT CODE START
	
    # STUDENT CODE END

    return mean_y, stderr_y # return the trials for each of the 15 sample sizes 
end

# ╔═╡ 2288356c-4f8b-11eb-0894-f90ef2cd8815
md"""
## Part 2: Convergence Plot

This section will generate your convergence plot. You should not have to change any of the code in this section. Check out the results of your hard work!
"""

# ╔═╡ 31d987aa-4f8b-11eb-18cd-07bff8790426
n_samples = round.(Int, collect(exp10.(range(1,stop=5,length=15))));

# ╔═╡ 368dc05c-4f8b-11eb-2f15-e5bc22b45936
mean_y, stderr_y = run_trials();

# ╔═╡ 72dcdb26-4f8b-11eb-33e4-a3d1903d95fb
begin
	Plots.plot(n_samples, 
		mean_y,
		linewidth=2,                     # Make line thicker
		ribbon=stderr_y*1.96,            # Use ribbon for CI
		fillalpha=0.3,                   # Make CI band slightly transparent
		label="Mean",                    # Label for mean line
		xaxis=("Number of samples", :log),
		ylabel="Estimate of pi",
		title="Buffon's Needle Estimate of π (with 95% CI)",
		ylims=(3.0, 3.4),
		legend=:bottom)                     # Show legend for labels
	
	# Add horizontal line for true π value
	Plots.plot!(n_samples, [π for _ in n_samples]; linewidth=2, linestyle=:dash, label="True π", color=:red)
end

# ╔═╡ 7da83cc6-4f8b-11eb-260e-09a9c541d3f5
md"""
Your plot should look like it is converging to the true value of $\pi$.
"""

# ╔═╡ 62408044-33f4-4343-bc3a-188fe66d4068
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ 46c9f5fd-1391-4ea0-a3e0-4c29669b41f3
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

# ╔═╡ a1fe0dee-fb1f-4356-af95-92fa718b455c
html_quarter_space()

# ╔═╡ a8f6f4e5-a56f-4b8e-b545-494e7ca6c45b
html_expand("Things to think about/remember", md"""
#### Things to think about/remember:

- Which coordinate ultimately decides if the needle overlaps?
- How will you check if a needle overlaps or not?
- The width of each panel is the same as the length of each needle
""")

# ╔═╡ 5baea115-3c4b-4966-a5be-fbc340ecb924
html_expand("Expand for `rand()` usage hint", md"""
To get a random number between $0$ and $10$, you can use `rand() * 10`.
""")

# ╔═╡ 0692bf72-6669-4936-aa09-c380d78b0684
start_code()

# ╔═╡ 9278a00f-f311-41a6-907a-6d980adef27b
end_code()

# ╔═╡ 29f2ce3e-4ef0-4958-89ca-dc0700169325
html_quarter_space()

# ╔═╡ 49fe7c6a-f229-456e-901f-a8e1cebc62cd
html_expand("Expand for examples of different conditional statements", md"""
#### Example Conitionals
```julia
	x = 2
	y = 5

	if x < y
		println("x is less than y")
	end

	# Also useful:
	if x < 3 || x > 5
		println("x is less than three or x is greater than five")
	end

	if x > 1 && x < 4
		println("x is between one and four")
	end
```
""")

# ╔═╡ fd9246ca-4f88-11eb-0619-9b337632c1cd
html_expand("Expand for hint", md"""
According to our definition, the value we sample for $x$ corresponds to the center of the needle. It may be useful to determine the location of the tips of the needle based on the sampled value of $θ$. Is there a simple trigonometric relationship to provide us with this?
""")

# ╔═╡ 06c09405-2e90-4534-80a9-d1af8321a9f4
start_code()

# ╔═╡ f0182f4e-838a-4dc9-8628-cd9259007dfe
end_code()

# ╔═╡ 093bf4c4-5c32-4d17-a2ef-1ff21f26759e
html_quarter_space()

# ╔═╡ 99963b79-9da4-4c2c-9d7c-b41f068ca470
start_code()

# ╔═╡ d018a395-0ea5-40c1-968a-717bd1c6736c
end_code()

# ╔═╡ e283eaae-5712-419a-8433-c5741a53b541
html_half_space()

# ╔═╡ 96c9f5cf-43db-4cfa-b3e4-f915e7d85f51
html_expand("Expand for function hints", md"""
From the `StatsBase` library, Julia has functions to help you calculate the mean and standard deviation of values in an array.

- `mean(x)` calculates the average of the values in array x.  
- `std(x)` calculates the standard deviation of the values in array x.

Example:
```julia
x = [1, 2, 3, 4, 5]
mean(x)  # 3.0
std(x)   # ≈1.58
```
""")

# ╔═╡ b8b3fbe0-3f0d-11eb-07d1-35926101d464
html_expand("Expand for standard error formula", md"""
Standard error = ``\frac{\sigma}{\sqrt{n}}``
where ``\sigma`` is the standard deviation of your estimates and ``n`` is the number of trials (100 in our case).
""")

# ╔═╡ 2bacebf3-5c44-457f-bcac-d8dfe0a63a09
start_code()

# ╔═╡ a22427a3-6126-49cc-9d6d-bf0fc7a2c231
end_code()

# ╔═╡ 4ee95e72-4acd-4cc5-a22d-34fec5b09a48
html_quarter_space()

# ╔═╡ a3e5d614-4f8b-11eb-274e-33c03641e2e8
html_half_space()

# ╔═╡ ba971c7d-996a-47f6-8e95-a127c990b9c7
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

# ╔═╡ a21e4ae3-acab-45f3-834b-e67a449c2f1b
PlutoUI.TableOfContents()

# ╔═╡ Cell order:
# ╟─2ed7b212-3f0b-11eb-21f0-3d47dc28865b
# ╟─1cf22288-de2e-408a-ac8b-7b2470da7271
# ╟─dbfbadd3-a283-4484-8bb1-ab8aff6433b7
# ╠═15ff38d2-3f0b-11eb-3b70-110e0233924e
# ╟─a150639b-6e23-4815-8d38-54b5b55e5f83
# ╟─1f625420-3f0b-11eb-1a97-73752639a1cd
# ╟─b583aae0-3f0a-11eb-1560-03c21f877727
# ╟─b97e1c52-511b-11eb-0dfe-410b622089cc
# ╟─a1fe0dee-fb1f-4356-af95-92fa718b455c
# ╟─5b66dc70-3f0b-11eb-00e3-6910d8ffaf21
# ╟─a8f6f4e5-a56f-4b8e-b545-494e7ca6c45b
# ╟─890f8d20-3f0b-11eb-0ab6-b54cd1c0f0e7
# ╟─8cc8f630-3f0c-11eb-2906-9ffe051b6fb8
# ╟─5baea115-3c4b-4966-a5be-fbc340ecb924
# ╟─0692bf72-6669-4936-aa09-c380d78b0684
# ╠═a689a200-3f0b-11eb-2354-357e2b8a25aa
# ╟─9278a00f-f311-41a6-907a-6d980adef27b
# ╟─db139d96-4bc3-4863-b83b-de3325ba7e35
# ╟─2fab5623-cba7-4bc1-8526-d17b4944a5c0
# ╟─29f2ce3e-4ef0-4958-89ca-dc0700169325
# ╟─c1171e40-3f0b-11eb-311b-337430ba84ac
# ╟─fd1e7040-3f0c-11eb-3b27-69a7f8aee903
# ╟─49fe7c6a-f229-456e-901f-a8e1cebc62cd
# ╟─fd9246ca-4f88-11eb-0619-9b337632c1cd
# ╟─06c09405-2e90-4534-80a9-d1af8321a9f4
# ╠═1c42b2b0-3f0d-11eb-1b92-4b252ac6c319
# ╟─f0182f4e-838a-4dc9-8628-cd9259007dfe
# ╟─954d7212-5557-49c9-812b-f5addd2ac9fc
# ╟─73484a0c-f416-4074-883e-265d9ac5998b
# ╟─093bf4c4-5c32-4d17-a2ef-1ff21f26759e
# ╟─2416a280-3f0d-11eb-04c2-b34b546b1d50
# ╟─57ff0e70-3f0d-11eb-0c5a-4759bf1fbc99
# ╟─99963b79-9da4-4c2c-9d7c-b41f068ca470
# ╠═41787470-3f0d-11eb-0e8c-9bf6be69db81
# ╟─d018a395-0ea5-40c1-968a-717bd1c6736c
# ╟─6b3b1150-3f0d-11eb-23d5-532804c11870
# ╠═6cc6e170-3f0d-11eb-1632-0b4d6e0cf9d8
# ╟─27494c35-1bd9-4ae2-8590-bb4a9cf9eb9c
# ╟─07ae7f44-b1cd-4f52-9d98-86ce6863adc1
# ╟─2f1a021d-d69b-4be7-90c3-df00af75c9cb
# ╟─e283eaae-5712-419a-8433-c5741a53b541
# ╟─88f0a890-3f0d-11eb-3b3f-a3a2150323ae
# ╟─ab4b84f0-3f0d-11eb-246d-894db1e511dd
# ╟─96c9f5cf-43db-4cfa-b3e4-f915e7d85f51
# ╟─b8b3fbe0-3f0d-11eb-07d1-35926101d464
# ╟─f48a9660-3f0d-11eb-3244-2bedb4858323
# ╟─2bacebf3-5c44-457f-bcac-d8dfe0a63a09
# ╠═0d43eca0-4f8b-11eb-0c89-5d63aeb992cd
# ╟─a22427a3-6126-49cc-9d6d-bf0fc7a2c231
# ╟─4ee95e72-4acd-4cc5-a22d-34fec5b09a48
# ╟─2288356c-4f8b-11eb-0894-f90ef2cd8815
# ╟─31d987aa-4f8b-11eb-18cd-07bff8790426
# ╟─368dc05c-4f8b-11eb-2f15-e5bc22b45936
# ╟─72dcdb26-4f8b-11eb-33e4-a3d1903d95fb
# ╟─7da83cc6-4f8b-11eb-260e-09a9c541d3f5
# ╟─a3e5d614-4f8b-11eb-274e-33c03641e2e8
# ╟─62408044-33f4-4343-bc3a-188fe66d4068
# ╟─46c9f5fd-1391-4ea0-a3e0-4c29669b41f3
# ╟─ba971c7d-996a-47f6-8e95-a127c990b9c7
# ╟─a21e4ae3-acab-45f3-834b-e67a449c2f1b
# ╟─d3f66622-b417-46c3-bbb2-bd9cf09ff0ed
