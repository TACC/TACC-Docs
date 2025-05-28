# ParaView at TACC
*Last update: February 12, 2025*

<!-- ![ParaView logo](../imgs/paraview-logo.svg){ .align-right width="300" } -->
<img src="../imgs/paraview-logo.png" width="300" alt="ParaView logo" class="align-right">

[ParaView](https://www.paraview.org/) is an open-source, multi-platform data analysis and visualization application. ParaView users can quickly build visualizations to analyze their data using qualitative and quantitative techniques. The data exploration can be done interactively in 3D or programmatically using ParaView's batch processing capabilities.

ParaView was developed to analyze extremely large datasets using distributed memory computing resources. ParaView can be run on supercomputers to analyze datasets of petascale size as well as on laptops for smaller data. ParaView has become an integral tool in many national laboratories, universities and industry, and has won several awards related to high performance computation.


## Installations { #installations } 

ParaView is currently installed on TACC's Stampede3, Lonestar6 and Frontera resources.  

### Table 1. ParaView Modules per TACC Resource { #table1 }

<table>
<tr><th>Resource</th><th>Versions Installed</th><th>Module requirements</th></tr>
<tr><td valign="middle" rowspan="2">Frontera</td><td>5.11.1<td><code>gcc/9.1.0</code> <code>impi/19.0.9</code> <code>qt5/5.14.2</code> <code>swr/21.2.5</code> <code>oneapi_rk/2021.4.0</code> <code>paraview/5.11.1</code><td></tr><tr><td>5.10.0</td><td><code>gcc/9.1.0</code><code>impi/19.0.9</code><code>qt5/5.14.2</code> <code>swr/21.2.5</code><code>oneapi_rk/2021.4.0</code> <code>paraview/5.10.0</code><td></tr>
<tr><td>Stampede3</td><td>5.12.0</td><td><code>paraview</code><td></tr>
<tr><td>Lonestar6</td><td>5.10.0</td><td><code>intel/19.1.1</code> <code>impi/19.0.9</code> <code>swr/21.2.5</code>  <code>qt5/5.14.2</code> <code>oneapi_rk/2021.4.0</code> <code>paraview</code><td></tr>
</table>


## Interactive ParaView A Compute-Node Desktop { #desktop }

To run ParaView on one of TACC's HPC resources, log onto the [TACC Analysis Portal][TACCANALYSISPORTAL] to request one (or more) compute nodes and launch a desktop.  

!!! important
	We do not use GPUs to run ParaView on Frontera, Stampede3 or Lonestar6.  On Frontera and Lonestar6 we use the **swr** wrapper that enables ParaView to take advantage of Intel's many-core OpenSWR rendering library.  The `-p 1` argument informs OpenSWR that ParaView is running serially and should have access to all available cores for rendering.  On Stampede3 this is not necessary.

In the image below the user is submitting a request for a 30-minute DCV session on a single node in Stampede3's `skx-dev` queue.  

!!!tip
	You can choose either the VNC or DCV method to provide the desktop.  DCV is preferred but has a limited number of licenses available.

<figure><img src="../imgs/paraview-1.png" width=60%>
<figcaption>Submit DCV session request</figcaption></figure>

Eventually the job will run, allocate the specified nodes and tasks, and provide a means to connect to it in a separate browser tab.   There you will see a desktop.   In the terminal window on that desktop:


1.  Load the modules as indicated in [Table 1.](#table1)  above:

	```cmd-line
	c442-001$ module load {module list}
	```

1. Launch ParaView GUI:
	
	On Frontera and Lonestar6 compute nodes:

	```cmd-line
	c442-001$ swr -p 1 paraview 
	```
	
	On Stampede3 compute nodes:

	```cmd-line
	c442-001$ paraview 
	```

1.	And the ParaView GUI will appear on the desktop.

	<figure><img src="../imgs/paraview-2.png" width=60%>
	<figcaption>ParaView session</figcaption></figure>


### Running ParaView In Parallel

To run ParaView in parallel, you must first start your VNC or DCV desktop with more than one task, running on one or more nodes.  This is easily done on the [TACC Analysis Portal][TACCANALYSISPORTAL]:

Then start ParaView as above.  Once the GUI appears, **File->connect…** opens the "Choose Server Configuration" dialog.   Select the "auto" configuration to launch a parallel server using one server process on each task allocated above.  The available cores will be meted out to the server processes based on the number of tasks running on each node.

!!!tip
	Running ParaView with an excessive number of nodes and/or processes is often detrimental to overall system performance. Request only the resources you actually need for your job.
 
### Notes on ParaView in Parallel {parallel-notes}


There are several issues to understand. First, there's limited bandwidth into each node; having lots of processors trying to load data in parallel through one data path causes all sorts of congestion. Generally, 4-6 processes per node maximizes the bandwidth onto the node; beyond this, total bandwidth falls off and way beyond this (which 48 processes/node is) it can look like its hung.  In one user's case, 2 nodes 8 processes loads the data in about a second whereas one node, one process loads in 3-4 seconds or so.  The difference rises with the size of the datasets.

Second, lots of processes will only help in one aspect of the overall problem: geometry processing. But, again, it's not without overhead. PV relies on spatial decomposition for parallel processing. In order to get the right answer at inter-partition boundaries, it must maintain 'ghost zones' - regions of actual overlap between the partitions. When the data is partitioned into lots of small chunks, as it is in our user's case, the portion of overlap rises, causing it to do significantly more work.

Next, when the data is distributed, a final image is created by having each process render its local data, then compositing (with depth) to resolve a single image that's correct with respect to all the data. This adds quite a significant overhead to the rendering process, which is engaged whenever you move the viewpoint - which in interactive use happens way more often than, say, computing a new isosurface.

Finally, our large-scale systems (Stampede3, Lonestar6 and Frontera) do not use GPUs for rendering. On Lonestar6 and Frontera we use a software rendering library which is optimized to run on lots of cores and to use the full SIMD architecture of each. When there are lots of processes on each node, the number of cores available to each for rendering is small. Even if we did use GPUs, though, again - lots of processors per node would cause contention for the GPU resources and would still require compositing.

While we wish there was a magic way to optimize ParaView in parallel,  there's not.  The best balance depends on the amount of data being read, the amount of geometry processing required, and the number of rendered frames per timestep that will be needed.  We generally advise users that the big win of running ParaView in parallel is that you get the aggregate bandwidth into memory and the aggregate total memory.  A useful rule of thumb is to use enough nodes to acquire maybe 4x the in-memory size of the input data, and hope that the high-water mark (remember, as you pass your data through PV filters, the intermediate data all increases ParaView's total memory footprint) and then allocate no more than 4-8 processes per node.

### Running ParaView In Batch Mode

It is often useful to run ParaView in batch mode - that is, to run ParaView visualizations as Python scripts without the GUI.  A typical workflow is to use ParaView interactively to set up a visualization, then save the state of the visualization as a Python script that can be tweaked by hand, if necessary.   This resulting script can be run using the `pvbatch` or `pvpython` command-line programs.  

Choose `pvbatch` if the script is intended to run using multiple processes; when wrapped in the `ibrun` script, it runs worker processes as determined by the manner in which the job was started (either by `idev`, by a Slurm script or by the [TACC Analysis Portal][TACCANALYSISPORTAL]).  It requires a Python script as an argument.   The `pvpython` utility, on the other hand, can be run **without** an argument and allows the user to type in statements.

Note that if the parent job does not include a server-side desktop (for example, if it is run by `idev` or using a simple Slurm script), then the **`paraview-osmesa`** module must be loaded.

To run `pvbatch` serially or in parallel, start an `idev` session:

```cmd-line
login2.frontera$ idev -N nNodes -n nTasks -A allocation -p queue
...
c455-003[skx]$ module load impi qt5 swr oneapi_rk paraview-osmesa
```

At that compute-node prompt you can run `pvbatch` and give it your Python script.   As an example, if your Python script is "tt.y" containing:

```job-script
from paraview.simple import *
Sphere()
Show()
SaveScreenshot("tt.png")
```

Then launch `pvbatch`.   On Frontera and Lonestar6 we use the `swr` wrapper; on Stampede3 this is not necessary.

```cmd-line
c455-003[skx]$ ibrun [swr] pvbatch tt.py 
TACC:  Starting up job 9553190 
TACC:  Starting parallel tasks... 
...
TACC:  Shutdown complete. Exiting. 
```

Ignore the scary looking text that emerges.  This will create a file named 'tt.png' containing an image of a sphere:

<figure>
<img src="../imgs/paraview-4.png">
<figcaption></figcaption></figure>

Alternatively, you can run `pvpython` and then enter the above statements at the prompt.  

### Job Script { #scripts } 

You could also launch `pvbatch` using a Slurm job script:

```job-script
#!/bin/bash

#SBATCH -J pvbatch
#SBATCH -o pvbatch.out
#SBATCH -e pvbatch.err
#SBATCH -p skx		       # queue to run in
#SBATCH -N 2		       # Total number of nodes requested
#SBATCH -n 1		       # Total number of processes to run
#SBATCH -t 02:00:00	       # Run time (hh:mm:ss) - 2 hours

module load gcc/9 impi qt5 swr oneapi_rk paraview-osmesa

# go to location of data and Python script

cd $SCRATCH/data

# run pvbatch one or more times (sequentially)

ibrun pvbatch state.py
```


## Visualization Team Notes { #notes } 

While one can write one's own ParaView/Python script by hand, it is often convenient to create a visualization using the ParaView GUI then run it in batch mode.   To do so, save your ParaView state as a Python script, then modify the script (by hand) to write images or save data as required.   See [ParaView/Python Scripting](https://www.paraview.org/Wiki/ParaView/Python_Scripting).

You can also modify this script to, for example, take command-line arguments to vary input and output file names etc.  It is also convenient to modify this script to iterate through data sets.

## References { #refs }

* [ParaView Resources](https://www.paraview.org/resources/)
* [`idev` at TACC][TACCIDEV]


{% include 'aliases.md' %}
