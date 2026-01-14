# Overview of Conda at TACC

Conda is a powerful package manager and environment management tool, widely used in data science and machine learning to manage dependencies and create isolated environments for different projects. This guide will walk you through the steps to install Conda on your system.

Conda-Forge is a comunity-driven repository of Conda packages. Mini-Forge is a lightweight installer for Conda, optimized to use Conda-Forge by default. For this guide's purposes, we will use MiniForge.

Using Conda at TACC in a performant way is tricky. The reason for this is that large conda environments, containing many thousands of files, can cause issues with the TACC system-wide $WORK (Lustre) file system.  In this tutorial we will discuss a few options you have for how to use conda on our systems in a way that avoids these issues.  In general, there are two ways to use conda: 

* Installed on our file systems
* Installed inside of a container 

Let's start by discussing the best way to use conda outside of a container

## Where to Install Conda Outside of a Container

If we are using conda outside of a container, some thought needs to go into where to place it on our file systems (HOME, WORK, or SCRATCH).  No location is perfect– here are pros and cons of each:

* **HOME** : Generally, you should not place conda in HOME unless the environment you build is very small due to the small disk quota in HOME. 
* **SCRATCH** : In terms of optimizing the I/O that takes place with conda, SCRATCH  is the correct location.  Unfortunately since SCRATCH can be purged, storing conda environments here is non-ideal.
* **WORK** : Conda environments should NOT be run from WORK as it can overload the file system for all users. If you are transfering or storing a conda environment on WORK, please copy it to SCRATCH before activating it.

For large conda environments, moving the conda environment into a container can reduce the file I/O overhead.  Next, let's take a look at an example of where we use miniforge within a container to build an environment. 


## Install Conda

!!! important
	It is best practice to build conda environments in the $SCRATCH directory because conda can overload the file system when using $WORK  and $HOME does not have the storage space for ML tasks. It is important to note that on $SCRATCH your environment is subject to being purged.  Care should be taken to back up the environments you build on $WORK. 

Chris Ramos: To avoid any kind of interruption to your access I recommend running on the safe side and using an idev session to install conda packages. Your conda env should be available across all systems with access to $WORK since it is containerized. I was able to test this in my own account and was successful on LS6 and S3. 
SDL conda activity  must be performed within an idev session and scratch directory


Need workflow: do we transfer / copy the venvs back and forth from SCRATCH
All actions to be performed within an idev session?


Computer Resource | single-node GPU idev command | gpus per node
-- | -- | --
Frontera | idev -N 1 -n 1 -p rtx-dev -t 02:00:00 | X
Stampede3| h100 | X
Vista | idev yada | X
Lonestar6 | idev yada | X


1. Grab a GPU node using TACC's `idev` utility: 

	To run the `multi_gpu_torchrun` script, we must first use the **idev** tool to request a GPU Node on system, see table. . Each Node on Frontera is comprised of four GPUs, which is why we'll only request one to run the multigpu_torchrun.py script.

		/scratch/<group number>/<TACC username>/frontera


	When you request a node through idev, you will see a status update print to the terminal while your job is waiting in the queue. After your idev session starts, your terminal session will automatically be connected to the node you requested. Once connected, you should see your terminal prompt change to the node name:

		c196-012[rtx](416)$


1. Install MiniForge - the Conda installer

	Miniforge is one of several Conda installers, others examples include Anaconda and Miniconda. We will be use miniforge  to download Conda into the $SCRATCH directory.  We are going to install Conda on **Vista/FronteraSDL** for the sake of this tutorial. When you SSH into Frontera, you will see this screen:

	Once you are in the $SCRATCH directory for frontera, we can install Conda. Use **curl** (a command-line tool to transfer data from a server via HTTP) to download Miniforge which will come bundled with conda.

		cd $SCRATCH
		curl -LO https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh

	Now make the execution script executable with **chmod**, which modifies file permissions so that we can execute (**+x**) the file:

		chmod +x Miniforge3-Linux-x86_64.sh

	Now we can run the Miniforge installer:

		bash Miniforge3-Linux-x86_64.sh

	When you run the bash script, you will have some disclaimers pop up on your command line during the installation process. This disclaimer will walk you through the installation steps for Miniforge, but it will present to you a default installation folder that is in the **$HOME** directory.

	**Ensure you change this to your scratch/frontera directory before you install Miniforge.**

	After running the bash script, it will ask you to update your shell profile to automatically initialize conda. **Type ‘yes'.**

1. Initialize Conda

	After installation, initialize Conda to configure your shell:

		conda init

	Restart your terminal for the changes to take effect.

1. Verify the Installation

	Confirm that Conda is installed by running:

		conda --version

	This should display the installed Conda version.


