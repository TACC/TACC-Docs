# PyTorch with User-Installed Conda
**Last update: January 26, 2026**

In this tutorial, you used idev to request a GPU node to work on, installed and used Conda to create a virtual environment, installed Pytorch in a virtual environment, and then ran an example script using multiple GPUs for AI/ML training tasks and benchmarking. Run a successful multi-GPU training task in a Conda environment. This script facilitates and streamlines the training of ML models on multiple GPUs, as well as benchmarks the performance of Pytorch-based models on multiple GPUs.

This page documents how to run the PyTorch multi-GPU sanity test using a Conda environment installed in `$SCRATCH`.

## Conda Intro

Conda is a powerful package manager and environment management tool, widely used in data science and machine learning to manage dependencies and create isolated environments for different projects. This guide will walk you through the steps to install Conda on your system.

Conda-Forge is a comunity-driven repository of Conda packages.  Mini-Forge is a lightweight installer for Conda, optimized to use Conda-Forge by default. For this guide's purposes, we will use MiniForge.

* Installed on TACC's file systems
* Installed inside of a container

Using Conda at TACC in a performant way can be tricky. The reason for this is that large conda environments, containing many thousands of files, can cause issues with the TACC system-wide `$WORK` (Lustre) file system.  For this reason, you must run all computational models in the SCRATCH file system.


!!!common tip
	**SCRATCH** : In terms of optimizing the I/O that takes place with conda, SCRATCH is the correct location. Unfortunately since SCRATCH can be purged, storing conda environments here is non-ideal.  See the [Backing up/Workflow](pytorch.md) section.


## Detailed Steps

1.  Download and install Miniforge:

    Install MiniForge - the Conda installer Miniforge is one of several Conda installers, others examples include Anaconda and Miniconda. We will be use miniforge to download Conda into the `$SCRATCH` directory.

         curl -LO https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
         bash Miniforge3-Linux-x86_64.sh

    When you run the bash script, you will have some disclaimers pop up on your command line during the installation process. This disclaimer will walk you through the installation steps for Miniforge, but it will present to you a default installation folder that is in the `$HOME` directory.

    **Ensure you change this to your scratch/frontera directory before you install Miniforge.**

    After running the bash script, it will ask you to update your shell profile to automatically initialize conda. **Type 'yes'.**

2.  Create a PyTorch Conda environment

    We can now create our first Conda Environment. Create a **Python 3.10** environment to ensure it works with CUDA by running the command:

        prompt$ conda create --name mypytorchvenv python=3.10

    Upon creation, the terminal should prompt you with a series of yes/no questions pertaining to the libraries that Conda will automatically install in the environment.

    Once the environment is created, **activate** it with:

        prompt$ conda activate mypytorchvenv

    Once the environment is properly activated, your working directory should look like:

        (mypytorchenv) c196-012[rtx](418)$


    After installation, initialize Conda to configure your shell:

         prompt$ conda init

    Restart your terminal for the changes to take effect.

    Verify the Installation Confirm that Conda is installed by running:

         prompt$ conda --version

    This should display the installed Conda version.

1.  Install Pytorch in Conda Environment

    To install Pytorch in our new Conda environment 

    Now install Cuda to run the `multigpu_torchrun.py` training set: 

         conda install pytorch torchvision torchaudio pytorch-cuda=12.6 -c pytorch -c nvidia

1.  Clone the Pytorch Examples Repository

    This is an official repository containing dozens of example scripts from the Pytorch library. For the purposes of this tutorial, we will be cloning it into our new environment.

        git clone https://github.com/pytorch/examples.git

1.  CD into the ddp tutorial series folder

    Upon listing all of the directories now present in the **\$SCRATCH** folder, we should now see a new directory called **examples**.

         cd examples/distributed/ddp-tutorial-series

1.  Run the Sanity Test

    Now that we have requested a specific number of GPU nodes to use with idev and created a Conda environment with Pytorch, we can try running an example script where we ensure that our environment works for multi-GPU training- a task with many applications in ML/AI in HPCs.

    By downloading and running a python script from the official Pytorch repository called **multigpu_torchrun.py**, we can enable single training jobs to utilize multiple GPUs on a machine.

    And within our virtual environment, we will use the `torchrun` command to launch the training script across all of the available nodes.

        torchrun --standalone --nproc_per_node=<GPU_COUNT> multigpu_torchrun.py 5 10
        cd examples/distributed/ddp-tutorial-series

    This will distribute the training workload across all GPUs on your machine using `torch.distributed` and `DistributedDataParallel` (DDP), and train the model for 5 epochs and run checkpoints every 10
    seconds.

<!--
    When run successfully, you should get a result like this:

    .. image:: images/multigpu_result.png
    :alt: multigpu_result
-->

## Refs

* For more information about multi-GPU training, see the following documentation: [Distributed Data Parallel in Pytorch](https://pytorch.org/tutorials/beginner/ddp_series_intro.html)
* [Conda documentation](https://docs.conda.io/)


<!--

## Creating and Managing Conda Environments

Once Conda is installed, you can start creating and managing environments using the following commands:

1.  To Create and activate a new environment:

         c123-4456$ conda create --name myenv python
         c123-4456$ conda activate myenv 

2.  Deactivate an environment

         c123-4456$ conda deactivate

3.  Remove an environment

         c123-4456$ conda remove --name myenv --all
-->

<!--
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
-->
