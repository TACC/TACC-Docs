# PyTorch with Containers (Apptainer)
**Last update: January 26, 2026**

This page documents how to run the PyTorch multi-GPU sanity test inside an Apptainer container on TACC systems. We will pull a PyTorch image from Docker Hub and run a Python script within an Apptainer container.  Set up a GPU-enabled Pytorch container on one of TACC's HPC compute resources.  Run the benchmark `multigpu_torchrun.py` testing script.

### Notes

*  Always run containers from `$SCRATCH`
*  Use `--nv` for GPU access
*  Adjust `--nproc_per_node` to match GPUs allocated


## Detailed Instructions

1.  Load Apptainer Module

        c123-456$ module load tacc-apptainer

	Note that `apptainer` is only available on the compute nodes of any TACC HPC resource.

2.  Download test data

    Always use the `$SCRATCH` systen, not `$WORK` First, we will download some test data to run a simple ML task on. Clone the examples library from the official Pytorch Github repository by running:

         prompt$ git clone https://github.com/pytorch/examples.git

3.  Pull a Prebuilt PyTorch Docker Image

    Instead of going to the trouble of creating our own Dockerfile, we can use an official, pre-built PyTorch image from [DockerHub](https://hub.docker.com/) to make the process of setting up a container for GPU use easier for us. For more detailed instructions on how to build and upload your own Docker image from scratch, see [TACC's Docker Repository](https://hub.docker.com/u/tacc).

    DockerHub is the official cloud-based repository where developers store, share, and distribute Docker images, similar to Github.

    Run the following command to pull the latest PyTorch image from Dockerhub with CUDA support:

         c123-456$ apptainer pull output.sif docker://pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel

    This will download the image and convert it into an Apptainer image format (.sif). You can replace "output.sif" with whatever you would like to name the file. Otherwise, it will default to the name of the image as defined on Dockerhub.

    CUDA is NVIDIA'S API that allows software to utilize NVIDIA GPUs for accelerated computing. This is essential for deep learning because GPUs process certain calculations much faster than CPUs. Since TACC machines have NVIDIA GPUs, we must use a CUDA-enabled PyTorch image to fully leverage GPU acceleration.

4.  Run training code/sanity test on GPU

    Execute the multigpu training script within our Pytorch container with the following command:.

         prompt$ apptainer exec --nv output.sif torchrun --nproc_per_node=<GPU_COUNT> examples/distributed/ddp-tutorial-series/multigpu_torchrun.py 50 10 

    Examine the terminal's output to check for any issues or errors.

## Refs

*   [Containers at TACC tutorial](https://containers-at-tacc.readthedocs.io/en/latest/index.html)
*   [TACC Docker Hub](https://hub.docker.com/u/tacc)
*   [Pytorch DDP](https://docs.pytorch.org/tutorials/intermediate/ddp_tutorial.html)

<!-- 
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
-->
