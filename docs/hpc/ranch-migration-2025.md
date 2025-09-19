# Ranch System Replacement - Data Migration Required

**NOTICE September 23, 2025** Over the next year, [TACC's Ranch, the archival data system][TACCRANCHUG], will undergo a complete system replacement, requiring all current Ranch users to curate, then migrate, all their Ranch data from the old to the new system.  

## Guts

Ranch will transition from the current Quantum StorNext tape archive system, hereinafter referred to as "Old Ranch", to a new Versity hierarchical storage management software and Spectra Logic tape archive system, to be referred to as "New Ranch".

<table>
<thead><tr><td colspan="2">Definitions</td></tr></thead>
<tr><td style="white-space:nowrap">Old Ranch (2019-2025)</td><td>Quantum StorNext tape archive</td> </tr>
<tr><td style="white-space:nowrap">New Ranch (2025-2035)</td><td>Versity ScoutAM & Spectra Logic TFinity</td></tr>
</table>


Since this is a total system replacement, and not an upgrade to existing hardware, all data on the current (Old) Ranch must be MANUALLY COPIED OVER to the New Ranch system in order to save it permanently.  <!-- Data on Old Ranch will NOT automatically transfer to New Ranch. -->  PIs are responsible for managing and migrating the data in their project spaces (or delegating the migration).   Data that is stored on Old Ranch, either in your personal directory, or in a designated Project space, must be migrated by you, or your project PI, before the end of September 2026.  

Data on Old Ranch will be accessible through September, 2026 giving all PIs and delegates ample time to curate and migrate their data.

## Estimated Timeline:  

<table border="1">
<thead><tr><td>Date</td><td>Action</td></tr></thead>
<tr>
<td style="white-space:nowrap">September 23, 2025</td>
<td>New Ranch hardware available to general users. <br>Begin migrating your data.  <br>Old Ranch directories will be mounted as a read-only directory called 'OldRanchData'.
Old Ranch will become a read-only file system on 09/23/2025, accessible via an NFS mount on the New Ranch’s login nodes. </td>
</tr>
<tr>
<td style="white-space:nowrap">November 1, 2026</td><td>Old Ranch hardware removed from service </td></tr>
</table>

&#42;All dates subject to change based on hardware availability and condition 

All Ranch allocations subsequent to September 23, 2025 will automatically be placed on New Ranch. 

### Curating your data

Now is a nifty time to re-evaluate your archived data e.g. decide if the data is still valuable and worth of long-term storage, or is no longer needed. 

The data on Old Ranch will be accessible for at least a year, so if you only need access to it in the short term, it can stay on the old system, and be accessed via the OldRanchData directory/NFS mount until November, 2026.. 

!!! tip
	To see your usage, check the "`HSM_usage`" text file in your Old Ranch home directory or project directory. 

	```
	[slindsey@login1-ranch ~]$ ls
	OldRanchData
	[slindsey@login1-ranch ~]$ tail -1 OldRanchData/HSM_usage
	Fri Sep 19 04:32:01 2025 /stornext/ranch_01/ranch/users/01158/slindsey total storage allocated: 2.0T on-disk in use: 476K (Under) total files allocated: 50K in use: 12 (Under) on-tape in use: 995.2 MB
	ranch$ ls
	```



## Data Migration Directions

Since Old Ranch is a read-only file system, you must use either the `cp` or `rsync` UNIX commands to move your data.

### Using `cp`

```cmd-line
ranch$ pwd
/home/02945/davec
ranch$ ls
Olddata
ranch$ cp OldRanchData/mystuff.tar .
```

### Using `rsync` 

```cmd-line
login1$ rsync -avhP OldRanchData/mystuff.tar .
```

!!! tip 
	Limit your `cp` and/or `rsync` transfers to no more than three simultaneous processes.  Initiating excessive processes on the login nodes is prohibited.  See [File Transfer Guidelines](https://docs.tacc.utexas.edu/basics/conduct/#conduct-transfers) in the Good Conduct guide.


## Ranch Quotas and Polices

Ranch quotas and policieswill remain constant across the new and old system.

<table>
<tr>
<td>File Count Quota</td> <td> Users are limited to 50,000 files in their $HOME directories.
<tr>
<td>File Space Quota</td> <td> Users are limited to 2 Terabytes (TB) of disk space in their $HOME directories. 
</tr>
</table>

See the Ranch User Guide for more about [Ranch's "Project" Storage](https://docs.tacc.utexas.edu/hpc/ranch/#projects), a special directory structure designed to support both shared and oversized data directories for users or projects whose storage needs exceed the standard 2TB quota. 


* [Ranch User Guide][TACCRANCHUG]
* Subscribe to [Ranch User News](https://accounts.tacc.utexas.edu/user_updates) to receive system status updates and news.


{% include 'aliases.md' %}
