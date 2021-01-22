### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 15ff38d2-3f0b-11eb-3b70-110e0233924e
using PlutoUI

# ╔═╡ b8b3fbe0-3f0d-11eb-07d1-35926101d464
using Statistics

# ╔═╡ 2b7adf62-4f8b-11eb-2de5-5709efe602a8
using Plots; plotly()

# ╔═╡ 2ed7b212-3f0b-11eb-21f0-3d47dc28865b
md"""
# Assignment 1: Estimating $\pi$
"""

# ╔═╡ 1f625420-3f0b-11eb-1a97-73752639a1cd
PlutoUI.LocalResource("figures/buffon.png")

# ╔═╡ b583aae0-3f0a-11eb-1560-03c21f877727
md"""
Buffon's Needle Problem was first proposed by Georges Buffon in 1737. By randomly throwing needles onto a hard floor marked with equally spaced lines, Buffon was able to derive a mathematial expression which could be used to calculate the value of $\pi$. Specifically, the probability that a needle of length equal to the width of parallel boards overlaps with a board edge is $\frac{2}{\pi}$. 

One can estimate pi by dropping a large number of pins and using the ratio of overlaps to non-overlaps to estimate pi.
The accuracy of this experimental value of pi increases with an increasing number of random throws. 
See [Wikipedia](https://en.wikipedia.org/wiki/Buffon%27s_needle) for a detailed problem description and background.
"""

# ╔═╡ b97e1c52-511b-11eb-0dfe-410b622089cc
md"""
## What is Turned In:
Edit the contents of this notebook and turn in your final Pluto notebook file (.jl) to Canvas. Do not use any external code or Julia packages other than those used in the class materials.
"""

# ╔═╡ 3d40d020-3f0b-11eb-285a-6d25e30d92c9
md"""
# Buffon's Needles Problem

In this assignment, you will develop an algorithm that estimates $\pi$ based on the above description, and write a program to implement this  algorithm.

1. Your algorithm will be implemented in Julia.
2. Your main function will have the following signature: `buffon(n::Int)`.
3. Your main function will return $\hat{\pi}$, your estimate for pi.
4. You will plot how your algorithm converges as the sample count is increased using [Plots.jl](https://github.com/tbreloff/Plots.jl)
5. Although you may discuss your algorithm with others, you must not share code.
"""

# ╔═╡ 5b66dc70-3f0b-11eb-00e3-6910d8ffaf21
md"""
## Milestone One: Implementing `buffon(n::Int)`

Our goal is to implement a function, `buffon(n::Int)`. The function `buffon(n::Int)` takes in an integer parameter `n` as the number of trials run, returning an estimate for pi based on the number of trials. We can divide the implementation of the function `buffon(n::Int)` into three parts: 
1. Throwing a needle
2. Checking whether the needle overlaps with a floorboard line
3. Use your result to estimate ${\pi}$
"""

# ╔═╡ 890f8d20-3f0b-11eb-0ab6-b54cd1c0f0e7
md"""
### Part 1: Throwing a Needle

To throw a needle, we can keep track of where it lands and how it lands. To do so, choose random x to specify the location of the center of the needle (the y location does not matter - make sure that makes sense to you before moving on) and an angle $\theta$ to specify in what orientation the needle lies once it lands. Since we are simulating throws, choose random values for x and $\theta$. The `rand()` function selects a random number between 0 and 1.
"""

# ╔═╡ 91e5aab0-3f0b-11eb-314f-1d3c03e7a46f
rand() * 10 # example random number between 0 and 10

# ╔═╡ 8cc8f630-3f0c-11eb-2906-9ffe051b6fb8
html"""
<h5><font color=crimson>💻 Implement the function <code>throw_needle()</code></font></h5>

Returns the <code>x</code> and <code>θ</code> value for a randomly thrown needle onto a board that has a total of five sections of width 1 (you can use the figure at the top of the page as a visual guide). Thus, the needle also has length 1. Let's define the leftmost border of the floor to correspond to <code>x = 0</code> and the rightmost border to correspond to <code>x = 5</code>. Based on this definition of our coordinates, it is up to you to specify the correct domain for <code>x</code> and <code>θ</code>.
"""

# ╔═╡ a689a200-3f0b-11eb-2354-357e2b8a25aa
function throw_needle()
    x = 0
	θ = 0
	
	# STUDENT CODE START
	
    # STUDENT CODE END

    return (x,θ) # returns values
end

# ╔═╡ c1171e40-3f0b-11eb-311b-337430ba84ac
md"""
### Part 2: Determine Overlap

After you have implemented a means of throwing a needle, you will need to decide whether or not it overlaps with a board edge. Think about the coordinate system we defined for our floor. You will want to make use of conditionals such as if statements. (Think about which condition you really need to check within the if statement)
"""

# ╔═╡ c9c6ef20-3f0b-11eb-1a1b-bba275052db9
# Example:
with_terminal() do
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
end

