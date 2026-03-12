# Data Transfer at TACC
*Last update: March 12, 2026*

TACC supports two primary data transfer technologies: **SSH-based tools** (`scp`, `sftp`, rsync) and **Globus** (formerly GridFTP). All TACC systems support SSH-based transfers, and most large TACC systems also support Globus.   

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

If you are a researcher with data located at multiple institutions, we suggest you use Globus for large data set transfers to TACC.  You will need to authenticate with your institution.  [See how to set up your TACC account to use Globus](#globus).

### 4. Backup/Transfer files between TACC HPC and TACC storage resources { #txf4 }

To backup files to TACC's Ranch archive, consult the [Ranch User Guide](https://docs.tacc.utexas.edu/hpc/corral/#transferring).  Consult the [Corral User Guide][TACCCORRALUG] for instructions on transferring between Lonestar6 and Corral.

## UTBox and other Third-Party Storage Services { #datatransfer-thirdparty }

UTBox and Dropbox do not support compatible transfer mechanisms.  To transfer files from one of these services:

1. Manually download the files from one of these services to your laptop
2. Using one of the tools outlined in this document (e.g. `scp` or Cyberduck), upload the files from your laptop to the desired TACC resource (e.g. Stampede3, Vista).

For Google, Amazon, and any other S3-compatible storage, [the "`rclone`" utility](https://rclone.org/) and many other tools and libraries can be used for command-line access from TACC systems, using the S3 protocol. However, S3 transfers are not directly supported by TACC, and users are responsible for understanding how to install and operate these tools within their own accounts.

{% include 'aliases.md' %}



<!--
put this somewhere when re-organzing

## Determining Paths { #cli-paths }

Before beginning data transfer with command-line tools, you will need to know:

* the path to your data file(s) on your local system
* the path to your transfer directory on the remote system

In order to transfer your project data, you will first need to know where the files are located on your local system.

To do so, navigate to the location of the files on your computer. This can be accomplished on a Mac by using the Finder application or on Windows with File Explorer application. Common locations for user data at the user's home directory, the Desktop and My Documents.
      
Once you have identified the location of the files, you can right-click on them and select either Get Info (on Mac) or Properties (on Windows) to view the path location on your local system.
      
Figure 1. Use Get Info to determine "Where" the path of your data file(s) is

<figure id="figure1"><img src="../imgs/dtg-1-determine-path.png" /></a>
<figcaption> Figure 1. Use Get Info to determine "Where" the path of your data file(s) is</figcaption></figure>

For example, a file located in a folder named `portal-data` under `Documents` would have the following path:

<table>
<tr><td>On Mac</td><td><code>/Users/username/Documents/portal-data/my_file.txt</code></td></tr>
<tr><td>On Windows</td><td><code>\Users\username\My Documents\portal-data\my_file.txt</code></td></tr>
</table>
-->

<!--

Put these sftp instructions in later, after re-organizing

### Transfer with `sftp` { #sftp }

`sftp` is a file transfer program that allows you to interactively navigate between your local file system and the remote secure system. To transfer a file (ex. `my_file.txt`) to the remote secure system via `sftp`, open a terminal on your local computer and navigate to the path where your data file is located.
      
<table>
<tr><td>On Mac</td><td>localhost$ cd ~/Documents/portal-data/</td></tr>
<tr><td>On Windows</td><td>localhost$ cd %HOMEPATH%\Documents\portal-data\</td></tr>
</table>

For example, assume your TACC username is `bjones` and you have an allocation on Stampede3.  An `sftp` transfer that pushes `my_file.txt` from the current directory of your local computer to your home directory on TACC's Stampede3 system would look like this:
      
```cmd-line
localhost$ sftp bjones@stampede3.tacc.utexas.edu:/transfer/directory/path
Password:
TACC Token Code:
Connected to host.
Changing to:
  /transfer/directory/path
sftp>
```
      
Once you've logged into the remote secure system and have been redirected to your transfer directory, confirm your location on the server:

```cmd-line
sftp> pwd
Remote working directory:
/transfer/directory/path
```

To list the files currently in your transfer directory:

```cmd-line
sftp> ls
utaustin_dir.txt
```
      
To list the files currently in your *local* directory:
      
```cmd-line
sftp> lls
my_file.txt
```

!!! tip
	The leading `l` in the `lls` command denotes that you are listing the contents of your *local* working directory.
      
To transfer `my_file.txt` from your local computer to your transfer directory:

```cmd-line
sftp> put my_file.txt
Uploading my_file.txt to /transfer/directory/path
my_file.txt     100% ##  #.#          KB/s   ##:#
```

To double-check if the transfer succeeded: 
      

```cmd-line
sftp> ls
my_file.txt
utaustin_dir.txt
```
To exit out of `sftp` on the terminal:

```cmd-line
sftp> bye
localhost1$
```
-->
