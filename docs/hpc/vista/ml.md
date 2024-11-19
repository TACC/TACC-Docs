## Machine Learning { #ml }

Vista is well equipped to provide researchers with the latest in Machine Learning frameworks, for example, PyTorch. The installation process will be a little different depending on whether you are using single or multiple nodes. Below we detail how to use PyTorch on our systems for both scenarios.

### Running PyTorch (Single Node)

#### Using the System PyTorch 

Follow these steps to use Vista's system PyTorch with a single GPU node.

1. Request a single compute node in Vista's `gh-dev` queue using the [`idev`][TACCIDEV] utility:
	```cmd-line
	login1.vista(76)$ idev -p gh-dev -N 1 -n 1 -t 1:00:00
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

#### Installing PyTorch 

Depending on your particular application, you may also need to install your own local copy of PyTorch. We recommend using the Python virtual environment to manage machine learning packages. Below we detail how to install PyTorch on our systems with a virtual environment:

1. Request a single compute node in Vista's `gh-dev` queue using the [`idev`][TACCIDEV] utility:
	```cmd-line
	login1.vista(76)$ idev -p gh-dev -N 1 -n 1 -t 1:00:00
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
	c123-456$ pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
	```

#### Testing PyTorch Installation

To test your installation of PyTorch we point you to a few benchmark calculations that are part of PyTorch's tutorials on multi-GPU and multi-node training.  See PyTorch's documentation: [Distributed Data Parallel in PyTorch](https://pytorch.org/tutorials/beginner/ddp_series_intro.html). These tutorials include several scripts set up to run single-node training and multi-node training.

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

To run multi-node jobs with Grace Hopper nodes on Vista you will need to use MPI-enabled Python. Follow these instructions to install and test these environments with MPI-enabled Python.

#### Using System PyTorch

Follow these steps to use Vista's system PyTorch with multiple GPU nodes.

1. Request a single compute node in Vista's `gh-dev` queue using the `idev` utility:
	```cmd-line
	login1.vista(76)$ idev -p gh-dev -N 2 -n 2 -t 1:00:00
	```
1. Load modules
	```cmd-line
	c123-456$ module load gcc cuda
	c123-456$ module load python3_mpi
	```

1. Launch Python interpreter and check to see that you can import PyTorch and that it can utilize the GPU nodes:
	```cmd-line
	import torch 
	torch.cuda.is_available()
	```	

### Installing PyTorch

To run multi-node jobs with Grace Hopper nodes on Vista you will need to use MPI-enabled Python.  Below we detail how to install PyTorch with MPI-enabled Python using a virtual environment:

1. Request two nodes in the `gh-dev` queue using the `idev` utility:
	```cmd-line
	idev -N 2 -n 2 -p gh-dev -t 01:00:00
	```

1. Create a Python virtual environment: 
	```cmd-line
	c123-456$ module load gcc cuda
	c123-456$ module load python3_mpi
	c123-456$ python3 -m venv /path/to/virtual-env-single-node  # (e.g., $SCRATCH/python-envs/test)
	```

1. Activate the Python virtual environment:
	```cmd-line
	c123-456$ source /path/to/virtual-env-single-node/bin/activate
	```

1. Now install PyTorch: 
	```cmd-line
	c123-456$ pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu124
	```

### Testing PyTorch Installation

To test your installation of multi-node PyTorch we supply a simple script below.  To launch this script run the following command:

```cmd-line
c123-456$ ibrun -np 2 python3 test.py c123-456
```

Python script ("test.py")

```file
import os
import argparse

from mpi4py import MPI

import torch
import torch.distributed as dist

# use mpi4py to get the world size and tasks rank
WORLD_SIZE = MPI.COMM_WORLD.Get_size()
WORLD_RANK = MPI.COMM_WORLD.Get_rank()

# use the convention that gets the local rank based on how many
# GPUs there are on the node.
GPU_ID = WORLD_RANK % torch.cuda.device_count()
name = MPI.Get_processor_name()

def run(backend):
	tensor = torch.randn(10000,10000)

	# Need to put tensor on a GPU device for nccl backend
	if backend == 'nccl':
    	device = torch.device("cuda:{}".format(GPU_ID))
    	tensor = tensor.to(device)
	print("Starting process on " + name+ ":" +torch.cuda.get_device_name(GPU_ID))
	if WORLD_RANK == 0:
    	for rank_recv in range(1, WORLD_SIZE):
        	dist.send(tensor=tensor, dst=rank_recv)
        	print('worker_{} sent data to Rank {}\n'.format(0, rank_recv))
	else:
    	dist.recv(tensor=tensor, src=0)
    	print('worker_{} has received data from rank {}\n'.format(WORLD_RANK,0))

def init_processes(backend, master_address):
	print("World Rank: %s, World Size: %s, GPU_ID: %s"%(WORLD_RANK,WORLD_SIZE,GPU_ID))
	os.environ["MASTER_ADDR"] = master_address
	os.environ["MASTER_PORT"] = "12355"
	dist.init_process_group(backend, rank=WORLD_RANK, world_size=WORLD_SIZE)
	run(backend)

if __name__ == "__main__":

	parser = argparse.ArgumentParser()
	parser.add_argument("master_node", type=str)
	parser.add_argument("--backend", type=str, default="nccl", choices=['nccl', 'gloo'])
	args = parser.parse_args()
	backend=args.backend
	if torch.cuda.device_count() == 0:
    	print("No gpu detected...switching to gloo for backend")
    	backend="gloo"
	init_processes(backend=backend,master_address=args.master_node)
	dist.destroy_process_group()
```
