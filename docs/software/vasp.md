# VASP at TACC
*Last update: April 27, 2022*


<img alt="VASP logo" src="../imgs/vasp-logo.png" style="width: 75px;" />
**V**ienna **A**b initio **S**imulation **P**ackage (VASP) is a computer program for atomic scale materials modeling, e.g. electronic structure calculations and quantum-mechanical molecular dynamics, from first principles.


## [Licenses](#licenses) { #licenses }

VASP requires an individual license. TACC's HPC support license allows us to install only the compiled VASP executables and grant the access to licensed users who have accounts on our systems. We are not allowed to share source code.  

If you have your own license and want to use your own compilation, you may [install it in your own account](../../hpc/stampede2#building-basics-thirdparty). If you wish to use TACC's installed version, then TACC will have to verify your license. [Submit a support ticket][HELPDESK] and include the following information: your **full** name, affiliated institution, and your TACC user name along with the license number or a scanned PDF of the license. TACC will notify you once the license is confirmed. 

### [Installations](#installations) { #installations }

The latest stable release of VASP is installed on [Stampede2](../../hpc/stampede2), [Lonestar6](../../hpc/lonestar6) and [Frontera](../../hpc/frontera) systems. Note that you will be unable to load any VASP module until your license is confirmed.

Use the "[`module`](https://lmod.readthedocs.io/en/latest/)" commands to explore other VASP installations, for example: 

``` cmd-line
login1$ module spider vasp
login1$ module spider vasp/6.3.0
```

Then, either interactively or via a batch script, load the appropriate module: 

``` cmd-line
login1$ module load vasp/6.3.0
```

## [Running VASP](#running-interactive) { #running-interactive }

TACC staff recently presented "[VASP on Frontera and Stampede2](https://learn.tacc.utexas.edu/mod/page/view.php?id=100)", detailing how to build and run VASP, and troubleshoot run time issues on TACC systems. Check out the recorded webinar and accompanying slides. 

Modify the following sample job scripts for VASP jobs on Stampede2, Lonestar6 and Frontera. 

### [Sample Job Script: VASP on Lonestar6](#jobscript-ls6) { #jobscript-ls6 }

The script below submits a VASP job to Lonestar6's normal queue ( Milan compute nodes), requesting 2 nodes and 256 tasks for a maximum of 4 hours. Refer to lonestar6's Running Jobs section for more Slurm options.

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

## [Sample Job Script: VASP on Frontera](#jobscript-frontera) { #jobscript-frontera }

The script below submits a VASP job to [Frontera's normal queue](../../hpc/frontera#queues) (CLX compute nodes), requesting 4 nodes and 224 tasks for a maximum of 4 hours. Refer to Frontera's [Running Jobs](../../hpc/frontera#running) section for more Slurm options.

``` job-script
#!bin/bash 
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


### [Sample Job Script: VASP on Stampede2](#jobscript-stampede2) { #jobscript-stampede2 }

The script below requests 4 nodes and 256 tasks, for a maximum of four hours in Stampede2's `normal` queue (KNL compute nodes). See the [Stampede2 User Guide: Common `sbatch` Options](../../hpc/stampede2#running-sbatch) for more about job options.  

``` job-script
#!/bin/bash 
#SBATCH -J vasp          
#SBATCH -o vasp.%j.out     
#SBATCH -e vasp.%j.err 
#SBATCH -n 256         
#SBATCH -N 4 
#SBATCH -p normal      
#SBATCH -t 4:00:00        
#SBATCH -A projectnumber

module load vasp/5.4.4.p12
ibrun vasp_std > vasp_test.out
```

## [References](#refs) { #refs }

<!-- * [HPC Application Tutorial: VASP on Frontera and Stampede2](https://learn.tacc.utexas.edu/mod/page/view.php?id=100) (March 2020) -->
* [The VASP Site](https://www.vasp.at/) home
* [The VASP Manual](https://www.vasp.at/wiki/index.php/The_VASP_Manual)

{% include 'aliases.md' %}
