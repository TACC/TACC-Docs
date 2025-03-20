# Manage Permissions with Access Control Lists
*Last update: February 19, 2024* 

Access Control Lists (ACLs) are a very powerful tool for managing permissions within a file system. ACLs allow for arbitrary lists of specific users and groups to be given read, write, and/or execute permissions on any file or directory that you own. They provide a much more flexible mechanism for managing permissions than the traditional Unix "user, group, and other" permissions system.  ACLs provide the common UNIX read, write, and execute permissions for individual users or groups of users, and you may have as many ACL entries as necessary to achieve the precise set of permissions you need on a given file or directory. 

!!! tip
	While TACC's [Corral][TACCCORALLUG] supports ACLs, not all file systems have this feature enabled. Please consult the appropriate user guide for questions about specific file systems.

**Important note**: Access Control Lists work only in an additive fashion and cannot be used to remove permissions granted through the regular UNIX permissions commands. For example, if you want all the members of a group but one to have access to a file, you cannot start by granting access to the group and then removing access for one user; instead, you must remove access for the whole group, then add the appropriate permissions for each individual. 

The two important command-line tools for managing ACLs are `setfacl` and `getfacl`. These commands are used to create or change ACLs, and to read the contents of an ACL, respectively. The man pages provide detailed documentation on both these commands. 

```cmd-line
login1$ man setfacl
```

and

```cmd-line
login1$ man getfacl
```

## Viewing ACLs { #viewing }

Viewing ACLs for a specific file or directory is quite simple, and can be accomplished using the `getfacl` command:

```cmd-line
login1$ getfacl myfile>
```

The output will be in the format shown below.  This example shows that the owner (root) has read and write access, while the user "testuser" has read-only access:

	# file: xwfs/projects/example/myfile
	# owner: root
	# group: root
	user::rw-
	user:testuser:r--
	group::---
	mask::r--
	other::---

Note that the command's output is in a specialized format that can also be used to set ACLs, as described [below](#multiplefiles).  You may use the wildcard (`*`) character to generate ACL listings for all files which match a specific pattern, however this may produce a lot of output if there are many files in a given directory. You must have read access to the file or directory in question in order to read its ACLs.

## Setting ACLs from the Command-Line { #setting }

The `setfacl` command is the simplest way to manage ACLs. The example below modifies (with the -m) option an ACL to add read access for the username "testuser". 

```cmd-line
login1$ setfacl -m u:testuser:r file
```

The `-w` and `-x` flags can also be added to give read, write, and execute permissions:

```cmd-line
login1$ setfacl -m u:testuser:rwx file
```

The `-x` option can be used to remove permissions from the ACL. The following command removes the permissions granted in the previous example:

```cmd-line
login1$ setfacl -x u:testuser:rwx file
```


## Setting Complex ACLs { #multiplefiles }

You can use a named file, or a pipe with the `getfacl` command, to set complex ACLs or to copy ACLs from one file to another. The following commands save the output of the `getfacl` command to a file named `myfile.acl`, and then reads that ACL to set the permissions on a second file:

```cmd-line
login1$ getfacl file > myfile.acl
login1$ setfacl -M myfile.acl file2
```

You can also use the `-R` flag for recursion and/or the wildcard character to set permissions for all files in a given directory tree.  The following command sets permissions using the specification in `myfile.acl` set in the above example on all files in the current directory:

```cmd-line
login1$ setfacl -M file.acl *
```

This command  recursively sets permissions on all files and subdirectories of the named directory:

```cmd-line
login1$ setfacl -R -M file.acl directory/
```

There are a large number of possibilities with the use of ACLs, including setting and managing default ACLs. Explore the man pages for more details on all the available options.

```cmd-line
login1$ man getfacl
login1$ man setfacl
```

## Default ACLs { #defaultacls }

Default ACLs can be set on a directory, and once set, are assigned automatically to all new files created within that directory. Default ACLs are useful when you have a specific and/or complex set of permissions you wish to apply uniformly to all new data in a project directory. Setting default ACLs follows the same format as regular ACLs, with a `d:` prefix in the ACL specification. For example, to assign a default ACL granting user `thomas` full permissions to all NEW data in mydirectory, use the following command:

```cmd-line
login1$ setfacl -m d:u:thomas:rwX mydirectory
```

The capital `X` in the ACL specification means "add execute permission for directories only" and is convenient for situations where you don't know whether the ACL will be applied to a directory or a file. Default ACLs can be set for both users and groups, just as regular ACLs can.

Note that default ACLs do not alter the permissions for any currently existing files; they only apply to files created after the default ACL is set.


<!-- ## References { #refs } -->

<!-- * [iRODS at TACC](../../software/irods) -->

{% include 'aliases.md' %}
