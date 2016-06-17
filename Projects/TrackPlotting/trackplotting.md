[gimmick: math]()
Project 1: Track Plotting
--------------------------
*Due date: May ? at 11:59p*

### Assignment ###

Your task is to:

1.  Load example aircraft tracks from a file and plot them.
2.  Propose a statistical model for capturing features from the data.

#### Aircraft Tracks

An airspace encounter consists of two components - the initial conditions and the transitions over time.
One file is provided for each.

The initial conditions file, [`initial.txt`](initial.txt), contains a table with the following columns:

| Variable | Type | Description |
| -------- |:----:| ----------- |
| id       | Int  | trace id    |
| $A$      | Int  | index corresponding to the airspace class (i.e., B, C, D, or other) |
| $L$      | Int  | index corresponding to the altitude layer with boundaries 500, 1200, 3000, 5000, and 12,500ft |
| $\chi$   | Int  | index corresponding to bearing of intruder relative to own aircraft at time of closest approach |
| $\beta$  | Float | approach angle at time of closest approach [deg] |
| $C_1$    | Int   | category of aircraft 1 |
| $C_2$    | Int   | category of aircraft 2 |
| $v_1$    | Float | airspeed of aircraft 1 [kt] |
| $v_2$    | Float | airpseed of aircraft 2 [kt] |
| $\dot v_1$ | Float | airspeed acceleration of aircraft 1 [kt/s] | 
| $\dot v_2$ | Float | airspeed acceleration of aircraft 2 [kt/s] | 
| $\dot h_1$ | Float | vertical rate of aircraft 1 [ft/min] |
| $\dot h_2$ | Float | vertical rate of aircraft 2 [ft/min] |
| $\dot \psi_1$ | Float | turn rate of aircraft 1 [deg/s] |
| $\dot \psi_2$ | Float | turn rate of aircraft 2 [deg/s] |
| $hmd$ | Float | horizontal miss distance at time of closest approach [kt] |
| $vmd$ | Float | vertical miss distance at time of closest approach [ft] |

The transitions file, [`transition.txt`](transition.txt), contains a table with the following columns:

| Variable | Type | Description |
| -------- |:----:| ----------- |
| initial_id          | Int   | trace id, same as in `initial.txt`    |
| t                   | Int   | time in 1s intervals from 0:49    |
| $\dot h_1(t+1)$     | Float | vertical rate of aircraft 1 [ft/min] |
| $\dot h_2(t+1)$     | Float | vertical rate of aircraft 2 [ft/min] |
| $\dot \psi_1(t+1)$  | Float | turn rate of aircraft 1 [deg/s] |
| $\dot \psi_1(t+1)$  | Float | turn rate of aircraft 2 [deg/s] |

Your task is to write a program to load these trajectories and plot them.

1.  Your algorithm must be implemented from scratch in Julia.
2.  Overlay all traces on a single top-down plot with the ownship starting at (0,0) pointing along the positive x-axis. using PGFPlots, PyPlot.jl, or Gadfly.jl [TODO: example plot]
3.  Although you may discuss your algorithm with others, you must not share code.

#### Propose a Statistical Model

[TODO: maybe Shahram can expand on this] ==> here it is:
Now that you are familiar with the Probabilistic Models discussed in class (and described in section 2.1 of the text book), you will propose a model which best captures features from the plotted data. Your must explan the reasoning behind your decision to propose the model you chose, and describe what are the key features which make the proposed model best suited for this data set.

#### How to submit code ####

Submit your code under the name `project2.jl` using the submission procedure described below:

1. **Login to corn.stanford.edu**

    You can use ssh (OS X, Ubuntu) or [SecureCRT](https://itservices.stanford.edu/service/ess/pc/docs/securecrt) (Windows) to connect to the server and login with your SUID. You can also copy your code to the server with scp (OS X, Ubuntu) or psftp (Windows). Someone off-campus can log into corn via [Stanford VPN](http://itservices.stanford.edu/service/vpn/).

2. **Run evaluation test on your code**

    We recommend you run the evaluation test before submitting. This will check that its format is correct and that it works with evaluation framework.

    Usage: **submit runtest &lt;project number&gt; &lt;filename&gt;**

    Example: test your code

    `$ /afs/ir/class/aa222/project_submission/submit runtest 2 project2.jl`

    or

    `$ /afs/ir/class/aa222/project_submission/submit runtest 2 project2.py`

    Note: The runtest and submit scripts need the PyCall package, which may not be loaded on some of the Corn machines. To add PyCall, open a julia terminal and type Pkg.add("PyCall").

3. **Submit code**

    Submit your code as a file named `project2.jl` or `project2.py` in a directory named `project2` as follows: 

    Usage: **submit submit &lt;nickname&gt; &lt;project number&gt; &lt;dirname&gt;**

    Example: submit code for project 2

    `$ /afs/ir/class/aa222/project_submission/submit submit 'snoopy' 2 project2`

    All of the contents of `project2` will be submitted. You may include any files you used to test your code by placing them in this directory.

    Note: The submission script will not accept your submission after 11:59p on the due date.

You can get help on running the submission script

`$ /afs/ir/class/aa222/project_submission/submit -h`



