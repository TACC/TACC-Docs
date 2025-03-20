## System Architecture { #system }

### Ice Lake Large Memory Nodes { #system-icxlargemem }

Stampede3 hosts 3 large memory "Ice Lake" (ICX) nodes.  Access these nodes via the [`nvdimm` queue](#queues).

#### Table 1. ICX NVDIMM Specifications { #table1 }

Specification | Value
--- | ---
CPU: | Intel Xeon Platinum 8380 ("Ice Lake")
Total cores: | 80 cores on two sockets (40 cores/socket)
Hardware threads per core: | 1
Hardware threads per node: | 80
Clock rate: | 2.3 GHz nominal<br>(3.4GHz max frequency depending on instruction set and number of active cores)
RAM: | 4TB NVDIMM
Cache:  | 48KB L1 data cache per core; 1.25 MB L2 per core; 60 MB L3 per socket.<br>Each socket can cache up to 110 MB (sum of L2 and L3 capacity)
Local storage: | 280GB `/tmp` partition


### Ice Lake Compute Nodes { #system-icx }

Stampede3 hosts 224 "Ice Lake" (ICX) compute nodes.

#### Table 2. ICX Specifications { #table2 }

Specification | Value
--- | ---
CPU: | Intel Xeon Platinum 8380 ("Ice Lake")
Total cores per ICX node: | 80 cores on two sockets (40 cores/socket)
Hardware threads per core: | 1
Hardware threads per node: | 80
Clock rate: | 2.3 GHz nominal<br>(3.4GHz max frequency depending on instruction set and number of active cores)
RAM: | 256GB (3.2 GHz) DDR4
Cache: | 48KB L1 data cache per core; 1.25 MB L2 per core; 60 MB L3 per socket.<br>Each socket can cache up to 110 MB (sum of L2 and L3 capacity)
Local storage: | 200 GB `/tmp` partition


### Sapphire Rapids Compute Nodes { #system-spr }

Stampede3 hosts 560 "Sapphire Rapids" HBM (SPR) nodes with 112 cores each.  Each SPR node provides a performance increase of 2 - 3x over the SKX nodes due to increased core count and greatly increased memory bandwidth.  The available memory bandwidth per core increases by a factor of 3.5x.  Applications that were starved for memory bandwidth should exhibit improved performance close to 3x. 

#### Table 3. SPR Specifications { #table3 }

Specification | Value 
--- | ---
CPU: | Intel Xeon CPU MAX 9480 ("Sapphire Rapids HBM")
Total cores per node: | 112 cores on two sockets (2 x 56 cores)
Hardware threads per core: | 1
Hardware threads per node: | 2x56 = 112
Clock rate: | 1.9GHz
Memory: | 128 GB HBM 2e
Cache: | 48 KB L1 data cache per core; 1MB L2 per core; 112.5 MB L3 per socket.<br>Each socket can cache up to 168.5 MB (sum of L2 and L3 capacity).
Local storage: | 150 GB /tmp partition

### Ponte Vecchio Compute Nodes { #system-pvc }

Stampede3 hosts 20 nodes with four Intel Data Center GPU Max 1550s "Ponte Vecchio" (PVC) each.<br>Each PVC GPU has 128 GB of HBM2e and 128 Xe cores providing a peak performance of 4x 52 FP64 TFLOPS per node for scientific workflows and 4x 832 BF16 TFLOPS for ML workflows. 

#### Table 4. PVC Specifications { #table4 }

Specification | Value
--- | --
GPU: | 4x Intel Data Center GPU Max 1550s ("Ponte Vecchio")
GPU Memory: | 128 GB HBM 2e
CPU: | Intel Xeon Platinum 8480 ("Sapphire Rapids")
Total cores per node: | 96 cores on two sockets (2 x 48 cores)
Hardware threads per core: | 1
Hardware threads per node: | 2x48 = 96
Clock rate: | 2.0 GHz
Memory: | 512 GB DDR5
Cache: | 48 KB L1 data cache per core; 1MB L2 per core; 112.5 MB L3 per socket.<br>Each socket can cache up to 168.t MB (sum of L2 and L3 capacity).
Local storage: | 150 GB /tmp partition

### Skylake Compute Nodes { #system-skx }

Stampede3 hosts 1,060 "Skylake" (SKX) compute nodes.

#### Table 5. SKX Specifications { #table5 }

Specification | Value
--- | ---
Model: | Intel Xeon Platinum 8160 ("Skylake")
Total cores per SKX node: | 48 cores on two sockets (24 cores/socket)
Hardware threads per core: | 1
Hardware threads per node: | 48
Clock rate: | 2.1GHz nominal (1.4-3.7GHz depending on instruction set and number of active cores)
RAM: | 192GB (2.67GHz) DDR4
Cache: | 32 KB L1 data cache per core; 1 MB L2 per core; 33 MB L3 per socket.<br>Each socket can cache up to 57 MB (sum of L2 and L3 capacity).
Local storage: | 90 GB /tmp 


### Login Nodes { #system-login }

The Stampede3 login nodes are Intel Xeon Platinum 8468 "Sapphire Rapids" (SPR) nodes, each with 96 cores on two sockets (48 cores/socket) with 250 GB of DDR. 

### Network { #system-network }

The interconnect is a 100Gb/sec Omni-Path (OPA) network with a fat tree topology. There is one leaf switch for each 28-node half rack, each with 20 leaf-to-core uplinks (28/20 oversubscription) for the SKX nodes.  The ICX and SKX nodes are fully connected.  The SPR and PVC nodes are fully connected with a fat tree topology with no oversubscription. 

The SPR and PVC networks will be upgraded to use Cornelis' CN5000 Omni-Path technology in 2024.  The backbone network will also be upgraded. 

### File Systems { #system-filesystems }
 
Stampede3 will use a shared VAST file system for the `$HOME` and `$SCRATCH` directories.  **These two file systems are NOT lustre file systems and do not support setting a stripe count or stripe size**.  There are no options for the user to set.  As with Stampede2, the `$WORK` file system will also be mounted.  Unlike `$HOME` and `$SCRATCH`, the `$WORK` file system is a Lustre file system and supports the lustre `lfs` commands.  All three file systems, `$HOME`, `$SCRATCH`, and `$WORK` are available from all Stampede3 nodes.  The `/tmp` partition is also available to users but is local to each node. The `$WORK` file system is available on most other TACC HPC systems as well. 


#### Table 6. File Systems { #table6 }

File System | Quota | Key Features
--- | --- | ---
`$HOME` | 15 GB, 300,000 files | Not intended for parallel or high−intensity file operations. <br> Backed up regularly. | Not purged.  
`$WORK` | 1 TB, 3,000,000 files across all TACC systems<br>Not intended for parallel or high−intensity file operations.<br>See [Stockyard system description][TACCSTOCKYARD] for more information. | Not backed up. | Not purged.
`$SCRATCH` | no quota<br>Overall capacity ~10 PB. | Not backed up.<br>Files are subject to purge if access time* is more than 10 days old. See TACC's [Scratch File System Purge Policy](#scratchpolicy) below.


{% include 'include/corraltip.md' %}
{% include 'include/scratchpolicy.md' %}

