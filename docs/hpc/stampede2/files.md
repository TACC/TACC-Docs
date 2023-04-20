## [Managing Your Files](#files) { #files }

Stampede2 mounts three file Lustre file systems that are shared across all nodes: the home, work, and scratch file systems. Stampede2's startup mechanisms define corresponding account-level environment variables `$HOME`, `$SCRATCH`, and `$WORK` that store the paths to directories that you own on each of these file systems. Consult the [Stampede2 File Systems](#table3) table for the basic characteristics of these file systems, [File Operations: I/O Performance](#programming-fileio) for advice on performance issues, and [Good Conduct](../../basics/conduct) for tips on file system etiquette.


### [Navigating the Shared File Systems](#files-filesystems) { #files-filesystems }

Stampede2's `/home` and `/scratch` file systems are mounted only on Stampede2, but the work file system mounted on Stampede2 is the Global Shared File System hosted on [Stockyard](https://www.tacc.utexas.edu/systems/stockyard). Stockyard is the same work file system that is currently available on Frontera, Lonestar6, and several other TACC resources. 

The `$STOCKYARD` environment variable points to the highest-level directory that you own on the Global Shared File System. The definition of the `$STOCKYARD` environment variable is of course account-specific, but you will see the same value on all TACC systems that provide access to the Global Shared File System. This directory is an excellent place to store files you want to access regularly from multiple TACC resources.