# ╔═╡ fd1e7040-3f0c-11eb-3b27-69a7f8aee903
html"""
<h5><font color=crimson>💻 Implement this function <code>needle_overlaps(x::Float64, θ::Float64)</code></font></h5>

Check if the needle overlaps with a board edge and return <code>true</code> if so and <code>false</code> if not.
"""

# ╔═╡ fd9246ca-4f88-11eb-0619-9b337632c1cd
html"""
<b>Hint</b>: according to our definition, the value we sample for <code>x</code> corresponds to the center of the needle. It may be useful to determine the location of the tips of the needle based on the sampled value of <code>θ</code>. Is there a simple trigonometric relationship to provide us with this?
"""

# ╔═╡ 1c42b2b0-3f0d-11eb-1b92-4b252ac6c319
function needle_overlaps(x::Float64, θ::Float64)
	overlaps = true
	
	# STUDENT CODE START

    # STUDENT CODE END
	
	return overlaps
end

# ╔═╡ 2416a280-3f0d-11eb-04c2-b34b546b1d50
md"""
### Part 3: Estimating $\pi$

It is now time to use the two function we wrote the get an estimate for $\pi$! Recall that Buffon's Needles Problem tells us that the ratio of overlaps to nonoverlaps is $\frac{2}{\pi}$. Once that you are able to run the specified number of trials, you have an estimate for $\frac{2}{\pi}$ and with some algebra we can then get an estimate for ${\pi}$.
"""

# ╔═╡ 57ff0e70-3f0d-11eb-0c5a-4759bf1fbc99
html"""
<h5><font color=crimson>💻 Implement this function <code>buffon_calc(n::Int)</code></font></h5>
"""

# ╔═╡ 4c616c70-3f0d-11eb-1cc9-ab40fe458702
md"""
Estimate $\pi$ using `n` thrown needles.
"""

# ╔═╡ d4c5e7da-f6b5-46d4-98f4-dd657dfc3a3e
md"""
> **Note**: to produce the character `π̂` type `\pi<TAB>` then `\hat<TAB>`
"""

# ╔═╡ 41787470-3f0d-11eb-0e8c-9bf6be69db81
function buffon_calc(n::Int)
	π̂ = 0
	
	# STUDENT CODE START

    # STUDENT CODE END

	return π̂ # returns your calculated estimate for π
end

# ╔═╡ 6b3b1150-3f0d-11eb-23d5-532804c11870
md"""
**Check:** Your code should produce a value close to $\pi$.
"""

# ╔═╡ 6cc6e170-3f0d-11eb-1632-0b4d6e0cf9d8
buffon_calc(20000) # test (failed if `buffon_calc` is not implemented)

# ╔═╡ 7b143a20-3f0d-11eb-0509-4b6a48aee3fb
md"""
### Things to think about/remember:

- Which coordinate ultimately decides if the needle overlaps?
- How will you check if a needle overlaps or not?
- The width of each panel is the same as the length of each needle
"""

# ╔═╡ 88f0a890-3f0d-11eb-3b3f-a3a2150323ae
md"""
## Milestone Two: Create a convergence plot

Now that you have the algorithm for estimating pi with the help of Buffon’s Needles Problem, we will use it to create a convergence plot for our data. The x-axis of the plot will be the number of samples and we will generate 15 different sample sizes using log space from 1 to 10,000 samples, which is given by: 

	nsamples = round.(Int, collect(exp10.(range(1, stop=5, length=15))))
                    
The y-axis will be the estimated value of $\pi$ we get from various sample sizes. 
 
We will then plot the mean estimate for $\pi$ for each of 100 trials of the 15 different sample sizes. Also be sure to include error bars with 1-standard deviation. 
"""

# ╔═╡ ab4b84f0-3f0d-11eb-246d-894db1e511dd
md"""
### Run Trials, Calculate Mean, and Find Standard Deviation 

First, we need to run the 100 trials for each of the 15 sample sizes. We want to store the results in some data structure -- a useful data structure might be an array. This all depends on how you would want to calculate the mean estimate for ${\pi}$ for each of the 15 sample sizes. 

Now that you have your data stored in some structure, you will need to calculate the mean estimate for the mean estimate for ${\pi}$ for each of the 15 sample sizes. There are many ways to do this depending on how you initialized your structure. 

Finally, you will need to find the error. You could use the `std` function in Julia to find the standard deviation, ${\sigma}$ for each of the 15 sample sizes. You would then need to divide by the square root of the sample size to calculate error. So for each sample size you would need to calculate $\frac{\sigma}{\sqrt{n}}$, where ${\sigma}$ is the standard devation for that sample and $n$ is the size of that sample.

**Useful functions:**

`mean` (pass in an array of values)

`std` (pass in an array of values)
"""

# ╔═╡ f48a9660-3f0d-11eb-3244-2bedb4858323
html"""
<h5><font color=crimson>💻 Implement this function <code>run_trials()</code></font></h5>
"""

