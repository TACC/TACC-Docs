## Machine Learning on Vista { #ml }

You may utilize one or more nodes for machine-learning model training tasks on Vista. Vista supports both configurations, enabling researchers to scale their training efficiently based on project requirements.

* Single-node training utilizes one or multiple GPUs on a single node and is ideal for smaller models and datasets, offering faster job throughput and easier debugging. 
* Multi-node training, on the other hand, distributes the workload across multiple nodes, each with its own set of GPUs. This approach is necessary for large-scale models and datasets that exceed the memory or compute capacity of a single node, and is essential for scalability. 

### Environment Setup

Before diving into machine learning frameworks, it's essential to set up your environment correctly. Vista supports Python virtual environments, which help manage dependencies and isolate projects. This guide walks you through setting up environments for both PyTorch and Accelerate.

We recommend using a Python virtual environment to manage machine learning packages. Once set up, users can run jobs within this environment using either [`idev`][TACCIDEV] sessions or [SLURM batch scripts](#scripts).

### Running PyTorch (Single Node)

Follow these steps to use Vista's system PyTorch with a single GPU node.

1. Request a single compute node in Vista's [`gh-dev` queue](#queues) using the [`idev`][TACCIDEV] utility:
	```cmd-line
	login1$ idev -p gh-dev -N 1 -n 1 -t 1:00:00
	```
1. Load modules
	```cmd-line
	c123-456$ module load gcc cuda
	c123-456$ module load python3
	```

1. Launch Python interpreter and check to see that you can import PyTorch and that it can utilize the GPU nodes:
	```cmd-line
	import torch 
	torch.cuda.is_available()
	```

### Installing PyTorch

Depending on your particular application, you may also need to install your own local copy of PyTorch. We recommend using the Python virtual environment to manage machine learning packages. Below we detail how to install PyTorch on our systems with a virtual environment:

1. Request a single compute node in Vista's [`gh-dev` queue](#queues) using the [`idev`][TACCIDEV] utility:
	```cmd-line
	login1$ idev -p gh-dev -N 1 -n 1 -t 1:00:00
	```
1. Load modules
	```cmd-line
	c123-456$ module load gcc/15.1.0  
	c123-456$ module load python3/3.11.8
	```
1. Create a Python virtual environment:
	```cmd-line
	c123-456$ module load gcc cuda
	c123-456$ module load python3
	c123-456$ python3 -m venv /path/to/virtual-env-single-node  # (e.g., $SCRATCH/python-envs/test)
	```
1. Activate the Python virtual environment:
	```cmd-line
	c123-456$ source /path/to/virtual-env-single-node/bin/activate
	```
1. Install PyTorch
	```cmd-line
	c123-456$ pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu129
	```

### Testing PyTorch Installation
To test your installation of PyTorch we point you to a few benchmark calculations that are part of PyTorch's tutorials on multi-GPU and multi-node training. See PyTorch's documentation: Distributed Data Parallel in PyTorch. These tutorials include several scripts set up to run single-node training and multi-node training.

1. Download the benchmark:
	```cmd-line
	c123-456$ cd $SCRATCH (or directory on scratch where you want this repo to reside)
	c123-456$ git clone https://github.com/pytorch/examples.git
	```

1. Run the benchmark on one node (1 GPU):
	```cmd-line
	c123-456$ python3 examples/distributed/ddp-tutorial-series/single_gpu.py 50 10
	```

### Running PyTorch (Multi-node)

1. Request two nodes in the [`gh-dev` queue](#queues) using TACC's [`idev`][TACCIDEV]  utility:
	```cmd-line
	login1$ idev -p gh-dev -N 2 -n 2 -t 1:00:00
	```

1. Move to the benchmark directory:
	```cmd-line
	c123-456$ cd $SCRATCH
	```

1. Create a script called "run.sh". This script needs two parameters, the hostname of the master node and the number of nodes. Add execution permission for the file "run.sh".
	```
	#!/bin/bash
	HOST=$1
	NODES=$2
	LOCAL_RANK=${OMPI_COMM_WORLD_RANK}
	torchrun --nproc_per_node=1  --nnodes=$NODES --node_rank=${LOCAL_RANK} --master_addr=$HOST \
   		examples/distributed/ddp-tutorial-series/multinode.py 50 10
	```
1. Run multi-gpu training:
	```cmd-line
	c123-456$ mpirun -np 2  --map-by ppr:1:node run.sh c123-456 2
	```

### Setting Up Transformers with Accelerate

Transformers is a Python library developed by Hugging Face that provides pre-trained models for machine learning tasks. It includes implementations of popular architectures like BERT, GPT, and T5, making it easy to fine-tune and deploy state-of-the-art models.

Accelerate is a Hugging Face library designed to streamline distributed training. It abstracts away the complexity of launching multi-GPU and multi-node jobs, allowing users to scale their training with minimal code changes. Follow these steps to set up and run training jobs.

### Set up Environment for Transformers and Accelerate


1. Download the code and scripts for the job and change directory 
	```cmd-line
	c123-456$ cd $SCRATCH
	c123-456$ git clone https://github.com/skye-glitch/Machine-Learning-on-Vista.git
	c123-456$ cd Machine-Learning-on-Vista
	```

1. Request a single compute node in Vista [`gh-dev` queue](#queues) using TACC's [`idev`][TACCIDEV] utility:
	```cmd-line
	login1$ idev -p gh-dev -N 1 -n 1 -t 1:00:00
	```
1. Load modules
	```cmd-line
	c123-456$ module load gcc cuda
	c123-456$ module load python3
	```
1. Create a Python virtual environment:
	```cmd-line
	c123-456$ python3 -m venv .venv 
	```
1. Activate the Python virtual environment:
	```cmd-line
	c123-456$ source .venv
	```
1. Now install dependencies:
	```cmd-line
	c123-456$ pip3 install -r requirements.txt
	```

### Testing Transformers and Accelerate Installation

#### Single-Node

Run the training on one node (1 GPU):
```cmd-line
c123-456$ python ./finetune.py
```

#### Multi-Node

1. Request two nodes in the [`gh-dev` queue](#queues) using TACC's [`idev`][TACCIDEV]  utility:
	```
	login1$ idev -p gh-dev -N 2 -n 2 -t 1:00:00
	```


1. Move to the code directory:
	```
	c123-456$ cd $SCRATCH/Machine-Learning-on-Vista
	```

1. Run the multi-gp training:
	```
	c123-456$ mpirun -np 2  --map-by ppr:1:node multinode.sh
	```


