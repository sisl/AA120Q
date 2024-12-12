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

# ╔═╡ 436036d3-cfdf-40cf-86dc-5d3c91b86d05
begin
	using Pkg
	Pkg.activate("../.") # Activate AA120Q project
	using PlutoUI # For use of @bind
end

# ╔═╡ a661329d-af9d-4ada-ac4d-fec68a76b393
begin 
	Pkg.activate("../.")
	Pkg.status() # View the downloaded packages and versions
end

# ╔═╡ d50862fe-4e9d-4dd8-9278-1f935ace223b
using Printf

# ╔═╡ f1a3a270-073b-11eb-1741-37897aa84974
begin	
	md"""
	# Julia and Pluto
	AA120Q: *Building Trust in Autonomy*

	## Readings/Videos/References
	
	Readings/Videos:
	- [Julia Documentation](https://docs.julialang.org/en/v1/)
	- [A Brief Introduction to Julia (video)](https://www.youtube.com/watch?v=X4Alzh3QyWU)

	Pluto Wiki:
	- [Choosing Pluto.jl](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%92%A1-Choosing-Pluto.jl)
	- [Pluto UI](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%92%BB--UI)
	- [Writing and running code](https://github.com/fonsp/Pluto.jl/wiki/%E2%9A%A1-Writing-and-running-code)
	- [Basic Commands in Pluto](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%94%8E-Basic-Commands-in-Pluto)
	"""
end

# ╔═╡ 6efb1630-074c-11eb-3186-b3ea3cc6d33b
md"""
# Pluto
Pluto, like Jupyter, is a notebook-style environment. We recommend this engaging presentation for a nice introduction: [https://www.youtube.com/watch?v=IAF8DjrQSSk](https://www.youtube.com/watch?v=IAF8DjrQSSk). **We will be using Pluto for the coding lectures and homework.**

1. Output of a cell is above the code (unlike Jupyter notebooks)
1. Changing a variable in one cell affects other dependent cells (interactive)
1. You cannot redefine a variable or function in a separate cell (due to \#2)
1. Cells contain a single piece of code, or can be wrapped in `begin` `end` blocks
		begin
			# code goes here
		end
5. You can bind interactive objects like sliders to variables using `PlutoUI`
"""

# ╔═╡ 433a69f0-074d-11eb-0698-f9113d9939c3
@bind var Slider(1:10, default=5, show_value=true)

# ╔═╡ 4a4f2872-074d-11eb-0ec8-13783b11ffd7
var^3

# ╔═╡ 991297c0-0776-11eb-082c-e57372352faa
md"""
# Quick Introduction to Julia

![](https://julialang.org/assets/infra/logo.svg)


Julia is a high-level dynamic programming language$^{[\href{https://en.wikipedia.org/wiki/Julia_(programming_language)}{2}]}$ that was designed to solve the two-language problem.

**Two language problem.**$\;\;$One typically uses a high-level language like MATLAB to do scientific computing and create prototypes, but a low-level language like C to implement resulting solutions.

Julia is both fast and easy to prototype in, and supports a wide range of features such as a built-in package manager (so reproducing someone's exact development environment can be done for verification purposes), distributed computing, C and Python interfaces, a powerful REPL (command line, stands for Read, Eval, Print, Loop), and an elegant type system.

The following examples are based on [Learn X in Y Minutes](http://learnxinyminutes.com/docs/julia/). Assumes Julia `v1.11`.

> Note, the output of code is *above* each cell in Pluto notebooks.
"""

# ╔═╡ 50caeb00-073c-11eb-36ac-5b8839bb70ab
md"""
## Types

These are different types of numbers.
"""

# ╔═╡ 5996f670-073c-11eb-3a63-67246e676f4e
typeof("hello world")

# ╔═╡ 5fe5f3f0-073c-11eb-33ae-2343a63d952d
typeof(1)

# ╔═╡ 62961fce-073c-11eb-315e-03a405d69157
typeof(1.0)

# ╔═╡ 8ca1d3a0-073c-11eb-2d51-7766203bdf92
supertype(Float64)

# ╔═╡ 90e6d04e-073c-11eb-0a64-a5596e6b6079
supertype(AbstractFloat)

# ╔═╡ 9516be60-073c-11eb-277b-b59f20b2feba
supertype(Real)

# ╔═╡ 9895d300-073c-11eb-1fe4-d3337747efcd
supertype(Number)

# ╔═╡ 9be413a0-073c-11eb-3c73-df78ea75bcd1
supertype(Int64)

# ╔═╡ a10c4462-073c-11eb-31f8-6f675614356d
supertype(Signed)

# ╔═╡ a4de820e-073c-11eb-374e-efd08bbc884c
supertype(Integer)

# ╔═╡ ae65ee42-073c-11eb-1dbd-eb918f086ab7
typeof(true)

# ╔═╡ b4ad4aa0-073c-11eb-238e-a913116c0944
md"""
## Boolean Operators

Negation is done with `!`
"""

# ╔═╡ bf0155a2-073c-11eb-1ff2-e9d78baf273a
!true