Your account-specific `$WORK` environment variable varies from system to system and is a sub-directory of `$STOCKYARD` ([Figure 3](#figure3)). The sub-directory name corresponds to the associated TACC resource. The `$WORK` environment variable on Stampede2 points to the `$STOCKYARD/stampede2` subdirectory, a convenient location for files you use and jobs you run on Stampede2. Remember, however, that all subdirectories contained in your `$STOCKYARD` directory are available to you from any system that mounts the file system. If you have accounts on both Stampede2 and Frontera, for example, the `$STOCKYARD/stampede2` directory is available from your Frontera account, and `$STOCKYARD/frontera` is available from your Stampede2 account. 

!!! note
	Your quota and reported usage on the Global Shared File System reflects all files that you own on Stockyard, regardless of their actual location on the file system.

See the example for fictitious user `bjones` in the figure below. All directories are accessible from all systems, however a given sub-directory (e.g. `lonestar6`, `frontera`) will exist **only** if you have an allocation on that system.  Figure 3 illustrates account-level directories on the `$WORK` file system (Global Shared File System hosted on Stockyard). Example for fictitious user `bjones`. All directories usable from all systems. Sub-directories (e.g. `lonestar6`, `frontera`) exist only when you have allocations on the associated system.

<figure id="figure3"><img border="1" alt="Stockyard 2022" src="../../imgs/stockyard-2022.jpg"<figcaption>Figure 3.</figcaption></figure>

Note that resource-specific sub-directories of `$STOCKYARD` are nothing more than convenient ways to manage your <u>resource-specific</u> files. You have access to any such <u>sub-directory</u> from any TACC resources. If you are logged into Stampede2, for example, executing the alias `cdw` (equivalent to `cd $WORK`) will take you to the <u>resource-specific</u> <u>sub-directory</u> `$STOCKYARD/stampede2`. But you can access this directory from other TACC systems as well by executing `cd $STOCKYARD/stampede2`. These commands allow you to share files across TACC systems. In fact, several convenient <u>account-level</u> aliases make it even easier to navigate across the directories you own in the shared file systems:

[Table 4. Built-in Account Level Aliases](#table4) { #table4 }

Alias | Command
--- | ---
<code>cd</code> or <code>cdh</code> | <code>cd $HOME</code>
<code>cdw</code> | <code>cd $WORK</code>
<code>cds</code> | <code>cd $SCRATCH</code>
<code>cdy</code> or <code>cdg</code> | <code>cd $STOCKYARD</code>

### [Striping Large Files](#files-striping) { #files-striping }

Stampede2's Lustre file systems look and act like a single logical hard disk, but are actually sophisticated integrated systems involving many physical drives (dozens of physical drives for `$HOME`, hundreds for `$WORK` and `$SCRATCH`).

Lustre can **stripe** (distribute) large files over several physical disks, making it possible to deliver the high performance needed to service input/output (I/O) requests from hundreds of users across thousands of nodes. Object Storage Targets (OSTs) manage the file system's spinning disks: a file with 16 stripes, for example, is distributed across 16 OSTs. One designated Meta-Data Server (MDS) tracks the OSTs assigned to a file, as well as the file's descriptive data.

!!! tip
	Before transferring to, or creating large files on Stampede2, be sure to set an appropriate default stripe count on the receiving directory.

To avoid exceeding your fair share of any given OST, a good rule of thumb is to allow at least one stripe for each 100GB in the file. For example, to set the default stripe count on the current directory to 30 (a plausible stripe count for a directory receiving a file approaching 3TB in size), execute:

``` cmd-line 
$ lfs setstripe -c 30 $PWD
```

Note that an `lfs setstripe` command always sets both stripe count and stripe size, even if you explicitly specify only one or the other. Since the example above does not explicitly specify stripe size, the command will set the stripe size on the directory to Stampede2's system default (1MB). In general there's no need to customize stripe size when creating or transferring files.

Remember that it's not possible to change the striping on a file that already exists. Moreover, the `mv` command has no effect on a file's striping if the source and destination directories are on the same file system. You can, of course, use the `cp` command to create a second copy with different striping; to do so, copy the file to a directory with the intended stripe parameters.

You can check the stripe count of a file using the `lfs getstripe` command:

``` cmd-line 
$ lfs getstripe myfile
```

## [Transferring Files](#transferring) { #transferring }

### [with `scp`](#transferring-scp) { #transferring-scp }

You can transfer files between Stampede2 and Linux-based systems using either [`scp`](http://linux.com/learn/intro-to-linux/2017/2/how-securely-transfer-files-between-servers-scp) or [`rsync`](http://linux.com/learn/get-know-rsync). Both `scp` and `rsync` are available in the Mac Terminal app. Windows [ssh clients](#access-ssh) typically include `scp`-based file transfer capabilities.

The Linux `scp` (secure copy) utility is a component of the OpenSSH suite. Assuming your Stampede2 username is `bjones`, a simple `scp` transfer that pushes a file named `myfile` from your local Linux system to Stampede2 `$HOME` would look like this:

``` cmd-line 
localhost$ scp ./myfile bjones@stampede2.tacc.utexas.edu:  # note colon after net address
```

You can use wildcards, but you need to be careful about when and where you want wildcard expansion to occur. For example, to push all files ending in `.txt` from the current directory on your local machine to `/work/01234/bjones/scripts` on Stampede2:

``` cmd-line 
localhost$ scp *.txt bjones@stampede2.tacc.utexas.edu:/work/01234/bjones/stampede2
```

To delay wildcard expansion until reaching Stampede2, use a backslash (`\`) as an escape character before the wildcard. For example, to pull all files ending in `.txt` from `/work/01234/bjones/scripts` on Stampede2 to the current directory on your local system:

``` cmd-line 
localhost$ scp bjones@stampede2.tacc.utexas.edu:/work/01234/bjones/stampede2/\*.txt .
```

You can of course use shell or environment variables in your calls to `scp`. For example:

``` cmd-line
localhost$ destdir="/work/01234/bjones/stampede2/data"
localhost$ scp ./myfile bjones@stampede2.tacc.utexas.edu:$destdir
```

You can also issue `scp` commands on your local client that use Stampede2 environment variables like `$HOME`, `$WORK`, and `$SCRATCH`. To do so, use a backslash (`\`) as an escape character before the `$`; this ensures that expansion occurs after establishing the connection to Stampede2:

``` cmd-line 
localhost$ scp ./myfile bjones@stampede2.tacc.utexas.edu:\$WORK/data   # Note backslash
```

Avoid using `scp` for recursive (`-r`) transfers of directories that contain nested directories of many small files:

``` cmd-line 
localhost$ <s>scp -r  ./mydata     bjones@stampede2.tacc.utexas.edu:\$WORK  # DON'T DO THIS
```

Instead, use `tar` to create an archive of the directory, then transfer the directory as a single file:

``` cmd-line
localhost$ tar cvf ./mydata.tar mydata</b>                                   # create archive
localhost$ scp     ./mydata.tar bjones@stampede2.tacc.utexas.edu:\$WORK  # transfer archive
```

### [with `rsync`](#transferring-rsync) { #transferring-rsync }

The `rsync` (remote synchronization) utility is a great way to synchronize files that you maintain on more than one system: when you transfer files using `rsync`, the utility copies only the changed portions of individual files. As a result, `rsync` is especially efficient when you only need to update a small fraction of a large dataset. The basic syntax is similar to `scp`:

``` cmd-line
localhost$ rsync       mybigfile bjones@stampede2.tacc.utexas.edu:\$WORK/data
localhost$ rsync -avtr mybigdir  bjones@stampede2.tacc.utexas.edu:\$WORK/data
```

The options on the second transfer are typical and appropriate when synching a directory: this is a recursive update (`-r`) with verbose (`-v`) feedback; the synchronization preserves time stamps (`-t`) as well as symbolic links and other meta-data (`-a`). Because `rsync` only transfers changes, recursive updates with `rsync` may be less demanding than an equivalent recursive transfer with `scp`.

See [Striping Large Files](#files-striping) for additional important advice about striping the receiving directory when transferring or creating large files on TACC systems. 

As detailed in [Good Conduct](../../basics/conduct), it is important to monitor your quotas on the `$HOME` and `$WORK` file systems, and limit the number of simultaneous transfers. Remember also that `$STOCKYARD` (and your `$WORK` directory on each TACC resource) is available from several other TACC systems: there's no need for `scp` when both the source and destination involve sub-directories of `$STOCKYARD`. See [Managing Your Files](#files) for more information about transfers on `$STOCKYARD`.

### [with  Grid Community Toolkit](#transferring-gct) { #transferring-gct }

The Grid Community Toolkit (GCT) is an open-source fork of the [Globus Toolkit](http://toolkit.globus.org/toolkit) and was created in response to the [end-of-support](https://github.com/globus/globus-toolkit/blob/globus_6_branch/support-changes.md) of the Globus Toolkit in January 2018.

Stampede2 has two endpoints, one running Globus gridftp v5.4 software available for [ACCESS](http://access-ci.org) (formerly XSEDE) users, and the endpoint running Grid Community Toolkit with CILogon authentication available to all.  

### [Sharing Files with Collaborators](#files-sharing) { #files-sharing }

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems][TACCSHARINGPROJECTFILES] for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.

