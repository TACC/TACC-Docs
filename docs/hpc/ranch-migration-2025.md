# Ranch System Replacement - Data Migration Required
*Last update: September 22, 2025*

!!! warning
	**NOTICE September XX, 2025** Over the next year, [TACC's archival data system, Ranch,][TACCRANCHUG], will undergo a complete system replacement, requiring all current Ranch users to curate, then migrate, all their Ranch data from the old to the new system.  

	Since this is a total system replacement, and not an upgrade to existing hardware, all data on the current (Old) Ranch must be MANUALLY COPIED OVER by the respective data's owner, to the New Ranch system in order to save it permanently.   Data on Old Ranch will NOT automatically transfer to New Ranch.  You are responsible for migrating your own data that is stored on Old Ranch, either in your personal directory, or in a designated Project space, prior to the end of November, 2026.  

## Technical Information

Ranch will transition from the current Quantum StorNext tape archive system, hereinafter referred to as "Old Ranch", to a new Versity hierarchical storage management software and Spectra Logic tape archive system, now to be referred to as "New Ranch".

<table>
<thead><th>Ranch System</th><th>Lifespan</th><th>Specifications</th></thead>
<tr><td style="white-space:nowrap">Old Ranch </td><td>2019-2025</td><td>Quantum StorNext tape archive</td> </tr>
<tr><td style="white-space:nowrap">New Ranch </td><td>2025-2035</td><td>Versity ScoutAM & Spectra Logic TFinity</td></tr>
</table>

!!! important
	PIs are responsible for managing and migrating the data in their project spaces (or delegating the migration).

### Estimated Timeline:  

<table border="1">
<thead><tr><td>Dates</td><td>Action</td></tr></thead>
<tr>
<td style="white-space:nowrap">September XX, 2025</td>
<td>
<li>New Ranch hardware available to general users. 
<li>Old Ranch will become a read-only file system on 09/XX/2025.
<li>Old Ranch directories will be accessible via an NFS mount on New Ranch's login nodes called `OldRanchData`. 
<li>Begin migrating your data.  
</tr>
<tr>
<td style="white-space:nowrap">November 1, 2026</td><td>Old Ranch hardware removed from service </td></tr>
</table>

&#42;All dates subject to change based on hardware availability and condition 

All Ranch allocations subsequent to September XX, 2025 will automatically be placed on New Ranch. 

## Curating your data

**Data on Old Ranch will be accessible through November, 2026**, allowing PIs and delegates ample time to curate and migrate their data.  

Now is the time to re-evaluate your archived data e.g. decide if the data is still valuable and worth of long-term storage, or if the data is redundant or no longer needed. 

If you only need access to your data in the short term, it can stay on the old system, and be accessed via the `OldRanchData` directory/NFS mount until November, 2026. 

!!! tip
	To see your disk usage on Old Ranch, check the "`HSM_usage`" text file in your Old Ranch home directory or project directory. 

	```
	[slindsey@login1-ranch ~]$ ls
	OldRanchData
	[slindsey@login1-ranch ~]$ tail -1 OldRanchData/HSM_usage
	Fri Sep 19 04:32:01 2025 /stornext/ranch_01/ranch/users/01158/slindsey total storage allocated: 2.0T on-disk in use: 476K (Under) total files allocated: 50K in use: 12 (Under) on-tape in use: 995.2 MB
	ranch$ ls
	```

## Data Migration Directions

Since Old Ranch is a read-only file system, you must use either the `cp` and/or the `rsync` UNIX commands to copy over your data.

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

## References

* [Ranch User Guide][TACCRANCHUG]
* Subscribe to [Ranch User News](https://accounts.tacc.utexas.edu/user_updates) to receive system status updates and news.


{% include 'aliases.md' %}
