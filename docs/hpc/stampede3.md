# Stampede3 User Guide 

*Last update: March 28, 2024*

## [Notices](#notices) { #notices }

*This user guide is in progress and will be updated as the system is configured.*

* Stampede3 Updated Timeline (03/14/2024)

	**All dates subject to change based on hardware availability and condition.**   

	January 2024 - Stampede3 file system available for data migration - **Available now**  
	February - mid April 2024 - Early user period for Stampede3 - **Available now**    
	late April 2024 - Stampede3 in full production   

* Stampede3's Globus endpoint is now active. (02/15/2024)

## [Migrating Data](#migrating) { #migrating }

The Stampede3 login nodes are now available for you to begin moving data between systems.  **If you have an active Stampede3 allocation** then you may begin the data migration process from Stampede2 to Stampede3.  During this migration period Stampede2's `/home` and `/scratch` systems will be temporarily mounted on Stampede3 and will be accessible through the `$HOME_S2` and `$SCRATCH_S2` environment variables respectively.  

!!! warning
	The Stampede2 file mounts are temporary and will be removed once Stampede3 is in full production.

You do not need to migrate data from `$WORK` (Stockyard) as that file system will be automatically mounted on Stampede3.  However, anything in your `$HOME` or `$SCRATCH` directories that you wish to retain will need to be moved.  

!!! important
	Migrate **only** the data you wish to keep from Stampede2.  

### [Examples](#migrating-examples) { #migrating-examples }

**If you have an active Stampede3 allocation** you can access Stampede3 via `ssh` as you do with other TACC resources.  Use the same password and MFA method as for accessing Stampede2.

``` cmd-line
ssh username@stampede3.tacc.utexas.edu
```
To move your data, we recommend using either the UNIX `cp` or `rsync` utilities.  

To copy a single file from Stampede2 to Stampede3: 

```cmd-line
stampede3$ cp $HOME_S2/filename $HOME
```
or

```cmd-line
stampede3$ rsync -r $HOME_S2/filename $HOME
```

To copy a directory: 

```cmd-line
stampede3$ rsync -r $SCRATCH_S2/dirName $SCRATCH
```
or

```cmd-line
stampede3$ cp -r $SCRATCH_S2/dirName $SCRATCH
```


## [Introduction](#intro) { #intro }

The National Science Foundation (NSF) has generously awarded the University of Texas at Austin funds for TACC's Stampede3 system ([Award Abstract # 2320757](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2320757)). <!-- put link to citation here? --> 

### [Allocations](#intro-allocations) { #intro-allocations }

Submit all Stampede3 allocations requests through the NSF's [ACCESS](https://allocations.access-ci.org/) project. General information related to allocations, support and operations is available via the ACCESS website <http://access-ci.org>.

