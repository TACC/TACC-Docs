# Ranch User Guide
*Last update: June 17, 2024*

<!-- ## Notices { #notices } -->

<!-- **The XSEDE project concluded formal operations as an NSF-funded project on August 31, 2022**.  Similar services are now operated through NSF's follow-on program, Advanced Cyberinfrastructure Coordination Ecosystem: Services &amp; Support, or ACCESS.  Find out more at the [ACCESS website](http://access-ci.org). (09/01/2022) -->


## Introduction { #intro }

TACC's High Performance Computing (HPC) systems are used primarily for scientific computing and while their disk systems are large, they are unable to store the long-term final data generated on these systems. The Ranch archive system fills this need for high capacity long-term storage, by providing a massive high performance file system and tape-based backing store designed, implemented, and supported specifically for archival purposes.

Ranch (**`ranch.tacc.utexas.edu`**), is a Quantum StorNext-based system, with a DDN- provided front-end disk system (30PB raw), and a 5000 slot Quantum Scalar i6000 library for its back-end tape archive.

Ranch is an allocated resource, meaning that Ranch is available only to users with an allocation on one of TACC's computational resources such as [Frontera](../frontera), [Stampede3](../stampede3), or [Lonestar6](../lonestar6). ACCESS PIs will be prompted automatically for the companion storage allocation as part of the proposal submission process and should include a justification of the storage needs in their proposal.  UT and UT system PIs should also make a request and justify the storage requested when applying for a Ranch shared "Project" (non-user) allocation. The default allocation on Ranch for users is 2TB. To request a [shared Ranch project space](#projects) for your team's use, please submit a [TACC Helpdesk ticket][HELPDESK].


### Intended Use { #intro-use }

**Ranch is fundamentally implemented using long-term *tape* storage and as such is designed for archiving data that is in a state wherein the data will not likely change, and will not likely need to be accessed very often.** Obviously, Ranch is to be used only for work-related data. In addition, and most importantly, Ranch is not meant for active data and is never to be used as a replication solution for your `/scratch` directory. Ranch is also not suitable for system backups, due to the large number of small files that backups inevitably generate. 

**Ranch is a single-copy archival system.** Ranch user data is neither backed up nor replicated. This means that Ranch contains only a single, active, instance of user data. While lost data due to tape damage or other system failure is rare, please keep this possibility in mind when formulating your data management plans. If you have irreplaceable data and would like a different level of service, let us know via the ticketing system, and we may be able to help you find a solution.



### System Configuration { #intro-configuration }

Ranch's primary disk storage system is a DDN SFA14K DCR (Declustered RAID) system which is managed by Quantum's StorNext file system. The raw capacity is approximately 30PB, of which 17PB is user-facing. File metadata is stored on a Quantum SSD-based appliance. The back-end tape library, to which files automatically migrate after they have been inactive (neither modified nor accessed) on disk for a period of time, is a Quantum Scalar i6000, with 24 LTO-8 tape drives.  Each tape has an uncompressed capacity of approximately 12.5TB.

Previously, the Ranch system was based on Oracle's HSM software, with two SL8500 libraries, each with 20,000 tape slots. This Oracle system will remain as a legacy system while we migrate relevant data from Oracle HSM to the new Quantum environment.


## System Access { #access }

Direct login via Secure Shell's `ssh` command to Ranch is allowed so you can create directories and manage files. The Ranch archive file systems cannot be mounted on any remote system.

```cmd-line
stampede3$ ssh taccusername@ranch.tacc.utexas.edu
```

### Ranch Environment Variables { #access-envvars }

The preferred way of accessing Ranch, especially from scripts, is by using the TACC-defined environment variables `$ARCHIVER` and `$ARCHIVE`. These variables, defined on all TACC resources, define the hostname of the current TACC archival system, `$ARCHIVER`, and each account's personal archival space, `$ARCHIVE`. These environment variables help ensure that scripts will continue to work, even if the underlying system configuration changes in the future.

