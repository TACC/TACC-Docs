## [Transferring your Files](#transferring) { #transferring } 

There are several transfer mechanism for data to Frontera, some of which depend on where and how the data are to be stored.  Please review the following transfer mechanisms.

### [Windows Users](#transferring-windows) { #transferring-windows } 

TACC staff recommends the open-source [Cyberduck](https://cyberduck.io/) utility for both Windows and Mac users that do not already have a preferred tool.

<img alt="cyberduck logo" src="../../../imgs/cyberduck.jpg"> [Download Cyberduck](https://cyberduck.io/download/)

Click on the "Open Connection" button in the top right corner of the Cyberduck window to open a connection configuration window (as shown below) transfer mechanism, and type in the server name "**`frontera.tacc.utexas.edu`**". Add your username and password in the spaces provided, and if the "more options" area is not shown click the small triangle or button to expand the window; this will allow you to enter the path to your project area so that when Cyberduck opens the connection you will immediately see your data. Then click the "Connect" button to open your connection.

Once connected, you can navigate through your remote file hierarchy using familiar graphical navigation techniques. You may also drag-and-drop files into and out of the Cyberduck window to transfer files to and from Frontera.

<!-- IMAGE3 -->

### [Grid Community Toolkit](#transferring-gct) { #transferring-gct } 

The Grid Community Toolkit (GCT) is an open-source fork of the [Globus Toolkit](http://toolkit.globus.org/toolkit) and was created in response to the [end-of-support](https://github.com/globus/globus-toolkit/blob/globus_6_branch/support-changes.md) of the Globus Toolkit in January 2018.  

Frontera has one Grid Community Toolkit endpoint. All users may authenticate using the CILogon myproxy authentication. See [Using Grid Community Toolkit at TACC](../../tutorials/gridcommunitytoolkit) for detailed information.  

### [SSH Utilities: `scp` & `rsync`](#transferring-ssh) { #transferring-ssh } 

The `scp` and `rsync` commands are standard UNIX data transfer mechanisms used to transfer moderate size files and data collections between systems. These applications use a single thread to transfer each file one at a time. The `scp` and `rsync` utilities are typically the best methods when transferring Gigabytes of data.  For larger data transfers, parallel data transfer mechanisms, e.g., Grid Community Toolkit, can often improve total throughput and reliability.

You can transfer files between Frontera and Linux-based systems using either [`scp`](http://linux.com/learn/intro-to-linux/2017/2/how-securely-transfer-files-between-servers-scp) or [`rsync`](http://linux.com/learn/get-know-rsync). Both `scp` and `rsync` are available in the Mac Terminal app. Windows SSH clients, such as Cyberduck and [Filezilla](https://filezilla-project.org/), typically include `scp`-based file transfer capabilities.

#### [Transferring Files with **`scp`**](#transferring-scp) { #transferring-scp } 

Data transfer from any Linux system can be accomplished using the `scp` utility to copy data to and from the login node. A file can be copied from your local system to the remote server by using the command:

```cmd-line
localhost% scp filename \
TACC-username@frontera.tacc.utexas.edu:/path/to/project/directory
```

Consult the `scp` man pages for more information:

```cmd-line
login1$ man scp
```


The Linux `scp` (secure copy) utility is a component of the OpenSSH suite. Assuming your Frontera username is `bjones`, a simple `scp` transfer that pushes a file named `myfile` from your local Linux system to Frontera `$HOME` would look like this:

```cmd-line
localhost$ scp ./myfile bjones@frontera.tacc.utexas.edu:  # note colon after net address
```

You can use wildcards, but you need to be careful about when and where you want wildcard expansion to occur. For example, to push all files ending in `.txt` from the current directory on your local machine to `/work/01234/bjones/scripts` on Frontera:

```cmd-line
localhost$ scp *.txt bjones@frontera.tacc.utexas.edu:/work/01234/bjones/frontera
```

To delay wildcard expansion until reaching Frontera, use a backslash (`\`) as an escape character before the wildcard. For example, to pull all files ending in `.txt` from `/work/01234/bjones/scripts` on Frontera to the current directory on your local system:

```cmd-line
localhost$ scp bjones@frontera.tacc.utexas.edu:/work/01234/bjones/frontera/\*.txt .
```

!!! note
	Using `scp` with wildcard expansion on the remote host is unreliable.  Specify absolute paths wherever possible.

<!--
You can of course use shell or environment variables in your calls to `scp`. For example:

```cmd-line
localhost$ destdir="/work/01234/bjones/frontera/data"
localhost$ scp ./myfile bjones@frontera.tacc.utexas.edu:$destdir
```

You can also issue `scp` commands on your local client that use Frontera environment variables like `$HOME`, `$WORK`, and `$SCRATCH`. To do so, use a backslash (`\`) as an escape character before the `$`; this ensures that expansion occurs after establishing the connection to Frontera:

```cmd-line
localhost$ scp ./myfile bjones@frontera.tacc.utexas.edu:\$WORK/data   # Note backslash
```
-->

Avoid using `scp` for recursive transfers of directories that contain nested directories of many small files:

```cmd-line
localhost$ scp -r ./mydata     bjones@frontera.tacc.utexas.edu:\$WORK  # DON'T DO THIS
```

Instead, use `tar` to create an archive of the directory, then transfer the directory as a single file:

```cmd-line
localhost$ tar cvf ./mydata.tar mydata                                  # create archive
localhost$ scp     ./mydata.tar bjones@frontera.tacc.utexas.edu:\$WORK  # transfer archive
```

#### [Transferring Files with `rsync`](#transferring-rsync) { #transferring-rsync } 

The `rsync` (remote synchronization) utility is a great way to synchronize files that you maintain on more than one system: when you transfer files using `rsync`, the utility copies only the changed portions of individual files. As a result, `rsync` is especially efficient when you only need to update a small fraction of a large dataset. The basic syntax is similar to `scp`:

```cmd-line
localhost$ rsync       mybigfile bjones@frontera.tacc.utexas.edu:\$WORK/data
localhost$ rsync -avtr mybigdir  bjones@frontera.tacc.utexas.edu:\$WORK/data
```

The options on the second transfer are typical and appropriate when synching a directory: this is a <u>recursive update (`-r`)</u> with verbose (`-v`) feedback; the synchronization preserves <u>time stamps (`-t`)</u> as well as symbolic links and other meta-data (`-a`). Because `rsync` only transfers changes, recursive updates with `rsync` may be less demanding than an equivalent recursive transfer with `scp`.

See [Good Conduct](../../basics/conduct) for additional important advice about striping the receiving directory when transferring large files; watching your quota on `$HOME` and `$WORK`; and limiting the number of simultaneous transfers. Remember also that `$STOCKYARD` (and your `$WORK` directory on each TACC resource) is available from several other TACC systems: there's no need for `scp` when both the source and destination involve subdirectories of `$STOCKYARD`. 

The `rsync` command is another way to keep your data up to date. In contrast to `scp`, `rsync` transfers only the actual changed parts of a file (instead of transferring an entire file). Hence, this selective method of data transfer can be much more efficient than scp. The following example demonstrates usage of the `rsync` command for transferring a file named `myfile.c` from its current location on Stampede to Frontera's `$DATA` directory.

```cmd-line
login1$ rsync myfile.c \
TACC-username@frontera.tacc.utexas.edu:/data/01698/TACC-username/data
```

An entire directory can be transferred from source to destination by using `rsync` as well. For directory transfers the options `-avtr` will transfer the files recursively (`-r` option) along with the modification times (`-t` option) and in the archive mode (`-a` option) to preserve symbolic links, devices, attributes, permissions, ownerships, etc. The `-v` option (verbose) increases the amount of information displayed during any transfer. The following example demonstrates the usage of the `-avtr` options for transferring a directory named `gauss` from the present working directory on Stampede to a directory named `data` in the $WORK file system on Frontera.

```cmd-line
login1$ rsync -avtr ./gauss \
TACC-username@frontera.tacc.utexas.edu:/data/01698/TACC-username/data
```

For more `rsync` options and command details, run the command `rsync -h` or:

```cmd-line
login1$ man rsync
```

When executing multiple instantiations of `scp` or `rsync`, please limit your transfers to no more than 2-3 processes at a time.

### [Sharing Files with Collaborators](#transferring-sharing) { #transferring-sharing } 

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems][TACCSHARINGPROJECTFILES] for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.

