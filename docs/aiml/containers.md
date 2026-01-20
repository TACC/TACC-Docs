# Containers with Pytorch

Here we will pulled a PyTorch image from Docker Hub and run a Python script within an Apptainer container. Need more- what are we doing? conducting a sanity test

## Defining Terms

What is a Docker? What are Images?

term | def
-- | --
**Docker** | is a platform that allows developers to package applications into containers and share them through the cloud.  Docker is a platform for developing, shipping, and running applications inside **containers**.  A **software container** is a lightweight, portable package that includes everything an application needs to run—including code, libraries, dependencies, operating system, and system settings. 
**Docker image** | is a pre-configured package that contains everything needed to run an application, including the code, runtime, libraries, and dependencies. 
**container** | Once an image is **instantiated**, it becomes a **container**. Multiple containers can be instantiated from the same base image.
	Containers ensure your code can be deployed to different machines without worrying about installing dependencies. 
** [Apptainer](https://containers-at-tacc.readthedocs.io/en/latest/singularity/01.singularity_basics.html) (formerly Singularity) | is a containerization platform designed specifically for high-performance computing (HPC) environments, offering a solution optimized for scientific research and large-scale data processing. 

Most general containers like Docker require root privileges and are commonly used for development and cloud-based applications, Apptainer is built to run efficiently on shared systems such as TACC's supercomputers.   

Apptainer  provides portability, reproducibility, and seamless integration with HPC job schedulers, making it ideal for researchers who need to run complex applications in secure, isolated environments without compromising performance or requiring administrative access.  

Use apptainer to run the container on a TACC HPC system

<!-- In this tutorial, we follow the workflow highlighted in [TACC's container tutorial](https://containers-at-tacc.readthedocs.io/en/latest/singularity/01.singularity_basics.html). -->

<!-- * Use Docker to develop containers locally
* Push (upload) our container to Docker hub 
-->

## Running GPU enabled PyTorch Containers at TACC

Set up a GPU-enabled Pytorch container at TACC to run the **Multigpu_Torchrun.py** testing script 

!!!tip
	* `apptainer` is only available on compute nodes at TACCs system. 
	* always use idev and explain why

1. Download test data

	* Always use the $SCRATCH systen, not $WORK
	First, we will download some test data to run a simple ML task on. Clone the examples library from the official Pytorch Github repository by running:

	```cmd-line
	login1$ cd $SCRATCH
	login1$ git clone https://github.com/pytorch/examples.git
	```


### Table 1. `idev` commands per TACC system

System      | Node Architecture                                       | Queue 			| Command
--          | --                                                      | -- 				| --
Frontera    | [GPU](../../hpc/frontera/#system-gpu)                   | [`rtx-dev`](../../hpc/frontera#queues) | `idev -p rtx-dev -t 02:00:00`
Stampede3   | [NVIDIA GPU H100](../../hpc/stampede3/#system-gpu-h100) | [`h100`](../../hpc/stampede3#queues)    |  `idev -p h100 -t 02:00:00`
Lonestar6   | [NVIDIA GPU A100](../../hpc/lonestar6/#system-gpu-a100) | [`gpu-a100-dev`](../../hpc/lonestar6#queues)  |  `idev -p gpu-a100-dev -t 02:00:00`
Vista       | [Grace Hopper GPU](../../hpc/vista/#system-gh)          | [`gh-dev`](../../hpcstampede3#queues)  |  `idev -p gh-dev -t 02:00:00`

<!-- LS6 a100 or h100 nodes? -->

1. Grab a compute node via idev.




	 Launch an interactive session with TACC's `idev` utility.  The following command requests an interactive session on a GPU development node (`-p rtx-dev`) for a total time of 2 hours (`-t 02:00:00`). 

	```cmd-line
	login1$ idev -p rtx-dev -t 02:00:00
	```

	There may be a wait time as you sit in the queue. Once the command runs successfully, you will have a shell on a dedicated compute node, and your working directory will appear as follows:

    	c196-011[rtx](458)$

1. Load in Apptainer

	Once you have successfully have a shell launched on a compute node, you will need to load apptainer using module.  

	To load the apptainer module, run:

    	module load tacc-apptainer

	Now the **apptainer command** should be be available.  You can check by typing:

    	type apptainer

	Which should return:

    	apptainer is /opt/apps/tacc-apptainer/1.3.3/bin/apptainer



1. Pull a Prebuilt PyTorch Docker Image

	Instead of creating our own Dockerfile that is GPU-enabled, we can use an official PyTorch image from `DockerHub <https://hub.docker.com/>`_ to make the process of setting up a container for GPU use easier for us.  For more detailed instructions on how to build and upload your own Docker image from scratch, see [TACC's official Docker tutorial](https://hub.docker.com/u/tacc).

    DockerHub is the official cloud-based repository where developers store, share, and distribute Docker images, similar to Github.

	Run the following command to pull the latest PyTorch image from Dockerhub with CUDA support:

    	apptainer pull output.sif docker://pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel

	This will download the image and convert it into an Apptainer image format (.sif).
	You can replace "output.sif" with whatever you would like to name the file. Otherwise, it will default to the name of the image as defined on Dockerhub.

    CUDA is NVIDIA'S API that allows software to utilize NVIDIA GPUs for accelerated computing. This is essential for deep learning because GPUs process certain calculations much faster than CPUs.  Since TACC machines have NVIDIA GPUs, we must use a CUDA-enabled PyTorch image to fully leverage GPU acceleration.


1. Run code on GPU

	Finally, we can execute the multigpu training script within our Pytorch container.  It is important to note in the command below that apptainer will only recognize the presence of a GPU by passing the apptainer command the ``--nv`` flag.

		$ apptainer exec --nv output.sif torchrun --nproc_per_node=4 examples/distributed/ddp-tutorial-series/multigpu_torchrun.py 50 10 

	Once you've executed the script, you can check the output directly in your terminal. If there are any issues or errors, they will be displayed in the terminal.


## Refs

* [Containers at TACC tutorial](https://containers-at-tacc.readthedocs.io/en/latest/index.html).
* [TACC Docker Hub](https://hub.docker.com/u/tacc)


