## Managing Files { #files }

{% include 'include/spacetip.md' %}

### Table 3. File Systems { #table3 }

File System | Quota | Key Features
--- | --- | ---
<code>$HOME</code> | 10 GB | 200,000 files<br><b>Not intended for parallel or high-intensity file operations.</b><br>NFS file system<br>Backed up regularly.<br>Overall capacity 7 TB<br>Not purged.
<code>$WORK</code> | 1 TB<br>3,000,000 files<br>Across all TACC systems | <b>Not intended for high-intensity file operations or jobs involving very large files.</b><br>Lustre file system<br>On the Global Shared File System that is mounted on most TACC systems.<br>See Stockyard system description for more information.<br>Defaults: 1 stripe, 1MB stripe size<br>Not backed up.<br>Not purged.
<code>$SCRATCH</code> | none | Overall capacity 8 PB<br>Defaults: 4 targets, 512 KB chunk size<br>Not backed up<br><b>Files are [subject to purge](#scratchpolicy) if access time* is more than 10 days old.</b><sup><a href="#sup1">&#42;</a></sup>
<code>/tmp</code> on nodes | 288 GB | Data purged at the end of each job.<br>Access is local to the node.<br>Data in /tmp is not shared across nodes.


{% include 'include/corraltip.md' %}

{% include 'include/scratchpolicy.md' %}

### Navigating the Shared File Systems { #files-navigating }

Lonestar6 mounts three Lustre file systems that are shared across all nodes: the home, work, and scratch file systems. Lonestar6's startup mechanisms define corresponding account-level environment variables `$HOME`, `$SCRATCH` and `$WORK` that store the paths to directories that you own on each of these file systems. Consult the [Lonestar6 File Systems](#table3) table above for the basic characteristics of these file systems, <!--"File Operations: I/O Performance" for advice on performance issues,--> and the [Good Conduct][TACCGOODCONDUCT] document for guidance on file system etiquette.

Lonestar6's `/home` and `/scratch` file systems are mounted only on Lonestar6, but the `/work` file system mounted on Lonestar6 is the Global Shared File System hosted on Stockyard. This is the same work file system that is currently available on Frontera, Stampede3 and most other TACC resources.

The `$STOCKYARD` environment variable points to the highest-level directory that you own on the Global Shared File System. The definition of the `$STOCKYARD` environment variable is of course account-specific, but you will see the same value on all TACC systems that provide access to the Global Shared File System (see [Table 3](#table3)). This directory is an excellent place to store files you want to access regularly from multiple TACC resources. 

<figure id="figure1">
<img src="../imgs/stockyard-2024.png">
<figcaption>Figure 1. Account-level directories on the <code>/work</code> file system (Global Shared File System hosted on Stockyard). Example for fictitious user <code>bjones</code>. All directories usable from all systems. Sub-directories (e.g. <code>stampede3</code>, <code>frontera</code>) exist only when you have allocations on the associated system.</figcaption></figure>

Your account-specific `$WORK` environment variable varies from system to system and is a subdirectory of `$STOCKYARD` ([Figure 1](#figure1)). The subdirectory name corresponds to the associated TACC resource. The `$WORK` environment variable on Lonestar6 points to the `$STOCKYARD/ls6` subdirectory, a convenient location for files you use and jobs you run on Lonestar6. Remember, however, that all subdirectories contained in your `$STOCKYARD` directory are available to you from any system that mounts the file system. If you have accounts on both Lonestar6 and Stampede3, for example, the `$STOCKYARD/ls6` directory is available from your Stampede3 account, and `$STOCKYARD/stampede3` directory is available from your Lonestar6 account. Your quota and reported usage on the Global Shared File System reflects **all files** that you own on Stockyard, regardless of their actual location on the file system.

Note that resource-specific subdirectories of `$STOCKYARD` are simply convenient ways to manage your resource-specific files. You have access to any such subdirectory from any TACC resources. If you are logged into Lonestar6, for example, executing the alias `cdw` (equivalent to `cd $WORK`) will take you to the resource-specific subdirectory `$STOCKYARD/ls6`. But you can access this directory from other TACC systems as well by executing `cd $STOCKYARD/ls6`. These commands allow you to share files across TACC systems. In fact, several convenient account-level aliases make it even easier to navigate across the directories you own in the shared file systems:

#### Table 4. Built-in Account Level Aliases { #table4 }

Alias | Command
--- | ---
<code>cd</code> or <code>cdh</code> | <code>cd $HOME</code>
<code>cds</code> | <code>cd $SCRATCH</code>
<code>cdy</code> or <code>cdg</code> | <code>cd $STOCKYARD</code>
<code>cdw</code> | <code>cd $WORK</code>

### Striping Large Files { #files-striping }

Lonestar6's BeeGFS and Lustre file systems look and act like a single logical hard disk, but are actually sophisticated integrated systems involving many physical drives. Lustre and BeeGFS can **stripe** (distribute 'chunk's) large files over several physical disks, making it possible to deliver the high performance needed to service input/output (I/O) requests from hundreds of users across thousands of nodes.  Object Storage Targets (OSTs) manage the file system's spinning disks: a file with 16 stripes, for example, is distributed across 16 OSTs. One designated Meta-Data Server (MDS) tracks the OSTs  assigned to a file, as well as the file's descriptive data.

The Lonestar6 `$SCRATCH` filesystem is a BeeGFS filesystem instead of a Lustre filesystem. However, the BeeGFS filesystem is similar to Lustre in that it distributes files across I/O servers and allows the user control over the stripe count and stripe size for directories. 

The `$WORK` file system has 24 I/O targets available, while the `$SCRATCH` file system has 96.  A good rule of thumb is to allow at least one stripe for each 100GB in the file not to exceed 75% of the available stripes.   So, the max stripe count for `$SCRATCH` would be 72, while that for `$WORK` would be 18.

!!! important
	Before transferring to, or creating large files on Lonestar6, be sure to set an appropriate default chunk/stripe count on the receiving directory.  

As an example, the following command sets the default stripe count on the current directory for a file 200 GB in size, then ensures that the operation was successful:

* If the destination directory is on the `$SCRATCH` file system:

		$ beegfs-ctl --setpattern --numtargets=20  $PWD
		$ beegfs-ctl --getentryinfo $PWD

* If the destination directory is on the `$WORK` file system:

		$ lfs setstripe -c 18 $PWD    #Use stripe count of 18 instead of 20 out of 24 total targets
		$ lfs getstripe $PWD    

!!! important
	It is not possible to change the stripe/chunk count on a file that already exists.  The `mv` command will have no effect on a file's striping unless the source and destination directories are on different file systems, e.g. `mv`ing a file from `$SCRATCH` to `$WORK`, or vice-versa.  Instead, use the `cp` command to copy the file to a directory with the intended stripe parameters.

Run the following for more information on these commands: 

	$ beegfs-ctl --setpattern --help 
	$ lfs help setstripe  

### Transferring your Files { #files-transferring }

#### Transferring with `scp` { #files-transferring-scp }

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

!!! note
	Using `scp` with wildcard expansion on the remote host is unreliable.  Specify absolute paths wherever possible.

<!--
You can of course use shell or environment variables in your calls to `scp`. For example:

```cmd-line
localhost$ destdir="/work/01234/bjones/ls6/data"
localhost$ scp ./myfile bjones@ls6.tacc.utexas.edu:$destdir
```

You can also issue `scp` commands on your local client that use Lonestar6 environment variables like `$HOME`, `$WORK`, and `$SCRATCH`. To do so, use a backslash (`\`) as an escape character before the `$`; this ensures that expansion occurs after establishing the connection to Lonestar6:

```cmd-line
localhost$ scp ./myfile bjones@ls6.tacc.utexas.edu:\$SCRATCH/data   # Note backslash
```
-->

Avoid using `scp` for recursive transfers of directories that contain nested directories of many small files:

```cmd-line
localhost$ scp -r ./mydata     bjones@ls6.tacc.utexas.edu:\$SCRATCH  # DON'T DO THIS
```

Instead, use `tar` to create an archive of the directory, then transfer the directory as a single file:

```cmd-line
localhost$ tar cvf ./mydata.tar mydata                                  # create archive
localhost$ scp     ./mydata.tar bjones@ls6.tacc.utexas.edu:\$WORK  # transfer archive
```

#### Transferring with `rsync` { #files-transferring-rsync }

The `rsync` (remote synchronization) utility is a great way to synchronize files that you maintain on more than one system: when you transfer files using `rsync`, the utility copies only the changed portions of individual files. As a result, `rsync` is especially efficient when you only need to update a small fraction of a large dataset. The basic syntax is similar to `scp`:

```cmd-line
localhost$ rsync       mybigfile bjones@ls6.tacc.utexas.edu:\$SCRATCH/data
localhost$ rsync -avtr mybigdir  bjones@ls6.tacc.utexas.edu:\$SCRATCH/data
```

The options on the second transfer are typical and appropriate when synching a directory: this is a <u>recursive update (`-r`)</u> with verbose (`-v`) feedback; the synchronization preserves <u>time stamps (`-t`)</u> as well as symbolic links and other meta-data (`-a`). Because `rsync` only transfers changes, recursive updates with `rsync` may be less demanding than an equivalent recursive transfer with `scp`.


### Sharing Files with Collaborators { #files-sharing }

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems][TACCSHARINGPROJECTFILES] for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.


