## Machine Learning { #ml }

Frontera is well equipped to provide researchers with the latest in machine learning frameworks, for example PyTorch. We recommend using the Python virtual environment to manage machine learning packages. Below we detail how to install Pytorch on our systems with a virtual environment: 

### Install Pytorch 

1. Request a single compute node in Frontera's [`rtx-dev`](#queues) queue using the [`idev`][TACCIDEV] utility:
	```cmd-line
	login2.frontera$ idev -N 1 -n 1 -p rtx-dev -t 02:00:00
	```
1. Create a Python virtual environment: 
	```cmd-line
	c123-456$ module load python3/3.9.2
	```
c123-456$ python3 -m venv /path/to/virtual-env  # (e.g., $SCRATCH/python-envs/test)
1. Activate the Python virtual environment:
	```cmd-line
	c123-456$ source /path/to/virtual-env/bin/activate
	```
1. Now install PyTorch: 
	```cmd-line
	c123-456$ pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
	```

### Testing Pytorch Installation 

To test your installation of PyTorch we point you to a few benchmark calculations that are part of PyTorch's tutorials on multi-GPU and multi-node training.  See PyTorch's documentation: [Distributed Data Parallel in PyTorch](https://pytorch.org/tutorials/beginner/ddp_series_intro.html). These tutorials include several scripts set up to run single-node training and multi-node training.


#### Single-Node

1. Download the benchmark:
	```cmd-line
	c123-456$ cd $SCRATCH 
	```
c123-456$  git clone https://github.com/pytorch/examples.git
1. Run the benchmark on one node (4 GPUs):
	```cmd-line
	c123-456$ torchrun --nproc_per_node=4 examples/distributed/ddp-tutorial-series/multigpu_torchrun.py 50 10
	```
	
### Multi-Node

1. Request two nodes in the [`rtx-dev`](#queues) queue using the [`idev`][TACCIDEV] utility:

	```cmd-line
	login2.frontera$idev -N 2 -n 2 -p rtx-dev -t 02:00:00
	```
1. Move to the benchmark directory:
	```cmd-line
	c123-456$ cd $SCRATCH 
	```
1. Create a script called "run.sh". This script needs two parameters, the hostname of the master node and the number of nodes. Add execution permission for the file "run.sh".

	```syntax
	#!/bin/bash
	HOST=$1
	NODES=$2
	LOCAL_RANK=${PMI_RANK}
	torchrun --nproc_per_node=4  --nnodes=$NODES --node_rank=${LOCAL_RANK} --master_addr=$HOST \
		examples/distributed/ddp-tutorial-series/multinode.py 50 10
	```

1. Run multi-gpu training:
	```cmd-line
	c123-456$ ibrun -np 2 ./run.sh c123-456 2
	```















