using Test
using AA120Q
using NBInclude

lecture_dir = joinpath(dirname(pathof(AA120Q)), "..", "lectures")
for d in readdir(lecture_dir)
    if endswith(d, ".ipynb")
        fullpath = joinpath(lecture_dir, d)
        stuff = "using Interact, Reactive, NBInclude; nbinclude(\"" * fullpath * "\")"
        cmd = `julia -e $stuff`
        run(cmd)
    end
end
