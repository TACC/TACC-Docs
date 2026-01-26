# PyTorch at TACC

This documentation describes how to run a PyTorch multi-GPU **sanity test** (`multigpu_torchrun.py`) on TACC high-performance computing
systems using three supported environment models:

*   [Python virtual environments (venv)](venv.md)
*   [User-installed Conda environments](containers.md)
*   [Containers via Apptainer](containers.md)

<!-- ## Purpose of This Guide

These pages focus on validating:

-   GPU visibility inside user environments
-   CUDA correctness
-   NCCL/DDP communication
-   `torchrun` launcher functionality
-   Filesystem access from compute nodes

This workload is a **sanity test**, not a benchmark or production
training run. -->


## Global Rules (Apply to All Methods)

### Where Work Must Be Done

-   All computation must occur inside an `idev` session on GPU compute
    nodes.
-   All files, environments, containers, and output must live in
    `$SCRATCH`.
-   Do not build or run from `$HOME` or `$WORK`.

### General Workflow

1.  `cd $SCRATCH`
2.  Clone the PyTorch examples repository
3.  Launch an `idev` session
4.  Activate the environment
5.  Verify GPU visibility
6.  Run `torchrun`

### GPU Verification

    nvidia-smi
    python - <<EOF
    import torch
    print(torch.cuda.device_count())
    EOF

## Resources and GPU Queues

It is best practice to build conda environments in the $SCRATCH directory because conda can overload the file system when using $WORK  and $HOME does not have the storage space for ML tasks. It is important to note that on $SCRATCH your environment is subject to being purged.  Care should be taken to back up the environments you build on $WORK. 

<!-- Chris Ramos: To avoid any kind of interruption to your access I recommend running on the safe side and using an idev session to install conda packages. Your conda env should be available across all systems with access to $WORK since it is containerized. I was able to test this in my own account and was successful on LS6 and S3. --> 

SDL conda activity  must be performed within an idev session and scratch directory

Need workflow: do we transfer / copy the venvs back and forth from SCRATCH
All actions to be performed within an idev session?


Computer Resource | single-node GPU idev command                     | gpus per node
--                | --                                               | --
Frontera          | idev -N 1 -n 1 -p rtx-dev -t 02:00:00            | X
Stampede3         | h100                                             | X
Vista             | idev yada                                        | X
Lonestar6         | idev yada                                        | X


## Moving to Batch Jobs

After validating workflows with `idev`, production workloads should be run through SLURM batch jobs (`sbatch`).

