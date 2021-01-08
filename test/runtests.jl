using Test
using AA120Q
# using InteractiveUtils
# using Plots

assignment_dir = joinpath(dirname(pathof(AA120Q)), "..", "assignments")
for d in readdir(assignment_dir)
    if startswith(d, "0") && endswith(d, ".jl")
        fullpath = joinpath(lecture_dir, d)
        include(fullpath)
    end
end
