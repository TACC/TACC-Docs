# Stampede3 User Guide 

*Last update: June 21, 2023*

## [Notices](#notices) { #notices }

* Stampede3 will be available to ACCESS researchers beginning December, 2023. (06/20/2023)
* This user guide is in progress and will be updated as the system is configured. 

## [Introduction](#intro) { #intro }

The National Science Foundation (NSF) has generously awarded the University of Texas at Austin funds for TACC's Stampede3 system ([Award Abstract # 2320757](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2320757)).  

### [Allocations](#intro-allocations) { #intro-allocations }

Stampede3 will be available to ACCESS researchers through the "Maximize" allocations, see: <https://allocations.access-ci.org/>.  



## [System Architecture](#system) { #system }

Stampede3's projected node configuration will include: 

* Intel Skylake nodes with 48 cores/node 
* Intel Ice Lake nodes with 80 cores/node 
* Intel Sapphire Rapids High Bandwidth Memory (HBM) nodes with 56 cores/node


<!--
### [Compute Nodes](#system-compute) { #system-compute }
#### [Table 1. Compute Node Specifications](#table1) { #table1 }

Specification | Value
--- | ---
CPU:   | TBD
Total cores per node:   | TBD
Hardware threads per core:   | X per core 
Hardware threads per node:   | X x Y = Z
Clock rate:   | TBD
RAM:   | TBD
Cache:   | TBD
Local storage:  | TBD

### [Login Nodes](#system-login) { #system-login }

#### [Table 2. `vm-small` Compute Node Specifications](#table15) { #table15 }

Specification | Value
--- | ---
CPU:   | <b>1/4th</b> of an AMD EPYC 7763 64-Core Processor ("Milan")
Total cores per VM:   | 16 cores
Hardware threads per core:   | 1 per core 
Hardware threads per VM:   | 16 x 1 = 16
Clock rate:   | 2.45 GHz (Boost up to 3.5 GHz)
RAM:   | 32 GB (3200 <b>shared</b> MT/s) DDR4
Cache:   | <b>Shared caches with all other VMs.</b><br>32KB L1 data cache per core<br>512KB L2 per core<br>32 MB L3 per core complex<br>(1 core complex contains 8 cores)<br>64 MB L3 total (2 core complexes)
Local storage:  | 112G <code>/tmp</code> partition


### [GPU Nodes](#system-gpu) { #system-gpu }

#### [Table 2. GPU Node Specifications](#table2) { #table2 }

Specification | Value
--- | ---
GPU:  | 3x NVIDIA A100 PCIE 40GB<br>(1 per socket )<br>gpu0:   socket 0<br>gpu1:   socket1<br>gpu2:   socket1
GPU Memory:  | 40 GB HBM2
CPU:   | 2x AMD EPYC 7763 64-Core Processor ("Milan")
Total cores per node:   | 128 cores on two sockets (64 cores / socket )
Hardware threads per core:   | 1 per core 
Hardware threads per node:   | 128 x 1 = 128
Clock rate:   | 2.45 GHz
RAM:   | 256 GB
Cache:   | 32KB L1 data cache per core<br>512KB L2 per core<br>32 MB L3 per core complex<br>(1 core complex contains 8 cores)<br>256 MB L3 total (8 core complexes )<br>Each socket can cache up to 288 MB<br>(sum of L2 and L3 capacity)
Local storage:   | 144GB /tmp partition on a 288GB SSD.

### [Network](#system-network) { #system-network }

-->
[HELPDESK]: https://tacc.utexas.edu/about/help/ "Help Desk"
[CREATETICKET]: https://tacc.utexas.edu/about/help/ "Create Support Ticket"
[TACCUSERPORTAL]: https://tacc.utexas.edu/portal/login "TACC Portal login"
[TACCPORTALLOGIN]: https://tacc.utexas.edu/portal/login "TACC Portal login"
[TACCUSAGEPOLICY]: https://tacc.utexas.edu/use-tacc/user-policies/ "TACC Usage Policy"
[TACCALLOCATIONS]: https://tacc.utexas.edu/use-tacc/allocations/ "TACC Allocations"
[TACCSUBSCRIBE]: https://accounts.tacc.utexas.edu/subscriptions "Subscribe to News"
[TACCDASHBOARD]: https://tacc.utexas.edu/portal/dashboard "TACC Dashboard"

[TACCANALYSISPORTAL]: http://tap.tacc.utexas.edu "TACC Analysis Portal"

[TACCLMOD]: https://lmod.readthedocs.io/en/latest/ "Lmod"
[DOWNLOADCYBERDUCK]: https://cyberduck.io/download/ "Download Cyberduck"


[TACCREMOTEDESKTOPACCESS]: https://docs.tacc.utexas.edu/tutorials/remotedesktopaccess "TACC Remote Desktop Access"
[TACCSHARINGPROJECTFILES]: https://docs.tacc.utexas.edu/tutorials/sharingprojectfiles "Sharing Project Files"
[TACCBASHQUICKSTART]: https://docs.tacc.utexas.edu/tutorials/bashstartup "Bash Quick Start Guide"
[TACCACCESSCONTROLLISTS]: https://docs.tacc.utexas.edu/tutorials/acls "Access Control Lists"
[TACCMFA]: https://docs.tacc.utexas.edu/basics/mfa "Multi-Factor Authentication at TACC""


