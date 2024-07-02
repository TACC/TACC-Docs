### [Scratch File System Purge Policy](#scratchpolicy) { #scratchpolicy }

!!! warning
	The <code>$SCRATCH</code> file system, as its name indicates, is a temporary storage space.  Files that have not been accessed&#42; in ten days are subject to purge.  Deliberately modifying file access time (using any method, tool, or program) for the purpose of circumventing purge policies is prohibited.

&#42;The operating system updates a file's access time when that file is modified on a login or compute node. Reading or executing a file/script on a login node does not update the access time, but reading or executing on a compute node does update the access time. This approach helps us distinguish between routine management tasks <u>(e.g. `tar`, `scp`)</u> and production use. Use the command `ls -ul` to view access times.


