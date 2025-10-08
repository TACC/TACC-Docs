<!-- 
Heo
Recursive cp or rsync is reasonable way to transfer.  The key here is that user should partition the batch in reasonable sizes, e.g. 10TB-100TB range.  We see a user who already copied 100TB last week from old projects to new ones.   In general, it will be a slow process for most users.   One thing we should warn users against is futile attempt to parallelize multiple batches in the hope to speed things up, which will bog down finite number of tape drives available on both source and target side, ultimately blocking all other resources.  This can easily happen, and we will have to terminate those processes and clean up.


David
Could you also add something about du to the migration guide? On the Quantum Ranch system, data that had been migrated to tape wasn't reflected in du output, which is why we had the HSM_usage file, but on the ScoutFS filesystem, the du output actually includes the data on tape usage, so is a lot more useful to the users.

add Globus as a means of transfer



heo
Junseong Heo
  4:54 PM
/qranch/{users,projects} are ReadOnly re-export of the old ranch data.   For every project that was on the old ranch, one can find the new one in /scoutfs/{users,projects} on new machines.  Each directory in the new one has a symbolic link to the old one called "OldRanchData".  The copy in /qranch will go away in 12 months or so.  User guide states that users need to review and copy wanted data to new ranch.
:+1:
2

-->








# Ranch System Replacement<br>Data Migration Instructions for all Users
*Last update: October 8, 2025*

## Notices

* 10/08/2025 **VSCode users: Accessing Ranch and managing transfers via VSCode is prohibited.**  Ranch is an archival file system, not a computational resource.  Please use a terminal application to manage your Ranch data.


09/24/2025  Over the next year, [TACC's archival data system, Ranch,][TACCRANCHUG], will undergo a complete system replacement, requiring all current Ranch users to curate, then migrate, all their Ranch data from the old to the new system.  

Since this is a total system replacement, and not an upgrade to existing hardware, all data on the current (Old) Ranch must be MANUALLY COPIED OVER to the New Ranch system,  by the respective data's owner, in order to save it permanently.   Data on Old Ranch will NOT automatically transfer to New Ranch.  You are responsible for migrating your own data that is stored on Old Ranch, either in your personal directory, or in a designated Project space, prior to the end of November, 2026.  

!!! tip
	Subscribe to [Ranch User News](https://accounts.tacc.utexas.edu/user_updates) to receive system status updates and news.

## Technical Information

Ranch will transition from the current Quantum StorNext tape archive system, hereinafter referred to as "Old Ranch", to a new Versity hierarchical storage management software and Spectra Logic tape archive system, now to be referred to as "New Ranch".

<table>
<thead><th>Ranch System</th><th>Lifespan</th><th>Specifications</th></thead>
<tr><td style="white-space:nowrap">Old Ranch </td><td>2019-2025</td><td>Quantum StorNext tape archive</td> </tr>
<tr><td style="white-space:nowrap">New Ranch </td><td>2025-2035</td><td>Versity ScoutAM & Spectra Logic TFinity</td></tr>
</table>


## Curating your data

**Data on Old Ranch will be accessible through November, 2026**.  This time span allows PIs and their delegates ample time to curate and migrate their data from Old Ranch to New Ranch. Now is the time to re-evaluate your archived data on Old Ranch e.g. decide if the data is still valuable and worth of long-term storage, or if the data is redundant or no longer needed.  

If you only need access to your data in the short term (within the next year), then the data can stay on Old Ranch, and be accessed via the `OldRanchData` directory/NFS mount until November, 2026. 

### Examining Usage on Old Ranch

To see your disk usage on Old Ranch, check the "`HSM_usage`" text file in your Old Ranch home directory or project directory. 

```
[slindsey@login1-ranch ~]$ ls
OldRanchData
[slindsey@login1-ranch ~]$ tail -1 OldRanchData/HSM_usage
Fri Sep 19 04:32:01 2025 /stornext/ranch_01/ranch/users/01158/slindsey total storage allocated: 2.0T on-disk in use: 476K (Under) total files allocated: 50K in use: 12 (Under) on-tape in use: 995.2 MB
ranch$ ls
```



### Important Dates

<table border="1">
<thead><tr><td>Dates</td><td>Action</td></tr></thead>
<tr>
<td style="white-space:nowrap">September 30, 2025</td>
<td>
<li>New Ranch hardware available to general users. Begin migrating your data.  
<li>Old Ranch will becomes a read-only file system.
<li>Old Ranch directories will be accessible via an NFS mount, <code>OldRanchData</code>, on New Ranch's login nodes. 
<li>All new Ranch allocations subsequent to September 30, 2025 will automatically be placed on New Ranch. 
</tr>
<tr>
<td style="white-space:nowrap">November 1, 2026</td><td>Old Ranch hardware removed from service </td></tr>
</table>

<!-- &#42;All dates subject to change based on hardware availability and condition -->

!!! important
	PIs are responsible for managing and migrating the data in their project spaces (or delegating the migration).

## Data Migration Directions

Since Old Ranch is a read-only file system, you must use either the `cp` and/or the `rsync` UNIX commands to copy over your data.  **Do not use VSCode to access or manage data on Ranch.**  <!-- **VSCode users: Accessing Ranch and managing transfers via VSCode is prohibited.**  Ranch is an archival file system, not a computational resource.  Please use a terminal application to manage your Ranch data.-->


<table border="1">
<tr><thead><th>Using <code>cp</code></th><th>Using <code>rsync</code></th></thead></tr>
<tr>
<td>
```cmd-line
ranch$ pwd
/home/02945/davec
ranch$ ls
OldRanchData
ranch$ cp OldRanchData/mystuff.tar .
```
</td>
<td>
```cmd-line
ranch$ rsync -avhP OldRanchData/mystuff.tar .
```
</td>
</tr>
</table>

!!! tip 
	Limit your `cp` and/or `rsync` transfers to no more than three simultaneous processes.  Initiating excessive processes on the login nodes is prohibited.  See [File Transfer Guidelines](https://docs.tacc.utexas.edu/basics/conduct/#conduct-transfers) in the Good Conduct guide.


## Ranch Quotas and Polices

Ranch quotas and policies will remain constant across the new and old system.

<table>
<tr>
<td>File Count Quota</td> <td> Users are limited to 50,000 files in their $HOME directories.
<tr>
<td>File Space Quota</td> <td> Users are limited to 2 Terabytes (TB) of disk space in their $HOME directories. 
</tr>
</table>

See the Ranch User Guide for more about [Ranch's "Project" Storage](https://docs.tacc.utexas.edu/hpc/ranch/#projects), a special directory structure designed to support both shared and oversized data directories for users or projects whose storage needs exceed the standard 2TB quota. 

{% include 'aliases.md' %}
