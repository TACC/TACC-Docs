## Job Management { #jobs }

In this section, we present several Slurm commands and other utilities that are available to help you plan and track your job submissions as well as check the status of the Slurm queues.

!!!important
	When interpreting queue and job status, remember that **Vista does not operate on a first-come-first-served basis**. Instead, the sophisticated, tunable algorithms built into Slurm attempt to keep the system busy, while scheduling jobs in a way that is as fair as possible to everyone. At times this means leaving nodes idle ("draining the queue") to make room for a large job that would otherwise never run. It also means considering each user's "fair share", scheduling jobs so that those who haven't run jobs recently may have a slightly higher priority than those who have.

### Monitoring Queue Status { #jobs-monitoring }

Monitor queue status via Slurm's `sinfo` command and/or TACC's `qlimits` utility.

#### TACC's `qlimits` command { #jobs-monitoring-qlimits }

To display resource limits for the Lonestar queues, execute: `qlimits`. The result is real-time data; the corresponding information in this document's [table of Vista queues](#queues) may lag behind the actual configuration that the `qlimits` utility displays.

#### Slurm's `sinfo` command { #jobs-monitoring-sinfo }

Slurm's `sinfo` command allows you to monitor the status of the queues. If you execute `sinfo` without arguments, you'll see a list of every node in the system together with its status. To skip the node list and produce a tight, alphabetized summary of the available queues and their status, execute:

```cmd-line
login1$ sinfo -S+P -o "%18P %8a %20F"    # compact summary of queue status
```
his command's output might look like this:

```cmd-line
PARTITION          AVAIL    NODES(A/I/O/T)
gg                 up       208/7/36/251
gh                 up       572/4/0/576
gh-dev*            up       18/0/2/20
```
	
The `AVAIL` column displays the overall status of each queue (up or down), while the column labeled `NODES(A/I/O/T)` shows the number of nodes in each of several states ("**A**llocated", "**I**dle", "**O**ffline", and "**T**otal"). Execute `man sinfo` for more information. Use caution when reading the generic documentation, however: some available fields are not meaningful or are misleading on Vista (e.g. `TIMELIMIT`, displayed using the `%l` option).

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
    674649          gg bb_rag_s rtoscano PD       0:00      1 (Dependency)
    696999          gg  g6_deim   999999 PD       0:00      1 (DependencyNeverSatisfied)
    696818          gg TESSA_J1 slindsey PD       0:00      2 (Dependency)
    696817          gg TESSA_J2 slindsey PD       0:00      2 (Dependency)
    690973          gg TESSA_J2 slindsey  R 1-23:42:47      2 i617-[062-063]
    696803          gg TESSA_J2 slindsey  R    3:24:00      2 i617-[001-002]
    697595          gh 2wiki300  ashleyp CG    3:36:29      1 c634-022
    673236          gh   IFML-R   895124 PD       0:00      1 (QOSMaxWallDurationPerJobLimit)
    697740          gh lysozyme sarajane PD       0:00     16 (Priority)
    697456          gh grpo_eva jemerson PD       0:00      1 (Dependency)
    695288          gh tldr_int kellykel PD       0:00      1 (DependencyNeverSatisfied)
    695427          gh idv02624 reynolds  R 1-18:40:00      8 c611-[071,122],c619-031,c620-[051,141-142],c640-[061-062]
    697606          gh musique3 tg111111  R    3:22:17      1 c612-021
    697613          gh ga_vmme_  bcatton  R    3:02:21      2 c613-152,c619-052
    695666          gh idv43155 camiguet  R 1-16:44:38      1 c621-052
    697723          gh ga_lvb_r  mylouis  R      16:19      2 c637-021,c641-061
    697782          gh proc_syn cmannion  R      34:45      8 c611-032,c613-[141,151],c619-151,c620-031,c622-[102,131,152]
    697057      gh-dev  BNS_VLR  acw6923 CG    1:02:28      1 c642-002
    697675      gh-dev     bash minchaoh CG    1:48:16      5 c642-[072,081-082,091-092]
    697802      gh-dev idv24504    gbell PD       0:00      1 (Resources)
    614573      gh-dev jupyter- jheldman PD       0:00      1 (JobHeldAdmin)
    611728      gh-dev jupyter- jheldman PD       0:00      1 (JobHeldAdmin)
    697772      gh-dev idv19251 reynolds  R      43:26      1 c642-011
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
`ReqNodeNotAvailable` | If you submit a job before a scheduled system maintenance period, and the job cannot complete before the maintenance begins, your job will run when the maintenance/reservation concludes.  The job will remain in the `PD` state until Vista returns to production.
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

If your waiting job cannot complete before a maintenance/reservation begins, `showq` will display its state as `**WaitNod**` ("Waiting for Nodes"). The job will remain in this state until Vista returns to production.

Since TACC charges by the node rather than core, `showq`'s default format now reports total nodes associated with a job rather than cores, tasks, or hardware threads.  Run `showq` with the `-l` option to display the number of cores and the job's queue.


### Dependent Jobs using `sbatch` { #jobs-dependencies }

You can use `sbatch` to help manage workflows that involve multiple steps: the `--dependency` option allows you to launch jobs that depend on the completion (or successful completion) of another job. For example you could use this technique to split into three jobs a workflow that requires you to (1) compile on a single node; then (2) compute on 40 nodes; then finally (3) post-process your results using 4 nodes. 

``` cmd-line
login1$ sbatch --dependency=afterok:173210 myjobscript
```

!!! warning
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
	170361          gh   spec12   bjones PD       0:00     32 (Resources)
	login1$ scancel 170361      # cancel job
	```

* For **detailed information** about the configuration of a specific job, use `scontrol`:

	```cmd-line
	login1$ scontrol show job=170361
	```