## Creating and Managing Conda Environments

Once Conda is installed, you can start creating and managing environments using the following commands:


1. To Create and activate a new environment

		$ conda create --name myenv python
		$ conda activate myenv 

1. Deactivate an environment

		$ conda deactivate

1. Remove an environment

		$ conda remove --name myenv --all


## Install & Test PyTorch within Conda

Now that we have Conda installed and we understand how to **activate**, **deactivate**, and **delete** environments, let's try installing and testing pytorch by running the **multigpu_torchrun.py** script from the official Pytorch library.

This script facilitates and streamlines the training of ML models on multiple GPUs, as well as benchmarks the performance of Pytorch-based models on multiple GPUs.


1. Create a Conda Environment

	We can now create our first Conda Environment. Create a **Python 3.10** environment to ensure it works with CUDA by running the command:

		conda create --name pytorch_env python=3.10

	Upon creation, the terminal should prompt you with a series of yes/no questions pertaining to the libraries that Conda will automatically install in the environment.

	Once the environment is created, **activate** it with:

		conda activate pytorch_environment

	Once the environment is properly activated, your working directory should look like:

		(pytorch_env) c196-012[rtx](418)$

1. Install Pytorch in Conda Environment

	To install Pytorch in our new Conda environment- which is in the $SCRATCH directory of Frontera, running in a single rtx node idev session- run the following Conda command in the environment:

	We will need to install Cuda to run the multigpu_torchrun.py file on the Frontera's NVIDIA GPUs.

		conda install pytorch torchvision torchaudio pytorch-cuda=12.6 -c pytorch -c nvidia

## Running an Example Script

In this tutorial, you used idev to **request a GPU node to work on**, **installed and used Conda to create a virtual environment**, **installed Pytorch in a virtual environment**, and then **ran an example script using multiple GPUs for AI/ML training tasks and benchmarking.**

	Congratulations! You have now run a successful multi-GPU training task in a Conda environment.
	Now that we have requested a specific number of GPU nodes to use with idev and created a Conda environment with Pytorch, we can try running an example script where we ensure that our environment works for multi-GPU training- a task with many applications in ML/AI in HPCs.

	By downloading and running a python script from the official Pytorch repository called **multigpu_torchrun.py**, we can enable single training jobs to utilize multiple GPUs on a machine.


1. Clone the Pytorch Repository

	This is an official repository containing dozens of example scripts from the Pytorch library. For the purposes of this tutorial, we will be cloning it into our new environment. 

		git clone https://github.com/pytorch/examples.git


1. CD into the ddp tutorial series folder

	Upon listing all of the directories now present in the **$SCRATCH** folder, we should now see a new directory called **examples**.

		cd examples/distributed/ddp-tutorial-series

1. Run multigpu_torchrun.py

	And within our virtual environment, we will use the **torchrun** command to launch the training script across all of the available nodes (1).

		torchrun --standalone --nproc_per_node=gpu multigpu_torchrun.py 5 10

	This will distribute the training workload across all GPUs on your machine using `torch.distributed` and `DistributedDataParallel` (DDP), and train the model for 5 epochs and run checkpoints every 10 seconds.

	When run successfully, you should get a result like this:

	.. image:: images/multigpu_result.png
	:alt: multigpu_result


## OPTIONAL: Export Environment & Manage Dependencies with a YAML file

Create a conda environment made with those dependencies that is easily shared between users thanks to our YAML file.

If you would like, you can manage your Conda environments using a YAML file, which helps ensure consistency across different systems and distributed environments.

Typically, conda environments are managed in a file called **environment.yml**, which defines and manages dependencies, environments, and channels. Let's manually create one–you will need vim or nano to do this through the command line.


1. Create an empty YAML File

	Using your favorite editor, create a file named 'environment.yaml' and place it XXXX directory,.

1. Add your environment variables to your YAML File

    name: pytorch_env
    channels:
        - pytorch
        - defaults
    dependencies:
        - python=3.10
        - pytorch
        - torchvision
        - torchaudio
        - cudatoolkit=12.6

1. Create your Conda environment with environment.yml

	Now that we have our environment.yml file created, we can activate it with:

		conda env create -f environment.yml

1. Activate Conda Environment

	Now that we have our **environment.yml** file created, we can activate it with:

		conda activate pytorch_env

1. Export your Conda Environment

	You can now share this environment easily between systems thanks to the environment.yml file.  Export it using the following command:

		conda env export > environment.yml


## Refs

* For more information about multi-GPU training, see the following documentation: [Distributed Data Parallel in Pytorch](https://pytorch.org/tutorials/beginner/ddp_series_intro.html)
* [Conda documentation](https://docs.conda.io/)


--