### Accessing Files from Within Running Programs { #access-programs }

Ranch access is not allowed from within running jobs on other TACC resources. Data must be first explicitly transferred from Ranch to your compute resource in order to be available for running jobs.

## Organizing Your Data { #organizing }

After over a decade of operation and servicing more than 60,000 user accounts, what has been revealed after running Ranch for so long, with so many users, is that limiting total file count, total file size, and possibly enforcing explicit data retention periods, are the keys to continued sustainable Ranch operation over the long-term.

When organizing your data keep in mind that reducing file count is at least as important as reducing file space. Ranch performs best manipulating large files and performance will suffer severely if Ranch is kept busy working against many small files rather than against a few large files. 

For this reason, users **must** bundle up their small-file-filled directories into one or more single large files.  This bundling is best done on the computational resource *prior* to migration of the data to Ranch. 

The best way to bundle files is to use the UNIX `tar` or `gtar` commands to create single large files typically called "tarfiles". We include several examples below.  Consult the `tar` or `gtar` man pages for detailed information on these commands.

!!! tip
	From careful auditing of past performance (predominantly the total retrieval time for a given data set until completion), we strongly recommend an average file size within Ranch of between 300GB to 4TB.

Users should be using `tar` or `gtar` to achieve file sizes in this range before placing them in Ranch.  Manipulating smaller files will detrimentally affect performance during both storage and retrieval.  For example, retrieval time of a 120TB data set comprised of `tar` files of 300GB can be an order of magnitude faster, or more, than the retrieval of the same data stored in its original form as individual files of 1GB or less.

The new Quantum-based environment is designed to meet the demand of retrieving multi-TB to PB-sized data sets in hours or days, rather than in weeks, which is possible only when the data set is stored into files with an average file size set optimally as described above.


### [Ranch Quotas](#organizing-quotas)  { #organizing-quotas }

!!! important
	**File Count Quota**: Users are limited to 50,000 files in their `$HOME` directories.  
	**File Space Quota**: Users are limited to 2 Terabytes (TB) of disk space in their `$HOME` directories.


You can display your current Ranch on-disk **file space usage** by executing the following UNIX command while the current directory is either you or your Project's home directory:

```cmd-line
ranch$ du -sh
```

Keep in mind the above commands only display file **space** used, not a total file **count**.  File count can be found using the UNIX `find` and `wc` commands, again while the current directory is either you or your Project's home directory:

```cmd-line
ranch$ find . -type f | wc
```

It is your responsibility to keep the file count below the 50,000 quota by using the UNIX `tar` command or some other methodology to bundle files when necessary. Both the file space and file count quotas apply to all data copied from the Oracle archive and all new incoming data.



### Monitor your Disk Usage and File Counts { #organizing-quotas }

Users can check their current and historical Ranch usage by looking at the contents of the `HSM_usage` file in their Ranch user directory. Note that this file contains quota, on-disk, and on-tape, usage information for the directory it is in and all those beneath it.

```cmd-line
ranch$ tail ~/HSM_usage
```

This file is updated nightly.  Each entry also shows the date and time of its update. **Do not delete or edit this file.**  Note that the format of the file has changed over time, and may again as necessary, to provide better information and improved readability for users.


## Ranch "Project" Storage { #projects }

Ranch has implemented new "Project" storage which is a separate directory structure designed to support both shared and over-size data directories for users and/or projects for whom the fixed standard storage for each user of 2TB is inadequate, or in the case of shared storage, inappropriate.  [Submit a support ticket][HELPDESK] to request Project storage on Ranch.  Note that each Project directory will also contain an `HSM_usage` file as described above.

## Transferring Data { #transferring }

