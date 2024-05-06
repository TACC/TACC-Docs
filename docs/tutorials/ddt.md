# Arm DDT Debugger at TACC
*Last update: May 18, 2020*

[Arm DDT](https://www.arm.com/products/development-tools/server-and-hpc/forge/ddt) is a symbolic, parallel debugger providing graphical debugging of C, C++ and Fortran threaded and parallel codes (MPI, OpenMP, and Pthreads applications). DDT is available on all TACC compute resources. Use the DDT Debugger with the [MAP Profiler](../../tutorials/map) to develop and analyze your HPC applications.

## [Set up Debugging Environment](#env) { #env }

Before running any debugger, the application code must be compiled with the `-g` and `-O0` options as shown below:

```cmd-line
login1$ mpif90 -g -O0 mycode.f90
```

or

```cmd-line
login1$ mpiCC -g -O0 mycode.c
```

Follow these steps to set up your debugging environment on Frontera, Stampede2, Lonestar6 and other TACC compute resources.

1. **Enable X11 forwarding**. To use the DDT GUI, ensure that X11 forwarding is enabled when you `ssh` to the TACC system. Use the `-X` option on the `ssh` command line if X11 forwarding is not enabled in your SSH client by default.

	```cmd-line
	localhost$ ssh -X username@stampede2.tacc.utexas.edu
	```

1. **Load the DDT module on the remote system along with any other modules needed to run the application**:

	```cmd-line
	$ module load ddt mymodule1 mymodule2
	```

	!!! note
		On Stampede2, there are 2 DDT modules, `ddt_skx` and `ddt_knl`, because the KNL's require a different license.

	```cmd-line
	$ module load ddt_knl mymodule1 mymodule2 # for KNL nodes
	```

	or
	```cmd-line
	$ module load ddt_skx mymodule1 mymodule2 # for SKX nodes
	```

1. **Start the debugger**:

	```cmd-line
	$ ddt myprogram
	```

	If this error message appears...

	```cmd-line
	ddt: cannot connect to X server
	```

	...then X11 forwarding was not enabled (Step 1.) or the system may not have local X11 support. If logging in with the `-X` flag doesn't fix the problem, please [create a help ticket][HELPDESK] for assistance.

1. **Click the "Run and Debug a Program" button in the "DDT - Welcome" window**:

	<figure id="figure1"><img src="../imgs/DDT-1.png">
	<figcaption></figcaption></figure>

1. This displays the "Run" window, where you **specify the executable path, command-line arguments, and processor count**. Once set, these values remain from one session to the next.

	<figure id="figure2"><img src="../imgs/DDT-2.png">
	<figcaption></figcaption></figure>

1. **Select each of the "Change" buttons in this window, and adjust the job parameters**.

	* With the "Options" change button, set the MPI Implementation to either "Intel MPI" or "MVAPICH 2i", depending on which MPI software stack you used to compile your program. Click OK.

		<figure id="figure3"><img src="../imgs/DDT-3.png">
	<figcaption></figcaption></figure>

	* In the "Queue Submission Parameters" window, fill in the following fields:

		<table border="1" cellpadding="3">
		<tr><th>Queue</th><td>default queue is <code>skx-dev</code> for Stampede2, and <code>development</code> for other systems</td></tr>
		<tr><th>Time</th><td>(hh:mm:ss)</td></tr>
		<tr><th>Project</th><td>Allocation/Project to charge the batch job to</td></tr></table>

		<p>You must set the Project field to a valid project id. When you login, a list of the projects associated with your account and the corresponding balance should appear. Click OK, and you'll return to the "Run" window.

		<figure id="figure4"><img alt="" src="../imgs/DDT-4.png">
	<figcaption></figcaption></figure>

1. Back in the "Run" window, **set the number of tasks you will need in the "Number of processes" box and the number of nodes you will be requesting**. If you are debugging an OpenMP program, set the number of OpenMP threads also.

	<figure id="figure5"><img alt="" src="../imgs/DDT-5.png">
	<figcaption></figcaption></figure>

1. **Finally, click "Submit"**. A submitted status box will appear:

	<figure id="figure6"><img src="../imgs/DDT-6.png">
	<figcaption></figcaption></figure>


## [Running DDT](#running) { #running }

Once your job is launched by the SLURM scheduler and starts to run, the DDT GUI will fill up with a code listing, stack trace, local variables and a project file list. Double click on line numbers to set breakpoints, and then click on the play symbol (>) in the upper left corner to start the run.

<figure id="figure7"><img alt="" src="../imgs/DDT-7.png">
	<figcaption></figcaption></figure>

## [DDT with Reverse Connect](#reverse) { #reverse }

By starting DDT from a login node you let it use X11 graphics, which can be slow. Using a VNC connection or the visualization portal is faster, but has its own annoyances. Another way to use DDT is through DDT's Remote Client using "reverse connect". The remote client is a program running entirely on your local machine, and the reverse connection means that the client is contacted by the DDT program on the cluster, rather than the other way around.

1. **[Download and install a remote client](https://developer.arm.com/tools-and-software/server-and-hpc/downloads/arm-forge). Get the latest client available**.

1. **Under "Remote Launch" make a new configuration**:

	<figure id="figure8"><img src="../imgs/DDT-8.png">
	<figcaption></figcaption></figure>

	Fill in your login name and the cluster to connect to, for instance `stampede2.tacc.utexas.edu`. The remote installation directory is stored in the `$TACC_DDT_DIR` environment variable after the module is loaded.

1. **Make the connection; you'll be promped for your password and two-factor code**:

	<figure id="figure9"><img src="../imgs/DDT-9.png">
	<figcaption></figcaption></figure>

1. **From any login node, submit a batch job where the `ibrun` line is replaced by**:

	```cmd-line
	$ ddt --connect -n $SLURM_NPROCS ./yourprogram
	```

1. **When your batch job (and therefore your DDT execution) starts, the remote client will ask you to accept the connection**:

	<figure id="figure10"><img src="../imgs/DDT-10.png">
	<figcaption></figcaption></figure>

	**Your DDT session will now use the remote client.**

## [References](#refs) { #refs }

* [DDT User Guide](https://developer.arm.com/docs/101136/2003/ddt)
* [MAP Profiler](../../tutorials/map)
<!-- SDL * Presentation: [Debugging at TACC](https://www.tacc.utexas.edu/documents/13601/897815/1a-Debugging.pdf) (`gdb`, DDT & Eclipse) -->

{% include 'aliases.md' %}