# ╔═╡ c22997b0-073c-11eb-31c8-952711ee4422
1 == 1

# ╔═╡ c393d612-073c-11eb-071d-93ca1d801f4d
1 != 1

# ╔═╡ c59412e0-073c-11eb-0b89-7d14cda40917
1 > 2 || 4 < 5 # or

# ╔═╡ cd146470-073c-11eb-131c-250b433dbe74
1 > 2 && 4 < 5 # and

# ╔═╡ d5dc2a20-073c-11eb-1667-038dd7a06c63
md"""
Comparisons can be chains. This is equivalent to `1 < 2 && 2 < 3`
"""

# ╔═╡ e05151b0-073c-11eb-2cd2-75f9f350b266
1 < 2 < 3

# ╔═╡ e3846930-073c-11eb-384a-b1b2e27d16cc
md"""
## Strings
Use double quotes for strings.
"""

# ╔═╡ ef0693f0-073c-11eb-14da-0bec0f5bfe2e
"This is a string"

# ╔═╡ f131d862-073c-11eb-0584-1947b568926c
typeof("This is a string")

# ╔═╡ f5e1a4d0-073c-11eb-0002-d94d6a932b0b
md"""
**Characters.**$\;$ Use single quotes for characters.
"""

# ╔═╡ 004e40e0-073d-11eb-1475-5dea9854afd4
'a'

# ╔═╡ 781dcaf0-073d-11eb-2498-0f3bdb572f88
typeof('a')

# ╔═╡ 80309880-073d-11eb-10d0-53a70045661f
md"""
Note the 1-based indexing---similar to MATLAB but unlike C/C++/Java/Python.
"""

# ╔═╡ 7a9cd4ae-073d-11eb-1c20-f1a0bc572b33
"This is a string"[1]

# ╔═╡ db37f460-0744-11eb-24b0-cb3767f0cf44
"This is a string"[end]

# ╔═╡ 8ea1a5d0-073d-11eb-029b-01b0401da847
md"""
`$` can be using for "string interpolation".
"""

# ╔═╡ 993a33e0-073d-11eb-2ded-4fc896fd19d7
"2 + 2 = $(2+2)"

# ╔═╡ f99743b0-0745-11eb-049e-71c7b72884d1
md"""
## Printing
In Pluto, the last expression is output by default. The use of `print` and `println` will output the result to stdout and it will appear *below* the cell.
"""

# ╔═╡ fbaad713-216b-4557-8132-3a1e95ed0a27
md"""
In the following block, notice only the last expression is output (i.e. sin(π))

*Note: To use multiple lines of code in a single cell, we need to use `begin` ... `end` blocks.*
"""

# ╔═╡ 4a2f40a4-029f-43bb-9f55-3bf001861d0c
begin
	cos(π)
	sin(π)
end

# ╔═╡ d3d5cde4-8d81-45b1-8554-4ee2e009074c
md"""
If we want more outputs, we can add `println` statements or use logging (e.g. `@info`).
"""

# ╔═╡ efa419b0-40ce-41ac-a660-5bd1743b0e6c
begin
	println("cos(π) = ", cos(π))
	println("sin(π) = ", sin(π))
end

# ╔═╡ bc755cd7-40ca-4ad6-9f88-8ff657e4e397
begin
	@info "cos(π)" cos(π)
	@info "sin(π)" sin(π)
end

# ╔═╡ a0ffcbd0-073d-11eb-3c0a-bfc967428073
print(4.5, " is less than ", 5.3)

# ╔═╡ 4968e820-0742-11eb-1b1b-034751f95fb9
println("Welcome to Julia!")

# ╔═╡ c5c2e4a7-6a4f-4d06-9cc5-0011dafbffe3
md"""
You can also use `printf` statements with the `Printf` package
"""

# ╔═╡ b1ed3fa0-b885-48be-9332-653623d4b606
@printf("%.2f is less than %.2f", 4.5, 5.3)

# ╔═╡ 62c9ce6e-0746-11eb-0911-afc23d8b351c
md"""
## Variables
"""

# ╔═╡ 64f36530-0746-11eb-3c66-59091a9c7d7d
v = 5

# ╔═╡ 66335f40-0746-11eb-2f7e-ffe20c76f21f
md"""
Variable names start with a letter, but after that you can use letters, digits, underscores, and exclamation points.
"""

# ╔═╡ 71dc24d0-0746-11eb-1eac-adcbb393c38b
xMarksTheSpot_2Dig! = 1

# ╔═╡ 765e5190-0746-11eb-318e-8954e5e8fa3e
md"""
It is Julian to use lowercase with underscores for variable names.
"""

# ╔═╡ 81956990-0746-11eb-2ca4-63ba1d192b97
x_marks_the_spot_to_dig = 1

# ╔═╡ 85101160-0746-11eb-1501-3101c2006157
md"""
## Arrays
"""

# ╔═╡ 97a54cf0-0746-11eb-391d-d70312796ded
A = Int64[]

# ╔═╡ 9a808070-0746-11eb-05cf-81547eab646d
B = [4, 5, 6]