To maximize the efficiency of data archiving and retrieval for users, data should be transferred using as large a file as is feasible.  See [Organizing your Data](#organizing) above.

Ideally users should combine their data into large files in their source environment, TACC or otherwise, and transfer the data already in its final form into Ranch.  If that is not possible, usually due to very large files (+5TB) files, then some technique should be used to create smaller files that transfer gracefully.  This could be achieved merely by the judicious use of `tar` or `gtar` on the source system, a combination of `tar`/`gtar` and then `split` on the source system, or lastly, and least optimally, the transfer of the files, regardless of size, into Ranch, and then the immediate use of `tar` to create "tarfiles" sized as described above.


### Manipulating Files within Ranch { #transferring-manipulating }

Since Ranch is an archive system, any files which have not been accessed recently will be stored on tape. This transfer is transparent to you, as is, when necessary, the truncation of the file's data to provide additional disk space. If a file has not yet been truncated, reading and manipulating the file will take place at speeds typical for the user-facing high performance disk array and file system wherein the file resides

However, for any file that is to be read or accessed that has been truncated, it must first be read, in its entirety, from tape. These retrievals from tape take time, from minutes to hours, and the time necessary is a normal aspect of file manipulation within Ranch.  While these retrievals are transparent to you, you will notice a time lag during the access of the file or files.  Again, the time lag, regardless of duration, is entirely normal.

Note that simply doing an `ls -l` to look at a file's attributes or an `mv` to rename the file will not provoke file retrieval from tape, as these are operations against the file's metadata.


### Data Transfer Methods { #transferring-methods }

TACC supports two transfer mechanisms: `scp` (recommended) and `rsync` (avoid if at all possible).   

Ranch also has two endpoints, one running Globus gridftp v5.4 software available for [ACCESS](http://access-ci.org) (formerly XSEDE) users, and the endpoint running Grid Community Toolkit with CILogon authentication available to all.  See [Grid Community Toolkit at TACC](../../tutorials/gridcommunitytoolkit) for more information.

#### Secure Copy with `scp` Command { #transferring-methods-scp }

The simplest way to transfer files to and from Ranch is to use the Secure Shell `scp` command:

```cmd-line
stampede3$ scp myfile ${ARCHIVER}:${ARCHIVE}/myfilepath
```

where `myfile` is the name of the file to copy and `myfilepath` is either the new name you want the file to have in Ranch, or is a directory into which you want to place `myfile`.

For large numbers of small files, we again **strongly** recommend you first employ the `tar` or `gtar` command to create an archive (tarfile) of files before transferring the data to Ranch.  Then use `scp` to copy the tarfile(s) over to Ranch.

Alternatively, sometimes you can actually do this in one step as part of the transfer process as shown below:

To use `tar`, `ssh`, and `cat` to create a good tarfile in Ranch from a source directory on your compute resource, all in one command line:

```cmd-line
stampede3$ tar cf - dirname/ | ssh ${ARCHIVER} "cat > ${ARCHIVE}/dirname.tar"
```

where `dirname/` is the path to the directory you want to archive, and `dirname.tar` is the name of the tarfile to be created on Ranch.

To be very UNIX specific about what the command above is doing: 

* `tar` creates a stream of bytes in `tar` format of the directory "dirname/" (recursively) and writes that to its standard output.  
* The pipe (`|`) reads that stream of bytes and writes that stream to the `ssh` command which has started the `cat` command over on a Ranch login node.  
* The `cat` command reads its standard input, which is the stream of `tar` formatted bytes, and then redirects that stream of bytes to its standard output via the `>` symbol creating or overwriting the file `dirname.tar`.  
* When the `tar` command is complete and exits, the stream of bytes will stop, and `cat` will gracefully close the file `dirname.tar`, `ssh` will exit, and you will be returned to the command line on Stampede3.

And in one simple command line, you have created a single tar file, `dirname.tar`, containing the entire data structure of the directory dirname/ over on Ranch, and ideally that tarfile is quite large as per the recommendations above.

Note that when transferring to Ranch, any destination directory specified must already exist. If not, `scp` will respond with:

```syntax
No such file or directory
```

The following command-line examples also demonstrate how to transfer files to and from Ranch using `scp`, and renaming in the process:

* Copy a tarfile from Stampede3 to Ranch:

	```cmd-line
	stampede3$ scp data_2020.tar ${ARCHIVER}:${ARCHIVE}/final_2020.tar
	```

* Copy a tarfile from Ranch to my computer, retaining the file modification time

	```cmd-line
	stampede3$ scp -p ${ARCHIVER}:${ARCHIVE}/final_data_2017.tar ./ranch_data_2017.tar
	```


#### [Remote Sync with `rsync` command](#transferring-methods-rsync)  { #transferring-methods-rsync }

**Please read carefully**: The UNIX `rsync` command is a powerful command to both transfer data as well as keep identical copies of data in separate locations in sync.  However, it MUST be used very carefully in any archive environment.

The `rsync` utility has several methods for checking to see if file data transfer and update is necessary during a synchronization of files. **THE ONLY APPROPRIATE METHOD** for use in any archive environment is the use of "last modification date" and the size of the file.  ANY sort of checksumming of existing data file(s) in Ranch may provoke their complete file transfer from tape if they have been truncated and thus no longer entirely on disk.  Needless retrieval of files off tape only to checksum them and discover they still are identical is a **massive waste of resources**, and puts that data at risk as it causes unnecessary reading of tape.

In addition, the retrieval of large amounts of data off tape simply to add "one more file" into a data structure, or into a tarfile, is also a **massive waste of resources** and puts more data at risk, a risk that also grows larger every time it is invoked.

Therefore, TACC Staff highly recommends to NOT use `rsync` for ANY kind of data synchronization with the Ranch archive system.  

Using `rsync`, **without synchronization**, continues to be a viable method of transferring data into and out of Ranch.


### Large Data Usage and Transfers { #transferring-largedata }

If you are moving a very large amount of data into Ranch and you encounter a quota limit error, then you are bumping into one of the limits on the amount of data you can have on Ranch's user-facing file systems. These quotas limit both file count as well as total file size.  However, it is expected that these limits should only affect a small number of users.  Again, the file "HSM_usage" at the top level of both users' and Projects' directories is updated nightly and should be consulted to see current usage with Ranch.  If you encounter a quota error, please submit a ticket to the TACC user portal, and we will see what remediation may be possible. 

Again, use the `du -sh .` and `find . -type f | wc` commands to see how much data and how many files you currently have on the disk or directory at that moment.

#### Examples { #transferring-largedata-examples }

1. Archive a large directory with `tar`, send the `tar` data stream to Ranch, splitting it into optimally sized tarfiles upon its arrival on the Ranch node:

	```cmd-line
	stampede3$ tar cf - directory/ | ssh ranch.tacc.utexas.edu \
		'split -b 300G - files.tar.'
	```

	Ideally, you would create, then split large, output files, or `tar` files, on the Stampede3 side, then move them to Ranch.  Large files, of more than a few TB in size, should be split into chunks, ideally between 300GB and 2TB in size.

1. Use the `split` command on Stampede3 to accomplish this:

	```cmd-line
	stampede3$ split -b 300G bigfile.tar bigfile_tar_part_
	```

	The above example will create several 300GB files, with the filenames: `bigfile_tar_part_aa`, `bigfile_tar_part_ab`, `bigfile_tar_part_ac`, etc.

1. Then use `scp` to copy the files into Ranch:

	```cmd-line
	stampede3$ scp -p bigfile_tar_part_* ${ARCHIVER}:${ARCHIVE}/
	```

1. After ensuring that you are satisfied with the transfer, and the viability of the data over on Ranch, the split parts of the original data could then be carefully deleted on Stampede3:

	The split parts of a file can be always be joined together again with the `cat` command.  See the `split` man page for more options.

	```cmd-line
	stampede3$ cat bigfile_tar_part_?? > bigfile.tar
	```

1. A subsequent `tar tvf bigfile.tar` should be used immediately to ensure `bigfile.tar` contains all the data you expect, and `tar` generates no errors.

	Or, if you don't want to wait to actually create `bigfile.tar`, you just want to validate your data, just throw the stream of bytes from the `cat` at `tar`, and you'll achieve the same result without actually putting anything new on disk:

	```cmd-line
	stampede3$ cat bigfile_tar_part_?? | tar tvf -
	```

1. If you like what you see, and `tar` returns no errors, you will have validated you have good data after having split it into manageable pieces.


## Good Conduct on Ranch { #conduct }

* Limit `scp`, `ssh`, `rsync` processes to no more than two processes.
* Follow the guidelines for archiving data - file size, file count, transfer method
* Store only data that was processed, or generated, on appropriate systems
* Carefully delete all unneeded data off of Ranch whenever possible
* Ideally store data that is in its final form, such that it will be accessed only when truly necessary
* No workstation or other system backups

## In Depth: How it Works { #works }

<!-- Ranch disk storage allocations are not implemented in the same fashion as active data storage allocations in the other TACC environments. -->

Ranch is specifically designed and implemented as a long-term data archive, comprised of a large user-facing disk array, and an even larger tape-based backing store.  Ranch storage quotas, both for users as well as Projects, represent how much data a user or Project can have on the user-facing file system at any particular time.

As Ranch is an archive, as files "age" by being neither accessed nor modified, they are transparently migrated to tape. This then frees up that disk space in the file system for use by all users and Projects, including your own.  This freeing of the file's disk space is known as file "truncation".  Upon access, files that have been migrated to tape are transparently pulled back off - with an expected delay of up to several minutes, and data access then resumes.

Ranch disk storage grants are never implemented in toto if they are quite large. Data ingestion rates, file count quotas, as well as normal data migration to tape usually obviates the need for this.

That being said, should a Project need more on-disk quota than they currently have, and they are not asking to exceed their granted storage size, their on-disk quotas will be adjusted appropriately.

You will see four phenomena within Ranch, typically made manifest in your `HSM_usage` file in your home directory:

1. Your on-disk storage quota is almost always smaller than your grant, and if you have been inactive since initial Project creation, it may be considerably smaller
2. Your disk usage will drop as your files are migrated to tape, with file count staying the same
3. Accessing old data that has been migrated to tape will initially be a slow process as your files are pulled back from tape and placed onto disk
4. Accessing old data will consume file system disk space and thus may then cause you to exceed your on-disk storage quota - therefore you are encouraged to always be selective about reading old data


!!! important 
	The file truncation that the system does automatically occurs only when there is a lack of free disk space on the entire file system, not in any particular user's or Project directory.  

For example, if the file system were half full, there would be NO file truncation, and while older files would be steadily copied to tape, their entire contents would remain on disk.  Conversely, if the file system were to grow to over 80% full, the system would be transparently searching for, and truncating, older files in order to create free disk space in the file system.  None of these truncation operations are driven by a particular user or Project reaching their quota of on-disk storage.  **The software is unaware that any particular directory has reached their quota and might need intervention via truncation.**

Given all that was described above with regard to storge allocations and the `HSM_usage` file, if a user has reached their current quota of on-disk storage, there are two solutions that can be used.

1. Perform an "early truncation" wherein your old files are explicitly discovered and truncated.  This presumes that these old files have already been written to tape.
1. Expand you or your Project's on-disk quota.  Given that Ranch is a shared resource with hundreds of Projects and thousands of users, this on-disk quota expansion is not the preferred solution.

In either case, you must [submit a helpdesk ticket][HELPDESK] to ask for an examination of the quota use in Ranch.

{% include 'include/ranch-help.md' %}

<!-- ## References { #refs }

* [Stampede3 User Guide](../stampede3) -->

{% include 'aliases.md' %}

