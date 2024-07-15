## Machine Learning on LS6 { #ml }

Lonestar6 is well equipped to provide researchers with the latest in Machine Learning frameworks, PyTorch and Tensorflow. We recommend using the Python virtual environment to manage machine learning packages.

### Running PyTorch  { #ml-pytorch }

Install Pytorch and TensorBoard.

1. Request a single compute node in Lonestar6's `gpu-a100-dev` queue using the [idev](../../software/idev) utility:

	```cmd-line
	login$ idev -p gpu-a100-dev -N 1 -n 1 -t 1:00:00
	```

1. Create a Python virtual environment:

	```cmd-line
	c123-456.ls6$ module load python3/3.9.7
	c123-456.ls6$ python3 -m venv /path/to/virtual-env  # (e.g., $SCRATCH/python-envs/test)
	```

1. Activate the Python virtual environment:

	```cmd-line
	c123-456.ls6$ source /path/to/virtual-env/bin/activate
	```

1. Now install PyTorch and TensorBoard:

	```cmd-line
	c123-456.ls6$ pip3 install torch==1.12.1 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
	c123-456.ls6$ pip3 install tensorboard
	```

#### Single-Node { #ml-pytorch-singlnode }

1. Download the benchmark:

	```cmd-line
	c123-456.ls6$ cd $SCRATCH
	c123-456.ls6$ git clone https://github.com/gpauloski/kfac-pytorch.git
	c123-456.ls6$ cd kfac-pytorch
	c123-456.ls6$ git checkout tags/v0.3.2
	c123-456.ls6$ pip3 install -e .
	c123-456.ls6$ pip3 install torchinfo tqdm Pillow
	c123-456.ls6$ export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
	```

1. Run the benchmark on one node (3 GPUs):

	```cmd-line
	c123-456.ls6$ python3 -m torch.distributed.launch --nproc_per_node=3 examples/torch_cifar10_resnet.py --kfac-update-freq 0
	```

#### Multi-Node { #ml-pytorch-multinode }

1. Request two nodes in the `gpu-a100-dev` queue using the [`idev`](../../software/idev) utility:

	```cmd-line
	login2.ls6$ idev -N 2 -n 2 -p gpu-a100-dev -t 01:00:00
	```

1. Activate the Python virtual environment:

	```cmd-line
	c123-456.ls6$ source /path/to/virtual-env/bin/activate
	```

1. Move to the benchmark directory:

	```cmd-line
	c123-456.ls6$ cd $SCRATCH/kfac-pytorch
	```

1. Create a script called "`run.sh`". This script needs two parameters, the hostname of the master node and the number of nodes. Add execution permission for the file "run.sh".

	```job-script
	#!/bin/bash
	HOST=$1
	NODES=$2
	LOCAL_RANK=${PMI_RANK}
	python3 -m torch.distributed.launch --nproc_per_node=3  --nnodes=$NODES --node_rank=${LOCAL_RANK} --master_addr=$HOST \
    	examples/torch_cifar10_resnet.py --kfac-update-freq 0
	```

1. Run multi-gpu training:

	```cmd-line
	c123-456.ls6$ ibrun -np 2 ./run.sh c123-456 2
	```

### Running Tensorflow  { #ml-tensorflow }

Follow these instructions to install and run TensorFlow benchmarks on Lonestar6's A100. Lonestar6's A100 runs TensorFlow 2.8.2 with Python 3.7.13. Lonestar6's supports CUDA/11.3, CUDA/11.4, and CUDA/12.0. By default, we use CUDA/11.3. Select the appropriate CUDA version for your TensorFlow version.

1. Request a single compute node in Lonestar6's `gpu-a100-dev` queue using the [idev](../../software/idev) utility:

	```cmd-line
	login2.ls6$ idev -N 1 -n 1 -p gpu-a100-dev -t 01:00:00
	```

1. Create a Python virtual environment:

	```cmd-line
	c123-456.ls6$ module load python3/3.7.13 cuda/11.3 cudnn nccl
	c123-456.ls6$ python3 -m venv /path/to/virtual-env # e.g., $SCRATCH/python-envs/test
	```

1. Activate the Python virtual environment:

	```cmd-line
	c123-456.ls6$ source /path/to/virtual-env/bin/activate
	```

1. Install TensorFlow and Horovod:

	```cmd-line
	c123-456.ls6$ pip3 install tensorflow-gpu==2.8.2
	```

	We suggest installing Horovod version 0.25.0. If you wish to install other versions of Horovod, please submit a support ticket with the subject "Request for Horovod" and TACC staff will provide special instructions.

	```cmd-line
	c123-456.ls6$ HOROVOD_CUDA_HOME=$TACC_CUDA_DIR HOROVOD_NCCL_HOME=$TACC_NCCL_DIR CC=gcc \
   	HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL HOROVOD_WITH_TENSORFLOW=1 pip3 install horovod==0.25.0
	```

#### Single-Node { #ml-tensorflow-singlenode }

1. Download the tensorflow benchmark to your `$SCRATCH` directory, then check out the branch that matches your tensorflow version.

	```cmd-line
	c123-456.ls6$ cds; git clone https://github.com/tensorflow/benchmarks.git
	c123-456.ls6$ cd benchmarks 
	c123-456.ls6$ git checkout 51d647f     # master head as of 08/18/2022
	```

1. Load modules and activate the Python virtual environment:

	```cmd-line
	c123-456.ls6$ module load python3/3.7.13 cuda/11.3 cudnn nccl
	c123-456.ls6$ source /path/to/virtual-env/bin/activate
	```

1. Benchmark the performance with synthetic dataset on 1 GPU:

	```cmd-line
	c123-456.ls6$ cd scripts/tf_cnn_benchmarks
	c123-456.ls6$ python3 tf_cnn_benchmarks.py --num_gpus=1 --model resnet50 --batch_size 32 --num_batches 200
	```

1. Benchmark the performance with synthetic dataset on 3 GPUs:

	```cmd-line
	c123-456.ls6$ cd scripts/tf_cnn_benchmarks
	c123-456.ls6$ ibrun -np 3 python3 tf_cnn_benchmarks.py --variable_update=horovod --num_gpus=1 \
   		--model resnet50 --batch_size 32 --num_batches 200 --allow_growth=True
	```


