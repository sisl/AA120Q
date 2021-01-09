# AA120Q
## Establishing Trust in Autonomous Systems
[![Build Status](https://travis-ci.org/sisl/AA120Q.svg?branch=master)](https://travis-ci.org/sisl/AA120Q)
[![Coverage Status](https://coveralls.io/repos/sisl/AA120Q/badge.svg)](https://coveralls.io/r/sisl/AA120Q)

This package supports AA120Q: *Establishing Trust in Autonomous Systems*, offered at Stanford.

### Lecture Notebooks
1. [Introduction to Julia](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/01_Julia.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/01_Julia.jl)]</sup>
2. [Scientific Computing](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/02_Computing_Tools.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/02_Computing_Tools.jl)]</sup>
3. [Statistical Models](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/03_Track_Plotting.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/03_Track_Plotting.jl)]</sup>
4. [Learning](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/04_Learning.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/04_Learning.jl)]</sup>
5. [Simulation](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/05_Simulation.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/05_Simulation.jl)]</sup>
6. [Building Autonomous Systems](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/06_Collision_Avoidance_System.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/06_Collision_Avoidance_System.jl)]</sup>
7. [Robustness to Sensor Error](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/07_Sensors.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/07_Sensors.jl)]</sup>
8. [Analysis of Autonomous Systems](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/08_Analysis.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/08_Analysis.jl)]</sup>
9. [Case Studies of Autonomous Systems](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/09_Case_Studies.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/09_Case_Studies.jl)]</sup>
10. [Societal Impact of Autonomy](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/10_Societal_Impact.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/10_Societal_Impact.jl)]</sup>
- [Optional: Bayesian Networks](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/lectures/html/Optional_Bayesian_Networks.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/lectures/Optional_Bayesian_Networks.jl)]</sup>


### Assignments
1. [Estimating π](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/assignments/html/01_Computing_Tools.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/assignments/01_Computing_Tools.jl)]</sup>
2. [Encounter Plotting](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/assignments/html/02_Track_Plotting.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/assignments/02_Track_Plotting.jl)]</sup>
3. [Simulation](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/assignments/html/03_Simulation.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/assignments/03_Simulation.jl)]</sup>
4. [Simple Collision Avoidance System](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/assignments/html/04_Simple_CAS.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/assignments/05_CAS_Design.jl)]</sup>
5. [Collision Avoidance System Design](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/assignments/html/05_CAS_Design.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/assignments/04_Simple_CAS.jl)]</sup>
6. [Analysis](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/assignments/html/06_Analysis.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/assignments/06_Analysis.jl)]</sup>
- [Optional Assignment: Bayesian Network Learning](http://htmlpreview.github.io/?https://raw.githubusercontent.com/sisl/AA120Q/master/assignments/html/Optional_Bayesian_Networks.jl.html) <sup>[[Pluto](https://github.com/sisl/AA120Q/blob/master/assignments/Optional_Bayesian_Networks.jl)]</sup>

## Installation

1. Install Julia version 1.5.3 from https://julialang.org/downloads
   - Add `julia` to the command line PATH: This will make `julia` available anywhere on the command line.
     - <details><summary><b>Windows</b></summary><p>
        Follow these instructions (https://helpdeskgeek.com/windows-10/add-windows-path-environment-variable/) and add the Julia `bin` directory to your User PATH environment variable (replacing <PATH_TO_JULIA> with your actual Julia installation location).

           C:\<PATH_TO_JULIA>\Julia-1.5.3\bin\
        </p></details>
     - <details><summary><b>Linux</b></summary><p>
        Edit your `~/.bashrc` to add the following line (replacing <PATH_TO_JULIA> with your actual Julia installation location):

           export PATH=$PATH:/<PATH_TO_JULIA>/bin/
        </p></details>
     - <details><summary><b>Mac OS X</b></summary><p>
        Open a terminal and run the following (this will create a`julia` alias and place it in `/usr/local/bin` which is already on the terminal path):

           sudo sh -c 'mkdir -p /usr/local/bin && ln -fs "/Applications/Julia-1.5.3.app/Contents/Resources/julia/bin/julia" /usr/local/bin/julia'
        </p></details>
2. Install Git from https://git-scm.com/downloads
3. Open a terminal and run:
    ```bash
    git clone https://github.com/sisl/AA120Q
    cd AA120Q
    julia install.jl
    ```
4. Test the installation by opening `julia` and running:
```julia
] test AA120Q
```


## Troubleshooting
Post issues either here on GitHub or on Piazza.