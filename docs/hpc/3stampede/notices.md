# Stampede3 User Guide 
*Last update: May 8, 2024*

## [Notices](#notices) { #notices }

*This user guide is in progress and will be updated as the system is configured.*

* The Ponte Vecchio nodes are now available via the [`pvc` queue](#queues).  Jobs in this queue will be charged at a rate of 4 SUs per node-hour. (05/08/2024)
* The new Sapphire Rapids nodes are now available via the [`spr` queue](#queues).  Jobs in this queue will be charged at a rate of 3 SUs per node-hour. (05/07/2024)

* Attention VASP Users: DO NOT run VASP using Stampede3's SPR nodes!  TACC staff has noticed many VASP jobs causing issues on the SPR nodes and impacting overall system stability and performance.  Please run your VASP jobs using either the [SKX](../../hpc/stampede3#table3) or [ICX](../../hpc/stampede3#table4) nodes.  See [Running VASP Jobs](../../software/vasp/#running) for more information.  (05/06/2024)

* TACC is now charging SUs against your balance for jobs run in the `skx-dev`, `skx`, and `icx` [queues](#queues) on Stampede3. The charge rates will be 1SU per node-hour for the `skx` queues and 1.67SUs per node-hour for the `icx` queue.  (04/08/2024)

* Stampede3 Updated Timeline (03/14/2024)

	**All dates subject to change based on hardware availability and condition.**   

	January 2024 - Stampede3 file system available for data migration - **Available now**  
	February - mid April 2024 - Early user period for Stampede3 - **Available now**    
	late April 2024 - Stampede3 in full production   


## [Migrating Data](#migrating) { #migrating }

The Stampede3 login nodes are now available for you to begin moving data between systems.  **If you have an active Stampede3 allocation** then you may begin the data migration process from Stampede2 to Stampede3.  During this migration period Stampede2's `/home` and `/scratch` systems will be temporarily mounted on Stampede3 and will be accessible through the `$HOME_S2` and `$SCRATCH_S2` environment variables respectively.  

!!! warning
	The Stampede2 file mounts are temporary and will be removed once Stampede3 is in full production.

You do not need to migrate data from `$WORK` (Stockyard) as that file system will be automatically mounted on Stampede3.  However, anything in your `$HOME` or `$SCRATCH` directories that you wish to retain will need to be moved.  

!!! important
	Migrate **only** the data you wish to keep from Stampede2.  

### [Examples](#migrating-examples) { #migrating-examples }

**If you have an active Stampede3 allocation** you can access Stampede3 via `ssh` as you do with other TACC resources.  Use the same password and MFA method as for accessing Stampede2.

``` cmd-line
ssh username@stampede3.tacc.utexas.edu
```
To move your data, we recommend using either the UNIX `cp` or `rsync` utilities.  

To copy a single file from Stampede2 to Stampede3: 

```cmd-line
stampede3$ cp $HOME_S2/filename $HOME
```
or

```cmd-line
stampede3$ rsync -r $HOME_S2/filename $HOME
```

To copy a directory: 

```cmd-line
stampede3$ rsync -r $SCRATCH_S2/dirName $SCRATCH
```
or

```cmd-line
stampede3$ cp -r $SCRATCH_S2/dirName $SCRATCH
```


## [Introduction](#intro) { #intro }

The National Science Foundation (NSF) has generously awarded the University of Texas at Austin funds for TACC's Stampede3 system ([Award Abstract # 2320757](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2320757)). <!-- put link to citation here? --> 

### [Allocations](#intro-allocations) { #intro-allocations }

Submit all Stampede3 allocations requests through the NSF's [ACCESS](https://allocations.access-ci.org/) project. General information related to allocations, support and operations is available via the ACCESS website <http://access-ci.org>.

Requesting and managing allocations will require creating a username and password on this site. These credentials do not have to be the same as those used to access the TACC User Portal and TACC resources. Principal Investigators (PIs) and their allocation managers will be able to add/remove users to/from their allocations and submit requests to renew, supplement, extend, etc. their allocations. PIs attempting to manage an allocation via the [TACC User Portal](https://tacc.utexas.edu/portal/dashboard) will be redirected to the ACCESS website.