# ╔═╡ 9d560e9e-0746-11eb-1e55-55e827e7423d
B[1]

# ╔═╡ 9f1264a0-0746-11eb-2554-1f50ba874f57
B[end-1]

# ╔═╡ a2283020-0746-11eb-341a-fb4e280be5d6
matrix = [1 2; 3 4; 5 6]

# ╔═╡ a9ea93c0-0746-11eb-0956-95d12cb066ac
A

# ╔═╡ bc8dd90e-0746-11eb-3c30-1b27e08fd17d
push!(A, 1)

# ╔═╡ ad279650-0746-11eb-2090-81a679e5f3be
push!(A, 2)

# ╔═╡ b1266240-0746-11eb-262c-893974d49c9f
append!(A, B)

# ╔═╡ b5a1b130-0746-11eb-2038-d353aad7e355
A

# ╔═╡ c4f7ee60-0746-11eb-324b-854c3b2e383e
pop!(A)

# ╔═╡ c7484700-0746-11eb-3327-f321a4423d2a
A

# ╔═╡ cb5d3300-0746-11eb-35d3-33280e451394
A[2:4]

# ╔═╡ cd941030-0746-11eb-34d7-216aa0f8f33d
A[2:end]

# ╔═╡ d6663620-0746-11eb-01dc-27b5e3b11ab8
A[2:end-1]

# ╔═╡ da28e370-0746-11eb-1ea1-91664661a74d
push!(A, round(Int64, 1.3))

# ╔═╡ df66e620-0746-11eb-37b9-d3f3ab3dd12f
in(4, A)

# ╔═╡ e3e171c0-0746-11eb-0e1d-c3fc24347d47
4 in A

# ╔═╡ e99fa0f0-0746-11eb-1f5c-7da5d6765131
md"""
You can use $\LaTeX$ keyworks to get unicode characters.
> **Example**: `\in` then hit `<TAB>`.
"""

# ╔═╡ e5afc920-0746-11eb-0558-79599697bec6
4 ∈ A

# ╔═╡ e8dc9f10-0746-11eb-2c56-c9383000043c
!in(4, A)

# ╔═╡ 1b239000-0747-11eb-0a63-d9e58c6dfda3
4 ∉ A # \notin

# ╔═╡ 24b05360-0747-11eb-0783-ab42074819c4
length(A)

# ╔═╡ 410c4e10-0747-11eb-0acf-116ff6073047
md"""
## Tuples
Think of them as immutable arrays.
"""

# ╔═╡ 4842ec70-0747-11eb-37b0-21da3d5049ff
T = (1, 5.4, "hello")

# ╔═╡ 7351b860-0747-11eb-16c5-833309f7fbcb
typeof(T)

# ╔═╡ 750c87c0-0747-11eb-1aeb-d32e03b686f5
T[2]

# ╔═╡ 7f9e37fe-0747-11eb-295e-6d55a31d8395
html"""
This line below gets an <font color='darkred'><b>error</b></font> message. Tuple elements cannot change because they are <i>immutable</i>.
"""

# ╔═╡ 77cd074e-0747-11eb-0306-05ff0e6ada53
T[2] = 3 # can't change elements in a tuple, they are immutable

# ╔═╡ 88232852-0747-11eb-289d-1742e687b041
a, b, c = (1, 2, 3) # you can split out the contents

# ╔═╡ 3589dfc0-0748-11eb-1b7f-672e2f6dcf53
a

# ╔═╡ 48a9a810-0748-11eb-0b15-e9085ebd7b52
b

# ╔═╡ 49c63ba0-0748-11eb-158d-57dcd4ad537d
c

# ╔═╡ 4a742ee0-0748-11eb-364c-f7eb2b89d88a
x, y, z = 1, 2, 3

# ╔═╡ 64a33770-0748-11eb-1221-b994ffb70091
x

# ╔═╡ 668d060e-0748-11eb-0f34-f307c94e755d
y

# ╔═╡ 6722dd70-0748-11eb-31b7-d38b56f4cc0f
z

# ╔═╡ 7226fe92-0748-11eb-215e-49075766b2da
md"""
To create a single-element tuple, you must add the "," at the end
"""

# ╔═╡ 5bfd2a90-0748-11eb-3b5c-8f191bd23f1c
(1,)

# ╔═╡ 7f8e8b20-0748-11eb-39da-435f6c49934a
typeof((1,))

# ╔═╡ 84d7d870-0748-11eb-2a11-5797476719b5
md"""
## Dictionaries
Dictionaries let you map `keys` to `values`.
"""

# ╔═╡ 8dc1a510-0748-11eb-1e2d-ab6fc445d549
dict = Dict()

# ╔═╡ 90afc450-0748-11eb-170e-9fd33246ec06
d = Dict("one"=>1, "two"=>2, "three"=>3)

# ╔═╡ a28f9290-0748-11eb-0e3a-539a124905c0
d["one"]

# ╔═╡ a6f27780-0748-11eb-2ca3-69c3f2923f7e
keys(d)

