### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 15ff38d2-3f0b-11eb-3b70-110e0233924e
using PlutoUI

# ╔═╡ b8b3fbe0-3f0d-11eb-07d1-35926101d464
using Statistics

# ╔═╡ 9d747840-3f0e-11eb-3f8f-7d9b7ce920e1
using Plots; gr()

# ╔═╡ 2ed7b212-3f0b-11eb-21f0-3d47dc28865b
md"""
# Assignment 1: Estimating $\pi$
"""

# ╔═╡ 1f625420-3f0b-11eb-1a97-73752639a1cd
PlutoUI.LocalResource("./figures/buffon.png")

# ╔═╡ b583aae0-3f0a-11eb-1560-03c21f877727
md"""
Buffon's Needle Problem was first proposed by Georges Buffon in 1737. By randomly throwing needles onto a hard floor marked with equally spaced lines, Buffon was able to derive a mathematial expression which could be used to calculate the value of pi. Specifically, the probability that a needle of length equal to the width of parallel boards overlaps with a board edge is $\frac{2}{\pi}$. 

One can estimate pi by dropping a large number of pins and using the ratio of overlaps to non-overlaps to estimate pi.
The accuracy of this experimental value of pi increases with an increasing number of random throws. 
See [Wikipedia](https://en.wikipedia.org/wiki/Buffon%27s_needle) for a detailed problem description and background.
"""

# ╔═╡ 3d40d020-3f0b-11eb-285a-6d25e30d92c9
md"""
# Buffon's Needles Problem

Your task is to develop an algorithm that estimates pi based on the above description, and write a program to implement this  algorithm.

1. Your algorithm must be implemented from scratch in Julia.
2. Your function should have the following signature: `buffon(n::Int)`.
3. Your function should return $\hat{\pi}$, your estimate for pi.
4. Plot how your algorithm converges as the sample count is increased using [Plots.jl](https://github.com/tbreloff/Plots.jl)
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

To throw a needle, we can keep track of where it lands and how it lands. To do so, choose random x and y to specify the location of the needle and an angle theta to specify in what orientation the needle lies once it lands. Since we are simulating throws, choose random values for x, y, and $\theta$. Remember that the number of needles that you throw depends on the integer value that you pass in. You can use the `rand()` function to select a random number within a given range.
"""

# ╔═╡ 91e5aab0-3f0b-11eb-314f-1d3c03e7a46f
rand(0:10) # example random number between 0 and 10

# ╔═╡ 8cc8f630-3f0c-11eb-2906-9ffe051b6fb8
html"""
<h5><font color=crimson>💻 Implement this function <code>throw_needle()</code></font></h5>

Returns the <code>x</code> and <code>θ</code> value for a randomly thrown needle onto a board with <code>w = l = 1</code>. It is up to you to decide on the domain for <code>x</code> and <code>θ</code> that you would like to use.
"""

# ╔═╡ a689a200-3f0b-11eb-2354-357e2b8a25aa
function throw_needle()
    # STUDENT CODE START
    # STUDENT CODE END

    return (x,θ) # returns values
end

# ╔═╡ c1171e40-3f0b-11eb-311b-337430ba84ac
md"""
### Part 2: Determine Overlap

After you have implemented a means of throwing a needle, you will need to decide whether or not it overlaps with a board edge. Think about how you will want to define your floor, remembering that the width of each board on the floor is the same as the length of the needle. You will want to make use of conditionals such as if statements. (Think about which condition you really need to check within the if statement)
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

# ╔═╡ 1c42b2b0-3f0d-11eb-1b92-4b252ac6c319
function needle_overlaps(x::Float64, θ::Float64)
    # STUDENT CODE START 
    # STUDENT CODE END
end

# ╔═╡ 2416a280-3f0d-11eb-04c2-b34b546b1d50
md"""
### Part 3: Estimating for pi

