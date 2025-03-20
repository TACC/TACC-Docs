## Data Transfer { #datatransfer }
*Last update: March 4, 2025*

This guide will outline and instruct methods of transferring data between TACC resources and and your local machine.  Transfer methods generally fall into two categories:

1. Graphical User Interface (GUI) tools, e.g. [Globus](#globus), [Cyberduck](#datatransfer-cyberduck).
1. Command-line (CLI) tools e.g. `scp`, `sftp`, `rsync`

!!! important
	Connection to third-party storage services, e.g. UTBox, DropBox; is [not supported](#datatransfer-thirdparty).


### Cyberduck { #datatransfer-cyberduck }

TACC staff recommends the open-source [Cyberduck](https://cyberduck.io/) utility for both Windows and Mac users that do not already have a preferred tool.

<a target="_blank" href="https://cyberduck.io/">Cyberduck</a> is a free graphical user interface for data transfer and is an alternative to using the command line. With a drag-and-drop interface, it is easy to transfer a file from your local system to the remote secure system. You can use <a target="_blank" href="https://cyberduck.io/">Cyberduck</a> for Windows or macOS.

<img alt="cyberduck logo" src="../../../imgs/cyberduck.jpg"> [Download Cyberduck][DOWNLOADCYBERDUCK]

Click on the "Open Connection" button in the top right corner of the Cyberduck window to open a connection configuration window (as shown below) transfer mechanism, and type in the server name "**`frontera.tacc.utexas.edu`**". Add your username and password in the spaces provided, and if the "more options" area is not shown click the small triangle or button to expand the window; this will allow you to enter the path to your project area so that when Cyberduck opens the connection you will immediately see your data. Then click the "Connect" button to open your connection.

Once installed, click "Open Connection" in the top left corner of your Cyberduck window.

Once connected, you can navigate through your remote file hierarchy using familiar graphical navigation techniques. You may also drag-and-drop files into and out of the Cyberduck window to transfer files to and from Frontera.


<!-- <figure id="figure2"><img src="../imgs/dtg-2-open-connection-context.png" />
<figcaption>Figure 2. Windows Cyberduck and "Open Connection" set up screen<figcaption></figure> -->

To set up a connection, type in the server name, host. Add your TACC username and password in the spaces provided. If the "More Options" area is not shown, click the small triangle button to expand the window; this will allow you to enter the path to your transfer directory, `/transfer/directory/path`, so that when Cyberduck opens the connection you will immediately be in your individualized transfer directory on the system. Click the "Connect" button to open your connection.

<!-- Consult Figure 2. below to ensure the information you have provided is correct.  *If you have not done so already, replace the "Path" with the path to your individualized transfer directory.* -->

<figure id="figure2"><img alt="Cyberduck-SSH" src="../imgs/cyberduck-ssh.png" width="500px"><figcaption>Figure 2. Cyberduck connection setup screen</figcaption></figure>


!!! note
	You will be prompted to "allow unknown fingerprint" upon connection. Select "allow" and then enter your TACC token value.
      
Once connected, you can navigate through your remote file hierarchy using the graphical user interface. You may also drag-and-drop files from your local computer into the Cyberduck window to transfer files to the system.
      
<!-- !!! note
	You cannot select "Open Connection" in the top left corner of your Cyberduck window as macOS' set up screen is missing the "More Options" button. -->
      
<!-- To set up a connection using "New Bookmark", type in the server name, host. Add your TACC username and password in the spaces provided. If the "More Options" area is not shown, click the small triangle or button to expand the window; this will allow you to enter the path to your transfer directory, /transfer/directory/path, so that when Cyberduck opens the connection you will immediately be in your individualized transfer directory on the system. As you fill out the information, Cyberduck will create the bookmark for you. Exit out of the set up screen and click on your newly created bookmark to launch the connection.
      
<figure id="figure4"><img src="../imgs/dtg-4-new-bookmark.png" width="75%">
<figcaption>Figure 4. macOS "New Bookmark" set up screen</figcaption></figure>
      
Consult Figure 4. above to ensure the information you have provided is correct.  *If you have not done so already, replace the "Path" with the path to your individualized transfer directory.*
      
Once connected, you can navigate through your remote file hierarchy using the graphical user interface. You may also drag-and-drop files from your local computer into the Cyberduck window to transfer files to the storage system.

-->


### Globus Data Transfer Guide { #globus }

Globus supplies high speed, reliable, asynchronous transfers to the portal. Globus is fast, for large volumes of data, as it uses multiple network sockets simultaneously to transfer data. It is reliable for large numbers of directories and files, as it can automatically fail and restart itself, and will only notify you when the transfers are completed successfully.

This document leads you through the steps required to set up Globus to use for the first time. Several steps will need to be repeated each time you set up a new computer to use Globus for the portal. Once you are set up, you can use Globus not only for transfers to and from the portal, but also to access other cyberinfrastructure resources at TACC and around the world.

To start using Globus, you need to do two things: Generate a unique identifier, <a href="#1">an ePPN<sup>&#42;</a></sup>, for all Globus services, and enroll the machine you are transferring data to/from with Globus.  This can be your personal laptop or desktop, or a server to which you have access. Follow this one-time process to set up the Globus file transfer capability.

!!! Note 
	**Globus Transition**. Globus has transitioned to version 5.4. This transition impacts all TACC researchers who use Globus and requires you to update your profile with an ePPN to continue using the Globus service. The use of "Distinguished Names", or DNs, is no longer supported.

!!! important 
	You must use your institution's credentials and **not your personal email account (e.g. Google, Yahoo!, AOL)** when setting up Globus.  You will encounter problems with the transfer endpoints (e.g. Frontera, Stampede3, Corral, Ranch) if you use your personal account information.


#### Step 1. **Retrieve your Unique ePPN**.  { #step1 }

Login to [CILogon](https://cilogon.org) and click on "User Attributes".  Make note of your ePPN.

<figure id="figure4">
<img src="../imgs/globus-CIlogin.png" style="width:65%"> 
<figcaption>Figure 4. Make note of your ePPN</figcaption>
</figure>

#### Step 2. **Associate your EPPN with your TACC Account.**  { #step2 }

Login to the [TACC Accounts Portal][TACCACCOUNTS], click "Account Information" in the left-hand menu, then add or edit your ePPN from Step 1.


!!! important
	The institution (ePPN) listed in your TACC account profile, must map to the ePPN you are using to log into GlobusOnline.  


<figure id="figure5">
<img src="../imgs/globus-setup-step2.png" style="width:65%">
<figcaption>Figure 5. Update your TACC user profile.</figcaption>
</figure>

!!! tip
	Once you update your ePPN, please allow up to 2 hours for the changes to propagate across TACC systems.


#### Step 3. **Globus File Manager** { #step3 }

Once you've completed these steps, you will be able to use the [Globus File Manager](https://app.globus.org) as usual.  If you encounter any issues, please [submit a support ticket](https://tacc.utexas.edu/portal/tickets).



### SSH Command-Line Tools  { #cli }

<!-- Introduce - scp, rsync, sftp
Examples with Corral -->

Transfer files between TACC HPC resources and other Linux-based systems using either [`scp`](http://linux.com/learn/intro-to-linux/2017/2/how-securely-transfer-files-between-servers-scp) or [`rsync`](http://linux.com/learn/get-know-rsync). Both `scp` and `rsync` are available in the Mac Terminal app. Windows SSH clients typically include `scp`-based file transfer capabilities.

The `scp` and `rsync` commands are standard UNIX data transfer mechanisms used to transfer moderate size files and data collections between systems. These applications use a single thread to transfer each file one at a time. The `scp` and `rsync` utilities are typically the best methods when transferring Gigabytes of data.  For larger data transfers, parallel data transfer mechanisms, e.g., Grid Community Toolkit, can often improve total throughput and reliability.

!!! note
	It is possible to use these command line tools if your local machine runs Windows, but you will need to use a ssh client (ex. [CyberDuck][DOWNLOADCYBERDUCK]).

To simplify the data transfer process, we recommend that Windows users follow the <a href="#datatransfer-cyberduck">How to Transfer Data with Cyberduck</a> guide as detailed below.


#### Using `scp` 


The Linux `scp` (secure copy) utility is a component of the OpenSSH suite. Assuming your Lonestar6 username is `bjones`, a simple `scp` transfer that pushes a file named `myfile` from your local Linux system to Lonestar6 `$HOME` would look like this:

```cmd-line
localhost$ scp ./myfile bjones@ls6.tacc.utexas.edu:  # note colon at end of line
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
	Using `scp` with wildcard expansion on the **remote host** is unreliable.  Specify absolute paths wherever possible.

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

Consult the `scp` man pages for more information:

```cmd-line
login1$ man scp
```

#### Transferring Files with `rsync` { #transferring-rsync } 

The `rsync` (remote synchronization) utility is another way to keep your data up to date. In contrast to `scp`, `rsync` transfers only the actual changed parts of a file (instead of transferring an entire file). Hence, this selective method of data transfer can be much more efficient than `scp`. The following example demonstrates usage of the `rsync` command for transferring a file named `myfile.c` from its current location on Stampede to Frontera's `$DATA` directory.

```cmd-line
localhost$ rsync       mybigfile bjones@frontera.tacc.utexas.edu:\$WORK/data
localhost$ rsync -avtr mybigdir  bjones@frontera.tacc.utexas.edu:\$WORK/data
```

The options on the second transfer are typical and appropriate when synching a directory: this is a **recursive update (`-r`)** with verbose (`-v`) feedback; the synchronization preserves **time stamps (`-t`)</u> as well as symbolic links and other meta-data (`-a`). Because `rsync` only transfers changes, recursive updates with `rsync` may be less demanding than an equivalent recursive transfer with `scp`.


!!! tip
	See [Good Conduct][TACCGOODCONDUCT] for additional important advice about striping the receiving directory when transferring large files; watching your quota on `$HOME` and `$WORK`; and limiting the number of simultaneous transfers. 

!!! tip
	Remember that `$STOCKYARD` (and your `$WORK` directory on each TACC resource) is available from several other TACC systems: there's no need for `scp` when both the source and destination involve subdirectories of `$STOCKYARD`. 


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

!!! Warning
	When executing multiple instantiations of any of the commands listed above, `scp`, `sftp` and `rsync`, limit your active transfers to no more than 2-3 processes at a time.


#### Transfer with `sftp` { #cli-sftp }

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


### UTBox and other Third-Party Storage Services { #datatransfer-thirdparty }

Unfortunately TACC does not allow direct access from UT Box or other third-party storage services such as Dropbox, Google or Amazon storage services. To transfer files from one of these services:

1. Manually download the files from one of these services to your laptop
2. Using one of the tools outlined in this document (e.g. `scp` or Cyberduck), upload the files from your laptop to the desired TACC resource (e.g. Stampede3, Frontera).

If you have files stored at another university, see the [Globus instructions](#globus) above.


{% include 'aliases.md' %}

<!--
### Determining Paths { #cli-paths }

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