# ╔═╡ a8c3b510-0748-11eb-39b2-7389d0ee67e4
collect(keys(d))

# ╔═╡ ac35d160-0748-11eb-00c4-e799f1c83746
values(d)

# ╔═╡ b137dc80-0748-11eb-3e3b-d9eb6ade524c
haskey(d, "one")

# ╔═╡ b47d6a92-0748-11eb-1a5c-fb5faaf20c14
haskey(d, 1)

# ╔═╡ bb233aa0-0748-11eb-3488-8d316224bdf8
md"""
## Control Flow
`if` statements, `for` loops, `while` loops, and error catching
"""

# ╔═╡ d2ec8dd0-0748-11eb-298a-5d94d5da2477
some_var = 5

# ╔═╡ db2d2220-0748-11eb-0889-a30e49f2d784
md"""
Here is an `if` statement. Indentation does *not* have a special meaning in Julia..
"""

# ╔═╡ e891a170-0748-11eb-2bbd-e15baa27423c
begin
	if some_var > 10
		println("some_var is totally bigger than 10.")
	elseif some_var < 10 # This elseif clause is optional.
		println("some_var is smaller than 10.")
	else # this else clause is also optional too.
		println("some_var is indeed 10.")
	end
end

# ╔═╡ 2f09cab2-0749-11eb-3533-79dae3c99545
md"""
`for` loops and `while` loops iterate over an iterable. Iterable types include `Range`, `Array`, `Set`, `Dict`, and `String`.
"""

# ╔═╡ 204a7650-0749-11eb-3bcf-2d2846eb951b
begin
	for animal in ["dog", "cat", "mouse"]
		println("$animal is a mammal")
	end
end

# ╔═╡ 50260c90-0749-11eb-0af7-8fa4ca5e3890
begin
	for (key, value) in Dict("dog"=>"mammal", "cat"=>"mammal", "sparrow"=>"bird")
		println("$key is a $value")
	end
end

# ╔═╡ 69c88c90-0749-11eb-1c23-a5f0042bf2de
begin
	s = 0
	while s < 4
		println(s)
		s += 1 # shorthand for s = s + 1
	end
end

# ╔═╡ fef5c85a-8536-42aa-b169-4b5ccab6e6bd
md"""
We can also handle errors and execute additional code after catching the error.
"""

# ╔═╡ 870a7a70-0749-11eb-2ab1-e9279dd4642a
begin
	try
		error("help!")
		println("We do not make it here after the error.")
	catch err
		println("Caught the error! $err")
		println("We do continue in this block after catching an error")
	end
end

# ╔═╡ 9ef92ff2-0749-11eb-119e-35edd2a409c4
md"""
## Functions
"""

# ╔═╡ c3ac5430-0749-11eb-13f0-cde5ec9409cb
md"""
Functions return the value of their last statement (or where you specify `return`)
"""

# ╔═╡ a12781a0-0749-11eb-0019-3154576cfbc5
function add(x, y)
	println("x is $x and y is $y")
	x + y
end

# ╔═╡ 514268b6-e65c-4ba7-b009-c0398e31c890
md"""
In the next block, you'll notice the result of the function's `return` (i.e., `x + y`) displayed above, as per Pluto's usual behavior, and the output of the `println` statement echoed below. 

By default, Julia returns the value of the last expression in a function if the `return` keyword is omitted.
"""

# ╔═╡ ba349f70-0749-11eb-3a4a-294a8c484463
add(5, 6)

# ╔═╡ d6c45450-0749-11eb-3a9c-41cbc41c8d08
md"""
You can define functions with optional positional arguments.
"""

# ╔═╡ dedb4090-0749-11eb-38f4-7dffd22ae8c5
function defaults(a, b, x=5, y=6)
	return "$a $b and $x $y"
end

# ╔═╡ e9fd49f0-0749-11eb-3cf6-b78a95067ee3
defaults('h', 'g')

# ╔═╡ f1339a30-0749-11eb-0fcb-21c6e9917eb9
defaults('h', 'g', 'j')

# ╔═╡ f6631df0-0749-11eb-111d-270176d2bd76
defaults('h', 'g', 'j', 'k')

# ╔═╡ f81b0720-0749-11eb-2217-9dd2714570b3
md"""
You can define functions that take keyword arguments using `;` to separate the variables.
"""

# ╔═╡ 06186b12-074a-11eb-2ff8-d7ecf3b88f3b
function keyword_args(; k1=4, name2="hello")
	return Dict("k1"=>k1, name2=>name2)
end

# ╔═╡ 1ae6cdc0-074a-11eb-2415-710522e2ff61
keyword_args(name2="ness")

# ╔═╡ 1f2031b0-074a-11eb-2f30-43fa1403837e
keyword_args(k1="mine")

# ╔═╡ 2547f820-074a-11eb-2aa5-ffe306f6b1e2
keyword_args()

# ╔═╡ 28c44da0-074a-11eb-07cf-21435e264c3b
md"""
This is "stabby lambda syntax" for creating anonymous functions.
"""

# ╔═╡ 39c7ecb0-074a-11eb-0f6a-59d57a454722
f = x -> x > 2

