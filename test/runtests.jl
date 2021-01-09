using Test
using AA120Q
# using InteractiveUtils
# using Plots

for dir in ["lectures", "assignments"]
    assignment_dir = joinpath(dirname(pathof(AA120Q)), "..", dir)
    cd("../$dir")
    for d in readdir(assignment_dir)
        if (startswith(d, "0") || startswith(d, "1")) && endswith(d, ".jl")
            fullpath = joinpath(assignment_dir, d)
            include(fullpath)
        end
    end
end
