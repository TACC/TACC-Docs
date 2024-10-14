# Unix Group Permissions and controlling the current Group context
Last update: *October 14, 2024*


Unix generally has a concept of a user owner and a group owner for any given file or directory, and it is important to understand these concepts to manage access to files at TACC.  There are two primary ways in which a users current and full set of groups can impact access to files on a TACC Unix file system.  These are:

1. When writing files, controlling who will be able to access them
2. When reading files created by other users, determining whether the current user has access

In addition, for several file systems at TACC the user and group that "own" a file will impact a "quota" or usage limitation.  In a users home directory there will be a total usage limit per-user, and on the Corral file system there will be a total usage limit per group.  At TACC each allocated project has a Unix group, so the group will be linked to all of the allocation members and total storage allocated.

There are several common utilities available to manipulate file ownership and permissions, as well as the permissions context for creating new files.  These commands are:

* `chmod` - Change permissions
* `chgrp` - Change the group owner 
* `groups` - Show group memberships 
* `newgrp` - Change the current effective group
* `sg` - Run one command under a specific group identity

We will provide examples here, but not full usage information.  Extensive documentation is available via web search or the system manual pages.  Detailed usage information for any command can be accessed with the Unix manpage system by running "<code>man <i>commandname</i></code>" on any TACC platform. 

## Understanding the permissions and owners of a file

To get a detailed listing of ownership and permissions information for a file or directory, run the command "`ls -l`"  - here is an example of the output of this command.

```cmd-line
$ ls -l
-rw-------  1 johnstudent mybioproject   13511 Feb 14  2017 anaconda.cfg
-rwxr--r--  1 cjones      G-44445          215 Sep 19  2017 audit.sh
```

The first column represents permissions for the User that owns the file, the Group that owns the file, and "Other" meaning every user on the system - the format is three letters for each permission category: "Read-Write-eXecute".  The third column shows which User owns the file and the fourth column shows the Group that owns the file.

In this example, the file "anaconda-ks.cfg" is only readable, and writable, by the user "exampleuser".  Any other user on the system will receive a "permission denied" error when attempting to access the file. 

The file "audit.sh" is readable by the user "cjones", members of the group "G-25209", and everyone else on the system.  It is executable only by the user "cjones".  Executable permission for a file means that it is code that can be executed on the system or in a job submission, while executable permission for a directory means that a user can view the contents of the directory and use the "cd" command to traverse into it.

If the user "cjones" wishes to share the file "audit.sh" with members of the group "mybioproject", the simplest way to accomplish this is to change the group owner with the `chgrp` command:

```cmd-line
$ chgrp G-example audit.sh
```

This is because the file is already shared with the Group owner, but it is currently not owned by the target group.  However, if instead the user "johnstudent" wished to share the file "anaconda.cfg" with members of "examplegroup," they should change the permissions on the file since it is already owned by this group, by adding read permissions:

```cmd-line
$ chmod g+r anaconda.cfg
```
See [Sharing Project Files][TACCSHARINGPROJECTFILES] for specific instructions for using these tools to setup a shared project folder. 

## Controlling the active or current group

When writing new data to the system, it is important to have your current group identity set correctly - this ensures that you are able to share with your project members easily, as well as keeping your allocation status correct.  You can check your current group and all your group memberships with the `groups` command:

```cmd-line
$ groups
```

This will list all the groups of which you are a member, with the currently active group first.  You can change that active group with the "newgrp" command:

```cmd-line
$ newgrp G-example
```

This will change your currently active group for the remainder of your login session.  Another way to change the current group context, for a single command, is to run it via the `sg` command, which will execute a command as different group ID:

```cmd-line
$ sg G-example ls
```

The example above will run the `ls` command using the group "G-example" as the current group.  You can use the `sg` command with any group of which you are currently a member (e.g. any group that shows up in the output of the `groups` command)

## Managing all groups and requesting default changes

Users who are members of multiple projects may have several groups associated with their user accounts, and may have a default group that is no longer active or relevant to their current work.  The first group shown in the output of the `groups` command is the users "default" group, which will be selected every time a user logs in.  If this group is no longer relevant to your needs, you can request that the default group be changed by [submitting a support ticket][CREATETICKET] through the TACC user portal.

## References

* [Manage Permissions with Access Control Lists][TACCACLS]
* [Sharing Project Files at TACC][TACCSHARINGPROJECTFILES]


{% include 'aliases.md' %}