# ╔═╡ 40e16622-074a-11eb-1f0d-579043dff6df
f(3)

# ╔═╡ 71088c86-7253-4b0b-b5eb-86533ca98db1
md"""
Another way of defining that a function without using the `function` keyword.
"""

# ╔═╡ 2fa63331-2634-48da-9981-4a34b81c5ba1
f_alternative(x) = x > 2

# ╔═╡ 2190f793-1b12-4727-b615-6df13dbd40f9
f_alternative(3)

# ╔═╡ 4602b910-074a-11eb-3b77-dd28974218f6
md"""
This function creates `add` functions. When we call `create_adder` a function is new function is returned.
"""

# ╔═╡ 4e6b95e0-074a-11eb-324c-09c41dd1fb64
function create_adder(x)
	y -> x + y
end

# ╔═╡ 55249fd0-074a-11eb-1df3-2bfaa49155ae
md"""
You can also name the internal function, if you want.
"""

# ╔═╡ 60e50c10-074a-11eb-0249-339b5ee9bcf2
function create_adder2(x)
	function adder(x)
		x + y
	end
	adder
end

# ╔═╡ 6cc00530-074a-11eb-08da-5f69fb9e6c08
add10 = create_adder(10)

# ╔═╡ 72681450-074a-11eb-2182-9ba3de8ae5c7
add10(3)

# ╔═╡ 89e51c40-074a-11eb-199f-79a721854c1f
[add10(i) for i in [1, 2, 3]]

# ╔═╡ f1055123-309a-4ee1-aa48-204eb0308b8f
md"""
Functions like `map` and `filter` allow us to apply operations to iterables efficiently.
"""

# ╔═╡ fd41492e-9a13-47d1-8f9f-b55edf4a93f3
map(add10, [1, 2, 3])

# ╔═╡ 4e2c0e4a-64be-4bf6-972a-3f4b1d236fb2
filter(x -> x > 5, [3, 4, 5, 6, 7])

# ╔═╡ 90db2f30-074a-11eb-2990-112df2b43ff3
md"""
## Composite Types

Composite types are user-defined data structures that play a crucial role in enabling multiple dispatch in Julia.
"""

# ╔═╡ 28c3d9f6-8666-44fa-b536-7c05149630eb
struct VehicleState
	position::Vector{Float64}
	velocity::Vector{Float64}
	heading::Float64
	timestamp::Float64
end

# ╔═╡ 755f8671-9076-4f4f-bbbf-1bd214a2d0a9
car_one = VehicleState([0.0, 0.0], [1.0, 0.0], 0.0, 0.0)

# ╔═╡ 6ed95d98-7d68-41a3-9b01-1fee030138cc
car_one.heading # access type properties using dot notation

# ╔═╡ bda58dd0-074a-11eb-37e9-a918c670d380
md"""
Abstract types are just a name used as a point in the type hierarchy.
"""

# ╔═╡ b45a403e-074a-11eb-1144-fd4d939b8bc8
abstract type Cat end

# ╔═╡ ceb62530-074a-11eb-2d0f-7383bc2bb7ea
subtypes(Number)

# ╔═╡ d37ea9c0-074a-11eb-075b-ef2a3aa472d0
subtypes(Cat)

# ╔═╡ f447e9a0-074a-11eb-1a5b-738a852d47a0
md"""
You can define more constructors for your type. Just define a function of the same name as the type and call an existing constructor to get a value of the correct type.

> `<:` is the subtyping operator.
"""

# ╔═╡ 2754b1f0-0914-11eb-1052-1159804bcc1c
struct Lion <: Cat # Lion is a subtype of Cat
	mane_color
	roar::AbstractString
end

# ╔═╡ 0bb9a6f0-074b-11eb-0cd5-55f6817db5fd
struct Panther <: Cat # Panther is also a subtype of Cat
	eye_color

	# Panters will only have this constructor, and no default constructor
	Panther() = new("green")
end

# ╔═╡ 34216ec0-074b-11eb-0ec5-b933ea8ecf34
subtypes(Cat)

# ╔═╡ 573a1ce0-074b-11eb-2c5d-8ddb9d0c07ed
md"""
## Multiple Dispatch
"""

# ╔═╡ 3827f232-0914-11eb-3365-35e127a537ce
function meow(animal::Lion)
	animal.roar 
end

# ╔═╡ 5d31d2a2-074b-11eb-169a-a7423f75a9e6
function meow(animal::Panther)
	"grrr"
end

# ╔═╡ e534d70a-af4d-4d4b-b844-a5e055af93f2
md"""
We can define functions using our `AbstractType` `Cat` to handle cases where specific implementations for subtypes are missing. This helps catch errors or provide warnings when dealing with multiple subtypes. Julia's multiple dispatch ensures that the most specific method (e.g., `meow(::Panter)`) is invoked first, falling back to the generic method when no specific implementation is found.
"""

# ╔═╡ 9ae8c099-0131-4022-bbc5-c10e78ea3e8d
function meow(cat::Cat)
	@warn "`meow` not defined for the type $(typeof(cat))"