Requesting and managing allocations will require creating a username and password on this site. These credentials do not have to be the same as those used to access the TACC User Portal and TACC resources. Principal Investigators (PIs) and their allocation managers will be able to add/remove users to/from their allocations and submit requests to renew, supplement, extend, etc. their allocations. PIs attempting to manage an allocation via the [TACC User Portal](https://tacc.utexas.edu/portal/dashboard) will be redirected to the ACCESS website.

## [System Architecture](#system) { #system }

### [Sapphire Rapids Compute Nodes](#system-spr) { #system-spr }

Stampede3 hosts 560 "Sapphire Rapids" HBM (SPR) nodes with 112 cores each.  Each SPR node provides a performance increase of 2 - 3x over the SKX nodes due to increased core count and greatly increased memory bandwidth.  The available memory bandwidth per core increases by a factor of 3.5x.  Applications that were starved for memory bandwidth should exhibit improved performance close to 3x. 

#### [Table 1. SPR Specifications](#table1) { #table1 }

Specification | Value 
--- | ---
CPU: | Intel Xeon CPU MAX 9480 ("Sapphire Rapids HBM")
Total cores per node: | 112 cores on two sockets (2x 56 cores)
Hardware threads per core: | 1
Hardware threads per node: | 2x56 = 112
Clock rate: | 1.9GHz
Memory: | 128 GB HBM 2e
Cache: | 48 KB L1 data cache per core; 1MB L2 per core; 112.5 MB L3 per socket. Each socket can cache up to 168.5 MB (sum of L2 and L3 capacity).
Local storage: | 150 GB /tmp partition

### [Ponte Vecchio Compute Nodes](#system-pvc) { #system-pvc }

Stampede3 hosts 20 nodes with four Intel Data Center GPU Max 1550s "Ponte Vecchio" (PVC) each.  Each PVC GPU has 128 GB of HBM2e and 128 Xe cores providing a peak performance of 4x 52 FP64 TFLOPS per node for scientific workflows and 4x 832 BF16 TFLOPS for ML workflows. 

#### [Table 2. PVC Specifications](#table2) { #table2 }

Specification | Value
--- | ---
GPU: | 4x Intel Data Center GPU Max 1550s ("Ponte Vecchio")
GPU Memory: | 128 GB HBM 2e
CPU: | Intel Xeon Platinum 8480+ ("Sapphire Rapids")
Total cores per node: | 112 cores on two sockets (2x 56 cores)
Hardware threads per core: | 1
Hardware threads per node: | 2x56 = 112
Clock rate: | 2.0 GHz
Memory: | 512 GB DDR5
Cache: | 48 KB L1 data cache per core; 1MB L2 per core; 112.5 MB L3 per socket. Each socket can cache up to 168.5 MB (sum of L2 and L3 capacity).
Local storage: | 150 GB /tmp partition

### [Skylake Compute Nodes](#system-skx)  { #system-skx }

Stampede3 hosts 1,060 "Skylake" (SKX) compute nodes.

#### [Table 3. SKX Specifications](#table3) { #table3 }

Specification | Value
--- | ---
Model: | Intel Xeon Platinum 8160 ("Skylake")
Total cores per SKX node: | 48 cores on two sockets (24 cores/socket)
Hardware threads per core: | 1
Hardware threads per node: | 48
Clock rate: | 2.1GHz nominal (1.4-3.7GHz depending on instruction set and number of active cores)
RAM: | 192GB (2.67GHz) DDR4
Cache: | 32 KB L1 data cache per core; 1 MB L2 per core; 33 MB L3 per socket. Each socket can cache up to 57 MB (sum of L2 and L3 capacity).
Local storage: | 90 GB /tmp 

### [ICX Compute Nodes](#system-icx) { #system-icx }

Stampede3 hosts 224 "Ice Lake" (ICX) compute nodes.

#### [Table 4. ICX Specifications](#table4) { #table4 }

Specification | Value
--- | ---
Model: | Intel Xeon Platinum 8380 ("Ice Lake")
Total cores per ICX node: | 80 cores on two sockets (40 cores/socket)
Hardware threads per core: | 1
Hardware threads per node: | 80
Clock rate: | 2.3 GHz nominal (3.4GHz max frequency depending on instruction set and number of active cores)
RAM: | 256GB (3.2 GHz) DDR4
Cache: | 48KB L1 data cache per core; 1.25 MB L2 per core; 60 MB L3 per socket. Each socket can cache up to 110 MB (sum of L2 and L3 capacity)
Local storage: | 200 GB /tmp partition

### [Login Nodes](#system-login) { #system-login }

The Stampede3 login nodes are Intel Xeon Platinum 8468 "Sapphire Rapids" (SPR) nodes, each with 96 cores on two sockets (48 cores/socket) with 250 GB of DDR. 

### [Network](#network) { #system-network }

The interconnect is a 100Gb/sec Omni-Path (OPA) network with a fat tree topology. There is one leaf switch for each 28-node half rack, each with 20 leaf-to-core uplinks (28/20 oversubscription) for the SKX nodes.  The ICX and SKX nodes are fully connected.  The SPR and PVC nodes are fully connected with a fat tree topology with no oversubscription. 

The SPR and PVC networks will be upgraded to use Cornelis' CN5000 Omni-Path technology in 2024.  The backbone network will also be upgraded. 

### [File Systems](#system-filesystems) { #system-filesystems }
 
Stampede3 will use a shared VAST file system for the `$HOME` and `$SCRATCH` directories.  **These two file systems are NOT lustre file systems and do not support setting a stripe count or stripe size**.  There are no options for the user to set.  As with Stampede2, the `$WORK` file system will also be mounted.  Unlike `$HOME` and `$SCRATCH`, the `$WORK` file system is a Lustre file system and supports the lustre `lfs` commands.  All three file systems, `$HOME`, `$SCRATCH`, and `$WORK` are available from all Stampede3 nodes.  The `/tmp` partition is also available to users but is local to each node. The `$WORK` file system is available on most other TACC HPC systems as well. 


#### [Table 5. File Systems](#table5) { #table5 }

File System | Quota | Key Features
--- | --- | ---
`$HOME` | 15 GB, 300,000 files | Not intended for parallel or high−intensity file operations. <br> Backed up regularly. | Not purged.  
`$WORK` | 1 TB, 3,000,000 files across all TACC systems<br>Not intended for parallel or high−intensity file operations.<br>See [Stockyard system description](#xxx) for more information. | Not backed up. | Not purged.
`$SCRATCH` | no quota<br>Overall capacity ~10 PB. | Not backed up.<br>Files are subject to purge if access time* is more than 10 days old. See TACC's [Scratch File System Purge Policy](#scratchpolicy) below.

{% include 'include/scratchpolicy.md' %}

## [Accessing the System](#access) { #access }

Access to all TACC systems requires Multi-Factor Authentication (MFA). You can create an MFA pairing under "Manage Account" in the TACC Portal.  See [Multi-Factor Authentication at TACC](../../basics/mfa) for further information.

!!! important
	You will be able to log on to Stampede3 **only if** you have an allocation on Stampede3, otherwise your password will be rejected.  
	Monitor your projects &amp; allocations the via the [TACC Portal](https://tacc.utexas.edu/portal/projects).

### [Secure Shell (SSH)](#access-ssh) { #access-ssh }

The `ssh` command (Secure Shell, or SSH protocol) is the standard way to connect to Stampede3 and initiate a login session. SSH also includes support for the UNIX file transfer utilities `scp` and `sftp`.  These commands are available within Linux and the Terminal application within Mac OS. If you are using Windows, you will need a modern terminal application such as [Windows Terminal](https://apps.microsoft.com/detail/9N0DX20HK701?hl=en-US&gl=US), [MobaXterm](https://mobaxterm.mobatek.net/) or [Cyberduck](https://cyberduck.io/download/).  

Initiate an SSH session using the `ssh` command or the equivalent: 

	localhost$ ssh myusername@stampede3.tacc.utexas.edu

The above command will rotate connections across all available login nodes and route your connection to one of them. To connect to a specific login node, use its full domain name:

	localhost$ ssh myusername@login2.stampede3.tacc.utexas.edu

To connect with X11 support on Stampede3 (usually required for applications with graphical user interfaces), use the `-X` or `-Y` option:

	localhost$ ssh -X myusername@stampede3.tacc.utexas.edu

Use your TACC portal password for direct logins to TACC resources. You can change or reset your TACC password via the [TACC Portal][TACCUSERPORTAL] under "Manage Account".  To report a connection problem, execute the `ssh` command with the `-vvv` option and include this command's verbose output when submitting a help ticket.

Do not run the `ssh-keygen` command on Stampede3. This command will create and configure a key pair that will interfere with the execution of job scripts in the batch system.  If you do this by mistake, you can recover by renaming or deleting the `.ssh` directory located in your home directory; the system will automatically generate a new pair for you when you next log into Stampede3.

1. execute `mv .ssh dot.ssh.old`
1. log out
1. log into Stampede3 again

After logging in again, the system will generate a properly configured key SSH pair.

## [Account Administration](#admin)

This section explores ways to configure and manage your Linux account on Stampede3.  Stampede3 nodes run Rocky Linux. Regardless of your research workflow, you'll likely need to master Linux command-line basics along with a Linux-based text editor (e.g. `emacs`, `nano`, `gedit`, or `vi`/`vim`) to use the system properly. If you encounter a term or concept in this user guide that is new to you, a quick internet search should help you resolve the matter quickly.

### [Allocation Status](#admin-allocation)

If your password is rejected while attempting to log in, it's possible your account or project has not been added to a Stampede3 allocation.  You can list and manage your allocations via the [TACC Portal](https://tacc.utexas.edu/portal/projects).  

### [Linux Shell](#admin-linux)

The default login shell for your user account is Bash. To determine your current login shell, examine the contents of the `$SHELL` environment variable: 

	$ echo $SHELL

!!! tip
	If you'd like to change your login shell to `csh`, `tcsh`, or `zsh`, [submit a help ticket][HELPDESK]. 
	The `chsh` ("change shell") command will not work on TACC systems.

When you start a shell on Stampede3, system-level startup files initialize your account-level environment and aliases before the system sources your own user-level startup scripts. You can use these startup scripts to customize your shell by defining your own environment variables, aliases, and functions. These scripts (e.g. `.profile` and `.bashrc`) are generally hidden files: so-called "dotfiles" that begin with a period, visible when you execute: `ls -a`.

Before editing your startup files, however, it's worth taking the time to understand the basics of how your shell manages startup. Bash startup behavior is very different from the simpler `csh` behavior, for example. The Bash startup sequence varies depending on how you start the shell (e.g. using `ssh` to open a login shell, executing the `bash` command to begin an interactive shell, or launching a script to start a non-interactive shell). Moreover, Bash does not automatically source your `.bashrc` file when you start a login shell by using `ssh` to connect to a node. Unless you have specialized needs, however, this is undoubtedly more flexibility than you want: you will probably want your environment to be the same regardless of how you start the shell. The easiest way to achieve this is to execute `source ~/.bashrc` from your `.profile`, then put all your customizations in your `.bashrc` file. The system-generated default startup scripts demonstrate this approach. We recommend that you use these default files as templates.

For more information see the [Bash Users' Startup Files: Quick Start Guide][TACCBASHQUICKSTART] and other online resources that explain shell startup. To recover the originals that appear in a newly created account, execute `/usr/local/startup_scripts/install_default_scripts`.

### [Diagnostics](#admin-diagnostics)

TACC's `sanitytool` module loads an account-level diagnostic package that detects common account-level issues and often walks you through the fixes. You should certainly run the package's `sanitycheck` utility when you encounter unexpected behavior. You may also want to run `sanitycheck` periodically as preventive maintenance. To run `sanitytool`'s account-level diagnostics, execute the following commands:

	login1$ module load sanitytool
	login1$ sanitycheck

Execute `module help sanitytool` for more information.

### [Environment Variables](#admin-envvars)

Your environment includes the environment variables and functions defined in your current shell: those initialized by the system, those you define or modify in your account-level startup scripts, and those defined or modified by the modules that you load to configure your software environment. Be sure to distinguish between an environment variable's name (e.g. `HISTSIZE`) and its value (`$HISTSIZE`). Understand as well that a sub-shell (e.g. a script) inherits environment variables from its parent, but does not inherit ordinary shell variables or aliases. Use `export` (in Bash) or `setenv` (in `csh`) to define an environment variable.

Execute the `env` command to see the environment variables that define the way your shell and child shells behave.
Pipe the results of `env` into `grep` to focus on specific environment variables. For example, to see all environment variables that contain the string GIT (in all caps), execute:

	$ env | grep GIT

The environment variables `PATH` and `LD_LIBRARY_PATH` are especially important. The `PATH` is a colon-separated list of directory paths that determines where the system looks for your executables.  The `LD_LIBRARY_PATH` environment variable is a similar list that determines where the system looks for shared libraries.


### [Using Modules](#admin-modules)

Lmod, a module system developed and maintained at TACC, makes it easy to manage your environment so you have access to the software packages and versions that you need to using your research. This is especially important on a system like Stampede3 that serves thousands of users with an enormous range of needs and software. Loading a module amounts to choosing a specific package from among available alternatives:

	$ module load intel          # load the default Intel compiler
	$ module load intel/24.0.0   # load a specific version of Intel compiler

A module does its job by defining or modifying environment variables (and sometimes aliases and functions). For example, a module may prepend appropriate paths to `$PATH` and `$LD_LIBRARY_PATH` so that the system can find the executables and libraries associated with a given software package. The module creates the illusion that the system is installing software for your personal use. Unloading a module reverses these changes and creates the illusion that the system just uninstalled the software:

	$ module load   ddt  # defines DDT-related env vars; modifies others
	$ module unload ddt  # undoes changes made by load

The module system does more, however. When you load a given module, the module system can automatically replace or deactivate modules to ensure the packages you have loaded are compatible with each other. In the example below, the module system automatically unloads one compiler when you load another, and replaces Intel-compatible versions of IMPI and PETSc with versions compatible with `gcc`:

	$ module load intel  # load default version of Intel compiler
	$ module load petsc  # load default version of PETSc
	$ module load gcc    # change compiler
	
	Lmod is automatically replacing "intel/24.0.0" with "gcc/13.2.0".
	
	Due to MODULEPATH changes, the following have been reloaded:
	1) impi/21.11     2) petsc/3.8

!!! tip
	See [Lmod's documentation](https://lmod.readthedocs.io/en/latest/) for extensive information. The online documentation addresses the basics in more detail, but also covers several topics beyond the scope of the help text (e.g. writing and using your own module files).

On Stampede3, modules generally adhere to a TACC naming convention when defining environment variables that are helpful for building and running software. For example, the papi module defines `TACC_PAPI_BIN` (the path to PAPI executables), `TACC_PAPI_LIB` (the path to PAPI libraries), `TACC_PAPI_INC` (the path to PAPI include files), and `TACC_PAPI_DIR` (top-level PAPI directory). After loading a module, here are some easy ways to observe its effects:

	$ module show papi   # see what this module does to your environment
	$ env | grep PAPI    # see env vars that contain the string PAPI
	$ env | grep -i papi # case-insensitive search for 'papi' in environment

To see the modules you currently have loaded:

	$ module list

To see all modules that you can load right now because they are compatible with the currently loaded modules:

	$ module avail

To see all installed modules, even if they are not currently available because they are incompatible with your currently loaded modules:

	$ module spider                  # list all modules, even those not available to load

To filter your search:

	$ module spider slep             # all modules with names containing 'slep'
	$ module spider sundials/2.5.0   # additional details on a specific module

Among other things, the latter command will tell you which modules you need to load before the module is available to load. You might also search for modules that are tagged with a keyword related to your needs (though your success here depends on the diligence of the module writers). For example:

	$ module keyword performance

You can save a collection of modules as a personal default collection that will load every time you log into Stampede3. To do so, load the modules you want in your collection, then execute:

	$ module save            # save the currently loaded collection of modules

Two commands make it easy to return to a known, reproducible state:

	$ module reset           # load the system default collection of modules
	$ module restore         # load your personal default collection of modules

On TACC systems, the command `module reset` is equivalent to `module purge; module load` TACC. It's a safer, easier way to get to a known baseline state than issuing the two commands separately.

Help text is available for both individual modules and the module system itself:

	$ module help swr        # show help text for software package swr
	$ module help            # show help text for the module system itself


It's safe to execute module commands in job scripts. In fact, this is a good way to write self-documenting, portable job scripts that produce reproducible results.  If you use `module save` to define a personal default module collection, it's rarely necessary to execute module commands in shell startup scripts, and it can be tricky to do so safely. If you do wish to put module commands in your startup scripts, see Stampede3's default startup scripts in `/usr/local/startup_scripts` for a safe way to do so.

### [TACC Tips](#admin-tips)

TACC Staff has amassed a database of helpful tips for our users.  Access these tips via the `tacc_tips` module and `showTip` command as demonstrated below:

	$ module load tacc_tips
	$ showTip

	Tip 131   (See "module help tacc_tips" for features or how to disable)

   		Use Ctrl+E to go the end of the command line.

## [Managing Your Files](#files) { #files }

Stampede3 mounts three file systems that are shared across all nodes: the home, work, and scratch file systems. Stampede3's startup mechanisms define corresponding account-level environment variables `$HOME`, `$SCRATCH`, and `$WORK` that store the paths to directories that you own on each of these file systems. Consult the Stampede3 File Systems table for the basic characteristics of these file systems, File Operations: I/O Performance for advice on performance issues, and Good Conduct for tips on file system etiquette.

### [Navigating the Shared File Systems](#files-filesystems) { #files-filesystems }

Stampede3's `/home` and `/scratch` file systems are mounted only on Stampede3, but the work file system mounted on Stampede3 is the Global Shared File System hosted on [Stockyard](https://tacc.utexas.edu/systems/stockyard/).  Stockyard is the same work file system that is currently available on Frontera, Lonestar6, and several other TACC resources.

The `$STOCKYARD` environment variable points to the highest-level directory that you own on the Global Shared File System. The definition of the `$STOCKYARD` environment variable is of course account-specific, but you will see the same value on all TACC systems that provide access to the Global Shared File System. This directory is an excellent place to store files you want to access regularly from multiple TACC resources.

Your account-specific `$WORK` environment variable varies from system to system and is a sub-directory of `$STOCKYARD` (Figure 1). The sub-directory name corresponds to the associated TACC resource. The `$WORK` environment variable on Stampede3 points to the `$STOCKYARD/stampede3` subdirectory, a convenient location for files you use and jobs you run on Stampede3. Remember, however, that all subdirectories contained in your `$STOCKYARD` directory are available to you from any system that mounts the file system. If you have accounts on both Stampede3 and Frontera, for example, the `$STOCKYARD/stampede3` directory is available from your Frontera account, and `$STOCKYARD/frontera` is available from your Stampede3 account.

!!! note 
	Your quota and reported usage on the Global Shared File System reflects **all files that you own on Stockyard**, regardless of their actual location on the file system.

See the example for fictitious user bjones in the figure below.  All directories are accessible from all systems, however a given sub-directory (e.g. lonestar6, frontera) will exist only if you have an allocation on that system.  [Figure 1](#figure1) below illustrates account-level directories on the `$WORK` file system (Global Shared File System hosted on Stockyard).   

<figure id="#figure1"><img src="../imgs/Stockyard2024.png">
<figcaption>Stockyard 2024</figcaption></figure>

Note that the resource-specific sub-directories of `$STOCKYARD` are nothing more than convenient ways to manage your resource-specific files. You have access to any such sub-directory from any TACC resources. If you are logged into Stampede3, for example, executing the alias cdw (equivalent to cd `$WORK`) will take you to the resource-specific sub-directory `$STOCKYARD/stampede3`. But you can access this directory from other TACC systems as well by executing cd `$STOCKYARD/stampede3`. These commands allow you to share files across TACC systems. In fact, several convenient account-level aliases make it even easier to navigate across the directories you own in the shared file systems:

### [Table 6. Built-in Account Level Aliases](#table6) { #table6 }

Alias | Command
--- | ---
`cd` or `cdh` | `cd $HOME`
`cdw` | `cd $WORK`
`cds` | `cd $SCRATCH`
`cdy` or `cdg` | `cd $STOCKYARD`


### [Sharing Files with Collaborators](#files-sharing) { #files-sharing }

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems](../../tutorials/sharingprojectfiles) for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.

## [Running Jobs](#running) { #running }

{% include 'include/stampede3-jobaccounting.md' %}

<!-- ### [Slurm Job Scheduler](#running-slurm) { #running-slurm } -->


### [Slurm Partitions (Queues)](#queues) { #queues }

Stampede3's job scheduler is the Slurm Workload Manager. Slurm commands enable you to submit, manage, monitor, and control your jobs.  <!-- See the [Job Management]()  section below for further information. -->

**Queues and limits are subject to change without notice.**  Execute `qlimits` on Stampede3 for real-time information regarding limits on available queues.  <!-- See Monitoring Jobs and Queues for additional information. -->

<!-- till things stabilize 
#### [Table 7. Production Queues](#table7) { #table7 }

Queue Name   | Node Type | Max Nodes per Job<br>(assoc'd cores) | Max Duration | Max Jobs in Queue | Charge Rate<br>(per node-hour)
--           | --        | --                                   | --           | --                |  
skx-dev      | SKX       | 4 nodes<br>(192 cores)               | 2 hrs        | 1                 | 1 SU
skx-normal   | SKX       | 128 nodes<br>(6,144 cores)           | 48 hrs       | 20                | 1 SU
skx-large&#42;  | SKX       | 384 nodes<br>(18,432 cores)          | 48 hrs       | 3                 | 1 SU
icx-normal   | ICX       | 40 nodes<br>(3,200 cores)            | 48 hrs       | 20                | 1.67 SU
spr-normal   | SPR       | 100 nodes<br>(11,200 cores)          | 48 hrs       | 20                | 3 SU
pvc          | PVC       | 5 nodes<br>(20 PVCs)                 | 48 hrs       | 20                | 5 SU 
-->

Current queue/partition limits on TACC's stampede3 system as of February 1, 2024:
	
	Name             MinNode  MaxNode     MaxWall  MaxNodePU  MaxJobsPU   MaxSubmit
	icx                    1       16  1-00:00:00         24          4          20
	skx                    1       32  1-00:00:00         48          4          20
	skx-dev                1        4    02:00:00          6          1           3


<!-- **&#42; To request more nodes than are available in the skx-normal queue, submit a consulting (help desk) ticket. Include in your request reasonable evidence of your readiness to run under the conditions you're requesting. In most cases this should include your own strong or weak scaling results from Stampede3.** -->

<!-- 
### [Submitting Batch Jobs with sbatch]()

Use Slurm's sbatch command to submit a batch job to one of the Stampede3 queues:

	login1$ sbatch myjobscript

Here myjobscript is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting. The details of your job script's contents depend on the type of job you intend to run.

In your job script you (1) use `#SBATCH` directives to request computing resources (e.g. 10 nodes for 2 hrs); and then (2) use shell commands to specify what work you're going to do once your job begins. There are many possibilities: you might elect to launch a single application, or you might want to accomplish several steps in a workflow. You may even choose to launch more than one application at the same time. The details will vary, and there are many possibilities. But your own job script will probably include at least one launch line that is a variation of one of the examples described here.

Your job will run in the environment it inherits at submission time; this environment includes the modules you have loaded and the current working directory. In most cases you should run your applications(s) after loading the same modules that you used to build them. You can of course use your job submission script to modify this environment by defining new environment variables; changing the values of existing environment variables; loading or unloading modules; changing directory; or specifying relative or absolute paths to files. **Do not** use the Slurm `--export` option to manage your job's environment: doing so can interfere with the way the system propagates the inherited environment.

The Common `sbatch` Options table below describes some of the most common sbatch command options. Slurm directives begin with `#SBATCH`; most have a short form (e.g. `-N`) and a long form (e.g. `--nodes`). You can pass options to sbatch using either the command line or job script; most users find that the job script is the easier approach. The first line of your job script must specify the interpreter that will parse non-Slurm commands; in most cases #!/bin/bash or #!/bin/csh is the right choice. Avoid `#!/bin/sh` (its startup behavior can lead to subtle problems on Stampede3), and do not include comments or any other characters on this first line. All `#SBATCH` directives must precede all shell commands. Note also that certain `#SBATCH` options or combinations of options are mandatory, while others are not available on Stampede3.
-->
<!-- 
#### [Table 8. Common sbatch Options](#table8)

Option | Argument | Comments
--- | --- | ---
`-p`  | queue_name | Submits to queue (partition) designated by queue_name
`-J`  | job_name   | Job Name
`-N`  | total_nodes | Required. Define the resources you need by specifying either:<br>(1) `-N` and `-n`; or<br>(2) `-N` and `-ntasks-per-node`.
`-n`  | total_tasks | This is total MPI tasks in this job. See `-N` above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set it to the same value as `-N`.
`-ntasks-per-node`<br>or<br>`-tasks-per-node` | tasks_per_node | This is MPI tasks per node. See `-N` above for a good way to use this option. When using this option in a non-MPI job, it is usually best to set `-ntasks-per-node` to 1.
`-t  | hh:mm:ss | Required. Wall clock time for job.
`-mail-user=` | email_address | Specify the email address to use for notifications. Use with the `-mail-type=` flag below.
`-mail-type=` | begin, end, fail, or all | Specify when user notifications are to be sent (one option per line).
`-o`  | output_file | Direct job standard output to output_file (without `-e` option error goes to this file)
`-e`  | error_file | Direct job error output to error_file
`-d=` | afterok:jobid | Specifies a dependency: this run will start only after the specified job (jobid) successfully finishes
`-A`  | projectid | Charge job to the specified project/allocation number. This option is only necessary for logins associated with multiple projects.
`-a`<br>or<br>`-array` | N/A | Not available. Use the launcher module for parameter sweeps and other collections of related serial jobs.
`-mem`  | N/A | Not available. If you attempt to use this option, the scheduler will not accept your job.
`-export=` | N/A | Avoid this option on Stampede3. Using it is rarely necessary and can interfere with the way the system propagates your environment.

By default, Slurm writes all console output to a file named "slurm-%j.out", where `%j` is the numerical job ID. To specify a different filename use the `-o` option. To save `stdout` (standard out) and `stderr` (standard error) to separate files, specify both `-o` and `-e` options.
-->
## [Launching Applications](#launching) { #launching }

The primary purpose of your job script is to launch your research application. How you do so depends on several factors, especially (1) the type of application (e.g. MPI, OpenMP, serial), and (2) what you're trying to accomplish (e.g. launch a single instance, complete several steps in a workflow, run several applications simultaneously within the same job). While there are many possibilities, your own job script will probably include a launch line that is a variation of one of the examples described in this section:

Note that the following examples demonstrate launching within a Slurm job script or an `idev` session.  Do not launch jobs on the login nodes.

### [One Serial Application](#launching-serial) { #launching-serial }

To launch a serial application, simply call the executable. Specify the path to the executable in either the `$PATH` environment variable or in the call to the executable itself:

``` job-script
myprogram                      # executable in a directory listed in $PATH
$WORK/apps/myprov/myprogram    # explicit full path to executable
./myprogram                    # executable in current directory
./myprogram -m -k 6 input1     # executable with notional input options
```

### [One Multi-Threaded Application](#launching-multithreaded) { #launching-multithreaded }

Launch a threaded application the same way. Be sure to specify the number of threads. Note that the default OpenMP thread count is 1.

``` job-script
export OMP_NUM_THREADS=48      # 48 total OpenMP threads (1 per SKX core)
./myprogram
```

### [One MPI Application](#launching-mpi) { #launching-mpi }

To launch an MPI application, use the TACC-specific MPI launcher `ibrun`, which is a Stampede3-aware replacement for generic MPI launchers like `mpirun` and `mpiexec`. In most cases the only arguments you need are the name of your executable followed by any arguments your executable needs. When you call `ibrun` without other arguments, your Slurm `#SBATCH` directives will determine the number of ranks (MPI tasks) and number of nodes on which your program runs.

``` job-script
#SBATCH -N 5
#SBATCH -n 200
ibrun ./myprogram              # ibrun uses the $SBATCH directives to properly allocate nodes and tasks
```
To use `ibrun` interactively, say within an `idev` session, you can specify:

``` cmd-line
login1$ idev -N 2 -n 80 
c123-456$ ibrun ./myprogram    # ibrun uses idev's arguments to properly allocate nodes and tasks
```


### [One Hybrid (MPI+Threads) Application](#launching-hybrid) { #launching-hybrid }

When launching a single application you generally don't need to worry about affinity: both Intel MPI and MVAPICH2 will distribute and pin tasks and threads in a sensible way.

``` job-script
export OMP_NUM_THREADS=8    # 8 OpenMP threads per MPI rank
ibrun ./myprogram           # use ibrun instead of mpirun or mpiexec
```

As a practical guideline, the product of `$OMP_NUM_THREADS` and the maximum number of MPI processes per node should not be greater than total number of cores available per node (SPR nodes have 112 cores, ICX nodes have 80 cores, SKX nodes have 48 cores).

### [More Than One Serial Application in the Same Job](#launching-morethanoneserial) { #launching-morethanoneserial }

TACC's `launcher` utility provides an easy way to launch more than one serial application in a single job. This is a great way to engage in a popular form of High Throughput Computing: running parameter sweeps (one serial application against many different input datasets) on several nodes simultaneously. The `launcher` utility will execute your specified list of independent serial commands, distributing the tasks evenly, pinning them to specific cores, and scheduling them to keep cores busy. Execute `module load launcher` followed by `module help launcher` for more information.

### [MPI Applications - Consecutive](#launching-mpiconsecutive) { #launching-mpiconsecutive }

To run one MPI application after another (or any sequence of commands one at a time), simply list them in your job script in the order in which you'd like them to execute. When one application/command completes, the next one will begin.

``` job-script
module load git
module list
./preprocess.sh
ibrun ./myprogram input1    # runs after preprocess.sh completes
ibrun ./myprogram input2    # runs after previous MPI app completes
```

### [MPI Application - Concurrent](#launching-mpiconcurrent) { #launching-mpiconcurrent }

To run more than one MPI application simultaneously in the same job, you need to do several things:

* use ampersands to launch each instance in the background;
* include a `wait` command to pause the job script until the background tasks complete;
* use `ibrun`'s `-n` and `-o` switches to specify task counts and hostlist offsets respectively; and
* include a call to the `task_affinity` script in your `ibrun` launch line.

If, for example, you use `#SBATCH` directives to request N=4 nodes and n=128 total MPI tasks, Slurm will generate a hostfile with 128 entries (32 entries for each of 4 nodes). The `-n` and `-o` switches, which must be used together, determine which hostfile entries `ibrun` uses to launch a given application; execute `ibrun --help` for more information. **Don't forget the ampersands (&) to launch the jobs in the background, and the wait command to pause the script until the background tasks complete**:

``` job-script
ibrun -n 32 -o  0 task_affinity ./myprogram input1 &   # 32 tasks; offset by  0 entries in hostfile.
ibrun -n 32 -o 32 task_affinity ./myprogram input2 &   # 32 tasks; offset by 32 entries in hostfile.
wait                                                   # Required; else script will exit immediately.
```

The `task_affinity` script manages task placement and pinning when you call `ibrun` with the `-n`, `-o` switches (it's not necessary under any other circumstances); 

### [More than One OpenMP Application Running Concurrently](#launching-openmp)

You can also run more than one OpenMP application simultaneously on a single node, but you will need to distribute and pin tasks appropriately. In the example below, numactl -C specifies virtual CPUs (hardware threads). According to the numbering scheme for SPR hardware threads, CPU (hardware thread) numbers 0-111 are spread across the 112 cores, 1 thread per core. Similarly for SKX: CPU (hardware thread) numbers 0-47 are spread across the 48 cores, 1 thread per core, and for ICX: CPU (hardware thread) numbers 0-79 are spread across the 80 cores, 1 thread per core.

``` job-script
export OMP_NUM_THREADS=2
numactl -C 0-1 ./myprogram inputfile1 &  # HW threads (hence cores) 0-1. Note ampersand.
numactl -C 2-3 ./myprogram inputfile2 &  # HW threads (hence cores) 2-3. Note ampersand.

wait
```

### [Interactive Sessions](#launching-interactive) { #launching-interactive }

#### [Interactive Sessions with `idev` and `srun`](#launching-interactive-idev) { #launching-interactive-idev }

TACC's own `idev` utility is the best way to begin an interactive session on one or more compute nodes. To launch a thirty-minute session on a single node in the development queue, simply execute:

``` cmd-line
login1$ idev
```

You'll then see output that includes the following excerpts:

``` cmd-line
...
-----------------------------------------------------------------
      Welcome to the Stampede3 Supercomputer          
-----------------------------------------------------------------
...

-> After your `idev` job begins to run, a command prompt will appear,
-> and you can begin your interactive development session. 
-> We will report the job status every 4 seconds: (PD=pending, R=running).

->job status:  PD
->job status:  PD
...
c449-001$
```

The job status messages indicate that your interactive session is waiting in the queue. When your session begins, you'll see a command prompt on a compute node (in this case, the node with hostname c449-001). If this is the first time you launch `idev`, the prompts may invite you to choose a default project and a default number of tasks per node for future `idev` sessions.

For command line options and other information, execute `idev --help`. It's easy to tailor your submission request (e.g. shorter or longer duration) using Slurm-like syntax:

``` cmd-line
login1$ idev -p skx-normal -N 2 -n 8 -m 150 # skx-normal queue, 2 nodes, 8 total tasks, 150 minutes
```

For more information [see the `idev` documentation][TACCIDEV].

You can also launch an interactive session with Slurm's `srun` command. A typical launch line would look like this:

``` cmd-line
login1$ srun --pty -N 2 -n 8 -t 2:30:00 -p skx-normal /bin/bash -l # same conditions as above
```

#### [Interactive Sessions using `ssh`](#launching-interactive-ssh) { #launching-interactive-ssh }

If you have a batch job or interactive session running on a compute node, you "own the node": you can connect via ssh to open a new interactive session on that node. This is an especially convenient way to monitor your applications' progress. One particularly helpful example: login to a compute node that you own, execute top, then press the "1" key to see a display that allows you to monitor thread ("CPU") and memory use.

There are many ways to determine the nodes on which you are running a job, including feedback messages following your sbatch submission, the compute node command prompt in an `idev` session, and the `squeue` or `showq` utilities. The sequence of identifying your compute node then connecting to it would look like this:

``` cmd-line
login1$ squeue -u bjones
 JOBID       PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
858811     skx-dev     idv46796   bjones  R       0:39      1 c448-004
1ogin1$ ssh c448-004
...
C448-004$
```

### [Slurm Environment Variables](#launching-slurmenvs) { #launching-slurmenvs }

Be sure to distinguish between internal Slurm replacement symbols (e.g. %j described above) and Linux environment variables defined by Slurm (e.g. SLURM_JOBID). Execute env | grep SLURM from within your job script to see the full list of Slurm environment variables and their values. You can use Slurm replacement symbols like %j only to construct a Slurm filename pattern; they are not meaningful to your Linux shell. Conversely, you can use Slurm environment variables in the shell portion of your job script but not in an `#SBATCH` directive.

!!! danger 
	For example, the following directive will not work the way you might think:
	``` job-script
	#SBATCH -o myMPI.o${SLURM_JOB_ID}   # incorrect
	```
!!! hint 
	Instead, use the following directive:
	``` job-script
	#SBATCH -o myMPI.o%j     # "%j" expands to your job's numerical job ID
	```

Similarly, you cannot use paths like `$WORK` or `$SCRATCH` in an `#SBATCH` directive.

For more information on this and other matters related to Slurm job submission, see the [Slurm online documentation](https://slurm.schedmd.com/sbatch.html); the man pages for both Slurm itself (`man slurm`) and its individual commands (e.g. `man sbatch`); as well as numerous other online resources.

## [Building Software](#building) { #building }

The phrase "building software" is a common way to describe the process of producing a machine-readable executable file from source files written in C, Fortran, or some other programming language. In its simplest form, building software involves a simple, one-line call or short shell script that invokes a compiler. More typically, the process leverages the power of makefiles, so you can change a line or two in the source code, then rebuild in a systematic way only the components affected by the change. Increasingly, however, the build process is a sophisticated multi-step automated workflow managed by a special framework like autotools or cmake, intended to achieve a repeatable, maintainable, portable mechanism for installing software across a wide range of target platforms.

This section of the user guide does nothing more than introduce the big ideas with simple one-line examples. You will undoubtedly want to explore these concepts more deeply using online resources. You will quickly outgrow the examples here. We recommend that you master the basics of makefiles as quickly as possible: even the simplest computational research project will benefit enormously from the power and flexibility of a makefile-based build process.

### [Compilers](#building-compilers) { #building-compilers }

#### [Intel Compilers](#building-intel) { #building-intel }

Intel is the recommended and default compiler suite on Stampede3. Each Intel module also gives you direct access to mkl without loading an mkl module; see Intel MKL for more information. 

!!! note
	The latest Intel distribution uses the OneAPI compilers which have different names than the traditional Intel compilers:

	Classic	| OneAPI
	---     | ---
	`icc`     | `icx`
	`icpc`    | `icpx`
	`ifort`   | `ifx`

Here are simple examples that use the Intel compiler to build an executable from source code:

	$ icx mycode.c                    # C source file; executable a.out
	$ icx main.c calc.c analyze.c     # multiple source files
	$ icx mycode.c     -o myexe       # C source file; executable myexe
	$ icpx mycode.cpp  -o myexe       # C++ source file
	$ ifx mycode.f90 -o myexe         # Fortran90 source file

Compiling a code that uses OpenMP would look like this:

	$ icx -qopenmp mycode.c -o myexe  # OpenMP

See the published Intel documentation, available both online and in `${TACC_INTEL_DIR}/documentation`, for information on optimization flags and other Intel compiler options.

#### [GNU Compilers](#building-gnu) { #building-gnu }

The GNU foundation maintains a number of high quality compilers, including a compiler for C (gcc), C++ (g++), and Fortran (gfortran). The gcc compiler is the foundation underneath all three, and the term "gcc" often means the suite of these three GNU compilers.

Load a gcc module to access a recent version of the GNU compiler suite. Avoid using the GNU compilers that are available without a gcc module — those will be older versions based on the "system gcc" that comes as part of the Linux distribution.

Here are simple examples that use the GNU compilers to produce an executable from source code:

	$ gcc mycode.c                    # C source file; executable a.out
	$ gcc mycode.c          -o myexe  # C source file; executable myexe
	$ g++ mycode.cpp        -o myexe  # C++ source file
	$ gfortran mycode.f90   -o myexe  # Fortran90 source file
	$ gcc -fopenmp mycode.c -o myexe  # OpenMP; GNU flag is different than Intel

Note that some compiler options are the same for both Intel and GNU (e.g. `-o`), while others are different (e.g. `-qopenmp` vs `-fopenmp`). Many options are available in one compiler suite but not the other. See the online GNU documentation for information on optimization flags and other GNU compiler options.

### [Compiling and Linking](#buildings-steps) { #buildings-steps }

Building an executable requires two separate steps: (1) compiling (generating a binary object file associated with each source file); and (2) linking (combining those object files into a single executable file that also specifies the libraries that executable needs). The examples in the previous section accomplish these two steps in a single call to the compiler. When building more sophisticated applications or libraries, however, it is often necessary or helpful to accomplish these two steps separately.

Use the `-c` ("compile") flag to produce object files from source files:

	$ icx -c main.c calc.c results.c

Barring errors, this command will produce object files main.o, calc.o, and results.o. Syntax for the Intel and GNU compilers is similar.

You can now link the object files to produce an executable file:

	$ icx main.o calc.o results.o -o myexe

The compiler calls a linker utility (usually `/bin/ld`) to accomplish this task. Again, syntax for other compilers is similar.

### [Include and Library Paths](#building-paths) { #building-paths }

Software often depends on pre-compiled binaries called libraries. When this is true, compiling usually requires using the `-I` option to specify paths to so-called header or include files that define interfaces to the procedures and data in those libraries. Similarly, linking often requires using the `-L` option to specify paths to the libraries themselves. Typical compile and link lines might look like this:

	$ icx        -c main.c -I${WORK}/mylib/inc -I${TACC_HDF5_INC}                  # compile
	$ icx main.o -o myexe  -L${WORK}/mylib/lib -L${TACC_HDF5_LIB} -lmylib -lhdf5   # link

On Stampede3, both the hdf5 and phdf5 modules define the environment variables `$TACC_HDF5_INC` and `$TACC_HDF5_LIB`. Other module files define similar environment variables; see Using Modules to Manage Your Environment for more information.

The details of the linking process vary, and order sometimes matters. Much depends on the type of library: static (`.a` suffix; library's binary code becomes part of executable image at link time) versus dynamically-linked shared (`.so` suffix; library's binary code is not part of executable; it's located and loaded into memory at run time).  However, the `$LD_LIBRARY_PATH` environment variable specifies the search path for dynamic libraries. For software installed at the system-level, TACC's modules generally modify `LD_LIBRARY_PATH` automatically. To see whether and how an executable named myexe resolves dependencies on dynamically linked libraries, execute ldd myexe.

<!-- Consult the [Intel Math Kernel Library]() (MKL) section below. -->

<!-- ### [Compiling and Linking MPI Programs](#building-mpi) { #building-mpi } -->
### [MPI Programs](#building-mpi) { #building-mpi }

Intel MPI (module impi) and MVAPICH2 (module mvapich2) are the two MPI libraries available on Stampede3. After loading an impi or mvapich2 module, compile and/or link using an MPI wrapper (`mpicc`, `mpicxx`, `mpif90`) in place of the compiler:

```
$ mpicc    mycode.c   -o myexe   # C source, full build
$ mpicc    -c mycode.c           # C source, compile without linking
$ mpicxx   mycode.cpp -o myexe   # C++ source, full build
$ mpif90   mycode.f90 -o myexe   # Fortran source, full build
```

These wrappers call the compiler with the options, include paths, and libraries necessary to produce an MPI executable using the MPI module you're using. To see the effect of a given wrapper, call it with the `-show` option:

```cmd-line
$ mpicc -show  # Show compile line generated by call to mpicc; similarly for other wrappers
```

### [Building Third-Party Software](#building-thirdparty) { #building-thirdparty }

You are welcome to download third-party research software and install it in your own account. In most cases you'll want to download the source code and build the software so it's compatible with the Stampede3 software environment. 

!!! Warning 
	You cannot use the `sudo` command or any package manager or installation process that requires elevated or "root" user privileges.


Instead, the key is to specify an installation directory for which you have write permissions. Details vary; you should consult the package's documentation and be prepared to experiment. Using the [three-step autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html) build process, the standard approach is to use the `PREFIX` environment variable to specify a non-default, user-owned installation directory at the time you execute `configure` or `make`:

	$ export INSTALLDIR=$WORK/apps/t3pio
	$ ./configure --prefix=$INSTALLDIR
	$ make
	$ make install

CMake based installations have a similar workflow where you specify the install location. Unlike with configure, you create a separate build location and tell cmake where to find the source:

``` cmd-line
$ mkdir build && cd build
$ cmake -D CMAKE_INSTALL_PREFIX=$WORK/apps/yourpackage /home/you/src/yourpackage
$ make
$ make install
```

Many packages at TACC set the `CMAKE_PREFIX_PATH` or `PKG_CONFIG_PATH` environment variables in their respective modulefiles, so that dependent modules are found automatically. See the [package documentation](https://cmake.org/getting-started/) for other CMake options. 

Other languages, frameworks, and build systems generally have equivalent mechanisms for installing software in user space. In most cases a web search like "Python Linux install local" will get you the information you need.

In Python, a local install will resemble one of the following examples:

	$ pip install netCDF4     --user                    # install netCDF4 package to $HOME/.local
	$ python setup.py install --user                    # install to $HOME/.local
	$ pip install netCDF4     --prefix=$INSTALLDIR      # custom location; add to PYTHONPATH

Similarly in R:

	$ module load Rstats            # load TACC's default R
	$ R                             # launch R
	> install.packages('devtools')  # R will prompt for install location

You may, of course, need to customize the build process in other ways. It's likely, for example, that you'll need to edit a makefile or other build artifacts to specify Stampede3-specific include and library paths or other compiler settings. A good way to proceed is to write a shell script that implements the entire process: definitions of environment variables, module commands, and calls to the build utilities. Include echo statements with appropriate diagnostics. Run the script until you encounter an error. Research and fix the current problem. Document your experience in the script itself; including dead-ends, alternatives, and lessons learned. Re-run the script to get to the next error, then repeat until done. When you're finished, you'll have a repeatable process that you can archive until it's time to update the software or move to a new machine.

If you wish to share a software package with collaborators, you may need to modify file permissions. See [Sharing Files with Collaborators](../../tutorials/sharingprojectfiles) for more information.

### [Performance](#building-performance) { #building-performance }

#### [Compiler Options](#building-performance-compiler) { #building-performance-compiler }

When building software on Stampede3, we recommend using the most recent Intel compiler and Intel MPI library available on Stampede3. The most recent versions may be newer than the defaults. Execute `module spider intel` and `module spider impi` to see what's installed. When loading these modules you may need to specify version numbers explicitly (e.g. `module load intel/24.0` and `module load impi/21.11`).

#### [Architecture-Specific Flags](#building-performance-archflags) { #building-performance-archflags }

To compile for for all the CPU platforms, include `-xCORE-AVX512` as a build option. The `-x` switch allows you to specify a target architecture.  The `-xCORE-AVX512` is a common subset of Intel's Advanced Vector Extensions 512-bit instruction set that is supported on SPR, ICX, and SKX.  There are some additional 512 bit optimizations implemented for machine learning on Sapphire Rapids.  Besides all other appropriate compiler options, you should also consider specifying an optimization level using the `-O` flag:

	$ icc   -xCORE-AVX512  -O3 mycode.c   -o myexe         # will run only on KNL

Similarly, to build for SKX or ICX, specify the CORE-AVX512 instruction set, which is native to SKX and ICX:

	$ ifort -xCORE-AVX512 -O3 mycode.f90 -o myexe         # will run on SKX or ICX

It's best to avoid building with `-xHost` (a flag that means "optimize for the architecture on which I'm compiling now"). The login nodes are SPR nodes.  Using `-xHost` might include AVX512 instructions that are only supported on SPR nodes. 

Don't skip the `-x` flag in a build: the default is the very old SSE2 (Pentium 4) instruction set. On Stampede3, the module files for the Intel compilers define the environment variable `$TACC_VEC_FLAGS` that stores the recommended architecture flag described above. This can simplify your builds:

	$ echo $TACC_VEC_FLAGS                         
	-xCORE-AVX512
	$ icc $TACC_VEC_FLAGS -O3 mycode.c -o myexe

If you use GNU compilers, see GNU x86 Options for information regarding support for SPR, ICX and SKX. 

## [Job Scripts](#scripts) { #scripts }

This section provides sample Slurm job scripts for each Stampede3 node type: 

* Ponte Vecchio (PVC),
* Sapphire Rapids (SPR),
* Ice Lake (ICX),
* Sky Lake (SKX).

Each section also contains sample scripts for serial, MPI, OpenMP and hybrid (MPI + OpenMP) programming models.  Copy and customize each script for your own applications.

### [PVC Nodes](#scripts-pvc) { #scripts-pvc }

*Coming Soon*

### [SPR Nodes](#scripts-spr) { #scripts-spr }

Click on a tab for a customizable job-script.

/// tab | MPI Job in Normal Queue
``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SPR nodes
#
#   *** MPI Job on SPR Normal Queue ***
# 
# Last revised: 14 Dec 2023
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch spr.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per SPR node: 112
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      on more nodes using fewer tasks and/or threads 
#      per node to give each task access to more memory.
#
#   -- Don't worry about task layout.  By default, ibrun
#      will provide proper affinity and pinning.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p spr-normal      # Queue (partition) name
#SBATCH -N 4               # Total # of nodes 
#SBATCH -n 448             # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...
module list
pwd
date

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec
```
///

/// tab | OpenMP Job in Normal Queue
``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SPR nodes
#
#   *** OpenMP Job on SPR Normal Queue ***
# 
# Last revised: 14 Dec 2023
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch spr.openmp.slurm" on a Stampede3 login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 80 (1 thread per core) but may be higher.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p spr-normal      # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for OpenMP)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for OpenMP)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Set thread count (default value is 1)...

export OMP_NUM_THREADS=112   # this is 1 thread/core; may want to start lower

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch OpenMP code...

./myprogram         # Do not use ibrun or any other MPI launcher
```
///

/// tab | Hybrid Job in Normal Queue
``` job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script
# for TACC Stampede3 SPR nodes
#
#   *** Hybrid Job on SPR Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         28 OpenMP threads per MPI task (112 threads per node)
#
# Last revised: 14 Dec 2023
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch spr.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- In most cases it's best to keep
#      ( MPI ranks per node ) x ( threads per rank )
#      to a number no more than 112 (total cores).
#
#   -- If you're running out of memory, try running
#      fewer tasks and/or threads per node to give each 
#      process access to more memory.
#
#   -- If you're running out of memory, try running
#      on more nodes using fewer tasks and/or threads 
#      per node to give each task access to more memory.
#
#   -- Don't worry about task layout.  By default, ibrun
#      will provide proper affinity and pinning.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p icx-normal      # Queue (partition) name
#SBATCH -N 10              # Total # of nodes 
#SBATCH -n 40              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Set thread count (default value is 1)...

export OMP_NUM_THREADS=28

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///

### [ICX Nodes](#scripts-icx) { #scripts-icx }

Click on a tab for a customizable job-script.

/// tab | MPI Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 ICX nodes
#
#   *** MPI Job on ICX Normal Queue ***
# 
# Last revised: 09 Mar 2022
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch icx.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per ICX node: 80
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      on more nodes using fewer tasks and/or threads 
#      per node to give each task access to more memory.
#
#   -- Don't worry about task layout.  By default, ibrun
#      will provide proper affinity and pinning.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p icx-normal      # Queue (partition) name
#SBATCH -N 4               # Total # of nodes 
#SBATCH -n 320             # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
/// 

/// tab | OpenMP Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
#
# Sample Slurm job script
#   for TACC Stampede3 ICX nodes
#
#   *** OpenMP Job on ICX Normal Queue ***
# 
# Last revised: 09 Mar 2022
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch icx.openmp.slurm" on a Stampede3 login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 80 (1 thread per core) but may be higher.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p icx-normal      # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for OpenMP)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for OpenMP)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Set thread count (default value is 1)...

export OMP_NUM_THREADS=80   # this is 1 thread/core; may want to start lower

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch OpenMP code...

./myprogram         # Do not use ibrun or any other MPI launcher

```
/// 

/// tab | Hybrid Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script
# for TACC Stampede3 ICX nodes
#
#   *** Hybrid Job on ICX Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         20 OpenMP threads per MPI task (80 threads per node)
#
# Last revised: 09 Mar 2022
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch icx.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- In most cases it's best to keep
#      ( MPI ranks per node ) x ( threads per rank )
#      to a number no more than 80 (total cores).
#
#   -- If you're running out of memory, try running
#      fewer tasks and/or threads per node to give each 
#      process access to more memory.
#
#   -- If you're running out of memory, try running
#      on more nodes using fewer tasks and/or threads 
#      per node to give each task access to more memory.
#
#   -- Don't worry about task layout.  By default, ibrun
#      will provide proper affinity and pinning.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and executable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p icx-normal      # Queue (partition) name
#SBATCH -N 10              # Total # of nodes 
#SBATCH -n 40              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Set thread count (default value is 1)...

export OMP_NUM_THREADS=20

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///

### [SKX Nodes](#scripts-skx) { #scripts-skx }

Click on a tab for a customizable job-script.

/// tab | Serial Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SKX nodes
#
#   *** Serial Job on SKX Normal Queue ***
# 
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch skx.serial.slurm" on a Stampede3 login node.
#
#   -- Serial codes run on a single node (upper case N = 1).
#        A serial code ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- For a good way to run multiple serial executables at the
#        same time, execute "module load launcher" followed
#        by "module help launcher".
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p skx-normal      # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Launch serial code...

./myprogram         # Do not use ibrun or any other MPI launcher

# ---------------------------------------------------
```
///
/// tab | MPI Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SKX nodes
#
#   *** MPI Job on SKX Normal Queue ***
# 
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch skx.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per SKX node: 48
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      fewer tasks per node to give each task more memory.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p skx-normal      # Queue (partition) name
#SBATCH -N 4               # Total # of nodes 
#SBATCH -n 32              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///
/// tab | OpenMP Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SKX nodes
#
#   *** OpenMP Job on SKX Normal Queue ***
# 
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch skx.openmp.slurm" on a Stampede3 login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 48 (1 thread per core) but may be higher.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p skx-normal      # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for OpenMP)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for OpenMP)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Set thread count (default value is 1)...

export OMP_NUM_THREADS=48   # this is 1 thread/core; may want to start lower

# Launch OpenMP code...

./myprogram         # Do not use ibrun or any other MPI launcher

```
///

/// tab | Hybrid Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script
# for TACC Stampede3 SKX nodes
#
#   *** Hybrid Job on SKX Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         12 OpenMP threads per MPI task (48 threads per node)
#
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch skx.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- In most cases it's best to keep
#      ( MPI ranks per node ) x ( threads per rank )
#      to a number no more than 48 (total cores).
#
#      process access to more memory.
#
#   -- IMPI and MVAPICH2 both do sensible process pinning by default.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p skx-normal      # Queue (partition) name
#SBATCH -N 10              # Total # of nodes 
#SBATCH -n 40              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Set thread count (default value is 1)...

export OMP_NUM_THREADS=12

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///

## [Job Management](#jobs) { #jobs }

In this section, we present several Slurm commands and other utilities that are available to help you plan and track your job submissions as well as check the status of the Slurm queues.

!!!important
	When interpreting queue and job status, remember that **Stampede3 does not operate on a first-come-first-served basis**. Instead, the sophisticated, tunable algorithms built into Slurm attempt to keep the system busy, while scheduling jobs in a way that is as fair as possible to everyone. At times this means leaving nodes idle ("draining the queue") to make room for a large job that would otherwise never run. It also means considering each user's "fair share", scheduling jobs so that those who haven't run jobs recently may have a slightly higher priority than those who have.

### [Monitoring Queue Status](#jobs-monitoring) { #jobs-monitoring }

#### [TACC's `qlimits` command](#jobs-monitoring-qlimits) { #jobs-monitoring-qlimits }

To display resource limits for the Lonestar queues, execute: `qlimits`. The result is real-time data; the corresponding information in this document's [table of Stampede3 queues](#queues) may lag behind the actual configuration that the `qlimits` utility displays.

#### [Slurm's `sinfo` command](#jobs-monitoring-sinfo) { #jobs-monitoring-sinfo }

Slurm's `sinfo` command allows you to monitor the status of the queues. If you execute `sinfo` without arguments, you'll see a list of every node in the system together with its status. To skip the node list and produce a tight, alphabetized summary of the available queues and their status, execute:

```cmd-line
login1$ sinfo -S+P -o "%18P %8a %20F"    # compact summary of queue status
```

This command's output might look like this:

```cmd-line
PARTITION          AVAIL    NODES(A/I/O/T)
icx                up       103/2/7/112
skx                up       402/6/32/440
skx-dev*           up       6/70/4/80
```
	
The `AVAIL` column displays the overall status of each queue (up or down), while the column labeled `NODES(A/I/O/T)` shows the number of nodes in each of several states ("**A**llocated", "**I**dle", "**O**ffline", and "**T**otal"). Execute `man sinfo` for more information. Use caution when reading the generic documentation, however: some available fields are not meaningful or are misleading on Stampede3 (e.g. `TIMELIMIT`, displayed using the `%l` option).

### [Monitoring Job Status](#jobs-monitoring-jobstatus) { #jobs-monitoring-jobstatus }

#### [Slurm's `squeue` command](#sjobs-monitoring-queuestatus) { #sjobs-monitoring-queuestatus }

Slurm's `squeue` command displays the state of all queued and running jobs.  

```cmd-line
login1$ squeue             # show all jobs in all queues
login1$ squeue -u bjones   # show all jobs owned by bjones
login1$ man squeue         # more info
```

Pending jobs appear in order of decreasing priority. Tack on the `-u` option to display only your jobs:

<figure id="squeuefigure">
```cmd-line
login1$ squeue -u slindsey | more
JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
10454         icx l4chcoo2 tg123456 PD       0:00      1 (QOSMaxJobsPerUserLimit)
 8018         icx l4bident tg123456  R   14:57:56      1 c461-218
10945         icx SM34_687 slindsey  R      27:30     10 c463-[218-227]
10940         icx SM34_685 slindsey  R      28:44      1 c463-214
 8936         icx  mark5.1   bjones  R   21:53:14     12 c460-207,c461-[206-212,221-224]
 9795         icx  mark1.2   bjones  R   12:08:59     10 c460-[220-227],c461-[219-220]
10956         icx       i2 sniffjck  R      14:14      4 c460-[208-211]
10997         skx     NAME rtoscano CG       1:13      4 c477-[092-094,101]
10996         skx     NAME rtoscano CG       2:44      4 c479-034,c490-[082-084]
 9609         skx sample-s tg987654 PD       0:00      1 (QOSMaxJobsPerUserLimit)
11002         skx     NAME  ashleyp PD       0:00      4 (Priority)
11004         skx     NAME  ashleyp PD       0:00      4 (Priority)
11000         skx     NAME  ashleyp PD       0:00      4 (Resources)
10673         skx trD4.204 jemerson PD       0:00      4 (Dependency)
10457         skx l4dimcha tg123456 PD       0:00      2 (QOSMaxJobsPerUserLimit)
10563         skx lcdm_bas kellygue PD       0:00      1 (Dependency)
10961         skx    d2_12 tg111111 PD       0:00      1 (QOSMaxJobsPerUserLimit)
```
</figure><figcaption>Figure 2. Sample <code>squeue</code> output</figcaption></figure>

<!-- The default format for `squeue` now reports total nodes associated with a job rather than cores, tasks, or hardware threads. One reason for this change is clarity: the operating system sees each compute node's SDL56 hardware threads as "processors", and output based on that information can be ambiguous or otherwise difficult to interpret. -->

!!!tip
	The `squeue`'s default format lists all nodes assigned to displayed jobs; this can make the output difficult to read. A handy variation that suppresses the nodelist is:

	```cmd-line
	login1$ squeue -o "%.10i %.12P %.12j %.9u %.2t %.9M %.6D"  # suppress nodelist
	```

!!!tip
	The `--start` option to the `squeue` displays job start times, including very rough estimates for the expected start times of some pending jobs that are relatively high in the queue:

	```cmd-line
	login1$ squeue --start -j 167635     # display estimated start time for job 167635
	```

#### [Queue Status Meanings](#jobs-monitoring-sqeue-status) { #jobs-monitoring-sqeue-status }

The `squeue` command's output displays two columns of interest.  See [Figure 2](#squeuefigure). above for sample output.

The column labeled `ST` displays each job's status: 

* `PD` means "Pending" (waiting); 
* `R`  means "Running";
* `CG` means "Completing" (cleaning up after exiting the job script).

#### [Table 7. Pending Jobs Reason](#table7) { #table7 }

The last column, labeled `NODELIST/REASON`, includes a nodelist for running/completing jobs, or a reason for pending jobs.  

`NODELIST/REASON` | Description
--- | ---
`Resources`       | The necessary combination of nodes/GPUs for your job are not available
`Priority`        | There are other jobs in the queue with a higher priority 
`Dependency`      | The job will not start until the dependency specified by you is satisfied.
`ReqNodeNotAvailable` | If you submit a job before a scheduled system maintenance period, and the job cannot complete before the maintenance begins, your job will run when the maintenance/reservation concludes.  The job will remain in the `PD` state until Stampede3 returns to production.
`QOSMaxJobsPerUserLimit` | The number of your jobs queued exceeds that [queue's limits](#jobs-monitoring-qlimits). These jobs will run once your previous jobs have ended.


<!-- `(QOS<something>)` | This tells you which limit the job is exceeding in the particular QOS. For example, QOSGrpCpuLimit means that the jobs running in that QOS (e.g., long) are using all of the allotted resources as set by the GrpTRES value. In this case, simply wait and your job will run. Run the qos command to see the limits. The number of "procs" or CPU-cores in use per QOS is displayed at the bottom of the output. One sees that "Grp" relates to the QOS and not to your research group. -->



#### [TACC's `showq` utility](#jobs-monitoring-showq) { #jobs-monitoring-showq }

TACC's `showq` utility mimics a tool that originated in the PBS project, and serves as a popular alternative to the Slurm `squeue` command:

```cmd-line
login1$ showq                 # show all jobs; default format
login1$ showq -u              # show your own jobs
login1$ showq -U bjones       # show jobs associated with user bjones
login1$ showq -h              # more info
```

The output groups jobs in four categories: `ACTIVE`, `WAITING`, `BLOCKED`, and `COMPLETING/ERRORED`. A `BLOCKED` job is one that cannot yet run due to temporary circumstances (e.g. a pending maintenance or other large reservation.).

If your waiting job cannot complete before a maintenance/reservation begins, `showq` will display its state as `**WaitNod**` ("Waiting for Nodes"). The job will remain in this state until Stampede3 returns to production.

<!-- old text The default format for `showq` now reports total nodes associated with a job rather than cores, tasks, or hardware threads. One reason for this change is clarity: the operating system sees each compute node's hardware threads as "processors", and output based on that information can be ambiguous or otherwise difficult to interpret. -->

Since TACC charges by the node rather than core, `showq`'s default format now reports total nodes associated with a job rather than cores, tasks, or hardware threads.  Run `showq` with the `-l` option to display the number of cores and the job's queue.



### [Dependent Jobs using `sbatch`](#jobs-dependencies) { #jobs-dependencies }

You can use `sbatch` to help manage workflows that involve multiple steps: the `--dependency` option allows you to launch jobs that depend on the completion (or successful completion) of another job. For example you could use this technique to split into three jobs a workflow that requires you to (1) compile on a single node; then (2) compute on 40 nodes; then finally (3) post-process your results using 4 nodes. 

``` cmd-line
login1$ sbatch --dependency=afterok:173210 myjobscript
```

For more information see the [Slurm online documentation](http://www.schedmd.com). Note that you can use `$SLURM_JOBID` from one job to find the jobid you'll need to construct the `sbatch` launch line for a subsequent one. But also remember that you can't use `sbatch` to submit a job from a compute node.


### [Other Job Management Commands](#jobs-other) { #jobs-other }

Use `scancel` to remove one of your jobs from the queue., 
Use `scontrol`to , and `sacct`

!!! warning
	It is not possible to add resources to a job (e.g. allow more time) once you've submitted the job to the queue.

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

## [Machine Learning](#ml) { #ml }

*Coming soon*

## [Help Desk](#help) { #help }

TACC Consulting operates from 8am to 5pm CST, Monday through Friday, except for holidays. You can [submit a help desk ticket][HELPDESK] at any time via the TACC User Portal with &quot;Stampede3&quot; in the Resource field. Help the consulting staff help you by following these best practices when submitting tickets. 

* **Do your homework** before submitting a help desk ticket. What does the user guide and other documentation say? Search the internet for key phrases in your error logs; that's probably what the consultants answering your ticket are going to do. What have you changed since the last time your job succeeded?

* **Describe your issue as precisely and completely as you can:** what you did, what happened, verbatim error messages, other meaningful output. When appropriate, include the information a consultant would need to find your artifacts and understand your workflow: e.g. the directory containing your build and/or job script; the modules you were using; relevant job numbers; and recent changes in your workflow that could affect or explain the behavior you're observing.

* **[Subscribe to Stampede3 User News][TACCSUBSCRIBE].** This is the best way to keep abreast of maintenance schedules, system outages, and other general interest items.

* **Have realistic expectations.** Consultants can address system issues and answer questions about Stampede3. But they can't teach parallel programming in a ticket, and may know nothing about the package you downloaded. They may offer general advice that will help you build, debug, optimize, or modify your code, but you shouldn't expect them to do these things for you.

* **Be patient.** It may take a business day for a consultant to get back to you, especially if your issue is complex. It might take an exchange or two before you and the consultant are on the same page. If the admins disable your account, it's not punitive. When the file system is in danger of crashing, or a login node hangs, they don't have time to notify you before taking action.

[HELPDESK]: https://tacc.utexas.edu/about/help/ "Help Desk"
[CREATETICKET]: https://tacc.utexas.edu/about/help/ "Create Support Ticket"
[SUBMITTICKET]: https://tacc.utexas.edu/about/help/ "Submit Support Ticket"
[TACCUSERPORTAL]: https://tacc.utexas.edu/portal/login "TACC Portal login"
[TACCPORTALLOGIN]: https://tacc.utexas.edu/portal/login "TACC Portal login"
[TACCUSAGEPOLICY]: https://tacc.utexas.edu/use-tacc/user-policies/ "TACC Usage Policy"
[TACCALLOCATIONS]: https://tacc.utexas.edu/use-tacc/allocations/ "TACC Allocations"
[TACCSUBSCRIBE]: https://accounts.tacc.utexas.edu/subscriptions "Subscribe to News"
[TACCDASHBOARD]: https://tacc.utexas.edu/portal/dashboard "TACC Dashboard"
[TACCPROJECTS]: https://tacc.utexas.edu/portal/projects "Projects & Allocations"


[TACCANALYSISPORTAL]: http://tap.tacc.utexas.edu "TACC Analysis Portal"

[TACCLMOD]: https://lmod.readthedocs.io/en/latest/ "Lmod"
[DOWNLOADCYBERDUCK]: https://cyberduck.io/download/ "Download Cyberduck"


[TACCREMOTEDESKTOPACCESS]: https://docs.tacc.utexas.edu/tutorials/remotedesktopaccess "TACC Remote Desktop Access"
[TACCSHARINGPROJECTFILES]: https://docs.tacc.utexas.edu/tutorials/sharingprojectfiles "Sharing Project Files"
[TACCBASHQUICKSTART]: https://docs.tacc.utexas.edu/tutorials/bashstartup "Bash Quick Start Guide"
[TACCACCESSCONTROLLISTS]: https://docs.tacc.utexas.edu/tutorials/acls "Access Control Lists"
[TACCMFA]: https://docs.tacc.utexas.edu/basics/mfa "Multi-Factor Authentication at TACC""
[TACCIDEV]: https://docs.tacc.utexas.edu/software/idev "idev at TACC""


