# AA120Q Lecture Notebooks
[![website](https://img.shields.io/badge/website-Stanford-b31b1b.svg)](https://aa120q.stanford.edu/)

## Steps
1. Open Pluto:
    - Run `julia` in a terminal.
    - Within Julia, run:
        ```julia
        using Pluto
        Pluto.run()
        ```
        - This should open Pluto in your browser.
            - If not, checkout the Pluto output for the URL (likely http://localhost:1234/):
            ```julia
            ┌ Info:
            └ Opening http://localhost:1234/ in your default browser... ~ have fun!
            ```
2. Open the desired notebook from Pluto through this box (`<PATH_TO_AA120Q>/lectures/<DESIRED_NOTEBOOK.jl>`): <p align="center"> <img src="./figures/pluto-open.png#gh-light-mode-only"> </p><p align="center"> <img src="./figures/pluto-open-dark.png#gh-dark-mode-only"> </p>
    - Click `Run notebook code` (on the top right).

## Notebook Overview

| # | Title | Link | Version | Description |
|---|-------|------|---------|-------------|
| 1 | Introduction to Julia and Pluto | [![html](https://img.shields.io/badge/static%20html-Coding_Notebook%2001-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/lectures/html/01_Julia.html) | v2025.0.1 | Introduction to the Julia programming languange and the interactive Pluto notebook environment. Topics include basic syntax, data types, control flow, functions, and plotting. |
| 2 | Scientific Computing Tools and Visualizations | [![html](https://img.shields.io/badge/static%20html-Coding_Notebook%2002-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/lectures/html/02_Computing_Tools.html) | v2025.0.1 | Learn about scientific computing tools in Julia, including working with probability distributions, data visualization, and basic statistical analysis. |
| 3 | Learning | [![html](https://img.shields.io/badge/static%20html-Coding_Notebook%2003-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/lectures/html/03_Learning.html) | v2025.0.1 | Introduction to parameter learning and model fitting. Topics include maximum likelihood estimation, fitting probabilistic models to data, and cross validation. |
| 4 | Simulation | [![html](https://img.shields.io/badge/static%20html-Coding_Notebook%2004-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/lectures/html/04_Simulation.html) | v2025.0.1 | Explore methods for simulating dynamic systems. Learn about the simulation loop, stochastic models, random number generation, and visualization techniques. |
| 5 | Building and Evaluating Autonomous Systems | [![html](https://img.shields.io/badge/static%20html-Coding_Notebook%2005-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/lectures/html/05_Building.html) | v2025.0.1 | Develop a foundation for constructing autonomous systems. Topics include decision-making processes, policy evaluation, and system implementation. |
| 6 | Analysis of Autonomous Systems | [![html](https://img.shields.io/badge/static%20html-Coding_Notebook%2006-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/lectures/html/06_Analysis.html) | v2025.0.1 | Methods for analyzing autonomous system performance including metrics definition, trade-off analysis using Pareto frontiers, and quantitative evaluation techniques. |
