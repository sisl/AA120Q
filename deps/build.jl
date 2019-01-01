data_dir = joinpath(@__DIR__, "data")
if !isdir(data_dir)
    mkdir(data_dir)
end

function fetch_dset(name::AbstractString;
    url::AbstractString="http://web.stanford.edu/class/aa120q/data/",
    dir::AbstractString=data_dir,
    )

    download(joinpath(url, name), joinpath(dir, name))
end

fetch_dset("myencountermodel.bson")
fetch_dset("flights.csv")
fetch_dset("initial_cas.txt")
fetch_dset("initial_large.txt")
fetch_dset("initial_small.txt")
fetch_dset("traces_cas.txt")
fetch_dset("traces_large.txt")
fetch_dset("traces_small.txt")
