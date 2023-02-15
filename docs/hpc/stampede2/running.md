## [Running Jobs on the Compute Nodes](#running) { #running }

{% include 'include/stampede2-jobaccounting.md' %}

### [Slurm Job Scheduler](#running-slurm) { #running-slurm }

Stampede2's job scheduler is the [Slurm Workload Manager](http://schedmd.com). Slurm commands enable you to submit, manage, monitor, and control your jobs. 

### [Slurm Partitions (Queues)](#running-queues) { #running-queues }

Currently available queues include those in [Stampede2 Production Queues](#table5). See [KNL Compute Nodes](#overview-phase1computenodes), [SKX Compute Nodes](#overview-skxcomputenodes), [Memory Modes](#programming-knl-memorymodes), and [Cluster Modes](#programming-knl-clustermodes) for more information on node types.

#### [Table 5. Stampede2 Production Queues](#table5)

Queue Name | Node Type | Max Nodes per Job<br /> (assoc'd cores)&#42; | Max Duration | Max Jobs in Queue &#42; | Charge Rate<br /> (per node-hour) 
--- | --- | --- | --- | --- | ---
<code>development</code> | KNL cache-quadrant | 16 nodes<br /> (1,088 cores)&#42; | 2 hrs | 1&#42; | 0.8 Service Unit (SU)
<code>normal</code> | KNL cache-quadrant | 256 nodes<br /> (17,408 cores) &#42; | 48 hrs | 50 &#42; | 0.8 SU
<code>large</code> &#42;&#42; | KNL cache-quadrant | 2048 nodes<br /> (139,264 cores) &#42;&#42; | 48 hrs | 5 &#42;&#42; | 0.8 SU
<code>long</code> | KNL cache-quadrant | 32 nodes<br>(2,176 cores) &#42; | 120 hrs | 2  &#42; | 0.8 SU
<code>flat-quadrant</code> | KNL flat-quadrant | 32 nodes<br /> (2,176 cores)  &#42; | 48 hrs | 5  &#42; | 0.8 SU
<code>skx-dev</code> | SKX | 4 nodes<br>(192 cores) &#42; | 2 hrs | 1 &#42; | 1 SU
<code>skx-normal</code> | SKX | 128 nodes<br>(6,144 cores) &#42; | 48 hrs | 20 &#42; | 1 SU
<code>skx-large</code> &#42; &#42; | SKX | 868 nodes<br>(41,664 cores) &#42; | 48 hrs | 3 &#42; | 1 SU
<code>icx-normal</code> | ICX | 40 nodes<br>(3,200 cores) &#42; | 48 hrs | 20 &#42; | 1.67 SU

&#42; Queue status as of March 7, 2022. **Queues and limits are subject to change without notice.** Execute `qlimits` on Stampede2 for real-time information regarding limits on available queues. See [Monitoring Jobs and Queues](#monitoring) for additional information.

&#42;&#42; To request more nodes than are available in the normal queue, submit a consulting (help desk) ticket through the [TACC][TACCUSERPORTAL].  Include in your request reasonable evidence of your readiness to run under the conditions you're requesting. In most cases this should include your own strong or weak scaling results from Stampede2.

&#42;&#42;&#42; For non-hybrid memory-cluster modes or other special requirements, submit a ticket through the [TACC User Portal][TACCUSERPORTAL].

### [Submitting Batch Jobs with `sbatch`](#running-sbatch) { #running-sbatch }

Use Slurm's `sbatch` command to [submit a batch job](#using-computenodes) to one of the Stampede2 queues:

<pre class="cmd-line">login1$ <b>sbatch myjobscript</b></pre>

Here `myjobscript` is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting. The details of your job script's contents depend on the type of job you intend to run. 

In your job script you (1) use `#SBATCH` directives to request computing resources (e.g. 10 nodes for 2 hrs); and then (2) use shell commands to specify what work you're going to do once your job begins. There are many possibilities: you might elect to launch a single application, or you might want to accomplish several steps in a workflow. You may even choose to launch more than one application at the same time. The details will vary, and there are many possibilities. But your own job script will probably include at least one launch line that is a variation of one of the examples described here.

Your job will run in the environment it inherits at submission time; this environment includes the modules you have loaded and the current working directory. In most cases you should **run your applications(s) after loading the same modules that you used to build them**.  You can of course use your job submission script to modify this environment by defining new environment variables; changing the values of existing environment variables; loading or unloading modules; changing directory; or specifying relative or absolute paths to files. **Do not use the Slurm <span style="white-space: nowrap;">`--export`</span> option to manage your job's environment**: doing so can interfere with the way the system propagates the inherited environment.

The [Common `sbatch` Options table](#table6) below describes some of the most common `sbatch` command options. Slurm directives begin with `#SBATCH`; most have a short form (e.g. <span style="white-space: nowrap;">`-N`</span>) and a long form (e.g. <span style="white-space: nowrap;">`--nodes`</span>). You can pass options to `sbatch` using either the command line or job script; most users find that the job script is the easier approach. The first line of your job script must specify the interpreter that will parse non-Slurm commands; in most cases <span style="white-space: nowrap;">`#!/bin/bash`</span> or <span style="white-space: nowrap;">`#!/bin/csh`</span> is the right choice. Avoid <span style="white-space: nowrap;">`#!/bin/sh`</span> (its startup behavior can lead to subtle problems on Stampede2), and do not include comments or any other characters on this first line. All `#SBATCH` directives must precede all shell commands. Note also that certain `#SBATCH` options or combinations of options are mandatory, while others are not available on Stampede2.


#### [Table 6. Common <code>sbatch</code> Options](#table6)

Option | Argument | Comments
--- | --- | ---
<code>-p</code> | <i>queue_name</i> | Submits to queue (partition) designated by <i>queue_name</i>
<code>-J</code> |  <i>job_name</i> |  Job Name
<code>-N</code> | <i>total_nodes</i> | Required. Define the resources you need by specifying either:<br>(1) <code>-N</code> and <code>-n</code>; or<br>(2) <code>-N</code> and <code>--ntasks-per-node</code>. 
<code>-n</code> | <i>total_tasks</i> | This is total MPI tasks in this job. See <code><span style="white-space: nowrap;">-N</span></code> above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set it to the same value as <code>-N</code>.
<code><span style="white-space: nowrap;">--ntasks-per-node</span></code><br>or<br><code>--tasks-per-node</code> | <i>tasks_per_node</i> | This is MPI tasks per node. See <code>-N</code> above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set <code>--ntasks-per-node</code> to 1.
<code>-t</code> | <i>hh:mm:ss</i> | Required. Wall clock time for job.
<code>--mail-user=</code> | <i>email_address</i> | Specify the email address to use for notifications. Use with the <code>--mail-type=</code> flag below.
<code>--mail-type=</code> | <code>begin</code>, <code>end</code>, <code>fail</code>, or  <code>all</code> | Specify when user notifications are to be sent (one option per line).
<code>-o</code> | <i>output_file</i> | Direct job standard output to <i>output_file</i> (without <code>-e</code> option error goes to this file)
<code>-e</code> | <i>error_file</i> | Direct job error output to <i>error_file</i>
<code>-d=</code> | afterok:<i>jobid</i> | Specifies a dependency: this run will start only after the specified job (<i>jobid</i>) successfully finishes
<code>-A</code> | <i>projectnumber</i> | Charge job to the specified project/allocation number.  This option is only necessary for logins associated with multiple projects.   
<code>-a</code><br>or<br><code>--array</code> | N/A | Not available. Use the <code>launcher</code> module for parameter sweeps and other collections of related serial jobs.
<code>--mem</code> | N/A | Not available. If you attempt to use this option, the scheduler will not accept your job.
<code>--export=</code> | N/A | Avoid this option on Stampede2. Using it is rarely necessary and can interfere with the way the system propagates your environment.

By default, Slurm writes all console output to a file named <span style="white-space: nowrap;">`slurm-%j.out`</span>, where `%j` is the numerical job ID. To specify a different filename use the <span style="white-space: nowrap;">`-o`</span> option. To save `stdout` (standard out) and `stderr` (standard error) to separate files, specify both <span style="white-space: nowrap;">`-o`</span> and <span style="white-space: nowrap;">`-e`</span>.


### [Launching Applications](#running-launching) { #running-launching }

The primary purpose of your job script is to launch your research application. How you do so depends on several factors, especially (1) the type of application (e.g. MPI, OpenMP, serial), and (2) what you're trying to accomplish (e.g. launch a single instance, complete several steps in a workflow, run several applications simultaneously within the same job). While there are many possibilities, your own job script will probably include a launch line that is a variation of one of the examples described in this section:

* [Launching One Serial Application](#running-launching-serial)
* [Launching One Multi-Threaded Application](#running-launching-multi)
* [Launching One MPI Application](#running-launching-mpi)
* [Launching One Hybrid (MPI+Threads) Application](#running-launching-hybrid)
* [More Than One Serial Application in the Same Job](#running-launching-serialmorethanone)
* [More than One MPI Application Running Concurrently](#running-launching-mpisimultaneous)
* [More than One OpenMP Application Running Concurrently](#running-launching-openmpsimultaneous)

#### [Launching One Serial Application](#running-launching-serial) { #running-launching-serial }

To launch a serial application, simply call the executable. Specify the path to the executable in either the PATH environment variable or in the call to the executable itself:

``` { .bash .job-script }
myprogram                   # executable in a directory listed in $PATH
$WORK/apps/myprov/myprogram # explicit full path to executable
./myprogram                 # executable in current directory
./myprogram -m -k 6 input1  # executable with notional input options
```

#### [Launching One Multi-Threaded Application](#running-launching-multi) { #running-launching-multi }

Launch a threaded application the same way. Be sure to specify the number of threads. **Note that the default OpenMP thread count is 1**.

``` { .bash .job-script }
export OMP_NUM_THREADS=68    # 68 total OpenMP threads (1 per KNL core)
./myprogram
```

#### [Launching One MPI Application](#running-launching-mpi) { #running-launching-mpi }

To launch an MPI application, use the TACC-specific MPI launcher `ibrun`, which is a Stampede2-aware replacement for generic MPI launchers like `mpirun` and `mpiexec`. In most cases the only arguments you need are the name of your executable followed by any arguments your executable needs. When you call `ibrun` without other arguments, your Slurm `#SBATCH` directives will determine the number of ranks (MPI tasks) and number of nodes on which your program runs.

``` { .bash .job-script }
#SBATCH -N 5
#SBATCH -n 200
ibrun ./myprogram              # ibrun uses the $SBATCH directives to properly allocate nodes and tasks

```

To use `ibrun` interactively, say within an `idev` session, you can specify:

<pre class="cmd-line">
login1$ <b>idev -N 2 -n 80 </b>
c123-456$ <b>ibrun ./myprogram</b>    # ibrun uses idev's arguments to properly allocate nodes and tasks
</pre>

### [Launching One Hybrid (MPI+Threads) Application](#running-launching-hybrid) { #running-launching-hybrid }

When launching a single application you generally don't need to worry about affinity: both Intel MPI and MVAPICH2 will distribute and pin tasks and threads in a sensible way.

``` { .bash .job-script }
export OMP_NUM_THREADS=8    # 8 OpenMP threads per MPI rank
ibrun ./myprogram           # use ibrun instead of mpirun or mpiexec
```

As a practical guideline, the product of `$OMP_NUM_THREADS` and the maximum number of MPI processes per node should not be greater than total number of cores available per node (KNL nodes have 68 cores, SKX nodes have 48 cores, ICX nodes have 80 cores).

### [More Than One Serial Application in the Same Job](#running-launching-serialmorethanone) { #running-launching-serialmorethanone }

TACC's `launcher` utility provides an easy way to launch more than one serial application in a single job. This is a great way to engage in a popular form of High Throughput Computing: running parameter sweeps (one serial application against many different input datasets) on several nodes simultaneously. The `launcher` utility will execute your specified list of independent serial commands, distributing the tasks evenly, pinning them to specific cores, and scheduling them to keep cores busy. Execute `module load launcher` followed by `module help launcher` for more information.

#### [MPI Applications One at a Time](#running-launching-consecutivempi) { #running-launching-consecutivempi }

To run one MPI application after another (or any sequence of commands one at a time), simply list them in your job script in the order in which you'd like them to execute. When one application/command completes, the next one will begin.

``` { .bash .job-script }
module load git
module list
./preprocess.sh
ibrun ./myprogram input1	# runs after preprocess.sh completes
ibrun ./myprogram input2    # runs after previous MPI app completes
```

#### [More than One MPI Application Running Concurrently](#running-launching-mpisimultaneous) { #running-launching-mpisimultaneous }

To run more than one MPI application simultaneously in the same job, you need to do several things:

* use ampersands to launch each instance in the background;
* include a `wait` command to pause the job script until the background tasks complete;
* use the `ibrun "-n` and `-o` switches to specify task counts and hostlist offsets respectively; and
* include a call to the `task_affinity` script in your `ibrun` launch line.

If, for example, you use `#SBATCH` directives to request N=4 nodes and n=128 total MPI tasks, Slurm will generate a hostfile with 128 entries (32 entries for each of 4 nodes). The `-n` and `-o` switches, which must be used together, determine which hostfile entries ibrun uses to launch a given application; execute <span style="white-space: nowrap;">`ibrun --help`</span> for more information. **Don't forget the ampersands (`&`)** to launch the jobs in the background, **and the `wait` command** to pause the script until the background tasks complete:

``` { .bash .job-script }
ibrun -n 64 -o  0 task_affinity ./myprogram input1 &amp;   # 64 tasks; offset by  0 entries in hostfile.
ibrun -n 64 -o 64 task_affinity ./myprogram input2 &amp;   # 64 tasks; offset by 64 entries in hostfile.
wait                                                       # Required; else script will exit immediately.
```

The `task_affinity` script does two things:

* `task_affinity` manages task placement and pinning when you call `ibrun` with the `-n`, `-o` switches (it's not necessary under any other circumstances); and
* `task_affinity` also manages MCDRAM when you run in flat-quadrant mode on the KNL. It does this in the same way as [`mem_affinity`](#managing-memory). 
* **Don't confuse `task_affinity` with [`tacc_affinity`](#managing-memory)**; the keyword `tacc_affinity` is now a symbolic link to `mem_affinity`. The `mem_affinity` script and the symbolic link `tacc_affinity` manage MCDRAM in flat-quadrant mode on the KNL, but they do not pin MPI tasks.


#### [More than One OpenMP Application Running Concurrently](#running-launching-openmpsimultaneous) { #running-launching-openmpsimultaneous }

You can also run more than one OpenMP application simultaneously on a single node, but you will need to <!-- [distribute and pin tasks appropriately](http://pages.tacc.utexas.edu/~eijkhout/pcse/html/omp-affinity.html) --> distribute and pin tasks appropriately. In the example below, <span style="white-space: nowrap;">`numactl -C`</span> specifies virtual CPUs (hardware threads). According to the numbering scheme for KNL hardware threads, CPU (hardware thread) numbers 0-67 are spread across the 68 cores, 1 thread per core. Similarly for SKX: CPU (hardware thread) numbers 0-47 are spread across the 48 cores, 1 thread per core, and for ICX: CPU (hardware thread) numbers 0-79 are spread across the 80 cores, 1 thread per core. See [TACC training materials](http://portal.tacc.utexas.edu/training#/session/64) for more information.

``` { .bash .job-script }
export OMP_NUM_THREADS=2
numactl -C 0-1 ./myprogram inputfile1 &amp;  # HW threads (hence cores) 0-1. Note ampersand.
numactl -C 2-3 ./myprogram inputfile2 &amp;  # HW threads (hence cores) 2-3. Note ampersand.

wait
```


### [Interactive Sessions with `idev` and `srun`](#running-idev) { #running-idev }

TACC's own `idev` utility is the best way to begin an interactive session on one or more compute nodes. To launch a thirty-minute session on a single node in the development queue, simply execute:

<pre class="cmd-line">login1$ <b>idev</b></pre>

You'll then see output that includes the following excerpts:

<pre class="cmd-line">
...
-----------------------------------------------------------------
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Welcome to the Stampede2 Supercomputer          
-----------------------------------------------------------------
...

-> After your idev job begins to run, a command prompt will appear,
-> and you can begin your interactive development session. 
-> We will report the job status every 4 seconds: (PD=pending, R=running).

->job status:  PD
->job status:  PD
...
c449-001$</pre>


The `job status` messages indicate that your interactive session is waiting in the queue. When your session begins, you'll see a command prompt on a compute node (in this case, the node with hostname c449-001). If this is the first time you launch `idev`, the prompts may invite you to choose a default project and a default number of tasks per node for future `idev` sessions.

For command line options and other information, execute <span style="white-space: nowrap;">`idev --help`</span>. It's easy to tailor your submission request (e.g. shorter or longer duration) using Slurm-like syntax:

<pre class="cmd-line">login1$ <b>idev -p normal -N 2 -n 8 -m 150</b> # normal queue, 2 nodes, 8 total tasks, 150 minutes</pre>

For more information see the [`idev` documentation](http://portal.tacc.utexas.edu/software/idev).

You can also launch an interactive session with Slurm's `srun` command, though there's no clear reason to prefer `srun` to `idev`. A typical launch line would look like this:

<pre class="cmd-line">login1$ <b>srun --pty -N 2 -n 8 -t 2:30:00 -p normal /bin/bash -l </b># same conditions as above</pre>


### [Interactive Sessions using `ssh`](#running-ssh) { #running-ssh }

If you have a batch job or interactive session running on a compute node, you "own the node": you can connect via `ssh` to open a new interactive session on that node. This is an especially convenient way to monitor your applications' progress. One particularly helpful example: login to a compute node that you own, execute `top`, then press the "1" key to see a display that allows you to monitor thread ("CPU") and memory use.

There are many ways to determine the nodes on which you are running a job, including feedback messages following your `sbatch` submission, the compute node command prompt in an `idev` session, and the `squeue` or `showq` utilities. The sequence of identifying your compute node then connecting to it would look like this:


<pre class="cmd-line">
login1$ <b>squeue -u bjones</b>
 JOBID       PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
858811     development idv46796   bjones  R       0:39      1 c448-004
1ogin1$ <b>ssh c448-004</b>
...
C448-004$</pre>


### [SLURM Environment Variables](#running-slurmenvvars) { #running-slurmenvvars }

Be sure to distinguish between internal Slurm replacement symbols (e.g. `%j` described above) and Linux environment variables defined by Slurm (e.g. `SLURM_JOBID`). Execute <span style="white-space: nowrap;">`env | grep SLURM`</span> from within your job script to see the full list of Slurm environment variables and their values. You can use Slurm replacement symbols like `%j` only to construct a Slurm filename pattern; they are not meaningful to your Linux shell. Conversely, you can use Slurm environment variables in the shell portion of your job script but not in an `#SBATCH` directive. For example, the following directive will not work the way you might think:

``` { .bash .job-script }
<s>#SBATCH -o myMPI.o${SLURM_JOB_ID}</s>   # incorrect
```

Instead, use the following directive:

``` { .bash .job-script }
#SBATCH -o myMPI.o%j     # "%j" expands to your job's numerical job ID
```

Similarly, you cannot use paths like `$WORK` or `$SCRATCH` in an `#SBATCH` directive.

For more information on this and other matters related to Slurm job submission, see the [Slurm online documentation](https://slurm.schedmd.com/sbatch.html); the man pages for both Slurm itself (<span style="white-space: nowrap;">`man slurm`</span>) and its individual command (e.g. <span style="white-space: nowrap;">`man sbatch`</span>); as well as numerous other online resources.