end

# ╔═╡ b2b1a3e2-074b-11eb-1a3d-3fb4f9c09ba9
meow(Lion("brown", "ROAAR"))

# ╔═╡ b7cc6720-074b-11eb-31e0-13dea28d37ec
meow(Panther())

# ╔═╡ da8fe338-68db-4981-af99-07baa5e919bc
struct Ragdoll <: Cat
	cuteness_level::Float64
	name::String
end

# ╔═╡ f8f79331-36ef-4705-93a2-1a5d0da3413e
meow(Ragdoll(Inf, "Sarsa"))

# ╔═╡ 43902359-b6eb-4eb0-aa20-dc3cf913d80e
meow(Panther())

# ╔═╡ 3ab40be6-9b96-42f8-9a06-0fabd73c8a07
md"""
# Packages with Julia

Julia simplifies the process of installing packages, including specific versions, making package management straightforward.

It also allows easy access to packages hosted on GitHub. When you activated the `AA120Q` project, Julia automatically ensured that all required packages were downloaded with compatible versions. All the packages needed for this class are already included in the project. However, if you wish to add a new package, you can do so using `Pkg.add` (e.g. `Pkg.add("Distributions")`).

Each notebook activates the AA120Q package assuming the default directory structure. At the beginning of each notebook, we call `using Pkg` and then activate the `AA120Q` project:

```julia
using Pkg
Pkg.activate(../.)
```
"""

# ╔═╡ 721cc411-35d3-4d5b-9219-5dd7a3dc6cb1
md"---"

# ╔═╡ fc57da22-fb5c-4a95-86f3-d899dfe10043
PlutoUI.TableOfContents(title="Julia and Pluto")

