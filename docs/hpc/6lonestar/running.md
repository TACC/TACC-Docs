## Running Jobs { #running }

Lonestar6's job scheduler is the <a href="http://schedmd.com">Slurm Workload Manager</a>. Slurm commands enable you to submit, manage, monitor, and control your jobs. Jobs submitted to the scheduler are queued, then run on the compute nodes. Each job consumes Service Units (SUs) which are then charged to your allocation. See the [Job Management](#jobs) section below for further information.


### Production Queues 

Lonestar6's new queue, `vm-small` is designed for users who only need a subset of a node's entire 128 cores in the "normal" queue.  Run your jobs in this queue if your job requires 16 cores or less and needs less than 29 GB of memory.  If your job is memory bandwidth dependent, your performance may decrease since your job will be possibly sharing memory bandwidth with other jobs.  

The jobs in this queue consume 1/7 the resources of a full node.  Jobs are charged accordingly at .143 SUs per node hour.


!!! important
    **Queue limits are subject to change without notice.**
    Frontera admins may occasionally adjust queue <!--the QOS--> settings in order to ensure fair scheduling for the entire user community.
    TACC's `qlimits` utility will display the latest queue configurations.

!!! warning
    **Queue Restrictions**
    Do not request specific nodes when submitting jobs without prior approval from staff.  Allow Slurm to allocate nodes as appropriate.

    Any job requesting specific compute nodes via batch scripts, `idev` invocations, or MPI hostfiles will be deleted from the queue.

<!--
login1.ls6(568)$ qlimits
Name             MinNode  MaxNode     MaxWall  MaxNodePU  MaxJobsPU   MaxSubmit
development            1        8    02:00:00          8          1           3
gpu-a100               1        8  2-00:00:00         12          8          32
gpu-a100-dev           1        2    02:00:00          2          1           3
gpu-a100-small         1        1  2-00:00:00          3          3          12
gpu-h100               1        1  2-00:00:00          1          1           4
large                 65      256  2-00:00:00        256          1           4
normal                 1       64  2-00:00:00         64         20         100
vm-small               1        1  2-00:00:00          4          4          16
--
login1.ls6(569)$ m /usr/local/etc/queue.map
# ls6
development:1.0
gpu-a100:3.0
gpu-a100-dev:3.0
gpu-a100-small:1.5
gpu-h100:6.0
large:1.0
normal:1.0
vm-small:0.143
-->

<a id="queues"></a>
#### Table 5. Production Queues { #table5 }

