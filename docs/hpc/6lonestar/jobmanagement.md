## Job Management { #jobs }

In this section, we present several Slurm commands and other utilities that are available to help you plan and track your job submissions as well as check the status of the Slurm queues.

When interpreting queue and job status, remember that **Lonestar6 doesn't operate on a first-come-first-served basis**. Instead, the sophisticated, tunable algorithms built into Slurm attempt to keep the system busy, while scheduling jobs in a way that is as fair as possible to everyone. At times this means leaving nodes idle ("draining the queue") to make room for a large job that would otherwise never run. It also means considering each user's "fair share", scheduling jobs so that those who haven't run jobs recently may have a slightly higher priority than those who have.

### Monitoring Queue Status { #jobs-monitoring }

#### TACC's `qlimits` command { #jobs-monitoring-qlimits }

To display resource limits for the Lonestar queues, execute: `qlimits`. The result is real-time data; the corresponding information in this document's [table of Lonestar6 queues](#queues) may lag behind the actual configuration that the `qlimits` utility displays.

#### Slurm's `sinfo` command { #jobs-monitoring-sinfo }

Slurm's `sinfo` command allows you to monitor the status of the queues. If you execute `sinfo` without arguments, you'll see a list of every node in the system together with its status. To skip the node list and produce a tight, alphabetized summary of the available queues and their status, execute:

```cmd-line
login1$ sinfo -S+P -o "%18P %8a %20F"    # compact summary of queue status
```

An excerpt from this command's output might look like this:

```cmd-line
login1$ sinfo -S+P -o "%18P %8a %20F"
PARTITION          AVAIL    NODES(A/I/O/T)    
development        up       0/8/0/8
v100               up       44/43/1/96          
v100-lm            up       0/8/0/8
```
	
The `AVAIL` column displays the overall status of each queue (up or down), while the column labeled `NODES(A/I/O/T)` shows the number of nodes in each of several states ("**A**llocated", "**I**dle", "**O**ffline", and "**T**otal"). Execute `man sinfo` for more information. Use caution when reading the generic documentation, however: some available fields are not meaningful or are misleading on Lonestar6 (e.g. `TIMELIMIT`, displayed using the `%l` option).

### Monitoring Job Status { #jobs-monitoring-jobstatus }

#### Slurm's `squeue` command { #sjobs-monitoring-queuestatus }

Slurm's `squeue` command allows you to monitor jobs in the queues, whether pending (waiting) or currently running:

```cmd-line
login1$ squeue             # show all jobs in all queues
login1$ squeue -u bjones   # show all jobs owned by bjones
login1$ man squeue         # more info
```

An excerpt from the default output might look like this:

```cmd-line
 JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
25781 development idv72397   bjones CG       9:36      2 c001-011,012
25918 development ppm_4828   bjones PD       0:00     20 (Resources)
25915 development MV2-test    siliu PD       0:00     14 (Priority)
25589        v100   aatest slindsey PD       0:00      8 (Dependency)
25949 development psdns_la sniffjck PD       0:00      2 (Priority)
25618        v100   SP256U   connor PD       0:00      1 (Dependency)
25944        v100  MoTi_hi   wchung  R      35:13      1 c005-003
25945        v100 WTi_hi_e   wchung  R      27:11      1 c006-001
25606        v100   trainA   jackhu  R   23:28:28      1 c008-012
```

The column labeled `ST` displays each job's status: 

* `PD` means "Pending" (waiting); 
* `R`  means "Running";
* `CG` means "Completing" (cleaning up after exiting the job script).

Pending jobs appear in order of decreasing priority. The last column includes a nodelist for running/completing jobs, or a reason for pending jobs. If you submit a job before a scheduled system maintenance period, and the job cannot complete before the maintenance begins, your job will run when the maintenance/reservation concludes. The `squeue` command will report `ReqNodeNotAvailable` ("Required Node Not Available"). The job will remain in the `PD` state until Lonestar6 returns to production.

The default format for `squeue` now reports total nodes associated with a job rather than cores, tasks, or hardware threads. One reason for this change is clarity: the operating system sees each compute node's 56 hardware threads as "processors", and output based on that information can be ambiguous or otherwise difficult to interpret. 

The default format lists all nodes assigned to displayed jobs; this can make the output difficult to read. A handy variation that suppresses the nodelist is:

```cmd-line
login1$ squeue -o "%.10i %.12P %.12j %.9u %.2t %.9M %.6D"  # suppress nodelist
```

The `--start` option displays job start times, including very rough estimates for the expected start times of some pending jobs that are relatively high in the queue:

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

If your waiting job cannot complete before a maintenance/reservation begins, `showq` will display its state as `**WaitNod**` ("Waiting for Nodes"). The job will remain in this state until Lonestar6 returns to production.

The default format for `showq` now reports total nodes associated with a job rather than cores, tasks, or hardware threads. One reason for this change is clarity: the operating system sees each compute node's 112 hardware threads as "processors", and output based on that information can be ambiguous or otherwise difficult to interpret.

### Dependent Jobs using `sbatch` { #jobs-dependencies }

You can use `sbatch` to help manage workflows that involve multiple steps: the `--dependency` option allows you to launch jobs that depend on the completion (or successful completion) of another job. For example you could use this technique to split into three jobs a workflow that requires you to (1) compile on a single node; then (2) compute on 40 nodes; then finally (3) post-process your results using 4 nodes. 

``` cmd-line
login1$ sbatch --dependency=afterok:173210 myjobscript
```

For more information see the [Slurm online documentation](http://www.schedmd.com). Note that you can use `$SLURM_JOBID` from one job to find the jobid you'll need to construct the `sbatch` launch line for a subsequent one. But also remember that you can't use `sbatch` to submit a job from a compute node.


### Other Job Management Commands { #jobs-other }

 `scancel`, `scontrol`, and `sacct`

**It's not possible to add resources to a job (e.g. allow more time)** once you've submitted the job to the queue.

To **cancel** a pending or running job, first determine its jobid, then use `scancel`:

```cmd-line
login1$ squeue -u bjones    # one way to determine jobid
 JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
170361        v100   spec12   bjones PD       0:00     32 (Resources)
login1$ scancel 170361      # cancel job
```

For **detailed information** about the configuration of a specific job, use `scontrol`:

```cmd-line
login1$ scontrol show job=170361
```

To view some **accounting data** associated with your own jobs, use `sacct`:

```cmd-line
login1$ sacct --starttime 2019-06-01  # show jobs that started on or after this date
```

