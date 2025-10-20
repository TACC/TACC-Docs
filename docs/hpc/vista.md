# Vista User Guide 
*Last update: October 20, 2025*

## Notices { #notices }

* **New**: See TACC Staff's [notes on incorporating NVIDIA's Multi-Process Service](#mps). (MPS) 
* **[Subscribe][TACCSUBSCRIBE] to Vista User News**. Stay up-to-date on Vista's status, scheduled maintenances and other notifications.  (09/01/2024)

## Introduction { #intro }


TACC's new AI-centric system, Vista, is in full production for the open science community. Vista serves as a bridge from Frontera to Horizon, the primary system of the U.S. [NSF Leadership-Class Computing Facility](https://lccf.tacc.utexas.edu/) (LCCF), and marks a departure from the x86-based architecture to one with CPUs based on Advanced RISC Machines architecture.  Vista expands the Frontera project's support of Machine Learning and GPU-enabled applications with a system based on NVIDIA Grace Hopper architecture and provides a path to more power efficient computing with NVIDIA's Grace Grace ARM CPUs. 

The Grace Hopper Superchip introduces a novel architecture that combines the GPU and CPU in one module.  This technology removes the bottleneck of the PCIe bus by connecting the CPU and GPU directly with NVLINK and exposing the CPU and GPU memory space as separate NUMA nodes.  This allows the programmer to easily access CPU or GPU memory from either device.  This greatly reduces the programming complexity of GPU programs while providing increased bandwidth and reduced latency between CPU and GPU.  

The Grace Superchip connects two 72 core Grace CPUs using the same NVLINK technology used in the Grace Hopper Superchip to provide 144 ARM cores in 2 NUMA nodes.  Using LPDDR memory, each Superchip offers over 850 GiB/s of memory bandwidth and up to 7 TFlops of double precision performance. 

Vista is funded by the National Science Foundation (NSF) via a supplement to the Computing for the Endless Frontier award, [Award Abstract #1818253](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1818253).  Please [reference TACC](https://tacc.utexas.edu/about/citing-tacc/) when providing any citations. 

<!--
### Allocations { #intro-allocations }
*Coming soon*.
-->



## Account Administration

{% include 'include/vista-crontab.md' %}

{% include 'include/tacctips.md' %}

## System Architecture { #system }

### Vista Topology { #system-topology }

Vista's compute system is divided into Grace-Grace and Grace-Hopper subsystems networked in two-level fat-tree topology as illustrated in Figure 1. below.

<figure><img src="../imgs/vista/vista-topology.png"> <figcaption>Figure 1. Vista Topology</figcaption></figure>

The Grace-Grace (GG) subsystem, a purely CPU-based system, is housed in four racks, each containing 64 Grace-Grace (GG) nodes. Each GG node contains 144 processing cores. A GG node provides over 7 TFlops of double precision performance and up to 1 TiB/s of memory bandwidth. GG nodes connect via an InfiniBand 200 Gb/s fabric to a top rack shelf NVIDIA Quantum-2 MQM9790 NDR switch. In total, the subsystem contains sixty-four 200 Gb/s uplinks to the NDR rack shelf switch.

The Grace-Hopper (GH) subsystem, on the other  hand,  consists of nodes using the GH200 Grace-Hopper Superchip. Each GH node contains an NVIDIA H200 GPU  with 96 GiB of HBM3 memory and a Grace CPU with 120 GiB of LPDDR5X memory and 72 cores. A GH node provides 34 TFlops of FP64 performance and 1979 TFlops of FP16 performance for ML workflows on the H200 chip. The GH subsystem is housed in 19 racks, each containing 32 Grace-Hopper (GH) nodes. These nodes connect via an NVIDIA InfiniBand 400 Gb/s fabric to the NVIDIA Quantum-2 MQM9790 NDR switch having 64 ports of 400Gb/s InfiniBand per port. There are thirty-two 400 Gb/s uplinks to the NDR rack shelf switch. The GH nodes have twice the network bandwidth of the GG nodes.

Each top rack shelf switch in all racks connects to sixteen core switches via dual-400G cables. In total, Vista contains 256 GG nodes and 600 GH nodes.   Both sets of nodes are connected with NDR fabric to two local file systems, `$HOME` and `$SCRATCH`. These are NFS-based flash file systems from VAST Data. The `$HOME` file system is designed for a small permanent storage area and is quota'd and backed up daily, while the `$SCRATCH` file system is designed for short term use from many nodes and is not quota'd but may be purged as needed. These file systems are connected to the management switch, which in turn is fully connected to the core network switches. The `$WORK` file system is a global Lustre file system connected to all of the TACC HPC resources. It is connected to Vista via LNeT routers. 

!!!tip
	See NVIDIA'S <a href="https://docs.nvidia.com/grace-perf-tuning-guide/index.html">Grace Performance Tuning Guide</a> for very detailed information on the Grace system..

!!!info
	See TACC's [Performance Analysis of Scientific Applications on an NVIDIA Grace System](https://doi.org/10.1109/SCW63240.2024.00078)


### Grace Grace Compute Nodes { #system-gg }

Vista hosts 256 "Grace Grace" (GG) nodes with 144 cores each. Each GG node provides a performance increase of 1.5 - 2x over the Stampede3's CLX nodes due to increased core count and increased memory bandwidth.  Each GG node provides over 7 TFlops of double precision performance and 850 GiB/s of memory bandwidth.

#### Table 1. GG Specifications { #table1 }

Specification | Value 
--- | ---
CPU:                       | NVIDIA Grace CPU Superchip
Total cores per node:      | 144 cores on two sockets (2 x 72 cores)
Hardware threads per core: | 1
Hardware threads per node: | 2x72 = 144
Clock rate:                | 3.4 GHz
Memory:                    | 237 GB LPDDR
Cache:                     | 64 KB L1 data cache per core; 1MB L2 per core; 114 MB L3 per socket.<br>Each socket can cache up to 186 MB (sum of L2 and L3 capacity).
Local storage:             | 286 GB `/tmp` partition
DRAM:                      | LPDDR5

### Grace Hopper Compute Nodes { #system-gh }

Vista hosts 600 Grace Hopper (GH) nodes. Each GH node has one H200 GPU with 96 GB of HBM3 memory and one Grace CPU with 116 GB of LPDDR memory. The GH node provides 34 TFlops of FP64 performance and 1979 TFlops of FP16 performance for ML workflows on the H200 chip.


#### Table 2. GH Specifications { #table2 }

Specification                | Value 
---                          | ---
GPU:                         | NVIDIA H200 GPU 
GPU Memory:                  | 96 GB HBM 3
CPU:                         | NVIDIA Grace CPU
Total cores per node:        | 72 cores on one socket
Hardware threads per core:   | 1
Hardware threads per node:   | 1x48 = 72
Clock rate:                  | 3.1 GHz
Memory:                      | 116 GB DDR5
Cache:                       | 64 KB L1 data cache per core; 1MB L2 per core; 114 MB L3 per socket.<br>Each socket can cache up to 186 MB (sum of L2 and L3 capacity).
Local storage:               | 286 GB `/tmp` partition
DRAM:                        | LPDDR5

### Login Nodes { #system-login }

The Vista login nodes are NVIDIA Grace Grace (GG) nodes, each with 144 cores on two sockets (72 cores/socket) with 237 GB of LPDDR.

### Network { #system-network }

The interconnect is based on Mellanox NDR technology with full NDR (400 Gb/s) connectivity between the switches and the GH GPU nodes and with NDR200 (200 Gb/s) connectivity to the GG compute nodes. A fat tree topology connects the compute nodes and the GPU nodes within separate trees.  Both sets of nodes are connected with NDR to the `$HOME` and `$SCRATCH` file systems. 

### File Systems { #system-filesystems }

Vista will use a shared VAST file system for the `$HOME` and `$SCRATCH` directories. 

!!! important
	Vista's `$HOME` and `$SCRATCH` file systems are NOT Lustre file systems and do not support setting a stripe count or stripe size. 

As with Stampede3, the `$WORK` file system will also be mounted.  Unlike `$HOME` and `$SCRATCH`, the `$WORK` file system is a Lustre file system and supports Lustre's `lfs` commands. All three file systems, `$HOME`, `$SCRATCH`, and `$WORK` are available from all Vista nodes. The `/tmp` partition is also available to users but is local to each node. The `$WORK` file system is available on most other TACC HPC systems as well.


#### Table 3. File Systems { #table3 }

File System | Type | Quota | Key Features
---         | -- | ---   | ---
`$HOME` | VAST   | 23 GB, 500,000 files | Not intended for parallel or high−intensity file operations.<br>Backed up regularly.
`$WORK` | Lustre | 1 TB, 3,000,000 files across all TACC systems<br>Not intended for parallel or high−intensity file operations.<br>See [Stockyard system description][TACCSTOCKYARD] for more information. | Not backed up. | Not purged.
`$SCRATCH` | VAST | no quota<br>Overall capacity ~10 PB. | Not backed up.<br>Files are subject to purge if access time* is more than 10 days old. See TACC's [Scratch File System Purge Policy](#scratchpolicy) below.

{% include 'include/scratchpolicy.md' %}


## Accessing the System { #access }

Access to all TACC systems requires Multi-Factor Authentication (MFA). You can create an MFA pairing under "Manage Account" in the TACC Portal.  See [Multi-Factor Authentication at TACC][TACCMFA] for further information.

!!! important
	You will be able to log on to Vista **only if** you have an allocation on Vista, otherwise your password will be rejected.  
	Monitor your projects &amp; allocations the via the [TACC Portal](https://tacc.utexas.edu/portal/projects).

### Secure Shell (SSH) { #access-ssh }

The `ssh` command (Secure Shell, or SSH protocol) is the standard way to connect to Vista and initiate a login session. SSH also includes support for the UNIX file transfer utilities `scp` and `sftp`.  These commands are available within Linux and the Terminal application within Mac OS. If you are using Windows, you will need a modern terminal application such as [Windows Terminal](https://apps.microsoft.com/detail/9N0DX20HK701?hl=en-US&gl=US), [MobaXterm](https://mobaxterm.mobatek.net/) or [Cyberduck](https://cyberduck.io/download/).  

Initiate an SSH session using the `ssh` command or the equivalent: 

	localhost$ ssh taccusername@vista.tacc.utexas.edu

The above command will rotate connections across all available login nodes and route your connection to the next available node. 

!!! important
	Vista's login nodes are a *shared resource*. See TACC's [Good Conduct Policy][TACCGOODCONDUCT] for more information.


To connect to a specific login node, use its full domain name:

	localhost$ ssh taccusername@login2.vista.tacc.utexas.edu

To connect with X11 support on Vista (usually required for applications with graphical user interfaces), use the `-X` or `-Y` option:

	localhost$ ssh -X taccusername@vista.tacc.utexas.edu

Use your TACC portal password for direct logins to TACC resources. You can change or reset your TACC password via the [TACC Portal][TACCUSERPORTAL] under "Manage Account".  To report a connection problem, execute the `ssh` command with the `-vvv` option and include this command's verbose output when submitting a help ticket.

Do not run the `ssh-keygen` command on Vista. This command will create and configure a key pair that will interfere with the execution of job scripts in the batch system.  If you do this by mistake, you can recover by renaming or deleting the `.ssh` directory located in your home directory; the system will automatically generate a new pair for you when you next log into Vista.

1. execute `mv .ssh dot.ssh.old`
1. log out
1. log into Vista again

After logging in again, the system will generate a properly configured key SSH pair.

## Running Jobs { #running }


<!-- ### Slurm Job Scheduler { #running-slurm } -->

### Slurm Partitions (Queues) { #queues }

Vista's job scheduler is the Slurm Workload Manager. Slurm commands enable you to submit, manage, monitor, and control your jobs.  <!-- See the [Job Management](#jobmanagement) section below for further information. -->

!!! important
    **Queue limits are subject to change without notice.**  
    TACC Staff will occasionally adjust the QOS settings in order to ensure fair scheduling for the entire user community.  
    Use TACC's `qlimits` utility to see the latest queue configurations.

<!--
10/20/2025
login1.vista(43)$ qlimits
Current queue/partition limits on TACC's vista system:

Name             MinNode  MaxNode     MaxWall  MaxNodePU  MaxJobsPU   MaxSubmit
gg                     1       32  2-00:00:00        128         20          40
gh                     1       64  2-00:00:00        192         20          40
gh-dev                 1        8    02:00:00          8          1           3

/usr/local/etc/queue.map
gg:0.33
gh:1.0
gh-dev:1.0
-->

#### Table 4. Production Queues { #table4 }

Queue Name  | Node Type     | Max Nodes per Job<br>(assoc'd cores) | Max Job<br>Duration | Max Nodes<br>per User   | Max Jobs<br>per User | Charge Rate<br>(per node-hour)
--          | --            | --                                   | --                  | --                      |--                    |--
`gg`        | Grace/Grace   | 32 nodes<br>(4608 cores)             | 48 hrs              | 128                     | 20                   | 0.33 SU
`gh`        | Grace/Hopper  | 64 nodes<br>(4608 cores/64 gpus)     | 48 hrs              | 192                     | 20                   | 1 SUs
`gh-dev`    | Grace Hopper  | 8 nodes<br>(576 cores)               |  2 hrs              | 8                       | 1                    | 1 SU


{% include 'include/vista-jobaccounting.md' %}

### Submitting Batch Jobs with `sbatch` { #running-sbatch }

Use Slurm's `sbatch` command to submit a batch job to one of the Vista queues:

```cmd-line
login1$ sbatch myjobscript
```

Where `myjobscript` is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting. The details of your job script's contents depend on the type of job you intend to run.

In your job script you (1) use `#SBATCH` directives to request computing resources (e.g. 10 nodes for 2 hrs); and then (2) use shell commands to specify what work you're going to do once your job begins. There are many possibilities: you might elect to launch a single application, or you might want to accomplish several steps in a workflow. You may even choose to launch more than one application at the same time. The details will vary, and there are many possibilities. But your own job script will probably include at least one launch line that is a variation of one of the examples described here.

Your job will run in the environment it inherits at submission time; this environment includes the modules you have loaded and the current working directory. In most cases you should run your applications(s) after loading the same modules that you used to build them. You can of course use your job submission script to modify this environment by defining new environment variables; changing the values of existing environment variables; loading or unloading modules; changing directory; or specifying relative or absolute paths to files. **Do not** use the Slurm `--export` option to manage your job's environment: doing so can interfere with the way the system propagates the inherited environment.

[Table 8.](#table8) below describes some of the most common `sbatch` command options. Slurm directives begin with `#SBATCH`; most have a short form (e.g. `-N`) and a long form (e.g. `--nodes`). You can pass options to `sbatch` using either the command line or job script; most users find that the job script is the easier approach. The first line of your job script must specify the interpreter that will parse non-Slurm commands; in most cases `#!/bin/bash` or `#!/bin/csh` is the right choice. Avoid `#!/bin/sh` (its startup behavior can lead to subtle problems on Vista), and do not include comments or any other characters on this first line. All `#SBATCH` directives must precede all shell commands. Note also that certain `#SBATCH` options or combinations of options are mandatory, while others are not available on Vista.

By default, Slurm writes all console output to a file named "`slurm-%j.out`", where `%j` is the numerical job ID. To specify a different filename use the `-o` option. To save `stdout` (standard out) and `stderr` (standard error) to separate files, specify both `-o` and `-e` options.

!!! tip
	The maximum runtime for any individual job is 48 hours.  However, if you have good checkpointing implemented, you can easily chain jobs such that the outputs of one job are the inputs of the next, effectively running indefinitely for as long as needed.  See Slurm's `-d` option.

#### Table 8. Common `sbatch` Options { #table8 }

Option | Argument | Comments
--- | --- | ---
`-A`  | *projectid* | Charge job to the specified project/allocation number. This option is only necessary for logins associated with multiple projects.
`-a`<br>or<br>`--array` | =*tasklist* | Vista supports Slurm job arrays.  See the [Slurm documentation on job arrays](https://slurm.schedmd.com/job_array.html) for more information.
`-d=` | afterok:*jobid* | Specifies a dependency: this run will start only after the specified job (jobid) successfully finishes
`-export=` | N/A | Avoid this option on Vista. Using it is rarely necessary and can interfere with the way the system propagates your environment.
`--gres` | | TACC does not support this option.
`--gpus-per-task` | | TACC does not support this option.
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
export OMP_NUM_THREADS=144     # 144 total OpenMP threads (1 per GG core)
./myprogram
```


### One MPI Application { #launching-mpi }

To launch an MPI application, use the TACC-specific MPI launcher `ibrun`, which is a Vista-aware replacement for generic MPI launchers like `mpirun` and `mpiexec`. In most cases the only arguments you need are the name of your executable followed by any arguments your executable needs. When you call `ibrun` without other arguments, your Slurm `#SBATCH` directives will determine the number of ranks (MPI tasks) and number of nodes on which your program runs.

``` job-script
#SBATCH -N 4
#SBATCH -n 576
ibrun ./myprogram              # ibrun uses the $SBATCH directives to properly allocate nodes and tasks
```
To use `ibrun` interactively, say within an `idev` session, you can specify:

``` cmd-line
login1$ idev -N 2 -n 80 -p gg
c123-456$ ibrun ./myprogram    # ibrun uses idev's arguments to properly allocate nodes and tasks
```

### One Hybrid (MPI+Threads) Application { #launching-hybrid }

When launching a single application you generally don't need to worry about affinity: both OpenMPI and MVAPICH2 will distribute and pin tasks and threads in a sensible way.

``` job-script
export OMP_NUM_THREADS=8    # 8 OpenMP threads per MPI rank
ibrun ./myprogram           # use ibrun instead of mpirun or mpiexec
```
As a practical guideline, the product of `$OMP_NUM_THREADS` and the maximum number of MPI processes per node should not be greater than total number of cores available per node (GG nodes have 144 cores, GH nodes have 72 cores).

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
      Welcome to the Vista Supercomputer          
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

For command line options and other information, execute `idev --help`. It's easy to tailor your submission request (e.g. shorter or longer duration) using Slurm-like syntax:

``` cmd-line
login1$ idev -p gg -N 2 -n 8 -m 150 # gg queue, 2 nodes, 8 total tasks, 150 minutes
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

!!! warning 
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



## NVIDIA  MPS { #mps }

NVIDIA's [Multi-Process Service](https://docs.nvidia.com/deploy/mps/) (MPS) allows multiple processes to share a GPU efficiently by reducing scheduling overhead. MPS can improve GPU resource sharing between processes when a single process cannot fully saturate the GPU's compute capacity. 

Follow these steps to configure MPS on Vista for optimized multi-process workflows:

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
#SBATCH -n 8                     # Total tasks (4 per node)
#SBATCH -p gh                    # GPU partition (modify as needed)
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


## Machine Learning on Vista { #ml }

You may utilize one or more nodes for machine-learning model training tasks on Vista. Vista supports both configurations, enabling researchers to scale their training efficiently based on project requirements.

* Single-node training utilizes one or multiple GPUs on a single node and is ideal for smaller models and datasets, offering faster job throughput and easier debugging. 
* Multi-node training, on the other hand, distributes the workload across multiple nodes, each with its own set of GPUs. This approach is necessary for large-scale models and datasets that exceed the memory or compute capacity of a single node, and is essential for scalability. 

### Environment Setup

Before diving into machine learning frameworks, it's essential to set up your environment correctly. Vista supports Python virtual environments, which help manage dependencies and isolate projects. This guide walks you through setting up environments for both PyTorch and Accelerate.

We recommend using a Python virtual environment to manage machine learning packages. Once set up, users can run jobs within this environment using either [`idev`][TACCIDEV] sessions or [SLURM batch scripts](#scripts).

### Running PyTorch (Single Node)

Follow these steps to use Vista's system PyTorch with a single GPU node.

1. Request a single compute node in Vista's [`gh-dev` queue](#queues) using the [`idev`][TACCIDEV] utility:
	```cmd-line
	login1$ idev -p gh-dev -N 1 -n 1 -t 1:00:00
	```
1. Load modules
	```cmd-line
	c123-456$ module load gcc cuda
	c123-456$ module load python3
	```

1. Launch Python interpreter and check to see that you can import PyTorch and that it can utilize the GPU nodes:
	```cmd-line
	import torch 
	torch.cuda.is_available()
	```

### Installing PyTorch

Depending on your particular application, you may also need to install your own local copy of PyTorch. We recommend using the Python virtual environment to manage machine learning packages. Below we detail how to install PyTorch on our systems with a virtual environment:

1. Request a single compute node in Vista's [`gh-dev` queue](#queues) using the [`idev`][TACCIDEV] utility:
	```cmd-line
	login1$ idev -p gh-dev -N 1 -n 1 -t 1:00:00
	```
1. Load modules
	```cmd-line
	c123-456$ module load gcc/15.1.0  
	c123-456$ module load python3/3.11.8
	```
1. Create a Python virtual environment:
	```cmd-line
	c123-456$ module load gcc cuda
	c123-456$ module load python3
	c123-456$ python3 -m venv /path/to/virtual-env-single-node  # (e.g., $SCRATCH/python-envs/test)
	```
1. Activate the Python virtual environment:
	```cmd-line
	c123-456$ source /path/to/virtual-env-single-node/bin/activate
	```
1. Install PyTorch
	```cmd-line
	c123-456$ pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu129
	```

### Testing PyTorch Installation
To test your installation of PyTorch we point you to a few benchmark calculations that are part of PyTorch's tutorials on multi-GPU and multi-node training. See PyTorch's documentation: Distributed Data Parallel in PyTorch. These tutorials include several scripts set up to run single-node training and multi-node training.

1. Download the benchmark:
	```cmd-line
	c123-456$ cd $SCRATCH (or directory on scratch where you want this repo to reside)
	c123-456$ git clone https://github.com/pytorch/examples.git
	```

1. Run the benchmark on one node (1 GPU):
	```cmd-line
	c123-456$ python3 examples/distributed/ddp-tutorial-series/single_gpu.py 50 10
	```

### Running PyTorch (Multi-node)

1. Request two nodes in the [`gh-dev` queue](#queues) using TACC's [`idev`][TACCIDEV]  utility:
	```cmd-line
	login1$ idev -p gh-dev -N 2 -n 2 -t 1:00:00
	```

1. Move to the benchmark directory:
	```cmd-line
	c123-456$ cd $SCRATCH
	```

1. Create a script called "run.sh". This script needs two parameters, the hostname of the master node and the number of nodes. Add execution permission for the file "run.sh".
	```
	#!/bin/bash
	HOST=$1
	NODES=$2
	LOCAL_RANK=${OMPI_COMM_WORLD_RANK}
	torchrun --nproc_per_node=1  --nnodes=$NODES --node_rank=${LOCAL_RANK} --master_addr=$HOST \
   		examples/distributed/ddp-tutorial-series/multinode.py 50 10
	```
1. Run multi-gpu training:
	```cmd-line
	c123-456$ mpirun -np 2  --map-by ppr:1:node run.sh c123-456 2
	```

### Setting Up Transformers with Accelerate

Transformers is a Python library developed by Hugging Face that provides pre-trained models for machine learning tasks. It includes implementations of popular architectures like BERT, GPT, and T5, making it easy to fine-tune and deploy state-of-the-art models.

Accelerate is a Hugging Face library designed to streamline distributed training. It abstracts away the complexity of launching multi-GPU and multi-node jobs, allowing users to scale their training with minimal code changes. Follow these steps to set up and run training jobs.

### Set up Environment for Transformers and Accelerate


1. Download the code and scripts for the job and change directory 
	```cmd-line
	c123-456$ cd $SCRATCH
	c123-456$ git clone https://github.com/skye-glitch/Machine-Learning-on-Vista.git
	c123-456$ cd Machine-Learning-on-Vista
	```

1. Request a single compute node in Vista [`gh-dev` queue](#queues) using TACC's [`idev`][TACCIDEV] utility:
	```cmd-line
	login1$ idev -p gh-dev -N 1 -n 1 -t 1:00:00
	```
1. Load modules
	```cmd-line
	c123-456$ module load gcc cuda
	c123-456$ module load python3
	```
1. Create a Python virtual environment:
	```cmd-line
	c123-456$ python3 -m venv .venv 
	```
1. Activate the Python virtual environment:
	```cmd-line
	c123-456$ source .venv
	```
1. Now install dependencies:
	```cmd-line
	c123-456$ pip3 install -r requirements.txt
	```

### Testing Transformers and Accelerate Installation

#### Single-Node

Run the training on one node (1 GPU):
```cmd-line
c123-456$ python ./finetune.py
```

#### Multi-Node

1. Request two nodes in the [`gh-dev` queue](#queues) using TACC's [`idev`][TACCIDEV]  utility:
	```
	login1$ idev -p gh-dev -N 2 -n 2 -t 1:00:00
	```


1. Move to the code directory:
	```
	c123-456$ cd $SCRATCH/Machine-Learning-on-Vista
	```

1. Run the multi-gp training:
	```
	c123-456$ mpirun -np 2  --map-by ppr:1:node multinode.sh
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

NVIDIA is the recommended and default compiler suite on Vista. 

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

On Vista, both the HDF5 and PHDF5 modules define the environment variables `$TACC_HDF5_INC` and `$TACC_HDF5_LIB`. Other module files define similar environment variables; see Using Modules to Manage Your Environment for more information.

The details of the linking process vary, and order sometimes matters. Much depends on the type of library: static (.a suffix; library's binary code becomes part of executable image at link time) versus dynamically-linked shared (.so suffix; library's binary code is not part of executable; it's located and loaded into memory at run time). However, the `$LD_LIBRARY_PATH` environment variable specifies the search path for dynamic libraries. For software installed at the system-level, TACC's modules generally modify the `$LD_LIBRARY_PATH` automatically. To see whether and how an executable named myexe resolves dependencies on dynamically linked libraries, execute ldd myexe.

### MPI Programs

OpenMPI (`module ompi`) and MVAPICH (`module mvapich`) are the two MPI libraries available on Vista. After loading an `ompi` or `mvapich2` module, compile and/or link using an MPI wrapper (`mpicc`, `mpicxx`, `mpif90`) in place of the compiler:

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

When building software on Vista, we recommend using the most recent NVIDIA compiler and OpenMPI library available on Vista. The most recent versions may be newer than the defaults. Execute module spider nvidia and module spider ompi to see what's installed. When loading these modules you may need to specify version numbers explicitly (e.g. `module load nvidia/24.5` and `module load ompi/5.0`).

### Architecture-Specific Flags

The Grace architecture is based on an Arm design that uses Neoverse V2 cores  The Neovers V2 core support Arm’s Scalable Vector Extension v2(SVE2) and Advanced SIMD(NEON) technologies.  Each core has four 128-bit functional units that support 8 64-bit FMA operations. To compile for this specific architecture, include the -tp neoverse-v2 compile option. 

Normally, we do not recommend using the `-fast` option.  But, in this case, since there is only one chip architecture on Vista, and `-fast` does not enforce `-static`, it is safe to use the `-fast` option with the NVIDIA compilers. It will enable optimizations for the Neoverse V2 architecture. 

You can also use the environment variable `$TACC_VEC_FLAGS`.  This environment variable sets the following flags:

	-Mvect=simd -fast -Mipa=fast,inline

If you use GNU compilers, you can optimize for the Grace architecture using the -mcpu=neoverse-v2 option.  You can also use TACC_VEC_FLAGS as with the NVIDIA compilers.  It enables the following flags:

	-O3 -mcpu-neoverse-v2 

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

**Example**: A compile/link process on Vista may look like the following:
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
	[Submit a help desk ticket][HELPDESK] at any time via the TACC User Portal.  Be sure to include "Vista" in the Resource field.  

TACC Consulting operates from 8am to 5pm CST, Monday through Friday, except for holidays.  Help the consulting staff help you by following these best practices when submitting tickets. 

* **Do your homework** before submitting a help desk ticket. What does the user guide and other documentation say? Search the internet for key phrases in your error logs; that's probably what the consultants answering your ticket are going to do. What have you changed since the last time your job succeeded?

* **Describe your issue as precisely and completely as you can:** what you did, what happened, verbatim error messages, other meaningful output. 

!!! tip
	When appropriate, include as much meta-information about your job and workflow as possible including: 

	* directory containing your build and/or job script
	* all modules loaded 
	* relevant job IDs 
	* any recent changes in your workflow that could affect or explain the behavior you're observing.

* **[Subscribe to Vista User News][TACCSUBSCRIBE].** This is the best way to keep abreast of maintenance schedules, system outages, and other general interest items.

* **Have realistic expectations.** Consultants can address system issues and answer questions about Vista. But they can't teach parallel programming in a ticket, and may know nothing about the package you downloaded. They may offer general advice that will help you build, debug, optimize, or modify your code, but you shouldn't expect them to do these things for you.

* **Be patient.** It may take a business day for a consultant to get back to you, especially if your issue is complex. It might take an exchange or two before you and the consultant are on the same page. If the admins disable your account, it's not punitive. When the file system is in danger of crashing, or a login node hangs, they don't have time to notify you before taking action.

## References { #refs }

* [NVIDIA Grace Performance Tuning Guide](https://docs.nvidia.com/grace-perf-tuning-guide/index.html)
* [NVIDIA Performance Libraries Documentation](https://docs.nvidia.com/nvpl/)
* [Performance Analysis of Scientific Applications on an NVIDIA Grace System](https://ieeexplore-ieee-org.ezproxy.lib.utexas.edu/document/10820760)


[CREATETICKET]: https://tacc.utexas.edu/about/help/ "Create Support Ticket"
[SUBMITTICKET]: https://tacc.utexas.edu/about/help/ "Submit Support Ticket"
[HELPDESK]: https://tacc.utexas.edu/about/help/ "Help Desk"


[TACCGOODCONDUCT]: https://docs.tacc.utexas.edu/basics/conduct/ "TACC Good Conduct Guide"
[TACCSOFTWARE]: https://docs.tacc.utexas.edu/basics/software/ "Software at TACC"

[TACCDOCS]: https://docs.tacc.utexas.edu "TACC Documentation Portal"
[TACCACCESSCONTROLLISTS]: https://docs.tacc.utexas.edu/tutorials/acls "Access Control Lists"
[TACCACLS]: https://docs.tacc.utexas.edu/tutorials/acls "Manage Permissions with Access Control Lists"
[TACCBASHQUICKSTART]: https://docs.tacc.utexas.edu/tutorials/bashstartup "Bash Quick Start Guide"
[TACCIDEV]: https://docs.tacc.utexas.edu/software/idev "idev at TACC"
[TACCLMOD]: https://lmod.readthedocs.io/en/latest/ "Lmod"
[TACCMANAGINGACCOUNT]: https://docs.tacc.utexas.edu/basics/accounts "Managing your TACC Account"
[TACCMANAGINGIO]: https://docs.tacc.utexas.edu/tutorials/managingio "Managing I/O at TACC""
[TACCMANAGINGPERMISSIONS]: https://docs.tacc.utexas.edu/tutorials/permissions "Unix Group Permissions and Environment"
[TACCMFA]: https://docs.tacc.utexas.edu/basics/mfa "Multi-Factor Authentication at TACC"
[TACCPYLAUNCHER]: https://docs.tacc.utexas.edu/software/pylauncher "PyLauncher at TACC"
[TACCPARAVIEW]: https://docs.tacc.utexas.edu/software/paraview "Paraview at TACC"
[TACCREMOTEDESKTOPACCESS]: https://docs.tacc.utexas.edu/tutorials/remotedesktopaccess "TACC Remote Desktop Access"
[TACCSHARINGPROJECTFILES]: https://docs.tacc.utexas.edu/tutorials/sharingprojectfiles "Sharing Project Files"

[TACCUSERPORTAL]: https://tacc.utexas.edu/portal/login "TACC User Portal login"
[TACCDASHBOARD]: https://tacc.utexas.edu/portal/dashboard "TACC Dashboard"
[TACCPROJECTS]: https://tacc.utexas.edu/portal/projects "Projects & Allocations"

[TACCACCOUNTS]: https://accounts.tacc.utexas.edu "TACC Accounts Portal"
[TACCUSERPROFILE]: https://accounts.tacc.utexas.edu/profile "TACC Accounts User Profile"
[TACCSUBSCRIBE]: https://accounts.tacc.utexas.edu/user_updates "Subscribe to News"
[TACCLOGINSUPPORT]: https://accounts.tacc.utexas.edu/login_support "TACC Accounts Login Support Tool"

[TACCALLOCATIONS]: https://tacc.utexas.edu/use-tacc/allocations/ "TACC Allocations"
[TACCAUP]: https://accounts.tacc.utexas.edu/aup "TACC Acceptable Use Policy"
[TACCCITE]: https://tacc.utexas.edu/about/citing-tacc/ "Citing TACC"

[TACCSTAMPEDE3UG]: https://docs.tacc.utexas.edu/hpc/stampede3/ "TACC Stampede3 User Guide"
[TACCLONESTAR6UG]: https://docs.tacc.utexas.edu/hpc/lonestar6/ "TACC Lonestar6 User Guide"
[TACCFRONTERAUG]: https://docs.tacc.utexas.edu/hpc/frontera/ "TACC Frontera User Guide"
[TACCVISTAUG]: https://docs.tacc.utexas.edu/hpc/vista/ "TACC Vista User Guide"
[TACCRANCHUG]: https://docs.tacc.utexas.edu/hpc/ranch/ "TACC Ranch User Guide"
[TACCCORRALUG]: https://docs.tacc.utexas.edu/hpc/corral/ "TACC Corral User Guide"
[TACCSTOCKYARD]: https://tacc.utexas.edu/systems/stockyard  "Stockyard File System"
[TACCANALYSISPORTAL]: http://tap.tacc.utexas.edu "TACC Analysis Portal"

[DOWNLOADCYBERDUCK]: https://cyberduck.io/download/ "Download Cyberduck"
[CYBERDUCK]: https://cyberduck.io "Download Cyberduck"
[TACCSOFTWARELIST]: https://tacc.utexas.edu/use-tacc/software-list/ "TACC Software List"
