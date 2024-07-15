## Introduction { #intro }

Stampede2, generously funded by the National Science Foundation (NSF) through [award  ACI-1540931](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1540931), is one of the Texas Advanced Computing Center (TACC), University of Texas at Austin's flagship supercomputers. Stampede2 entered full production in the Fall 2017 as an 18-petaflop national resource that builds on the successes of the original Stampede system it replaces. The first phase of the Stampede2 rollout featured the second generation of processors based on Intel's Many Integrated Core (MIC) architecture. Stampede2's 4,200 Knights Landing (KNL) nodes represent a radical break with the first-generation Knights Corner (KNC) MIC coprocessor. Unlike the legacy KNC, a Stampede2 KNL is not a coprocessor: each 68-core KNL is a stand-alone, self-booting processor that is the sole processor in its node. Phase 2 added to Stampede2 a total of 1,736 Intel Xeon Skylake (SKX) nodes. The final phase of Stampede2 features the replacement of 448 KNL nodes with 224 Ice Lake nodes. 


## System Overview { #overview }

### KNL Compute Nodes { #overview-phase1computenodes }

Stampede2 hosts 4,200 KNL compute nodes, including 504 KNL nodes that were formerly configured as a Stampede1 sub-system.  

Each of Stampede2's KNL nodes includes 96GB of traditional DDR4 Random Access Memory (RAM). They also feature an additional 16GB of high bandwidth, on-package memory known as Multi-Channel Dynamic Random Access Memory (**MCDRAM**) that is up to four times faster than DDR4. The KNL's memory is configurable in two important ways: there are BIOS settings that determine at boot time the processor's **memory mode** and **cluster mode**. The processor's **memory mode** determines whether the fast MCDRAM operates as RAM, as direct-mapped L3 cache, or as a mixture of the two. The **cluster mode** determines the mechanisms for achieving cache coherency, which in turn determines latency: roughly speaking, this mode specifies the degree to which some memory addresses are "closer" to some cores than to others. See "[Programming and Performance: KNL](#programming-knl)" below for a top-level description of these and other available memory and cluster modes.

#### [Table 1. KNL Compute Node Specifications](#table1)   { #table1 }

Table 1. Stampede2 KNL Compute Node Specifications.

Specification | Value
--- | ---
Model:  | Intel Xeon Phi 7250 ("Knights Landing")
Total cores per KNL node:  | 68 cores on a single socket
Hardware threads per core:  | 4
Hardware threads per node:  | 68 x 4 = 272
Clock rate:  | 1.4GHz
RAM:  | 96GB DDR4 plus 16GB high-speed MCDRAM. Configurable in two important ways; see "<a href="#programming-knl">Programming and Performance: KNL</a>" for more info.
Cache:  | 32KB L1 data cache per core; 1MB L2 per two-core tile. In default config, <a href="#programming-knl-memorymodes">MCDRAM</a> operates as 16GB direct-mapped L3.
Local storage:  | All but 504 KNL nodes have a 107GB <code>/tmp</code> partition on a 200GB Solid State Drive (SSD). The 504 KNLs originally installed as the Stampede1 KNL sub-system each have a 32GB <code>/tmp</code> partition on 112GB SSDs. The latter nodes currently make up the <code>development</code>, <code>long</code> and <span style="white-space: nowrap;"><code>flat-quadrant</code></span> <a href="#running-queues">queues</a>. Size of <code>/tmp</code> partitions as of 24 Apr 2018.
	
	
### SKX Compute Nodes { #overview-skxcomputenodes }

Stampede2 hosts 1,736 SKX compute nodes.

#### Table 2. Stampede2 SKX Compute Node Specifications { #table2 }

