# PyTorch at TACC


# Testing Matrix

<table border="1">
<tr><th>&nbsp;</th><th colspan="3">Environment</th></tr>
<tr><th>Resource</th><th>Python venv</th><th>Conda</th><th>Containers</th></tr>
<tr><td>Vista</td><td><a href="https://docs.tacc.utexas.edu/hpc/vista/#ml">XX</a></td><td>XXX</td><td>XXX</td>
<tr><td>Frontera</td><td>XXX</td><td>XXX</td><td>XXX</td>
<tr><td>Stampede3</td><td>XXX</td><td>XXX</td><td>XXX</td>
<tr><td>Lonestar6</td><td>XXX</td><td>XXX</td><td>XXX</td>
</table>

PyTorch is a Python framework for machine and deep learning. It is built upon the torch library and also provides a C++ interface. It supports CPU and GPU execution for single-node and multi-node systems. 

This section provides an overview of three common software tools that are used to manage dependcies and environments. Python virtual environments, conda, and containers all offer different ways of creating an isolated place on your machine where you can install specific versions of software. This enables users to work on multiple projects on the same machine without worrying about mismatches in software depencies between projects.

This documentation describes how to run a PyTorch multi-GPU sanity test (`multigpu_torchrun.py`) on TACC high-performance computing systems using three supported virtual environment models:

* Python virtual environments (`venv`)
* User-installed Conda environments
* Containers via Apptainer

This workload is a **sanity test**, not a benchmark or production training run. 

## Python Virtual Environments (venv)

A python virtual environment, often referred to as a "venv", installs all python packages into a specific target folder on your machine. When you "activate" the environment all of the installed packages are made visible to your python installation. Under the hood, virtual environments are controlling your system variables (e.g. `$PATH`) to manage where software is installed and in which directories programs like python look for installed packages.

### Key Features

* **Lightweight**: Unlike Conda or containers, virtual environments in Python only manage Python libraries, which can make them simpler and faster to set up.
* **No System-Level Dependencies**: Virtual environments do not handle non-Python system libraries or software dependencies.
* **Ideal for Small Projects**: Best suited for smaller projects where only Python dependencies need to be isolated, without the complexity of managing other tools.

## Conda

Conda is similar to python virtual environments except that it can also install non-python packages. This capability can be useful when your project involves not just python code but many external software dependencies.

### Key Features

* **Versatility**: Allows the installation of both Python and non-Python packages.
* **Cross-Language Support**: Supports a variety of programming languages- not just Python!

The way conda manages files is not optimized for use on HPC systems owing to the distributed and shared nature of HPC data storage. If you would like to use Conda, view our tutorial on [How to Install Conda](\ai_environments_at_tacc\docs\getting_starting_section\How%20to%20Install%20Conda.rst) for use on our systems as well as our advanced Conda section. This will give examples of various ways to install conda on our system to get the best performance.

## Containers

