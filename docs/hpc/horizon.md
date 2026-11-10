# Horizon User Guide 
*Last update: November 10, 2026*

!!! info 
	This user guide is a draft in progress.  You may submit feedback via support ticket or PR.

## Notices { #notices }

* Horizon is still limited only to internal users. (07/24/2026)
* **[Subscribe][TACCSUBSCRIBE] to Horizon User News**. Stay up-to-date on Horizon's status, scheduled maintenances and other notifications.  (04/15/2026) 

{% include 'include/ai.md' %}

## Introduction { #intro }

Horizon is a National Science Foundation-funded system that is part of the the Leadership Class Computing Facility (LCCF) award, [Award Abstract #2323116](https://www.nsf.gov/awardsearch/show-award/?AWD_ID=2323116).  Please [reference TACC](https://tacc.utexas.edu/about/citing-tacc/) when providing any citations. 

### Allocations { #intro-allocations }

* [LCCF Allocations](https://lccf.tacc.utexas.edu/allocations/)
* [National Artificial Intelligence Research Resource Pilot (NAIRR)](https://nairrpilot.org/)
* [TxRAS](https://submit-tacc.xras.org) 



## System Specifications  { #system }

Developed in collaboration with Dell Technologies, NVIDIA, VAST Data, Spectra Logic, Versity, and Sabey Data Centers, the Horizon supercomputer combines cutting-edge technologies with advanced infrastructure to redefine what is possible in scientific computing.

| Specification                      | Value
| -----                              | ----- |
| Performance<br>GPU component only) | 160 petaflops (FP64 units)<br>320 petaflops (FP32 units)<p>~288 petaflops<br>(DGEMM using Ozaki method)
| AI Performance                     | 20 exaflops for AI at BF16/FP16<br>40 exaflops for AI at FP8<br>80 exaflops for AI at FP4 |
| Scale                              | NVIDIA Grace Blackwell platform featuring 4,000 GPUs and NVIDIA Vera Vera servers featuring 4752 nodes |
| Networking                         | Interconnected by the NVIDIA Quantum-x800 InfiniBand networking platform |
| Local All-Solid State Storage      | up to 200PB of storage delivering more than 8TB/s of read/write bandwidth along with multi-tenancy and Quality-of-Service capabilities. |
| Efficiency                         | Up to 6x more energy efficient, powered by a new 20 MW data center with advanced liquid cooling in Round Rock, Texas. |

### Grace Blackwell Compute Nodes

Horizon hosts 1,000 Grace Blackwell (GB) nodes. The Grace Blackwell (GB) subsystem consists of nodes using the GB200 NVL4 platform. The NVL4 platform is configured with 4 NVIDIA Blackwell GPUs each with 185 GiB of HBM3 memory and 2 Grace CPUs each with 478 GiB of LPDDR5X memory and 72 cores. 

A GB node provides 160 TFlops of FP64 performance and 20 PFlops of FP16 performance for ML workflows. The GB subsystem is housed in 28 racks, each containing 36 GB nodes. These nodes connect via an NVIDIA dual-rail InfiniBand 800 Gb/s fabric to NVIDIA XDR InfiniBand switches using a fully connected two-level fat-tree topology. There are two 800 Gb/s connections per node.


#### Table 1. Grace Blackwell Specifications

| Specification | Value |
| ----- | ----- |
| GPU: | Blackwell, GB200 |
| GPU Memory: | 185 Gib |
| Total GPUs per node: | 4 GB200s, NVLink connected
| CPU: | NVIDIA Grace CPU |
| Total CPU cores per node: | 72 cores per socket, 2 sockets per node
| Hardware threads per core: | 1
| Hardware threads per node: | 144 
| Clock rate: | 3.4 GHz |
| Memory: | 478 GiB LPDDR |
| Cache: | 64 KB L1 data cache per core; 1MB L2 per core; 114 MB L3 |
| Local storage: | 57 GiB |
| DRAM: | LPDDR5 |

### Vera Vera Compute Nodes

#### Table 2. Vera Vera Specifications

| Specification | Value |
| ----- | ----- |
| CPU: | NVIDIA Vera CPU |
| Total cores per node: | 176 cores on two sockets (2 x 88)  |
| Hardware threads per core: | 2 (Spatial Multi-Threading) |
| Hardware threads per node: | 2 x 88 x 2 = 352 |
| Clock rate: | TBA |
| Memory: | 768 GB LPDDR |
| Cache: | TBA |
| Local storage: | 240 GB |
| DRAM: | LPDDR5 |

Horizon hosts 4752 "Vera Vera" (VV) nodes with 176 cores each. Each VV node provides a performance increase of  over 3x compared to Frontera's CLX nodes and ~2x compared to the Grace Grace nodes of Vista.  This improved performance per node is due to increase in core count, 176 vs 144, an increase in vector units per core, 6 vs 4, and an increase in memory bandwidth, 2.4 TB/s vs 1 TB/s. Each VV node provides over 13 TFlops of double precision performance and over 2 TiB/s of memory bandwidth.


### Login Nodes

The Horizon login nodes are Grace Grace (GG) nodes with 144 cores and 237 GB of LPDDR. They are compatible with the NVIDIA and GNU software stacks installed for the GB and VV nodes.

### Network

The interconnect is based on Mellanox XDR technology with full XDR (800 Gb/s) connectivity between the switches and the GB GPU nodes and with XDR400 (400 Gb/s) connectivity to the VV compute nodes. A fat tree topology fully connects the compute nodes and the GPU nodes within separate trees with no over subscription within each tree.  Every GB node is fully connected using full XDR (800 Gb/s) to every other GB node.  Every VV node is fully connected using XDR400 (400 Gb/s) to every other VV node. Both sets of nodes are connected to the `$HOME` and `$SCRATCH` file systems via Infiniband.


## Managing Your Files { #files }

### Horizon Filesystems

Horizon will use a shared VAST file system for the `$HOME` and `$SCRATCH` directories.

!!! warning
	The `$WORK` filesystem will not be available for early users.  A `$WORK` filesystem will be available in late 2026.  The `/tmp` partition is also available to users but is local to each node. 


#### Table 3. File Systems { #table3 }

*in progress*

| File System | Type     | Quota                               | Key Features
| -----       | -----    | -----                               | -----|
| `$HOME`    | VAST      | TBD                                 | Not intended for parallel or high−intensity file operations.<br>Backed up daily. 
| `$WORK`    | VAST      | TBD                                 | Not backed up.
| `$SCRATCH` | VAST      | no quota Overall capacity ~400 PB. | Not backed up.<br>Files are subject to purge if access time\* is more than 10 days old. See TACC's Scratch File System Purge Policy below.


{% include 'include/scratchpolicy.md' %}


### Navigating the Shared File Systems { #files-filesystems }

Horizon mounts three file systems that are shared across all nodes: the home, work, and scratch file systems. Horizon's startup mechanisms define corresponding account-level environment variables `$HOME`, `$SCRATCH`, and `$WORK` that store the paths to directories that you own on each of these file systems.  <!-- Consult the Horizon [File Systems](#table6) table for the basic characteristics of these file systems, [File Operations: I/O Performance](#programming-io) for advice on performance issues, and [Good Conduct][TACCGOODCONDUCT] for tips on file system etiquette. -->

{% include 'include/spacetip.md' %}


Horizon's `/home` and `/scratch` file systems are mounted only on Horizon, but the work file system mounted on Horizon is the Global Shared File System hosted on [Stockyard](https://tacc.utexas.edu/systems/stockyard/).  Stockyard is the same work file system that is currently available on Frontera, Lonestar6, and several other TACC resources.

The `$STOCKYARD` environment variable points to the highest-level directory that you own on the Global Shared File System. The definition of the `$STOCKYARD` environment variable is of course account-specific, but you will see the same value on all TACC systems that provide access to the Global Shared File System. This directory is an excellent place to store files you want to access regularly from multiple TACC resources.

Your account-specific `$WORK` environment variable varies from system to system and is a sub-directory of `$STOCKYARD` (Figure 1). The sub-directory name corresponds to the associated TACC resource. The `$WORK` environment variable on Horizon points to the `$STOCKYARD/horizon` subdirectory, a convenient location for files you use and jobs you run on Horizon. Remember, however, that all subdirectories contained in your `$STOCKYARD` directory are available to you from any system that mounts the file system. If you have accounts on both Horizon and Frontera, for example, the `$STOCKYARD/horizon` directory is available from your Frontera account, and `$STOCKYARD/frontera` is available from your Horizon account.

!!! note 
	Your quota and reported usage on the Global Shared File System reflects **all files that you own on Stockyard**, regardless of their actual location on the file system.

See the example for fictitious user bjones in the figure below.  All directories are accessible from all systems, however a given sub-directory (e.g. lonestar6, frontera) will exist only if you have an allocation on that system.  [Figure 1](#figure1) below illustrates account-level directories on the `$WORK` file system (Global Shared File System hosted on Stockyard).   

<figure id="figure1"><img src="../imgs/stockyard-2026.png">
<figcaption>Stockyard 2026</figcaption></figure>

Note that the resource-specific sub-directories of `$STOCKYARD` are nothing more than convenient ways to manage your resource-specific files. You have access to any such sub-directory from any TACC resources. If you are logged into Horizon, for example, executing the alias cdw (equivalent to cd `$WORK`) will take you to the resource-specific sub-directory `$STOCKYARD/horizon`. But you can access this directory from other TACC systems as well by executing cd `$STOCKYARD/horizon`. These commands allow you to share files across TACC systems. In fact, several convenient account-level aliases make it even easier to navigate across the directories you own in the shared file systems:

### Table X. Built-in Account Level Aliases { #table7 }

Alias | Command
--- | ---
`cd` or `cdh` | `cd $HOME`
`cdw` | `cd $WORK`
`cds` | `cd $SCRATCH`
`cdy` or `cdg` | `cd $STOCKYARD`


### Sharing Files with Collaborators { #files-sharing }

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems][TACCSHARINGPROJECTFILES] for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.

----
File Systems

Horizon will use a shared VAST file system for the $HOME and $SCRATCH directories.

!!! important 
	Horizon's $HOME and $SCRATCH file systems are NOT Lustre file systems and do not support setting a stripe count or stripe size.  

!!! important
	The $WORK filesystem will not be available for early users.  A $WORK filesystem will be made available later in 2026.  Each node's `/tmp` partition is also available to users but is local to each node. 


Table 3. File Systems
File System
Type
Quota
Key Features
$HOME
VAST
TBD 
Not intended for parallel or high−intensity file operations.
Backed up regularly.
$WORK
VAST
TBD
Not backed up.
$SCRATCH
VAST
no quota
Overall capacity ~400 PB.
Not backed up.
Files are subject to purge if access time* is more than 10 days old. See TACC's Scratch File System Purge Policy below.


## Running Jobs { #running }

<!-- ### Slurm Job Scheduler { #running-slurm } -->

Like all other current TACC systems, Horizon employs the Slurm Workload Manager as it's job scheduler.  Slurm commands enable you to submit, manage, monitor, and control your jobs.  <!-- See the [Job Management](#jobmanagement) section below for further information. -->

### Slurm Partitions (Queues) { #queues }

!!! caution
    **Queue limits are subject to change without notice.**
    Horizon admins may occasionally adjust queue settings in order to ensure fair scheduling for the entire user community.
    TACC's `qlimits` utility will display the latest queue configurations.

A Grace Blackwell node contains 2 Grace CPUs and 4 Blackwell GPUs. The node is composed of 2 Grace/Blackwell/Blackwell boards connected via NVLink.  One SU is charged per Grace/Blackwell/Blackwell.  So, a regular GPU node is charged at 2 SUs per node hour.  

There are shared queues that allow a user to request one or two GPUs to efficiently use the system.  In the shared queue, the charge is .5 SUs per GPU.  <!-- Examples submitting to the shared queues are below. -->


#### Table 4. Production Queues { #table4 }

| Queue Name    | Node Type       | Max Nodes per Job     | Max Job Duration | Charge Rate (per node-hour) 
| -----         | -----           | -----                 | -----            | -----                       
| `gpu-shared`  | Grace Blackwell | 3 (Max GPUs per job)  | 48 hrs           | .5 SUs (per GPU-hour)
| `gpu-dev`     | Grace Blackwell | 8                     | 2 hrs            | 2 SUs
| `gpu`         | Grace Blackwell | 64                    | 48 hrs           | 2 SUs
| `gpu-large`   | Grace Blackwell | 256                   | 48 hrs           | 2 SUs
| `cpu-dev`     | Vera Vera       | 32                    | 2 hrs            | 0.3 SUs
| `cpu`         | Vera Vera       | 256                   | 48 hrs           | 0.3 SUs
| `cpu-large`   | Vera Vera       | 1024                  | 48 hrs           | 0.3 SUs


{% include 'include/horizon-jobaccounting.md' %}

<!---
Cazes add to accounting sectioin
Job Accounting

Horizon’s accounting and allocation system is based on resource usage over time.  One  Service Unit (SU) represents a single Grace/Blackwell/Blackwell component.  One Horizon GPU node contains two of these components and is charged at 2 SUs.   

When running in the gpu-shared queue, a user may request one or two GPUs.  One GPU will be charged at .5 SUs/hour, while 2 GPUs will be charged at 1 SU/hour.

The VeraVera CPU nodes are less performant than a Blackwell GPU and will be charged at .3 SUs/hour. 
-->


### Submitting Batch Jobs with `sbatch` { #running-sbatch }

Use Slurm's `sbatch` command to submit a batch job to one of the Horizon queues:

```cmd-line
login1$ sbatch myjobscript
```

Where `myjobscript` is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting. The details of your job script's contents depend on the type of job you intend to run.

In your job script you (1) use `#SBATCH` directives to request computing resources (e.g. 10 nodes for 2 hrs); and then (2) use shell commands to specify what work you're going to do once your job begins. There are many possibilities: you might elect to launch a single application, or you might want to accomplish several steps in a workflow. You may even choose to launch more than one application at the same time. The details will vary, and there are many possibilities. But your own job script will probably include at least one launch line that is a variation of one of the examples described here.

Your job will run in the environment it inherits at submission time; this environment includes the modules you have loaded and the current working directory. In most cases you should run your applications(s) after loading the same modules that you used to build them. You can of course use your job submission script to modify this environment by defining new environment variables; changing the values of existing environment variables; loading or unloading modules; changing directory; or specifying relative or absolute paths to files. **Do not** use the Slurm `--export` option to manage your job's environment: doing so can interfere with the way the system propagates the inherited environment.

[Table 5.](#table5) below describes some of the most common `sbatch` command options. Slurm directives begin with `#SBATCH`; most have a short form (e.g. `-N`) and a long form (e.g. `--nodes`). You can pass options to `sbatch` using either the command line or job script; most users find that the job script is the easier approach. The first line of your job script must specify the interpreter that will parse non-Slurm commands; in most cases `#!/bin/bash` or `#!/bin/csh` is the right choice. Avoid `#!/bin/sh` (its startup behavior can lead to subtle problems on Horizon), and do not include comments or any other characters on this first line. All `#SBATCH` directives must precede all shell commands. Note also that certain `#SBATCH` options or combinations of options are mandatory, while others are not available on Horizon.

By default, Slurm writes all console output to a file named "`slurm-%j.out`", where `%j` is the numerical job ID. To specify a different filename use the `-o` option. To save `stdout` (standard out) and `stderr` (standard error) to separate files, specify both `-o` and `-e` options.

!!! tip
	The maximum runtime for any individual job is 48 hours.  However, if you have good checkpointing implemented, you can easily chain jobs such that the outputs of one job are the inputs of the next, effectively running indefinitely for as long as needed.  See Slurm's `-d` option.

#### Table 5. Common `sbatch` Options { #table5 }

Option | Argument | Comments
--- | --- | ---
`-A`  | *projectid* | Charge job to the specified project/allocation number. This option is only necessary for logins associated with multiple projects.
`-a`<br>or<br>`--array` | =*tasklist* | Horizon supports Slurm job arrays.  See the [Slurm documentation on job arrays](https://slurm.schedmd.com/job_array.html) for more information.
`-d=` | afterok:*jobid* | Specifies a dependency: this run will start only after the specified job (jobid) successfully finishes
`-export=` | N/A | Avoid this option on Horizon. Using it is rarely necessary and can interfere with the way the system propagates your environment.
`--gres` | N/A | Horizon does not support this option. Slurm will reject any job script containing this directive.
`--gpus-per-task` | N/A | Horizon does not support this option. Slurm will reject any job script containing this directive.
`-p`  | *queue_name* | Submits to queue (partition) designated by queue_name
`-J`  | *job_name*   | Job Name
`-N`  | *total_nodes* | Required. Define the resources you need by specifying either:<br>(1) `-N` and `-n`; or<br>(2) `-N` and `-ntasks-per-node`.
`-n`  | *total_tasks* | This is total MPI tasks in this job. See `-N` above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set it to the same value as `-N`.
`-ntasks-per-node`<br>or<br>`-tasks-per-node` | tasks_per_node | This is MPI tasks per node. See `-N` above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set `-ntasks-per-node` to 1.
`-t`  | *hh:mm:ss* | Required. Wall clock time for job.
`-mail-type=` | `begin`, `end`, `fail`, or `all` | Specify when user notifications are to be sent (one option per line).
`-mail-user=` | *email_address* | Specify the email address to use for notifications. Use with the `-mail-type=` flag above.
`-o`  | *output_file* | Direct job standard output to output_file (without `-e` option error goes to this file)
`-e`  | *error_file* | Direct job error output to error_file
`-mem`  | N/A | Not available. If you attempt to use this option, the scheduler will not accept your job.


## Launching Applications { #launching }

The primary purpose of your job script is to launch your research application. How you do so depends on several factors, especially (1) the type of application (e.g. MPI, OpenMP, serial), and (2) what you're trying to accomplish (e.g. launch a single instance, complete several steps in a workflow, run several applications simultaneously within the same job). While there are many possibilities, your own job script will probably include a launch line that is a variation of one of the examples described in this section:


!!! important
	The following examples demonstrate launching within a Slurm job script or an `idev` session.  
	Do not launch jobs on the login nodes. See TACC's [Good Conduct Policy][TACCGOODCONDUCT] for more information.

### One Serial Application { #launching-serial }

To launch a serial application, simply call the executable. Specify the path to the executable in either the `$PATH` environment variable or in the call to the executable itself:

``` job-script
myprogram                      # executable in a directory listed in $PATH
$WORK/apps/myprov/myprogram    # explicit full path to executable
./myprogram                    # executable in current directory
./myprogram -m -k 6 input1     # executable with notional input options
```

### One Multi-Threaded Application { #launching-multithreaded }

Launch a threaded application the same way. Be sure to specify the number of threads. Note that the default OpenMP thread count is 1.

``` job-script
export OMP_NUM_THREADS=176     # 176 total OpenMP threads (1 per Vera-Vera core)
./myprogram
```


### One MPI Application { #launching-mpi }

To launch an MPI application, use the TACC-specific MPI launcher `ibrun`, which is a Horizon-aware replacement for generic MPI launchers like `mpirun` and `mpiexec`. In most cases the only arguments you need are the name of your executable followed by any arguments your executable needs. When you call `ibrun` without other arguments, your Slurm `#SBATCH` directives will determine the number of ranks (MPI tasks) and number of nodes on which your program runs.

``` job-script
#SBATCH -N 4
#SBATCH -n 704
ibrun ./myprogram              # ibrun uses the $SBATCH directives to properly allocate nodes and tasks
```
To use `ibrun` interactively, say within an `idev` session, you can specify:

``` cmd-line
login1$ idev -N 2 -n 80 -p cpu
c123-456$ ibrun ./myprogram    # ibrun uses idev's arguments to properly allocate nodes and tasks
```

### One Hybrid (MPI+Threads) Application { #launching-hybrid }

When launching a single application you generally don't need to worry about affinity: both OpenMPI and MVAPICH2 will distribute and pin tasks and threads in a sensible way.

``` job-script
export OMP_NUM_THREADS=8    # 8 OpenMP threads per MPI rank
ibrun ./myprogram           # use ibrun instead of mpirun or mpiexec
```
As a practical guideline, the product of `$OMP_NUM_THREADS` and the maximum number of MPI processes per node should not be greater than total number of cores available per node (cpu  nodes have 176 cores, gpu nodes have 144 cores).

### MPI Applications - Consecutive { launching-mpi-consecutive }

To run one MPI application after another (or any sequence of commands one at a time), simply list them in your job script in the order in which you'd like them to execute. When one application/command completes, the next one will begin.

```job-script
module load git
module list
./preprocess.sh
ibrun ./myprogram input1    # runs after preprocess.sh completes
ibrun ./myprogram input2    # runs after previous MPI app completes
```

### MPI Application - Concurrent { launching-mpi-concurrent }

*Coming soon.*


### More than One OpenMP Application Running Concurrently { #launching-openmp }

You can also run more than one OpenMP application simultaneously on a single node, but you will need to distribute and pin tasks appropriately. In the example below, numactl -C specifies virtual CPUs (hardware threads). According to the numbering scheme for GG cores, CPU () numbers 0-143 are spread across the 144 cores, 1 thread per core.

``` job-script
export OMP_NUM_THREADS=2
numactl -C 0-1 ./myprogram inputfile1 &  # HW threads (hence cores) 0-1. Note ampersand.
numactl -C 2-3 ./myprogram inputfile2 &  # HW threads (hence cores) 2-3. Note ampersand.

wait
```

### Shared Queue Jobs

To launch a slurm job in the shared queue, `gpu-shared`, you must also select the number of GPUs that you want to use.  This can be done either on the command line:

```cmd-line
sbatch --gpus=2 <slurm_batch_script>
```

or within a batch script using an SBATCH directive:

```job-script
#SBATCH --gpus=2  #Requests 2 GPUs from a shared node            
```

**These options are only available for the `gpu-shared` queue**.  You may request 1, 2, or 3 gpus and will be charged .5, 1.0, or 1.5 SUs respectively.


### Interactive Sessions { #launching-interactive }

#### Interactive Sessions with `idev` and `srun` { #launching-interactive-idev }

TACC's own `idev` utility is the best way to begin an interactive session on one or more compute nodes. To launch a thirty-minute session on a single node in the development queue, simply execute:

``` cmd-line
login1$ idev
```

You'll then see output that includes the following excerpts:
```cmd-line
...
-----------------------------------------------------------------
      Welcome to the Horizon Supercomputer          
-----------------------------------------------------------------
...

-> After your `idev` job begins to run, a command prompt will appear,
-> and you can begin your interactive development session. 
-> We will report the job status every 4 seconds: (PD=pending, R=running).

->job status:  PD
->job status:  PD
...
c449-001$
```

The job status messages indicate that your interactive session is waiting in the queue. When your session begins, you'll see a command prompt on a compute node (in this case, the node with hostname c449-001). If this is the first time you launch `idev`, the prompts may invite you to choose a default project and a default number of tasks per node for future `idev` sessions.

The `idev` utility also supports the `-g` flag to specify the number of GPUs for the shared queue. This option only works for shared queues.


For command line options and other information, execute `idev --help`. It's easy to tailor your submission request (e.g. shorter or longer duration) using Slurm-like syntax:

``` cmd-line
login1$ idev -p gpu -N 2 -n 8 -m 150 # gpu queue, 2 nodes, 8 total tasks, 150 minutes
```

For more information [see the `idev` documentation][TACCIDEV].

#### Interactive Sessions using `ssh` { #launching-interactive-ssh }

If you have a batch job or interactive session running on a compute node, you "own the node": you can connect via ssh to open a new interactive session on that node. This is an especially convenient way to monitor your applications' progress. One particularly helpful example: login to a compute node that you own, execute top, then press the "1" key to see a display that allows you to monitor thread ("CPU") and memory use.

There are many ways to determine the nodes on which you are running a job, including feedback messages following your sbatch submission, the compute node command prompt in an `idev` session, and the `squeue` or `showq` utilities. The sequence of identifying your compute node then connecting to it would look like this:

``` cmd-line
login1$ squeue -u bjones
 JOBID       PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
858811     skx-dev     idv46796   bjones  R       0:39      1 c448-004
1ogin1$ ssh c448-004
...
C448-004$
```
### Slurm Environment Variables { #launching-slurmenvs }

Be sure to distinguish between internal Slurm replacement symbols (e.g. `%j` described above) and Linux environment variables defined by Slurm (e.g. `SLURM_JOBID`). Execute `env | grep SLURM` from within your job script to see the full list of Slurm environment variables and their values. You can use Slurm replacement symbols like `%j` only to construct a Slurm filename pattern; they are not meaningful to your Linux shell. Conversely, you can use Slurm environment variables in the shell portion of your job script but not in an `#SBATCH` directive.

!!! caution 
	For example, the following directive will not work the way you might think:
	``` job-script
	#SBATCH -o myMPI.o${SLURM_JOB_ID}   # incorrect
	```
!!! tip 
	Instead, use the following directive:
	``` job-script
	#SBATCH -o myMPI.o%j     # "%j" expands to your job's numerical job ID
	```

Similarly, you cannot use paths like `$WORK` or `$SCRATCH` in an `#SBATCH` directive.

For more information on this and other matters related to Slurm job submission, see the [Slurm online documentation](https://slurm.schedmd.com/sbatch.html); the man pages for both Slurm itself (`man slurm`) and its individual commands (e.g. `man sbatch`); as well as numerous other online resources.



## Job Management { #jobs }

In this section, we present several Slurm commands and other utilities that are available to help you plan and track your job submissions as well as check the status of the Slurm queues.

!!!important
	When interpreting queue and job status, remember that **Horizon does not operate on a first-come-first-served basis**. Instead, the sophisticated, tunable algorithms built into Slurm attempt to keep the system busy, while scheduling jobs in a way that is as fair as possible to everyone. At times this means leaving nodes idle ("draining the queue") to make room for a large job that would otherwise never run. It also means considering each user's "fair share", scheduling jobs so that those who haven't run jobs recently may have a slightly higher priority than those who have.

### Monitoring Queue Status { #jobs-monitoring }

Monitor queue status via Slurm's `sinfo` command and/or TACC's `qlimits` utility.

#### TACC's `qlimits` command { #jobs-monitoring-qlimits }

To display resource limits for the Lonestar queues, execute: `qlimits`. The result is real-time data; the corresponding information in this document's [table of Horizon queues](#queues) may lag behind the actual configuration that the `qlimits` utility displays.

#### Slurm's `sinfo` command { #jobs-monitoring-sinfo }

Slurm's `sinfo` command allows you to monitor the status of the queues. If you execute `sinfo` without arguments, you'll see a list of every node in the system together with its status. To skip the node list and produce a tight, alphabetized summary of the available queues and their status, execute:

```cmd-line
login1$ sinfo -S+P -o "%18P %8a %20F"    # compact summary of queue status
```
This command's output might look like this:

```cmd-line
PARTITION          AVAIL    NODES(A/I/O/T)
gpu                up       951/4/5/960
gpu-dev*           up       18/22/2/40
gpu-large          up       951/4/5/960
gpu-shared         up       18/22/2/40
```
	
The `AVAIL` column displays the overall status of each queue (up or down), while the column labeled `NODES(A/I/O/T)` shows the number of nodes in each of several states ("**A**llocated", "**I**dle", "**O**ffline", and "**T**otal"). Execute `man sinfo` for more information. Use caution when reading the generic documentation, however: some available fields are not meaningful or are misleading on Horizon (e.g. `TIMELIMIT`, displayed using the `%l` option).

### Monitoring Job Status { #jobs-monitoring-jobstatus }

Monitor your job's status in the queue via Slurm's `squeue` command and/or TACC's `showq` utility.

#### Slurm's `squeue` command { #jobs-monitoring-queuestatus }

Slurm's `squeue` command displays the state of all queued and running jobs.  

```cmd-line
login1$ squeue             # show all jobs in all queues
login1$ squeue -u bjones   # show all jobs owned by bjones
login1$ man squeue         # more info
```

The `squeue` command's default output format lists all nodes assigned to displayed jobs; this can make the output difficult to read. See the example below for a handy variation that suppresses the nodelist:

!!!tip
	The `squeue` command's default output format lists all nodes assigned to displayed jobs; this can make the output difficult to read. See the example below for a handy variation that suppresses the nodelist:

	```cmd-line
	login1$ squeue -o "%.10i %.12P %.12j %.9u %.2t %.9M %.6D"  # suppress nodelist
	```
### Job and Queue Status Meanings 

The `squeue` command's output displays two columns of interest, the column labeled `ST` displays each job's status, and the last column, labeled `NODELIST/REASON`, includes a nodelist for running/completing jobs, or a reason for pending jobs.  See [Table 6](#table6) and [Table 7](#table7) below for detailed explanations.

<figure id="figure2">
```cmd-line
     JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
    674649         gpu bb_rag_s rtoscano PD       0:00      1 (Dependency)
    696999         gpu  g6_deim   999999 PD       0:00      1 (DependencyNeverSatisfied)
    696818         gpu TESSA_J1 slindsey PD       0:00      2 (Dependency)
    690973         gpu TESSA_J2 slindsey  R 1-23:42:47      2 i617-[062-063]
    696803         gpu TESSA_J2 slindsey  R    3:24:00      2 i617-[001-002]
    697595     gpu-dev 2wiki300  ashleyp CG    3:36:29      1 c634-022
    673236     gpu-dev   IFML-R   895124 PD       0:00      1 (QOSMaxWallDurationPerJobLimit)
    697740     gpu-dev lysozyme sarajane PD       0:00     16 (Priority)
    697456     gpu-dev grpo_eva jemerson PD       0:00      1 (Dependency)
    695288     gpu-dev tldr_int kellykel PD       0:00      1 (DependencyNeverSatisfied)
    695427     gpu-dev idv02624 reynolds  R 1-18:40:00      8 c611-[071,122],c619-031,c620-[051,141-142],c640-[061-062]
    697606     gpu-dev musique3 tg111111  R    3:22:17      1 c612-021
    697613     gpu-dev ga_vmme_  bcatton  R    3:02:21      2 c613-152,c619-052
    695666     gpu-dev idv43155 camiguet  R 1-16:44:38      1 c621-052
    697723     gpu-dev ga_lvb_r  mylouis  R      16:19      2 c637-021,c641-061
    697782     gpu-dev proc_syn cmannion  R      34:45      8 c611-032,c613-[141,151],c619-151,c620-031,c622-[102,131,152]
    697802     gpu-dev idv24504    gbell PD       0:00      1 (Resources)
    614573     gpu-dev jupyter- jheldman PD       0:00      1 (JobHeldAdmin)
    611728     gpu-dev jupyter- jheldman PD       0:00      1 (JobHeldAdmin)
    697772     gpu-dev idv19251 reynolds  R      43:26      1 c642-011
```
</figure><figcaption>Figure 2. Sample <code>squeue</code> output</figcaption></figure>


##### Table 6. Job Status Meanings { #table6 }

Status Code | Status          | Description
--          | --              | --
`CA`        | CANCELLED       | Job was explicitly cancelled by the user or system administrator
`CD`        | COMPLETED       | Job has terminated all processes on all nodes with an exit code of zero.
`CG`        | COMPLETING      | Job is in the process of completing. Some processes on some nodes may still be active.
`F`         | FAILED          | Job terminated with non-zero exit code or other failure condition.
`NF`        | NODE_FAIL       | Job terminated due to failure of one or more allocated nodes.
`PD`        | PENDING         | Job is awaiting resource allocation.
`PR`        | PREEMPTED       | Job terminated due to preemption.
`R`         | RUNNING         | Job has an allocation and is currently running.
`TO`        | TIMEOUT         | Job terminated upon reaching its time limit.



##### Table 7. Pending Jobs Reason { #table7 }

The last column, labeled `NODELIST/REASON`, includes a nodelist for running/completing jobs, or a reason for pending jobs.  

`NODELIST/REASON` | Description
--- | ---
`Resources`       | The necessary combination of nodes/GPUs for your job are not available
`Priority`        | There are other jobs in the queue with a higher priority 
`Dependency`      | The job will not start until the dependency specified by you is satisfied.
`ReqNodeNotAvailable` | If you submit a job before a scheduled system maintenance period, and the job cannot complete before the maintenance begins, your job will run when the maintenance/reservation concludes.  The job will remain in the `PD` state until Horizon returns to production.
`QOSMaxJobsPerUserLimit` | The number of your jobs queued exceeds that [queue's limits](#jobs-monitoring-qlimits). These jobs will run once your previous jobs have ended.


!!!tip
	The `--start` option to the `squeue` command displays job start times, including very rough estimates for the expected start times of some pending jobs that are relatively high in the queue:

	```cmd-line
	login1$ squeue --start -j 167635     # display estimated start time for job 167635
	```


#### TACC's `showq` utility { #jobs-monitoring-showq }

TACC's `showq` utility mimics a tool that originated in the PBS project, and serves as a popular alternative to the Slurm `squeue` command:

```cmd-line
login1$ showq                 # show all jobs; default format
login1$ showq -u              # show your own jobs
login1$ showq -U bjones       # show jobs associated with user bjones
login1$ showq -h              # more info
```

The output groups jobs in four categories: `ACTIVE`, `WAITING`, `BLOCKED`, and `COMPLETING/ERRORED`. A `BLOCKED` job is one that cannot yet run due to temporary circumstances (e.g. a pending maintenance or other large reservation.).

If your waiting job cannot complete before a maintenance/reservation begins, `showq` will display its state as `**WaitNod**` ("Waiting for Nodes"). The job will remain in this state until Horizon returns to production.

Since TACC charges by the node rather than core, `showq`'s default format now reports total nodes associated with a job rather than cores, tasks, or hardware threads.  Run `showq` with the `-l` option to display the number of cores and the job's queue.


### Dependent Jobs using `sbatch` { #jobs-dependencies }

You can use `sbatch` to help manage workflows that involve multiple steps: the `--dependency` option allows you to launch jobs that depend on the completion (or successful completion) of another job. For example you could use this technique to split into three jobs a workflow that requires you to (1) compile on a single node; then (2) compute on 40 nodes; then finally (3) post-process your results using 4 nodes. 

``` cmd-line
login1$ sbatch --dependency=afterok:173210 myjobscript
```

!!! caution
	It is not possible to add resources to a job (e.g. allow more time, increase number of nodes) once you've submitted the job to the queue.

For more information see the [Slurm online documentation](http://www.schedmd.com). Note that you can use `$SLURM_JOBID` from one job to find the jobid you'll need to construct the `sbatch` launch line for a subsequent one. But also remember that you can't use `sbatch` to submit a job from a compute node.


### Inspecting Running and Completed Jobs { #jobs-other }


* To view some **accounting data** associated with your own jobs, use `sacct`:

	```cmd-line
	login1$ sacct --starttime 2026-05-01  # show jobs that started on or after this date
	```

* To **cancel** a pending or running job, first determine its jobid, then use `scancel`:

	```cmd-line
	login1$ squeue -u bjones    # one way to determine jobid
     JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
	170361         gpu   spec12   bjones PD       0:00     32 (Resources)
	login1$ scancel 170361      # cancel job
	```

* For **detailed information** about the configuration of a specific job, use `scontrol`:

	```cmd-line
	login1$ scontrol show job=170361
	```

## Building Software { #building } 

!!!important
    TACC maintains a database of currently installed software packages and libraries across all HPC resources.
    Navigate to TACC's [Software List][TACCSOFTWARELIST] to see where, or if, a particular package is already installed on a particular resource.

	If TACC does not have your desired software package already installed, you are welcome to download, build, and install the package in your own account.
	See [Building Third-Party Software](../../basics/software#thirdparty) in the [Software at TACC][TACCSOFTWARE] guide.


The phrase "building software" is a common way to describe the process of producing a machine-readable executable file from source files written in C, Fortran, CUDA, or some other programming language. In its simplest form, building software involves a simple, one-line call or short shell script that invokes a compiler. More typically, the process leverages the power of makefiles, so you can change a line or two in the source code, then rebuild in a systematic way only the components affected by the change. Increasingly, however, the build process is a sophisticated multi-step automated workflow managed by a special framework like autotools or cmake, intended to achieve a repeatable, maintainable, portable mechanism for installing software across a wide range of target platforms.

This section of the user guide does nothing more than introduce the big ideas with simple one-line examples. You will undoubtedly want to explore these concepts more deeply using online resources. You will quickly outgrow the examples here. We recommend that you master the basics of CMake and/or makefiles as quickly as possible: even the simplest computational research project will benefit enormously from the power and flexibility of a CMakefile or makefile-based build process.


### NVIDIA Compilers

NVIDIA is the recommended and default compiler suite on Horizon. 

Here are simple examples that use the NVIDIA compiler to build an executable from source code:

```cmd-line
$ nvc mycode.c                    # C source file; executable a.out
$ nvc main.c calc.c analyze.c     # multiple source files
$ nvc mycode.c         -o myexe   # C source file; executable myexe
$ nvcpc mycode.cpp     -o myexe   # C++ source file
$ nvfortran mycode.f90 -o myexe   # Fortran90 source file
```

Compiling a code that uses OpenMP would look like this:

```cmd-line
$ nvc -openmp mycode.c -o myexe   # OpenMP
```

See the published NVIDIA documentation, available online at <https://docs.nvidia.com/hpc-sdk//index.html>.

### GNU Compilers

The GNU foundation maintains a number of high quality compilers, including a compiler for C (`gcc`), C++ (`g++`), and Fortran (`gfortran`). The `gcc` compiler is the foundation underneath all three, and the term "`gcc`" often means the suite of these three GNU compilers.

Load a GCC module to access a recent version of the GNU compiler suite. Avoid using the GNU compilers that are available without a `gcc` module — those will be older versions based on the "system GCC" that comes as part of the Linux distribution.

Here are simple examples that use the GNU compilers to produce an executable from source code:

```cmd-line
$ gcc mycode.c                    # C source file; executable a.out
$ gcc mycode.c          -o myexe  # C source file; executable myexe
$ g++ mycode.cpp        -o myexe  # C++ source file
$ gfortran mycode.f90   -o myexe  # Fortran90 source file
$ gcc -fopenmp mycode.c -o myexe  # OpenMP
```

Note that some compiler options are the same for both NVIDIA and GNU (e.g. `-o`), while others are different (e.g. `-openmp` vs `-fopenmp`). Many options are available in one compiler suite but not the other. See the online GNU documentation for information on optimization flags and other GNU compiler options.

### Compiling and Linking

Building an executable requires two separate steps: (1) compiling (generating a binary object file associated with each source file); and (2) linking (combining those object files into a single executable file that also specifies the libraries that executable needs). The examples in the previous section accomplish these two steps in a single call to the compiler. When building more sophisticated applications or libraries, however, it is often necessary or helpful to accomplish these two steps separately.

Use the `-c` ("compile") flag to produce object files from source files:

```cmd-line
$ nvc -c main.c calc.c results.c
```

Barring errors, this command will produce object files main.o, calc.o, and results.o. Syntax for the NVIDIA and GNU compilers is similar.
You can now link the object files to produce an executable file:

```cmd-line
$ nvc main.o calc.o results.o -o myexe
```

The compiler calls a linker utility (usually `/bin/ld`) to accomplish this task. Again, syntax for other compilers is similar.

### Include and Library Paths

Software often depends on pre-compiled binaries called libraries. When this is true, compiling usually requires using the `-I` option to specify paths to so-called header or include files that define interfaces to the procedures and data in those libraries. Similarly, linking often requires using the `-L` option to specify paths to the libraries themselves. Typical compile and link lines might look like this:

```cmd-line
$ nvc        -c main.c -I${WORK}/mylib/inc -I${TACC_HDF5_INC}                  # compile
$ nvc main.o -o myexe  -L${WORK}/mylib/lib -L${TACC_HDF5_LIB} -lmylib -lhdf5   # link
```

On Horizon, both the HDF5 and PHDF5 modules define the environment variables `$TACC_HDF5_INC` and `$TACC_HDF5_LIB`. Other module files define similar environment variables; see Using Modules to Manage Your Environment for more information.

The details of the linking process vary, and order sometimes matters. Much depends on the type of library: static (.a suffix; library's binary code becomes part of executable image at link time) versus dynamically-linked shared (.so suffix; library's binary code is not part of executable; it's located and loaded into memory at run time). However, the `$LD_LIBRARY_PATH` environment variable specifies the search path for dynamic libraries. For software installed at the system-level, TACC's modules generally modify the `$LD_LIBRARY_PATH` automatically. To see whether and how an executable named myexe resolves dependencies on dynamically linked libraries, execute ldd myexe.

### MPI Programs

OpenMPI (`module openmpi`) and MVAPICH (`module mvapich-plus`) are the two MPI libraries available on Horizon. After loading an `openmpi` or `mvapich-plus` module, compile and/or link using an MPI wrapper (`mpicc`, `mpicxx`, `mpif90`) in place of the compiler:

```cmd-line
$ mpicc    mycode.c   -o myexe   # C source, full build
$ mpicc -c mycode.c              # C source, compile without linking
$ mpicxx   mycode.cpp -o myexe   # C++ source, full build
$ mpif90   mycode.f90 -o myexe   # Fortran source, full build
```

These wrappers call the compiler with the options, include paths, and libraries necessary to produce an MPI executable using the MPI module you're using. To see the effect of a given wrapper, call it with the `-show` option:

```cmd-line
$ mpicc -show                    # Show compile line generated by call to mpicc; similarly for other wrappers
```

## Building for Performance

### Compiler Options

When building software on Horizon, we recommend using the most recent NVIDIA compiler and OpenMPI library available on Horizon. The most recent versions may be newer than the defaults. Execute module spider nvidia and module spider ompi to see what's installed. When loading these modules you may need to specify version numbers explicitly (e.g. `module load nvidia/26.5` and `module load ompi/5.0.10`). <!-- should this be openmpi -->

### Architecture-Specific Flags

The Grace architecture is based on an Arm design that uses Neoverse V2 cores  The Neoverse V2 core support Arm’s Scalable Vector Extension v2(SVE2) and Advanced SIMD(NEON) technologies.  Each core has four 128-bit functional units that support 8 64-bit FMA operations. To compile for this specific architecture, include the -tp neoverse-v2 compile option. <!-- Details regarding Vera architecture optimizations will be added later. -->

Normally, we do not recommend using the `-fast` option.  But, in this case, since there is only one chip architecture on Horizon, and `-fast` does not enforce `-static`, it is safe to use the `-fast` option with the NVIDIA compilers. It will enable optimizations for the Neoverse V2 architecture. 

You can also use the environment variable `$TACC_VEC_FLAGS`.  This environment variable sets the following flags:

	-Mvect=simd -fast -Mipa=fast,inline

If you use GNU compilers, you can optimize for the Grace architecture using the -mcpu=neoverse-v2 option.  You can also use TACC_VEC_FLAGS as with the NVIDIA compilers.  It enables the following flags:

	-O3 -mcpu-neoverse-v2 

## NVIDIA  MPS { #mps }

NVIDIA's [Multi-Process Service](https://docs.nvidia.com/deploy/mps/) (MPS) allows multiple processes to share a GPU efficiently by reducing scheduling overhead. MPS can improve GPU resource sharing between processes when a single process cannot fully saturate the GPU's compute capacity. 

Follow these steps to configure MPS on Horizon for optimized multi-process workflows:

1. **Configure Environment Variables**

	Set environment variables to define where MPS stores its runtime pipes and logs. In the example below, these are placed in each node's `/tmp` directory.  The `/tmp` directory is ephemeral and cleared after a job ends or a node reboots.  Add these lines to your job script or shell session:

	```job-script
	# Set MPS environment variables
	export CUDA_MPS_PIPE_DIRECTORY=/tmp/nvidia-mps
	export CUDA_MPS_LOG_DIRECTORY=/tmp/nvidia-log
	```

	To retain these logs for later analysis, specify directories in `$SCRATCH`, `$WORK`, or `$HOME` file systems instead of `/tmp`. 

2. **Launch MPS Control Daemon**

	Use `ibrun` to start the MPS daemon across all allocated nodes. This ensures one MPS control process per node:

	```job-script
	# Launch MPS daemon on all nodes
	export TACC_TASKS_PER_NODE=1     # Force one task per node
	ibrun -np $SLURM_NNODES nvidia-cuda-mps-control -d
	unset TACC_TASKS_PER_NODE        # Reset to default task distribution
	```

3. **Submit Your GPU Job**

	After enabling MPS, run your CUDA application as usual. For example:

	```job-script
	ibrun ./your_cuda_executable 
	```

4. **Optional: Quit MPS daemon on all nodes**

	```job-script
	export TACC_TASKS_PER_NODE=1     # Force 1 task/node
	ibrun -np $SLURM_NNODES bash -c "echo quit | nvidia-cuda-mps-control"
	unset TACC_TASKS_PER_NODE
	```

### Sample Job Script { #scripts }

Incorporating the above elements into a job script may look like this:

```job-script
#!/bin/bash
#SBATCH -J mps_gpu_job           # Job name
#SBATCH -o mps_job.%j.out        # Output file (%j = job ID)
#SBATCH -t 01:00:00              # Wall time (1 hour)
#SBATCH -N 2                     # Number of nodes
#SBATCH -n 32                    # Total tasks (16 per node)
#SBATCH -p gpu                   # GPU partition (modify as needed)
#SBATCH -A your_project          # Project allocation

# 1. Configure environment
export CUDA_MPS_PIPE_DIRECTORY=/tmp/nvidia-mps
export CUDA_MPS_LOG_DIRECTORY=/tmp/nvidia-log

# 2. Launch MPS daemon on all nodes
echo "Starting MPS daemon..."
export TACC_TASKS_PER_NODE=1     # Force 1 task/node
ibrun -np $SLURM_NNODES nvidia-cuda-mps-control -d
unset TACC_TASKS_PER_NODE
sleep 5                          # Wait for daemons to initialize

# 3. Run your CUDA application
echo "Launching application..."
ibrun ./your_cuda_executable     # Replace with your executable
```

### Notes on Performance

MPS is particularly effective for workloads characterized by:

* Fine-grained GPU operations (many small kernel launches)
* Concurrent processes sharing the same GPU
* Underutilized GPU resources in single-process workflows

You may verify performance gains for your use case using the following command to monitor the node that your job is running on (e.g., `c608-052`):

```cmd-line
login1$ ssh c608-052
c608-052$ nvidia-smi dmon --gpm-metrics=3,12 -s u
```

The side-by-side plots in Figure 1 illustrate the performance enhancement obtained by running two GPU processes simultaneous on a single Hopper node with MPS. The GPU performance improvement is ~12%, compared to no improvement without MPS. Also, the setup cost on the CPU (about 12 seconds) is completely overlapped, resulting in in a 1.2x total improvement for 2 simultaneous Amber executions. Even better performance is expected for applications which don't load the GPU as much as Amber.

 
<figure><img src="../imgs/vista/MPS-graphs.png" width="800"><figcaption>Figure 1.  Usage (SM, Memory and FP32) and SM occupancy percentages for single and dual Amber GPU executions (single-precision) on Hopper H200.</figcaption></figure>


## NVIDIA Performance Libraries (NVPL) {nvpl}

The [NVIDIA Performance Libraries (NVPL)](https://docs.nvidia.com/nvpl/) are a collection of high-performance mathematical libraries optimized for the NVIDIA Grace Armv9.0 architecture. These CPU-only libraries are for standard C and Fortran mathematical APIs allowing HPC applications to achieve maximum performance on the Grace platform. The collection includes:

### NVIDIA Documentation { nvpl-documentation }

* [NVPL BLAS Documentation](https://docs.nvidia.com/nvpl/_static/blas/index.html)
* [NVPL FFT Documentation](https://docs.nvidia.com/nvpl/_static/fft/index.html)
* [NVPL LAPACK Documentation](https://docs.nvidia.com/nvpl/_static/lapack/index.html)
* [NVPL RAND Documentation](https://docs.nvidia.com/nvpl/_static/rand/index.html)
* [NVPL ScaLAPACK Documentation](https://docs.nvidia.com/nvpl/_static/scalapack/index.html)
* [NVPL Sparse Documentation](https://docs.nvidia.com/nvpl/_static/sparse/index.html)
* [NVPL Tensor Documentation](https://docs.nvidia.com/nvpl/_static/tensor/index.html)

Consult the above documents for the details of each library and its API for building and linking codes. The libraries work with both NVHPC and GCC compilers, as well as their corresponding MPI wrappers. All libraries support the OpenMP runtime libraries. Refer to individual libraries documentation for details and API extensions supporting nested parallelism.

### Compiler Examples

**Example**: A compile/link process on Horizon may look like the following:
This links the code against the NVPL FFT library using the GNU `g++` compiler. 
The features in NVPL FFT are still evolving, please pay close attention and follow the latest NVPL FFT document. 

```cmd-line
$ module load nvpl
$ g++ mycode.cpp -I$TACC_NVPL_DIR}/include \
		-L$TACC_NVPL_DIR}/lib \
		-lnvpl_fftw \
		-o myprogram
```

**Example**: This links the code against the NVPL OpenMP threaded BLAS, LAPACK, and SCALAPACK libraries of 32 bit integer interface using the NVHPC mpif90 wrapper. The cluster capability of BLAS from current NVPL release from NVHPC SDK-24.5 includes openmpi3,4,5 and mpich, choose the one that matches the MPI version in mpif90. 


```cmd-line
$ module load nvpl            
$ mpif90 -mp -I$TACC_NVPL_DIR}/include  \
       -L${TACC_NVPL_DIR}/lib   \
       -lnvpl_blas_lp64_gomp   \
       -lnvpl_lapack_lp64_gomp  \
      -lnvpl_blacs_lp64_openmpi5 \
      -lnvpl_scalapack_lp64   \
       mycode.f90
```


When linking using NVHPC compiler, convenient flags `-Mnvpl` and `-Mscalapack` are provided. As the behavior of these flags may change during active development, please refer to the latest [NVHPC compiler guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/index.html#lib-use-lapack-blas-ffts) for more details. 

### Using NVPL as BLAS/LAPACK with Third-Party Software

When your third-party software requires BLAS or LAPACK, we recommend that you use NVPL to supply this functionality. Replace generic instructions that include link options like `-lblas` or `-llapack` with the NVPL approach described above. Generally there is no need to download and install alternatives like OpenBLAS. However, since the NVPL is a relatively new math library suite targeting the aarch64, its interoperability to other softwares with a special 32 or 64 bit integer interface, or OpenMP runting support are not fully tested yet. If you have issues with NVPL and alternative BLAS, LAPACK libraries are needed, the OpenBLAS based ones are available as a part of NVHPC compiler libraries. 

### Controlling Threading in NVPL

All NVPL libraries support the both GCC and NVHPC OpenMP runtime libraries. See individual libraries documentation for details and API extensions supporting nested parallelism. NVPL Libraries do not explicitly link any particular OpenMP runtime, they rely on runtime loading of the OpenMP library as determined by the application and environment. Applications linked to NVPL should always use at runtime the same OpenMP distribution the application was compiled with. Mixing OpenMP distributions from compile-time to runtime may result in anomalous performance.  Please note that the default library linked with `-Mnvpl` flag is single threaded as of NVHPC 24.5, `-mpflag` is needed to linked with the threaded version. 
	
NVIDIA HPC modules provide a `libgomp.so` symlink to `libnvomp.so`. This symlink will be on `LD_LIBRARY_PATH` if NVHPC environment modules are loaded. Use  [ldd](https://man7.org/linux/man-pages/man1/ldd.1.html) to ensure that applications built with GCC do not accidentally load `libgomp.sosymlink` from HPC SDK due to `LD_LIBRARY_PATH`. Use `libnvomp.soif` if and only if the application was built with NVHPC compilers.
	
`$OMP_NUM_THREADS` defaults to 1 on TACC systems. If you use the default value you will get no thread-based parallelism from NVPL. Setting the environment variable `$OMP_NUM_THREADS` to control the number of threads for optimal performance.
	

### Using NVPL with other MATLAB, PYTHON and R

TACC MATLAB, Python and R modules need BLAS and LAPACK and other math libraries for performance. How to use NVPL with them is under investigation. We will update.
## Help Desk { #help }

!!!important
	[Submit a help desk ticket][HELPDESK] at any time via the TACC User Portal.  Be sure to include "Horizon" in the Resource field.  

TACC Consulting operates from 8am to 5pm CST, Monday through Friday, except for holidays.  Help the consulting staff help you by following these best practices when submitting tickets. 

* **Do your homework** before submitting a help desk ticket. What does the user guide and other documentation say? Search the internet for key phrases in your error logs; that's probably what the consultants answering your ticket are going to do. What have you changed since the last time your job succeeded?

* **Describe your issue as precisely and completely as you can:** what you did, what happened, verbatim error messages, other meaningful output. 

!!! tip
	When appropriate, include as much meta-information about your job and workflow as possible including: 

	* directory containing your build and/or job script
	* all modules loaded 
	* relevant job IDs 
	* any recent changes in your workflow that could affect or explain the behavior you're observing.

* **[Subscribe to Horizon User News][TACCSUBSCRIBE].** This is the best way to keep abreast of maintenance schedules, system outages, and other general interest items.

* **Have realistic expectations.** Consultants can address system issues and answer questions about Horizon. But they can't teach parallel programming in a ticket, and may know nothing about the package you downloaded. They may offer general advice that will help you build, debug, optimize, or modify your code, but you shouldn't expect them to do these things for you.

* **Be patient.** It may take a business day for a consultant to get back to you, especially if your issue is complex. It might take an exchange or two before you and the consultant are on the same page. If the admins disable your account, it's not punitive. When the file system is in danger of crashing, or a login node hangs, they don't have time to notify you before taking action.

[CREATETICKET]: https://tacc.utexas.edu/about/help/ "Create Support Ticket"
[SUBMITTICKET]: https://tacc.utexas.edu/about/help/ "Submit Support Ticket"
[HELPDESK]: https://tacc.utexas.edu/about/help/ "Help Desk"


[TACCGOODCONDUCT]: /basics/conduct/ "TACC Good Conduct Guide"
[TACCSOFTWARE]: /basics/software/ "Software at TACC"

[TACCDOCS]: / "TACC Documentation Portal"
[TACCACCESSCONTROLLISTS]: /tutorials/acls "Access Control Lists"
[TACCACLS]: /tutorials/acls "Manage Permissions with Access Control Lists"
[TACCBASHQUICKSTART]: /tutorials/bashstartup "Bash Quick Start Guide"
[TACCIDEV]: /software/idev "idev at TACC"
[TACCLMOD]: https://lmod.readthedocs.io/en/latest/ "Lmod"
[TACCMANAGINGACCOUNT]: /basics/accounts "Managing your TACC Account"
[TACCMANAGINGIO]: /tutorials/managingio "Managing I/O at TACC"
[TACCMANAGINGPERMISSIONS]: /tutorials/permissions "Unix Group Permissions and Environment"
[TACCMFA]: /basics/mfa "Multi-Factor Authentication at TACC"
[TACCPYLAUNCHER]: /software/pylauncher "PyLauncher at TACC"
[TACCPARAVIEW]: /software/paraview "Paraview at TACC"
[TACCREMOTEDESKTOPACCESS]: /tutorials/remotedesktopaccess "TACC Remote Desktop Access"
[TACCSHARINGPROJECTFILES]: /tutorials/sharingprojectfiles "Sharing Project Files"

[TACCUSERPORTAL]: https://tacc.utexas.edu/portal/login "TACC User Portal login"
[TACCDASHBOARD]: https://tacc.utexas.edu/portal/dashboard "TACC Dashboard"
[TACCPROJECTS]: https://tacc.utexas.edu/portal/projects "Projects & Allocations"

[TACCACCOUNTS]: https://accounts.tacc.utexas.edu "TACC Accounts Portal"
[TACCUSERPROFILE]: https://accounts.tacc.utexas.edu/profile "TACC Accounts User Profile"
[TACCSUBSCRIBE]: https://accounts.tacc.utexas.edu/user_updates "Subscribe to News"
[TACCLOGINSUPPORT]: https://accounts.tacc.utexas.edu/login_support "TACC Accounts Login Support Tool"

[TACCALLOCATIONS]: https://tacc.utexas.edu/use-tacc/allocations/ "TACC Allocations"
[TACCAUP]: https://tacc.utexas.edu/use-tacc/user-policies/ "TACC Acceptable Use Policy"
[TACCCITE]: https://tacc.utexas.edu/about/citing-tacc/ "Citing TACC"

[TACCSTAMPEDE3UG]: /hpc/stampede3/ "TACC Stampede3 User Guide"
[TACCLONESTAR6UG]: /hpc/lonestar6/ "TACC Lonestar6 User Guide"
[TACCFRONTERAUG]: /hpc/frontera/ "TACC Frontera User Guide"
[TACCVISTAUG]: /hpc/vista/ "TACC Vista User Guide"
[TACCHORIZONAUG]: /hpc/horizon/ "TACC Horizon User Guide"
[TACCRANCHUG]: /hpc/ranch/ "TACC Ranch User Guide"
[TACCCORRALUG]: /hpc/corral/ "TACC Corral User Guide"
[TACCSTOCKYARD]: https://tacc.utexas.edu/systems/stockyard  "Stockyard File System"
[TACCANALYSISPORTAL]: http://tap.tacc.utexas.edu "TACC Analysis Portal"

[DOWNLOADCYBERDUCK]: https://cyberduck.io/download/ "Download Cyberduck"
[CYBERDUCK]: https://cyberduck.io "Download Cyberduck"
[TACCSOFTWARELIST]: https://tacc.utexas.edu/use-tacc/software-list/ "TACC Software List"
[TACCGAUSSIANAGREEMENT]: /taccdocs/TACC_GAUSSIAN_Usage_Agreement.pdf "TACC GAUSSIAN Usage Agreement"

