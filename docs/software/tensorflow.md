# TensorFlow at TACC
*Last update: August 14, 2023*

Scientists across domains are actively exploring and adopting deep learning as a cutting-edge methodology to make research breakthrough. At TACC, our mission is to enable discoveries that advance science and society through the application of advanced computing technologies. Thus, we are embracing this new type of application on our high end computing platforms.

TACC supports the TensorFlow+Horovod stack. This framework exposes high level interfaces for deep learning architecture specification, model training, tuning, and validation. Deep learning practitioners and domain scientists who are exploring the deep learning methodology should consider this framework for their research.

This document details how to install TensorFlow, then download and run benchmarks in both single- and multi-node modes. Due to variations in TensorFlow and Python versions, and their compatabilities with the Intel compilers and CUDA libraries, the installation instructions are quite specific. Pay careful attention to the installation instructions.

## [Installations](#installations) { #installations }

TensorFlow is installed on TACC's [Lonestar6](../../hpc/lonestar6), [Frontera](../../hpc/frontera), and [Stampede2](../../hpc/stampede2) resources.

* Parallel Training with TensorFlow and Horovod is available on Stampede2. 
* TensorFlow v2.1 is available on Stampede2.

!!! caution
	Running programs or performing computations on the login nodes may result in account suspension.<br>
	All of the following examples are run on compute, not login, nodes.<br>
	Use TACC's <a href="../idev"><code>idev</code></a> utility to grab compute node/s when conducting any TensorFlow activities.


## [TensorFlow on Lonestar6](#lonestar6) { #lonestar6 }

These instructions detail installing and running TensorFlow benchmarks on Lonestar6. Lonestar6 runs TensorFlow 2.6.1 with CUDA/11.4, Python 3.9.7 and Intel 19.

To install Horovod: 

``` cmd-line
login1$ module load cuda/11.4 cudnn/8.2.4 nccl/2.11.4
login1$ pip3 install --user gast==0.4.0 keras==2.6.0 tensorflow-gpu==2.6.1 --no-cache-dir
login1$ HOROVOD_CUDA_HOME=$TACC_CUDA_DIR HOROVOD_NCCL_HOME=$TACC_NCCL_DIR \
			CC=icc HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL HOROVOD_WITH_TENSORFLOW=1 \
			pip3 install horovod --no-cache-dir
```


### [Single-Node](#lonestar6-singlenode) { #lonestar6-singlenode }

To run a single-node job benchmark on one GPU, first create an `idev` session in LS6's [`gpu-a100`](../../hpc/lonestar6#queues) queue: 

``` cmd-line
login1$ idev -N 1 -n 2 -p gpu-a100
```

Once the `idev` session is created, run the benchmark on a single node, using one GPU:

``` cmd-line
c307-001.ls6$ cds; git clone https://github.com/tensorflow/benchmarks.git
c307-001.ls6$ cd benchmarks
c307-001.ls6$ module load cuda/11.4 cudnn/8.2.4 nccl/2.11.4
c307-001.ls6$ python3 scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
				--num_gpus=1 --model resnet50 --batch_size 32 --num_batches 200
```

Run the same benchmark using both GPUs:

``` cmd-line
c307-001.ls6$ python3 scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
				--num_gpus=2 --model resnet50 --batch_size 32 --num_batches 200
```



### [Multi-Node](#lonestar6-multinode) { #lonestar6-multinode }

To run a multi-node job benchmark, first create a multi-node `idev` session in LS6's [`gpu-a100`](../../hpc/lonestar6#queues) queue: 

``` cmd-line
login1$ idev -N 2 -n 4 -p gpu-a100
```

Once the `idev` session is created, run the benchmarks on two nodes, using four GPUs:

``` cmd-line
c305-000$ cds;git clone  https://github.com/tensorflow/benchmarks.git
c305-000$ cd benchmarks
c305-000$ module load cuda/11.4 cudnn/8.2.4 nccl/2.11.4
c305-000$ ibrun -np 4 python3 scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
			--num_gpus=1 --variable_update=horovod --model resnet50 --batch_size 32 --num_batches 200
```

