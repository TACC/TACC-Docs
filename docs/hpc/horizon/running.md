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



