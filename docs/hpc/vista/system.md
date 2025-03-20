## System Architecture { #system }

### Vista Topology { #system-topology }

Vista's compute system is divided into Grace-Grace and Grace-Hopper subsystems networked in two-level fat-tree topology as illustrated in Figure 1. below.

<figure><img src="../imgs/vista/vista-topology.png"> <figcaption>Figure 1. Vista Topology</figcaption></figure>

The Grace-Grace (GG) subsystem, a purely CPU-based system, is housed in four racks, each containing 64 Grace-Grace (GG) nodes. Each GG node contains 144 processing cores. A GG node provides over 7 TFlops of double precision performance and up to 1 TiB/s of memory bandwidth. GG nodes connect via an InfiniBand 200 Gb/s fabric to a top rack shelf NVIDIA Quantum-2 MQM9790 NDR switch. In total, the subsystem contains sixty-four 200 Gb/s uplinks to the NDR rack shelf switch.

The Grace-Hopper (GH) subsystem, on the other  hand,  consists of nodes using the GH200 Grace-Hopper Superchip. Each GH node contains an NVIDIA H200 GPU  with 96 GiB of HBM3 memory and a Grace CPU with 120 GiB of LPDDR5X memory and 72 cores. A GH node provides 34 TFlops of FP64 performance and 1979 TFlops of FP16 performance for ML workflows on the H200 chip. The GH subsystem is housed in 19 racks, each containing 32 Grace-Hopper (GH) nodes. These nodes connect via an NVIDIA InfiniBand 400 Gb/s fabric to the NVIDIA Quantum-2 MQM9790 NDR switch having 64 ports of 400Gb/s InfiniBand per port. There are thirty-two 400 Gb/s uplinks to the NDR rack shelf switch. The GH nodes have twice the network bandwidth of the GG nodes.

Each top rack shelf switch in all racks connects to sixteen core switches via dual-400G cables. In total, Vista contains 256 GG nodes and 600 GH nodes.   Both sets of nodes are connected with NDR fabric to two local file systems, `$HOME` and `$SCRATCH`. These are NFS-based flash file systems from VAST Data. The `$HOME` file system is designed for a small permanent storage area and is quota'd and backed up daily, while the `$SCRATCH` file system is designed for short term use from many nodes and is not quota'd but may be purged as needed. These file systems are connected to the management switch, which in turn is fully connected to the core network switches. The `$WORK` file system is a global Lustre file system connected to all of the TACC HPC resources. It is connected to Vista via LNeT routers. 

!!!tip
	See NVIDIA'S <a href="https://docs.nvidia.com/grace-perf-tuning-guide/index.html">Grace Performance Tuning Guide</a> for very detailed information on the Grace system..


### Grace Grace Compute Nodes { #system-gg }

Vista hosts 256 "Grace Grace" (GG) nodes with 144 cores each. Each GG node provides a performance increase of 1.5 - 2x over the Stampede3's CLX nodes due to increased core count and increased memory bandwidth.  Each GG node provides over 7 TFlops of double precision performance and 850 GiB/s of memory bandwidth.

#### Table 1. GG Specifications { #table1 }

Specification | Value 
--- | ---
CPU:                       | NVIDIA Grace CPU Superchip
Total cores per node:      | 144 cores on two sockets (2 x 72 cores)
Hardware threads per core: | 1
Hardware threads per node: | 2x72 = 144
Clock rate:                | 3.4 GHz
Memory:                    | 237 GB LPDDR
Cache:                     | 64 KB L1 data cache per core; 1MB L2 per core; 114 MB L3 per socket.<br>Each socket can cache up to 186 MB (sum of L2 and L3 capacity).
Local storage:             | 286 GB `/tmp` partition
DRAM:                      | LPDDR5

### Grace Hopper Compute Nodes { #system-gh }

Vista hosts 600 Grace Hopper (GH) nodes. Each GH node has one H200 GPU with 96 GB of HBM3 memory and one Grace CPU with 116 GB of LPDDR memory. The GH node provides 34 TFlops of FP64 performance and 1979 TFlops of FP16 performance for ML workflows on the H200 chip.


#### Table 2. GH Specifications { #table2 }

Specification                | Value 
---                          | ---
GPU:                         | NVIDIA H200 GPU 
GPU Memory:                  | 96 GB HBM 3
CPU:                         | NVIDIA Grace CPU
Total cores per node:        | 72 cores on one socket
Hardware threads per core:   | 1
Hardware threads per node:   | 1x48 = 72
Clock rate:                  | 3.1 GHz
Memory:                      | 116 GB DDR5
Cache:                       | 64 KB L1 data cache per core; 1MB L2 per core; 114 MB L3 per socket.<br>Each socket can cache up to 186 MB (sum of L2 and L3 capacity).
Local storage:               | 286 GB `/tmp` partition
DRAM:                        | LPDDR5

### Login Nodes { #system-login }

The Vista login nodes are NVIDIA Grace Grace (GG) nodes, each with 144 cores on two sockets (72 cores/socket) with 237 GB of LPDDR.

### Network { #system-network }

The interconnect is based on Mellanox NDR technology with full NDR (400 Gb/s) connectivity between the switches and the GH GPU nodes and with NDR200 (200 Gb/s) connectivity to the GG compute nodes. A fat tree topology connects the compute nodes and the GPU nodes within separate trees.  Both sets of nodes are connected with NDR to the `$HOME` and `$SCRATCH` file systems. 

### File Systems { #system-filesystems }

Vista will use a shared VAST file system for the `$HOME` and `$SCRATCH` directories. 

!!! important
	Vista's `$HOME` and `$SCRATCH` file systems are NOT Lustre file systems and do not support setting a stripe count or stripe size. 

As with Stampede3, the `$WORK` file system will also be mounted.  Unlike `$HOME` and `$SCRATCH`, the `$WORK` file system is a Lustre file system and supports Lustre's `lfs` commands. All three file systems, `$HOME`, `$SCRATCH`, and `$WORK` are available from all Vista nodes. The `/tmp` partition is also available to users but is local to each node. The `$WORK` file system is available on most other TACC HPC systems as well.


#### Table 3. File Systems { #table3 }

File System | Type | Quota | Key Features
---         | -- | ---   | ---
`$HOME` | VAST   | 23 GB, 500,000 files | Not intended for parallel or high−intensity file operations.<br>Backed up regularly.
`$WORK` | Lustre | 1 TB, 3,000,000 files across all TACC systems<br>Not intended for parallel or high−intensity file operations.<br>See [Stockyard system description][TACCSTOCKYARD] for more information. | Not backed up. | Not purged.
`$SCRATCH` | VAST | no quota<br>Overall capacity ~10 PB. | Not backed up.<br>Files are subject to purge if access time* is more than 10 days old. See TACC's [Scratch File System Purge Policy](#scratchpolicy) below.

{% include 'include/scratchpolicy.md' %}


