## Running Jobs { #running }

Frontera's job scheduler is the <a href="http://schedmd.com">Slurm Workload Manager</a>. Slurm commands enable you to submit, manage, monitor, and control your jobs. Jobs submitted to the scheduler are queued, then run on the compute nodes. Each job consumes Service Units (SUs) which are then charged to your allocation.

{%include 'include/frontera-jobaccounting.md' %}

### Requesting Resources  { #running-requesting } 

Be sure to request computing resources e.g., number of nodes, number of tasks per node, max time per job, that are consistent with the type of application(s) you are running:

* A **serial** (non-parallel) application can only make use of a single core on a single node, and will only see that node's memory.
* A threaded program (e.g. one that uses **OpenMP**) employs a shared memory programming model and is also restricted to a single node, but the program's individual threads can run on multiple cores on that node. 
* An **MPI** (Message Passing Interface) program can exploit the distributed computing power of multiple nodes: it launches multiple copies of its executable (MPI **tasks**, each assigned unique IDs called **ranks**) that can communicate with each other across the network. The tasks on a given node, however, can only directly access the memory on that node. Depending on the program's memory requirements, it may not be possible to run a task on every core of every node assigned to your job. If it appears that your MPI job is running out of memory, try launching it with fewer tasks per node to increase the amount of memory available to individual tasks.
* A popular type of **parameter sweep** (sometimes called **high throughput computing**) involves submitting a job that simultaneously runs many copies of one serial or threaded application, each with its own input parameters ("Single Program Multiple Data", or SPMD). TACC's `pylauncher` tool is designed to make it easy to submit this type of job.  See [PyLauncher at TACC][TACCPYLAUNCHER] for more information.

<a id="queues">
### Frontera Production Queues { #running-queues } 


Frontera's Slurm partitions (queues), maximum node limits and charge rates are summarized in the table below. **Queues and limits are subject to change without notice.** Execute `qlimits` on Frontera for real-time information regarding limits on available queues. See [Job Accounting](#jobaccounting) to learn how jobs are charged to your allocation.

Frontera's newest queue, `small`, has been created specifically for one and two node jobs. Jobs of one or two nodes that will run for up to 48 hours should be submitted to this new `small` queue. The `normal` queue now has a lower limit of three nodes for all jobs. 

