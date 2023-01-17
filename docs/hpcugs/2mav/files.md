## [Managing Your Files](#files) { #files }

Maverick2 mounts two Lustre file systems that are shared across all nodes: the home and work file systems. Maverick2's startup mechanisms define corresponding account-level environment variables, `$HOME` and `$WORK`, that store the paths to directories that you own on each of these file systems. Maverick2's home file system is mounted only on Maverick2, but the work file system mounted on Maverick2 is the Global Shared File System hosted on [Stockyard](https://www.tacc.utexas.edu/systems/stockyard). This is the same work file system that is currently available on Stampede2, Frontera, Lonestar6, and several other TACC resources.

Table 4. Maverick2 File Systems

File System | Quota | Key Features
--- | --- | ---
<code>$HOME</code> | 10GB, 200,000 files | <b>Not intended for parallel or high-intensity file operations.</b><br>Backed up regularly.<br>Overall capacity ~1PB. NFS-mounted. Two Meta-Data Servers (MDS), four Object Storage Targets (OSTs).<br>Defaults: 1 stripe, 1MB stripe size.<br>Not purged.</br>
<code>$WORK</code> | 1TB, 3,000,000 files across all TACC systems,<br>regardless of where on the file system the files reside.  | <b>Not intended for high-intensity file operations or jobs involving very large files.</b><br>On the Global Shared File System that is mounted on most TACC systems.<br>See <a href="https://www.tacc.utexas.edu/systems/stockyard">Stockyard system description</a> for more information.<br>Defaults: 1 stripe, 1MB stripe size<br>Not backed up.<br>Not purged.</br>
<code>$SCRATCH</code> | <b>N/A</b> | <b>Maverick2 does not mount a scratch file system.</b>

The `$STOCKYARD` environment variable points to the highest-level directory that you own on the Global Shared File System. The definition of the `$STOCKYARD` environment variable is of course account-specific, but you will see the same value on all TACC systems that provide access to the Global Shared File System (see [Figure 3](#figure3)). This directory is an excellent place to store files you want to access regularly from multiple TACC resources.

### [Navigating the Shared File Systems](#files-navigating) { #files-navigating }

Your account-specific `$WORK` environment variable varies from system to system and (except for the decommissioned Stampede1 system) is a sub-directory of `$STOCKYARD` ([Figure 3](#figure3)). The sub-directory name corresponds to the associated TACC resource. The `$WORK` environment variable on Maverick2 points to the `$STOCKYARD/maverick2` subdirectory, a convenient location for files you use and jobs you run on Maverick2. Remember, however, that all subdirectories contained in your `$STOCKYARD` directory are available to you from any system that mounts the file system. If you have accounts on both Maverick2 and Stampede2, for example, the `$STOCKYARD/maverick2` directory is available from your Stampede2 account, and `$STOCKYARD/stampede2` is available from your Maverick2 account. Your quota and reported usage on the Global Shared File System reflects all files that you own on Stockyard, regardless of their actual location on the file system.

<figure>
<img src="IMAGEDIR/stockyard-2022.jpg">
<figcaption>**Figure 3.** Account-level directories on the work file system (Global Shared File System hosted on Stockyard). Example for fictitious user `bjones`. All directories usable from all systems. Sub-directories (e.g. `frontera`, `maverick2`) exist only when you have allocations on the associated system.
</figcaption></figure>

Note that resource-specific NOWRAPsub-directoriesESPAN of `$STOCKYARD` are nothing more than convenient ways to manage your NOWRAPresource-specificESPAN files. You have access to any such NOWRAPsub-directoryESPAN from any TACC resources. If you are logged into Maverick2, for example, executing the alias `cdw` (equivalent to NOWRAP"`cd $WORK`"ESPAN) will take you to the NOWRAPresource-specificESPAN NOWRAPsub-directoryESPAN `$STOCKYARD/maverick2`. But you can access this directory from other TACC systems as well by executing NOWRAP"`cd $STOCKYARD/maverick2`"ESPAN. These commands allow you to share files across TACC systems. In fact, several convenient NOWRAPaccount-levelESPAN aliases make it even easier to navigate across the directories you own in the shared file systems:

#### [Table 5. Built-in Account Level Aliases](#table5) { #table5 }

Alias | Command
<code>cd</code> or <code>cdh</code> | <code>cd $HOME</code>
<code>cdw</code> | <code>cd $WORK</code>
<code>cdy</code> or <code>cdg</code> | <code>cd $STOCKYARD</code>


### [Transferring Files Using `scp` and `rsync`](#transferring-scp) { #transferring-scp }

You can transfer files between Maverick2 and Linux-based systems using either [`scp`](http://linux.com/learn/intro-to-linux/2017/2/how-securely-transfer-files-between-servers-scp) or [`rsync`](http://linux.com/learn/get-know-rsync). Both `scp` and `rsync` are available in the Mac Terminal app. Windows [ssh clients][STAMPEDE2UG#secure-shell-ssh] typically include `scp`-based file transfer capabilities.

The Linux `scp` (secure copy) utility is a component of the OpenSSH suite. Assuming your Maverick2 username is `bjones`, a simple `scp` transfer that pushes a file named "`myfile`" from your local Linux system to Maverick2 `$HOME` would look like this:

<pre class="cmd-line">localhost$ <b>scp ./myfile bjones@maverick2.tacc.utexas.edu:</b>  # note colon after net address</pre>

You can use wildcards, but you need to be careful about when and where you want wildcard expansion to occur. For example, to push all files ending in "`.txt`" from the current directory on your local machine to `/work/01234/bjones/scripts` on Maverick2:

<pre class="cmd-line">localhost$ <b>scp *.txt bjones@maverick2.tacc.utexas.edu:/work/01234/bjones/maverick2</b></pre>

To delay wildcard expansion until reaching Maverick2, use a backslash ("`\`") as an escape character before the wildcard. For example, to pull all files ending in "`.txt`" from `/work/01234/bjones/scripts` on Maverick2 to the current directory on your local system:

<pre class="cmd-line">localhost$ <b>scp bjones@maverick2.tacc.utexas.edu:/work/01234/bjones/maverick2/\*.txt .</b></pre>

You can of course use shell or environment variables in your calls to `scp`. For example:

<pre class="cmd-line">
localhost$ <b>destdir="/work/01234/bjones/maverick2/data"</b>
localhost$ <b>scp ./myfile bjones@maverick2.tacc.utexas.edu:$destdir</b></pre>

You can also issue `scp` commands on your local client that use Maverick2 environment variables like `$HOME` and `$WORK`. To do so, use a backslash ("`\`") as an escape character before the "`$`"; this ensures that expansion occurs after establishing the connection to Maverick2:

<pre class="cmd-line">localhost$ <b>scp ./myfile bjones@maverick2.tacc.utexas.edu:\$WORK/data</b>   # Note backslash</pre>

Avoid using `scp` for recursive ("`-r`") transfers of directories that contain nested directories of many small files:

<pre class="cmd-line">localhost$ <s><b>scp -r  ./mydata     bjones@maverick2.tacc.utexas.edu:\$WORK</b></s>  # DON'T DO THIS</pre>

Instead, use `tar` to create an archive of the directory, then transfer the directory as a single file:

<pre class="cmd-line">
localhost$ <b>tar cvf ./mydata.tar mydata</b>                                   # create archive
localhost$ <b>scp     ./mydata.tar bjones@maverick2.tacc.utexas.edu:\$WORK</b>  # transfer archive</pre>

The `rsync` (remote synchronization) utility is a great way to synchronize files that you maintain on more than one system: when you transfer files using `rsync`, the utility copies only the changed portions of individual files. As a result, `rsync` is especially efficient when you only need to update a small fraction of a large dataset. The basic syntax is similar to `scp`:

<pre class="cmd-line">
localhost$ <b>rsync       mybigfile bjones@maverick2.tacc.utexas.edu:\$WORK/data</b>
localhost$ <b>rsync -avtr mybigdir  bjones@maverick2.tacc.utexas.edu:\$WORK/data</b></pre>

The options on the second transfer are typical and appropriate when synching a directory: this is a recursive update ("`-r`") with verbose ("`-v`") feedback; the synchronization preserves time stamps ("`-t`") as well as symbolic links and other meta-data ("`-a`"). Because `rsync` only transfers changes, recursive updates with `rsync` may be less demanding than an equivalent recursive transfer with `scp`.

See [Good Conduct](#conduct) for additional important advice about striping the receiving directory when transferring large files; watching your quota on `$HOME` and `$WORK`; and limiting the number of simultaneous transfers. Remember also that `$STOCKYARD` (and your `$WORK` directory on each TACC resource) is available from several other TACC systems: there's no need for `scp` when both the source and destination involve sub-directories of `$STOCKYARD`. See [Managing Your Files](#files) for more information about transfers on `$STOCKYARD`.


### [Sharing Files with Collaborators](#files-sharing) { #files-sharing }

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems](http://portal.tacc.utexas.edu/tutorials/sharing-project-files) for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.

### [Notes on Small Files Under Lustre](#files-smallfiles) { #files-smallfiles }

The Stockyard/`$WORK` file system is a Lustre file system which is optimized for large scale reads and writes. As some workloads, such as image classification, leverage using multiple small files, we advise users not work directly on `$WORK` with these workloads. Users should have their jobs copy these files to `/tmp` on the compute node, compute against the `/tmp` data, store their results on the `$WORK` file system, and clean up `/tmp`. We are currently working on solutions to expand the 60 GB `/tmp` capacity. 

### [Striping Large Files](#files-striping) { #files-striping }

Lustre can **stripe** (distribute) large files over several physical disks, making it possible to deliver the high performance needed to service input/output (I/O) requests from hundreds of users across thousands of nodes. Object Storage Targets (OSTs) manage the file system's spinning disks: a file with 20 stripes, for example, is distributed across 20 OSTs. One designated Meta-Data Server (MDS) tracks the OSTs assigned to a file, as well as the file's descriptive data.

Before transferring large files to Maverick2, or creating new large files, be sure to set an appropriate default stripe count on the receiving directory. To avoid exceeding your fair share of any given OST, a good rule of thumb is to allow at least one stripe for each 100GB in the file. For example, to set the default stripe count on the current directory to 30 (a plausible stripe count for a directory receiving a file approaching 3TB in size), execute:

<pre class="cmd-line">$ <b>lfs setstripe -c 30 $PWD</b></pre>

Note that an "`lfs setstripe`" command always sets both stripe count and stripe size, even if you explicitly specify only one or the other. Since the example above does not explicitly specify stripe size, the command will set the stripe size on the directory to Maverick2's system default (1MB). In general there's no need to customize stripe size when creating or transferring files.

Remember that it's not possible to change the striping on a file that already exists. Moreover, the "`mv`" command has no effect on a file's striping if the source and destination directories are on the same file system. You can, of course, use the "`cp`" command to create a second copy with different striping; to do so, copy the file to a directory with the intended stripe parameters.



