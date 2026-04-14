# Horizon User Guide 
*Last update: March 30, 2026*

## Notices { #notices }

* **[Subscribe][TACCSUBSCRIBE] to Horizon User News**. Stay up-to-date on Horizon's status, scheduled maintenances and other notifications.  (04/01/2026) 

## Introduction { #intro }

*Intro here*

Horizon is a National Science Foundation-funded system that is part of the the Leadership Class Computing Facility (LCCF) award, [Award Abstract #2323116](https://www.nsf.gov/awardsearch/show-award/?AWD_ID=2323116).  Please [reference TACC](https://tacc.utexas.edu/about/citing-tacc/) when providing any citations. 

### Allocations { #intro-allocations }

*Coming soon*.


## System Architecture { #system }

*content*

### Horizon Topology { #system-topology }

*image needed*

<!-- Horizon's compute system is divided into Grace-Grace and Grace-Hopper subsystems networked in two-level fat-tree topology as illustrated in Figure 1. below.

<figure><img src="../imgs/horizon/horizon-topology.png"> <figcaption>Figure 1. Horizon Topology</figcaption></figure>

The Grace-Grace (GG) subsystem, a purely CPU-based system, is housed in four racks, each containing 64 Grace-Grace (GG) nodes. Each GG node contains 144 processing cores. A GG node provides over 7 TFlops of double precision performance and up to 1 TiB/s of memory bandwidth. GG nodes connect via an InfiniBand 200 Gb/s fabric to a top rack shelf NVIDIA Quantum-2 MQM9790 NDR switch. In total, the subsystem contains sixty-four 200 Gb/s uplinks to the NDR rack shelf switch.

The Grace-Hopper (GH) subsystem, on the other  hand,  consists of nodes using the GH200 Grace-Hopper Superchip. Each GH node contains an NVIDIA H200 GPU  with 96 GiB of HBM3 memory and a Grace CPU with 120 GiB of LPDDR5X memory and 72 cores. A GH node provides 34 TFlops of FP64 performance and 1979 TFlops of FP16 performance for ML workflows on the H200 chip. The GH subsystem is housed in 19 racks, each containing 32 Grace-Hopper (GH) nodes. These nodes connect via an NVIDIA InfiniBand 400 Gb/s fabric to the NVIDIA Quantum-2 MQM9790 NDR switch having 64 ports of 400Gb/s InfiniBand per port. There are thirty-two 400 Gb/s uplinks to the NDR rack shelf switch. The GH nodes have twice the network bandwidth of the GG nodes.

Each top rack shelf switch in all racks connects to sixteen core switches via dual-400G cables. In total, Horizon contains 256 GG nodes and 600 GH nodes.   Both sets of nodes are connected with NDR fabric to two local file systems, `$HOME` and `$SCRATCH`. These are NFS-based flash file systems from VAST Data. The `$HOME` file system is designed for a small permanent storage area and is quota'd and backed up daily, while the `$SCRATCH` file system is designed for short term use from many nodes and is not quota'd but may be purged as needed. These file systems are connected to the management switch, which in turn is fully connected to the core network switches. The `$WORK` file system is a global Lustre file system connected to all of the TACC HPC resources. It is connected to Horizon via LNeT routers. 

!!!tip
	See NVIDIA'S <a href="https://docs.nvidia.com/grace-perf-tuning-guide/index.html">Grace Performance Tuning Guide</a> for very detailed information on the Grace system.

!!!info
	See TACC's [Performance Analysis of Scientific Applications on an NVIDIA Grace System](https://doi.org/10.1109/SCW63240.2024.00078)

-->

*system description needed*

### Vera Rubin Compute Nodes { #system-vr }

*description*

#### Table 1. Vera Rubin Specifications { #table1 }

Specification | Value 
--- | ---
CPU:                       | 
Total cores per node:      | 
Hardware threads per core: | 
Hardware threads per node: | 
Clock rate:                | 
Memory:                    | 
Cache:                     | 
Local storage:             | 
DRAM:                      | 

### Vera Vera Compute Nodes { #system-vv }

*description*


#### Table 2. Vera Vera Specifications { #table2 }

Specification                | Value 
---                          | ---
GPU:                         | 
GPU Memory:                  | 
CPU:                         | 
Total cores per node:        | 
Hardware threads per core:   | 
Hardware threads per node:   | 
Clock rate:                  | 
Memory:                      | 
Cache:                       | 
Local storage:               | 
DRAM:                        | 

### Login Nodes { #system-login }

<!-- The Horizon login nodes are NVIDIA Grace Grace (GG) nodes, each with 144 cores on two sockets (72 cores/socket) with 237 GB of LPDDR. -->

*description needed*

### Network { #system-network }

*copied from Vista*

The interconnect is based on Mellanox NDR technology with full NDR (400 Gb/s) connectivity between the switches and the GH GPU nodes and with NDR200 (200 Gb/s) connectivity to the GG compute nodes. A fat tree topology connects the compute nodes and the GPU nodes within separate trees.  Both sets of nodes are connected with NDR to the `$HOME` and `$SCRATCH` file systems. 

### File Systems { #system-filesystems }

Horizon will use a shared VAST file system for the `$HOME` and `$SCRATCH` directories. 

!!! important
	Horizon's `$HOME` and `$SCRATCH` file systems are NOT Lustre file systems and do not support setting a stripe count or stripe size. 

As with Stampede3, the `$WORK` file system will also be mounted.  Unlike `$HOME` and `$SCRATCH`, the `$WORK` file system is a Lustre file system and supports Lustre's `lfs` commands. All three file systems, `$HOME`, `$SCRATCH`, and `$WORK` are available from all Horizon nodes. The `/tmp` partition is also available to users but is local to each node. The `$WORK` file system is available on most other TACC HPC systems as well.


#### Table 3. File Systems { #table3 }

*update this table for Horizon*

File System | Type | Quota | Key Features
---         | -- | ---   | ---
`$HOME` | VAST   | 23 GB, 500,000 files | Not intended for parallel or high−intensity file operations.<br>Backed up regularly.
`$WORK` | Lustre | 1 TB, 3,000,000 files across all TACC systems<br>Not intended for parallel or high−intensity file operations.<br>See [Stockyard system description][TACCSTOCKYARD] for more information. | Not backed up. | Not purged.
`$SCRATCH` | VAST | no quota<br>Overall capacity ~10 PB. | Not backed up.<br>Files are subject to purge if access time* is more than 10 days old. See TACC's [Scratch File System Purge Policy](#scratchpolicy) below.


<!-- commenting out for Google Docs version {% include 'include/scratchpolicy.md' %}  -->


## Managing Your Files { #files }

Horizon mounts three file systems that are shared across all nodes: the home, work, and scratch file systems. Horizon's startup mechanisms define corresponding account-level environment variables `$HOME`, `$SCRATCH`, and `$WORK` that store the paths to directories that you own on each of these file systems. Consult the Horizon [File Systems](#table6) table for the basic characteristics of these file systems, [File Operations: I/O Performance](#programming-io) for advice on performance issues, and [Good Conduct][TACCGOODCONDUCT] for tips on file system etiquette.

{% include 'include/spacetip.md' %}

### Navigating the Shared File Systems { #files-filesystems }

Horizon's `/home` and `/scratch` file systems are mounted only on Horizon, but the work file system mounted on Horizon is the Global Shared File System hosted on [Stockyard](https://tacc.utexas.edu/systems/stockyard/).  Stockyard is the same work file system that is currently available on Frontera, Lonestar6, and several other TACC resources.

The `$STOCKYARD` environment variable points to the highest-level directory that you own on the Global Shared File System. The definition of the `$STOCKYARD` environment variable is of course account-specific, but you will see the same value on all TACC systems that provide access to the Global Shared File System. This directory is an excellent place to store files you want to access regularly from multiple TACC resources.

Your account-specific `$WORK` environment variable varies from system to system and is a sub-directory of `$STOCKYARD` (Figure 1). The sub-directory name corresponds to the associated TACC resource. The `$WORK` environment variable on Horizon points to the `$STOCKYARD/horizon` subdirectory, a convenient location for files you use and jobs you run on Horizon. Remember, however, that all subdirectories contained in your `$STOCKYARD` directory are available to you from any system that mounts the file system. If you have accounts on both Horizon and Frontera, for example, the `$STOCKYARD/horizon` directory is available from your Frontera account, and `$STOCKYARD/frontera` is available from your Horizon account.

!!! note 
	Your quota and reported usage on the Global Shared File System reflects **all files that you own on Stockyard**, regardless of their actual location on the file system.

See the example for fictitious user bjones in the figure below.  All directories are accessible from all systems, however a given sub-directory (e.g. lonestar6, frontera) will exist only if you have an allocation on that system.  [Figure 1](#figure1) below illustrates account-level directories on the `$WORK` file system (Global Shared File System hosted on Stockyard).   

<figure id="figure1"><img src="../imgs/stockyard-2026.png">
<figcaption>Stockyard 2026</figcaption></figure>

Note that the resource-specific sub-directories of `$STOCKYARD` are nothing more than convenient ways to manage your resource-specific files. You have access to any such sub-directory from any TACC resources. If you are logged into Horizon, for example, executing the alias cdw (equivalent to cd `$WORK`) will take you to the resource-specific sub-directory `$STOCKYARD/horizon`. But you can access this directory from other TACC systems as well by executing cd `$STOCKYARD/horizon`. These commands allow you to share files across TACC systems. In fact, several convenient account-level aliases make it even easier to navigate across the directories you own in the shared file systems:

### Table 7. Built-in Account Level Aliases { #table7 }

Alias | Command
--- | ---
`cd` or `cdh` | `cd $HOME`
`cdw` | `cd $WORK`
`cds` | `cd $SCRATCH`
`cdy` or `cdg` | `cd $STOCKYARD`


### Sharing Files with Collaborators { #files-sharing }

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems][TACCSHARINGPROJECTFILES] for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.

## Running Jobs { #running }


<!-- ### Slurm Job Scheduler { #running-slurm } -->

### Slurm Partitions (Queues) { #queues }

Horizon's job scheduler is the Slurm Workload Manager. Slurm commands enable you to submit, manage, monitor, and control your jobs.  <!-- See the [Job Management](#jobmanagement) section below for further information. -->

!!! important
    **Queue limits are subject to change without notice.**
    Horizon admins may occasionally adjust queue <!--the QOS--> settings in order to ensure fair scheduling for the entire user community.
    TACC's `qlimits` utility will display the latest queue configurations.


<a id="queues">
#### Table 4. Production Queues { #table4 }

*copied from Vista - update*

Queue Name  | Node Type     | Max Nodes per Job<br>(assoc'd cores) | Max Job<br>Duration | Max Nodes<br>per User   | Max Jobs<br>per User | Max Submit | Charge Rate<br>(per node-hour)
--          | --            | --                                   | --                  | --                      |--        |--         |--
`gg`        | Grace/Grace   | 32 nodes<br>(4608 cores)             | 48 hrs              | 128                     | 20       | 40        | 0.33 SU
`gh`        | Grace/Hopper  | 64 nodes<br>(4608 cores/64 gpus)     | 48 hrs              | 192                     | 20       | 40        | 1 SUs
`gh-dev`    | Grace Hopper  | 8 nodes<br>(576 cores)               |  2 hrs              | 8                       | 1        | 3         | 1 SU


<!-- commenting out for Google Docs version 
{% include 'include/horizon-jobaccounting.md' %}

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

-->
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
[TACCMANAGINGIO]: https://docs.tacc.utexas.edu/tutorials/managingio "Managing I/O at TACC"
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
[TACCAUP]: https://tacc.utexas.edu/use-tacc/user-policies/ "TACC Acceptable Use Policy"
[TACCCITE]: https://tacc.utexas.edu/about/citing-tacc/ "Citing TACC"

[TACCSTAMPEDE3UG]: https://docs.tacc.utexas.edu/hpc/stampede3/ "TACC Stampede3 User Guide"
[TACCLONESTAR6UG]: https://docs.tacc.utexas.edu/hpc/lonestar6/ "TACC Lonestar6 User Guide"
[TACCFRONTERAUG]: https://docs.tacc.utexas.edu/hpc/frontera/ "TACC Frontera User Guide"
[TACCVISTAUG]: https://docs.tacc.utexas.edu/hpc/vista/ "TACC Vista User Guide"
[TACCHORIZONAUG]: https://docs.tacc.utexas.edu/hpc/horizon/ "TACC Horizon User Guide"
[TACCRANCHUG]: https://docs.tacc.utexas.edu/hpc/ranch/ "TACC Ranch User Guide"
[TACCCORRALUG]: https://docs.tacc.utexas.edu/hpc/corral/ "TACC Corral User Guide"
[TACCSTOCKYARD]: https://tacc.utexas.edu/systems/stockyard  "Stockyard File System"
[TACCANALYSISPORTAL]: http://tap.tacc.utexas.edu "TACC Analysis Portal"

[DOWNLOADCYBERDUCK]: https://cyberduck.io/download/ "Download Cyberduck"
[CYBERDUCK]: https://cyberduck.io "Download Cyberduck"
[TACCSOFTWARELIST]: https://tacc.utexas.edu/use-tacc/software-list/ "TACC Software List"
