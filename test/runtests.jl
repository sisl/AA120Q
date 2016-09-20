using Base.Test
using AA120Q
using NBInclude

lecture_dir = Pkg.dir("AA120Q", "lectures")
for d in readdir(lecture_dir)
    if endswith(d, ".ipynb")
        fullpath = joinpath(lecture_dir, d)
        stuff = "using NBInclude; nbinclude(\"" * fullpath * "\")"
        cmd = `julia -e $stuff`
        run(cmd)
    end
end
