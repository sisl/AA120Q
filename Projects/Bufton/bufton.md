[gimmick: math]()
Project 0: Buffon's Needle Experiment
--------------------------
*Due date: May ? at 11:59p*

Buffon'e Needle Problem was first proposed by Georges Buffon in 1737. By randomly throwing needles onto a hard floor marked with equally spaced lines, Buffon was able to derive a mathematial expression which could be used to calculate the value of pi. The accuracy of this experimental value of pi increases with an increasing number of random throws. We will make the assumption that the length of the needle is less than or equal to the separation distance between the lines on the floor (for needles longer than the length of separation, a slightly different expression is used).

Your task is to develop an algorithm that calculates pi based on the above description, and write a program to implement this  algorithm.

### Rules ###

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



