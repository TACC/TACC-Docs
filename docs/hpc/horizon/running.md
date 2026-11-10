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


