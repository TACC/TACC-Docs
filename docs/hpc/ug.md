# Homepage Navigation

## Choose Your Path

### New to Lonestar6?
→ Getting Started

### Need to run a CPU job?
→ Running Jobs

### Need GPUs or AI?
→ AI, GPUs, and Machine Learning

### Need interactive desktop access?
→ Visualization and Remote Computing

### Job not working?
→ Troubleshooting

### Looking for queue limits or node specs?
→ Reference
# New User Guide Organization LS6

## Getting Started

### Notices and Important Policies
- Queue restrictions
- AI usage guidance
- SU charging responsibilities

### What is Lonestar6?
- System purpose
- Supported research areas
- Partner institutions

### Allocations and Access
- Who can use Lonestar6
- Requesting allocations
- Joining a project
- Checking allocation status

### Multi-Factor Authentication

### Logging In
- SSH access
- Login nodes
- First login checklist

### Quick Start: Submit Your First Job
- Create a test script
- Submit with `sbatch`
- Monitor with `squeue`
- View output

## System Overview

### Architecture Overview

### Compute Nodes

### GPU Nodes

### Login Nodes

### Network

### Queue Summary
| Queue | Intended Use | Node Type | Max Runtime |
|---------|---------|---------|---------|

---
## Storage and Data Management

### Filesystem Overview

### HOME

### WORK / Stockyard

### SCRATCH

### Node Local Storage (`/tmp`)

### Quotas and Purge Policies

### Data Transfer
- `scp`
- `rsync`
- Globus

### Ranch Archive Storage

---
## Running Jobs

### Slurm Fundamentals

### Job Accounting

### Queue Charge Rates

### Production Queues

### Basic Job Scripts

#### Serial Jobs

#### OpenMP Jobs

#### MPI Jobs

#### Hybrid MPI/OpenMP Jobs

#### GPU Jobs

### Interactive Jobs

### Job Dependencies

### HTC and Parameter Sweeps

---
## Software and Development

### Environment Modules

### Environment Variables

### Building Software

### Intel Compilers

### GCC and Other Toolchains

### Libraries and MPI

### Python Environments

### Containers

---
## AI, GPUs, and Machine Learning

### GPU Resource Overview

### GPU Queues

### Environment Setup

### PyTorch

### Accelerate

### Single-Node Training

### Multi-Node Training

### AI Usage Policies

---
## Interactive Computing and Visualization

### Overview

### Development Queue for Interactive Work

### Remote Desktop Access

### DCV Sessions

### VNC Sessions

### OpenSWR Rendering

### Visualization Applications

---
## Monitoring and Performance

### Queue Monitoring

### `sinfo`

### `showq`

### `qlimits`

### Job Monitoring

### Understanding Pending Jobs

### Performance Best Practices

### CPU Utilization

### Memory Usage

### GPU Monitoring

---
## Troubleshooting

### Login Problems

### MFA Problems

### Allocation Problems

### Filesystem Quota Issues

### Scratch Purge Issues

### Jobs Stuck Pending

### MPI Launch Problems

### GPU Job Failures

### Common Slurm Errors

### When to Contact Support

---
## Reference

### Node Specifications

### Filesystem Specifications

### Queue Specifications

### Environment Variables Reference

### Common Commands Cheat Sheet

### Glossary

---
## Support and Community

### Help Desk

### Writing Effective Support Tickets

### User News and Status Information

---
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
