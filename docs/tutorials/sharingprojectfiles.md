# Sharing Project Files on TACC Systems
*Last update: February 29, 2024* 


Collaborators on the same project/allocation often wish to share code, data or other project files with each other, but not necessarily with the world. Users with Educational allocations may wish to have a repository accessible to their students. This page will instruct allocation managers and their delegates how to set up a project workspace that is accessible only to users in the same allocation. 

## TACC, UNIX groups and Project Numbers { #taccgroups }

All TACC system users are organized into UNIX "groups", collections of users who typically share the same permissions: read, write, execute or some combination thereof, including none, on a set of files or directories. Groups and group membership are created and assigned by a TACC system administrator upon user account creation. A user may belong to many groups but a file or directory is owned by only one owner and one group. For files and directories to be shared among a collection of users: 

1. Those users and files must belong to the same UNIX group
2. The file or directory's permissions must allow group read or write access

At TACC, users assigned to the same allocated project typically belong to the same UNIX group. This group number will (usually) correspond directly to the project/allocation number. 

## Determine Project's GID { #projectgid }

To determine your project's UNIX group number (GID), log on to your TACC Dashboard and go to [Projects and Allocations][TACCALLOCATIONS].  Click on the "Project Detail" button to view the group number:

In [Figure 1.](#figure1) below, example project "UserServStaff" has Unix group ID (GID) "G-803077".  Therefore, when creating a shared file space for your project members, all files to be associated with this project must belong to this group.

<figure id="figure1">
<img alt="Project's Unix Group Number" width="800" src="../imgs/sharingprojectfiles-1.png">
<figcaption>Figure 1. Project's Unix Group Number</figcaption></figure>


## Determine your Default GID { #defaultgid }

Now that you know your project's GID, you can begin changing permissions to create a common shared file space.  
The UNIX command `groups` displays all groups a user belongs to:

<code>groups <i>username</i></code>

<pre>
login1$ <b>groups</b>
G-40300 G-25072 G-80748 G-80906 G-801508 <mark>G-803077</mark> G-803450 
</pre>

The first group listed, in this case `G-40300`, is this user's primary or default group, meaning that any files or directories this user creates will automatically belong to this group. However, we need our files to belong to project "UserServStaff" GID G-803077 as determined [above](#projectid).  

If your project GID and your default GID are the same, then skip to [Create A Shared Workspace](#workspace).  Otherwise, you must switch UNIX groups from your default group, in this example `G-40300`, to the project's group, `G-803077`, via the UNIX `newgrp` command. 

```syntax
newgrp groupid
```

```cmd-line
login1$ newgrp G-803077
```

Now all files created by you will belong to the project's group and you can proceed to [Create A Shared Workspace](#workspace).

!!! note
	The `newgrp` command does not change the group or permissions of any files that have *already been created*.  

!!! tip
	To display a file or directory's owner and group membership, use the `ls -l` command:

		login1$ ls -l myfile
		-rw------- 1 slindsey G-40300 983 Nov 13 10:40 myfile
		login1$ ls -l mydir
		drwxr-xr-x 4 slindsey G-40300 4096 Feb 14 16:14 mydir
		...

	In the above output the file `myfile` is owned by user `slindsey` and belongs to the `G-40300` group. This file's permissions are set to read and write, `rw`, for the owner, `slindsey`, only.


## Create a Shared Project Workspace { #workspace }

It is not possible to make a shared, writable directory under a user's `$HOME` directory and the `$SCRATCH` file system is subject to periodic purging. Therefore, TACC staff strongly recommends placing all files to be shared in the top level of the user's area of the `/work` filesystem, defined in the `$STOCKYARD` environment variable. This new shared directory will be accessible only to members of the unix group and by extension the project members.

!!! note
	The `$STOCKYARD` environment variable points to the highest level directory you own on Stockyard, TACC's [Global Shared File System](https://www.tacc.utexas.edu/systems/stockyard), which is mounted and available across all TACC systems. Your `$WORK` environment variable points to a resource-specific eponymous subdirectory of `$STOCKYARD`. For example on Stampede3, `$WORK` is defined as `$STOCKYARD/stampede3`.  All subdirectories are accessible to you on any TACC system where you have an allocation.


1. Make your `$STOCKYARD` directory accessible, though not readable, to the group members:  

	```cmd-line
	login1$ chmod g+X $STOCKYARD
	```

1. Go to your work directory on Stockyard and create the sub-directory to be shared:

	```cmd-line
	login1$ cd $STOCKYARD; mkdir mysharedirectory
	```

1. The directory with shared files then needs to belong to the group. This step may be redundant if the directory already belongs to the group:

	```cmd-line
	login1$ chgrp -R G-803077 mysharedirectory
	```

1. Set the shared directory's ownership and permissions. In this example, permissions will be set to 

	* owner:read, write, execute 
	* group:read, execute
	* other:no access to any users outside the group.  

	a. Set the group id bit. Any new files created in the shared directory will inherit the group ownership:

		login1$ chmod g+s mysharedirectory

	b. Then edit your `.bashrc` and set the umask variable to "027". This ensures that all NEW files created will inherit the proper permissions.

		umask 027
	
	c. Last, set permissions to readable and accessible to group members:

		login1$ chmod g+rX mysharedirectory

1. (optional) Grant write access to the directory. The project manager may wish to grant project collaborators write access to the directory or leave the directory as read-only.

		login1$ chmod g+rwX mysharedirectory

Project members will now have read and write, or read-only access to this directory and its contents. 

!!!caution
	Many of these commands can be tricky. If you need assistance in setting up a shared project workspace, please [submit a help-desk ticket][HELPDESK]. See also the following man pages:


!!!tip
	Allocation managers should remind their users to set their shell's [umask](http://en.wikipedia.org/wiki/Umask) variable allowing other users to see their created files.  

		login1$ set umask 027

<!--
## Adding users to TACC Projects { #addusers }

Allocation Managers can manage project membership via the [TACC User Portal][TACCUSERPORTAL] under Allocations. 

<figure id="figure3">
<img alt="Add users to project" src="../imgs/sharingfiles-1.png">
<figcaption></figcaption></figure>

-->

## References { #refs }

* [Manage Permissions with Access Control Lists](../../tutorials/acls)
* Consult the UNIX `man` pages for more information on the `chmod`, `chgrp`, `umask`, `groups` and `chgrp` commands.


{% include 'aliases.md' %}



<!--

1. Determine project GID

2. Determine project manager's default GID

3. if project manager's default GID != project GID

	a. project manager change default group via `newgrp`
	b. change permissions on Stockyard `chmod 755 $STOCKYARD` 

4. create shared project space 


if your Stockyard directory belongs to a different group than the newly created sharedprojectspace, you may have to change the permissions on your Stockyard directory to allow group access.

-->



<!-- ## Share an Existing folder -->