Containers are lightweight and portable software platforms, similar to virtual machine images, but aimed at high performance applications. A container will not only have the code for the target application, but also its runtime, system tools, libraries, and settings, ensuring consistent execution across environments. The primary software engine that builds and runs containers is called Docker. The HPC systems at TACC use software called Apptainer, which will convert and run containers made using docker. Please see [TACC's container tutorials](https://containers-at-tacc.readthedocs.io/en/latest/) for
more details.

### Key Features

-   **Complete and Portable Environment**: Bundles the application with all necessary dependencies, making it portable across different systems without the need for installation on the target machine.
-   **Scalable**: Ideal for scalable, microservice-based architectures and container orchestration tools like Kubernetes.
-   **Root Priveleges**: Software in containers can be installed with root priveleges and then the container can be uploaded and run on a HPC system.


## Global Rules (Apply to All Methods)

*   All computation and disk-intensive activity must occur within an `idev` session on GPU compute node/s.  This includes installing packages and conda environments
*   All files, environments, containers, and output must live in `$SCRATCH`.
*   Do not build or run from `$HOME` or `$WORK`.


## Resources and GPU Queues

It is best practice to build conda environments in the `$SCRATCH` directory because conda can overload the file system when using `$WORK` and `$HOME` does not have the storage space for ML tasks. It is important to note that on `$SCRATCH` your environment is subject to being purged. Take care to back up the environments you build on `$WORK`.  See Workflow below.

### Table 1. { table1 } `idev` invocations and GPU nodes
	
Compute Resource  | single-node GPU `idev` invocation                | GPUs per node
--                | --                                               | --
Frontera          | `idev -N 1 -n 1 -m 120 -p rtx-dev`               | X
Stampede3         | `idev -N 1 -n 1 -m 120 -p xxxxx`                 | X
Vista             | `idev -N 1 -n 1 -m 120 -p gh-dev`                | X
Lonestar6         | `idev -N 1 -n 1 -m 120 -p gpu-a100-dev`          | X
idev -N 1 -n 1 -p -m 120


## `idev` Instructions 

1.  Request access to GPU node through TACC's `idev` utility.

    To run our example script, we'll need to allocate a single node for the purposes of our task. One node on Frontera has 4 GPUs, which is
    adequate to run multigpu_torchrun.py's benchmarking function.

    Begin your idev session by invoking the appropriate idev command for your resource. See Table 1. for the appropriate `idev` nivocation.  The following example is run on Frontera. The `rtx-dev` queue is specifically for the NVIDIA RTX-5000 GPU compute nodes on Frontera systems, which are compatible with CUDA and pytorch by extension.

         idev -N 1 -n 1 -p rtx-dev -t 02:00:00

    This will request a single compute node (-N 1 -n 1) in the rtx-dev partition/queue (-p) for a time length of two hours (-t 02:00:00).

    When you request a node through idev, you will be taken to a loading screen. After your idev session starts, your current working
    directory will look like:

         (myenv) c196-011[rtx](452)$

    This is how you will know your idev session has begun. **Ensure you see the (myenv) tag before your working directory. If you do not, activate your virtual environment again.**

2.  Install Conda and perform all computations in the `$SCRATCH` file system, and within an `idev` session..

         login1$ cd $SCRATCH
         login1$ idev....

    When you request a node through idev, you will see a status update print to the terminal while your job is waiting in the queue. After your idev session starts, your terminal session will automatically be connected to the node you requested. Once connected, you should see your terminal prompt change to the node name:

         c196-012[rtx](416)$

3.  Move to the scratch directory and Launch an idev session

    Perform all activities within each compute resource's `$SCRATCH`
    file system.

         login1$ cd $SCRATCH

    or

         login1$ cds

4.  Launch an interactive session on a compute node with TACC's `idev` utility. Consult the table above for the appropriate idev invocation per resource. Each command requests 1 GPU node for two hours in the appropriate GPU queue. The following command is run on Frontera.

    ``` cmd-line
    login1$ idev -p rtx-dev -t 02:00:00
    ...
    c123-456$ 
    ```

    There may be a wait time as you sit in the queue. Once the command runs successfully, you will have a shell on a dedicated compute node, and your command prompt will appear prefixed with the computenode you have access to.

## Next: set up environment

See the following pages for running a sanity test pytorch job in the desired virtual environment..

* [Python virtual environments (`venv`)](venv.md)
* [User-installed Conda environments](containers.md)
* [Containers via Apptainer](containers.md)

## Backing up your environments / Workflow

To avoid any kind of interruption to your access I recommend running on the safe side and using an idev session to install conda packages. Your conda env should be available across all systems with access to $WORK since it is containerized. 
Need workflow: do we transfer / copy the venvs back and forth from SCRATCH

## Moving to Batch Jobs

After validating workflows with `idev`, production workloads should be
run through SLURM batch jobs (`sbatch`).

## Virtual Environments with Pytorch { venv-pytorch }

This is a general guide to pytorch on TACC resources, Frontera, LS6 and Vista and Stampede3. See each resource's respective user guide for more
advanced usage.

* [Vista - ml](http://docs.tacc.utexas.edu/hpc/vista#ml)
* [Stampede3 - pytorch](http://docs.tacc.utexas.edu/hpc/stampede3#ml)
* [Frontera - pytorch](http://docs.tacc.utexas.edu/hpc/frontera#ml) 
* [Lonestar6 - pytorch](http://docs.tacc.utexas.edu/hpc/lonestar6#ml)


<!--
### Prompt meanings

Table x.

  Prompt         location/meaning
  -------------- ---------------------------------------------
  `login1$`      activities performed on a login node
  `c123-456$`    activities performed within an idev session
  `localhost$`   activites on your laptop/desktop
  `container prompt`
  venv prompt
  conda prompt

-->
