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

# ╔═╡ 5e7ec050-3ef1-4f7a-bc9c-45f3432970cc
begin 
	using Pkg
	Pkg.activate("../.")
	using PlutoUI
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

# ╔═╡ f3d093c0-076b-11eb-21bc-d752119bd59f
begin
	md"""
	# Scientific Computing Tools and Visualizations
	AA120Q: *Building Trust in Autonomy*

	## Readings/Videos/References
	- [`Pkg` Documentation](https://docs.julialang.org/en/v1/stdlib/Pkg/)
	- [`Plots.jl` Documentation](https://docs.juliaplots.org/stable/)
	- [`DataFrames.jl` Documentation](https://dataframes.juliadata.org/stable/)
	- [`Distributions.jl` Documentation](https://juliastats.org/Distributions.jl/stable/)
	- [Decision Making Under Uncertainty, Chapter 2.1, Probabilistic Models](https://ieeexplore.ieee.org/document/7288676)
	"""
end

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

Julia offers a wide range of [official packages]( https://juliahub.com/ui/Packages). There are many custom packages that are not in the official listing as well.

You can go to a package's documentation, typically from Github, to view all of its features.

Some of the packages we will be using are:
- DataFrames
- Distributions
- Discretizers
- Plots
- Colors
- Symbolics
"""

# ╔═╡ 46be8b02-0776-11eb-0a40-b1de3001c2fa
md"""
## DataFrames
"""

# ╔═╡ dd115c90-0776-11eb-2a5a-a7a9e12e0b85
df = DataFrame(
    timestamp = 1:5,
    position_x = [0.0, 1.1, 2.3, 3.2, 4.1],
    position_y = [0.0, 0.3, 0.5, 0.4, 0.6],
    velocity = [0.0, 1.1, 1.2, 0.9, 1.0],
	obstacle_detected = [false, false, true, true, false]
)

# ╔═╡ ff2a26e0-0776-11eb-1543-5b0a27c2eeb9
df[2, :position_x] # By index and column name

# ╔═╡ 03025800-0777-11eb-061c-1749664edcaf
df[2, 2] # By index only

# ╔═╡ 053eb370-0777-11eb-2ae5-f7e866357a0f
df[!, :obstacle_detected] # All entries in a column

# ╔═╡ 995fd97e-8b73-467a-8df1-382f6cfc99c5
df.obstacle_detected # Another way to get all entries in a column

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
speed_edges = [0.0, 5.0, 10.0, 15.0, 20.0, 25.0]

# ╔═╡ 1d4d7a70-077f-11eb-3752-5d42c826d823
lineardisc = LinearDiscretizer(speed_edges)

# ╔═╡ 54990e90-077f-11eb-20a0-bbdba8de08a4
md"""
###### Encoding
"""

# ╔═╡ 29a67d30-077f-11eb-1bb1-2f5998f4a8bf
encode(lineardisc, 17.3)

# ╔═╡ 48855230-077f-11eb-0cc7-e1b3f68c4bbc
encode(lineardisc, 1.2)

# ╔═╡ 49ffbd32-077f-11eb-159e-ef3ca084c9e6
encode(lineardisc, 120.0)

# ╔═╡ 4ae3dba0-077f-11eb-3b1e-79a6d52114ac
encode(lineardisc, [17.3, 1.2, 120.0])

# ╔═╡ 5382e3a0-077f-11eb-324b-7f1eae0f0e3e
md"""
###### Decoding
"""

# ╔═╡ bff436a1-75f3-41d3-8f9f-8e561d307b54
md"""
As a default, `decode` for a `::LinearDiscretizer` uniformly samples from the bins. Another option is to return the bin center and you can decode using this method by passing `SampleBinCenter()` to `decode`.
"""

# ╔═╡ 6242d440-077f-11eb-09c2-7d637f3be52d
decode(lineardisc, 1)

# ╔═╡ 680e22d0-077f-11eb-2639-67723187c19f
decode(lineardisc, 2)

# ╔═╡ 6accf4b0-077f-11eb-1408-7b86c51641cf
decode(lineardisc, [2, 1, 2])

# ╔═╡ 343f22a7-92ef-4389-bff9-579ace34c97a
decode(lineardisc, 1, SampleBinCenter())

# ╔═╡ 332596d0-e62e-4e1a-b26c-216d189b394d
decode(lineardisc, 2, SampleBinCenter())

# ╔═╡ 7d52aea4-4d12-409a-bb7d-9e0b616b7c10
decode(lineardisc, [2, 1, 2, 4, 5], SampleBinCenter())

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
plotlyjs() # one of many different backends

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

# ╔═╡ 48ae1310-0783-11eb-2d09-6b00cca36f26
md"""
!!! note 
	You can use underscores within numbers as separators for human-readability. E.g. 10_000 is the same as 10000.
"""

# ╔═╡ 3f301cc0-0783-11eb-092a-918535d1bd1c
histogram2d(randn(10_000), randn(10_000), bins=20, c=:viridis, showempty=true)

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

# ╔═╡ 350a7f4e-0784-11eb-1fa5-17cbd9d193c2
md" $\uparrow$ unhide the above cell to see how these sliders work."

# ╔═╡ cc62b2f0-0784-11eb-3c99-01342dc67e7d
md"""
You can use `RGB` with plots as well (try changing this to use `r`, `g`, and `b` bound to sliders from above).
"""

# ╔═╡ acd1f310-0784-11eb-2e4f-7d2da86dbee0
plot(x->sin(x^2), 0, π, line=2, color=RGB(0.75, 0, 0.5))

# ╔═╡ 6de2d1be-124c-45f8-b7b4-e866100bf56b
md"""
## Statistcal Models
"""

# ╔═╡ 6296fddf-92f9-4107-b74b-81f1b5480f53
md"""
### Piecewise Constant Distributions
"""

# ╔═╡ f6fa805e-451b-4b3e-ab53-87253ff8e56e
md"""
A normal distribution with mean 3 and standard deviation 2.
"""

# ╔═╡ 5fd3d217-09d0-4b98-9b7e-5cae1689bf96
normal_dist = Normal(3, 2)

# ╔═╡ f42a9e79-9a74-43d6-867b-2e5c8ec71395
md"""
Generate 1000 samples.
"""

# ╔═╡ 9858284d-7f31-4b4b-a5a2-4607b91e4f68
normaldata = rand(normal_dist, 1000)

# ╔═╡ 0df8db0a-400f-459c-a5bb-9a4f8d827656
binlengths = [3 10 50 1000]

# ╔═╡ 654bcf1e-0392-4b33-bf24-3d63b48d5e71
histogram(fill(normaldata, 4),
	      bins=binlengths,
	      label=binlengths,
	      layout=@layout([a b; c d]))

# ╔═╡ 45c292b5-7d7e-460b-9de3-e220e41cb5a4
md"""
These plots are not of densities (they do not integrate to $1$).
"""

# ╔═╡ 50fb398f-bb65-4bd5-8224-274cb38adcd8
md"""
### Mixture Model
This example will focus on Gaussian mixture components, but the code can support components from other distributions.
"""

# ╔═╡ a08e3a50-0eaa-4cbf-82ed-2ff8d7c50801
md"""
# Backend
_Helper functions and project management. Please do not edit._
"""

# ╔═╡ de5cd6f0-5907-45f1-b7b2-fd70dc4debe9
PlutoUI.TableOfContents()

# ╔═╡ a571e201-8ce2-4d6b-9ca6-7860a10eae4e
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

# ╔═╡ ccc704f0-0782-11eb-1b75-8ddfd5ffb33d
md"Control the mean: $(@bind μ Slider(-5:0.5:5, default=0, show_value=true))"

# ╔═╡ ce804320-0781-11eb-2b48-9927b05e5bdc
md"Control the standard deviation: $(@bind σ Slider(0.2:0.2:5, default=1, show_value=true))"

# ╔═╡ fadb8c40-0781-11eb-297e-4db03c0d521b
histogram(μ .+ σ*randn(1000), bins=20); xlims!(-15, 15); ylims!(0, 250)

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

# ╔═╡ fc730a40-0783-11eb-2bd0-cb2cc7c9f987
md"""
Red: $(@bind r Slider(0:0.01:1))
Green: $(@bind g Slider(0:0.01:1))
Blue: $(@bind b Slider(0:0.01:1))
"""

# ╔═╡ efd73220-0783-11eb-06aa-c775f6fb89d7
RGB(r, g, b)

# ╔═╡ 658318e0-0784-11eb-1a47-f7c46d6cb10c
md"""
Hue: $(@bind h Slider(0:360))
Saturation: $(@bind s Slider(0:0.01:1, default=0.5))
Value (i.e. brightness): $(@bind v Slider(0:0.01:1, default=0.5))
"""

# ╔═╡ 31b95880-0784-11eb-39f1-332b4ebb8d2a
HSV(h, s, v)

# ╔═╡ 5c9a748f-a87b-4f27-9ba6-ee8dce49259c
md"""
μ₁: $(@bind μ₁ Slider(-10:0.1:10; default=-3, show_value=true)) σ₁: $(@bind σ₁ Slider(0:0.1:5; default=1, show_value=true))

μ₂: $(@bind μ₂ Slider(-10:0.1:10; default=4, show_value=true)) σ₂: $(@bind σ₂ Slider(0:0.1:5; default=2, show_value=true))

w₁: $(@bind w₁ Slider(0.0:0.1:1.0; default=0.8, show_value=true)) 1-w₁: $(1-w₁)
"""

# ╔═╡ 07ff7471-a164-4f93-8a9a-5736ef825227
mixture = MixtureModel([Normal(μ₁,σ₁), Normal(μ₂,σ₂)], [w₁, 1-w₁])

# ╔═╡ ae9c77dc-3058-446d-9b9a-c29f6d6282e4
mixdata = rand(mixture, 1000);

# ╔═╡ 7ea7ab10-c24f-4498-afb2-7c76a1508fa3
histogram(mixdata, bins=50, ylabel="Counts", size=(650,300), xlim=(-15,15))

# ╔═╡ 7d23aab8-1cf5-440b-9a43-b1ef2b15a586
html_half_space()

# ╔═╡ 4ee2c5fe-e65d-479b-8d1b-fdbcf6fbe78f
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
# ╟─f3d093c0-076b-11eb-21bc-d752119bd59f
# ╟─5e7ec050-3ef1-4f7a-bc9c-45f3432970cc
# ╟─6536e190-076c-11eb-3c75-7f594ba1ab24
# ╟─46be8b02-0776-11eb-0a40-b1de3001c2fa
# ╠═db7cd9e0-0776-11eb-1cd5-d582a6dcfcdd
# ╠═dd115c90-0776-11eb-2a5a-a7a9e12e0b85
# ╠═ff2a26e0-0776-11eb-1543-5b0a27c2eeb9
# ╠═03025800-0777-11eb-061c-1749664edcaf
# ╠═053eb370-0777-11eb-2ae5-f7e866357a0f
# ╠═995fd97e-8b73-467a-8df1-382f6cfc99c5
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
# ╟─bff436a1-75f3-41d3-8f9f-8e561d307b54
# ╠═6242d440-077f-11eb-09c2-7d637f3be52d
# ╠═680e22d0-077f-11eb-2639-67723187c19f
# ╠═6accf4b0-077f-11eb-1408-7b86c51641cf
# ╠═343f22a7-92ef-4389-bff9-579ace34c97a
# ╠═332596d0-e62e-4e1a-b26c-216d189b394d
# ╠═7d52aea4-4d12-409a-bb7d-9e0b616b7c10
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
# ╟─efd73220-0783-11eb-06aa-c775f6fb89d7
# ╟─fc730a40-0783-11eb-2bd0-cb2cc7c9f987
# ╟─350a7f4e-0784-11eb-1fa5-17cbd9d193c2
# ╠═31b95880-0784-11eb-39f1-332b4ebb8d2a
# ╟─658318e0-0784-11eb-1a47-f7c46d6cb10c
# ╟─cc62b2f0-0784-11eb-3c99-01342dc67e7d
# ╠═acd1f310-0784-11eb-2e4f-7d2da86dbee0
# ╟─6de2d1be-124c-45f8-b7b4-e866100bf56b
# ╟─6296fddf-92f9-4107-b74b-81f1b5480f53
# ╟─f6fa805e-451b-4b3e-ab53-87253ff8e56e
# ╟─5fd3d217-09d0-4b98-9b7e-5cae1689bf96
# ╟─f42a9e79-9a74-43d6-867b-2e5c8ec71395
# ╠═9858284d-7f31-4b4b-a5a2-4607b91e4f68
# ╠═0df8db0a-400f-459c-a5bb-9a4f8d827656
# ╠═654bcf1e-0392-4b33-bf24-3d63b48d5e71
# ╟─45c292b5-7d7e-460b-9de3-e220e41cb5a4
# ╟─50fb398f-bb65-4bd5-8224-274cb38adcd8
# ╠═07ff7471-a164-4f93-8a9a-5736ef825227
# ╟─5c9a748f-a87b-4f27-9ba6-ee8dce49259c
# ╠═ae9c77dc-3058-446d-9b9a-c29f6d6282e4
# ╟─7ea7ab10-c24f-4498-afb2-7c76a1508fa3
# ╟─7d23aab8-1cf5-440b-9a43-b1ef2b15a586
# ╟─a08e3a50-0eaa-4cbf-82ed-2ff8d7c50801
# ╟─de5cd6f0-5907-45f1-b7b2-fd70dc4debe9
# ╟─a571e201-8ce2-4d6b-9ca6-7860a10eae4e
# ╟─4ee2c5fe-e65d-479b-8d1b-fdbcf6fbe78f
