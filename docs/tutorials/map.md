# Arm MAP Profiler at TACC
*Last update: May 08, 2020*

[Arm MAP](https://developer.arm.com/tools-and-software/server-and-hpc/debug-and-profile/arm-forge/arm-map) is a profiler for parallel, multithreaded or single threaded C, C++, Fortran and F90 codes. MAP provides in-depth runtime analysis and bottleneck pinpointing to the source code line. MAP is available on all TACC compute resources. Use the MAP Profiler with the [DDT Debugger](../../tutorials/ddt) to develop and analyze your HPC applications. 

## Set up Profiling Environment { #env }

Before running MAP, the application code must be compiled with the `-g` option as shown below:

```cmd-line
login1$ mpif90 -g mycode.f90
```

or

```cmd-line
login1$ mpiCC -g mycode.c
```

Leave in any optimization flags to ensure that optimization is still enabled.  If there were no other optimization flags, add the `-O2` flag.  Otherwise, the `-g` flag by itself will drop the default optimization from `-O2` to `-O0`.

Follow these steps to set up your profiling environment on Frontera, Stampede3, Lonestar6 and other TACC compute resources.

1. **Enable X11 forwarding**. To use the MAP GUI, ensure that X11 forwarding is enabled when you ssh to the TACC system. Use the `-X` option on the ssh command line if X11 forwarding is not enabled in your ssh client by default.

	```cmd-line
	localhost$ ssh -X username@stampede2.tacc.utexas.edu
	```

1. **Load the appropriate MAP module on the remote system** along with any other modules needed to run the application:

	```cmd-line
	$ module load map_skx mymodule1 mymodule2	# on Stampede3 load "map_skx"
	$ module load map mymodule1 mymodule2       # on all other resources load "map"
	```

1. **Start the profiler.**

	```cmd-line
	$ map myprogram
	```

	If this error message appears...

	```cmd-line
	map: cannot connect to X server
	```

	...then X11 forwarding was not enabled or the system may not have local X11 support. If logging in with the `-X` flag doesn't fix the problem, please contact the [help desk][HELPDESK] for assistance.

1. **Click the "Profile a Program" button in the "arm FORGE" window if the "Run" window did not open**.

	<figure id="figure1">
	<img alt="figure1" src="../imgs/MAP-1.png">
	<figcaption></figcaption></figure>

1. **Specify the executable path, command-line arguments, and processor count in the "Run" window**. Once set, the values persist from one session to the next.

	<figure id="figure2">
	<img alt="figure2" src="../imgs/MAP-2.png">
	<figcaption></figcaption></figure>

1. **Select each of the "Change" buttons in this window, and adjust the job parameters, as follows:**

	* With the "Options" change button, set the MPI Implementation to either "Intel MPI" or "mvapich2", depending on which MPI software stack you used to compile your program. Click OK.

		<figure id="figure3">
		<img alt="figure3" src="../imgs/MAP-3.png">
		<figcaption></figcaption></figure>

	* In the "Queue Submission Parameters" window, fill in all the following fields:

		<table border="1" cellpadding="3"> <tr>
		<th> Queue
		<td> default queue is <code>skx</code> for Stampede3, and `development` for other systems
		</tr><tr>
		<th> Time
		<td> (hh:mm:ss)
		</tr><tr>
		<th> Project
		<td> Allocation/Project to charge the batch job to</table>

		<p>You must set the Project field to a valid project id. When you login, a list of the projects associated with your account and the corresponding balance should appear. The "Cores per node" setting controls how many MPI tasks will run on each node. For example, if you wanted to run with 4 MPI tasks per node and 4 OpenMP threads per task, this would be set to "4way". Click OK, and you will return to the "Run" window.

		<figure id="figure4">
		<img alt="figure4" src="../imgs/MAP-4.png">
		<figcaption></figcaption></figure>

1. **Back in the "Run" window, set the total number of tasks you will need in the "Number of processes" box and the number of nodes you will be requesting**. If you are running an OpenMP program, set the number of OpenMP threads also.

	<figure id="figure5">
	<img alt="figure5" src="../imgs/MAP-5.png">
	<figcaption></figcaption></figure>

1. **Finally, click "Submit"**. A submitted status box will appear.

	<figure id="figure6">
	<img alt="figure6" src="../imgs/MAP-6.png">
	<figcaption></figcaption></figure>

## Running MAP { #running }

Once your job is launched by the SLURM scheduler and starts to run, the MAP window will switch to show stdout/stderr.  At this point, you can also stop execution of the program to analyze the collected profiling data.

<figure id="figure7">
<img alt="figure7" src="../imgs/MAP-7.png">
<figcaption></figcaption></figure>

After your code completes, MAP will run an analysis of the profiling data collected, and then open the MAP GUI. This screen shows a time progression of the profiled code showing activity, floating point and memory usage. Other timelines, such as IO, MPI, or Lustre, may be added by clicking on the "Metrics" menu.  If you compiled with `-g` and MAP can find the source code, a code listing will also be available.  

<figure id="figure8">
<img alt="figure8" src="../imgs/MAP-8.png">
<figcaption></figcaption></figure>

## MAP with Reverse Connect { #reverse }

By starting MAP from a login node you let it use X11 graphics, which can be slow. Using a VNC connection or the visualization portal is faster, but has its own annoyances. Another way to use MAP is through a MAP's Remote Client using "reverse connect". The remote client is a program running entirely on your local machine, and the reverse connection means that the client is contacted by the MAP program on the cluster, rather than the other way around.

1. **Download and install the [ARM Forge remote client](https://developer.arm.com/tools-and-software/server-and-hpc/downloads/arm-forge)**. The client version and the MAP version on the TACC cluster must correspond. 

1. **Under "Remote Launch" make a new configuration**:

	<figure id="figure9">
	<img alt="figure9" src="../imgs/MAP-9.png">
	<figcaption></figcaption></figure>

1. **Fill in your login name and the cluster to connect to**, for instance `stampede2.tacc.utexas.edu`. The remote installation directory is stored in the `$TACC_MAP_DIR` environment variable once the module is loaded.  

1. **Make the connection**; you'll be prompted for your password and two-factor code:

	<figure id="figure10">
	<img alt="figure10" src="../imgs/MAP-10.png">
	<figcaption></figcaption></figure>

1. **From any login node, submit a batch job where the ibrun line is replaced by**:

	```cmd-line
	login1$ map --connect -n 123 ./yourprogram
	```

1. **When your batch job (and therefore your MAP execution) starts, the remote client will ask you to accept the connection**:

	<figure id="figure11">
	<img alt="figure11" src="../imgs/MAP-11.png">
	<figcaption></figcaption></figure>

	**Your MAP session will now use the remote client.**

## References { #refs }

* [DDT Debugger](../../tutorials/ddt)
* [MAP user guide](https://developer.arm.com/docs/101136/2003)

{% include 'aliases.md' %}
