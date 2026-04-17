## System Specifications  { #system }

Developed in collaboration with Dell Technologies, NVIDIA, VAST Data, Spectra Logic, Versity, and Sabey Data Centers, the Horizon supercomputer combines cutting-edge technologies with advanced infrastructure to redefine what is possible in scientific computing.

| Specification                      | Value
| -----                              | ----- |
| Performance<br>GPU component only) | 160 petaflops (FP64 units)<br>320 petaflops (FP32 units)<p>~288 petaflops<br>(DGEMM using Ozaki method)
| AI Performance                     | 20 exaflops for AI at BF16/FP16<br>40 exaflops for AI at FP8<br>80 exaflops for AI at FP4 |
| Scale                              | NVIDIA Grace Blackwell platform featuring 4,000 GPUs and NVIDIA Vera Vera servers featuring 4752 nodes |
| Networking                         | Interconnected by the NVIDIA Quantum-x800 InfiniBand networking platform |
| Local All-Solid State Storage      | 400PB of storage delivering more than 8TB/s of read/write bandwidth along with multi-tenancy and Quality-of-Service capabilities. |
| Efficiency                         | Up to 6x more energy efficient, powered by a new 20 MW data center with advanced liquid cooling in Round Rock, Texas. |

### Grace Blackwell Compute Nodes

Horizon hosts 2,000 Grace Blackwell (GB) nodes. The Grace Blackwell (GB) subsystem consists of nodes using the GB200 NVL4 platform. The NVL4 platform is configured as 2 nodes each with 2 NVIDIA Blackwell GPUs each with 185 GiB of HBM3 memory and 1 Grace CPU with 120 GiB of LPDDR5X memory and 72 cores. 

A GB node provides 80 TFlops of FP64 performance (~160 TFlops DGEMM performance using NVML) and 20 PFlops of FP16 performance for ML workflows. The GB subsystem is housed in 28 racks, each containing 72 GB nodes. These nodes connect via an NVIDIA InfiniBand 800 Gb/s fabric to NVIDIA XDR InfiniBand switches using a fully connected two-level fat-tree topology.

#### Table 1. Grace Blackwell Specifications

| Specification | Value |
| ----- | ----- |
| GPU: | Blackwell, GB200 |
| GPU Memory: | 185 Mib |
| CPU: | NVIDIA Grace CPU |
| Total CPU cores per node: | 72 cores on one socket |
| Hardware threads per core: | 1 |
| Hardware threads per node: | 72 |
| Clock rate: | 3.4 GHz |
| Memory: | 240 GiB LPDDR |
| Cache: | 64 KB L1 data cache per core; 1MB L2 per core; 114 MB L3 |
| Local storage: | 130 GiB |
| DRAM: | LPDDR5 |

### Vera Vera Compute Nodes

#### Table 2. Vera Vera Specifications

| Specification | Value |
| ----- | ----- |
| CPU: | NVIDIA Vera CPU |
| Total cores per node: | 176 cores on two sockets (2 x 88)  |
| Hardware threads per core: | 2 (Spatial Multi-Threading) |
| Hardware threads per node: | 2 x 88 x 2 = 352 |
| Clock rate: | TBA |
| Memory: | 500 GB LPDDR |
| Cache: | TBA |
| Local storage: | 240 GB |
| DRAM: | LPDDR5 |

Horizon hosts 4752 "Vera Vera" (VV) nodes with 176 cores each. Each VV node provides a performance increase of  over 3x compared to Frontera's CLX nodes and ~2x compared to the Grace Grace nodes of Vista.  This improved performance per node is due to increase in core count, 176 vs 144, an increase in vector units per core, 6 vs 4, and an increase in memory bandwidth, 2.4 TB/s vs 1 TB/s. Each VV node provides over 13 TFlops of double precision performance and over 2 TiB/s of memory bandwidth.

### Login Nodes

The Horizon login nodes are Grace Grace (GG) nodes with 144 cores and 237 GB of LPDDR. They are compatible with the NVIDA and GNU software stacks installed for the GB and VV nodes.

### Network

The interconnect is based on Mellanox XDR technology with full XDR (800 Gb/s) connectivity between the switches and the GB GPU nodes and with XDR400 (400 Gb/s) connectivity to the VV compute nodes. A fat tree topology fully connects the compute nodes and the GPU nodes within separate trees with no over subscription within each tree.  Every GB node is fully connected using full XDR (800 Gb/s) to every other GB node.  Every VV node is fully connected using XDR400 (400 Gb/s) to every other VV node. Both sets of nodes are connected to the `$HOME` and `$SCRATCH` file systems via Infiniband.


### File Systems 

Horizon will use a shared VAST file system for the `$HOME` and `$SCRATCH` directories.

!!!  warning
	The $WORK filesystem will not be available for early users.  A `$WORK` filesystem will be made available later in 2026.  The `/tmp` partition is also available to users but is local to each node. 


#### Table 3. File Systems { #table3 }

*in progress*

| File System | Type     | Quota                               | Key Features
| -----       | -----    | -----                               | -----|
| `$HOME`    | VAST      | TBD                                 | Not intended for parallel or high−intensity file operations.<br>Backed up daily. 
| `$WORK`    | VAST      | TBD                                 | Not backed up.
| `$SCRATCH` | VAST      | no quota Overall capacity ~400 PB. | Not backed up.<br>Files are subject to purge if access time\* is more than 10 days old. See TACC's Scratch File System Purge Policy below.


{% include 'include/scratchpolicy.md' %}

---
