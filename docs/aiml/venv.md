# Python Virtual Environments at TACC

PyTorch is a Python framework for machine and deep learning. It is built upon the torch library and also provides a C++ interface. It supports CPU and GPU execution for single-node and multi-node systems. 

This page documents how to run the PyTorch multi-GPU sanity test inside a Python virtual environment created with `venv`. 

In the next section, we will test this virtual environment by installing pytorch into it and then running an example script. To demonstrate how to use our virtual environment, we will download the `multigpu_torchrun.py` script from a github repository, install pytorch, and then run an example benchmarking function from the script, all within our virtual environment.

**multigpu_torchrun.py** is a script from the official pytorch repository that leverages distributed data parallel (DDP) to split ML
training tasks across GPUs, allowing for a more efficient runtime.

The multigpu_torchrun.py script can be found in the github repository below: <https://github.com/pytorch/examples>

## Quickstart (venv)

1. Create a virtual environment in `$SCRATCH`.
1. Activate it.
1. Install PyTorch.
1. Clone the PyTorch examples repository.
1. Change into the DDP tutorial directory.
1. Run: `torchrun --standalone --nproc_per_node=<GPU_COUNT> multigpu_torchrun.py 5 10`
1. Deactivate when finished.

## Detailed Instructions

Virtual environments are essential for isolating project dependencies and ensuring compatibility across different projects.  This guide explains how to create a virtual environment using Python's built-in `venv` module on TACC compute resources.

!!! important 

1.  Create a Python virtual environment 

		c123-456$$ cd $SCRATCH
		c123-456$$ python3 -m venv mypytorchvenv

1.  Activate the virtual environment

		c123-456$ source mypytorchenv/bin/activate

	Upon activation, you should see parentheses around the name of your environment appear in front of your working directory:

		(mypytorchenv) c123-456[gh](117)$

	If the `activate` command is not recognized, ensure you're in the correct directory where the virtual environment was created.

1. Install Pytorch into our Virtual Environment

    To run multigpu_torchrun, we will need to install pytorch. Run the following pip command inside of your virtual environment:

         prompt$ pip3 install torch torchvision torchaudio

1.  Clone the Examples Repository

	Download the repository containing code to run.  You can download a github repository through the command line with the command git
    clone.

         prompt$ git clone https://github.com/pytorch/examples.git

1.  Run the Sanity Test

	CD into the ddp tutorial series folder And within our virtual environment, we will use the **torchrun** command to launch the training script across all of the available nodes (1).

    	prompt$ cd examples/distributed/ddp-tutorial-series
    	prompt$ torchrun --standalone --nproc_per_node=<GPU_COUNT> multigpu_torchrun.py 5 10

    This will distribute the training workload across all GPUs on your machine using `torch.distributed` and `DistributedDataParallel` (DDP), and train the model for 5 epochs and run checkpoints every 10 seconds.

    When run successfully, you should get a result like this:

.. image:: images/multigpu_result.png :alt: multigpu_result

.. note:: The task may take a few minutes to run.

### Expected Output

Successful execution will display rank assignments and training progress
for each GPU.

### Deactivating a Virtual Environment

When you're done working in your virtual environment, you can deactivate it to return to the global Python environment.  Run the following command in your terminal (works on all operating systems):

         c123-456$ deactivate

	You'll notice the environment name disappears from your command line, confirming the environment has been deactivated.

<!--
	Verify the Creation

    After running the command, a new directory (e.g., `myenv`) will be created in your current location. This directory contains the files needed for the virtual environment.

        (base) UserName@System myenv % ls
        bin     include     lib     pyvenv.cfg

### Understanding the Directory Structure

The virtual environment directory contains:

directory | contains
-- | --
**`bin` or `Scripts`**| Contains the executables, including the Python interpreter.
**`lib`**| Includes the standard library and site packages for your virtual environment.
**`pyvenv.cfg`**| Configuration file for the virtual environment.
-->
