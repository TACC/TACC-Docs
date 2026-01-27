
This page documents how to run the PyTorch multi-GPU sanity test inside a Python virtual environment created with `venv`.

## Workflow Summary

1.  Create a virtual environment in `$SCRATCH`
2.  Activate the environment inside `idev`
3.  Install PyTorch
4.  Clone the examples repository
5.  Run `torchrun`

a;lskdjfl;askdjf;laskdfj

1. Create and Activate a Python Virtual Environment { #pythonvenv }
	Create the Environment in `$SCRATCH`

    cd $SCRATCH
    python3 -m venv pytorch-venv

	Virtual environments are essential for isolating project dependencies and ensuring compatibility across different projects. This guide explains how to create a virtual environment using Python's built-in `venv` module on TACC compute resources.

Once logged into one of TACC's compute resources.

	Create environment

	Run this command to create a virtual environment. You can replace `myenv` with whatever you want to name your virtual environment.

		python3 -m venv myenv

	Verify the Creation

	After running the command, a new directory (e.g., `myenv`) will be created in your current location. This directory contains the files needed for the virtual environment.

		(base) UserName@System myenv % ls
		bin		include		lib		pyvenv.cfg


1. Activate the environment

		source myenv/bin/activate
    	source pytorch-venv/bin/activate

	Upon activation, you should see parentheses around the name of your environment appear in front of your working directory:

		(myenv) login3.frontera(470)$

	If the `activate` command is not recognized, ensure you’re in the correct directory where the virtual environment was created.

### Install PyTorch

    pip install torch torchvision torchaudio

### Clone the Examples Repository

    git clone https://github.com/pytorch/examples.git

### Run the Sanity Test

    cd examples/distributed/ddp-tutorial-series
    torchrun --standalone --nproc_per_node=gpu multigpu_torchrun.py 5 10

### Expected Output

Successful execution will display rank assignments and training progress for each GPU.

----


### Deactivating a Virtual Environment

When you're done working in your virtual environment, you can deactivate it to return to the global Python environment:

1. Simply run the following command in your terminal (works on all operating systems):

		deactivate

2. You’ll notice the environment name disappears from your command line, confirming the environment has been deactivated.



PyTorch is a Python framework for machine and deep learning. It is built upon the torch library and also provides a C++ interface. It supports CPU and GPU execution for single-node and multi-node systems.

### Installing Pytorch within venv

In the next section, we will test this virtual environment by installing pytorch into it and then running an example script.
Congratulations! You have now run a successful multi-GPU training task in a virtual python environment.
To demonstrate how to use our virtual environment, we will download the `multigpu_torchrun.py` script from a github repository, install pytorch, and then run an example benchmarking function from the script, all within our virtual environment.

**multigpu_torchrun.py** is a script from the official pytorch repository that leverages distributed data parallel (DDP) to split ML training tasks across GPUs, allowing for a more efficient runtime. 

The multigpu_torchrun.py script can be found in the github repository below: <https://github.com/pytorch/examples>

1. Download the repository containing code to run**
   You can download a github repository through the command line with the command **git clone**.

		git clone https://github.com/pytorch/examples.git

1. Request a Node through idev**

	To run our example script, we'll need to allocate a single node for the purposes of our task. One node on Frontera has 4 GPUs, which is adequate to run multigpu_torchrun.py's benchmarking function.

	Begin your idev session by running the following in your virtual environment:

    	idev -N 1 -n 1 -p rtx-dev -t 02:00:00

	This will request a **single compute node (-N 1 -n 1)** in the **rtx-dev** partition/queue **(-p)** for a time length of **two hours (-t 02:00:00).**

	The `rtx-dev` queue is specifically for the NVIDIA RTX-5000 GPU compute nodes on Frontera systems, which are compatible with CUDA and pytorch by extension. 


	When you request a node through idev, you will be taken to a loading screen. After your idev session starts, your current working directory will look like:

		(myenv) c196-011[rtx](452)$

	This is how you will know your idev session has begun. **Ensure you see the (myenv) tag before your working directory. If you do not, activate your virtual environment again.** 


1. Install Pytorch into our Virtual Environment**

	<!-- To run multigpu_torchrun, we will need to install pytorch.--> 
	Run the following pip command inside of your virtual environment:

    	pip3 install torch torchvision torchaudio

1. CD into the ddp tutorial series folder**

	We should now see a new directory called **examples** present in our virtual environment.  **cd** into the following directory:

		cd examples/distributed/ddp-tutorial-series

		<!-- *This will be a hidden directory.* -->

1. Run multigpu_torchrun.py**

	And within our virtual environment, we will use the **torchrun** command to launch the training script across all of the available nodes (1).

		torchrun --standalone --nproc_per_node=gpu multigpu_torchrun.py 5 10

	This will distribute the training workload across all GPUs on your machine using `torch.distributed` and `DistributedDataParallel` (DDP), and train the model for 5 epochs and run checkpoints every 10 seconds.

	When run successfully, you should get a result like this:

.. image:: images/multigpu_result.png
    :alt: multigpu_result

.. note::
    The task may take a few minutes to run.


### Understanding the Structure

The virtual environment directory contains:

directory | contains
-- | --
**`bin` or `Scripts`**| Contains the executables, including the Python interpreter.
**`lib`**| Includes the standard library and site packages for your virtual environment.
**`pyvenv.cfg`**| Configuration file for the virtual environment.

