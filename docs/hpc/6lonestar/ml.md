## Machine Learning on LS6 { #ml }

Lonestar6 is well equipped to provide researchers with the latest in Machine Learning frameworks, PyTorch and Tensorflow. We recommend using the Python virtual environment to manage machine learning packages. Below we detail how to install PyTorch on our systems with a virtual environment: 

### Install PyTorch 

1. Request a single compute node in Lonestar6's `gpu-a100-dev` queue using TACC's [`idev`][TACCIDEV] utility:
	```cmd-line
	login$ idev -p gpu-a100-dev -N 1 -n 1 -t 1:00:00
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
	c123-456$ pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
	```

### Testing PyTorch Installation 

To test your installation of PyTorch we point you to a few benchmark calculations that are part of PyTorch's tutorials on multi-GPU and multi-node training.  See PyTorch's documentation: [Distributed Data Parallel in PyTorch](https://pytorch.org/tutorials/beginner/ddp_series_intro.html). These tutorials include several scripts set up to run single-node training and multi-node training.

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
	
#### Multi-Node

1. Request two nodes in the [`gpu-a100-dev`](#queues) queue using TACC's [`idev`][TACCIDEV] utility:
	```cmd-line
	login2.ls6$ idev -N 2 -n 2 -p gpu-a100-dev -t 01:00:00
	```

1. Move to the benchmark directory:
	```cmd-line
	c123-456$ cd $SCRATCH 
	```

1. Create a script called "run.sh". This script needs two parameters, the hostname of the master node and the number of nodes. Add execution permission for the file "run.sh".

	```file
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


