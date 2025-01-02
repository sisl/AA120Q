using Pkg
Pkg.add("Pluto")
Pkg.add("PlutoUI")
Pkg.activate(".")
Pkg.update()
Pkg.build()
@info "Packages for AA120Q updated and built."
