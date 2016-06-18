[gimmick: math]()
Project 2: Encounter Learning
-----------------------------
*Due date: May ? at 11:59p*

### Assignment ###

Your task is to write code for learning the parameters of an aircraft encounter model from data.
Using the provided airplane trajectories you will:

1.  Learn an initial scene model
2.  Learn an uncorrelated dynamics model

The files [initial.txt](#) and [transition.txt](#) are formatted identically to the previous assignment.
Use the provided data to learn your models.

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



