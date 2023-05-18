## [Machine Learning](#ml) { #ml }

Frontera is well equipped to provide researchers with the latest in Machine Learning frameworks, PyTorch and Tensorflow. We recommend using the Python virtual environment to manage machine learning packages.

### [Running PyTorch ](#ml-pytorch) { #ml-pytorch }

Install Pytorch and TensorBoard.

1. Request a single compute node in Frontera's `rtx-dev` queue using the [`idev`](https://docs.tacc.utexas.edu/software/idev) utility:

	```cmd-line
	login2.frontera$ idev -N 1 -n 1 -p rtx-dev -t 02:00:00
	```

1. Create a Python virtual environment: 

	```cmd-line
	c123-456$ module load python3/3.9.2
	c123-456$ python3 -m venv /path/to/virtual-env  # (e.g., $SCRATCH/python-envs/test)
	```

1. Activate the Python virtual environment:

	```cmd-line
	c123-456$ source /path/to/virtual-env/bin/activate
	```

1. Now install PyTorch and TensorBoard: 

	```cmd-line
	c123-456$ pip3 install torch==1.12.1 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
	c123-456$ pip3 install tensorboard
	```

#### [Single-Node](#ml-pytorch-singlnode) { #ml-pytorch-singlnode }

1. Download the benchmark:

	```cmd-line
	c123-456$ cd $SCRATCH
	c123-456$ git clone https://github.com/gpauloski/kfac-pytorch.git
	c123-456$ cd kfac-pytorch
	c123-456$ git checkout tags/v0.3.2
	c123-456$ pip3 install -e .
	c123-456$ pip3 install torchinfo tqdm Pillow
	c123-456$ export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
	```

1. Run the benchmark on one node (4 GPUs):

	```cmd-line
	c123-456$ python3 -m torch.distributed.launch --nproc_per_node=4 examples/torch_cifar10_resnet.py --kfac-update-freq 0
	```

#### [Multi-Node](#ml-pytorch-multinode) { #ml-pytorch-multinode }

1. Request two nodes in the `rtx-dev` queue using the [`idev`](https://docs.tacc.utexas.edu/software/idev) utility:

	```cmd-line
	login2.frontera$ idev -N 2 -n 2 -p rtx-dev -t 02:00:00
	```

1. Go to the benchmark directory:

	```cmd-line
	c123-456$ cd $SCRATCH/kfac-pytorch
	```

1. Create a script called "`run.sh`". This script needs two parameters, the hostname of the master node and the number of nodes.

	```job-script
	#!/bin/bash
	HOST=$1
	NODES=$2
	LOCAL_RANK=${PMI_RANK}
	python3 -m torchdistributed.launch --nproc_per_node=4  --nnodes=$NODES --node_rank=${LOCAL_RANK} --master_addr=$HOST \
		examples/torch_cifar10_resnet.py --kfac-update-freq 0
	```

1. Run multi-gpu training:
	
	```cmd-line
	c123-456$ ibrun -np 2 ./run.sh c123-456 2
	```


### [Running Tensorflow ](#ml-tensorflow) { #ml-tensorflow }

Follow these instructions to install and run TensorFlow benchmarks on Frontera RTX. Frontera RTX runs TensorFlow 2.8.0 with Python 3.8.2. Frontera supports CUDA/10.1, CUDA/11.0, and CUDA/11.1. By default, we use CUDA/11.3. Select the appropriate CUDA version for your TensorFlow version.

1. Request a single compute node in Frontera's `rtx-dev` queue using the [`idev`](https://docs.tacc.utexas.edu/software/idev) utility:

	```cmd-line
	login2.frontera$ idev -N 1 -n 1 -p rtx-dev -t 02:00:00
	```

1. Create a Python virtual environment:

	```cmd-line
	c123-456$ python3 -m venv /path/to/virtual-env # e.g., $SCRATCH/python-envs/test
	```

1. Activate the Python virtual environment:

	```cmd-line
	c123-456$ source /path/to/virtual-env/bin/activate
	```

1. Install TensorFlow and Horovod:

	```cmd-line
	c123-456$ module load cuda/11.3 cudnn nccl
	c123-456$ pip3 install tensorflow-gpu==2.8.2
	```

	We suggest installing Horovod version 0.25.0. If you wish to install other versions of Horovod, please submit a support ticket with the subject "Request for Horovod" and TACC staff will provide special instructions.

	```cmd-line
	c123-456$ HOROVOD_CUDA_HOME=$TACC_CUDA_DIR HOROVOD_NCCL_HOME=$TACC_NCCL_DIR CC=gcc \
    	HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL HOROVOD_WITH_TENSORFLOW=1 pip3 install horovod==0.25.0
	```

#### [Single-Node](#ml-tensorflow-singlenode) { #ml-tensorflow-singlenode }

1. Download the tensorflow benchmark to your $SCRATCH directory, then check out the branch that matches your tensorflow version.

	```cmd-line
	c123-456$ cds; git clone https://github.com/tensorflow/benchmarks.git
	c123-456$ cd benchmarks 
	c123-456$ git checkout 51d647f     # master head as of 08/18/2022
	```

1. Activate the Python virtual environment:

	```cmd-line
	c123-456$ source /path/to/virtual-env/bin/activate
	```

1. Benchmark the performance with synthetic dataset on 1 GPU:

	```cmd-line
	c123-456$ cd scripts/tf_cnn_benchmarks
	c123-456$ python3 tf_cnn_benchmarks.py --num_gpus=1 --model resnet50 --batch_size 32 --num_batches 200
	```

1. Benchmark the performance with synthetic dataset on 4 GPUs:

	```cmd-line
	c123-456$ cd scripts/tf_cnn_benchmarks
	c123-456$ ibrun -np 4 python3 tf_cnn_benchmarks.py --variable_update=horovod --num_gpus=1 \
    	--model resnet50 --batch_size 32 --num_batches 200 --allow_growth=True
	```

