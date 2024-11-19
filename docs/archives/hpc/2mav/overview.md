## System Overview { #overview }

Maverick2 hosts the following GPUs: 24 nodes each with 4 NVidia GTX 1080 Ti GPUs running in a Broadwell based compute node; four nodes each with two of NVidia V100s GPUs running in a Skylake based Dell R740 based node; and three nodes each with two NVidia P100s GPUs running in a Skylake based Dell R740 node.

### GTX Compute Nodes { #overview-computenodes }

Maverick2 hosts 24 GTX compute nodes. One GTX node is reserved for staff use, leaving 23 nodes available for general use.

#### Table 1. GTX Compute Node Specifications { #table1 }

Specification | Value
--- | ---
Model: | Super Micro X10DRG-Q Motherboard
Processor: | Intel(R) Xeon(R) CPU E5-2620 v4
Total processors per node: | 2
Total cores per processor: | 8
Total cores per node: | 16
Hardware threads per core: | 2
Hardware threads per node: | 32
Clock rate: | 2.10GHz
RAM: | 128 GB
L1/L2/L3 Cache: | 512KiB / 2MiB / 20 MiB
Local storage: | 150.0 GB (~60 GB free)
GPUs: | 4 x NVidia 1080-TI GPUs

### V100 Compute Nodes { #overview-v100 }

Maverick2 has 4 V100 compute nodes.

#### Table 2. V100 Compute Node Specifications { #table2 }

Specification | Value
--- | ---
Model: | Dell PowerEdge R740
Processor: | Xeon(R) Platinum 8160 CPU @ 2.10GHz
Total processors per node: | 2
Total cores per processor: | 24
Total cores per node: | 48
Hardware threads per core: | 2
Hardware threads per node: | 96
Clock rate: | 2.10GHz
RAM: | 192 GB
L1/L2/L3 Cache: | 1536KiB / 24576KiB / 33792KiB
Local storage: | 119.5 GB (~32 GB free)
GPUs: | 2 NVidia  V100 adapters

### P100 Compute Nodes { #overview-p100 }

Maverick2 has 3 P100 nodes.

#### Table 3. P100 Compute Node Specifications { #table3 }

Specification | Value
--- | ---
Model: | Dell PowerEdge R740
Processor: | Xeon(R) Platinum 8160 CPU @ 2.10GHz
Total processors per node: | 2
Total cores per processor: | 24
Total cores per node: | 48
Hardware threads per core: | 2
Hardware threads per node: | 96
Clock rate: | 2.10GHz
RAM: | 192 GB
L1/L2/L3 Cache: | 1536KiB / 24576KiB / 33792KiB
Local storage: | 119.5 GB (~32 GB free)
GPUs: | 2 NVidia P100 adapters

### Login Nodes { #overview-loginnodes }

Maverick2 hosts a single login node:

* Dual Socket
* Intel Xeon CPU E5-2660 v3 (Haswell) @ 2.60GHz: 10 cores/socket (20 cores/node)
* 128 GB DDR4-2133 (8 x 16GB dual rank x4 DIMMS)
* Hyperthreading Disabled

### Network { #overview-network }

* Mellanox FDR Infiniband MT27500 Family ConnectX-3 Adapter
* up to 10/40/56Gbps bandwidth and a sub-microsecond low latency
* Fat Tree Interconnect
* Intel Ethernet Controller I350 IEEE 802.3 1Gbps Adapter

### File Systems { #overview-filesystems }

Maverick2 mounts [two shared Lustre file systems](#table4) on which each user has corresponding account-specific directories `$HOME` and `$WORK`. **Unlike most TACC resources, Maverick2 does not mount a `/scratch` file system.**  Both the `/home` and `/work` file systems are available from all Maverick2 nodes; the [Stockyard-hosted `/work` file system](https://www.tacc.utexas.edu/systems/stockyard) is available on other TACC systems as well. A Lustre file system looks and acts like a single logical hard disk, but is actually a sophisticated integrated system involving many physical drives (dozens of physical drives for `$HOME` and thousands for `$WORK`).



