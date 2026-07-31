# Horizon User Guide 
*Last update: July 24, 2026*

---
*This user guide is in progress*
---

## Notices { #notices }

* Horizon is still limited only to internal users. (07/24/2026)
* See the latest TACC Announcement regarding [Horizon opportunities](https://tacc.utexas.edu/news/user-updates/107622/). (04/17/2026)
* **[Subscribe][TACCSUBSCRIBE] to Horizon User News**. Stay up-to-date on Horizon's status, scheduled maintenances and other notifications.  (04/15/2026) 
{% include 'include/ai.md' %}

## Introduction { #intro }

Horizon is a National Science Foundation-funded system that is part of the the Leadership Class Computing Facility (LCCF) award, [Award Abstract #2323116](https://www.nsf.gov/awardsearch/show-award/?AWD_ID=2323116).  Please [reference TACC](https://tacc.utexas.edu/about/citing-tacc/) when providing any citations. 

### Allocations { #intro-allocations }

* NAIRR: NAIRR <https://nairrpilot.org/>
* TxRAS: Submit to opportunities, including LRAC at <https://submit-tacc.xras.org/>
* See the latest TACC Announcement regarding [Horizon opportunities](https://tacc.utexas.edu/news/user-updates/107622/). 



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
## Running Jobs { #running }

<!-- ### Slurm Job Scheduler { #running-slurm } -->

Like all other current TACC systems, Horizon employs the Slurm Workload Manager as it's job scheduler.  Slurm commands enable you to submit, manage, monitor, and control your jobs.  <!-- See the [Job Management](#jobmanagement) section below for further information. -->

### Slurm Partitions (Queues) { #queues }

!!! warning
    **Queue limits are subject to change without notice.**
    Horizon admins may occasionally adjust queue settings in order to ensure fair scheduling for the entire user community.
    TACC's `qlimits` utility will display the latest queue configurations.

<a id="queues">
#### Table 4. Production Queues { #table4 }

| Queue Name | Node Type       | Max Nodes per Job | Max Job Duration | Charge Rate (per node-hour) 
| -----      | -----           | -----             | -----            | -----                       
| `gb`       | Grace Blackwell | 128               | 48 hrs           | 1 SU 
| `gb-dev`   | Grace Blackwell | 16                | 2 hrs            | 1 SU 
| `gb-large` | Grace Blackwell | 512               | 48 hrs           | 1 SU 
| `vv`       | Vera Vera       | 256               | 48 hrs           | 0.25 SUs 
| `vv-dev`   | Vera Vera       | 32                | 2 hrs            | 0.25 SUs 
| `vv-large` | Vera Vera       | 1024              | 48 hrs           | 0.25 SUs 

Reminder: A Grace Blackwell node contains 1 Grace CPU and 2 Blackwell GPUs. 

[CREATETICKET]: https://tacc.utexas.edu/about/help/ "Create Support Ticket"
[SUBMITTICKET]: https://tacc.utexas.edu/about/help/ "Submit Support Ticket"
[HELPDESK]: https://tacc.utexas.edu/about/help/ "Help Desk"


[TACCGOODCONDUCT]: https://docs.tacc.utexas.edu/basics/conduct/ "TACC Good Conduct Guide"
[TACCSOFTWARE]: https://docs.tacc.utexas.edu/basics/software/ "Software at TACC"

[TACCDOCS]: https://docs.tacc.utexas.edu "TACC Documentation Portal"
[TACCACCESSCONTROLLISTS]: https://docs.tacc.utexas.edu/tutorials/acls "Access Control Lists"
[TACCACLS]: https://docs.tacc.utexas.edu/tutorials/acls "Manage Permissions with Access Control Lists"
[TACCBASHQUICKSTART]: https://docs.tacc.utexas.edu/tutorials/bashstartup "Bash Quick Start Guide"
[TACCIDEV]: https://docs.tacc.utexas.edu/software/idev "idev at TACC"
[TACCLMOD]: https://lmod.readthedocs.io/en/latest/ "Lmod"
[TACCMANAGINGACCOUNT]: https://docs.tacc.utexas.edu/basics/accounts "Managing your TACC Account"
[TACCMANAGINGIO]: https://docs.tacc.utexas.edu/tutorials/managingio "Managing I/O at TACC"
[TACCMANAGINGPERMISSIONS]: https://docs.tacc.utexas.edu/tutorials/permissions "Unix Group Permissions and Environment"
[TACCMFA]: https://docs.tacc.utexas.edu/basics/mfa "Multi-Factor Authentication at TACC"
[TACCPYLAUNCHER]: https://docs.tacc.utexas.edu/software/pylauncher "PyLauncher at TACC"
[TACCPARAVIEW]: https://docs.tacc.utexas.edu/software/paraview "Paraview at TACC"
[TACCREMOTEDESKTOPACCESS]: https://docs.tacc.utexas.edu/tutorials/remotedesktopaccess "TACC Remote Desktop Access"
[TACCSHARINGPROJECTFILES]: https://docs.tacc.utexas.edu/tutorials/sharingprojectfiles "Sharing Project Files"

[TACCUSERPORTAL]: https://tacc.utexas.edu/portal/login "TACC User Portal login"
[TACCDASHBOARD]: https://tacc.utexas.edu/portal/dashboard "TACC Dashboard"
[TACCPROJECTS]: https://tacc.utexas.edu/portal/projects "Projects & Allocations"

[TACCACCOUNTS]: https://accounts.tacc.utexas.edu "TACC Accounts Portal"
[TACCUSERPROFILE]: https://accounts.tacc.utexas.edu/profile "TACC Accounts User Profile"
[TACCSUBSCRIBE]: https://accounts.tacc.utexas.edu/user_updates "Subscribe to News"
[TACCLOGINSUPPORT]: https://accounts.tacc.utexas.edu/login_support "TACC Accounts Login Support Tool"

[TACCALLOCATIONS]: https://tacc.utexas.edu/use-tacc/allocations/ "TACC Allocations"
[TACCAUP]: https://tacc.utexas.edu/use-tacc/user-policies/ "TACC Acceptable Use Policy"
[TACCCITE]: https://tacc.utexas.edu/about/citing-tacc/ "Citing TACC"

[TACCSTAMPEDE3UG]: https://docs.tacc.utexas.edu/hpc/stampede3/ "TACC Stampede3 User Guide"
[TACCLONESTAR6UG]: https://docs.tacc.utexas.edu/hpc/lonestar6/ "TACC Lonestar6 User Guide"
[TACCFRONTERAUG]: https://docs.tacc.utexas.edu/hpc/frontera/ "TACC Frontera User Guide"
[TACCVISTAUG]: https://docs.tacc.utexas.edu/hpc/vista/ "TACC Vista User Guide"
[TACCHORIZONAUG]: https://docs.tacc.utexas.edu/hpc/horizon/ "TACC Horizon User Guide"
[TACCRANCHUG]: https://docs.tacc.utexas.edu/hpc/ranch/ "TACC Ranch User Guide"
[TACCCORRALUG]: https://docs.tacc.utexas.edu/hpc/corral/ "TACC Corral User Guide"
[TACCSTOCKYARD]: https://tacc.utexas.edu/systems/stockyard  "Stockyard File System"
[TACCANALYSISPORTAL]: http://tap.tacc.utexas.edu "TACC Analysis Portal"

[DOWNLOADCYBERDUCK]: https://cyberduck.io/download/ "Download Cyberduck"
[CYBERDUCK]: https://cyberduck.io "Download Cyberduck"
[TACCSOFTWARELIST]: https://tacc.utexas.edu/use-tacc/software-list/ "TACC Software List"
[TACCGAUSSIANAGREEMENT]: https://tacc.utexas.edu/taccdocs/TACC_GAUSSIAN_Usage_Agreement.pdf "TACC GAUSSIAN Usage Agreement"
