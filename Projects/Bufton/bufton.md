[gimmick: math]()
Project 0: Buffon's Needle Experiment
--------------------------
*Due date: May ? at 11:59p*

<img src="http://andreiformiga.com/blog/wp-content/uploads/2013/03/buffon.png" alt="Tossing Needles" width="600" align="middle">

Buffon's Needle Problem was first proposed by Georges Buffon in 1737. By randomly throwing needles onto a hard floor marked with equally spaced lines, Buffon was able to derive a mathematial expression which could be used to calculate the value of pi. Specifically, the probability that a needle of $b$ overlaps with a line is $\frac{2}{\pi}$. 

One can estimate pi by dropping a large number of pins and using the ratio of overlaps to non-overlaps to estimate pi.
The accuracy of this experimental value of pi increases with an increasing number of random throws. 
See [Wikipedia](https://en.wikipedia.org/wiki/Buffon%27s_needle) for a detailed problem description and background.

### Assignment ###

Your task is to develop an algorithm that estimates pi based on the above description, and write a program to implement this  algorithm.

1.	Your algorithm must be implemented from scratch in Julia.
2.	Your function should have the following signature: `bufton(n::Int)`.
3.  Your function should return $\hat{\pi}$, your estimate for pi.
4.  Plot how your algorithm converges as the sample count is increased using [PGFPlots](https://github.com/sisl/PGFPlots.jl), [PyPlot.jl](https://github.com/stevengj/PyPlot.jl), or [Gadfly.jl](https://github.com/dcjones/Gadfly.jl)
5.	Although you may discuss your algorithm with others, you must not share code.

#### Submission ####

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



