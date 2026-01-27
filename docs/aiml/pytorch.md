<!-- ## Purpose of This Guide

These pages focus on validating:

-   GPU visibility inside user environments
-   CUDA correctness
-   NCCL/DDP communication
-   `torchrun` launcher functionality
-   Filesystem access from compute nodes

This workload is a **sanity test**, not a benchmark or production
training run. -->

# PyTorch at TACC

This section provides an overview of three common software tools that are used to manage dependcies and environments. Python virtual environments, conda, and containers all offer different ways of creating an isolated place on your machine where you can install specific versions of software. This enables users to work on multiple projects on the same machine without worrying about mismatches in software depencies between projects.  

## Virtual Environments Summary

This documentation describes how to run a PyTorch multi-GPU **sanity test** (`multigpu_torchrun.py`) on TACC high-performance computing systems using three supported virtual environment models:

*   [Python virtual environments (`venv`)](venv.md)
*   [User-installed Conda environments](containers.md)
*   [Containers via Apptainer](containers.md)

### Python Virtual Environments (venv)

A python virtual environment, often referred to as a "venv", installs all python packages into a specific target folder on your machine. When you "activate" the environment all of the installed packages are made visible to your python installation.  Under the hood, virtual environments are controlling your system variables (e.g. `$PATH`) to manage where software is installed and in which directories programs like python look for installed packages. 

#### Key Features  

* **Lightweight**: Unlike Conda or containers, virtual environments in Python only manage Python libraries, which can make them simpler and faster to set up.
* **No System-Level Dependencies**: Virtual environments do not handle non-Python system libraries or software dependencies.
* **Ideal for Small Projects**: Best suited for smaller projects where only Python dependencies need to be isolated, without the complexity of managing other tools.


### Conda 

Conda is similar to python virtual environments except that it can also install non-python packages. This capability can be useful when your project involves not just python code but many external software dependencies.

#### Key Features  

* **Versatility**: Allows the installation of both Python and non-Python packages.
* **Cross-Language Support**: Supports a variety of programming languages- not just Python!

The way conda manages files is not optimized for use on HPC systems owing to the distributed and shared nature of HPC data storage. If you would like to use Conda, view our tutorial on [How to Install Conda](\ai_environments_at_tacc\docs\getting_starting_section\How to Install Conda.rst) for use on our systems as well as our advanced Conda section. This will give examples of various ways to install conda on our system to get the best performance. 

### Containers

Containers are lightweight and portable software platforms, similar to virtual machine images, but aimed at high performance applications. A container will not only have the code for the target application, but also its runtime, system tools, libraries, and settings, ensuring consistent execution across environments. The primary software engine that builds and runs containers is called Docker.  The HPC systems at TACC use software called Apptainer, which will convert and run containers made using docker. Please see [TACC's container tutorials](https://containers-at-tacc.readthedocs.io/en/latest/) for more details. 

#### Key Features  

* **Complete and Portable Environment**: Bundles the application with all necessary dependencies, making it portable across different systems without the need for installation on the target machine.
* **Scalable**: Ideal for scalable, microservice-based architectures and container orchestration tools like Kubernetes.
* **Root Priveleges**: Software in containers can be installed with root priveleges and then the container can be uploaded and run on a HPC system. 


## Global Rules (Apply to All Methods)

### Where Work Must Be Done

* All computation must occur inside an `idev` session on GPU compute node/s.
* All files, environments, containers, and output must live in `$SCRATCH`.
* Do not build or run from `$HOME` or `$WORK`.

### General Workflow

1.  `cd $SCRATCH`
1.  Clone the PyTorch examples repository
1.  Launch an `idev` session
1.  Activate the environment
1.  Verify GPU visibility
1.  Run `torchrun`


## Resources and GPU Queues

It is best practice to build conda environments in the `$SCRATCH` directory because conda can overload the file system when using `$WORK`  and `$HOME` does not have the storage space for ML tasks. It is important to note that on `$SCRATCH` your environment is subject to being purged.  Take care to back up the environments you build on `$WORK`. 


Compute Resource  | single-node GPU `idev` invocation                | GPUs per node
--                | --                                               | --
Frontera          | `idev -N 1 -n 1 -m 120 -p rtx-dev`               | X
Stampede3         | `idev -N 1 -n 1 -m 120 -p xxxxx`                 | X
Vista             | `idev -N 1 -n 1 -m 120 -p gh-dev`                | X
Lonestar6         | `idev -N 1 -n 1 -m 120 -p xxxxx`                 | X

### more information

See the following pages for running a sanity test pytorch job..

*   [Python virtual environments (`venv`)](venv.md)
*   [User-installed Conda environments](containers.md)
*   [Containers via Apptainer](containers.md)


## Moving to Batch Jobs

After validating workflows with `idev`, production workloads should be run through SLURM batch jobs (`sbatch`).


<!-- Chris Ramos: To avoid any kind of interruption to your access I recommend running on the safe side and using an idev session to install conda packages. Your conda env should be available across all systems with access to $WORK since it is containerized. I was able to test this in my own account and was successful on LS6 and S3. 
SDL conda activity  must be performed within an idev session and scratch directory
Need workflow: do we transfer / copy the venvs back and forth from SCRATCH
All actions to be performed within an idev session?
--> 

### Prompt meanings

Table x. 

Prompt | location/meaning
-- | --
`login1$` | activities performed on a login node
`c123-456$` | activities performed within an idev session
`localhost$` | activites on your laptop/desktop


## Virtual Environments with Pytorch { venv-pytorch }

This is a general guide to pytorch on TACC resources,  Frontera, LS6 and Vista and Stampede3.  See each resource's respective user guide for more advanced usage.

* [Vista - ml](http://docs.tacc.utexas.edu/hpc/vista#ml)
* [Stampede3 - pytorch](http://docs.tacc.utexas.edu/hpc/stampede3#ml)
* [Frontera - pytorch](http://docs.tacc.utexas.edu/hpc/frontera#ml)  no point updating this?
* [Lonestar6 - pytorch](http://docs.tacc.utexas.edu/hpc/lonestar6#ml)