Recount that Buffon's Needles Problem tells us that the ratio of overlaps to nonoverlaps is $\frac{2}{\pi}$. Now that you are able to run the specified number of trials, you have an estimate for $\frac{2}{\pi}$ and with some algebra we can then get an estimate for ${\pi}$.
"""

# ╔═╡ 57ff0e70-3f0d-11eb-0c5a-4759bf1fbc99
html"""
<h5><font color=crimson>💻 Implement this function <code>buffon_calc(n::Int)</code></font></h5>
"""

# ╔═╡ 4c616c70-3f0d-11eb-1cc9-ab40fe458702
md"""
Estimate pi using `n` thrown needles.
"""

# ╔═╡ 41787470-3f0d-11eb-0e8c-9bf6be69db81
function buffon_calc(n::Int)
	# STUDENT CODE START
    # STUDENT CODE END

	return piapprox # returns your calculated estimate for pi
end

# ╔═╡ 6b3b1150-3f0d-11eb-23d5-532804c11870
md"""
Your code should produce a value close to $\pi$.
"""

# ╔═╡ 6cc6e170-3f0d-11eb-1632-0b4d6e0cf9d8
buffon_calc(20000) # test (failed if `buffon_calc` is not implemented)

# ╔═╡ 7b143a20-3f0d-11eb-0509-4b6a48aee3fb
md"""
### Things to think about/remember:

- How can you define a floor marked with equally spaced lines?
- Which coordinate ultimately decides if the needle overlaps?
- How will you check if a needle overlaps or not?
- The width of each panel is the same as the length of each needle
"""

# ╔═╡ 88f0a890-3f0d-11eb-3b3f-a3a2150323ae
md"""
## Milestone Two: Create a convergence plot

Now that you have the algorithm for estimating pi with the help of Buffon’s Needles Problem, we will use it to create a convergence plot for our data. The x-axis of the plot will be the number of samples and we will generate 15 different sample sizes using log space from 1 to 10000 samples, which is given by: 

			nsamples = round.(Int, collect(exp10.(range(1, stop=5, length=15))))
                    
The y-axis will be the estimated value of pi we get from various sample sizes. 
 
We will then plot the mean estimate for pi for each of 100 trials of the 15 different sample sizes. Also be sure to include error bars with 1-standard deviation. 
"""

# ╔═╡ ab4b84f0-3f0d-11eb-246d-894db1e511dd
md"""
### Run Trials, Calculate Mean, and Find Standard Deviation 

First, we need to run the 100 trials for each of the 15 sample sizes. We want to store the results in some data structure -- a useful data structure might be an array. This all depends on how you would want to calculate the mean estimate for ${\pi}$ for each of the 15 sample sizes. 

Now that you have your data stored in some structure, you will need to calculate the mean estimate for the mean estimate for ${\pi}$ for each of the 15 sample sizes. There are many ways to do this depending on how you initialized your structure. 

**Useful functions:**
`mean` (pass in an array of values)

Finally, you will need to find the error. You could use the std function in Julia to find the standard deviation, ${\sigma}$ for each of the 15 sample sizes. You would then need to divide by the square root of the sample size to calculate error. So for each sample size you would need to calculate $\frac{\sigma}{n}$, where ${\sigma}$ is the standard devation for that sample and n is the size of that sample.

**Useful functions:**
`std` (pass in an array of values)
"""

# ╔═╡ f48a9660-3f0d-11eb-3244-2bedb4858323
html"""
<h5><font color=crimson>💻 Implement this function <code>run_trials()</code></font></h5>
"""

# ╔═╡ ef09be4e-3f0d-11eb-160e-efae5ac2d4de
function run_trials()

    # Implement so that you run 100 trials for each of the 15 sample sizes
    nsamples = round.(Int, collect(exp10.(range(1, stop=5, length=15))))

    # STUDENT CODE START
    # STUDENT CODE END

    return mean_y, stdev_y # return the trials for each of the 15 sample sizes 
end

# ╔═╡ 03638d40-3f0e-11eb-3696-9f49ce233eef
md"""
# Optional: Jackknife

For those of you who would like a bit more of a challenge, you can try to implement _Jackknife_. We have provided a description below:

While calculating error by using the above method may be simpler, a more interesting and rigorous method is the [jackknife](https://en.wikipedia.org/wiki/Jackknife_resampling).

To calculate the standard deviation, you can use the `std` function given by Julia for each set of estimates from the 15 different sample sizes. Another method would be to use jackknife. To implement the jackknife, say we have a sample of $X_1 \ldots X_n$. We generate $n$ samples of size $n - 1$ by leaving out one observation at a time. For example we would have the sample $X_2 \ldots X_n$, leaving out $X_1$ and then the sample $X_1, X_3, \ldots, X_n$, leaving out $X_2$ and continue to remove one element at a time. 
 
We can then use the variance estimation:

$$\operatorname{Var}_\text{jackknife}=\frac{n-1}{n}\sum_{i=1}^{n}\left( \bar{x}_{i}-\bar{x}_{.}\right )$$

where

$$\bar{x}_{.}=\frac{1}{n}\sum_{i=1}^{n}\bar{x}_{i}$$ is the estimator based on all of the subsamples.

You would then square root the variance calculated and get the estimate for the standard deviation.
"""

# ╔═╡ 94c25d70-3f0e-11eb-0dcd-79768991d6fb
md"""
## Starter Code: Jackknife
"""

# ╔═╡ a468dd80-3f0e-11eb-0350-bbd3bd9f9966
# This is served as an example, replace this with your own code
begin
	n_samples = round.(Int, collect(exp10.(range(1,stop=5,length=15))))
	fake_mean_y = map(x->pi + 1/x, n_samples)
	fake_stdev_y = map(x->0.1/log(x), n_samples)
	n_samples = round.(Int, collect(exp10.(range(1,stop=5,length=15))))
	jackknife_mean_y, jackknife_stdev_y = run_trials()
end

# ╔═╡ b66d4ac0-3f0e-11eb-06a1-8bc23bf0b23d
Plots.plot(n_samples, jackknife_mean_y,
		   yerror=jackknife_stdev_y,
		   xaxis=("number of samples", :log),
		   ylabel="estimate of pi")

# ╔═╡ 80ce5fc0-3f0f-11eb-3451-d942af84dffe
md"""
### Things to think about/remember:

- How will you keep track of all the trials?  
- How can you use the map function to help you with the mean and standard deviation?
- Make sure you are comfortable with Arrays/Vectors/Matrices
"""

# ╔═╡ Cell order:
# ╟─2ed7b212-3f0b-11eb-21f0-3d47dc28865b
# ╠═15ff38d2-3f0b-11eb-3b70-110e0233924e
# ╠═1f625420-3f0b-11eb-1a97-73752639a1cd
# ╟─b583aae0-3f0a-11eb-1560-03c21f877727
# ╟─3d40d020-3f0b-11eb-285a-6d25e30d92c9
# ╟─5b66dc70-3f0b-11eb-00e3-6910d8ffaf21
# ╟─890f8d20-3f0b-11eb-0ab6-b54cd1c0f0e7
# ╠═91e5aab0-3f0b-11eb-314f-1d3c03e7a46f
# ╟─8cc8f630-3f0c-11eb-2906-9ffe051b6fb8
# ╠═a689a200-3f0b-11eb-2354-357e2b8a25aa
# ╟─c1171e40-3f0b-11eb-311b-337430ba84ac
# ╠═c9c6ef20-3f0b-11eb-1a1b-bba275052db9
# ╟─fd1e7040-3f0c-11eb-3b27-69a7f8aee903
# ╠═1c42b2b0-3f0d-11eb-1b92-4b252ac6c319
# ╟─2416a280-3f0d-11eb-04c2-b34b546b1d50
# ╟─57ff0e70-3f0d-11eb-0c5a-4759bf1fbc99
# ╟─4c616c70-3f0d-11eb-1cc9-ab40fe458702
# ╠═41787470-3f0d-11eb-0e8c-9bf6be69db81
# ╟─6b3b1150-3f0d-11eb-23d5-532804c11870
# ╠═6cc6e170-3f0d-11eb-1632-0b4d6e0cf9d8
# ╟─7b143a20-3f0d-11eb-0509-4b6a48aee3fb
# ╟─88f0a890-3f0d-11eb-3b3f-a3a2150323ae
# ╟─ab4b84f0-3f0d-11eb-246d-894db1e511dd
# ╠═b8b3fbe0-3f0d-11eb-07d1-35926101d464
# ╟─f48a9660-3f0d-11eb-3244-2bedb4858323
# ╠═ef09be4e-3f0d-11eb-160e-efae5ac2d4de
# ╟─03638d40-3f0e-11eb-3696-9f49ce233eef
# ╟─94c25d70-3f0e-11eb-0dcd-79768991d6fb
# ╠═9d747840-3f0e-11eb-3f8f-7d9b7ce920e1
# ╠═a468dd80-3f0e-11eb-0350-bbd3bd9f9966
# ╠═b66d4ac0-3f0e-11eb-06a1-8bc23bf0b23d
# ╟─80ce5fc0-3f0f-11eb-3451-d942af84dffe
