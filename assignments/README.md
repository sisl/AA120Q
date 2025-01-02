# AA120Q Assignment Notebooks
[![website](https://img.shields.io/badge/website-Stanford-b31b1b.svg)](https://aa120q.stanford.edu/)

## Steps
### 1. Open Pluto:
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
### 2. Open the desired notebook from Pluto through this box (`<PATH_TO_AA120Q>/assignments/<DESIRED_NOTEBOOK.jl>`): <p align="center"> <img src="./figures/pluto-open.png#gh-light-mode-only"> </p><p align="center"> <img src="./figures/pluto-open-dark.png#gh-dark-mode-only"> </p>
    - Click `Run notebook code` (on the top right).

### 3. Complete the assignment.

### 4. Submit
1. Export this notebook as a PDF ([how-to in the documentation](https://plutojl.org/en/docs/export-pdf/))
2. Upload the PDF to [Gradescope](https://www.gradescope.com/)
3. Tag your pages on Gradescope

## Assignment Overview

### Assignment 1: Estimating π 
[![html](https://img.shields.io/badge/static%20html-Assignment%2001-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/assignments/html/01_Estimating_Pi.html)

Implement Buffon's needle experiment to estimate π through simulation. Learn about random sampling, statistical convergence, and visualization of results.

### Assignment 2: Learning Aircraft Encounter Models
[![html](https://img.shields.io/badge/static%20html-Assignment%2002-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/assignments/html/02_Learning_Encounter_Models.html)

Develop probabilistic models of aircraft encounters using Bayesian networks. Implement methods for learning both initial conditions and dynamic transitions from data.

### Assignment 3: Encounter Simulation and Analysis
[![html](https://img.shields.io/badge/static%20html-Assignment%2003-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/assignments/html/03_Encounter_Simulation.html)

Generate and analyze aircraft encounter scenarios. Focus on safety metrics, particularly near mid-air collision (NMAC) analysis in simulated encounters.

### Assignment 4: Simple Collision Avoidance System
[![html](https://img.shields.io/badge/static%20html-Assignment%2004-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/assignments/html/04_Simple_CAS.html)

Design and implement a basic collision avoidance system. Evaluate system performance through safety and efficiency metrics, exploring fundamental trade-offs in system design.

### Assignment 5: CAS Design
[![html](https://img.shields.io/badge/static%20html-Assignment%2005-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/assignments/html/05_CAS_Design.html)

Design and implement a more refined collision avoidance system. Build on insights from the simple CAS to create improved collision avoidance logic and demonstrate enhanced performance.

### Assignment 6: Additional Analysis
[![html](https://img.shields.io/badge/static%20html-Assignment%2006-0072B2)](https://htmlview.glitch.me/?https://github.com/sisl/AA120Q/blob/main/assignments/html/06_Additional_Analysis.html)

Conduct in-depth analysis of your collision avoidance system design. Evaluate improvements, assess performance gains, and provide discussions on system capabilities and limitations.