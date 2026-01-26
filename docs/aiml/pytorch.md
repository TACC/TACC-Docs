
# PyTorch at TACC

This section provides an overview of three common software tools that are used to manage dependcies and environments. Python virtual environments, conda, and containers all offer different ways of creating an isolated place on your machine where you can install specific versions of software. This enables users to work on multiple projects on the same machine without worrying about mismatches in software depencies between projects.  


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

## Conda

.. image:: images/Conda_logo.svg
   :align: center

Image source: [github.com/conda (https://github.com/conda)]

Conda is similar to python virtual environments except that it can also install non-python packages. This capability can be useful when your project involves not just python code but many external software dependencies.

**Key Features**  

* **Versatility**: 
   Allows the installation of both Python and non-Python packages.
* **Cross-Language Support**: 
   Supports a variety of programming languages- not just Python!

The way conda manages files is not optimized for use on HPC systems owing to the distributed and shared nature of HPC data storage. If you would like to use Conda, view our tutorial on `How to Install Conda <\ai_environments_at_tacc\docs\getting_starting_section\How to Install Conda.rst>`_ for use on our systems as well as our advanced Conda section. This will give examples of various ways to install conda on our system to get the best performance. 

## Containers

Containers are lightweight and portable software platforms, similar to virtual machine images, but aimed at high performance applications. A container will not only have the code for the target application, but also its runtime, system tools, libraries, and settings, ensuring consistent execution across environments. The primary software engine that builds and runs containers is called Docker.  The HPC systems at TACC use software called Apptainer, which will convert and run containers made using docker. Please see `TACC's container tutorials <https://containers-at-tacc.readthedocs.io/en/latest/>`_ for more details. 


**Key Features**  

* **Complete and Portable Environment**: 
   Bundles the application with all necessary dependencies, making it portable across different systems without the need for installation on the target machine.
* **Scalable**: 
   Ideal for scalable, microservice-based architectures and container orchestration tools like Kubernetes.
* **Root Priveleges**: 
   Software in containers can be installed with root priveleges and then the container can be uploaded and run on a HPC system. 



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

It is best practice to build conda environments in the `$SCRATCH` directory because conda can overload the file system when using `$WORK`  and `$HOME` does not have the storage space for ML tasks. It is important to note that on `$SCRATCH` your environment is subject to being purged.  Care should be taken to back up the environments you build on `$WORK`. 

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