<!--
## [TensorFlow on Maverick2](#maverick2) { #maverick2 }

These instructions detail installing and running TensorFlow benchmarks on Maverick2. Maverick2 runs TensorFlow 2.1.0 with Python 3.7.0 and Intel 18.

Maverick2 supports CUDA/10.0, and CUDA/10.1. Use the respective CUDA version for your TensorFlow installation with Python 3.7.

``` cmd-line

c123-456$ module load intel/18.0.2 python3/3.7.0
c123-456$ module load cuda/10.1 cudnn/7.6.5 nccl/2.5.6
c123-456$ pip3 install --user grpcio==1.28.1 tensorflow-gpu==2.1.0 --no-cache-dir
```

We suggest installing Horovod version 0.19.2. If you wish to install other versions of Horovod, please [submit a support ticket][HELPDESK] with the subject "Request for Horovod" and TACC staff will provide special instructions.

``` cmd-line

c123-456$ HOROVOD_CUDA_HOME=$TACC_CUDA_DIR HOROVOD_NCCL_HOME=$TACC_NCCL_DIR CC=gcc \
	HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL HOROVOD_WITH_TENSORFLOW=1 pip3 install \
	--user horovod==0.19.2 --no-cache-dir
```

### [Single-Node](#maverick2-singlenode) { #maverick2-singlenode }

Download the tensorflow benchmark to your `$WORK` directory, then check out the branch that matches your tensorflow version.

``` cmd-line

c123-456$ cdw; git clone https://github.com/tensorflow/benchmarks.git
c123-456$ cd benchmarks
c123-456$ git checkout cnn_tf_v2.1_compatible
```

Benchmark the performance with the synthetic dataset on 1 GPU:

``` cmd-line

c123-456$ cd scripts/tf_cnn_benchmarks
c123-456$ module load intel/18.0.2 python3/3.7.0 cuda/10.1 cudnn/7.6.5 nccl/2.5.6
c123-456$ python3 tf_cnn_benchmarks.py --num_gpus=1 --model resnet50 --batch_size 32 --num_batches 200
```

Benchmark the performance with the synthetic dataset on 4 GPUs:

``` cmd-line

c123-456$ cd scripts/tf_cnn_benchmarks
c123-456$ module load intel/18.0.2 python3/3.7.0 cuda/10.1 cudnn/7.6.5 nccl/2.5.6
c123-456$ ibrun -np 4 python3 tf_cnn_benchmarks.py --variable_update=horovod \
            --num_gpus=1 --model resnet50 --batch_size 32 --num_batches 200 --allow_growth=True
```

### [Multi-Node](#maverick2-multinode) { #maverick2-multinode }

Download the TensorFlow benchmark to your `$WORK` directory. Check out the branch that matches your tensorflow version. This example runs on two nodes in Maverick2's `gtx` queue (8 GPUs).

``` cmd-line

c123-456$ cdw; git clone https://github.com/tensorflow/benchmarks.git
c123-456$ git checkout cnn_tf_v2.1_compatible
```

Benchmark the performance with synthetic dataset on these two 2 nodes using 8 GPUs:

``` cmd-line

c123-456$ cd scripts/tf_cnn_benchmarks
c123-456$ module load intel/18.0.2 python3/3.7.0 cuda/10.1 cudnn/7.6.5 nccl/2.5.6
c123-456$ ibrun -np 8 python3 tf_cnn_benchmarks.py --variable_update=horovod \
            --num_gpus=1 --model resnet50 --batch_size 32 --num_batches 200 --allow_growth=True
```
-->

## [TensorFlow on Frontera](#frontera) { #frontera }

These instructions detail installing and running TensorFlow benchmarks on Frontera RTX. Frontera RTX runs TensorFlow 2.1.0 with Python 3.7.0 and Intel 19. Frontera supports CUDA10.0 and CUDA/10.1. Use the appropriate CUDA version for your TensorFlow installation with Python 3.7.6.

