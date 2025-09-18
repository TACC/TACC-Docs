# Ranch System Replacement - Data Migration Required

Over the next year, TACC staff will perform a complete system replacement of Ranch, the archival data system, transitioning to new hardware and software. We are migrating from our the older system based on a Quantum StorNext tape archive system (hereinafter referred to as "Old Ranch” to a new Versity (hierarchical storage management software) and Spectra Logic (tape archive system) based Ranch archive, to be referred to as "New Ranch”.

Old Ranch - 2019-2025 Quantum StorNext tape archive
New Ranch - 2025 - 2035+ Versity ScoutAM & Spectra Logic TFinity

Since this is a total system replacement, and not an upgrade to existing hardware, all data on the current (Old) Ranch must be COPIED OVER to the New Ranch system.  users are responsible for migrating their data to the new system, New Ranch.  Data on Old Ranch will be accessible through September, 2026 while users migrate their data to New Ranch.  

## Estimated Timeline:  

<table border="1">
<thead><tr><td>Date</td><td>Action</td></tr></thead>
<tr>
<td style="white-space:nowrap">September 23, 2025</td>
<td>New Ranch hardware available to general users. <br>Begin migrating your data.  <br>Old ranch directories will be mounted as a read-only directory called 'olddata'.</td>
</tr>
<tr>
<td style="white-space:nowrap">November 1, 2026</td><td>Old Ranch hardware removed from service </td></tr>
</table>

*All dates subject to change based on hardware availability and condition *

Old Ranch will become a read-only file system on 09/23/2025, accessible via an NFS mount on the New Ranch’s login nodes. 

For All users who have data on Ranch prior to 09/23/2025 

Data on Old Ranch will NOT automatically transfer to New Ranch. Data that is stored on Old Ranch must be migrated by you, or your project PI, before the end of September 2026. 


This includes your home directory, and the project directories.


!!! important 
	PIs are responsible for managing and migrating the data in their project spaces (or delegating the migration).

Now's a nifty time to re-evaluate the data stored on Ranch e.g. decide if you want to keep it and transfer over.

All new Ranch allocation requests will automatically be placed on New Ranch. 

## Curating your data

!!! important 
	Migrate ONLY the data you need to keep long term. 

The data on Old Ranch will be accessible for at least a year, so if you only need access to it in the short term, it can stay on the old system, and be accessed via the olddata directory/NFS mount. 

!!! tip
	To see your usage, check the "`HSM_usage`" text file in your Old Ranch home directory or project directory. 

	```
	ranch$ ls
	```


For very large data migration (>=1PB), or other special use cases, please contact the support team for assistance: https://tacc.utexas.edu/portal/tickets 


## Data Migration Directions

Once logged into New Ranch (`ranch.tacc.utexas.edu`), copy your data using either the `cp` or `rsync` commands from the NFS-mounted directory called "olddata” to your new home directory. The `olddata` directory is read-only. 
Since Old Ranch is a read-only file system, you must use either the `cp` or `rsync` UNIX commands to move your data.

```cmd-line
ranch$ pwd
/home/02945/davec
ranch$ ls
Olddata
ranch$ cp olddata/mystuff.tar .
```

Alternatively, you can use the `rsync` command to copy your data from the old system with: 

```cmd-line
login1$ rsync -avhP olddata/mystuff.tar .
```

 
!!! warning 
	Limit your `cp` and/or `rsync` transfers to no more than three simultaneous processes.  


## Ranch Quotas 

Ranch quotas will remain constant across the new and old system.

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
