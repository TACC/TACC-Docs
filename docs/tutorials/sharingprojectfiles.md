# Sharing Project Files on TACC Systems
*Last update: June 8, 2023* 


Collaborators on the same project/allocation often wish to share code, data or other project files with each other, but not necessarily with the world. Users with Educational allocations may wish to have a repository accessible to their students. This page will instruct allocation managers and their delegates how to set up a project workspace that is accessible only to users in the same allocation. 

## [TACC, UNIX groups and Project Numbers](#taccgroups) { #taccgroups }

All TACC system users are organized into UNIX "groups", collections of users who typically share the same permissions: read, write, execute or some combination thereof, including none, on a set of files or directories. Groups and group membership are created and assigned by a TACC system administrator upon user account creation. A user may belong to many groups but a file or directory is owned by only one owner and one group. For files and directories to be shared among a collection of users: 

1. Those users and files must belong to the same UNIX group
2. The file or directory's permissions must allow group read or write access

At TACC, users assigned to the same allocated project typically belong to the same UNIX group. This group number will (usually) correspond directly to the project/allocation number. To determine your project's UNIX group number, go to [Projects and Allocations][TACCALLOCATIONS] via your TACC Dashboard.

<figure id="figure1">
<img alt="Project Detail" border="1" src="../imgs/sharingfiles-1.png">
<figcaption></figcaption></figure>

Click on the "Project Detail" button to view the group number:

<figure id="figure2">
<img alt="Project's UNIX group number" border="1" src="../imgs/sharingfiles-1.png">
<figcaption></figcaption></figure>

In this case, Test Project XYZ's UNIX group ID (GID) is "G-816631". Therefore, all files to be associated with this project must belong to this group.

## [Display a File's Owner, Group and Permissions Information](#displaypermissions) { #displaypermissions }

The UNIX command `groups` displays all groups a user belongs to:

```cmd-line
login1$ groups slindsey
G-40300 G-80748 G-80906 G-801508 G-803450 G-803454 G-813602 G-816631
```

The first group listed, in this case `G-40300`, is the user's primary or default group, 

In the above output, the user `slindsey`'s primary or default group is G-40300, meaning that any files or directories this user creates will automatically belong to this group. However, Test Project XYZ's UNIX group is G-816631 as determined above.  

<!-- The user must therefore switch groups from their default group, G-40300, to the project's group, G-816631, via the UNIX `newgrp` command. <pre>login1$ <b>newgrp G-816631</b>

Now all files created by this user will belong to the project's group. Note that this command does not change the group or permissions of any files that have already been created. If the user's default group matches the project's group, then this step is not necessary.-->

To display a file's owner and group membership, use the `ls -l` command:

```cmd-line
login1$ ls -l myfile
-rw------- 1 slindsey G-40300 983 Nov 13 10:40 myfile
``` 

In the above output the file `myfile` is owned by user `slindsey` and belongs to the `G-40300` project/group. This file's permissions are set to read and write, `rw`, for the owner, `slindsey`, only.

Please consult the UNIX man pages for more information on these commands:

```cmd-line
login1$ man groups
login1$ man chgrp
```

## [Create a Shared Project Workspace](#createworkspace) { #createworkspace }

It is not possible to make a shared, writable directory under a user's `$HOME` directory and the `$SCRATCH` file system is subject to periodic purging. Therefore, TACC staff strongly recommends placing all files to be shared in the top level of the user's area of the `/work` filesystem, defined in the `$STOCKYARD` environment variable. This new shared directory will be accessible only to members of the unix group and by extension the project members.

Note that `$STOCKYARD` points to the highest level directory you own on Stockyard, TACC's [Global Shared File System](https://www.tacc.utexas.edu/systems/stockyard), which is mounted and available across all TACC systems. Your `$WORK` environment variable points to a resource-specific eponymous subdirectory of `$STOCKYARD`. For example on Stampede2, `$WORK` is defined as `$STOCKYARD/stampede2`.  All subdirectories are accessible to you on any TACC system where you have an allocation.

### [Readable](#createworkspace-read) { #createworkspace-read }

### [Writeable](#createworkspace-write) { #createworkspace-write }


1. Make your `$STOCKYARD` directory accessible, though not readable, to the group members:  

	```cmd-line
	login1$ chmod g+X $STOCKYARD
	```

1. Go to your work directory on Stockyard and create the sub-directory to be shared:

	```cmd-line
	login1$ cd $STOCKYARD; mkdir mysharedirectory
	```

	<!-- // insert permissions and gid stuff here -->

1. The directory with shared files then needs to belong to the group. This step may be redundant if the directory already belongs to the group:

	```cmd-line
	login1$ chgrp -R G-816631 mysharedirectory
	```

1. Set the shared directory's ownership and permissions. In this example, permissions will be set to owner:read, write, execute; group:read, execute, and no access to any users outside the group.  

	a. Set the group id bit. Any new files created in the shared directory will inherit the group ownership:

	```cmd-line
	login1$ chmod g+s mysharedirectory
	```

	b. Then edit your `.bashrc` and set the umask variable to "027". This ensures that all NEW files created will inherit the proper permissions.

		umask 027
	
	c. Last, set permissions to readable and accessible to group members:

	```cmd-line
	login1$ chmod g+rX mysharedirectory
	```

1. (optional) Grant write access to the directory. The project manager may wish to grant project collaborators write access to the directory or leave the directory as read-only.

	```cmd-line
	login1$ chmod g+rwX mysharedirectory
	```

Project members will now have read and write, or read-only access to this directory and its contents. 

Project managers should remind their users to set their shell's [umask](http://en.wikipedia.org/wiki/Umask) variable allowing other users to see their created files.  

```cmd-line
login1$ set umask 027
```

Many of these commands can be tricky. If you need assistance in setting up a shared project workspace, please [submit a help-desk ticket][HELPDESK]. See also the following man pages:

```cmd-line
login1$ man chmod
login1$ man chgrp
login1$ man umask
```

## [Adding users to TACC Projects](#addusers) { #addusers }

Principal Investigators (PIs) or their delegates can manage project membership through the [TACC User Portal][TACCUSERPORTAL] under Allocations. 

<figure id="figure3">
<img alt="Add users to project" src="../imgs/sharingfiles-1.png">
<figcaption></figcaption></figure>

## [References](#refs) { #refs }

<!-- * [TACC Projects &amp; Allocations][TACCPROJECTS] -->
<!-- * [How To: Manage Your Allocation](https://portal.tacc.utexas.edu/tutorials/managing-allocations) -->
* [Manage Permissions with Access Control Lists](../../tutorials/acls)

{% include 'aliases.md' %}