# ╔═╡ Cell order:
# ╟─f1a3a270-073b-11eb-1741-37897aa84974
# ╟─436036d3-cfdf-40cf-86dc-5d3c91b86d05
# ╟─6efb1630-074c-11eb-3186-b3ea3cc6d33b
# ╠═433a69f0-074d-11eb-0698-f9113d9939c3
# ╠═4a4f2872-074d-11eb-0ec8-13783b11ffd7
# ╟─991297c0-0776-11eb-082c-e57372352faa
# ╟─50caeb00-073c-11eb-36ac-5b8839bb70ab
# ╠═5996f670-073c-11eb-3a63-67246e676f4e
# ╠═5fe5f3f0-073c-11eb-33ae-2343a63d952d
# ╠═62961fce-073c-11eb-315e-03a405d69157
# ╠═8ca1d3a0-073c-11eb-2d51-7766203bdf92
# ╠═90e6d04e-073c-11eb-0a64-a5596e6b6079
# ╠═9516be60-073c-11eb-277b-b59f20b2feba
# ╠═9895d300-073c-11eb-1fe4-d3337747efcd
# ╠═9be413a0-073c-11eb-3c73-df78ea75bcd1
# ╠═a10c4462-073c-11eb-31f8-6f675614356d
# ╠═a4de820e-073c-11eb-374e-efd08bbc884c
# ╠═ae65ee42-073c-11eb-1dbd-eb918f086ab7
# ╟─b4ad4aa0-073c-11eb-238e-a913116c0944
# ╠═bf0155a2-073c-11eb-1ff2-e9d78baf273a
# ╠═c22997b0-073c-11eb-31c8-952711ee4422
# ╠═c393d612-073c-11eb-071d-93ca1d801f4d
# ╠═c59412e0-073c-11eb-0b89-7d14cda40917
# ╠═cd146470-073c-11eb-131c-250b433dbe74
# ╟─d5dc2a20-073c-11eb-1667-038dd7a06c63
# ╠═e05151b0-073c-11eb-2cd2-75f9f350b266
# ╟─e3846930-073c-11eb-384a-b1b2e27d16cc
# ╠═ef0693f0-073c-11eb-14da-0bec0f5bfe2e
# ╠═f131d862-073c-11eb-0584-1947b568926c
# ╟─f5e1a4d0-073c-11eb-0002-d94d6a932b0b
# ╠═004e40e0-073d-11eb-1475-5dea9854afd4
# ╠═781dcaf0-073d-11eb-2498-0f3bdb572f88
# ╟─80309880-073d-11eb-10d0-53a70045661f
# ╠═7a9cd4ae-073d-11eb-1c20-f1a0bc572b33
# ╠═db37f460-0744-11eb-24b0-cb3767f0cf44
# ╟─8ea1a5d0-073d-11eb-029b-01b0401da847
# ╠═993a33e0-073d-11eb-2ded-4fc896fd19d7
# ╟─f99743b0-0745-11eb-049e-71c7b72884d1
# ╟─fbaad713-216b-4557-8132-3a1e95ed0a27
# ╠═4a2f40a4-029f-43bb-9f55-3bf001861d0c
# ╟─d3d5cde4-8d81-45b1-8554-4ee2e009074c
# ╠═efa419b0-40ce-41ac-a660-5bd1743b0e6c
# ╠═bc755cd7-40ca-4ad6-9f88-8ff657e4e397
# ╠═a0ffcbd0-073d-11eb-3c0a-bfc967428073
# ╠═4968e820-0742-11eb-1b1b-034751f95fb9
# ╟─c5c2e4a7-6a4f-4d06-9cc5-0011dafbffe3
# ╠═d50862fe-4e9d-4dd8-9278-1f935ace223b
# ╠═b1ed3fa0-b885-48be-9332-653623d4b606
# ╟─62c9ce6e-0746-11eb-0911-afc23d8b351c
# ╠═64f36530-0746-11eb-3c66-59091a9c7d7d
# ╟─66335f40-0746-11eb-2f7e-ffe20c76f21f
# ╠═71dc24d0-0746-11eb-1eac-adcbb393c38b
# ╟─765e5190-0746-11eb-318e-8954e5e8fa3e
# ╠═81956990-0746-11eb-2ca4-63ba1d192b97
# ╟─85101160-0746-11eb-1501-3101c2006157
# ╠═97a54cf0-0746-11eb-391d-d70312796ded
# ╠═9a808070-0746-11eb-05cf-81547eab646d
# ╠═9d560e9e-0746-11eb-1e55-55e827e7423d
# ╠═9f1264a0-0746-11eb-2554-1f50ba874f57
# ╠═a2283020-0746-11eb-341a-fb4e280be5d6
# ╠═a9ea93c0-0746-11eb-0956-95d12cb066ac
# ╠═bc8dd90e-0746-11eb-3c30-1b27e08fd17d
# ╠═ad279650-0746-11eb-2090-81a679e5f3be
# ╠═b1266240-0746-11eb-262c-893974d49c9f
# ╠═b5a1b130-0746-11eb-2038-d353aad7e355
# ╠═c4f7ee60-0746-11eb-324b-854c3b2e383e
# ╠═c7484700-0746-11eb-3327-f321a4423d2a
# ╠═cb5d3300-0746-11eb-35d3-33280e451394
# ╠═cd941030-0746-11eb-34d7-216aa0f8f33d
# ╠═d6663620-0746-11eb-01dc-27b5e3b11ab8
# ╠═da28e370-0746-11eb-1ea1-91664661a74d
# ╠═df66e620-0746-11eb-37b9-d3f3ab3dd12f
# ╠═e3e171c0-0746-11eb-0e1d-c3fc24347d47
# ╟─e99fa0f0-0746-11eb-1f5c-7da5d6765131
# ╠═e5afc920-0746-11eb-0558-79599697bec6
# ╠═e8dc9f10-0746-11eb-2c56-c9383000043c
# ╠═1b239000-0747-11eb-0a63-d9e58c6dfda3
# ╠═24b05360-0747-11eb-0783-ab42074819c4
# ╟─410c4e10-0747-11eb-0acf-116ff6073047
# ╠═4842ec70-0747-11eb-37b0-21da3d5049ff
# ╠═7351b860-0747-11eb-16c5-833309f7fbcb
# ╠═750c87c0-0747-11eb-1aeb-d32e03b686f5
# ╟─7f9e37fe-0747-11eb-295e-6d55a31d8395
# ╠═77cd074e-0747-11eb-0306-05ff0e6ada53
# ╠═88232852-0747-11eb-289d-1742e687b041
# ╠═3589dfc0-0748-11eb-1b7f-672e2f6dcf53
# ╠═48a9a810-0748-11eb-0b15-e9085ebd7b52
# ╠═49c63ba0-0748-11eb-158d-57dcd4ad537d
# ╠═4a742ee0-0748-11eb-364c-f7eb2b89d88a
# ╠═64a33770-0748-11eb-1221-b994ffb70091
# ╠═668d060e-0748-11eb-0f34-f307c94e755d
# ╠═6722dd70-0748-11eb-31b7-d38b56f4cc0f
# ╟─7226fe92-0748-11eb-215e-49075766b2da
# ╠═5bfd2a90-0748-11eb-3b5c-8f191bd23f1c
# ╠═7f8e8b20-0748-11eb-39da-435f6c49934a
# ╟─84d7d870-0748-11eb-2a11-5797476719b5
# ╠═8dc1a510-0748-11eb-1e2d-ab6fc445d549
# ╠═90afc450-0748-11eb-170e-9fd33246ec06
# ╠═a28f9290-0748-11eb-0e3a-539a124905c0
# ╠═a6f27780-0748-11eb-2ca3-69c3f2923f7e
# ╠═a8c3b510-0748-11eb-39b2-7389d0ee67e4
# ╠═ac35d160-0748-11eb-00c4-e799f1c83746
# ╠═b137dc80-0748-11eb-3e3b-d9eb6ade524c
# ╠═b47d6a92-0748-11eb-1a5c-fb5faaf20c14
# ╟─bb233aa0-0748-11eb-3488-8d316224bdf8
# ╠═d2ec8dd0-0748-11eb-298a-5d94d5da2477
# ╟─db2d2220-0748-11eb-0889-a30e49f2d784
# ╠═e891a170-0748-11eb-2bbd-e15baa27423c
# ╟─2f09cab2-0749-11eb-3533-79dae3c99545
# ╠═204a7650-0749-11eb-3bcf-2d2846eb951b
# ╠═50260c90-0749-11eb-0af7-8fa4ca5e3890
# ╠═69c88c90-0749-11eb-1c23-a5f0042bf2de
# ╟─fef5c85a-8536-42aa-b169-4b5ccab6e6bd
# ╠═870a7a70-0749-11eb-2ab1-e9279dd4642a
# ╟─9ef92ff2-0749-11eb-119e-35edd2a409c4
# ╟─c3ac5430-0749-11eb-13f0-cde5ec9409cb
# ╠═a12781a0-0749-11eb-0019-3154576cfbc5
# ╟─514268b6-e65c-4ba7-b009-c0398e31c890
# ╠═ba349f70-0749-11eb-3a4a-294a8c484463
# ╟─d6c45450-0749-11eb-3a9c-41cbc41c8d08
# ╠═dedb4090-0749-11eb-38f4-7dffd22ae8c5
# ╠═e9fd49f0-0749-11eb-3cf6-b78a95067ee3
# ╠═f1339a30-0749-11eb-0fcb-21c6e9917eb9
# ╠═f6631df0-0749-11eb-111d-270176d2bd76
# ╟─f81b0720-0749-11eb-2217-9dd2714570b3
# ╠═06186b12-074a-11eb-2ff8-d7ecf3b88f3b
# ╠═1ae6cdc0-074a-11eb-2415-710522e2ff61
# ╠═1f2031b0-074a-11eb-2f30-43fa1403837e
# ╠═2547f820-074a-11eb-2aa5-ffe306f6b1e2
# ╟─28c44da0-074a-11eb-07cf-21435e264c3b
# ╠═39c7ecb0-074a-11eb-0f6a-59d57a454722
# ╠═40e16622-074a-11eb-1f0d-579043dff6df
# ╟─71088c86-7253-4b0b-b5eb-86533ca98db1
# ╠═2fa63331-2634-48da-9981-4a34b81c5ba1
# ╠═2190f793-1b12-4727-b615-6df13dbd40f9
# ╟─4602b910-074a-11eb-3b77-dd28974218f6
# ╠═4e6b95e0-074a-11eb-324c-09c41dd1fb64
# ╟─55249fd0-074a-11eb-1df3-2bfaa49155ae
# ╠═60e50c10-074a-11eb-0249-339b5ee9bcf2
# ╠═6cc00530-074a-11eb-08da-5f69fb9e6c08
# ╠═72681450-074a-11eb-2182-9ba3de8ae5c7
# ╠═89e51c40-074a-11eb-199f-79a721854c1f
# ╟─f1055123-309a-4ee1-aa48-204eb0308b8f
# ╠═fd41492e-9a13-47d1-8f9f-b55edf4a93f3
# ╠═4e2c0e4a-64be-4bf6-972a-3f4b1d236fb2
# ╟─90db2f30-074a-11eb-2990-112df2b43ff3
# ╠═28c3d9f6-8666-44fa-b536-7c05149630eb
# ╠═755f8671-9076-4f4f-bbbf-1bd214a2d0a9
# ╠═6ed95d98-7d68-41a3-9b01-1fee030138cc
# ╟─bda58dd0-074a-11eb-37e9-a918c670d380
# ╠═b45a403e-074a-11eb-1144-fd4d939b8bc8
# ╠═ceb62530-074a-11eb-2d0f-7383bc2bb7ea
# ╠═d37ea9c0-074a-11eb-075b-ef2a3aa472d0
# ╟─f447e9a0-074a-11eb-1a5b-738a852d47a0
# ╠═2754b1f0-0914-11eb-1052-1159804bcc1c
# ╠═0bb9a6f0-074b-11eb-0cd5-55f6817db5fd
# ╠═34216ec0-074b-11eb-0ec5-b933ea8ecf34
# ╟─573a1ce0-074b-11eb-2c5d-8ddb9d0c07ed
# ╠═3827f232-0914-11eb-3365-35e127a537ce
# ╠═5d31d2a2-074b-11eb-169a-a7423f75a9e6
# ╠═b2b1a3e2-074b-11eb-1a3d-3fb4f9c09ba9
# ╠═b7cc6720-074b-11eb-31e0-13dea28d37ec
# ╟─e534d70a-af4d-4d4b-b844-a5e055af93f2
# ╠═9ae8c099-0131-4022-bbc5-c10e78ea3e8d
# ╠═da8fe338-68db-4981-af99-07baa5e919bc
# ╠═f8f79331-36ef-4705-93a2-1a5d0da3413e
# ╠═43902359-b6eb-4eb0-aa20-dc3cf913d80e
# ╟─3ab40be6-9b96-42f8-9a06-0fabd73c8a07
# ╠═a661329d-af9d-4ada-ac4d-fec68a76b393
# ╟─721cc411-35d3-4d5b-9219-5dd7a3dc6cb1
# ╠═fc57da22-fb5c-4a95-86f3-d899dfe10043
