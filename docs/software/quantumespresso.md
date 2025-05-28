# Quantum Espresso at TACC
*Last update: May 15, 2024*

<!-- ![Quantum Espresso logo](../imgs/qespresso-logo.png){ .align-right width="300" } -->
<img src="../imgs/qe-logo.png" width="300" alt="Quantum Espresso logo" align="right">

Quantum Espresso (QE) is an integrated suite of open-source codes for electronic-structure calculations and materials modeling at the nanoscale. Quantum Espresso (**Quantum** op<b>E</b>n-<b>S</b>ource <b>P</b>ackage for <b>R</b>esearch in <b>E</b>lectronic <b>S</b>tructure, <b>S</b>imulation, and <b>O</b>ptimization) is based on density-functional theory, plane waves, and pseudopotentials.  

## Installations { #installations }

The latest QE stable release is installed on TACC's [Stampede3][TACCSTAMPEDE3UG], [Lonestar6][TACCLONESTAR6UG] and [Frontera][TACCFRONTERAUG] systems. Use `module` commands to load the latest installed version by default, and to list all installed versions.  

``` cmd-line
$ module load qe
$ module spider qe
```

## Running QE { #running }

Quantum Espresso executables have many optional command line arguments described in the [user manual](http://www.quantum-espresso.org/resources/users-manual). QE users may run with their default settings usually with no problem. QE contains many packages and executables and `pw.x` is the most popular. 

!!!tip
	TACC staff strongly recommends you refer to the [Quantum Espresso documentation](http://www.quantum-espresso.org/resources/users-manual) to learn how to construct input files, and learn the correct and optimal way to run your codes.

Use the following job scripts for Quantum Espresso runs on Stampede3, Lonestar6 and Frontera. 

### Sample Job Script: Lonestar6 { #jobscript-lonestar6 }

```job-script
#!/bin/bash 
#SBATCH -J qe                               # define the job name
#SBATCH -o qe.%j.out                        # define stdout & stderr output files 
#SBATCH -e qe.%j.err 
#SBATCH -N 2                                # request 4 nodes 
#SBATCH -n 256                              # 224 total tasks = 56 tasks/node
#SBATCH -p normal                           # submit to "normal" queue 
#SBATCH -t 4:00:00                          # run for 4 hours max 
#SBATCH -A projectname

module load qe/7.3                          # setup environment
ibrun pw.x -input qeinput > qe_test.out     # launch job
```

### Sample Job Script: Frontera { #jobscript-frontera }

The script below submits a Quantum Espresso job to Frontera's normal queue (CLX compute nodes), requesting 4 nodes and 224 tasks for a maximum of 4 hours. Refer to Frontera's [Running Jobs](../../hpc/frontera#running) section for more Slurm options.

``` job-script
#!/bin/bash 
#SBATCH -J qe                               # define the job name
#SBATCH -o qe.%j.out                        # define stdout & stderr output files 
#SBATCH -e qe.%j.err 
#SBATCH -N 4                                # request 4 nodes 
#SBATCH -n 224                              # 224 total tasks = 56 tasks/node
#SBATCH -p normal                           # submit to "normal" queue 
#SBATCH -t 4:00:00                          # run for 4 hours max 
#SBATCH -A projectname

module load qe/7.3                          # setup environment
ibrun pw.x -input qeinput > qe_test.out     # launch job
```

### Sample Job Script: Stampede3 { #jobscript-stampede3 }

The script below submits a Quantum Espresso job to Stampede3's `skx` queue (SkyLake compute nodes), requesting 4 nodes and 192 tasks for a maximum of 4 hours. Refer to Stampede3's [Running Jobs](../../hpc/stampede3#running) section for more Slurm options. 

``` job-script
#!/bin/bash 
#SBATCH -J qe                               # define the job name
#SBATCH -o qe.%j.out                        # define stdout & stderr output files 
#SBATCH -e qe.%j.err 
#SBATCH -N 4                                # request 4 nodes 
#SBATCH -n 192                              # 224 total tasks = 56 tasks/node
#SBATCH -p skx                              # submit to "normal" queue 
#SBATCH -t 4:00:00                          # run for 4 hours max 
#SBATCH -A projectname

module load qe/7.3                          # setup environment
ibrun pw.x -input qeinput > qe_test.out     # launch job

```

## References { #refs }

* [Quantum Espresso home page](http://www.quantum-espresso.org/)
* [Quantum Espresso User Manual](http://www.quantum-espresso.org/resources/users-manual)


{% include 'aliases.md' %}
