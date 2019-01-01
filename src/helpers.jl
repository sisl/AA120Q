using Printf
using LinearAlgebra
macro max(range, ex)
    :(maximum($(Expr(:typed_comprehension, :Float64, ex, range))))
end
macro sum(range, ex)
    :(sum($(Expr(:typed_comprehension, :Float64, ex, range))))
end
macro min(range, ex)
    :(minimum($(Expr(:typed_comprehension, :Float64, ex, range))))
end
macro prod(range, ex)
    :(prod($(Expr(:typed_comprehension, :Float64, ex, range))))
end
macro argmax(range, ex)
    @assert(range.head == :in)
    @assert(length(range.args) == 2)
    :($(range.args[2])[indmax($(Expr(:typed_comprehension, :Float64, ex, range)))])
end
macro argmin(range, ex)
    @assert(range.head == :in)
    @assert(length(range.args) == 2)
    :($(range.args[2])[indmin($(Expr(:typed_comprehension, :Float64, ex, range)))])
end
macro array(range, ex)
    :($(Expr(:typed_comprehension, :Float64, ex, range)))
end
