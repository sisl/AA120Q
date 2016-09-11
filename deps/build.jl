const DATA_DOWNLOAD_URL =

data_dir = Pkg.dir("AA120Q", "data")
if !isdir(data_dir)
    mkdir(data_dir)
end

function fetch_dset(name::AbstractString;
    url::AbstractString="http://web.stanford.edu/class/aa120q/data/",
    dir::AbstractString=data_dir,
    )

    init = "initial_" * name * ".txt"
    traces = "traces_" * name * ".txt"
    download(joinpath(url, init), joinpath(dir, init))
    download(joinpath(url, traces), joinpath(dir, traces))
end

fetch_dset("small")
fetch_dset("large")
