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

# ╔═╡ f3d093c0-076b-11eb-21bc-d752119bd59f
begin
	using PlutoUI

	md"""
	# Scientific Computing Tools and Visualizations
	AA120Q: *Building Trust in Autonomy*, Stanford University. 

	## Lecture 2
	We will discuss how the Julia programming language is used for scientific computing and data visualization.

	Readings:
	- [Julia tutorial](https://learnxinyminutes.com/docs/julia/)
	"""
end

# ╔═╡ db7cd9e0-0776-11eb-1cd5-d582a6dcfcdd
using DataFrames

# ╔═╡ 4c3d23b0-0777-11eb-0541-efbd67f06b91
using Distributions

# ╔═╡ 6e8be5e0-40c1-11eb-36a5-976734a0a2cf
using Random

# ╔═╡ 7145ddd0-077e-11eb-3514-d3736ee63693
using Discretizers

# ╔═╡ 0384269e-0781-11eb-17a5-7fa7f4db431d
using Plots

# ╔═╡ e98fd5c0-0783-11eb-0719-8385ba04dcd7
using Colors

# ╔═╡ 0590fee0-0787-11eb-2359-21c3bad35e43
using SymPy

# ╔═╡ 6536e190-076c-11eb-3c75-7f594ba1ab24
md"""
# Scientific Computing
Scientific computing is the process of using "advanced computing capabilities to understand and solve complex problems".$^{[\href{https://en.wikipedia.org/wiki/Computational_science}{1}]}$

Scientific computing includes:
- Algorithm and data structure design
- Numerical simulation
- Model fitting
- Data analysis
- Optimization
"""

# ╔═╡ b052f060-076c-11eb-0605-2bda092968da
md"""
## Julia

![](https://julialang.org/assets/infra/logo.svg)

Julia is a high-level dynamic programming language.$^{[\href{https://en.wikipedia.org/wiki/Julia_(programming_language)}{2}]}$
"""

# ╔═╡ 91b3c700-076d-11eb-2090-f340640ff2f0
md"""
### Installing Packages
Julia makes it easy to install packages (and specific versions of packages too).

Julia also makes it easy to obtain packages from Github.
"""

# ╔═╡ 6d579664-fe37-4986-aea6-d50b4f1e64af
md"""
```julia
using Pkg
Pkg.add("DataFrames")
Pkg.add("Distributions")
Pkg.add("Discretizers")
Pkg.add("Plots")
Pkg.add("Colors")
Pkg.add("SymPy")
```
"""

# ╔═╡ 8a655ae0-076d-11eb-196b-c5af3ec9148f
md"""
# Scientific Computing Packages
Julia offers a wide range of [official packages](https://juliahub.com/). There are many custom packages that are not in the official listing as well.

You can go to a package's documentation, typically from Github, to view all of its features.

Some of the packages we will be using are:
- DataFrames
- Distributions
- Discretizers
- Plots
- Colors
- SymPy
"""

# ╔═╡ 46be8b02-0776-11eb-0a40-b1de3001c2fa
md"""
## DataFrames
"""

# ╔═╡ dd115c90-0776-11eb-2a5a-a7a9e12e0b85
df = DataFrame(animal=["Dog", "Cat", "Mouse", "Snake", "Sparrow"],
	           legs=[4, 4, 4, 0, 2],
	           weight=[100, 10, 0.68, 2, 0.2])

# ╔═╡ ff2a26e0-0776-11eb-1543-5b0a27c2eeb9
df[2, :animal]

# ╔═╡ 03025800-0777-11eb-061c-1749664edcaf
df[2, 1]

# ╔═╡ 053eb370-0777-11eb-2ae5-f7e866357a0f
df[!, :legs]

# ╔═╡ 09a93980-0777-11eb-1b25-2154fbb945ec
md"""
## Distributions
This package provides all sorts of probability distributions and methods for sampling from them and inferring them from data.
"""

# ╔═╡ 51b59750-0777-11eb-3c41-7ba300d5abbc
Random.seed!(0); # for reproducable results

# ╔═╡ 5dfac3f0-0777-11eb-34e2-4fc2b0ddd28d
dist = Normal(1, 2)

