using Test
using AA120Q
using NBInclude
using InteractiveUtils
using Plots

lecture_dir = joinpath(dirname(pathof(AA120Q)), "..", "lectures")
for d in readdir(lecture_dir)
    if endswith(d, ".ipynb")
        fullpath = joinpath(lecture_dir, d)
        @nbinclude(fullpath; softscope=true)
    end
end
