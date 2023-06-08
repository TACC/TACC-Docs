# Managing I/O on TACC Resources
*Last update: June 8, 2023*

The TACC Global Shared File System, <a href="https://www.tacc.utexas.edu/systems/stockyard">Stockyard</a>, is mounted on nearly all TACC HPC resources as the `/work` (`$WORK`) directory. This file system is accessible to all TACC users, and therefore experiences a huge amount of I/O activity (reading and writing to disk) as users run their jobs. This document presents best practices for reducing and mitigating such activity to keep all systems running at maximum efficiency for all TACC users.

## [What is I/O?](#io) { #io }

I/O stands for **I**nput/**O**utput and refers to the idea that for every input to a computer (keyboard input, mouse click, external disk access), there is an output (to the screen, in game play, write to disk). In the HPC environment, I/O refers almost exclusively to disk access: opening and closing files, reading from, writing to, and searching within files. Each of these I/O operations (iops), `open`, `write`, and `close`, access each file system's MetaData Server (MDS). The MDS coordinates access to the `/work` file system for all users. If a file system's MDS is overwhelmed by a user's I/O workflow activities, then that file system could go down for an indeterminate period and all current jobs on that resource may fail.

Examples of intensive I/O activity that could affect the system include, but are not limited to:

* reading/writing 100+ GBs to checkpoint or output files
* running with 4096+ MPI tasks all reading/writing individual files
* Hundreds of concurrent Python jobs, especially those using multiple modules such as `pandas`, `numpy`, `matplotlib`, `mpi4py`, etc.

As TACC's user base continues to expand, the stress on the resources' shared file systems increases daily. TACC staff now recommends new file system and job submission guidelines in order to maintain file system stability. If a user's jobs or activities are stressing the file system, then every other user's jobs and activities are impacted, and the system admins may resort to cancelling the user's jobs and suspending access to the queues. 

!!! note
	If you know your jobs will generate significant I/O, please [submit a support ticket][HELPDESK] and an HPC consultant will work with you.

## [Recommended File Systems Usage](#files) { #files }

Consider that your `/home` (`$HOME`) and `/work` (`$WORK`) directories are for storage and keeping track of important items. The `$WORK` file system is intended to be an area where you can build your code, store your input and output data, and any intermediate results. The `$WORK` fileystem is not designed to handle jobs with large amounts of I/O load or iops. 

**Actual job activity, reading and writing to disk, should be offloaded to your resource's `$SCRATCH` file system.** You can start a job from anywhere but the actual work of the job should occur only on the `$SCRATCH` partition. You can save original items to `$HOME` or `$WORK` so that you can copy them over to `$SCRATCH` if you need to re-generate results.

[Table 1](#table1) outlines TACC's new recommended guidelines for file system usage. <!-- Note that two TACC systems, Longhorn and Maverick2, differ in their file system configurations. Longhorn does not mount the Stockyard file system and therefore has no `$WORK` access. Maverick2 has no `/scratch` file system. -->

## [Table 1. TACC File System Usage Recommendations](#table1) { #table1 }

File System | Recommended Use | Notes
--- | --- | ---
<code>$HOME</code> | cron jobs, scripts and templates, environment settings, compilations | each user's <code>$HOME</code> directory is backed up
<code>$WORK</code>  | software installations, original datasets that can't be reproduced.  | The Stockyard file system is NOT backed up.<br>Ensure that your important data is backed up to <a href="../../hpc/ranch">Ranch</a> long-term storage.
<span style="white-space: nowrap;"><code>$SCRATCH</code> <sup><a href="#sup1">1</a></sup></span> | Reproducible datasets, I/O files: temporary files, checkpoint/restart files, job output files | Not backed up.<br>All <code>$SCRATCH</code> file systems are <b>subject to purge</b> if access time <sup><a href="#sup2">2</a></sup> is more than 10 days old.


<!-- <a id="#sup1">1</a> Maverick2 does not have its own `$SCRATCH` file system. Consult the <a href="../../hpc/maverick2">Maverick2 User Guide</a>'s File Systems section for further guidance.  -->

<a id="#sup2">2</a> The operating system updates a file's access time when that file is modified on a login or compute node. Reading or executing a file/script on a login node does not update the access time, but reading or executing on a compute node does update the access time. This approach helps us distinguish between routine management tasks (e.g. `tar`, `scp`) and production use. Use the command `ls -ul` to view access times.

## [Best Practices for Minimizing I/O](#bestpractices) { #bestpractices }

Here we present guidelines aimed at minimizing I/O impact on all TACC resources. Primarily, this means redirecting I/O activity away from Stockyard (the `$WORK` file system) onto each resource's own local storage: usually the respective `/tmp` or `$SCRATCH` file systems.


### [Use Each Compute Node's `/tmp` Storage Space](#bestpractices-tmp) { #bestpractices-tmp }

Your jobs are run on the compute nodes of each resource and each compute node has a local `/tmp` directory on it. You can use the `/tmp` partition to read/write temporary files that do not need to be accessed by other tasks. If this output data is needed at the end of the job, the files may be copied from `/tmp` to your `$SCRATCH` directory at the end of your batch script. This will greatly reduce the load on the file system and may provide performance improvement.

Data stored in the `/tmp` directory is as temporary as its name indicates, lasting only for the duration of your job. Each MPI task will write output to the `/tmp` directory on the node on which it is running. MPI tasks cannot access data from `/tmp` on different nodes. Each TACC resource's compute nodes host a different amount of `/tmp` space as shown in [Table 2](#table2) below.  Submit a support ticket for more help using this directory/storage.

##		[Table 2. TACC Resources Compute Node (<code>/tmp</code>) Storage](#table2) { #table2 }

Compute Resource | Storage per Compute Node
--- | ---
Frontera | 144 GB
Stampede2 SKX | 144 GB
Stampede2 KNL | 107 GB normal/large<br>32 GB development

### [Run Jobs Out of Each Resource's Scratch File System](#bestpractices-redirect-scratch) { #bestpractices-redirect-scratch }

Each TACC resource has its own Scratch file system, `/scratch`, accessible by the `$SCRATCH` environment variable and the `cds` alias.

**Scratch file systems are not shared across TACC production systems but are specific to one resource. Scratch file systems have neither file count or file size quotas, but are subject to periodic and unscheduled file purges should total disk usage exceed a safety threshold.**

TACC staff recommends you run your jobs out of your resource's `$SCRATCH` file system instead of the global `$WORK` file system. To run your jobs out of `$SCRATCH`, copy (stage) the entire executable/package along with all needed job input files and/or needed libraries to your resource's `$SCRATCH` directory.

Compute nodes should not reference the `$WORK` file system unless it's to stage data in or out, and only before or after jobs.

Your job script should also direct the job's output to the local scratch directory:

```job-script
# stage executable and data
cd $SCRATCH
mkdir testrunA
cp $WORK/myprogram testrunA
cp $WORK/jobinputdata testrunA

# launch program
ibrun testrunA/myprogram testrunA/myinputdata &gt; testrunA/output

# copy results back permanent storage once job is done
cp testrunA/output $WORK/savetestrunA
```



### [Avoid Writing One File Per Process](#bestpractices-perprocess) { #bestpractices-perprocess }

If your program regularly writes data to disk from each process, for instance for checkpointing, avoid writing output to a separate file for each process, as this will quickly overwhelm the Metadata Server. Instead, employ a library such as `hdf5` or `netcdf` to write a single parallel file for the checkpoint. A one-time generation of one file per process (for instance at the end of your run) is less serious, but even then you should consider writing parallel files.

Alternatively, you could write these per-process files to each compute node's `/tmp` directory, see <a href="#bestpractices-redirect-scratch">below</a>.


### [Avoid Repeated Reading/Writing to the Same File](#bestpractices-contention) { #bestpractices-contention }

Jobs that have multiple tasks that read and/or write to the same file will often suspend the file in question in an open state in order to accommodate the changes happening to it. Please make sure that your I/O activity is not being directed to a single file repeatedly. You can use `/tmp` on the node to store this file if the condition cannot be avoided. If you require shared file operations, then please ensure your I/O is optimized.

If you anticipate the need for multiple nodes or processes to write to a single file in parallel (aka single file with multiple writers/collective writers), please [submit a support ticket][HELPDESK] for assistance.


### [Monitor Your File System Quotas](#bestpractices-quotas) { #bestpractices-quotas }

If you are close to file quota on either the `$WORK` or `$HOME` file system, your job may fail due to being unable to write output, and this will cause stress to the file systems when attempting to write beyond quota. It's important to monitor your disk and file usage on all TACC resources where you have an allocation.

Monitor your file system's quotas and usage using the `taccinfo` command. This output displays whenever you log on to a TACC resource.

{% include "include/tinfo.md" %}

```cmd-line
---------------------- Project balances for user <user> ----------------------
| Name           Avail SUs     Expires | Name           Avail SUs     Expires |
| Allocation             1             | Alloc                100             |
------------------------ Disk quotas for user <user>  -------------------------
| Disk         Usage (GB)     Limit    %Used   File Usage       Limit   %Used |
| /home1              1.5      25.0     6.02          741      400000    0.19 |
| /work             107.5    1024.0    10.50         2434     3000000    0.08 |
| /scratch1           0.0       0.0     0.00            3           0    0.00 |
| /scratch3       41829.5       0.0     0.00       246295           0    0.00 |
-------------------------------------------------------------------------------
```



### [Manipulate Data in Memory, not on Disk](#bestpractices-memory) { #bestpractices-memory }

Manipulate data in memory instead of files on disk when necessary. This means:

* For unimportant data that do not need a backup, process that data directly in memory.
* For any commands in the intermediate steps, process those commands directly in memory instead of creating extra script files for them.

### [Stripe Large Files on `$SCRATCH` and `$WORK`](#striping) { #striping }

When transferring or creating large files, it's important that you stripe the receiving directory. See the respective "Striping Large Files" sections in the [Stampede2](../../hpc/stampede2#files-striping]) and [Frontera](../../hpc/frontera#striping-large-files) user guides. 


## [Govern I/O with OOOPS](#ooops) { #ooops }

TACC staff has developed OOOPS, **O**ptimal **O**verloaded I/O **P**rotection **S**ystem, an easy-to-use tool to help HPC users optimize heavy I/O requests and reduce the impact of high I/O jobs.  If your jobs have a particularly high I/O footprint, then you must employ the OOOPS tool to govern that I/O activity.

!!! note
	Employing OOOPS may slow down your job significantly if your job has a lot of I/O.

The OOOPS module is currently installed on TACC's [Frontera](../../hpc/frontera) and [Stampede2](../../hpc/stampede2) resources.


### [Functions](#ooops-functions) { #ooops-functions }

The OOOPS module provides two functions `set_io_param` and `set_io_param_batch` for single-node jobs and multiple-node jobs, respectively. These commands adjust the maximum allowed frequency of `open` and `stat` function calls on all compute nodes involved in a running job. Execute these two commands within a Slurm job script or within an `idev` session. 

These functions instruct the system to modulate your job's I/O activity, thus reducing the impact on the designated file system. For both functions, use "0" to indicate the `$SCRATCH` file system and "1" to indicate the `$WORK` file system. 

!!! note
	These indices are subject to change. See each command's `help` option to ensure correct parameters:

```cmd-line
c123-456$ set_io_param -h
```

Indicate the frequency of `open` and `stat` function calls, from the least to the most, with `low`, `medium`, or `high`.

### [How to Use OOOPS](#ooops-howto) { #ooops-howto }

First, load the `ooops` module in your job script or `idev` session to deploy OOOPS. Next, set the frequency of I/O activities using either the `set_io_param` or `set_io_param_batch` command. 

#### [Example: Single-Node Job on `$SCRATCH`](#ooops-howto-singlenode) { #ooops-howto-singlenode }

<table border="1">
<tr><th>Job Script Example</th><th>Interactive Session Example</th></tr>
<tr><td>
```job-script
#SBATCH -N 1
#SBATCH -J myjob.%j
...
module load ooops 
set_io_param 0 low 
ibrun myprogram 
```

</td>
<td width="450" valign="top">
```job-script
login1$ idev -N 1
...
c123-456$ module load ooops
c123-456$ set_io_param 0 low
c123-456$ ibrun myprogram
```
</td></tr></table>
		
To turn off throttling on the `$SCRATCH` file system for a submitted job, run the following command on a login node or within an `idev` session while the job is running:

```cmd-line
login1$ set_io_param 0 unlimited
```


#### [Example: Multi-Node Job on `$SCRATCH`](#ooops-howto-multinode) { #ooops-howto-multinode }

<table border="1"><tr>
<th>Job Script Example</th>
<th>Interactive Session Example</th></tr>
<tr>
<td width="450" valign="top"> 
	```job-script
	#SBATCH -N 4<br>#SBATCH -n 64<br>#SBATCH -J myjob.%j
	...
	module load ooops
	set_io_param_batch $SLURM_JOBID 0 low
	ibrun myprogram
    ```

</td>
<td width="450" valign="top">
	```job-script
	login1$ idev -N 4
	...
	c123-456$ module load ooops
	c123-456$ set_io_param_batch [jobid] 0 low
	c123-456$ ibrun myprogram
	```

</td></tr></table>

To turn off throttling on the `$SCRATCH` file system for a submitted job, you can run the following command (on a login node) after the job is submitted:

```cmd-line
login1$ set_io_param_batch [jobid] 0 unlimited
```

### [I/O Warning](#ooops-warnings) { #ooops-warnings }

If OOOPS finds intensive I/O work in your job, it will print out warning messages and create an `open`/`stat` call report after the job finishes. To enable reporting, load the OOOPS module on a login node, and then submit your batch job.  The reporting function will not be enabled if the module is loaded within a batch script.

<!-- ### [Developers](#ooops-dev) { #ooops-dev }
Contact the OOOPS developers, <a href="mailto:huang@tacc.utexas.edu">Lei Huang</a> and <a href="mailto:siliu@tacc.utexas.edu">Si Liu</a>, with any OOOPS related questions. -->


## [Python I/O Management](#python) { #python }

For jobs that make use of large numbers of Python modules or use local installations of Python/Anaconda/MiniConda, TACC staff provides additional tools to help manage the I/O activity caused by library and module calls.

**On Stampede2 and Frontera**: Load the `python_cacher` module in your job script:

```job-script
module load python_cacher
```

 This library will cache python modules to local disk so python programs won't keep pulling the modules over and over from the `/scratch` or `/work` file systems.

In case `python_cacher` does not work, you can copy your Python/Anaconda/MiniConda directory to the local `/tmp` directory of each involved compute node for a specific job. 


## [Tracking Job I/O](#tracking) { #tracking }

**Stampede2 and Frontera**: To track the full extent of your I/O activity over the course of your job, you can employ another TACC tool, `iomonitor` that will report on `open()` and `stat()` calls during your job's run. Place the following lines in your job submission script after your Slurm commands, to wrap your executable:

```job-script
export LD_PRELOAD=/home1/apps/tacc-patches/io_monitor/io_monitor.so:\
	/home1/apps/tacc-patches/io_monitor/hook.so
ibrun my_executable
unset LD_PRELOAD
```

Log files will be generated during the job run in the working directory with prefix `log_io_*.`

**Note**: Since the `iomonitor` tool may itself generate a lot of files, we highly recommend you profile your job beginning with trivial cases, then ramping up to the desired number of nodes/tasks.

Please feel free to [submit a support ticket][HELPDESK] if you need any further assistance.

## [I/O Do's and Don'ts](#table3) { #table3 }
 
DON'TS<br>Try to avoid | DO'S<br>Recommended Workflow
--- | ---
Use <code>$HOME</code> or <code>$WORK</code> for production jobs | Use <code>$SCRATCH</code> for production jobs<br>Take advantage of the local <code>/tmp</code> space if possible
Keep thousands of files in on a single directory | Create subdirectories and keep files in separate subdirectories
Work with many tiny files | Work with large files if possible<br>Use the local <code>/tmp</code> space if possible
Create files on disk for unnecessary data or commands | Process data that do not require a backup directly in memory<br>Process intermediate commands directly in memory instead of creating additional script files
Use a single stripe for large files | Use a single stripe for small files<br>Stripe large files on the Lustre file systems
Conduct open/close/state operations repetitively | Open/close only once for each file if possible<br>Reduce the state call frequency if possible
Use many processes to work simultaneously on the same file | Use scalable Parallel I/O libraries, like phdf5, pnetcdf, PIO<br> Limit the number of processes for I/O work (one processor per node is a good start)<br>Make copies of the required files in advance when necessary
Perform high frequency I/O work | Keep the data in memory if possible<br>Reduce the frequency of the I/O work<br>Limit the number of concurrent jobs<br>Take advantage of OOOPS
Perform large-scale runs with R/Python on <code>$HOME</code>/<code>$WORK</code> | Install Python/R modules under <code>$SCRATCH</code><br> Copy Python/R modules under <code>/tmp</code> for large-scale runs Use Python_Cacher
Overlook I/O pattern and I/O workload | Use profilers or I/O monitoring tools when necessary

{% include 'aliases.md' %}