Queue Name | Min/Max Nodes per Job<br>(assoc'd cores)&#42; | Max Job<br>Duration | Max Nodes<br>per User | Max Jobs<br>per User | Max Submit | Charge Rate<br>(per node-hour)
--- | --- | --- | --- | --- | --- | ---
<code>development</code>                         | 8 nodes<br>(1024 cores)       |  2 hours |   8 |  1 | 3 | 1 SU
<code>gpu-a100</code>                            | 8 nodes<br>(1024 cores)       | 48 hours |  12 |  8 | 32 | 3 SUs
<code>gpu-a100-dev</code>                        | 2 nodes<br>(256 cores)        |  2 hours |   2 |  1 | 3 | 3 SUs
<code>gpu-a100-small</code><sup>&#42;&#42;</sup> | 1 node                        | 48 hours |   3 |  3 | 12 | 1.5 SUs
<code>gpu-h100</code>                            | 1 node                        | 48 hours |   1 |  1 | 4 | 6 SUs | (96 cores)
<code>large</code><sup>&#42;</sup>               | 65/256 nodes<br>(65536 cores) | 48 hours | 256 |  1 | 4 | 1 SU
<code>normal</code>                              | 1/64 nodes<br>(8192 cores)    | 48 hours |  64 | 20 | 100 | 1 SU
<code>vm-small</code><sup>&#42;&#42;</sup>       | 1 node<br>(16 cores)          | 48 hours |   4 |  4 | 16 | 0.143 SU


&#42; Access to the `large` queue is restricted. To request more nodes than are available in the normal queue, submit a consulting (help desk) ticket through the TACC User Portal. Include in your request reasonable evidence of your readiness to run under the conditions you're requesting. In most cases this should include your own strong or weak scaling results from Lonestar6.

&#42;&#42; The `gpu-a100-small` and `vm-small` queues contain virtual nodes with fewer resources (cores) than the nodes in the other queues.

{% include 'include/lonestar6-jobaccounting.md' %}


### Submitting Batch Jobs with `sbatch` { #running-sbatch }

Use Slurm's `sbatch` command to submit a batch job to one of the Lonestar6 queues:

```cmd-line
login1$ sbatch myjobscript
```

Where `myjobscript` is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting. The details of your job script's contents depend on the type of job you intend to run.

In your job script you (1) use `#SBATCH` directives to request computing resources (e.g. 10 nodes for 2 hrs); and then (2) use shell commands to specify what work you're going to do once your job begins. There are many possibilities: you might elect to launch a single application, or you might want to accomplish several steps in a workflow. You may even choose to launch more than one application at the same time. The details will vary, and there are many possibilities. But your own job script will probably include at least one launch line that is a variation of one of the examples described here.

Your job will run in the environment it inherits at submission time; this environment includes the modules you have loaded and the current working directory. In most cases you should run your applications(s) after loading the same modules that you used to build them. You can of course use your job submission script to modify this environment by defining new environment variables; changing the values of existing environment variables; loading or unloading modules; changing directory; or specifying relative or absolute paths to files. **Do not** use the Slurm `--export` option to manage your job's environment: doing so can interfere with the way the system propagates the inherited environment.

[Table 5.5](#table55) below describes some of the most common `sbatch` command options. Slurm directives begin with `#SBATCH`; most have a short form (e.g. `-N`) and a long form (e.g. `--nodes`). You can pass options to `sbatch` using either the command line or job script; most users find that the job script is the easier approach. The first line of your job script must specify the interpreter that will parse non-Slurm commands; in most cases `#!/bin/bash` or `#!/bin/csh` is the right choice. Avoid `#!/bin/sh` (its startup behavior can lead to subtle problems on Lonestar6), and do not include comments or any other characters on this first line. All `#SBATCH` directives must precede all shell commands. Note also that certain `#SBATCH` options or combinations of options are mandatory, while others are not available on Lonestar6.

By default, Slurm writes all console output to a file named "`slurm-%j.out`", where `%j` is the numerical job ID. To specify a different filename use the `-o` option. To save `stdout` (standard out) and `stderr` (standard error) to separate files, specify both `-o` and `-e` options.

!!! tip
	The maximum runtime for any individual job is 48 hours.  However, if you have good checkpointing implemented, you can easily chain jobs such that the outputs of one job are the inputs of the next, effectively running indefinitely for as long as needed.  See Slurm's `-d` option.

#### Table 5.5 Common `sbatch` Options { #table55 }

Option | Argument | Comments
--- | --- | ---
`-A`  | *projectid* | Charge job to the specified project/allocation number. This option is only necessary for logins associated with multiple projects.
`-a`<br>or<br>`--array` | =*tasklist* | Lonestar6 supports Slurm job arrays.  See the [Slurm documentation on job arrays](https://slurm.schedmd.com/job_array.html) for more information.
`-d=` | afterok:*jobid* | Specifies a dependency: this run will start only after the specified job (jobid) successfully finishes
`-export=` | N/A | Avoid this option on Lonestar6. Using it is rarely necessary and can interfere with the way the system propagates your environment.
`--gres` | N/A | Lonestar6 does not support this option. Slurm will reject any job script containing this directive.
`--gpus-per-task` | N/A | Lonestar6 does not support this option. Slurm will reject any job script containing this directive.
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


