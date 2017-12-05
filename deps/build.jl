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

    flights = name * ".txt"
    download(joinpath(url, flights), joinpath(dir, flights))
end

fetch_dset("iniital_cas")
fetch_dset("iniital_large")
fetch_dset("iniital_small")
fetch_dset("traces_cas")
fetch_dset("traces_large")
fetch_dset("traces_small")
