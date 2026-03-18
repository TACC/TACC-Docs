# Data Transfer at TACC
*Last update: March 16, 2026*

TACC supports two primary data transfer technologies: **SSH-based tools** (`scp`, `sftp`, rsync) and **Globus** (formerly GridFTP). All TACC systems support SSH-based transfers, and most large TACC systems also support Globus.   

All TACC systems support SSH-based transfers, and most large TACC systems also support Globus.

## Choosing a Transfer Method

In general, we'll define "small" data sets as less than 200GB and "large" datasets as greater than 200GB.

*  **Small Datasets (SSH-based tools)**: For smaller data sets, SSH-based tools are likely easier to work with.  See the [TACC SSH-based Tools Guide](./ssh.md). 
*  **Large Datasets (Globus)**: We recommend Globus when transferring or moving datasets greater than 200GB.  See the [TACC Globus Guide](./globus.md). 

When in doubt, start with SSH-based transfer as this requires the least setup, uses the TACC authentication system, and is sufficient for most users' needs.  Globus is ideal for large data transfers and in some of the workflows detailed below.  Globus uses its own authentication system and requires additional setup steps.


### Table 1. Choosing a Transfer Method { #table1 }

| Scenario | Recommended Tool |
|---|---|
| Transfer between personal laptop and TACC systems | SSH tools
| Transfer between institutions | Globus |
| Transfer between TACC systems | Shared file systems (`$WORK`) |
| Transfer many small files | `tar` + SSH or Globus |

## Common Workflows

Let's examine the most common data transfer scenarios for TACC users.  In all the following text, the term "data" can refer to anything from a single file to multiple directories.

1. [Between your laptop and TACC resources](#txf1)
1. [Between TACC HPC resources](#txf2)
1. [Between research institutions](#txf3)
1. [Between TACC HPC and storage resources](#txf4)  

### 1. Between your laptop and TACC resources { #txf1 }

Moving data from your home computer/laptop to a TACC resource is called "pushing" or "uploading" that file.  Conversely, when copying data from a TACC resource to your laptop, this is "pulling" or "downloading" data.    Note that all transfers are initiated from your laptop, not the TACC resource, since your laptop likely does not have a fixed IP address.

The following examples demonstrate transferring trivial files.  For larger datasets, see the [TACC Globus Guide](./globus.md)..

**Example A: TACC user `bjones` uploads a local file, `mylaptopfile`, to his home directory on Stampede3. **

```cmd-line
localhost$ scp mylaptopfile bjones@stampede3.tacc.utexas.edu:               # Note the "`:`" at the end of the line
```

**Example B: TACC user `bjones` downloads a file located in his home directory on Stampede3, `myTACCfile`, to his laptop.**

```cmd-line
localhost$ scp bjones@stampede3.utexas.edu:myTACCfile .	                    # Note the "`.`" at the end of the line
```

### 2. Between TACC HPC Resources { #txf2 }

Transfer files between TACC HPC resources, e.g. Stampede3 to Vista.  

If you have an allocation on more than one TACC HPC resource, and want to move a file from one home directory or another, make use of the shared `$WORK` file system.  There's no need for `scp` when both the source and destination involve subdirectories of `$STOCKYARD`. 

**Example C: copy `myfile` in my home directory on Stampede3 to my home directory on Vista.**
	
```cmd-line
stampede3$ cp myfile $WORK
stampede3$ ssh vista
vista$ mv $WORK/myfile .
vista$ exit
stampede3$ 
```

### 3. Between Institutions { #txf3 }

If you are a researcher with data located at multiple institutions, we suggest you use Globus for large data set transfers to TACC.  You will need to authenticate with your institution.  [See how to set up your TACC account to use Globus](#globus).

### 4. Backup/Transfer files between TACC HPC and TACC storage resources { #txf4 }

To backup files to TACC's Ranch archive, consult the [Ranch User Guide](https://docs.tacc.utexas.edu/hpc/corral/#transferring).  Consult the [Corral User Guide][TACCCORRALUG] for instructions on transferring between Lonestar6 and Corral.


## Third-Party Storage

### UTBox and Dropbox

UTBox and Dropbox do not support compatible transfer mechanisms.  To transfer files from one of these services:

1. Manually download the files from one of these services to your laptop
2. Using one of the SSH tools outlined in this document (e.g. `scp`, Cyberduck), upload the files from your laptop to the desired TACC resource (e.g. Stampede3, Vista).

### S3-Compatible Storage

For Google, Amazon, and any other S3-compatible storage, [the `rclone` utility](https://rclone.org/) and many other tools and libraries can be used for command-line access from TACC systems, using the S3 protocol. However, S3 transfers are not directly supported by TACC, and users are responsible for understanding how to install and operate these tools within their own accounts.

{% include 'aliases.md' %}