# ╔═╡ 7374f700-0777-11eb-3020-2919684db10c
rand(dist)

# ╔═╡ 76f4cef0-0777-11eb-3930-c9d54aba42a1
data = rand(dist, 10)

# ╔═╡ 7f06b220-0777-11eb-2109-8b41ec9dd93d
fit(Normal, data)

# ╔═╡ 62ef3650-077e-11eb-345f-8720b68ebfd5
md"""
## Discretizers
This package provides an easy way to discretize data or map between labels and integer vaules.
"""

# ╔═╡ 72e8ea00-077f-11eb-195a-2d558e885ca6
md"""
#### Categorical discretizers
"""

# ╔═╡ 783f4c1e-077e-11eb-005c-3f7446c6da63
discrete_data = ["cat", "dog", "dog", "cat", "cat", "elephant"]

# ╔═╡ 964acb90-077e-11eb-10ef-5506be3a9fdc
discretizer = CategoricalDiscretizer(discrete_data)

# ╔═╡ cd0ff19e-077e-11eb-359c-7f301bf65893
md"""
###### Encoding
"""

# ╔═╡ b43e2f20-077e-11eb-20c1-5b43d16d5603
encode(discretizer, "cat")

# ╔═╡ bc04b172-077e-11eb-22d1-8f447108dd3b
encode(discretizer, "dog")

# ╔═╡ c37d3ad0-077e-11eb-08c0-09a8ec7f1755
encode(discretizer, discrete_data)

# ╔═╡ c9c00350-077e-11eb-0b2d-df216cb079b7
md"""
###### Decoding
"""

# ╔═╡ d73ac9c0-077e-11eb-33c5-6b8fb4b53e45
decode(discretizer, 1)

# ╔═╡ f66fae00-077e-11eb-2cc2-2bc8f2a27180
decode(discretizer, 2)

# ╔═╡ f96b61d0-077e-11eb-0b17-7189abf81f2d
decode(discretizer, [1, 2, 3])

# ╔═╡ 320f0be0-077f-11eb-37fa-6daafba872cf
md"""
#### Linear discretizers
"""

# ╔═╡ 048fdc30-077f-11eb-1e3b-b1da18425fdf
md"""
Here we construct a linear discretizer that maps $[0, 0.5) \to 1$ and $[0.5, 1] \to 2$.
"""

# ╔═╡ 15e91550-077f-11eb-2469-6f1e90d3491f
binedges = [0, 0.5, 1]

# ╔═╡ 1d4d7a70-077f-11eb-3752-5d42c826d823
lineardisc = LinearDiscretizer(binedges)

# ╔═╡ 54990e90-077f-11eb-20a0-bbdba8de08a4
md"""
###### Encoding
"""

# ╔═╡ 29a67d30-077f-11eb-1bb1-2f5998f4a8bf
encode(lineardisc, 0.2)

# ╔═╡ 48855230-077f-11eb-0cc7-e1b3f68c4bbc
encode(lineardisc, 0.7)

# ╔═╡ 49ffbd32-077f-11eb-159e-ef3ca084c9e6
encode(lineardisc, 0.5)

# ╔═╡ 4ae3dba0-077f-11eb-3b1e-79a6d52114ac
encode(lineardisc, [0, 0.8, 0.2])

# ╔═╡ 5382e3a0-077f-11eb-324b-7f1eae0f0e3e
md"""
###### Decoding
"""

# ╔═╡ 6242d440-077f-11eb-09c2-7d637f3be52d
decode(lineardisc, 1)

# ╔═╡ 680e22d0-077f-11eb-2639-67723187c19f
decode(lineardisc, 2)

# ╔═╡ 6accf4b0-077f-11eb-1408-7b86c51641cf
decode(lineardisc, [2, 1, 2])

# ╔═╡ c84dc3be-0780-11eb-237a-3b491dae9c4d
md"""
# Data Visualization and Plotting
Data visualization and plotting are extremely important for the interpretation of scientific results. Julia has many great packages for this.
"""

# ╔═╡ e636ee20-0780-11eb-0239-4b58bcae19b7
md"""
## Plots
[Plots.jl](http://docs.juliaplots.org/latest/) is a wrapper for a number of Julia plotting packages, providing a clean interface to all of them.
"""

