# Data Transfer

TACC supports two primary data transfer technologies: **SSH-based tools** (SCP, SFTP, rsync) and **Globus** (formerly GridFTP). All TACC systems support SSH-based transfers, and most large TACC systems also support Globus. Globus uses its own authentication system and will require additional setup steps.  When in doubt, we recommend that you start with SSH-based transfer as this requires the least setup and utilizes the TACC authentication system. Globus uses its own authentication system and will require additional setup steps, [outlined below](#globus).

There are many SSH-compatible clients across all platforms, and almost any modern SSH client will successfully interoperate with TACC systems. While we provide [examples using the Cyberduck application](#cyberduck), users are encouraged to select and utilize whichever transfer client is most familiar to them and most functional on your platform. Many SSH clients are organized to assist with specific workflows.

For SSH-based transfers, you will need two pieces of information in addition to your TACC username/password combination: the HOSTNAME of the system you are transferring to, and the PATH that you are attempting to access. Especially if you are uploading data, it is very important that you select the correct path for the resource and project - otherwise your data will be at risk of being lost or misplaced. The path may include a functional name such as /scratch/ or a resource name such as /corral/ .

<!-- Note that SSH-based transfers perform poorly on **high-latency network paths**. For large data transfers (e.g. > 200 GB) over paths with round-trip times (RTT) greater than ~10 ms (e.g. outside Texas), Globus is strongly recommended. In these environments, Globus is often **orders of magnitude faster** than `scp`, frequently achieving **100× or greater throughput improvements**.  -->

Globus-based transfers usually utilize an endpoint name (usually the name of the HPC or Storage resource you are connecting to) rather than a hostname, but you will still need to know the endpoint name, and you will always need the PATH that you are addressing, in order to successfully transfer data.

All TACC resources support SSH-based transfer, and most TACC resources support Globus-based transfer.

<!-- Globus also provides **end-to-end file-level checksum verification by default**, which is critical for ensuring data integrity during large transfers. SSH-based tools report transfer success based on transport-layer completion but **do not verify file content equivalence** at the source and destination. Unlike Globus, `scp` lacks built-in checksum verification and robust resume capabilities, making it unsuitable for validating large or irreplaceable datasets without manual checksum comparison (e.g., MD5 or SHA-256). -->

<!-- File-level checksums act as a digital fingerprint of file content. Comparing checksums before and after transfer ensures that data arrives intact and protects against silent data corruption introduced during disk I/O, staging, or wide-area network transfer. -->

As a broad generalization we'll define "small" data sets as less than 200GB and "large" datasets as greater than 200GB.

## Smaller Datasets (SSH-based tools)

For smaller data sets, SSH-based tools are likely easier to work with.  See the [TACC SSH-based Tools Guide](datatransfer_ssh.md). 

## Larger Datasets (Globus)

We recommend Globus when transferring or moving datasets larger than 200GB.:

<!-- 
- Transferring **large datasets (>200 GB)**  
- Moving **many thousands of files**
- Transfers may take **hours**
- You need **automatic restart** after network interruptions
- You want **parallel, optimized transfers** without manual tuning
-->

See the [TACC Globus Guide](datatransfer_globus.md). 

<!-- ## Performance Expectations

If you want to compare your data transfer performance to others, you can use the [TACC NetSage Portal](https://tacc.netsage.io/). For example [this page](https://tacc.netsage.io/grafana/d/-l3_u8nWl/1b22d62) shows transfer rates for Globus jobs between TACC and the rest of the world. In general, you should be able to get at least 1 Gbps transfer speeds.
-->



## Transfer Scenarios

Let's examine the most common data transfer scenarios for TACC users.  In all the following text, the term "data" can refer to anything from a single file to multiple directories.

1. [Between your laptop and TACC resources](#txf1)
1. [Between TACC HPC resources](#txf2)
1. [Between institutions](#txf3)
1. [Between TACC HPC and storage resources](#txf4)  


### 1. Transfer data between your laptop and a TACC resource { #txf1 }

Moving data from your home computer/laptop to a TACC resource is called "pushing" or "uploading" that file.  Conversely, when copying data from a TACC resource to your laptop, this is "pulling" or "downloading" data.  In the following examples, all transfers are initiated from your laptop, not the TACC resource, since your laptop likely does not have a fixed IP address.

Example 1: TACC account holder `bjones` uploads a local file, `mylaptopfile`, to his home directory on Stampede3. 

```cmd-line
localhost$ scp mylaptopfile bjones@stampede3.tacc.utexas.edu:
```
Note the "`:`" at the end of the line.

Example 2: TACC account holder `bjones` downloads a file located in his home directory on Stampede3, `myTACCfile`, to his laptop.  

```cmd-line
localhost$ scp bjones@stampede3.utexas.edu:myTACCfile .
```

### 2. Transfer files between TACC HPC resources { #txf2 }

Transfer files between TACC HPC resources, e.g. Stampede3 to Vista.  

If you have an allocation on more than one TACC HPC resource, and want to move a file from one home directory or another, make use of the shared `$WORK` file system.  There's no need for `scp` when both the source and destination involve subdirectories of `$STOCKYARD`. 

Example: copy `myfile` in my home directory on Stampede3 to my account on Vista.
	
```cmd-line
stampede3$ cp myfile $WORK
stampede3$ ssh vista
vista$ mv $WORK/myfile .
vista$ exit
stampede3$ 
```

### 3. Transfer Files Between Institutions { #txf3 }

If you are a researcher with data located at multiple institutions, we recommend you use Globus for large data set transfers to TACC.  You will need to authenticate with your institution.  [See how to set up your TACC account to use Globus](#globus).

### 4. Backup/Transfer files between TACC HPC and TACC storage resources { #txf4 }

To backup files to TACC's Ranch archive, consult the [Ranch User Guide](https://docs.tacc.utexas.edu/hpc/corral/#transferring).  Consult the [Corral User Guide][TACCCORRALUG] for instructions on transferring between Lonestar6 and Corral.

## UTBox and other Third-Party Storage Services { #datatransfer-thirdparty }

Unfortunately TACC does not allow direct access from UT Box or other third-party storage services such as Dropbox, Google or Amazon storage services. To transfer files from one of these services:

1. Manually download the files from one of these services to your laptop
2. Using one of the tools outlined in this document (e.g. `scp` or Cyberduck), upload the files from your laptop to the desired TACC resource (e.g. Stampede3, Frontera).
