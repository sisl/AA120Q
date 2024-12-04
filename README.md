# AA120Q
## Building Trust in Autonomy
[![website](https://img.shields.io/badge/website-Stanford-b31b1b.svg)](https://aa120q.stanford.edu/)
[![Build Status](https://travis-ci.org/sisl/AA120Q.svg?branch=main)](https://travis-ci.org/sisl/AA120Q)
<!-- [![Coverage Status](https://coveralls.io/repos/sisl/AA120Q/badge.svg)](https://coveralls.io/r/sisl/AA120Q) -->

This package supports AA120Q: *Establishing Trust in Autonomous Systems*, offered at Stanford.

### Lecture Notebooks
1. [Introduction to Julia](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/01_Julia.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/01_Julia.jl)]</sup>
2. [Scientific Computing](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/02_Computing_Tools.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/02_Computing_Tools.jl)]</sup>
3. [Statistical Models](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/03_Track_Plotting.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/03_Track_Plotting.jl)]</sup>
4. [Learning](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/04_Learning.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/04_Learning.jl)]</sup>
5. [Simulation](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/05_Simulation.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/05_Simulation.jl)]</sup>
6. [Building Autonomous Systems](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/06_Collision_Avoidance_System.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/06_Collision_Avoidance_System.jl)]</sup>
7. [Robustness to Sensor Error](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/07_Sensors.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/07_Sensors.jl)]</sup>
8. [Analysis of Autonomous Systems](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/08_Analysis.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/08_Analysis.jl)]</sup>
9. [Case Studies of Autonomous Systems](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/09_Case_Studies.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/09_Case_Studies.jl)]</sup>
10. [Societal Impact of Autonomy](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/10_Societal_Impact.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/10_Societal_Impact.jl)]</sup>
- [Optional: Bayesian Networks](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/lectures/html/Optional_Bayesian_Networks.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/lectures/Optional_Bayesian_Networks.jl)]</sup>


### Assignments
1. [Estimating π](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/assignments/html/01_Computing_Tools.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/assignments/01_Computing_Tools.jl)]</sup>
2. [Encounter Plotting](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/assignments/html/02_Track_Plotting.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/assignments/02_Track_Plotting.jl)]</sup>
3. [Simulation](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/assignments/html/03_Simulation.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/assignments/03_Simulation.jl)]</sup>
4. [Simple Collision Avoidance System](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/assignments/html/04_Simple_CAS.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/assignments/04_Simple_CAS.jl)]</sup>
5. [Collision Avoidance System Design](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/assignments/html/05_CAS_Design.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/assignments/05_CAS_Design.jl)]</sup>
6. [Analysis](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/assignments/html/06_Analysis.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/assignments/06_Analysis.jl)]</sup>
- [Optional Assignment: Bayesian Network Learning](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/main/assignments/html/Optional_Bayesian_Networks.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/main/assignments/Optional_Bayesian_Networks.jl)]</sup>

## Installation
### Install Git
- https://git-scm.com/downloads

### Install Julia
Install Julia version 1.11+ from https://julialang.org/downloads. Once installed julia will be available via the command line interface. The commands will also install the Juliaup installation manager, which will automatically install julia and help keep it up to date. The command `juliaup` is also installed. To install different julia versions see `juliaup --help`.
   - The commands from the Julia website are echoed below:
     - <details><summary><b>Windows</b></summary><p>
        Open the command prompt and run the following:

           winget install julia -s msstore
        </p></details>
     - <details><summary><b>MacOS & Linux</b></summary><p>
        Open a terminal and run the following:

           curl -fsSL https://install.julialang.org | sh
        </p></details>

### Clone the Repository
Open a terminal, navigate to a directory where you want to store the course materials, and run:
    ```bash
    git clone https://github.com/sisl/AA120Q
    cd AA120Q
    julia install.jl
    ```
### Test the Installation
Test the installation by opening `julia` using `julia --project=.` from the AA120Q directory and running:
   ```julia
   ] test
   ```

## Package Management
There are a couple of ways to open Julia. The following options assume you are in the AA120Q directory.

### Activate the AA120Q Package After Opening Julia
Typeing `julia` will open julia, and then you can use `]` to open the package manager. You should see `(@v1.11) pkg> ` in the prompt and then run `activate .` to activate the AA120Q package. You should see `(@v1.11) Pkg> ` change to `(@AA120Q) Pkg> ` to confirm that the AA120Q package is active. Then you can press backspace to return to the normal prompt.
```julia
(@v1.11) pkg> activate .
(AA120Q) pkg>
julia>
```
      
### Activate the AA120Q Package When Opening Julia
Another option is to open julia with the AA120Q package activated. From the AA120Q directory, run the following in the terminal:
```bash
julia --project=.
```

### Using the Julia Package Manger
The Julia package manager is a useful tool for managing packages used for a projct and to help with reproducibility. To inspect the packages used in the AA120Q project, you can type `]` to open the package manager and then type `status`. You should see something similar to the following:
```julia
(AA120Q) pkg> status
Project AA120Q v0.2.0
Status `~/Documents/AA120Q/AA120Q/Project.toml`
  [fbb218c0] BSON v0.3.9
  [336ed68f] CSV v0.10.15
  [5d742f6a] CSVFiles v1.0.2
  [159f3aea] Cairo v1.1.0
⌅ [5ae59095] Colors v0.12.11
  [a81c6b42] Compose v0.9.5
  [a93c6f00] DataFrames v1.7.0
  [6e83dbb3] Discretizers v3.2.3
  [31c24e10] Distributions v0.25.112
  [86223c79] Graphs v1.12.0
  [c601a237] Interact v0.10.5
  [91a5bcdd] Plots v1.40.8
  [c3e4b0f8] Pluto v0.20.1
  [7f904dfe] PlutoUI v0.7.60
  [ce6b1742] RDatasets v0.7.7
  [a223df75] Reactive v0.8.3
  [189a3867] Reexport v1.2.2
  [10745b16] Statistics v1.11.1
  [24249f21] SymPy v2.2.0
  [37e2e46d] LinearAlgebra v1.11.0
  [44cfe95a] Pkg v1.11.0
  [de0858da] Printf v1.11.0
(AA120Q) pkg>
```

## Running Pluto

To run Pluto to interact with the notebooks:
1. Open Julia and activate the AA120Q package (above options)
2. Run `using Pluto` followed by `Pluto.run()`:
```julia
using Pluto
Pluto.run()
```
You should see a url similar to `http://localhost:####/?secret=####` that you can open in a browser (this will open Pluto!).


## Troubleshooting
Post issues you expereince on Ed or here on GitHub.

## Update AA120Q (if necessary)
If we update the course materials, you can update your local copy of the repository by running `git pull` from the AA120Q directory.