# ╔═╡ 0d43eca0-4f8b-11eb-0c89-5d63aeb992cd
function run_trials()

    # Implement so that you run 100 trials for each of the 15 sample sizes
    nsamples = round.(Int, collect(exp10.(range(1, stop=5, length=15))))
	
	# Populate these arrays with the results from the trials
	mean_y = zeros(15)
	stderr_y = zeros(15)

    # STUDENT CODE START

    # STUDENT CODE END

    return mean_y, stderr_y # return the trials for each of the 15 sample sizes 
end

# ╔═╡ 2288356c-4f8b-11eb-0894-f90ef2cd8815
md"""
### Convergence Plot:

This section will generate your convergence plot. You should not have to change any of the code in this section. Check out the results of your hard work!
"""

# ╔═╡ 31d987aa-4f8b-11eb-18cd-07bff8790426
n_samples = round.(Int, collect(exp10.(range(1,stop=5,length=15))));

# ╔═╡ 368dc05c-4f8b-11eb-2f15-e5bc22b45936
mean_y, stderr_y = run_trials();

# ╔═╡ 72dcdb26-4f8b-11eb-33e4-a3d1903d95fb
Plots.plot(n_samples, mean_y,
		   yerror=stderr_y,
		   xaxis=("number of samples", :log),
		   ylabel="estimate of pi", legend=false)

# ╔═╡ 7da83cc6-4f8b-11eb-260e-09a9c541d3f5
md"""
Your plot should look like it is converging to the true value of $\pi$.
"""

# ╔═╡ a3e5d614-4f8b-11eb-274e-33c03641e2e8
md"""
### You have completed the assignment!
---
"""

# ╔═╡ a21e4ae3-acab-45f3-834b-e67a449c2f1b
PlutoUI.TableOfContents(title="Estimating π")

# ╔═╡ Cell order:
# ╟─2ed7b212-3f0b-11eb-21f0-3d47dc28865b
# ╠═15ff38d2-3f0b-11eb-3b70-110e0233924e
# ╟─1f625420-3f0b-11eb-1a97-73752639a1cd
# ╟─b583aae0-3f0a-11eb-1560-03c21f877727
# ╟─b97e1c52-511b-11eb-0dfe-410b622089cc
# ╟─3d40d020-3f0b-11eb-285a-6d25e30d92c9
# ╟─5b66dc70-3f0b-11eb-00e3-6910d8ffaf21
# ╟─890f8d20-3f0b-11eb-0ab6-b54cd1c0f0e7
# ╠═91e5aab0-3f0b-11eb-314f-1d3c03e7a46f
# ╟─8cc8f630-3f0c-11eb-2906-9ffe051b6fb8
# ╠═a689a200-3f0b-11eb-2354-357e2b8a25aa
# ╟─c1171e40-3f0b-11eb-311b-337430ba84ac
# ╠═c9c6ef20-3f0b-11eb-1a1b-bba275052db9
# ╟─fd1e7040-3f0c-11eb-3b27-69a7f8aee903
# ╟─fd9246ca-4f88-11eb-0619-9b337632c1cd
# ╠═1c42b2b0-3f0d-11eb-1b92-4b252ac6c319
# ╟─2416a280-3f0d-11eb-04c2-b34b546b1d50
# ╟─57ff0e70-3f0d-11eb-0c5a-4759bf1fbc99
# ╟─4c616c70-3f0d-11eb-1cc9-ab40fe458702
# ╟─d4c5e7da-f6b5-46d4-98f4-dd657dfc3a3e
# ╠═41787470-3f0d-11eb-0e8c-9bf6be69db81
# ╟─6b3b1150-3f0d-11eb-23d5-532804c11870
# ╠═6cc6e170-3f0d-11eb-1632-0b4d6e0cf9d8
# ╟─7b143a20-3f0d-11eb-0509-4b6a48aee3fb
# ╟─88f0a890-3f0d-11eb-3b3f-a3a2150323ae
# ╟─ab4b84f0-3f0d-11eb-246d-894db1e511dd
# ╠═b8b3fbe0-3f0d-11eb-07d1-35926101d464
# ╟─f48a9660-3f0d-11eb-3244-2bedb4858323
# ╠═0d43eca0-4f8b-11eb-0c89-5d63aeb992cd
# ╟─2288356c-4f8b-11eb-0894-f90ef2cd8815
# ╠═2b7adf62-4f8b-11eb-2de5-5709efe602a8
# ╠═31d987aa-4f8b-11eb-18cd-07bff8790426
# ╠═368dc05c-4f8b-11eb-2f15-e5bc22b45936
# ╟─72dcdb26-4f8b-11eb-33e4-a3d1903d95fb
# ╟─7da83cc6-4f8b-11eb-260e-09a9c541d3f5
# ╟─a3e5d614-4f8b-11eb-274e-33c03641e2e8
# ╠═a21e4ae3-acab-45f3-834b-e67a449c2f1b
