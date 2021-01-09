using Pkg
Pkg.update()
Pkg.build()

Pkg.add(PackageSpec(name="AA120Q", url="https://github.com/sisl/AA120Q.git"))
Pkg.build("AA120Q")

@info "Packages installed."
