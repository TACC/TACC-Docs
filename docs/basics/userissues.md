# Common User Issues 
<!-- *or* How to Banned from the System-->
Last update: *March 02, 2026*

On occasion, a user's activities may negatively affect system performance, system stability or impact other users.  In that case TACC User Support makes a best effort to notify that user of administrative warnings and any required workflow changes.  However, once a user's activities or jobs are causing significant harm to the system, the admins will revoke queue access immediately for the health of the systems and the benefit of other users.  

Revocation of queue access means that you will no longer be able to submit jobs via `sbatch`, run an `idev` session, or initiate a TAP session.  The ban will be lifted only when the system admins are certain all issues have been remediated.  

Here we list the most common user mistakes that may affect system performance and/or stability, and may lead to revocation of queue access. Many of these items are detailed in [TACC's Good Conduct Guide][TACCGOODCONDUCT].

**Exceeding File System Quotas**   

All TACC resources have access to three file systems, (`home`, `work`, `scratch`) and each file system has two distinct quotas: 

* total number of files
* total disk space

Once a user nears either of these quotas, (trouble usually begins at 93% of quota), any attempts to write to disk may result in repeated failures, consequently stressing the shared filesystem. 

!!! tip
        To display a summary of your TACC project balances and disk quotas at any time, execute:<br><br><code>login1$ <b>/usr/local/etc/taccinfo</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Generally more current than balances displayed on the portals.</code></p>


**Disrespecting the Login Nodes**   

The login nodes are a shared resource amongst all users currently logged into that resource.  A single user hogging that nodes resources, either via excessive number of transfers, running MATLAB or any other package, or any other method will be immediately suspended.  Read the good conduct guide. 

* **Launching jobs on login nodes**: Under no circumstances should a user run jobs on login nodes. Login nodes are strictly for submitting jobs, the actual jobs must be run on compute nodes only.

* **Running research applications on login nodes**: Do not launch frameworks such as MATLAB, R, and other computationally and I/O intensive python scripts from the login nodes. 

* **Launching too many simultaneous processes on login nodes**: 

* Users may compile on a login node, but commands like "make -j 16" (which compiles on 16 cores) may impact other users.

**Excessive cron job or polling scripts**: 

* Poll job status scripts are permitted if they are run every few minutes, but should not be run several times a second.
* Running them several times a second will result in the user's queue access getting revoked.


**Running jobs out of the /HOME directory**

* /HOME is for routine file management, not parallel jobs. 
* Jobs run out of /HOME may likely overload the system and result in a revocation of the user's queue access.

**Running the entire workflow (code as well as data) out of /WORK**

* If all of the code, intermediate and non-intermediate data resides in /WORK and is run out of there, it will cause an overload on /WORK and result in consequences described in Point 1.

* Always direct any intermediate I/O and all job activity to each resources' `$SCRATCH` file system.  Ensure /SCRATCH is used for intermediate IO and actual job activity, while /HOME and /WORK are for storage and keeping track of important items.  See  [Table X. File System Usage Recommendations](https://docs.tacc.utexas.edu/basics/conduct/#table-file-system-usage-recommendations) for details.

* Compute nodes should not reference /WORK unless it is to stage data in/out only before/after jobs.

**I/O Intensive Sessions**

Frequent read and/or writes to disk (I/O) may cause high loads on the file system.

* Lots of reads and writes to the disk or rapidly opening and closing files will stress the shared filesystem.
* See [Managing I/O on TACC Resources][TACCMANAGINGIO] for details and workarounds.

See the "Limit Input/Output Activity" section in the Good Conduct Guide and [Managing I/O on TACC's HPC Resources][TACCMANAGINGIO] document.

**Admin: Multiple User Accounts**: TACC User Policy strictly prohibits an individual from having multiple accounts.  Should this occur, then TACC User Support will verify the user's identity, and all accounts belonging to the user will be merged into a single account.  TACC staff will disable all the other accounts.

**Large, unmanaged file transfers**:  Ensure receiving directories are striped, avoid too many simultaneous file transfers and recursive file transfers: <https://docs.tacc.utexas.edu/basics/conduct/#conduct-transfers> 


**PyLauncher - Too many tasks**

* Beware of running too many large tasks or a large number of small tasks on PyLauncher. 
* An upper limit for the number of tasks cannot be provided as it is entirely dependent on the specifications of the user's workflow, but should a user have questions about their set-up, they may reach out to TACC User Support for assistance.

**Conda**: Do not automatically source a Conda environment upon from within your `.bashrc` or other startup file. You must amend your workflow to *manually* activate a Conda evironment.

Hardcoding environment variables in the bashrc file

* Be wary of hard-coding certain environment variables in your startup scripts.  Instead,  employ `‘module load`, job-specific exports, `.env` files.


{% include 'aliases.md' %}

<!---
this won't get you suspended

## Workflows

1. Do not store important, long term data and files in /SCRATCH

	* /SCRATCH is a temporary storage space and is subject to routine purging (<https://docs.tacc.utexas.edu/basics/conduct/#scratchpolicy>)
	* Users may lose data permanently and this cannot be recovered if users don't save their important files in /WORK or /HOME.
--->

