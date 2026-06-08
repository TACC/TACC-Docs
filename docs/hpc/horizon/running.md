## Running Jobs { #running }

<!-- ### Slurm Job Scheduler { #running-slurm } -->

Like all other current TACC systems, Horizon employs the Slurm Workload Manager as it's job scheduler.  Slurm commands enable you to submit, manage, monitor, and control your jobs.  <!-- See the [Job Management](#jobmanagement) section below for further information. -->

### Slurm Partitions (Queues) { #queues }

!!! warning
    **Queue limits are subject to change without notice.**
    Horizon admins may occasionally adjust queue settings in order to ensure fair scheduling for the entire user community.
    TACC's `qlimits` utility will display the latest queue configurations.

<a id="queues">
#### Table 4. Production Queues { #table4 }

| Queue Name | Node Type       | Max Nodes per Job | Max Job Duration | Charge Rate (per node-hour) 
| -----      | -----           | -----             | -----            | -----                       
| `gb`       | Grace Blackwell | 128               | 48 hrs           | 1 SU 
| `gb-dev`   | Grace Blackwell | 16                | 2 hrs            | 1 SU 
| `gb-large` | Grace Blackwell | 512               | 48 hrs           | 1 SU 
| `vv`       | Vera Vera       | 256               | 48 hrs           | 0.25 SUs 
| `vv-dev`   | Vera Vera       | 32                | 2 hrs            | 0.25 SUs 
| `vv-large` | Vera Vera       | 1024              | 48 hrs           | 0.25 SUs 

Reminder: A Grace Blackwell node contains 1 Grace CPU and 2 Blackwell GPUs. 