``` cmd-line

c123-456$ module load python3 
c123-456$ module load cuda/10.1 cudnn/7.6.5 nccl/2.5.6
c123-456$ pip3 install --user grpcio==1.28.1 tensorflow-gpu==2.1.0 --no-cache-dir
```

We suggest installing Horovod version 0.19.2. If you wish to install other versions of Horovod, please [submit a support ticket][HELPDESK] with the subject "Request for Horovod" and TACC staff will provide special instructions.

``` cmd-line
c123-456$ HOROVOD_CUDA_HOME=$TACC_CUDA_DIR HOROVOD_NCCL_HOME=$TACC_NCCL_DIR CC=gcc \
	HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL HOROVOD_WITH_TENSORFLOW=1 pip3 install \
	--user horovod==0.19.2 --no-cache-dir
```

### [Single-Node](#frontera-singlenode) { #frontera-singlenode }

Download the tensorflow benchmark to your `$WORK` directory, then check out the branch that matches your tensorflow version.

``` cmd-line

c123-456$ cds; git clone https://github.com/tensorflow/benchmarks.git
c123-456$ cd benchmarks  
c123-456$ git checkout cnn_tf_v2.1_compatible
```

Benchmark the performance with synthetic dataset on 1 GPU

``` cmd-line

c123-456$ cd scripts/tf_cnn_benchmarks
c123-456$ module load python3/3.7.0 cuda/10.1 cudnn/7.6.5 nccl/2.5.6
c123-456$ python3 tf_cnn_benchmarks.py --num_gpus=1 --model resnet50 --batch_size 32 --num_batches 200
```

Benchmark the performance with synthetic dataset on 4 GPUs

``` cmd-line

c123-456$ cd scripts/tf_cnn_benchmarks
c123-456$ module load python3/3.7.0 cuda/10.1 cudnn/7.6.5 nccl/2.5.6
c123-456$ ibrun -np 4 python3 tf_cnn_benchmarks.py --variable_update=horovod --num_gpus=1 \
	--model resnet50 --batch_size 32 --num_batches 200 --allow_growth=True
```

### [Multi-Node](#frontera-multinode) { #frontera-multinode }

Download the TensorFlow benchmark to your `$WORK` directory. Check out the branch that matches your tensorflow version. This example runs on two nodes in the `rtx queue` (8 GPUs).

``` cmd-line

c123-456$ cds; git clone https://github.com/tensorflow/benchmarks.git
c123-456$ git checkout cnn_tf_v2.1_compatible
```

Benchmark the performance with synthetic dataset on these two 2 nodes using 8 GPUs

``` cmd-line

c123-456$ cd scripts/tf_cnn_benchmarks
c123-456$ module load python3/3.7.0 cuda/10.1 cudnn/7.6.5 nccl/2.5.6
c123-456$ ibrun -np 8 python3 tf_cnn_benchmarks.py --variable_update=horovod --num_gpus=1 \
	--model resnet50 --batch_size 32 --num_batches 200 --allow_growth=True
```

## [TensorFlow on Stampede2](#stampede2) { #stampede2 }

These instructions detail installing and running TensorFlow benchmarks on Stampede2. Stampede2 runs TensorFlow 2.1.0 with Python 3.7 and Intel 18.