# ╔═╡ 069adc80-0781-11eb-1aad-abb11200e9cf
plotly() # one of many different backends

# ╔═╡ 60250140-0a88-11eb-1d92-99f3cc279e4a
XY = Plots.fakedata(50, 10)

# ╔═╡ 0e94cae0-0781-11eb-006e-f1e951667e43
plot(XY, palette=:jet)

# ╔═╡ 18e37eb0-0781-11eb-19c7-b3b0a548e5bf
md"""
Plotting a function $f(x)$.
"""

# ╔═╡ 384f0350-0781-11eb-109f-0339f1e31e21
plot(sin, x->sin(2x), 0, 2π, legend=false)

# ╔═╡ 42e08c80-0781-11eb-0dc9-e74d7639d4a4
X = [1, 2, 3, 4, 6, 8, 10]

# ╔═╡ 4be9ef10-0781-11eb-1831-e12b5845af42
Y = [0.5, 0.4, 0.6, 1.2, -0.5, 0.8, 0.0]

# ╔═╡ 5c390b30-0781-11eb-19c9-8de114d2397e
plot(X, Y, color=:red, linestyle=:dash,
	       xlabel="horizontal axis label",
	       ylabel="vertical axis label",
	       label="line label",
	       title="The Title")

# ╔═╡ 878c8140-0781-11eb-13b2-d36ec8329a48
md"""
We can layer plots on top of one another.
"""

# ╔═╡ 7c333b42-0781-11eb-0199-bd5a50e2a2d5
begin
	p = plot(x->sin(x^2), 0, π, line=2, lab="sin(x²)")
	plot!(p, x->sin(x)^2, 0, π, line=2, lab="sin(x)²")
	scatter!(p, [0, 1, 2, 3], [0.5, 0, -0.5, 0], lab="scatter")
end

# ╔═╡ c17a3780-0781-11eb-386e-83e5c931cc31
histogram(randn(1000), bins=20)

# ╔═╡ ccc704f0-0782-11eb-1b75-8ddfd5ffb33d
md"Control the mean: $(@bind μ Slider(-5:0.5:5, default=0, show_value=true))"

# ╔═╡ ce804320-0781-11eb-2b48-9927b05e5bdc
md"Control the standard deviation: $(@bind σ Slider(0.2:0.2:5, default=1, show_value=true))"

# ╔═╡ fadb8c40-0781-11eb-297e-4db03c0d521b
histogram(μ .+ σ*randn(1000), bins=20); xlims!(-15, 15); ylims!(0, 250)

# ╔═╡ 48ae1310-0783-11eb-2d09-6b00cca36f26
md"""
> Note you can use underscores within numbers as separators for human-readability. 
"""

# ╔═╡ 3f301cc0-0783-11eb-092a-918535d1bd1c
histogram2d(randn(10_000), randn(10_000), bins=20, c=:viridis, showempty=true)

# ╔═╡ 48af1ab0-0a87-11eb-224c-d389ecb189e9
md"Control the mean (x): $(@bind μx2d Slider(-5:0.5:5, default=0, show_value=true)) |  Control the mean (y): $(@bind μy2d Slider(-5:0.5:5, default=0, show_value=true))"

# ╔═╡ 3d8967d0-0a87-11eb-3d2c-8b15d9e77e12
md"Control the standard deviation (x): $(@bind σx2d Slider(0.2:0.2:4, default=1, show_value=true)) | Control σ (y): $(@bind σy2d Slider(0.2:0.2:4, default=1, show_value=true))"

# ╔═╡ 5f9030be-0a87-11eb-2035-6d60b017c3c3
begin
	X2d = μx2d .+ σx2d*randn(10_000)
	Y2d = μy2d .+ σy2d*randn(10_000)
	histogram2d(X2d, Y2d, bins=20, c=:viridis)
	xlims!(-10,10)
	ylims!(-10,10)
end

# ╔═╡ 8fb3fd60-0783-11eb-2f7e-912b2637b908
begin
	p1 = histogram(randn(1000), bins=20)
	p2 = plot(x->sin(x^2), 0, π, lab="sin(x²)")
	plot(p1, p2, layout=2, size=(650, 250))