Specification | Value
--- | ---
Model:  | Intel Xeon Platinum 8160 ("Skylake")
Total cores per SKX node:  | 48 cores on two sockets (24 cores/socket)
Hardware threads per core:  | 2
Hardware threads per node:  | 48 x 2 = 96
Clock rate:  | 2.1GHz nominal (1.4-3.7GHz depending on instruction set and number of active cores)
RAM:  | 192GB (2.67GHz) DDR4
Cache:  | 32KB L1 data cache per core; 1MB L2 per core; 33MB L3 per socket. Each socket can cache up to 57MB (sum of L2 and L3 capacity).
Local storage:  | 144GB <code>/tmp</code> partition on a 200GB SSD. Size of <code>/tmp</code> partition as of 14 Nov 2017.

### ICX Compute Nodes { #overview-icxcomputenodes }

Stampede2 hosts 224 ICX compute nodes.

#### Table 2a. Stampede2 ICX Compute Node Specifications { #table2a }

Specification | Value
--- | ---
Model:  | Intel Xeon Platinum 8380 ("Ice Lake")
Total cores per ICX node:  | 80 cores on two sockets (40 cores/socket)
Hardware threads per core:  | 2
Hardware threads per node:  | 80 x 2 = 160
Clock rate:  | 2.3 GHz nominal (3.4GHz max frequency depending on instruction set and number of active cores)
RAM:  | 256GB (3.2 GHz) DDR4
Cache:  | 48KB L1 data cache per core; 1.25 MB L2 per core; 60 MB L3 per socket. Each socket can cache up to 110 MB (sum of L2 and L3 capacity)
Local storage:  | 342 GB <code>/tmp</code> partition

### Login Nodes { #overview-loginnodes }

The Stampede2 login nodes, upgraded at the start of Phase 2, are Intel Xeon Gold 6132 (SKX) nodes, each with 28 cores on two sockets (14 cores/socket). They replace the decommissioned Broadwell login nodes used during Phase 1.

### Network { #overview-network }

The interconnect is a 100Gb/sec Intel Omni-Path (OPA) network with a fat tree topology employing six core switches. There is one leaf switch for each 28-node half rack, each with 20 leaf-to-core uplinks (28/20 oversubscription).

### File Systems Introduction { #overview-filesystems }

Stampede2 mounts three shared Lustre file systems on which each user has corresponding account-specific directories [`$HOME`, `$WORK`, and `$SCRATCH`](#files-filesystems). Each file system is available from all Stampede2 nodes; the [Stockyard-hosted work file system](https://www.tacc.utexas.edu/systems/stockyard) is available on most other TACC HPC systems as well.  See [Navigating the Shared File Systems](#files-filesystems) for detailed information as well as the [Good Conduct](../../basics/conduct#conduct-filesystems) file system guidelines. 

		
#### Table 3. Stampede2 File Systems { #table3 }

<u>File System</u> | Quota | Key Features
--- | --- | ---
<code>$HOME</code> | 10GB, 200,000 files | <b>Not intended for parallel or high-intensity file operations.</b><br>Backed up regularly.<br>Overall capacity ~1PB. Two Meta-Data Servers (MDS), four Object Storage Targets (OSTs).<br>Defaults: 1 stripe, 1MB stripe size.<br>Not purged.</br>
<code>$WORK</code> | 1TB, 3,000,000 files across all TACC systems,<br>regardless of where on the file system the files reside. | <b>Not intended for high-intensity file operations or jobs involving very large files.</b><br>On the Global Shared File System that is mounted on most TACC systems.<br>See <a href="https://www.tacc.utexas.edu/systems/stockyard">Stockyard system description</a> for more information.<br>Defaults: 1 stripe, 1MB stripe size<br>Not backed up.<br>Not purged.</br>
<code>$SCRATCH</code> | no quota | Overall capacity ~30PB. Four MDSs, 66 OSTs.<br>Defaults: 1 stripe, 1MB stripe size.<br>Not backed up.<br><b>Files are <a href="#scratchpolicy">subject to purge</a> if access time* is more than 10 days old</b>.
	

{% include 'include/scratchpolicy.md' %}


