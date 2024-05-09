## [Running Jobs](#running) { #running }

{% include 'include/stampede3-jobaccounting.md' %}

<!-- ### [Slurm Job Scheduler](#running-slurm) { #running-slurm } -->


### [Slurm Partitions (Queues)](#queues) { #queues }

Stampede3's job scheduler is the Slurm Workload Manager. Slurm commands enable you to submit, manage, monitor, and control your jobs.  See the [Job Management](#jobmanagement) section below for further information. 

!!! important
	**Queues and limits are subject to change without notice.** <br>Execute `qlimits` on Stampede3 for real-time information regarding limits on available queues.  <!-- See Monitoring Jobs and Queues for additional information. -->

#### [Table 7. Production Queues](#table7) { #table7 }

Queue Name   | Node Type | Max Nodes per Job<br>(assoc'd cores) | Max Duration | Max Jobs in Queue | Charge Rate<br>(per node-hour)
--           | --        | --                                   | --           | --                |  
icx          | ICX       | 16 nodes<br>(1280 cores)             | 24 hrs       | 4                 | 1.67 SUs
pvc          | PVC       | 1 node<br>(96 cores)                 | 48 hrs       | 2                 | 4 SUs
skx          | SKX       | 64 nodes<br>(3072 cores)             | 24 hrs       | 4                 | 1 SU
skx-dev      | SKX       | 16 nodes<br>(798 cores)              | 2 hrs        | 1                 | 1 SU
spr          | SPR       | 16 nodes<br>(896 cores)              | 24 hrs       | 6                 | 3 SUs


<!-- SDL 05/07 no skx-large yet
**&#42; To request more nodes than are available in the skx-normal queue, submit a consulting (help desk) ticket. Include in your request reasonable evidence of your readiness to run under the conditions you're requesting. In most cases this should include your own strong or weak scaling results from Stampede3.** -->

### [Submitting Batch Jobs with `sbatch`](#running-sbatch)  { #running-sbatch }

Use Slurm's `sbatch` command to submit a batch job to one of the Stampede3 queues:

```cmd-line
login1$ sbatch myjobscript
```

Where `myjobscript` is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting. The details of your job script's contents depend on the type of job you intend to run.

In your job script you (1) use `#SBATCH` directives to request computing resources (e.g. 10 nodes for 2 hrs); and then (2) use shell commands to specify what work you're going to do once your job begins. There are many possibilities: you might elect to launch a single application, or you might want to accomplish several steps in a workflow. You may even choose to launch more than one application at the same time. The details will vary, and there are many possibilities. But your own job script will probably include at least one launch line that is a variation of one of the examples described here.

Your job will run in the environment it inherits at submission time; this environment includes the modules you have loaded and the current working directory. In most cases you should run your applications(s) after loading the same modules that you used to build them. You can of course use your job submission script to modify this environment by defining new environment variables; changing the values of existing environment variables; loading or unloading modules; changing directory; or specifying relative or absolute paths to files. **Do not** use the Slurm `--export` option to manage your job's environment: doing so can interfere with the way the system propagates the inherited environment.

The Common `sbatch` Options table below describes some of the most common `sbatch` command options. Slurm directives begin with `#SBATCH`; most have a short form (e.g. `-N`) and a long form (e.g. `--nodes`). You can pass options to `sbatch` using either the command line or job script; most users find that the job script is the easier approach. The first line of your job script must specify the interpreter that will parse non-Slurm commands; in most cases `#!/bin/bash` or `#!/bin/csh` is the right choice. Avoid `#!/bin/sh` (its startup behavior can lead to subtle problems on Stampede3), and do not include comments or any other characters on this first line. All `#SBATCH` directives must precede all shell commands. Note also that certain `#SBATCH` options or combinations of options are mandatory, while others are not available on Stampede3.

#### [Table 8. Common `sbatch` Options](#table8)

Option | Argument | Comments
--- | --- | ---
`-p`  | queue_name | Submits to queue (partition) designated by queue_name
`-J`  | job_name   | Job Name
`-N`  | total_nodes | Required. Define the resources you need by specifying either:<br>(1) `-N` and `-n`; or<br>(2) `-N` and `-ntasks-per-node`.
`-n`  | total_tasks | This is total MPI tasks in this job. See `-N` above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set it to the same value as `-N`.
`-ntasks-per-node`<br>or<br>`-tasks-per-node` | tasks_per_node | This is MPI tasks per node. See `-N` above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set `-ntasks-per-node` to 1.
`-t`  | hh:mm:ss | Required. Wall clock time for job.
`-mail-user=` | email_address | Specify the email address to use for notifications. Use with the `-mail-type=` flag below.
`-mail-type=` | begin, end, fail, or all | Specify when user notifications are to be sent (one option per line).
`-o`  | output_file | Direct job standard output to output_file (without `-e` option error goes to this file)
`-e`  | error_file | Direct job error output to error_file
`-d=` | afterok:jobid | Specifies a dependency: this run will start only after the specified job (jobid) successfully finishes
`-A`  | projectid | Charge job to the specified project/allocation number. This option is only necessary for logins associated with multiple projects.
`-a`<br>or<br>`-array` | N/A | Not available. Use the launcher module for parameter sweeps and other collections of related serial jobs.
`-mem`  | N/A | Not available. If you attempt to use this option, the scheduler will not accept your job.
`-export=` | N/A | Avoid this option on Stampede3. Using it is rarely necessary and can interfere with the way the system propagates your environment.

By default, Slurm writes all console output to a file named "`slurm-%j.out`", where `%j` is the numerical job ID. To specify a different filename use the `-o` option. To save `stdout` (standard out) and `stderr` (standard error) to separate files, specify both `-o` and `-e` options.
