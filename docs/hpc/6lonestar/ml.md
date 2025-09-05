## Machine Learning on LS6 { #ml }

You may utilize one or more nodes for machine-learning model training tasks on Lonestar6. Lonestar6 supports both configurations, enabling researchers to scale their training efficiently based on project requirements.

* Single-node training utilizes one or multiple GPUs on a single node and is ideal for smaller models and datasets, offering faster job throughput and easier debugging. 
* Multi-node training, on the other hand, distributes the workload across multiple nodes, each with its own set of GPUs. This approach is necessary for large-scale models and datasets that exceed the memory or compute capacity of a single node, and is essential for scalability. 

### Environment Setup

Before diving into machine learning frameworks, it's essential to set up your environment correctly. Lonestar6 supports Python virtual environments, which help manage dependencies and isolate projects. This guide walks you through setting up environments for both PyTorch and Accelerate.

We recommend using a Python virtual environment to manage machine learning packages. Once set up, users can run jobs within this environment using either idev sessions or SLURM batch scripts.

Below we detail how to set up PyTorch on Lonestar6 within a Python virtual environment:

### Set up Environment for PyTorch

SDL Note that we install in Lonestar6’s /scratch directory - purge - yada

1. Request a single compute node in Lonestar6's [`gpu-a100-dev` queue](#queues) using TACC's [`idev utility`](#TACCIDEV):
	```cmd-line
	login1$ idev -p gpu-a100-dev -N 1 -n 1 -t 1:00:00
	```

1. Create a Python virtual environment:
	```cmd-line
	c123-456$ module load python3/3.9.7
	c123-456$ python3 -m venv /path/to/virtual-env  # (e.g., $SCRATCH/python-envs/test)
	```

1. Activate the Python virtual environment:
	```cmd-line
	c123-456$ source /path/to/virtual-env/bin/activate
	```

1. Now install PyTorch:
	```cmd-line
	c123-456$ pip3 install torch==2.8.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu128
	```

### Testing PyTorch Installation

To test your installation of PyTorch we point you to a few benchmark calculations that are part of PyTorch's tutorials on multi-GPU and multi-node training. See PyTorch's documentation: 

Distributed Data Parallel in PyTorch. These tutorials include several scripts set up to run single-node training and multi-node training.

#### Single-Node

1. Download the benchmark:
	```cmd-line
	c123-456$ cd $SCRATCH
	c123-456$  git clone https://github.com/pytorch/examples.git
	```

1. Run the benchmark on one node (3 GPUs):
	```cmd-line
	c123-456$ torchrun --nproc_per_node=3 examples/distributed/ddp-tutorial-series/multigpu_torchrun.py 50 10
	```

Multi-Node
1. Request two nodes in the gpu-a100-dev queue using TACC's idev  utility:
	```cmd-line
	login1$ idev -N 2 -n 2 -p gpu-a100-dev -t 01:00:00
	```

1. Move to the benchmark directory:
	```cmd-line
	c123-456$ cd $SCRATCH
	```

1. Create a script called "run.sh". This script needs two parameters, the hostname of the master node and the number of nodes. Add execution permission for the file "run.sh".
	```cmd-line
	#!/bin/bash
	HOST=$1
	NODES=$2
	LOCAL_RANK=${PMI_RANK}
	torchrun --nproc_per_node=3  --nnodes=$NODES --node_rank=${LOCAL_RANK} --master_addr=$HOST \
	   	examples/distributed/ddp-tutorial-series/multinode.py 50 10
	```

1. Run multi-gpu training:
	```cmd-line
	c123-456$ ibrun -np 2 ./run.sh c123-456 2
	```


### Setting Up Transformers with Accelerate

Transformers is a Python library developed by Hugging Face that provides pre-trained models for machine learning tasks. It includes implementations of popular architectures like BERT, GPT, and T5, making it easy to fine-tune and deploy state-of-the-art models.

Accelerate is a Hugging Face library designed to streamline distributed training. It abstracts away the complexity of launching multi-GPU and multi-node jobs, allowing users to scale their training with minimal code changes. Follow these steps to set up and run training jobs.

#### Set up Environment for Transformers

1. Download the code and scripts for the job and change directory 
	```cmd-line
	c123-456$ cd $SCRATCH
	c123-456$  git clone https://github.com/skye-glitch/Machine-Learning-on-LS6.git
	c123-456$ cd Machine-Learning-on-LS6
	```
1. Request a single compute node in Lonestar6's `gpu-a100-dev` queue using TACC's `idev` utility:
	```cmd-line
	login1$ idev -p gpu-a100-dev -N 1 -n 1 -t 1:00:00
	```

1. Create a Python virtual environment:
	```cmd-line
	c123-456$ module load python3/3.9.7
	c123-456$ python3 -m venv .venv 
	```
1. Request a single compute node in Lonestar6's  gpu-a100-dev queue using TACC's  idev utility:
	```cmd-line
	login1$ idev -p gpu-a100-dev -N 1 -n 1 -t 1:00:00
	```

1. Activate the Python virtual environment:
	```cmd-line
	c123-456$ source .venv
	```

1. Now install dependencies:
	```cmd-line
	c123-456$ pip3 install -r requirements.txt
	```

### Testing Transformers Installation

#### Single-Node

Run the training on one node (3 GPUs):

```cmd-line
c123-456$ accelerate launch --num_processes 3 ./finetune.py
```

#### Multi-Node

1. Request two nodes in the gpu-a100-dev queue using TACC's idev  utility:
	```cmd-line
	login2.ls6$ idev -N 2 -n 2 -p gpu-a100-dev -t 01:00:00
	```

1. Move to the code directory:
	```cmd-line
	c123-456$ cd $SCRATCH/Machine-Learning-on-LS6
	```

1. Run the multi-gpu training:
	```cmd-line
	c123-456$ mpirun -np 2  --map-by ppr:1:node multinode.sh
	```


