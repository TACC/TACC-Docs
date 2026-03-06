# Data Transfer

TACC supports two primary data transfer technologies: **SSH-based tools** (SCP, SFTP, rsync) and **Globus** (formerly GridFTP). All TACC systems support SSH-based transfers, and most large TACC systems also support Globus.   

## Recommendations

When in doubt, we recommend that you start with SSH-based transfer as this requires the least setup and utilizes the TACC authentication system.  Globus uses its own authentication system and will require additional setup steps. 

In general, we'll define "small" data sets as less than 200GB and "large" datasets as greater than 200GB.

*  Small Datasets (SSH-based tools): For smaller data sets, SSH-based tools are likely easier to work with.  See the [TACC SSH-based Tools Guide](datatransfer_ssh.md). 

*  Large Datasets (Globus): We recommend Globus when transferring or moving datasets greater than 200GB.  See the [TACC Globus Guide](datatransfer_globus.md). 


<!-- 
- Transferring **large datasets (>200 GB)**  
- Moving **many thousands of files**
- Transfers may take **hours**
- You need **automatic restart** after network interruptions
- You want **parallel, optimized transfers** without manual tuning
-->

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

Moving data from your home computer/laptop to a TACC resource is called "pushing" or "uploading" that file.  Conversely, when copying data from a TACC resource to your laptop, this is "pulling" or "downloading" data.    Note that all transfers are initiated from your laptop, not the TACC resource, since your laptop likely does not have a fixed IP address.

The following examples demonstrate transferring trivial files.  For large datasets, see Globus.

**Example 1: TACC account holder `bjones` uploads a local file, `mylaptopfile`, to his home directory on Stampede3. **

```cmd-line
localhost$ scp mylaptopfile bjones@stampede3.tacc.utexas.edu:
```
Note the "`:`" at the end of the line.

**Example 2: TACC account holder `bjones` downloads a file located in his home directory on Stampede3, `myTACCfile`, to his laptop.**

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

If you are a researcher with data located at multiple institutions, we highly you use Globus for large data set transfers to TACC.  You will need to authenticate with your institution.  [See how to set up your TACC account to use Globus](#globus).

### 4. Backup/Transfer files between TACC HPC and TACC storage resources { #txf4 }

To backup files to TACC's Ranch archive, consult the [Ranch User Guide](https://docs.tacc.utexas.edu/hpc/corral/#transferring).  Consult the [Corral User Guide][TACCCORRALUG] for instructions on transferring between Lonestar6 and Corral.

## UTBox and other Third-Party Storage Services { #datatransfer-thirdparty }

Unfortunately TACC does not allow direct access from UT Box or other third-party storage services such as Dropbox, Google or Amazon storage services. To transfer files from one of these services:

1. Manually download the files from one of these services to your laptop
2. Using one of the tools outlined in this document (e.g. `scp` or Cyberduck), upload the files from your laptop to the desired TACC resource (e.g. Stampede3, Frontera).
