using Pkg
Pkg.update()

Pkg.add("BayesNets")
Pkg.add("BSON")
Pkg.add("Cairo")
Pkg.add("Colors")
Pkg.add("Compose")
Pkg.add("CSV")
Pkg.add("CSVFiles")
Pkg.add("DataFrames")
Pkg.add("Discretizers")
Pkg.add("Distributions")
Pkg.add("Interact")
Pkg.add("InteractiveUtils")
Pkg.add("LightGraphs")
Pkg.add("LinearAlgebra")
Pkg.add("Markdown")
Pkg.add("Pkg")
Pkg.add("Plots")
Pkg.add("Pluto")
Pkg.add("PlutoUI")
Pkg.add("Printf")
Pkg.add("Random")
Pkg.add("RDatasets")
Pkg.add("Reactive")
Pkg.add("Reexport")
Pkg.add("Statistics")
Pkg.add("SymPy")
Pkg.add("Test")
Pkg.add("TikzPictures")

Pkg.build()

if !haskey(ENV, "TRAVIS")
    # Non-Travis CI builds install AA120Q here.
    pkg"dev ."
    Pkg.build("AA120Q")
end

@info "Packages installed."