Use TACC's `idev` utility to grab a single compute node for 1 hour in Stampede2's [skx-dev queue](../../hpc/stampede2#queues):

``` cmd-line
login1$ idev -p skx-dev -N 1 -n 1 -m 60
```

Install TensorFlow 2.1 using the default intel/18.0.2 compiler and Python 3.7:

``` cmd-line

c123-456$ module load intel/18.0.2 python3/3.7.0
c123-456$ pip3 install --user tensorflow==2.1.0 --no-cache-dir
```

To install horovod v0.19.2:

``` cmd-line

c123-456$ CC=gcc HOROVOD_WITH_TENSORFLOW=1 pip3 install --user horovod==0.19.2 --no-cache-dir --no-cache-dir
```

### [Single-Node](#stampede2-singlenode) { #stampede2-singlenode }

If you're not already on a compute node, then use TACC's `idev` utility to grab a single compute node for 1 hour:
``` cmd-line

login1$ idev -p skx-dev -N 1 -n 1 -m 60
```

Download the TensorFlow benchmark to your `$SCRATCH` directory. Check out the corresponding branch for your TensorFlow version. In this example we used `cnn_tf_v2.1_compatible`.

``` cmd-line

c123-456$ cd $SCRATCH
c123-456$ git clone https://github.com/tensorflow/benchmarks.git
c123-456$ cd benchmarks
c123-456$ git checkout cnn_tf_v2.1_compatible
```

Benchmark the performance with a synthetic dataset:

``` cmd-line

c123-456$ cd scripts/tf_cnn_benchmarks
c123-456$ export KMP_BLOCKTIME=0
c123-456$ export KMP_AFFINITY="granularity=fine,verbose,compact,1,0"
c123-456$ export OMP_NUM_THREADS=46
c123-456$ python3 tf_cnn_benchmarks.py --model resnet50 --batch_size 128 --data_format NHWC \
	--num_intra_threads 46 --num_inter_threads 2 --distortions=False --num_batches 100
```

### [Multi-Node](#stampede2-multinode) { #stampede2-multinode }

If you're not already on a compute node, then use TACC's `idev` utility to grab two compute nodes for 1 hour:

``` cmd-line

login1$ idev -p skx-dev -N 2 -n 2 -m 60
```

Download the TensorFlow benchmark to your `$SCRATCH` directory. Check out the corresponding branch for your TensorFlow version. In this example, we used `cnn_tf_v2.1_compatible`.

``` cmd-line

c123-456$ cd $SCRATCH
c123-456$ git clone https://github.com/tensorflow/benchmarks.git
c123-456$ git checkout cnn_tf_v2.1_compatible
```

Benchmark the performance with a synthetic dataset on 4 nodes:

``` cmd-line

c123-456$ module load intel/18.0.2 python3/3.7.0 
c123-456$ cd benchmarks/scripts/tf_cnn_benchmarks
c123-456$ export KMP_BLOCKTIME=0
c123-456$ export KMP_AFFINITY="granularity=fine,verbose,compact,1,0"
c123-456$ export OMP_NUM_THREADS=46
c123-456$ ibrun -np 2 python3 tf_cnn_benchmarks.py --model resnet50 --batch_size 128 \
	--variable_update horovod --data_format NCHW --num_intra_threads 46 --num_inter_threads 2 \
	--num_batches 100
```

The parameters for this last command are defined as follows:

* `-model` specifies the neural network model
* `-batch_size` specifies the number of samples in each iteration
* `-variable_update` specifies using horovod to synchronize gradients
* `-data_format` informs TF the nested data format comes in the order of sample count, channel, height, and width
* `-num_intra_threads` specifies the number of threads used for computation within a single operation
* `-num_inter_threads` specifies the number of threads used for independent operations
* `-num_batches` specifies the total number of iterations to run

		
## [FAQ](#faq) { #faq }

Q: **I have missing Python packages when using TensorFlow. What shall I do?**  

A: Deep learning frameworks usually depend on many other packages. e.g., the [Caffe package dependency list](https://github.com/intel/caffe/blob/master/python/requirements.txt). On TACC resources, you can install these packages in user space by running:

``` cmd-line
$ pip install --user package-name
```

## [References](#refs) { #refs }

<!-- * [Maverick2 User Guide](../../hpc/maverick2) -->
* [Github: TensorFlow](https://github.com/tensorflow/tensorflow)
* [Stampede2 User Guide](../../hpc/stampede2)

{% include 'aliases.md' %}
