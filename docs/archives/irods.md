# iRODS at TACC
*Last update: November 28, 2017*

## [Introduction](#intro) { #intro }

iRODS is a data grid/data management tool. iRODS allows you to store data in a unified namespace using multiple storage resources, to replicate data so that copies exist on multiple systems, and to store checksums and arbitrary metadata with a file. The TACC iRODS configuration supports accessing iRODS through either the native iRODS tools such as the UNIX "i-Commands" or via the HTTPS and WebDAV protocols.

Each storage system accessed through iRODS is referred to as a "resource". In TACC's current [Corral](../../hpc/corral) configuration, there are two disk-based resources accessible through iRODS, one for each of the Corral filesystems. The unreplicated GPFS filesystem is referred to within iRODS as `corral-tacc` and the replicated filesystem is referred to as `corral-repl`. By default all data will be stored in the `corral-repl` file system.

### [Table 1. iRODS Resource Names and Corresponding Filesystems](#table1) { #table1 }

Resource Name | Storage System
--- | ---
<code>corral-repl</code> | Replicated GPFS file system (<code>corral-repl</code>
<code>corral-tacc</code> | TACC-only GPFS file system (<code>corral-tacc</code>

Access to the iRODS system on Corral is available only to allocated users who have requested it. If you wish to utilize iRODS for accessing Corral, please indicate so in your Corral allocation request. Users with existing allocations who wish to make use of iRODS should [submit a user support request][HELPDESK]. You may also email <a href="mailto:data@tacc.utexas.edu">data@tacc.utexas.edu</a> to discuss your data needs and we will be happy to make a recommendation on the best tools for managing your data.

Use of the Corral resource may be subject to allocation constraints.

## [iRODS Setup](#setup) { #setup }

### [Command-line Usage](#setup-cli) { #setup-cli }

The IRODS command-line utilities, collectively referred to as "i-commands", use a JSON configuration file to store iRODS initialization information under a user's home directory. A template version of that file is shown below in Example 1 below. To set up your computing environment, copy and paste this text into a file called `~/.irods/irods_environment.json`, then edit the file, replacing each instance of "USERNAME" with your TACC username. You may also change the `irods_default_resource` line to use a different default resource if you so choose. Once you have created and saved this file, you can issue the `iinit` command to start your iRODS session, after which you can store and retrieve data normally using the i-commands as documented below. If you will be accessing iRODS only through the WebDAV or other Web-based mechanisms you do not need to create this configuration file.

#### [Example 1. iRODS Configuration Template](#example1) { #example1 }

``` job-script
{
	"irods_host": "irods.corral.tacc.utexas.edu",
	"irods_port": 1247,
	"irods_authentication_scheme": "PAM",
	"irods_ssl_verify_server": "none",
	"irods_log_level": "DEBUG",
	"irods_default_resource": "corral-repl",
	"irods_home": "/corralZ/home/USERNAME",
	"irods_cwd": "/corralZ/home/USERNAME",
	"irods_user_name": "USERNAME",
	"irods_zone_name": "corralZ",
	"irods_client_server_negotiation": "request_server_negotiation",
	"irods_client_server_policy": "CS_NEG_REQUIRE",
	"irods_encryption_key_size": 32,
	"irods_encryption_salt_size": 8,
	"irods_encryption_num_hash_rounds": 16,
	"irods_encryption_algorithm": "AES-256-CBC",
	"irods_default_hash_scheme": "SHA256",
	"irods_match_hash_policy": "compatible",
	"irods_maximum_size_for_single_buffer_in_megabytes": 32,
	"irods_default_number_of_transfer_threads": 4,
	"irods_transfer_buffer_size_for_parallel_transfer_in_megabytes": 4
	}
```

### [GUI Usage](#setup-gui) { #setup-gui }

iRODS can be accessed via a Desktop GUI through the native support in the cross-platform Cyberduck file transfer client. Cyberduck is free, works on all major desktop platforms, and supports drag-and-drop operations from your desktop using the native iRODS protocol for high-performance network transfers. 

	https://web.corral.tacc.utexas.edu/irods-webdav/<i>PATH</i>

where "*`PATH`*" is replaced with the path to your data in iRODS e.g. `/corralZ/home/username`.

You can download Cyberduck for free from <https://cyberduck.io>. To connect to iRODS using the native iRODS plug-in for Cyberduck, download [this Cyberduck profile](../taccdocs/CyberduckProfile.cyberduckprofile) to your desktop and open it in Cyberduck, either by double-clicking it or by dragging and dropping it onto the Cyberduck icon. Fill in your TACC username, and enter your password when you first connect to the server, and you will see a directory listing. By default you will be placed in your home directory, but you can change the default starting location to be a project directory if you have a shared project folder you wish to use instead. Once you have initiated a connection to the iRODS server via Cyberduck, you can drag files or folders into the Cyberduck window to upload them, and drag them from the window onto the desktop to download them. Cyberduck will perform recursive uploads and downloads, i.e. dragging a folder into the Cyberduck window will upload both the folder and any files and folders contained within that folder.

## [Basic i-Commands](#icommands) { #icommands }

Once you have configured the `~/.irods/irods_environment.json` file, you can use i-commands to access and manipulate data in the system. The i-commands nomenclature mimcs that of UNIX but with an "i" prepended to the command name e.g. `ils`, `imkdir`, `icd`. Generally, i-commands are functionally equivalent to their UNIX counterparts. Complete <a href="https://docs.irods.org/master/icommands/user/">i-commands documentation</a> can be found on the iRODS site. The following table summarizes some of the most common i-commands.

### [Table 2. Common i-Commands](#table2) { #table2 }

i-Command | Syntax | Description
--- | --- | ---
<code><a href="https://docs.irods.org/4.1.10/icommands/user/#iinit">iinit</a></code> | <code>iinit <i>yourpassword</i></code> | initialize and start an iRODS session
<code><a href="https://docs.irods.org/4.1.10/icommands/user/#ils">ils</a></code> | <code>ils <i>file or directory</i></code> | like UNIX <code>ls</code>, list files or directories
<code><a href="https://docs.irods.org/4.1.10/icommands/user/#ilsresc">ilsresc</a></code> | <code>ilsresc</code> | list all iRODS resources
<code><a href="https://docs.irods.org/4.1.10/icommands/user/#iput">iput</a></code> | <code>iput -v <i>file</i> /corralZ/home/<i>user/dir</i></code> | store file/s into the system
<code><a href="https://docs.irods.org/4.1.10/icommands/user/#iget">iget</a></code> | <code>iget <i>file</i> /corralZ/home/<i>user/dir</i></code> | retrieve file/s from the system
<code><a href="https://docs.irods.org/4.1.10/icommands/user/#imkdir">imkdir</a></code> | <code>imkdir <i>new_directory</i></code> | like UNIX <code>mkdir</code>, create a new directory (collection)
<code><a href="https://docs.irods.org/4.1.10/icommands/user/#icp">icp</a></code> | <code>icp <i>source destination</i></code> | copy a file or directory, many options available


### [`irsync`](#icommands-irsync) { #icommands-irsync }

Use the `irsync` command to synchronize a local directory with iRODS, similar to the Unix rsync command. It can be used to make an exact copy of a directory hierarchy on a local disk within iRODS, or retrieve an exact copy of a directory hierarchy already stored in iRODS. It may also be used to create an exact copy of a file or directory within iRODS. iRODS paths are identified with an i: prefix in the `irsync` command.

For example, if you have created a directory within iRODS called `/corralZ/home/joeuser/myproject`, and you wish to retrieve an exact copy of that directory on Stampede, run the command:

``` cmd-line
login1$ irsync -r i:/corralZ/home/joeuser/myproject /path/to/joeusers/workdir
```

After editing the files on Stampede, you can then synchronize the data back into iRODS using the command:

``` cmd-line
login1$ irsync -r /path/to/joeusers/workdir i:/corralZ/home/joeuser/myproject
```

If you are storing or retrieving data to Ranch with the `-R ranch-main` option, you should also use the `-s` switch - this will use the size rather than the checksum of the file to determine whether synchronization is necessary, thereby avoiding the need to retrieve all the files from tape to compute checksums. This will greatly improve the performance of synchronization with Ranch.


### [`irm`](#icommands-irm) { #icommands-irm }

Use the `irm` command to remove files. By default, the `irm` command only moves files to a temporary "trash" folder, and these files can be restored at a later date or completely removed with the `irmtrash` command. You can use the `-f` switch to force deletion of the file immediately, but files removed with the force switch can not be recovered.

`irm` options include:

* `-f` force data removal
* `-v` for verbose
* `-r` for recursive
* `-h` for help


### [`ichmod`](#icommands-ichmod) { #icommands-ichmod }

All users can see all other users' collections and files but cannot access, (read, write or own), where they do not have permissions. The `ichmod` command, like the UNIX chmod command, allows a user to give file access permission to other users or groups. Note that iRODS only supports access control lists (ACLs), rather than the Unix-style user/group/other permissions structure. More information about ACLs is available in other TACC tutorials.

* **Read Permission**

	``` cmd-line
	login1$ ichmod read testuser testfile.txt 
	login1$ ils -A testfile.txt
	```

	The `ils -A` command shows the Access Control List (ACL) for the file `testfile.txt`. Here, `testuser` has been given read permission on `testfile`.

* **Ownership Permission**

	Giving another user ownership permission will enable them to change ACL for the file or folder. For example, to give `testuser` ownership permissions means `testuser` can then extend read/write/owner permissions to other users.

	``` cmd-line
	login1$ ichmod own testuser testfile.txt
	```

* **Removing Permissions**

	You can assign `null` to remove permissions from the ACL for a file or folder:

	``` cmd-line
	login1$ ichmod null testuser testfile.txt
	```

* **Inherit Permission**

	The "inherit" permission is a special type of permission you can assign to a directory, which causes all new files and folders created within that directory to have the same permissions as the parent. For example, you can grant read permissions to a specific user, add the inherit permission, then add a number of files to that directory, which will also have the read permissions assigned to the enclosing folder. This makes it easier to share files within a group or to copy complicated permissions structures to additional files.

	``` cmd-line
	login1$ ichmod inherit testuser myfolder
	```

`ichmod` command options include:

* `-v` for verbose
* `-r` for recursive
* `-R` for Resource

## [Installing the iRODS client](#installing) { #installing }

You may also use the iRODS i-Commands to view and manipulate your data, as well as storing and retrieving data, from your own desktop or laptop running a Redhat or Ubuntu-based version of Linux, by downloading and installing the iRODS client tools. iRODS binary package downloads and installation instructions are at <a href="https://irods.org/download/">https://irods.org/download/</a>.

## [References](#refs) { #refs }

See also:

* [Access Control Lists](../../tutorials/acls)


{% include 'aliases.md' %}
