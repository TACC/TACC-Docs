# Common User Issues 
<!-- *or* How to Banned from the System-->
Last update: *March 03, 2026*

On occasion, a user's activities may negatively affect system performance, system stability or impact other users.  In that case TACC User Support makes a best effort to notify that user of administrative warnings and any required workflow changes.  However, once a user's activities or jobs are causing significant harm to the system, the admins will revoke queue access immediately for the health of the systems and the benefit of other users.  

Revocation of queue access means that you will no longer be able to submit jobs via `sbatch`, run an `idev` session, or initiate a TAP session.  The ban will be lifted only when the system admins are certain all issues have been remediated.  

Here we list a few of the  most common user mistakes that may affect system performance and/or stability, which in turn may lead to revocation of queue access. Many of these items are further detailed in [TACC's Good Conduct Guide][TACCGOODCONDUCT].

### Nearing or Exceeding File System Quotas   

All TACC resources have access to three file systems, `home`, `work`, and `scratch`, and each file system has two distinct quotas: 

* total number of files
* total disk space

Once a user nears either of these quotas, (trouble usually begins at 93% of quota), any attempts to write to disk may result in repeated failures, consequently stressing the shared filesystem. 

!!! tip
	To display a summary of your TACC project balances and disk quotas at any time, execute:<br><br><code>login1$ <b>/usr/local/etc/taccinfo</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Generally more current than balances displayed on the portals.</code></p>


### Disrespecting the Login Nodes

The login nodes are a **shared** resource amongst all users currently logged into that resource.  A single user hogging a login node's resources, either via excessive number of transfers, running MATLAB,  or any other method will be immediately suspended. 

This mandate includes:

* **Running jobs on login nodes**: Under no circumstances should a user run jobs on login nodes. Login nodes are strictly for submitting jobs, the actual jobs must be run on compute nodes only.

* **Running research applications on login nodes**: Do not launch frameworks such as MATLAB, R, and other computationally and I/O intensive python scripts from the login nodes. 

* **Launching too many simultaneous processes on login nodes**: Users may compile on a login node, but commands like `make -j 16` (which compiles on 16 cores) may impact other users.

**Excessive cron job or polling scripts**: Poll job status scripts are permitted if they are run every few minutes, but should not be run several times a second.

### Allowing compute jobs to access the wrong file system

All compute jobs should be staged out of each resource's `$SCRATCH` file system.  

**Do not run jobs out of the `$HOME` file system**

* `/HOME` is for routine file management, not for computational jobs.  
* Jobs run out of /HOME may likely overload the system and result in a revocation of the user's queue access.

**Do not run the entire workflow (code as well as data) out of `$WORK`**

* If all of the code, intermediate and non-intermediate data resides in `$WORK` and is run out of there, it will cause an overload on `$WORK` and result in consequences described in Point 1.

* Always direct any intermediate I/O and all job activity to each resources' `$SCRATCH` file system.  Ensure `$SCRATCH` is used for intermediate IO and actual job activity, while /HOME and `$WORK` are for storage and keeping track of important items.  See [File System Usage Recommendations](https://docs.tacc.utexas.edu/basics/conduct/#table-file-system-usage-recommendations) for details.

* Compute nodes should not read or write data `$WORK` unless it is to stage data in/out only before/after jobs.

### Running I/O Intensive Sessions

Frequent read and/or writes to disk (I/O) may cause high loads on the file system.

* Lots of reads and writes to the disk or rapidly opening and closing files will stress the shared filesystem.
* See [Managing I/O on TACC Resources][TACCMANAGINGIO] for details and workarounds.

See the "Limit Input/Output Activity" section in the Good Conduct Guide and [Managing I/O on TACC's HPC Resources][TACCMANAGINGIO] document.

<!-- 
### PyLauncher: Too Many Tasks

* Beware of running too many large tasks or a large number of small tasks on PyLauncher. 
* An upper limit for the number of tasks cannot be provided as it is entirely dependent on the specifications of the user's workflow.
-->

### Avoid Hardcoding Environment Variables in your Startup Files 

Be wary of hard-coding certain environment variables in your startup scripts, e.g. `.bashrc` .  Environment variables such `LD_LIBRARY_PATH`, `MPIRUNLIB` may override system and/or vendor libraries.  Instead, make use of [LMOD][TACCLMOD] system (`module load`),  job-specific exports, and `.env` files to configure your environment.

#### Automatic Conda Startup

Do not automatically source a Conda environment from within your `.bashrc` or other startup file. You must amend your workflow to *manually* activate a Conda evironment.

### Admin: Multiple User Accounts 

The [TACC Acceptable Use Policy][TACCAUP] strictly prohibits an individual from having multiple accounts.  Should this occur, then TACC User Support will verify the user's identity, and all accounts belonging to the user will be merged into a single account.  TACC staff will disable any other accounts.

### Large, unmanaged file transfers  

Ensure receiving directories on Frontera's `$WORK` and `$SCRATCH` file systems are <a href="../hpc/frontera/#files-striping">striped</a>, avoid too many simultaneous file transfers and recursive file transfers.


### Storing important data in the `$SCRATCH` 

Do not store important, long-term data and files in any resource's `$SCRATCH` directory.  Each resource's `$SCRATCH` file system/s are [temporary storage spaces](https://docs.tacc.utexas.edu/basics/conduct/#scratchpolicy) and are subject to routine purging.  Data cannot be recovered after a purge.

It is the user's responsibility to create a backup workflow to the Stockyard `$WORK` or `$HOME` file systems, TACC's long-term storage resources, [Ranch][TACCRANCHUG], or [Corral][TACCCORRALUG], or another backup destination of your choice.


{% include 'aliases.md' %}











