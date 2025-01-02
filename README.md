# AA120Q
## Building Trust in Autonomy
[![website](https://img.shields.io/badge/website-Stanford-b31b1b.svg)](https://aa120q.stanford.edu/)
[![Lectures](https://img.shields.io/badge/coding_lectures-Pluto-175E54.svg)](https://github.com/sisl/AA120Q/tree/main/lectures)
[![Assignments](https://img.shields.io/badge/coding_assignments-Pluto-175E54.svg)](https://github.com/sisl/AA120Q/tree/main/assignments)

Coding Lectures and Assignments for Stanford's AA120Q: *Building Trust in Autonomy*

### Coding Lecture Notebooks
The coding lectures introduce computational tools and concepts through interactive Pluto notebooks. Topics include:
- Julia programming fundamentals 
- Scientific computing tools and visualization
- Machine learning and probabilistic modeling
- Simulation and analysis techniques
- System evaluation and testing

See the [lectures directory](lectures/) for more information about each lecture notebook.

### Coding Assignment Notebooks
The coding assignments provide hands-on experience implementing key concepts through guided Pluto notebooks. Projects include:
- Estimating π using Monte Carlo methods
- Learning aircraft encounter models
- Simulating collision avoidance scenarios  
- Implementing and analyzing safety systems

See the [assignments directory](assignments/) for more information about each assignment.


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
    ```

### Install the Packages
From the AA120Q directory, run:
```bash
julia install.jl
```
The `install.jl` script will add Pluto and PlutoUI to your default Julia environment. It will also activate the AA120Q package, download the project dependencies, and compile the project. If you do not experience any errors during this process, you are ready to run the notebooks!

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
  [ba4760a4] BayesNets v3.4.1
  [336ed68f] CSV v0.10.15
  [159f3aea] Cairo v1.1.1
⌅ [5ae59095] Colors v0.12.11
  [a81c6b42] Compose v0.9.5
  [a93c6f00] DataFrames v1.7.0
  [6e83dbb3] Discretizers v3.2.4
  [31c24e10] Distributions v0.25.115
  [033835bb] JLD2 v0.5.10
  [f0f68f2c] PlotlyJS v0.18.15
⌃ [91a5bcdd] Plots v1.40.7
  [c3e4b0f8] Pluto v0.20.4
  [7f904dfe] PlutoUI v0.7.60
  [ce6b1742] RDatasets v0.7.7
  [10745b16] Statistics v1.11.1
⌅ [2913bbd2] StatsBase v0.33.21
  [37f6aa50] TikzPictures v3.5.0
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