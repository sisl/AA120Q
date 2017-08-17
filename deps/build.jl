Pkg.checkout("Reactive")

# const DATA_DOWNLOAD_URL =

data_dir = Pkg.dir("AA120Q", "data")
if !isdir(data_dir)
    mkdir(data_dir)
end

function fetch_dset(name::AbstractString;
    url::AbstractString="http://web.stanford.edu/class/aa120q/data/",
    dir::AbstractString=data_dir,
    )

    flights = name * ".csv"
    download(joinpath(url, flights), joinpath(dir, flights))
end

fetch_dset("flights")
