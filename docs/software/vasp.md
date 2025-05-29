# VASP at TACC
*Last update: May 12, 2025*

<!-- ![VASP logo](../imgs/vasp-logo.png){ .align-right width="200" } -->
<img src="../imgs/vasp-logo.png" width="200" alt="VASP logo" class="align-right">

**V**ienna **A**b initio **S**imulation **P**ackage (VASP) is a computer program for atomic scale materials modeling, e.g. electronic structure calculations and quantum-mechanical molecular dynamics, from first principles.


## VASP Licenses { #licenses }

VASP requires an individual license. TACC's HPC support license allows us to install only the compiled VASP executables and grant the access to licensed users who have accounts on our systems. We are not allowed to share source code.

If you have your own license and want to use your own compilation, you may install it in your own account. If you wish to use TACC's installed version, then TACC will have to verify your license. [Submit a support ticket][SUBMITTICKET] and include the following information: 

* full name 
* affiliated institution 
* TACC login ID 
* email address that was used by your VASP PI to register you under that license on VASP portal

TACC will confirm the license by using this email address on the VASP portal. If you get the license from Material Design, TACC will use that information to contact Material Design and confirm the license. 

## Installations { #installations }

The latest stable release of VASP is installed on Stampede3, Lonestar6 and Frontera systems. 

!!! important
	You cannot load any VASP module until your license is confirmed. [See above](#licenses).

Once your license is active, use [Lmod][TACCLMOD]'s `module` commands to explore other VASP installations, for example:

``` cmd-line
login1$ module spider vasp
login1$ module spider vasp/6.3.0
```

Then, either interactively or via a batch script, load the appropriate module:

``` cmd-line
login1$ module load vasp/6.3.0
```

## Running VASP Jobs { #running }

You may use and customize the following sample job scripts for VASP jobs on TACC's Stampede3, Lonestar6 and Frontera resources.

### Sample Job Script: VASP on Vista { #running-vista }

The script below submits a VASP job to Vista's `gg` queue ( Grace compute nodes), requesting 2 nodes and 280 tasks for a maximum of 4 hours.

```job-script
#!/bin/bash
#SBATCH -J vasp
#SBATCH -o vasp.%j.out
#SBATCH -e vasp.%j.err
#SBATCH -n 280
#SBATCH -N 2
#SBATCH -p gg
#SBATCH -t 4:00:00
#SBATCH -A projectnumber
module load vasp/6.4.3
ibrun vasp_std > vasp_test.out
```

### Sample Job Script: VASP on Stampede3 { #running-stampede3 }


!!! important
	DO NOT run VASP using Stampede3's SPR nodes!<br> TACC staff has noticed many VASP jobs causing issues on the SPR nodes and impacting overall system stability and performance.<br> Please run your VASP jobs using either the [SKX](../../hpc/stampede3#table3) or [ICX](../../hpc/stampede3#table4) nodes.   

The issue appears to be memory overuse: each SPR node has 112 cores on 2 sockets and only 128 GB memory in total, so each core has about 1GB memory.  Compare to the SKX (48 nodes, 192GB) and ICX (80 cores and 256GB) nodes, the SPR nodes have much less total and per task memory.  Therefore jobs running on the SPR nodes will require more nodes, yet need less tasks per node.  This is not an efficient use of resources.


!!! tip
	TACC staff recommends that former Stampede2 users first conduct numerical consistency tests using the `skx` compute nodes. From there, determine the best node and queue configuration for your application.

The script below requests 4 nodes and 192 tasks, for a maximum of four hours in [Stampede3's `skx` queue](../../hpc/stampede3/#queues) (SKX compute nodes). 


``` job-script
#!/bin/bash 
#SBATCH -J vasp          
#SBATCH -o vasp.%j.out     
#SBATCH -e vasp.%j.err 
#SBATCH -n 192         
#SBATCH -N 4 
#SBATCH -p skx      
#SBATCH -t 4:00:00        
#SBATCH -A projectnumber

module load vasp/5.4.4.pl2
ibrun vasp_std > vasp_test.out
```

### Sample Job Script: VASP on Frontera { #running-frontera }

The script below submits a VASP job to [Frontera's `normal` queue](../../hpc/frontera/#queues) (CLX compute nodes), requesting 4 nodes and 224 tasks for a maximum of 4 hours. 

``` job-script
#!/bin/bash 
#SBATCH -J vasp          
#SBATCH -o vasp.%j.out     
#SBATCH -e vasp.%j.err 
#SBATCH -n 224         
#SBATCH -N 4 
#SBATCH -p normal      
#SBATCH -t 4:00:00        
#SBATCH -A projectnumber

module load vasp/5.4.4.pl2
ibrun vasp_std > vasp_test.out
```
### Sample Job Script: VASP on Lonestar6 { #running-lonestar6 }

The script below submits a VASP job to [Lonestar6's `normal` queue](../../hpc/lonestar6#queues) ( Milan compute nodes), requesting 2 nodes and 256 tasks for a maximum of 4 hours. 

``` job-script
#!/bin/bash 
#SBATCH -J vasp          
#SBATCH -o vasp.%j.out     
#SBATCH -e vasp.%j.err 
#SBATCH -n 256         
#SBATCH -N 2 
#SBATCH -p normal      
#SBATCH -t 4:00:00        
#SBATCH -A projectnumber

module load vasp/5.4.4.pl2
ibrun vasp_std > vasp_test.out
```

## References { #refs }

* [The VASP Site home](https://www.vasp.at/)
* [The VASP Manual](https://www.vasp.at/wiki/index.php/The_VASP_Manual)
* [TACC Software List](https://tacc.utexas.edu/use-tacc/software-list/)

{% include 'aliases.md' %}