end

# ╔═╡ aa2f2a20-0783-11eb-1969-3d44dd557c93
md"""
## Data Visualization
Data visualization is more general than plotting, and often involves interaction and more general graphics libraries.

This class uses `Reactive`, `PlutoUI`, and `Cairo` behind the scenes.
"""

# ╔═╡ fc730a40-0783-11eb-2bd0-cb2cc7c9f987
md"""
Red: $(@bind r Slider(0:0.01:1))
Green: $(@bind g Slider(0:0.01:1))
Blue: $(@bind b Slider(0:0.01:1))
"""

# ╔═╡ efd73220-0783-11eb-06aa-c775f6fb89d7
RGB(r, g, b)

# ╔═╡ 350a7f4e-0784-11eb-1fa5-17cbd9d193c2
md" $\uparrow$ unhide the above cell to see how these sliders work."

# ╔═╡ 658318e0-0784-11eb-1a47-f7c46d6cb10c
md"""
Hue: $(@bind h Slider(0:360))
Saturation: $(@bind s Slider(0:0.01:1, default=0.5))
Value (i.e. brightness): $(@bind v Slider(0:0.01:1, default=0.5))
"""

# ╔═╡ 31b95880-0784-11eb-39f1-332b4ebb8d2a
HSV(h, s, v)

# ╔═╡ cc62b2f0-0784-11eb-3c99-01342dc67e7d
md"""
You can use `RGB` with plots as well (try changing this to use `r`, `g`, and `b` bound to sliders from above).
"""

# ╔═╡ acd1f310-0784-11eb-2e4f-7d2da86dbee0
plot(x->sin(x^2), 0, π, line=2, color=RGB(0.75, 0, 0.5))

# ╔═╡ b9ced6f0-0784-11eb-0f57-5999bd3df9e2
md"""
# SymPy
Symbolic math in Julia!
"""

# ╔═╡ 99274452-078e-11eb-1d23-3528c7bbfe1b
# Fix LaTeX display issue which was wrapping things with \text{...}
# https://github.com/fonsp/Pluto.jl/issues/488
Base.show(io::IO, ::MIME"text/latex", x::SymPy.SymbolicObject) = print(io, sympy.latex(x, mode="inline"))

# ╔═╡ 0ecedef0-0787-11eb-1006-f5e89a94559f
x = symbols("x")

# ╔═╡ 08aec432-0788-11eb-209d-017d9bc569e9
y = sin(π*x)

# ╔═╡ 2fbe1600-078a-11eb-17b5-bf277495fd9f
y(1)

# ╔═╡ 3397f4d0-078a-11eb-34b4-d534d90322b0
solve(x^2 + 1)

# ╔═╡ 2e137340-078a-11eb-2020-a99eb75e14fb
z = symbols("z", real=true)

# ╔═╡ 4fe856c0-078a-11eb-1f87-03f36f56e416
solve(z^2 + 1)

# ╔═╡ 4dc82700-0918-11eb-1d2c-7728dad5b2f9
y1, y2 = symbols("y1, y2", positive=true)

# ╔═╡ 5504045e-078a-11eb-1287-79f40457f8cb
solve(y1 + 1) # -1 is not positive

# ╔═╡ 6230d1e0-078a-11eb-1c2a-ebd4cf7299f9
ex = x^2 + 2x + 1

# ╔═╡ 6aac7360-078a-11eb-0cee-e5780438eb5e
subs(ex, x, y)

# ╔═╡ 77f37fa2-078a-11eb-130e-43348967a008
subs(ex, x, 0)

# ╔═╡ 7c2d31b2-078a-11eb-1ddc-e547ad6cef98
w = x^2 + 3x + 2

# ╔═╡ b3b384e0-078a-11eb-02e1-d98d80d9c457
factor(w)

# ╔═╡ ba511790-078a-11eb-0d2c-451cc28851cd
solve(cos(x) - sin(x))

# ╔═╡ c58c2730-078a-11eb-07c3-db5c4848e151
limit(sin(x)/x, x, 0)

# ╔═╡ ca169150-078a-11eb-2532-472d16f3fb43
diff(x^x, x)

