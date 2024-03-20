# Quantum Espresso at TACC
*Last update: May 19, 2020*


<img alt="Quantum Espresso logo" src="../imgs/qespresso-logo.png" style="width: 75px;" />
Quantum Espresso (QE) is an integrated suite of open-source codes for electronic-structure calculations and materials modeling at the nanoscale. Quantum Espresso (op<b>E</b>n-<b>S</b>ource <b>P</b>ackage for <b>R</b>esearch in <b>E</b>lectronic <b>S</b>tructure, <b>S</b>imulation, and <b>O</b>ptimization) is based on density-functional theory, plane waves, and pseudopotentials.  

## [Installations](#installations) { #installations }

The latest QE stable release is installed on TACC's [Stampede2](../../hpc/stampede2), [Lonestar6](../../hpc/lonestar6) and [Frontera](../../hpc/frontera) systems. Use `module` commands to load the latest installed version by default, and to list all installed versions.  

``` cmd-line
$ module load qe
$ module spider qe
```

You can find extensive documentation for each QE component in the respective Doc directory, for example:

``` cmd-line
$ cd $TACC_QE_DIR/PW/Doc		# explore PWscf documentation
```

## [Running QE](#running) { #running }

Quantum Espresso executables have many optional command line arguments described in the [user manual](http://www.quantum-espresso.org/resources/users-manual). QE users may run with their default settings usually with no problem. QE contains many packages and executables and `pw.x` is the most popular. **We strongly recommend you refer to the [QE manual](http://www.quantum-espresso.org/resources/users-manual) to learn how to construct input files, and learn the correct and optimal way to run your codes**.

Use the following job scripts for Quantum Espresso runs on Stampede2 and Frontera. To configure a script for Lonestar6, vary the `-N` and `-n` directives.

### [Sample Job Script: Frontera](#jobscript-frontera) { #jobscript-frontera }

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

module load qe/6.4.1                        # setup environment
ibrun pw.x -input qeinput > qe_test.out     # launch job
```

### [Sample Job Script: Stampede2](#jobscript-stampede2) { #jobscript-stampede2 }

The script below submits a Quantum Espresso job to Stampede2's `normal` queue (KNL compute nodes), requesting 4 nodes and 256 tasks for a maximum of 4 hours. Refer to Stampede2's [Running Jobs](../../hpc/stampede2#running) section for more Slurm options. 

``` job-script
#!/bin/bash 
#SBATCH -J qe          						# define the job name
#SBATCH -o qe.%j.out    					# define stdout & stderr output files 
#SBATCH -e qe.%j.err 
#SBATCH -N 4         						# request 4 nodes 
#SBATCH -n 256								# 256 total tasks = 64 tasks/node
#SBATCH -p normal     						# submit to <code>normal</code> queue 
#SBATCH -t 4:00:00       					# run for 4 hours max 
#SBATCH -A projectname

module load qe/6.2.1						# setup environment
ibrun pw.x -input qeinput > qe_test.out	    # launch job
```

## [References](#refs) { #refs }

* [Quantum Espresso home page](http://www.quantum-espresso.org/)
* [Quantum Espresso User Manual](http://www.quantum-espresso.org/resources/users-manual)


{% include 'aliases.md' %}