The `nvdimm` queue features 16 [large-memory (2.1TB) nodes](#system-largememory). Access to this queue is not restricted, however jobs in this queue are charged at twice the rate of the `normal`, `development` and `large`  queues. 

Frontera's `flex` queue offers users a low cost queue for lower priority/node count jobs and jobs running software with checkpointing capabilities. Jobs in the `flex` queue are scheduled with lower priority and are also eligible for preemption after running for one hour.  That is, if other jobs in the other queues are currently waiting for nodes and there are jobs running in the `flex` queue, the Slurm scheduler will cancel any jobs in the `flex` queue that have run more than one hour in order to give resources back to the higher priority jobs. Any job started in the `flex` queue is guaranteed to run for at least an hour (assuming the requested wallclock time was >= 1 hour). If there remain no outstanding requests from other queues, then these jobs will continue to run until they hit their wallclock requested time. This flexibility in runtime is rewarded by a reduced charge rate of .8 SUs/hour. Also, the max total node count for one user with many jobs in the flex queue is 6400 nodes.


#### Table 6. Frontera Production Queues { #table6 } 

!!! important
    **Queue limits are subject to change without notice.**   
	Frontera admins may occasionally adjust queue <!--the QOS--> settings in order to ensure fair scheduling for the entire user community.   
    TACC's `qlimits` utility will display the latest queue configurations.  

<!--
01/20/2026
frontera2(1)$ qlimits
Current queue/partition limits on TACC's Frontera system:

The "running job limit" is the MaxJobsPU column. MaxJobsPU is the maximum number of jobs a user can have running simultaneously.
The "job submission limit" is the MaxSubmit column. The MaxSubmit limit is the maximum number of jobs a user can have in the queue. 

           Name       MinNode       MaxNode   PreemptExemptTime     MaxWall     MaxNodePU MaxJobsPU MaxSubmit
           flex             1           128            01:00:00  2-00:00:00          2048        15        60
    development                          40                        02:00:00            40         2         2
         normal             1           512                      2-00:00:00          1280        75       200
          large           513          2048                      2-00:00:00          3072         2         8
          debug                        8368                      2-00:00:00          8368        30        60
            rtx                          16                      2-00:00:00            32        20        36
        rtx-dev                           2                        02:00:00             2         2         2
         nvdimm                           4                      2-00:00:00             6         4         8
          small             1             2                      2-00:00:00            30        22        80
          grace                          30                      5-00:00:00            30        30       100
         corral                         512                      2-00:00:00          2048       100       200
             gh                           1                        02:00:00             1         2         2

frontera2(2)$ m /usr/local/etc/queue.map
# frontera
flex:0.8
development:1.0
normal:1.0
large:1.0
rtx:3.0
rtx-dev:3.0
nvdimm:2.0
small:1.0
-->

| Queue Name | Min-Max Nodes per Job<br>(assoc'd cores) | Pre-empt<br>Exempt Time | Max Job Duration | Max Nodes per User | Max Jobs per User | Max Submit | Charge Rate<br>per node-hour
| ------                        | -----                             | ----        | ----             | ----        | ----   |    | ----
| <code>flex&#42;</code>        | 1-128 nodes<br>(7,168 cores)      | 1 hour      | 48 hrs           | 6400 nodes  | 15     |  60 | .8 Service Units (SUs) 
| <code>development</code>      | 1-40 nodes<br>(2,240 cores)       | N/A         | 2 hrs            |   40 nodes  |  1     |   2 | 1 SU 
| <code>normal</code>           | 3-512 nodes<br>(28,672 cores)     | N/A         | 48 hrs           | 1024 nodes  | 75     | 200 | 1 SU   
| <code>large&#42;&#42;</code>  | 513-2048 nodes<br>(114,688 cores) | N/A         | 48 hrs           | 3072 nodes  |  1     |   8 | 1 SU
| <code>rtx</code>              | 16 nodes                          | N/A         | 48 hrs           |   32 nodes  | 12     |  36 | 3 SUs
| <code>rtx-dev</code>          | 2 nodes                           | N/A         | 2 hrs            |    2 nodes  |  1     |   2 | 3 SUs
| <code>nvdimm</code>           | 4 nodes                           | N/A         | 48 hrs           |    6 nodes  |  3     |   8 | 2 SUs 
| <code>small</code>            | 1-2 nodes                         | N/A         | 48 hrs           |   25 nodes  | 15     |  80 | 1 SU


   
&#42; **Jobs in the `flex` queue are charged less than jobs in other queues but are eligible for preemption after running for more than one hour.**  
&#42;&#42; **Access to the large queue is restricted**. To request more nodes than are available in the `normal` queue, [submit a consulting ticket][HELPDESK].  Include in your request reasonable evidence of your readiness to run under the conditions you're requesting. In most cases this should include your own strong or weak scaling results from Frontera.



### Accessing the Compute Nodes { #running-computenodes } 

 The login nodes are shared resources: at any given time, there are many users logged into each of these login nodes, each preparing to access the "back-end" compute nodes (Figure 2. Login and Compute Nodes). What you do on the login nodes affects other users directly because you are competing for the same resources: memory and processing power. This is the reason you should not run your applications on the login nodes or otherwise abuse them. Think of the login nodes as a prep area where you can manage files and compile code before accessing the compute nodes to perform research computations. See [Good Conduct][TACCGOODCONDUCT] for more information.

#### Figure 2. Login and Compute Nodes { #figure2 } 
<figure id="figure2"><img alt="[Figure 2. Login and Compute Nodes" src="../imgs/login-compute-nodes.jpg">
<figcaption></figcaption></figure>

You can use your command-line prompt, or the `hostname` command, to discern whether you are on a login node or a compute node. The default prompt, or any custom prompt containing `\h`, displays the short form of the hostname <u>(e.g. `c401-064`)</u>. The hostname for a Frontera login node begins with the string `login` (e.g. `login2.frontera.tacc.utexas.edu`), while compute node hostnames begin with the character `c` <u>(e.g. `c401-064.frontera.tacc.utexas.edu`)</u>. 

While some workflows, tools, and applications hide the details, there are three basic ways to access the compute nodes:

1.	[Submit a **batch job** using the `sbatch` command](#running-sbatch). This directs the scheduler to run the job unattended when there are resources available. Until your batch job begins it will wait in a [queue](#queues). You do not need to remain connected while the job is waiting or executing. Note that the scheduler does not start jobs on a first come, first served basis; it juggles many variables to keep the machine busy while balancing the competing needs of all users. The best way to minimize wait time is to request only the resources you really need: the scheduler will have an easier time finding a slot for the two hours you need than for the 24 hours you unnecessarily request.

1.	Begin an [interactive session using **`ssh`**](#running-ssh) to connect to a compute node on which you are already running a job. This is a good way to open a second window into a node so that you can monitor a job while it runs.

1.	Begin an [**interactive session** using `idev` or `srun`](#running-interactive). This will log you into a compute node and give you a command prompt there, where you can issue commands and run code as if you were doing so on your personal machine. An interactive session is a great way to develop, test, and debug code. Both the `srun` and `idev` commands submit a new batch job on your behalf, providing interactive access once the job starts. You will need to remain logged in until the interactive session begins.


### Submitting Batch Jobs with `sbatch` { #running-sbatch } 

Use Slurm's `sbatch` command to submit a batch job to one of the Frontera queues:

```cmd-line
login1$ sbatch myjobscript
```

Here `myjobscript` is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting. The details of your job script's contents depend on the type of job you intend to run. 

In each job script: 

1. use `#SBATCH` directives to request computing resources (e.g. 10 nodes for 2 hrs); 
2. then, list shell commands to specify what work you're going to do once your job begins. 

There are many possibilities: you might elect to launch a single application, or you might want to accomplish several steps in a workflow. You may even choose to launch more than one application at the same time. The details will vary, and there are many possibilities. But your own job script will probably include at least one launch line that is a variation of one of the examples described here.

!!! tip

   	See the [customizable job script examples](#scripts) below.

Your job will run in the environment it inherits at submission time; this environment includes the modules you have loaded and the current working directory. In most cases you should **run your application(s) after loading the same modules that you used to build them**. You can of course use your job submission script to modify this environment by defining new environment variables; changing the values of existing environment variables; loading or unloading modules; changing directory; or specifying relative or absolute paths to files. **Do not use the Slurm `--export` option to manage your job's environment**: doing so can interfere with the way the system propagates the inherited environment.

The [Common `sbatch` Options table](#table7) below describes some of the most common `sbatch` command options. Slurm directives begin with `#SBATCH`; most have a short form (e.g. `-N`) and a long form (e.g. `--nodes`). You can pass options to `sbatch` using either the command line or job script; most users find that the job script is the easier approach. The first line of your job script must specify the interpreter that will parse non-Slurm commands; in most cases `#!/bin/bash` or `#!/bin/csh` is the right choice. Avoid `#!/bin/sh` (its startup behavior can lead to subtle problems on Frontera), and do not include comments or any other characters on this first line. All `#SBATCH` directives must precede all shell commands. Note also that certain `#SBATCH` options or combinations of options are mandatory, while others are not available on Frontera.


#### Table 7. Common <code>sbatch</code> Options { #table7 } 

| Option | Argument | Comments |
| --- | --- | -- |
<code>-p</code> | <i>queue_name</i> | Submits to queue (partition) designated by <i>queue_name</i>
<code>-J</code> | <i>job_name</i> | Job Name
<code>-N</code> | <i>total_nodes</i> | Required. Define the resources you need by specifying either:<br>(1) <code>-N</code> and <code>-n</code>; or<br>(2) <code>-N</code> and <code>--ntasks-per-node</code>. 
<code>-n</code> | <i>total_tasks</i> | This is total MPI tasks in this job. See <code>-N</code> above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set it to the same value as <code>-N</code>.
<span style="white-space: nowrap;"><code>--ntasks-per-node</code></span><br>or<br><code>--tasks-per-node</code></td> | <i>tasks_per_node</i> | This is MPI tasks per node. See <code>-N</code> above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set <code>--ntasks-per-node</code> to 1.
<code>-t</code> | <i>hh:mm:ss</i> | Required. Wall clock time for job.
<span style="white-space: nowrap;"><code>--mail-user=</code></span> | <i>email_address</i> | Specify the email address to use for notifications.
<code>--mail-type=</code> | <code>begin</code>, <code>end</code>, <code>fail</code>, or <code>all</code> | Specify when user notifications are to be sent (one option per line).
<code>-o</code> | <i>output_file</i> | Direct job standard output to <i>output_file</i> (without <code>-e</code> option error goes to this file)
<code>-e</code> | <i>error_file</i> | Direct job error output to <i>error_file</i>
<code>--dependency=</code> | <i>jobid</i> | Specifies a dependency: this run will start only after the specified job (<i>jobid</i>) successfully finishes
<code>-A</code> | <i>projectnumber</i> | Charge job to the specified project/allocation number. This option is only necessary for logins associated with multiple projects.   
<code>-a</code><br>or<br><code>--array</code> | N/A | Not available. Use the <code>pylauncher</code> module for parameter sweeps and other collections of related serial jobs.
<code>--mem</code> | N/A | Not available. If you attempt to use this option, the scheduler will not accept your job.
<code>--export=</code> | N/A | Avoid this option on Frontera. Using it is rarely necessary and can interfere with the way the system propagates your environment.

By default, Slurm writes all console output to a file named `slurm-%j.out`, where `%j` is the numerical job ID. To specify a different filename use the `-o` option. To save `stdout` (standard out) and `stderr` (standard error) to separate files, specify both `-o` and `-e`.


### Interactive Sessions with `idev` and `srun` { #running-interactive } 

TACC's own `idev` utility is the best way to begin an interactive session on one or more compute nodes. `idev` submits a batch script requesting access to a compute node. Once the scheduler allocates a compute node, you are then automatically ssh'd to that node where you can begin any compute-intensive jobs.  

To launch a thirty-minute session on a single node in the `development` queue, simply execute:

```cmd-line
login1$ idev
```

You'll then see output that includes the following excerpts:

```cmd-line
...
-----------------------------------------------------------------
		Welcome to the Frontera Supercomputer          
-----------------------------------------------------------------
...

-> After your idev job begins to run, a command prompt will appear,
-> and you can begin your interactive development session. 
-> We will report the job status every 4 seconds: (PD=pending, R=running).

->job status:  PD
->job status:  PD
...
c123-456$
```

The `job status` messages indicate that your interactive session is waiting in the queue. When your session begins, you'll see a command prompt on a compute node (in this case, the node with hostname `c449-001`). If this is the first time you invoke `idev`, you may be prompted to choose a default project and a default number of tasks per node for future `idev` sessions.

For command-line options and other information, execute `idev --help`. It's easy to tailor your submission request (e.g. shorter or longer duration) using Slurm-like syntax:

```cmd-line
login1$ idev -p normal -N 2 -n 8 -m 150 # normal queue, 2 nodes, 8 total tasks, 150 minutes
```

You can also launch an interactive session with Slurm's `srun` command, though there's no clear reason to prefer `srun` to `idev`. A typical launch line would look like this:

```cmd-line
login1$ srun --pty -N 2 -n 8 -t 2:30:00 -p normal /bin/bash -l # same conditions as above
```

Consult the [`idev`][TACCIDEV] documentation for further details.

### Interactive Sessions using SSH { #running-ssh } 

If you have a batch job or interactive session running on a compute node, you "own the node": you can connect via `ssh` to open a new interactive session on that node. This is an especially convenient way to monitor your applications' progress. One particularly helpful example: login to a compute node that you own, execute `top`, then press the "1" key to see a display that allows you to monitor thread ("CPU") and memory use.

There are many ways to determine the nodes on which you are running a job, including feedback messages following your `sbatch` submission, the compute node command prompt in an `idev` session, and the `squeue` or `showq` utilities. The sequence of identifying your compute node then connecting to it would look like this:


```cmd-line
login1$ squeue -u bjones
 JOBID       PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
858811     development idv46796   bjones  R       0:39      1 c448-004
1ogin1$ ssh c448-004
...
C448-004$
```


### Slurm Environment Variables { #running-slurmenvvars } 

Be sure to distinguish between internal Slurm replacement symbols (e.g. `%j` described above) and Linux environment variables defined by Slurm (e.g. `SLURM_JOBID`). Execute `env | grep SLURM` from within your job script to see the full list of Slurm environment variables and their values. You can use Slurm replacement symbols like `%j` only to construct a Slurm filename pattern; they are not meaningful to your Linux shell. Conversely, you can use Slurm environment variables in the shell portion of your job script but not in an `#SBATCH` directive. For example, the following directive will not work the way you might think:

```job-script
#SBATCH -o myMPI.o${SLURM_JOB_ID}   # incorrect
```

Instead, use the following directive:

```job-script
#SBATCH -o myMPI.o%j     # "%j" expands to your job's numerical job ID
```

Similarly, you cannot use paths like `$WORK` or `$SCRATCH` in an `#SBATCH` directive.

For more information on this and other matters related to Slurm job submission, see the [Slurm online documentation](https://slurm.schedmd.com/sbatch.html); the man pages for both Slurm itself (`man slurm`) and its individual commands (e.g. `man sbatch`); as well as numerous other online resources.