# ╔═╡ cdb95a90-078a-11eb-1f63-4be59b019e55
integrate(x^3, x)

# ╔═╡ 7d23aab8-1cf5-440b-9a43-b1ef2b15a586
md"---"

# ╔═╡ de5cd6f0-5907-45f1-b7b2-fd70dc4debe9
PlutoUI.TableOfContents(title="Computing Tools")

# ╔═╡ Cell order:
# ╟─f3d093c0-076b-11eb-21bc-d752119bd59f
# ╟─6536e190-076c-11eb-3c75-7f594ba1ab24
# ╟─b052f060-076c-11eb-0605-2bda092968da
# ╟─91b3c700-076d-11eb-2090-f340640ff2f0
# ╟─6d579664-fe37-4986-aea6-d50b4f1e64af
# ╟─8a655ae0-076d-11eb-196b-c5af3ec9148f
# ╟─46be8b02-0776-11eb-0a40-b1de3001c2fa
# ╠═db7cd9e0-0776-11eb-1cd5-d582a6dcfcdd
# ╠═dd115c90-0776-11eb-2a5a-a7a9e12e0b85
# ╠═ff2a26e0-0776-11eb-1543-5b0a27c2eeb9
# ╠═03025800-0777-11eb-061c-1749664edcaf
# ╠═053eb370-0777-11eb-2ae5-f7e866357a0f
# ╟─09a93980-0777-11eb-1b25-2154fbb945ec
# ╠═4c3d23b0-0777-11eb-0541-efbd67f06b91
# ╠═6e8be5e0-40c1-11eb-36a5-976734a0a2cf
# ╠═51b59750-0777-11eb-3c41-7ba300d5abbc
# ╠═5dfac3f0-0777-11eb-34e2-4fc2b0ddd28d
# ╠═7374f700-0777-11eb-3020-2919684db10c
# ╠═76f4cef0-0777-11eb-3930-c9d54aba42a1
# ╠═7f06b220-0777-11eb-2109-8b41ec9dd93d
# ╟─62ef3650-077e-11eb-345f-8720b68ebfd5
# ╠═7145ddd0-077e-11eb-3514-d3736ee63693
# ╟─72e8ea00-077f-11eb-195a-2d558e885ca6
# ╠═783f4c1e-077e-11eb-005c-3f7446c6da63
# ╠═964acb90-077e-11eb-10ef-5506be3a9fdc
# ╟─cd0ff19e-077e-11eb-359c-7f301bf65893
# ╠═b43e2f20-077e-11eb-20c1-5b43d16d5603
# ╠═bc04b172-077e-11eb-22d1-8f447108dd3b
# ╠═c37d3ad0-077e-11eb-08c0-09a8ec7f1755
# ╟─c9c00350-077e-11eb-0b2d-df216cb079b7
# ╠═d73ac9c0-077e-11eb-33c5-6b8fb4b53e45
# ╠═f66fae00-077e-11eb-2cc2-2bc8f2a27180
# ╠═f96b61d0-077e-11eb-0b17-7189abf81f2d
# ╟─320f0be0-077f-11eb-37fa-6daafba872cf
# ╟─048fdc30-077f-11eb-1e3b-b1da18425fdf
# ╠═15e91550-077f-11eb-2469-6f1e90d3491f
# ╠═1d4d7a70-077f-11eb-3752-5d42c826d823
# ╟─54990e90-077f-11eb-20a0-bbdba8de08a4
# ╠═29a67d30-077f-11eb-1bb1-2f5998f4a8bf
# ╠═48855230-077f-11eb-0cc7-e1b3f68c4bbc
# ╠═49ffbd32-077f-11eb-159e-ef3ca084c9e6
# ╠═4ae3dba0-077f-11eb-3b1e-79a6d52114ac
# ╟─5382e3a0-077f-11eb-324b-7f1eae0f0e3e
# ╠═6242d440-077f-11eb-09c2-7d637f3be52d
# ╠═680e22d0-077f-11eb-2639-67723187c19f
# ╠═6accf4b0-077f-11eb-1408-7b86c51641cf
# ╟─c84dc3be-0780-11eb-237a-3b491dae9c4d
# ╟─e636ee20-0780-11eb-0239-4b58bcae19b7
# ╠═0384269e-0781-11eb-17a5-7fa7f4db431d
# ╠═069adc80-0781-11eb-1aad-abb11200e9cf
# ╠═60250140-0a88-11eb-1d92-99f3cc279e4a
# ╠═0e94cae0-0781-11eb-006e-f1e951667e43
# ╟─18e37eb0-0781-11eb-19c7-b3b0a548e5bf
# ╠═384f0350-0781-11eb-109f-0339f1e31e21
# ╠═42e08c80-0781-11eb-0dc9-e74d7639d4a4
# ╠═4be9ef10-0781-11eb-1831-e12b5845af42
# ╠═5c390b30-0781-11eb-19c9-8de114d2397e
# ╟─878c8140-0781-11eb-13b2-d36ec8329a48
# ╠═7c333b42-0781-11eb-0199-bd5a50e2a2d5
# ╠═c17a3780-0781-11eb-386e-83e5c931cc31
# ╟─ccc704f0-0782-11eb-1b75-8ddfd5ffb33d
# ╟─ce804320-0781-11eb-2b48-9927b05e5bdc
# ╠═fadb8c40-0781-11eb-297e-4db03c0d521b
# ╟─48ae1310-0783-11eb-2d09-6b00cca36f26
# ╠═3f301cc0-0783-11eb-092a-918535d1bd1c
# ╟─48af1ab0-0a87-11eb-224c-d389ecb189e9
# ╟─3d8967d0-0a87-11eb-3d2c-8b15d9e77e12
# ╠═5f9030be-0a87-11eb-2035-6d60b017c3c3
# ╠═8fb3fd60-0783-11eb-2f7e-912b2637b908
# ╟─aa2f2a20-0783-11eb-1969-3d44dd557c93
# ╠═e98fd5c0-0783-11eb-0719-8385ba04dcd7
# ╠═efd73220-0783-11eb-06aa-c775f6fb89d7
# ╟─fc730a40-0783-11eb-2bd0-cb2cc7c9f987
# ╟─350a7f4e-0784-11eb-1fa5-17cbd9d193c2
# ╠═31b95880-0784-11eb-39f1-332b4ebb8d2a
# ╟─658318e0-0784-11eb-1a47-f7c46d6cb10c
# ╟─cc62b2f0-0784-11eb-3c99-01342dc67e7d
# ╠═acd1f310-0784-11eb-2e4f-7d2da86dbee0
# ╟─b9ced6f0-0784-11eb-0f57-5999bd3df9e2
# ╠═0590fee0-0787-11eb-2359-21c3bad35e43
# ╠═99274452-078e-11eb-1d23-3528c7bbfe1b
# ╠═0ecedef0-0787-11eb-1006-f5e89a94559f
# ╠═08aec432-0788-11eb-209d-017d9bc569e9
# ╠═2fbe1600-078a-11eb-17b5-bf277495fd9f
# ╠═3397f4d0-078a-11eb-34b4-d534d90322b0
# ╠═2e137340-078a-11eb-2020-a99eb75e14fb
# ╠═4fe856c0-078a-11eb-1f87-03f36f56e416
# ╠═4dc82700-0918-11eb-1d2c-7728dad5b2f9
# ╠═5504045e-078a-11eb-1287-79f40457f8cb
# ╠═6230d1e0-078a-11eb-1c2a-ebd4cf7299f9
# ╠═6aac7360-078a-11eb-0cee-e5780438eb5e
# ╠═77f37fa2-078a-11eb-130e-43348967a008
# ╠═7c2d31b2-078a-11eb-1ddc-e547ad6cef98
# ╠═b3b384e0-078a-11eb-02e1-d98d80d9c457
# ╠═ba511790-078a-11eb-0d2c-451cc28851cd
# ╠═c58c2730-078a-11eb-07c3-db5c4848e151
# ╠═ca169150-078a-11eb-2532-472d16f3fb43
# ╠═cdb95a90-078a-11eb-1f63-4be59b019e55
# ╟─7d23aab8-1cf5-440b-9a43-b1ef2b15a586
# ╠═de5cd6f0-5907-45f1-b7b2-fd70dc4debe9
