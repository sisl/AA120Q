using Test
using AA120Q

for dir in ["lectures", "assignments"]
    test_dir = joinpath(dirname(pathof(AA120Q)), "..", dir)
    cd("../$dir")
    for d in readdir(test_dir)
        if (startswith(d, "0") || startswith(d, "1")) && endswith(d, ".jl")
            fullpath = joinpath(test_dir, d)
            @info d
            try
                include(fullpath)
            catch err
                if isa(err, LoadError) # expected error in first notebook
                    continue
                else
                    throw(err)
                end
            end
        end
    end
end
