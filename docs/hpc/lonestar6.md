# Lonestar6 User Guide
Last update: January 13, 2023


## [Notices](#notices) { #notices }

* **Lonestar6 has a [new queue, `vm-small`](#queues), for jobs requiring only a subset of a node's cores.** (11/11/2022) 
* **Lonestar6 will transition from the early user phase into production on Tuesday, January 11, 2022.** For our researchers who currently have access to Lonestar6, we will start charging usage against your allocation. (01/06/2002)
* TACC has transitioned to a new allocations management system for Lonestar6, and there are new Project Names. See [Sharing Project Files on TACC Systems](../../tutorials/sharingprojectfiles) to learn about managing file permissions across projects. 
* **All users: read the [Good Conduct](../../basics/conduct) section.** Lonestar6 is a shared resource and your actions can impact other users. (10/18/2021) 
* **[Subscribe][TACCSUBSCRIBE] to Lonestar6 User News**. Stay up-to-date on Lonestar6's status, scheduled maintenances and other notifications.


## [Introduction](#intro) { #intro }

Lonestar6 provides a balanced set of resources to support simulation, data analysis, visualization, and machine learning.  It is the next system in TACC's Lonestar series of high performance computing systems that are deployed specifically to support Texas researchers. Lonestar6 is funded through collaboration with TACC, the University of Texas System, Texas A&amp;M University, Texas Tech University, and the University of North Texas, as well as a number of research centers and faculty at UT-Austin, including the Oden Institute for Computational Engineering &amp; Sciences and the Center for Space Research.

The system employs Dell Servers with  AMD's highly performant Epyc Milan processor, Mellanox's HDR Infiniband technology, and 8 PB of BeeGFS based storage on Dell storage hardware.  Additionally, Lonestar6 supports GPU nodes utilizing NVIDIA's Ampere A100 GPUs to support machine learning workflows and other GPU-enabled applications.  Lonestar6 will continue to support the TACC HPC environment, providing numerical libraries, parallel applications, programming tools, and performance monitoring capabilities to the user community.

### [Allocations](#intro-allocations) { #intro-allocations }

Lonestar6 is available to researchers from all University of Texas System institutions and to our partners, Texas A&amp;M University, Texas Tech University and University of North Texas.

UT System Researchers may submit allocation requests for compute time on Lonestar6 via TACC's new [Texas Resource Allocation System](https://tacc-submit.xras.xsede.org) (TxRAS).  Consult the [Allocations](https://tacc.utexas.edu/use-tacc/allocations/) page for details.  

Researchers at our partner institutions may submit allocation requests through the links below.

* [Texas A&amp;M University](https://hprc.tamu.edu/user_services/new_user_information.html)
* [Texas Tech University](https://www.depts.ttu.edu/hpcc/about/services.php)
* [University of North Texas](https://research.unt.edu/research-services/research-computing)


## [System Architecture](#system) { #system }

All Lonestar6 nodes run Rocky 8.4 and are managed with batch services through native Slurm 20.11.8. Global storage areas are supported by an NFS file system (`$HOME`), a BeeGFS parallel file system (`$SCRATCH`), and a Lustre parallel file system (`$WORK`). Inter-node communication is supported by a Mellanox HDF Infiniband network. Also, the TACC Ranch tape archival system is available from Lonestar6.

The system is composed of 560 compute nodes and 32 GPU nodes.  The compute nodes are housed in 4 dielectric liquid coolant cabinets and ten air-cooled racks.  The air cooled racks also contain the 32 GPU nodes.  Each node has two AMD EPYC 7763 64-core processors (Milan) and 256 GB of DDR4 memory. Twenty-four of the compute nodes are reserved for development and are accessible interactively for up to two hours. Each GPU node also contains two AMD EPYC 7763 64-core processes and three NVIDIA A100 GPUs each with 40 GB of high bandwidth memory (HBM2).


### [Compute Nodes](#system-compute) { #system-compute }

Lonestar6 hosts 560 compute nodes with 5 TFlops of peak performance per node and 256 GB of DRAM.

#### [Table 1. Compute Node Specifications](#table1) { #table1 }

Specification | Value
--- | ---
CPU:   | 2x AMD EPYC 7763 64-Core Processor ("Milan")
Total cores per node:   | 128 cores on two sockets (64 cores / socket )
Hardware threads per core:   | 1 per core 
Hardware threads per node:   | 128 x 1 = 128
Clock rate:   | 2.45 GHz (Boost up to 3.5 GHz)
RAM:   | 256 GB (3200 MT/s) DDR4
Cache:   | 32KB L1 data cache per core<br>512KB L2 per core<br>32 MB L3 per core complex<br>(1 core complex contains 8 cores)<br>256 MB L3 total (8 core complexes )<br>Each socket can cache up to 288 MB<br>(sum of L2 and L3 capacity)
Local storage:  | 144GB /tmp partition on a 288GB SSD.

### [Login Nodes](#system-login) { #system-login }

Lonestar6's three login nodes, `login1`, `login2`, and `login3`, contain the same hardware and are configured similarly to the compute nodes. However, since these nodes are shared, limits are enforced on memory usage and number of processes. Please use the login nodes only for file management, compilation, and data movement. Any and all computing should be done within a batch job or an [interactive session](../../software/idev) on the compute nodes.

### [`vm-small` Queue Nodes](#system-vmsmall) { #system-vmsmall }

Lonestar6 hosts 28 `vm-small` compute nodes running on 4 physical hosts.

#### [Table 1.5. `vm-small` Compute Node Specifications](#table15) { #table15 }

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

Lonestar6 hosts **32** GPU nodes that are configured identically to the compute nodes with the addition of 3 NVIDIA A100 GPUs.  Each A100 gpu has a peak performance of 9.7 TFlops in double precision and 312 TFlops in FP16 precision using the Tensor Cores.

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

The interconnect is based on Mellanox HDR technology with full HDR (200 Gb/s) connectivity between the switches and the compute nodes. A fat tree topology employing sixteen core switches connects the compute nodes and the `$SCRATCH` file systems. There is an oversubscription of 24/16.


## [Managing Files](#files) { #files }


### [Table 3. File Systems](#files-table3) { #table3 }

File System | Quota | Key Features
--- | --- | ---
<code>$HOME</code> | 10 GB | 200,000 files<br><b>Not intended for parallel or high-intensity file operations.</b><br>NFS file system<br>Backed up regularly.<br>Overall capacity 7 TB<br>Not purged.
<code>$WORK</code> | 1 TB<br>3,000,000 files<br>Across all TACC systems | <b>Not intended for high-intensity file operations or jobs involving very large files.</b><br>Lustre file system<br>On the Global Shared File System that is mounted on most TACC systems.<br>See Stockyard system description for more information.<br>Defaults: 1 stripe, 1MB stripe size<br>Not backed up.<br>Not purged.
<code>$SCRATCH</code> | none | Overall capacity 8 PB<br>Defaults: 4 targets, 512 KB chunk size<br>Not backed up<br><b>Files are subject to purge if access time* is more than 10 days old.</b><sup><a href="#sup1">&#42;</a></sup>
<code>/tmp</code> on nodes | 288 GB | Data purged at the end of each job.<br>Access is local to the node.<br>Data in /tmp is not shared across nodes.


&#42;The operating system updates a file's access time when that file is modified on a login or compute node. Reading or executing a file/script on a login node does not update the access time, but reading or executing on a compute node does update the access time. This approach helps us distinguish between routine management tasks <u>(e.g. `tar`, `scp`)</u> and production use. Use the command `ls -ul` to view access times.

{% include 'include/scratchpolicy.md' %}

### [Navigating the Shared File Systems](#files-navigating) { #files-navigating }

Lonestar6 mounts three Lustre file systems that are shared across all nodes: the home, work, and scratch file systems. Lonestar6's startup mechanisms define corresponding account-level environment variables `$HOME`, `$SCRATCH` and `$WORK` that store the paths to directories that you own on each of these file systems. Consult the [Lonestar6 File Systems](#table3) table above for the basic characteristics of these file systems, <!--"File Operations: I/O Performance" for advice on performance issues,--> and the [Good Conduct](../../basics/conduct) document for guidance on file system etiquette.

Lonestar6's home and scratch file systems are mounted only on Lonestar6, but the work file system mounted on Lonestar6 is the Global Shared File System hosted on Stockyard. This is the same work file system that is currently available on Frontera, Stampede2 and most other TACC resources.

The `$STOCKYARD` environment variable points to the highest-level directory that you own on the Global Shared File System. The definition of the `$STOCKYARD` environment variable is of course account-specific, but you will see the same value on all TACC systems that provide access to the Global Shared File System (see [Table 3](#table3)). This directory is an excellent place to store files you want to access regularly from multiple TACC resources. 

<figure id="figure1">
[Figure 1. Stockyard Global File System](#figure1)

<img src="../../imgs/stockyard-2022.jpg">
<figcaption>Account-level directories on the <code>/work</code> file system (Global Shared File System hosted on Stockyard). Example for fictitious user `bjones`. All directories usable from all systems. Sub-directories (e.g. `stampede2`, `frontera`) exist only when you have allocations on the associated system.</figcaption></figure>

Your account-specific `$WORK` environment variable varies from system to system and is a subdirectory of `$STOCKYARD` (Figure 1). The subdirectory name corresponds to the associated TACC resource. The `$WORK` environment variable on Lonestar6 points to the `$STOCKYARD/ls6` subdirectory, a convenient location for files you use and jobs you run on Lonestar6. Remember, however, that all subdirectories contained in your `$STOCKYARD` directory are available to you from any system that mounts the file system. If you have accounts on both Lonestar6 and Stampede2, for example, the `$STOCKYARD/ls6` directory is available from your Stampede2 account, and `$STOCKYARD/stampede2` directory is available from your Lonestar6 account. Your quota and reported usage on the Global Shared File System reflects **all files** that you own on Stockyard, regardless of their actual location on the file system.

Note that resource-specific subdirectories of `$STOCKYARD` are simply convenient ways to manage your resource-specific files. You have access to any such subdirectory from any TACC resources. If you are logged into Lonestar6, for example, executing the alias `cdw` (equivalent to `cd $WORK`) will take you to the resource-specific subdirectory `$STOCKYARD/ls6`. But you can access this directory from other TACC systems as well by executing `cd $STOCKYARD/ls6`. These commands allow you to share files across TACC systems. In fact, several convenient account-level aliases make it even easier to navigate across the directories you own in the shared file systems:

#### [Table 4. Built-in Account Level Aliases](#table4) { #table4 }

Alias | Command
--- | ---
<code>cd</code> or <code>cdh</code> | <code>cd $HOME</code>
<code>cds</code> | <code>cd $SCRATCH</code>
<code>cdy</code> or <code>cdg</code> | <code>cd $STOCKYARD</code>
<code>cdw</code> | <code>cd $WORK</code>


### [Transferring your Files](#files-transferring) { #files-transferring }

#### [Transferring with `scp`](#files-transferring-scp) { #files-transferring-scp }

You can transfer files between Lonestar6 and Linux-based systems using either [`scp`](http://linux.com/learn/intro-to-linux/2017/2/how-securely-transfer-files-between-servers-scp) or [`rsync`](http://linux.com/learn/get-know-rsync). Both `scp` and `rsync` are available in the Mac Terminal app. Windows SSH clients typically include `scp`-based file transfer capabilities.

The Linux `scp` (secure copy) utility is a component of the OpenSSH suite. Assuming your Lonestar6 username is `bjones`, a simple `scp` transfer that pushes a file named `myfile` from your local Linux system to Lonestar6 `$HOME` would look like this:

```cmd-line
localhost$ scp ./myfile bjones@ls6.tacc.utexas.edu:  # note colon after net address
```

You can use wildcards, but you need to be careful about when and where you want wildcard expansion to occur. For example, to push all files ending in `.txt` from the current directory on your local machine to `/work/01234/bjones/scripts` on Lonestar6:

```cmd-line
localhost$ scp *.txt bjones@ls6.tacc.utexas.edu:/work/01234/bjones/ls6
```

To delay wildcard expansion until reaching Lonestar6, use a backslash (`\`) as an escape character before the wildcard. For example, to pull all files ending in `.txt` from `/work/01234/bjones/scripts` on Lonestar6 to the current directory on your local system:

```cmd-line
localhost$ scp bjones@ls6.tacc.utexas.edu:/work/01234/bjones/ls6/\*.txt .
```

You can of course use shell or environment variables in your calls to `scp`. For example:

```cmd-line
localhost$ destdir="/work/01234/bjones/ls6/data"
localhost$ scp ./myfile bjones@ls6.tacc.utexas.edu:$destdir
```

You can also issue `scp` commands on your local client that use Lonestar6 environment variables like `$HOME`, `$WORK`, and `$SCRATCH`. To do so, use a backslash (`\`) as an escape character before the `$`; this ensures that expansion occurs after establishing the connection to Lonestar6:

```cmd-line
localhost$ scp ./myfile bjones@ls6.tacc.utexas.edu:\$SCRATCH/data   # Note backslash
```

Avoid using `scp` for recursive transfers of directories that contain nested directories of many small files:

```cmd-line
localhost$ scp -r ./mydata     bjones@ls6.tacc.utexas.edu:\$SCRATCH  # DON'T DO THIS
```

Instead, use `tar` to create an archive of the directory, then transfer the directory as a single file:

```cmd-line
localhost$ tar cvf ./mydata.tar mydata                                  # create archive
localhost$ scp     ./mydata.tar bjones@ls6.tacc.utexas.edu:\$WORK  # transfer archive
```

#### [Transferring with `rsync`](#files-transferring-rsync) { #files-transferring-rsync }

The `rsync` (remote synchronization) utility is a great way to synchronize files that you maintain on more than one system: when you transfer files using `rsync`, the utility copies only the changed portions of individual files. As a result, `rsync` is especially efficient when you only need to update a small fraction of a large dataset. The basic syntax is similar to `scp`:

```cmd-line
localhost$ rsync       mybigfile bjones@ls6.tacc.utexas.edu:\$SCRATCH/data
localhost$ rsync -avtr mybigdir  bjones@ls6.tacc.utexas.edu:\$SCRATCH/data
```

The options on the second transfer are typical and appropriate when synching a directory: this is a <u>recursive update (`-r`)</u> with verbose (`-v`) feedback; the synchronization preserves <u>time stamps (`-t`)</u> as well as symbolic links and other meta-data (`-a`). Because `rsync` only transfers changes, recursive updates with `rsync` may be less demanding than an equivalent recursive transfer with `scp`.


### [Sharing Files with Collaborators](#files-sharing) { #files-sharing }

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems](../../tutorials/sharingprojectfiles) for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.


## [Access the System](#access) { #access }

### [Secure Shell (SSH)](#access-ssh) { #access-ssh }

The `ssh` command (SSH protocol) is the standard way to connect to Lonestar6 (**`ls6.tacc.utexas.edu`**). SSH also includes support for the file transfer utilities `scp` and `sftp`. [Wikipedia](https://en.wikipedia.org/wiki/Secure_Shell) is a good source of information on SSH. SSH is available within Linux and from the terminal app in the Mac OS. If you are using Windows, you will need an SSH client that supports the SSH-2 protocol: e.g. [Bitvise](http://www.bitvise.com), [OpenSSH](http://www.openssh.com), [PuTTY](http://www.putty.org), or [SecureCRT](https://www.vandyke.com/products/securecrt/). Initiate a session using the `ssh` command or the equivalent; from the Linux command line the launch command looks like this:

```cmd-line
localhost$ ssh username@ls6.tacc.utexas.edu
```

The above command will rotate connections across all available login nodes, `login1-login3`, and route your connection to one of them. To connect to a specific login node, use its full domain name:

```cmd-line
localhost$ ssh username@login2.ls6.tacc.utexas.edu
```

To connect with X11 support on Lonestar6 (usually required for applications with graphical user interfaces), use the `-X` or `-Y` switch:

```cmd-line
localhost$ ssh -X username@ls6.tacc.utexas.edu
```

To report a connection problem, execute the `ssh` command with the `-vvv` option and include the verbose output when submitting a help ticket.
**Do not run the `ssh-keygen` command on Lonestar6.** This command will create and configure a key pair that will interfere with the execution of job scripts in the batch system. If you do this by mistake, you can recover by renaming or deleting the `.ssh` directory located in your home directory; the system will automatically generate a new one for you when you next log into Lonestar6.

1. execute `mv .ssh dot.ssh.old` 
1. log out
1. log into Lonestar6 again

After logging in again the system will generate a properly configured key pair.

Regardless of your research workflow, <b>you'll need to master Linux basics</b> and a Linux-based text editor (e.g. `emacs`, `nano`, `gedit`, or `vi/vim`) to use the system properly. However, this user guide does not address these topics. There are numerous resources in a variety of formats that are available to help you learn Linux<!-- , SDL including some listed on the <a href="https://xortal.tacc.utexas.edu/training/course-materials">TACC</a> and training sites-->. If you encounter a term or concept in this user guide that is new to you, a quick internet search should help you resolve the matter quickly.

## [Account Administration](#admin) { #admin }

### [Check your Allocation Status](#admin-allocations) { #admin-allocations }

**You must be added to a Lonestar6 allocation in order to have access/login to Lonestar6.** The ability to log on to the TACC User Portal does NOT signify access to Lonestar6 or any TACC resource. Submit Lonestar6 allocations requests via [TACC's Resource Allocation System](https://tacc-submit.xras.xsede.org/). Continue to [manage your allocation's users][TACCALLOCATIONS] via the TACC Portal. 

### [Multi-Factor Authentication](#admin-mfa) { #admin-mfa }

Access to all TACC systems now requires Multi-Factor Authentication (MFA). You can create an MFA pairing on the TACC User Portal. After login on the portal, go to your account profile (Home->Account Profile), then click the "Manage" button under "Multi-Factor Authentication" on the right side of the page. See [Multi-Factor Authentication at TACC](../../../tutorials/mfa) for further information. 

<!-- SDL 
### [Password Management](#admin-password) { #admin-password }

Use your TACC User Portal password for direct logins to TACC resources. You can change your TACC password through the [TACC User Portal](http://xortal.tacc.utexas.edu/). Log into the portal, then select "Change Password" under the "HOME" tab. If you've forgotten your password, go to the [TACC User Portal](http://xortal.tacc.utexas.edu/) home page and select "Password Reset" under the Home tab.

-->


### [Linux Shell](#admin-shell) { #admin-shell }

The default login shell for your user account is Bash. To determine your current login shell, execute: 

```cmd-line
$ echo $SHELL
```

If you'd like to change your login shell to `csh`, `sh`, `tcsh`, or `zsh`, [submit a helpdesk ticket][HELPDESK]. The `chsh` ("change shell") command will not work on TACC systems. 

When you start a shell on Lonestar6, system-level startup files initialize your account-level environment and aliases before the system sources your own user-level startup scripts. You can use these startup scripts to customize your shell by defining your own environment variables, aliases, and functions. These scripts (e.g. `.profile` and `.bashrc`) are generally hidden files: so-called dotfiles that begin with a period, visible when you execute: `ls -a`.

Before editing your startup files, however, it's worth taking the time to understand the basics of how your shell manages startup. Bash startup behavior is very different from the simpler `csh` behavior, for example. The Bash startup sequence varies depending on how you start the shell (e.g. using `ssh` to open a login shell, executing the `bash` command to begin an interactive shell, or launching a script to start a non-interactive shell). Moreover, Bash does not automatically source your `.bashrc` when you start a login shell by using `ssh` to connect to a node. Unless you have specialized needs, however, this is undoubtedly more flexibility than you want: you will probably want your environment to be the same regardless of how you start the shell. The easiest way to achieve this is to execute `source ~/.bashrc` from your `.profile`, then put all your customizations in `.bashrc`. The system-generated default startup scripts demonstrate this approach. We recommend that you use these default files as templates.

For more information see the [Bash Users' Startup Files: Quick Start Guide](../../../tutorials/bashstartup) and other online resources that explain shell startup. To recover the originals that appear in a newly created account, execute `/usr/local/startup_scripts/install_default_scripts`.

### [Environment Variables](#admin-envvars) { #admin-envvars }

Your environment includes the environment variables and functions defined in your current shell: those initialized by the system, those you define or modify in your account-level startup scripts, and those defined or modified by the [modules](#admin-modules) that you load to configure your software environment. Be sure to distinguish between an environment variable's name (e.g. `HISTSIZE`) and its value (`$HISTSIZE`). Understand as well that a sub-shell (e.g. a script) inherits environment variables from its parent, but does not inherit ordinary shell variables or aliases. Use `export` (in Bash) or `setenv` (in `csh`) to define an environment variable.

Execute the `env` command to see the environment variables that define the way your shell and child shells behave. 

Pipe the results of `env` into `grep` to focus on specific environment variables. For example, to see all environment variables that contain the string GIT (in all caps), execute:

```cmd-line
$ env | grep GIT
```

The environment variables `PATH` and `LD_LIBRARY_PATH` are especially important. `PATH` is a colon-separated list of directory paths that determines where the system looks for your executables. `LD_LIBRARY_PATH` is a similar list that determines where the system looks for shared libraries.

{% include './include/sanitytool.md' %}

TACC's `sanitytool` module loads an account-level diagnostic package that detects common account-level issues and often walks you through the fixes. You should certainly run the package's `sanitycheck` utility when you encounter unexpected behavior. You may also want to run `sanitycheck` periodically as preventive maintenance. To run `sanitytool`'s account-level diagnostics, execute the following commands:

```cmd-line
login1$ module load sanitytool
login1$ sanitycheck
```

Execute `module help sanitytool` for more information. -->

### [Using Modules to Manage your Environment](#admin-modules) { #admin-modules }

[Lmod](https://www.tacc.utexas.edu/research-development/tacc-projects/lmod), a module system developed and maintained at TACC, makes it easy to manage your environment so you have access to the software packages and versions that you need to conduct your research. This is especially important on a system like Lonestar6 that serves thousands of users with an enormous range of needs. Loading a module amounts to choosing a specific package from among available alternatives:

```cmd-line
$ module load intel          # load the default Intel compiler v19.1.14
$ module load intel/19.1.1   # load a specific version of the Intel compiler
```

A module does its job by defining or modifying environment variables (and sometimes aliases and functions). For example, a module may prepend appropriate paths to `$PATH` and `$LD_LIBRARY_PATH` so that the system can find the executables and libraries associated with a given software package. The module creates the illusion that the system is installing software for your personal use. Unloading a module reverses these changes and creates the illusion that the system just uninstalled the software:

```cmd-line
$ module load   netcdf  # defines DDT-related env vars; modifies others
$ module unload netcdf  # undoes changes made by load
```

The module system does more, however. When you load a given module, the module system can automatically replace or deactivate modules to ensure the packages you have loaded are compatible with each other. In the example below, the module system automatically unloads one compiler when you load another, and replaces Intel-compatible versions of IMPI and FFTW3 with versions compatible with gcc:

```cmd-line
$ module load intel  # load default version of Intel compiler
$ module load fftw3  # load default version of fftw3
$ module load gcc    # change compiler
```

Lmod is automatically replacing "intel/19.0.4" with "gcc/9.1.0".

Inactive Modules:
1) python2

Due to MODULEPATH changes, the following have been reloaded:
1) fftw3/3.3.8     2) impi/19.0.4

On Lonestar6, modules generally adhere to a TACC naming convention when defining environment variables that are helpful for building and running software. For example, the `papi` module defines `TACC_PAPI_BIN` (the path to PAPI executables), `TACC_PAPI_LIB` (the path to PAPI libraries), `TACC_PAPI_INC` (the path to PAPI include files), and `TACC_PAPI_DIR` (top-level PAPI directory). After loading a module, here are some easy ways to observe its effects:

```cmd-line
$ module show netcdf   # see what this module does to your environment
$ env | grep NETCDF    # see env vars that contain the string PAPI
$ env | grep -i netcdf # case-insensitive search for 'papi' in environment
```

To see the modules you currently have loaded:

```cmd-line
$ module list
```

To see all modules that you can load right now because they are compatible with the currently loaded modules:

```cmd-line
$ module avail
```

To see all installed modules, even if they are not currently available because they are incompatible with your currently loaded modules:

```cmd-line
$ module spider   # list all modules, even those not available to load
```

To filter your search:

```cmd-line
$ module spider netcdf             # all modules with names containing 'slep'
$ module spider netcdf/3.6.3       # additional details on a specific module
```

Among other things, the latter command will tell you which modules you need to load before the module is available to load. You might also search for modules that are tagged with a keyword related to your needs (though your success here depends on the diligence of the module writers). For example:

```cmd-line
$ module keyword performance
```

You can save a collection of modules as a personal default collection that will load every time you log into Lonestar6. To do so, load the modules you want in your collection, then execute:

```cmd-line
$ module save    # save the currently loaded collection of modules 
```

Two commands make it easy to return to a known, reproducible state:

```cmd-line
$ module reset   # load the system default collection of modules
$ module restore # load your personal default collection of modules
```

On TACC systems, the command `module reset` is equivalent to `module purge; module load TACC`. It's a safer, easier way to get to a known baseline state than issuing the two commands separately.

Help text is available for both individual modules and the module system itself:

```cmd-line
$ module help swr     # show help text for software package swr
$ module help         # show help text for the module system itself
```

See [Lmod's online documentation](http://lmod.readthedocs.org) for more extensive documentation. The online documentation addresses the basics in more detail, but also covers several topics beyond the scope of the help text (e.g. writing and using your own module files).

It's safe to execute module commands in job scripts. In fact, this is a good way to write self-documenting, portable job scripts that produce reproducible results. If you use `module save` to define a personal default module collection, it's rarely necessary to execute module commands in shell startup scripts, and it can be tricky to do so safely. If you do wish to put module commands in your startup scripts, see Lonestar6's default startup scripts for a safe way to do so.


## [Building Software](#building) { #building }

The phrase "building software" is a common way to describe the process of producing a machine-readable executable file from source files written in C, Fortran, or some other programming language. In its simplest form, building software involves a simple, one-line call or short shell script that invokes a compiler. More typically, the process leverages the power of <a href="http://www.gnu.org/software/make/manual/make.html">makefiles</a>, so you can change a line or two in the source code, then rebuild in a systematic way only the components affected by the change. Increasingly, however, the build process is a sophisticated multi-step automated workflow managed by a special framework like <a href="http://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html">autotools</a> or <a href="http://cmake.org"><code>cmake</code></a>, intended to achieve a repeatable, maintainable, portable mechanism for installing software across a wide range of target platforms.</p>

### [Basics of Building Software](#building-basics) { #building-basics }

This section of the user guide does nothing more than introduce the big ideas with simple one-line examples. You will undoubtedly want to explore these concepts more deeply using online resources. You will quickly outgrow the examples here. We recommend that you master the basics of makefiles as quickly as possible: even the simplest computational research project will benefit enormously from the power and flexibility of a makefile-based build process.

### [Intel Compilers](#building-intelcompiler) { #building-intelcompiler }

Intel is the recommended and default compiler suite on Lonestar6. Each Intel module also gives you direct access to `mkl` without loading an `mkl` module; see [Intel MKL](#the-intel-math-kernel-library-mkl) for more information. Here are simple examples that use the Intel compiler to build an executable from source code:

Compiling a code that uses OpenMP would look like this:

```cmd-line
$ icc -qopenmp mycode.c -o myexe  # OpenMP
```

See the published Intel documentation, available both [online](http://software.intel.com/en-us/intel-software-technical-documentation) and in `${TACC_INTEL_DIR}/documentation`, for information on optimization flags and other Intel compiler options.

### [GNU Compilers](#building-gnucompilers) { #building-gnucompilers }

The GNU foundation maintains a number of high quality compilers, including a compiler for C (`gcc`), C++ (`g++`), and Fortran (`gfortran`). The `gcc` compiler is the foundation underneath all three, and the term `gcc` often means the suite of these three GNU compilers.

Load a `gcc` module to access a recent version of the GNU compiler suite. Avoid using the GNU compilers that are available without a `gcc` module &mdash; those will be older versions based on the "system gcc" that comes as part of the Linux distribution.

Here are simple examples that use the GNU compilers to produce an executable from source code:

```cmd-line
$ gcc mycode.c                    # C source file; executable a.out
$ gcc mycode.c          -o myexe  # C source file; executable myexe
$ g++ mycode.cpp        -o myexe  # C++ source file
$ gfortran mycode.f90   -o myexe  # Fortran90 source file
$ gcc -fopenmp mycode.c -o myexe  # OpenMP; GNU flag is different than Intel
```

Note that some compiler options are the same for both Intel and GNU <u>(e.g. `-o`)</u>, while others are different (e.g. `-qopenmp` vs `-fopenmp`). Many options are available in one compiler suite but not the other. See the [online GNU documentation](https://gcc.gnu.org/onlinedocs/) for information on optimization flags and other GNU compiler options.

### [Compiling and Linking as Separate Steps](#building-compiling) { #building-compiling }

Building an executable requires two separate steps: (1) compiling (generating a binary object file associated with each source file); and (2) linking (combining those object files into a single executable file that also specifies the libraries that executable needs). The examples in the previous section accomplish these two steps in a single call to the compiler. When building more sophisticated applications or libraries, however, it is often necessary or helpful to accomplish these two steps separately.

Use the `-c` ("compile") flag to produce object files from source files:

```cmd-line
$ icc -c main.c calc.c results.c
```

Barring errors, this command will produce object files `main.o`, `calc.o`, and `results.o`. Syntax for other compilers Intel and GNU compilers is similar.

You can now link the object files to produce an executable file:

```cmd-line
$ icc main.o calc.o results.o -o myexe
```

The compiler calls a linker utility (usually `/bin/ld`) to accomplish this task. Again, syntax for other compilers is similar.

### [Include and Library Paths](#building-include) { #building-include }

Software often depends on pre-compiled binaries called libraries. When this is true, compiling usually requires using the `-I` option to specify paths to so-called header or include files that define interfaces to the procedures and data in those libraries. Similarly, linking often requires using the `-L` option to specify paths to the libraries themselves. Typical compile and link lines might look like this:

```cmd-line
$ icc        -c main.c -I${WORK}/mylib/inc -I${TACC_HDF5_INC}                  # compile
$ icc main.o -o myexe  -L${WORK}/mylib/lib -L${TACC_HDF5_LIB} -lmylib -lhdf5   # link
```

On Lonestar6, both the `hdf5` and `phdf5` modules define the environment variables `$TACC_HDF5_INC` and `$TACC_HDF5_LIB`. Other module files define similar environment variables; see [Using Modules](#admin-modules) for more information.

The details of the linking process vary, and order sometimes matters. Much depends on the type of library: static (`.a` suffix; library's binary code becomes part of executable image at link time) versus dynamically-linked shared (.so suffix; library's binary code is not part of executable; it's located and loaded into memory at run time). The link line can use rpath to store in the executable an explicit path to a shared library. In general, however, the `LD_LIBRARY_PATH` environment variable specifies the search path for dynamic libraries. For software installed at the system-level, TACC's modules generally modify `LD_LIBRARY_PATH` automatically. To see whether and how an executable named `myexe` resolves dependencies on dynamically linked libraries, execute `ldd myexe`.

A separate section below addresses the [Intel Math Kernel Library](#the-intel-math-kernel-library-mkl) (MKL).

### [Compiling and Linking MPI Programs](#building-mpi) { #building-mpi }

Intel MPI (module `impi`) and MVAPICH2 (module `mvapich2`) are the two MPI libraries available on Lonestar6. After loading an `impi` or `mvapich2` module, compile and/or link using an mpi wrapper (`mpicc`, `mpicxx`, `mpif90`) in place of the compiler:

```cmd-line
$ mpicc    mycode.c   -o myexe   # C source, full build
$ mpicc -c mycode.c              # C source, compile without linking
$ mpicxx   mycode.cpp -o myexe   # C++ source, full build
$ mpif90   mycode.f90 -o myexe   # Fortran source, full build
```

These wrappers call the compiler with the options, include paths, and libraries necessary to produce an MPI executable using the MPI module you're using. To see the effect of a given wrapper, call it with the `-show` option:

```cmd-line
$ mpicc -show  # Show compile line generated by call to mpicc; similarly for other wrappers
```


### [Building Third-Party Software](#building-thirdparty) { #building-thirdparty }

You can discover already installed software using TACC's [Software Search](https://www.tacc.utexas.edu/systems/software) tool or execute `module spider` or `module avail` on the command-line.

You're welcome to download third-party research software and install it in your own account. In most cases you'll want to download the source code and build the software so it's compatible with the Lonestar6 software environment. You can't use yum or any other installation process that requires elevated privileges, but this is almost never necessary. The key is to specify an installation directory for which you have write permissions. Details vary; you should consult the package's documentation and be prepared to experiment. When using the famous [three-step autotools](http://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html) build process, the standard approach is to use the `PREFIX` environment variable to specify a non-default, user-owned installation directory at the time you execute `configure` or `make`:

```cmd-line
$ export INSTALLDIR=$WORK/apps/t3pio
$ ./configure --prefix=$INSTALLDIR
$ make
$ make install
```

Other languages, frameworks, and build systems generally have equivalent mechanisms for installing software in user space. In most cases a web search like "Python Linux install local" will get you the information you need.

In Python, a local install will resemble one of the following examples:

```cmd-line
$ pip3 install netCDF4      --user                  # install netCDF4 package to $HOME/.local
$ python3 setup.py install --user                   # install to $HOME/.local
$ pip3 install netCDF4     --prefix=$INSTALLDIR     # custom location; add to PYTHONPATH
```

Similarly in R:

```cmd-line
$ module load Rstats            # load TACC's default R
$ R                             # launch R
> install.packages('devtools')  # R will prompt for install location
```

You may, of course, need to customize the build process in other ways. It's likely, for example, that you'll need to edit a `makefile` or other build artifacts to specify Lonestar6-specific [include and library paths](#include-and-library-paths) or other compiler settings. A good way to proceed is to write a shell script that implements the entire process: definitions of environment variables, module commands, and calls to the build utilities. Include `echo` statements with appropriate diagnostics. Run the script until you encounter an error. Research and fix the current problem. Document your experience in the script itself; including dead-ends, alternatives, and lessons learned. Re-run the script to get to the next error, then repeat until done. When you're finished, you'll have a repeatable process that you can archive until it's time to update the software or move to a new machine.

If you wish to share a software package with collaborators, you may need to modify file permissions. See [Sharing Files with Collaborators](../../tutorials/sharingprojectfiles) for more information.

{% include "include/lonestar6-mkl.md" %}

## [Launching Applications](#launching) { #launching }

The primary purpose of your job script is to launch your research application. How you do so depends on several factors, especially (1) the type of application (e.g. MPI, OpenMP, serial), and (2) what you're trying to accomplish (e.g. launch a single instance, complete several steps in a workflow, run several applications simultaneously within the same job). While there are many possibilities, your own job script will probably include a launch line that is a variation of one of the examples described in this section.</p>

### [One Serial Application](#launching-serial) { #launching-serial }

To launch a serial application, simply call the executable. Specify the path to the executable in either the PATH environment variable or in the call to the executable itself:

```job-script
myprogram								# executable in a directory listed in $PATH
$SCRATCH/apps/mydir/myprogram			# explicit full path to executable
./myprogram								# executable in current directory
./myprogram -m -k 6 input1				# executable with notional input options
```

### [Parametric Sweep / HTC jobs](#launching-parametric) { #launching-parametric }

Consult the [Launcher at TACC](/software/launcher) documentation for instructions on running parameter sweep and other High Throughput Computing workflows.


### [One Multi-Threaded Application](#launching-multithreaded) { #launching-multithreaded }

Launch a threaded application the same way. Be sure to specify the number of threads. Note that the default OpenMP thread count is 1.

```job-script
export OMP_NUM_THREADS=128   	# 128 total OpenMP threads (1 per core)
./myprogram
```

### [One MPI Application](#launching-mpi) { #launching-mpi }

To launch an MPI application, use the TACC-specific MPI launcher `ibrun`, which is a Lonestar6-aware replacement for generic MPI launchers like `mpirun` and `mpiexec`. In most cases the only arguments you need are the name of your executable followed by any arguments your executable needs. When you call `ibrun` without other arguments, your Slurm `#SBATCH` directives will determine the number of ranks (MPI tasks) and number of nodes on which your program runs.

```job-script
#SBATCH -N 4				
#SBATCH -n 512

# ibrun uses the $SBATCH directives to properly allocate nodes and tasks
ibrun ./myprogram				
```

To use `ibrun` interactively, say within an `idev` session, you can specify:

```job-script
login1$ idev -N 2 -n 100
c309-005$ ibrun ./myprogram
```

### [One Hybrid (MPI+Threads) Application](#launching-hybrid) { #launching-hybrid }

When launching a single application you generally don't need to worry about affinity: both Intel MPI and MVAPICH2 will distribute and pin tasks and threads in a sensible way.

```job-script
export OMP_NUM_THREADS=8    # 8 OpenMP threads per MPI rank
ibrun ./myprogram           # use ibrun instead of mpirun or mpiexec
```

As a practical guideline, the product of `$OMP_NUM_THREADS` and the maximum number of MPI processes per node should not be greater than total number of cores available per node (128 cores in the `development`/`normal`/`large` [queues](#queues)).


### [More Than One Serial Application in the Same Job](#launching-serialmorethanone) { #launching-serialmorethanone }

TACC's `launcher` utility provides an easy way to launch more than one serial application in a single job. This is a great way to engage in a popular form of High Throughput Computing: running parameter sweeps (one serial application against many different input datasets) on several nodes simultaneously. The launcher utility will execute your specified list of independent serial commands, distributing the tasks evenly, pinning them to specific cores, and scheduling them to keep cores busy. Execute `module load launcher` followed by `module help launcher` for more information.

### [MPI Applications One at a Time](#launching-mpioneatatime) { #launching-mpioneatatime }

To run one MPI application after another (or any sequence of commands one at a time), simply list them in your job script in the order in which you'd like them to execute. When one application/command completes, the next one will begin.

```job-script
./preprocess.sh
ibrun ./myprogram input1    # runs after preprocess.sh completes
ibrun ./myprogram input2    # runs after previous MPI app completes
```

### [More Than One MPI Application Running Concurrently](#launching-mpiconcurrent) { #launching-mpiconcurrent }

To run more than one MPI application simultaneously in the same job, you need to do several things:

* use ampersands to launch each instance in the background;
* include a wait command to pause the job script until the background tasks complete;
* use `ibrun`'s `-n` and `-o` switches to specify task counts and hostlist offsets respectively; and
* include a call to the `task_affinity` script in your `ibrun` launch line.

If, for example, you use `#SBATCH` directives to request N=4 nodes and n=256 total MPI tasks, Slurm will generate a hostfile with 256 entries (64 entries for each of 4 nodes). The `-n` and `-o` switches, which must be used together, determine which hostfile entries ibrun uses to launch a given application; execute `ibrun --help` for more information. Don't forget the ampersands ("&") to launch the jobs in the background, and the `wait` command to pause the script until the background tasks complete:

```job-script
# 128 tasks; offset by  0 entries in hostfile.
ibrun -n 128 -o  0 task_affinity ./myprogram input1 &   

# 128 tasks; offset by 128 entries in hostfile.
ibrun -n 128 -o 128 task_affinity ./myprogram input2 &   

# Required; else script will exit immediately.
wait
```

The `task_affinity` script manages task placement and memory pinning when you call ibrun with the `-n`, `-o` switches (it's not necessary under any other circumstances). 

### [More than One OpenMP Application Running Concurrently](#launching-openmpconcurrent) { #launching-openmpconcurrent }

You can also run more than one OpenMP application simultaneously on a single node, but you will need to distribute and pin OpenMP threads appropriately. The most portable way to do this is with OpenMP Affinity.

An OpenMP executable sequentially assigns its `N` forked threads (thread number `0,...N-1`) at a parallel region to the sequence of "places" listed in the `$OMP_PLACES` environment variable. Each place is specified within braces ({}). The sequence `{0,1},{2,3},{4,5}` has three places, and OpenMP thread numbers `0`, `1`, and `2` are assigned to the processor ids (proc-ids) `0,1` and `2,3` and `4,5`, respectively. The hardware assigned to the proc-ids can be found in the `/proc/cpuinfo` file.

The sequence of proc-ids on socket 0 and socket 1 are sequentially numbered.  

On socket 0:

``` syntax
0,1,2,...,62,63 
```

and on socket 1:

``` syntax
64,65,...,126,127
```

Note, hardware threads are not enabled on Lonestar6.  So, there are no core ids greater than 127.

The proc-id mapping to the cores for Milan is:

``` syntax
|------- Socket 0 ------------|-------- Socket 1 -------------|
#   0   1   2,..., 61, 62, 63 |  0   1   2,...,  61,  62,  63 |
0   0   1   2,..., 61, 62, 63 | 64  65  66,..., 125, 126, 127 |
```

Hence, to bind OpenMP threads to a sequence of 3 cores on each socket, the places would be:

```job-script
socket 0:  export OMP_PLACES="{0},{1},{2}"
socket 1:  export OMP_PLACES="{64},{65},{66}"
```

Under the NUMA covers, each AMD chip is actually composed of 8 "chiplets" which share a 32 MB L3 cache.  To place each thread on its own chiplet for an 8 thread OpenMP program, you would use this command:

```job-script
socket 0:  export OMP_PLACES="{0},{8},{16},{24},{32},{40},{48},{56}"
socket 1:  export OMP_PLACES="{64},{72},{80},{88},{96},{104},{112},{120}"
```

Interval notation can be used to express a sequence of places. The syntax is: {proc-ids},N,S, where N is the number of places to create from the base place ({proc-ids}) with a stride of S. Hence the above sequences could have been written:

```job-script
socket 0:  export OMP_PLACES="{0},8,8"
socket 1:  export OMP_PLACES="{64},8,8"
```

In the example below two OpenMP programs are executed on a single node, each using 64 threads. The first program uses the cores on socket 0. It is put in the background, using the ampersand (&amp;) character at the end of the line, so that the job script execution can continue to the second OpenMP program execution, which uses the cores on socket 1. It, too, is put in the background, and the job execution waits for both to finish with the wait command at the end.

```job-script
export OMP_NUM_THREADS=64
env OMP_PLACES="{0},64,1" ./omp.exe &    #execution on socket 0 cores
env OMP_PLACES="{64},64,1" ./omp.exe &   #execution on socket 1 cores
wait
```

## [Running Jobs](#running) { #running }

This section provides an overview of how compute jobs are charged to allocations and describes the **S**imple **L**inux **U**tility for **R**esource **M**anagement (Slurm) batch environment, Lonestar6 queue structure, lists basic Slurm job control and monitoring commands along with options.

{% include 'include/lonestar6-jobaccounting.md' %}

### [Production Queues](#queues) { #queues }

Lonestar6's new queue, `vm-small` is designed for users who only need a subset of a node's entire 128 cores in the "normal" queue.  Run your jobs in this queue if your job requires 16 cores or less and needs less than 29 GB of memory.  If your job is memory bandwidth dependent, your performance may decrease since your job will be possibly sharing memory bandwidth with other jobs.  

The jobs in this queue consume 1/7 the resources of a full node.  Jobs are charged accordingly at .143 SUs per node hour.

#### [Table 5. Production Queues](#table5) { #table5 }

**Queue limits are subject to change without notice.**  Use TACC's `qlimits` utility to see the latest configuration.

Queue Name | Min/Max Nodes per Job<br /> (assoc'd cores)&#42; | Max Job Duration | Max Nodes<br> per User | Max Jobs<br> per User | Charge Rate<br /><u>(per node-hour)</u>
--- | --- | --- | --- | --- | ---
<code>development</code> | 4 nodes<br>(512 cores) | 2 hours | 6 | 1 | 1 SU
<code>gpu-a100</code> | 16 nodes<br>(2048 cores) | 48 hours | 16 | 8 | 4 SUs
<code>large</code><sup>&#42;</sup> | 65/256 nodes<br>(65536 cores) | 48 hours | 256 | 1 | 1 SU
<code>normal</code> | 1/64 nodes<br>(8192 cores) | 48 hours | 96 | 15 | 1 SU
<code>vm-small</code><sup>&#42;&#42;</sup> | 1/1 node<br>(16 cores) | 48 hours | 4 | 4 | 0.143 SU

&#42; Access to the `large` queue is restricted. To request more nodes than are available in the normal queue, submit a consulting (help desk) ticket through the TACC User Portal. Include in your request reasonable evidence of your readiness to run under the conditions you're requesting. In most cases this should include your own strong or weak scaling results from Lonestar6.

&#42;&#42; The `vm-small` queue contains virtual nodes with fewer resources (cores) than the nodes in the other queues.



## [Sample Job Scripts](#scripts) { #scripts }

Copy and customize the following scripts to specify and refine your job's requirements.</p>

* specify the maximum run time with the `-t` option. 
* specify number of nodes needed with the `-N` option
* specify tasks per node with the `-n` option
* specify the project to be charged with the `-A` option.

In general, the fewer resources (nodes) you specify in your batch script, the less time your job will wait in the queue. See [5. Job Submissions Tips](../../basics/conduct#conduct-jobs) in the [Good Conduct](../../basics/conduct) document. 

Consult [Table 6](../stampede2#table6) in the [Stampede2 User Guide](../stampede2) for a listing of common Slurm `#SBATCH` options.

Click on a tab header below to display it's job script, then copy and customize to suit your own application.

/// tab | Serial Jobs
Serial Jobs

Serial codes should request 1 node (`#SBATCH -N 1`) with 1 task (`#SBATCH -n 1`). 
  
!!! important 
	Run all serial jobs in the `normal` queue.

Consult the <a href="../../tutorials/launcher">Launcher at TACC</a> documentation to run multiple serial executables at one time.

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Lonestar6 AMD Milan nodes
#
#   *** Serial Job in Normal Queue***
# 
# Last revised: October 22, 2021
#
# Notes:
#
#  -- Copy/edit this script as desired.  Launch by executing
#     "sbatch milan.serial.slurm" on a Lonestar6 login node.
#
#  -- Serial codes run on a single node (upper case N = 1).
#       A serial code ignores the value of lower case n,
#       but slurm needs a plausible value to schedule the job.
#
#  -- Use TACC's launcher utility to run multiple serial 
#       executables at the same time, execute "module load launcher" 
#       followed by "module help launcher".
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=username@tacc.utexas.edu

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Launch serial code...
./myprogram         # Do not use ibrun or any other MPI launcher
```
///

/// tab | MPI Jobs
MPI Jobs

This job script requests 4 nodes (`#SBATCH -N 4`) and 32 tasks (`#SBATCH -n 32`), for 8 MPI rasks per node.  

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Lonestar6 AMD Milan nodes
#
#   *** MPI Job in Normal Queue ***
# 
# Last revised: October 22, 2021
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch milan.mpi.slurm" on a Lonestar6 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do NOT use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per Milan node: 128
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      fewer tasks per node to give each task more memory.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 4               # Total # of nodes 
#SBATCH -n 32              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=username@tacc.utexas.edu

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Launch MPI code... 
ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec
```


///
/// tab | OpenMP Jobs
OpenMP Jobs

!!! important
	Run all OpenMP jobs in the `normal` queue.  

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Lonestar6 AMD Milan nodes
#
#   *** OpenMP Job in Normal Queue ***
# 
# Last revised: October 22, 2021
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch milan.openmp.slurm" on a Lonestar6 login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 56 (1 thread per core) but may be higher.
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for OpenMP)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for OpenMP)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH -A myproject       # Project/Allocation name (req'd if you have more than 1)

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Set thread count (default value is 1)...
export OMP_NUM_THREADS=56   # this is 1 thread/core; may want to start lower

# Launch OpenMP code...
./myprogram         # Do not use ibrun or any other MPI launcher
```

///
/// tab | Hybrid (MPI + OpenMP) Job
Hybrid (MPI + OpenMP) Jobs

This script requests 10 nodes (`#SBATCH -N 10`) and 40 tasks (`#SBATCH -n 40`).  

``` job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script
# for TACC Lonestar6 AMD Milan nodes
#
#   *** Hybrid Job in Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         14 OpenMP threads per MPI task (56 threads per node)
#
# Last revised: October 22, 2021
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch milan.hybrid.slurm" on Lonestar6 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do NOT use mpirun or mpiexec.
#
#   -- In most cases it's best to keep
#      ( MPI ranks per node ) x ( threads per rank )
#      to a number no more than 56 (total cores).
#
#   -- If you're running out of memory, try running
#      fewer tasks and/or threads per node to give each 
#      process access to more memory.
#
#   -- IMPI does sensible process pinning by default.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 10              # Total # of nodes 
#SBATCH -n 40              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=username@tacc.utexas.edu

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Set thread count (default value is 1)...
export OMP_NUM_THREADS=14

# Launch MPI code... 
ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec
```

///

## [Job Management](#jobs) { #jobs }

In this section, we present several Slurm commands and other utilities that are available to help you plan and track your job submissions as well as check the status of the Slurm queues.

When interpreting queue and job status, remember that **Lonestar6 doesn't operate on a first-come-first-served basis**. Instead, the sophisticated, tunable algorithms built into Slurm attempt to keep the system busy, while scheduling jobs in a way that is as fair as possible to everyone. At times this means leaving nodes idle ("draining the queue") to make room for a large job that would otherwise never run. It also means considering each user's "fair share", scheduling jobs so that those who haven't run jobs recently may have a slightly higher priority than those who have.

### [Monitoring Queue Status](#jobs-monitoring) { #jobs-monitoring }

#### [TACC's `qlimits` command](#jobs-monitoring-qlimits) { #jobs-monitoring-qlimits }

To display resource limits for the Lonestar queues, execute: `qlimits`. The result is real-time data; the corresponding information in this document's [table of Lonestar6 queues](#running-queues) may lag behind the actual configuration that the `qlimits` utility displays.

#### [Slurm's `sinfo` command](#jobs-monitoring-sinfo) { #jobs-monitoring-sinfo }

Slurm's `sinfo` command allows you to monitor the status of the queues. If you execute `sinfo` without arguments, you'll see a list of every node in the system together with its status. To skip the node list and produce a tight, alphabetized summary of the available queues and their status, execute:

```cmd-line
login1$ sinfo -S+P -o "%18P %8a %20F"    # compact summary of queue status
```

An excerpt from this command's output might look like this:

```cmd-line
login1$ sinfo -S+P -o "%18P %8a %20F"
PARTITION          AVAIL    NODES(A/I/O/T)    
development        up       0/8/0/8
v100               up       44/43/1/96          
v100-lm            up       0/8/0/8
```
	
The `AVAIL` column displays the overall status of each queue (up or down), while the column labeled `NODES(A/I/O/T)` shows the number of nodes in each of several states ("**A**llocated", "**I**dle", "**O**ffline", and "**T**otal"). Execute `man sinfo` for more information. Use caution when reading the generic documentation, however: some available fields are not meaningful or are misleading on Lonestar6 (e.g. `TIMELIMIT`, displayed using the `%l` option).

### [Monitoring Job Status](#jobs-monitoring-jobstatus) { #jobs-monitoring-jobstatus }

#### [Slurm's `squeue` command](#sjobs-monitoring-queuestatus) { #sjobs-monitoring-queuestatus }

Slurm's `squeue` command allows you to monitor jobs in the queues, whether pending (waiting) or currently running:

```cmd-line
login1$ squeue             # show all jobs in all queues
login1$ squeue -u bjones   # show all jobs owned by bjones
login1$ man squeue         # more info
```

An excerpt from the default output might look like this:

```cmd-line
 JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
25781 development idv72397   bjones CG       9:36      2 c001-011,012
25918 development ppm_4828   bjones PD       0:00     20 (Resources)
25915 development MV2-test    siliu PD       0:00     14 (Priority)
25589        v100   aatest slindsey PD       0:00      8 (Dependency)
25949 development psdns_la sniffjck PD       0:00      2 (Priority)
25618        v100   SP256U   connor PD       0:00      1 (Dependency)
25944        v100  MoTi_hi   wchung  R      35:13      1 c005-003
25945        v100 WTi_hi_e   wchung  R      27:11      1 c006-001
25606        v100   trainA   jackhu  R   23:28:28      1 c008-012
```

The column labeled `ST` displays each job's status: 

* `PD` means "Pending" (waiting); 
* `R`  means "Running";
* `CG` means "Completing" (cleaning up after exiting the job script).

Pending jobs appear in order of decreasing priority. The last column includes a nodelist for running/completing jobs, or a reason for pending jobs. If you submit a job before a scheduled system maintenance period, and the job cannot complete before the maintenance begins, your job will run when the maintenance/reservation concludes. The `squeue` command will report `ReqNodeNotAvailable` ("Required Node Not Available"). The job will remain in the `PD` state until Lonestar6 returns to production.

The default format for `squeue` now reports total nodes associated with a job rather than cores, tasks, or hardware threads. One reason for this change is clarity: the operating system sees each compute node's 56 hardware threads as "processors", and output based on that information can be ambiguous or otherwise difficult to interpret. 

The default format lists all nodes assigned to displayed jobs; this can make the output difficult to read. A handy variation that suppresses the nodelist is:

```cmd-line
login1$ squeue -o "%.10i %.12P %.12j %.9u %.2t %.9M %.6D"  # suppress nodelist
```

The `--start` option displays job start times, including very rough estimates for the expected start times of some pending jobs that are relatively high in the queue:

```cmd-line
login1$ squeue --start -j 167635     # display estimated start time for job 167635
```

#### [TACC's `showq` utility](#jobs-monitoring-showq) { #jobs-monitoring-showq }

TACC's `showq` utility mimics a tool that originated in the PBS project, and serves as a popular alternative to the Slurm `squeue` command:

```cmd-line
login1$ showq                 # show all jobs; default format
login1$ showq -u              # show your own jobs
login1$ showq -U bjones       # show jobs associated with user bjones
login1$ showq -h              # more info
```

The output groups jobs in four categories: `ACTIVE`, `WAITING`, `BLOCKED`, and `COMPLETING/ERRORED`. A `BLOCKED` job is one that cannot yet run due to temporary circumstances (e.g. a pending maintenance or other large reservation.).

If your waiting job cannot complete before a maintenance/reservation begins, `showq` will display its state as `**WaitNod**` ("Waiting for Nodes"). The job will remain in this state until Lonestar6 returns to production.

The default format for `showq` now reports total nodes associated with a job rather than cores, tasks, or hardware threads. One reason for this change is clarity: the operating system sees each compute node's 112 hardware threads as "processors", and output based on that information can be ambiguous or otherwise difficult to interpret.

### [Dependent Jobs using `sbatch`](#jobs-dependencies) { #jobs-dependencies }

You can use `sbatch` to help manage workflows that involve multiple steps: the `--dependency` option allows you to launch jobs that depend on the completion (or successful completion) of another job. For example you could use this technique to split into three jobs a workflow that requires you to (1) compile on a single node; then (2) compute on 40 nodes; then finally (3) post-process your results using 4 nodes. 

``` cmd-line
login1$ sbatch --dependency=afterok:173210 myjobscript
```

For more information see the [Slurm online documentation](http://www.schedmd.com). Note that you can use `$SLURM_JOBID` from one job to find the jobid you'll need to construct the `sbatch` launch line for a subsequent one. But also remember that you can't use `sbatch` to submit a job from a compute node.


### [Other Job Management Commands](#jobs-other) { #jobs-other }

 `scancel`, `scontrol`, and `sacct`

**It's not possible to add resources to a job (e.g. allow more time)** once you've submitted the job to the queue.

To **cancel** a pending or running job, first determine its jobid, then use `scancel`:

```cmd-line
login1$ squeue -u bjones    # one way to determine jobid
 JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
170361        v100   spec12   bjones PD       0:00     32 (Resources)
login1$ scancel 170361      # cancel job
```

For **detailed information** about the configuration of a specific job, use `scontrol`:

```cmd-line
login1$ scontrol show job=170361
```

To view some **accounting data** associated with your own jobs, use `sacct`:

```cmd-line
login1$ sacct --starttime 2019-06-01  # show jobs that started on or after this date
```

## [Visualization and VNC Sessions](#vis) { #vis }

Lonestar6 uses AMD's Milan processors for all visualization and rendering operations. We use the Intel OpenSWR library to render raster graphics with OpenGL, and the Intel OSPRay framework for ray traced images inside visualization software. OpenSWR can be loaded by executing `module load swr`.

Lonestar6 currently has no separate visualization queue. All visualization apps are available on all nodes. VNC and DCV sessions are available on any queue, either through the command line or via the [TACC Visualization Portal](https://vis.tacc.utexas.edu/). We recommend submitting to Lonestar6's `development` queue for interactive sessions. If you are interested in an application that is not yet available, please submit a help desk ticket.

### [Remote Desktop Access](#vis-remote) { #vis-remote }

Remote desktop access to Lonestar6 is formed through a DCV or VNC connection to one or more compute nodes. Users must first connect to a Lonestar6 login node (see [Accessing the System](#access)) and submit a special interactive batch job that:

* allocates a set of Lonestar6 compute nodes
* starts a `dcvserver` or `vncserver` remote desktop process on the first allocated node
* sets up a tunnel through the login node to the dcvserver or vncserver access port

Once the remote desktop process is running on the compute node and a tunnel through the login node is created, an output message identifies the access port for connecting a remote desktop viewer. A remote desktop viewer application is run on the user's remote system and presents the desktop to the user.

!!!	important
	If this is your first time connecting to Lonestar6 using VNC, you must run `vncpasswd` to create a password for your VNC servers. This should NOT be your login password! This mechanism only deters unauthorized connections; it is not fully secure, as only the first eight characters of the password are saved. 

All VNC connections are tunneled through SSH for extra security, as described below.

Follow the steps below to start an interactive session.

1. Start a Remote Desktop

	TACC has provided a DCV job script (`/share/doc/slurm/job.dcv`), a VNC job script (`/share/doc/slurm/job.vnc`) and a combined job script that prefers DCV and fails over to VNC if a DCV license is not available (`/share/doc/slurm/job.dcv2vnc`). Each script requests one node in the development queue for two hours, creating a remote desktop session, either [DCV](https://aws.amazon.com/hpc/dcv) or [VNC](https://en.wikipedia.org/wiki/VNC).

	```cmd-line
	login1$ sbatch /share/doc/slurm/job.vnc
	login1$ sbatch /share/doc/slurm/job.dcv
	login1$ sbatch /share/doc/slurm/job.dcv2vnc
	```

	You may modify or overwrite script defaults with sbatch command-line options. Note that the command options must be placed between `sbatch` and the script:

	* <code>-t <i>hours:minutes:seconds</i></code> modify the job runtime
	* <code>-A <i>projectnumber</i></code> specify the project/allocation to be charged
	* <code>-N <i>nodes</i></code> specify number of nodes needed
	* <code>-p <i>partition</i></code> specify an alternate queue   


	Consult [Table 6](../stampede2#table6) in the [Stampede2 User Guide](../stampede2) for a listing of common Slurm `#SBATCH` options.

	All arguments after the job script name are sent to the vncserver command. For example, to set the desktop resolution to 1440x900, use:

	```cmd-line
	login1$ sbatch /share/doc/slurm/job.vnc -geometry 1440x900
	```

	The `vnc.job` script starts a `vncserver` process and writes to the output file, `vncserver.out` in the job submission directory, with the connect port for the vncviewer. 

	Note that the DCV viewer adjusts desktop resolution to your browser or DCV client, so desktop resolution does not need to be specified.

	Watch for the "To connect" message at the end of the output file, or watch the output stream in a separate window with the commands:

	```cmd-line
	login1$ touch vncserver.out ; tail -f vncserver.out
	login1$ touch dcvserver.out ; tail -f dcvserver.out
	```

	The lightweight window manager, `xfce`, is the default DCV and VNC desktop and is recommended for remote performance. Gnome is available; to use gnome, open the `~/.vnc/xstartup` file (created after your first VNC session) and replace `startxfce4` with `gnome-session`. Note that gnome may lag over slow internet connections.

1. Create an SSH Tunnel to Lonestar6

	DCV connections are encrypted via TLS and are secure. For VNC connections, TACC requires users to create an SSH tunnel from the local system to the Lonestar6 login node to assure that the connection is secure. The tunnels created for the VNC job operate only on the `localhost` interface, so you must use `localhost` in the port forward argument, not the Lonestar6 hostname. On a Unix or Linux system, execute the following command once the port has been opened on the Lonestar6 login node:

	```cmd-line
	localhost$ ssh -f -N -L xxxx:localhost:yyyy username@ls6.tacc.utexas.edu
	```

	where:

	* `<i>yyyy</i>` is the port number given by the vncserver batch job
	* `<i>xxxx</i>` is a port on the remote system. Generally, the port number specified on the Lonestar6 login node, <code><i>yyyy</i></code>, is a good choice to use on your local system as well
	* `-f` instructs SSH to only forward ports, not to execute a remote command
	* `-N` puts the ssh command into the background after connecting
	* `-L` forwards the port   

	On Windows systems find the menu in the Windows SSH client where tunnels can be specified, and enter the local and remote ports as required, then ssh to Lonestar6.  


1. Connecting the vncviewer

	Once the SSH tunnel has been established, use a [VNC client](https://en.wikipedia.org/wiki/Virtual_Network_Computing) to connect to the local port you created, which will then be tunneled to your VNC server on Lonestar6. Connect to localhost:*xxxx*, where *xxxx* is the local port you used for your tunnel. In the examples above, we would connect the VNC client to <code>localhost::<i>xxxx</i></code>. (Some VNC clients accept <code>localhost:<i>xxxx</i></code>).

	We recommend the [TigerVNC](http://sourceforge.net/projects/tigervnc) VNC Client, a platform independent client/server application.

	Once the desktop has been established, two initial xterm windows are presented (which may be overlapping). One, which is white-on-black, manages the lifetime of the VNC server process. Killing this window (typically by typing `exit` or `ctrl-D` at the prompt) will cause the vncserver to terminate and the original batch job to end. Because of this, we recommend that this window not be used for other purposes; it is just too easy to accidentally kill it and terminate the session.

	The other xterm window is black-on-white, and can be used to start both serial programs running on the node hosting the vncserver process, or parallel jobs running across the set of cores associated with the original batch job. Additional xterm windows can be created using the window-manager left-button menu.

### [Applications on the Remote Desktop](#vis-apps) { #vis-apps }

From an interactive desktop, applications can be run from icons or from xterm command prompts. Two special cases arise: running parallel applications, and running applications that use OpenGL.

### [Parallel Applications from the Desktop](#vis-parallelapps) { #vis-parallelapps }

Parallel applications are run on the desktop using the same ibrun wrapper described above (see Running). The command:

```cmd-line
c301-001$ ibrun ibrunoptions application applicationoptions
```

will run application on the associated nodes, as modified by the ibrun options.

### [OpenGL/X Applications On The Desktop](#vis-opengl) { #vis-opengl }

Lonestar6 uses the OpenSWR OpenGL library to perform efficient rendering. At present, the compute nodes on Lonestar6 do not support native X instances. All windowing environments should use a DCV desktop launched via the job script in `/share/doc/slurm/job.dcv`, a VNC desktop launched via the job script in `/share/doc/slurm/job.vnc` or using the [TACC Analysis Portal][TACCANALYSISPORTAL].

`swr`: To access the accelerated OpenSWR OpenGL library, it is necessary to use the `swr` module to point to the `swr` OpenGL implementation and configure the number of threads to allocate to rendering.

```cmd-line
c301-001$ module load swr
c301-001$ swr options application application-args
```

### [Parallel VisIt on Lonestar6](#vis-visit) { #vis-visit }

[VisIt](https://wci.llnl.gov/simulation/computer-codes/visit) was compiled under the Intel compiler and the mvapich2 and MPI stacks.

After connecting to a VNC server on Lonestar6, as described above, load the VisIt module at the beginning of your interactive session before launching the VisIt application:

```cmd-line
c301-001$ module load swr visit
c301-001$ swr visit
```

VisIt first loads a dataset and presents a dialog allowing for selecting either a serial or parallel engine. Select the parallel engine. Note that this dialog will also present options for the number of processes to start and the number of nodes to use; these options are actually ignored in favor of the options specified when the VNC server job was started.

#### [Preparing Data for Parallel Visit](#vis-visit-preparingdata) { #vis-visit-preparingdata }

VisIt reads [nearly 150 data formats](https://github.com/visit-dav/visit/tree/develop/src/databases). Except in some limited circumstances (particle or rectilinear meshes in ADIOS, basic netCDF, Pixie, OpenPMD and a few other formats), VisIt piggy-backs its parallel processing off of whatever static parallel decomposition is used by the data producer. This means that VisIt expects the data to be explicitly partitioned into independent subsets (typically distributed over multiple files) at the time of input. Additionally, VisIt supports a metadata file (with a `.visit` extension) that lists multiple data files of any supported format that hold subsets of a larger logical dataset. VisIt also supports a "brick of values (`bov)` format which supports a simple specification for the static decomposition to use to load data defined on rectilinear meshes. For more information on importing data into VisIt, see [Getting Data Into VisIt](https://visit-dav.github.io/visit-website/pdfs/GettingDataIntoVisIt2.0.0.pdf?#page=97).

### [Parallel ParaView on Lonestar6](#vis-paraview) { #vis-paraview }

After connecting to a VNC server on Lonestar6, as described above, do the following:

1. Set up your environment with the necessary modules. Load the `swr`, `qt5`, `ospray`, and `paraview` modules <b>in this order</b>:

	```cmd-line
	c301-001$ module load swr qt5 ospray paraview
	```

1. Launch ParaView:

	```cmd-line
	c301-001$ swr -p 1 paraview [paraview client options]
	```

1. Click the "Connect" button, or select File -&gt; Connect

1. Select the "auto" configuration, then press "Connect". In the Paraview Output Messages window, you'll see what appears to be an 'lmod' error, but can be ignored. Then you'll see the parallel servers being spawned and the connection established.
## [Help Desk](#help) { #help }

TACC Consulting operates from 8am to 5pm CST, Monday through Friday, except for holidays. You can [submit a help desk ticket][HELPDESK] at any time via the TACC User Portal with &quot;Lonestar6&quot; in the Resource field. Help the consulting staff help you by following these best practices when submitting tickets. 

* **Do your homework** before submitting a help desk ticket. What does the user guide and other documentation say? Search the internet for key phrases in your error logs; that's probably what the consultants answering your ticket are going to do. What have you changed since the last time your job succeeded?

* **Describe your issue as precisely and completely as you can:** what you did, what happened, verbatim error messages, other meaningful output. When appropriate, include the information a consultant would need to find your artifacts and understand your workflow: e.g. the directory containing your build and/or job script; the modules you were using; relevant job numbers; and recent changes in your workflow that could affect or explain the behavior you're observing.

* **[Subscribe to Lonestar6 User News][TACCSUBSCRIBE].** This is the best way to keep abreast of maintenance schedules, system outages, and other general interest items.

* **Have realistic expectations.** Consultants can address system issues and answer questions about Lonestar6. But they can't teach parallel programming in a ticket, and may know nothing about the package you downloaded. They may offer general advice that will help you build, debug, optimize, or modify your code, but you shouldn't expect them to do these things for you.

* **Be patient.** It may take a business day for a consultant to get back to you, especially if your issue is complex. It might take an exchange or two before you and the consultant are on the same page. If the admins disable your account, it's not punitive. When the file system is in danger of crashing, or a login node hangs, they don't have time to notify you before taking action.

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


