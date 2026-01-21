# Containers with Pytorch
**Last update: January 21, 2026**

Here we will pulled a PyTorch image from Docker Hub and run a Python script within an Apptainer container. Need more- what are we doing? conducting a sanity test

## Defining Terms

What is a Docker? What are Images?

term | def
-- | --
**Docker** | is a platform that allows developers to package applications into containers and share them through the cloud.  Docker is a platform for developing, shipping, and running applications inside **containers**.  A **software container** is a lightweight, portable package that includes everything an application needs to run—including code, libraries, dependencies, operating system, and system settings. 
**Docker image** | is a pre-configured package that contains everything needed to run an application, including the code, runtime, libraries, and dependencies. 
**container** | Once an image is **instantiated**, it becomes a **container**. Multiple containers can be instantiated from the same base image.<p>Containers ensure your code can be deployed to different machines without worrying about installing dependencies. 
** [Apptainer](https://containers-at-tacc.readthedocs.io/en/latest/singularity/01.singularity_basics.html)** | Apptainer, formerly Singularity is a containerization platform designed specifically for high-performance computing (HPC) environments, offering a solution optimized for scientific research and large-scale data processing. 

Most general containers like Docker require root privileges and are commonly used for development and cloud-based applications, Apptainer is built to run efficiently on shared systems such as TACC's supercomputers.   

Apptainer  provides portability, reproducibility, and seamless integration with HPC job schedulers, making it ideal for researchers who need to run complex applications in secure, isolated environments without compromising performance or requiring administrative access.  

Use apptainer to run the container on a TACC HPC system

In this tutorial, we follow the workflow highlighted in [TACC's container tutorial](https://containers-at-tacc.readthedocs.io/en/latest/singularity/01.singularity_basics.html).


## Running GPU enabled PyTorch Containers at TACC

Running an example DDP training model within a Pytorch container on TACC's Vista compute resource. 

Set up a GPU-enabled Pytorch container on TACC's Vista compute resource.  Run the ?benchmark `multigpu_torchrun.py` testing script.

!!!tip
	* `apptainer` is only available on compute nodes at TACCs system. 
	* always use idev and explain why


## Make sure of promots

	* login1$ - activities performed on a login node
	* c123-456$ - activities performed within an idev session

Very important that you run all training models within an idev session or you will be pounded.

1. Perform all activities within each compute reosurce's SCRATCH file system.  

		login1$ cd $SCRATCH

	or

		login1$ cds

1. Download test data

	Always use the $SCRATCH systen, not $WORK
	First, we will download some test data to run a simple ML task on. Clone the examples library from the official Pytorch Github repository by running:

		login1$ git clone https://github.com/pytorch/examples.git



<!-- LS6 a100 or h100 nodes? -->

1. Launch an interactive session on a compute node with TACC's `idev` utility. Consult the table above for the appropriate idev invocation per resource.  Each command requests 1 GPU node for two hours in the appropriate GPU queue.

	```cmd-line
	login1$ idev -p rtx-dev -t 02:00:00
	...
	c123-456$ 
	```

	There may be a wait time as you sit in the queue. Once the command runs successfully, you will have a shell on a dedicated compute node, and your command prompt will appear prefixed with the computenode you have access to.


1. Load the Apptainer module

    	c123-456$ module load tacc-apptainer

1. Pull a Prebuilt PyTorch Docker Image

	Instead of going to the trouble of creating our own Dockerfile,  we can use an official, pre-built PyTorch image from [DockerHub](https://hub.docker.com/) to make the process of setting up a container for GPU use easier for us.  For more detailed instructions on how to build and upload your own Docker image from scratch, see [TACC's Docker Repository](https://hub.docker.com/u/tacc).

    DockerHub is the official cloud-based repository where developers store, share, and distribute Docker images, similar to Github.

	Run the following command to pull the latest PyTorch image from Dockerhub with CUDA support:

    	c123-456$ apptainer pull output.sif docker://pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel

	This will download the image and convert it into an Apptainer image format (.sif).
	You can replace "output.sif" with whatever you would like to name the file. Otherwise, it will default to the name of the image as defined on Dockerhub.

    CUDA is NVIDIA'S API that allows software to utilize NVIDIA GPUs for accelerated computing. This is essential for deep learning because GPUs process certain calculations much faster than CPUs.  Since TACC machines have NVIDIA GPUs, we must use a CUDA-enabled PyTorch image to fully leverage GPU acceleration.


1. Run training code on GPU

	What exactly are we running - one node, multiple GPUs per node
	DDP Distributed Data Parallel - we are running a training script.
	Single-Node, Multi-GPU training

	Execute the multigpu training script within our Pytorch container with the following command:.  

	It is important to note in the command below that apptainer will only recognize the presence of a GPU by passing the apptainer command the `--nv` flag.

		c123-456$$ apptainer exec --nv output.sif torchrun --nproc_per_node=4 examples/distributed/ddp-tutorial-series/multigpu_torchrun.py 50 10 

	Examine the terminal's output to check for any issues or errors.  


## Refs

* [Containers at TACC tutorial](https://containers-at-tacc.readthedocs.io/en/latest/index.html)
* [TACC Docker Hub](https://hub.docker.com/u/tacc)
* [Pytorch DDP](https://docs.pytorch.org/tutorials/intermediate/ddp_tutorial.html)
