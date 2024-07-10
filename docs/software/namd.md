# NAMD at TACC
*Last update: July 7, 2024*

<img alt="NAMD logo" src="../imgs/namd-logo.png" style="width:40%;">   
<a href="http://www.ks.uiuc.edu/Research/namd/">NAMD</a> **Na**noscale **M**olecular **D**ynamics program, is a parallel molecular dynamics code designed for high-performance simulation of large biomolecular systems. Based on Charm++ parallel objects, NAMD scales to hundreds of cores for typical simulations and beyond 500,000 cores for the largest simulations. NAMD uses the popular molecular graphics program VMD for simulation setup and trajectory analysis, but is also file-compatible with AMBER, CHARMM, and X-PLOR. NAMD can perform geometry optimization, molecular dynamics simulations, chemical and conformational free energy calculations, enhanced sampling via replica exchange. It also supports Tcl based scripting and steering forces.  

## [Installations](#installations) { #installations }

NAMD is currently installed on TACC's [Frontera](../../hpc/frontera), [Stampede3](../../hpc/stampede3), and [Lonestar6](../../hpc/lonestar6) compute resources.  NAMD is managed under the module system on TACC resources. Read the following instructions carefully. NAMD performance is particularly sensitive to its configuration.  Try running benchmarks with different configurations to find your optimal NAMD set up. You can initiate interactive [`idev`](../../software/idev) debugging sessions on all systems.

## [NAMD on Frontera](#running-frontera) { #running-frontera }

The recommended and latest installed NAMD version is 2.14 on Frontera. Users are welcome to install different NAMD versions in their own directories.

``` cmd-line
login1$ module load namd/2.14
```

### [Job Script](#running-frontera-jobscript) { #running-frontera-jobscript }

!!! tip
	TACC staff recommends that users attempt runs with 4 tasks per node and 8 tasks per node (scales better at large number of nodes) and then pick the configuration that provides the best performance.

4 tasks per node:

``` job-script
#SBATCH -J test         # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2            # Total number of nodes
#SBATCH -n 8            # Total number of mpi tasks
#SBATCH -p normal       # Queue (partition) name 
#SBATCH -t 24:00:00     # Run time (hh:mm:ss) - 24 hours

module load namd/2.14
ibrun namd2 +ppn 13 \
			+pemap 2-26:2,30-54:2,3-27:2,31-55:2 \
			+commap 0,28,1,29 input &> output
```

8 tasks per node:

``` job-script
#SBATCH -J test         # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12           # Total number of nodes
#SBATCH -n 96           # Total number of mpi tasks
#SBATCH -p normal       # Queue (partition) name -- skx-normal, skx-dev, etc.
#SBATCH -t 24:00:00     # Run time (hh:mm:ss) - 24 hours

module load namd/2.14
ibrun namd2 +ppn 6 \
			+pemap 2-12:2,16-26:2,30-40:2,44-54:2,3-13:2,17-27:2,31-41:2,45-55:2\
			+commap 0,14,28,42,1,15,29,43 input &> output
```

For very large simulations, users may want to use compressed structures. See the [NAMD wiki: NamdMemoryReduction](https://www.ks.uiuc.edu/Research/namd/wiki/index.cgi?NamdMemoryReduction) to prepare your compressed input files and set up your input files. In this case use the `namd2_memopt` executable instead of `namd2`: 

compressed input files

``` job-script
	ibrun namd2_memopt +ppn 6 \
	 			+pemap 2-12:2,16-26:2,30-40:2,44-54:2,3-13:2,17-27:2,31-41:2,45-55:2 \
	 			+commap 0,14,28,42,1,15,29,43 input &> output
```


## [NAMD on Stampede3](#running-stampede3) { #running-stampede3 }


Note: The way to run NAMD on Sapphire Rapids nodes is shown as following:
Example of 4 tasks per node. Good for small number of nodes.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2                  # Total number of nodes
#SBATCH -n 8                  # Total number of mpi tasks
#SBATCH -p spr                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0b6
ibrun namd3 +ppn 27 \
			+pemap 2-54:2,58-110:2,3-55:2,59-111:2 \
			+commap 0,56,1,57 input &> output
```

Example of 8 tasks per node. Scale better for large number of nodes.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12                 # Total number of nodes
#SBATCH -n 96                 # Total number of mpi tasks
#SBATCH -p spr                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0b6
ibrun namd3 +ppn 13 \
			+pemap 2-26:2,30-54:2,58-82:2,86-110:2,3-27:2,31-55:2,59-83:2,87-111:2 \
			+commap 0,28,56,84,1,29,57,85 input &> output
```

Note: The way to run NAMD on Ice Lake nodes is shown as following:
Example of 4 tasks per node. Good for small number of nodes.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2                  # Total number of nodes
#SBATCH -n 8                  # Total number of mpi tasks
#SBATCH -p icx                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0b6
ibrun namd3 +ppn 19 \
			+pemap 2-38:2,42-78:2,3-39:2,43-79:2 \
			+commap 0,40,1,41 input &> output
```

Example of 8 tasks per node. Scale better for large number of nodes.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12                 # Total number of nodes
#SBATCH -n 96                 # Total number of mpi tasks
#SBATCH -p icx                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0b6
ibrun namd3 +ppn 9 \
			+pemap 2-18:2,22-38:2,42-58:2,62-78:2,3-19:2,23-39:2,43-59:2,63-79:2 \
			+commap 0,20,40,60,1,21,41,61 input &> output
```

Note: The way to run NAMD on Skylake nodes is shown as following:
Example of 4 tasks per node. Good for small number of nodes.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2                  # Total number of nodes
#SBATCH -n 8                  # Total number of mpi tasks
#SBATCH -p skx                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0b6
ibrun namd3 +ppn 11 \ 
			+pemap 2-22:2,26-46:2,3-23:2,27-47:2 \ 
			+commap 0,24,1,25 input &> output
```

Example of 8 tasks per node. Scale better for large number of nodes.

```job-script
#!/bin/bash
#SBATCH -J test              # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12                # Total number of nodes
#SBATCH -n 96                # Total number of mpi tasks
#SBATCH -p skx               # Queue name
#SBATCH -t 24:00:00          # Run time (hh:mm:ss) - 24 hours

module load namd/3.0b6
ibrun namd3 +ppn 5 \
			+pemap 2-10:2,14-22:2,26-34:2,38-46:2,3-11:2,15-23:2,27-35:2,39-47:2 \
			+commap 0,12,24,36,1,13,25,37 input &> output
```


## [NAMD on Lonestar6](#running-lonestar6) { #running-lonestar6 }

NAMD ver2.14 is installed on Lonestar6 as this version provides best performance. Feel free to install your own newer version locally. 

``` cmd-line
login1$ module load namd/2.14
```

### [Job Script](#running-lonestar6-jobscript) { #running-lonestar6-jobscript }

!!! tip
	TACC staff recommends assigning 4 tasks per node for NAMD jobs running on Lonestar6's compute nodes.

The following Lonestar6 job script requests 2 node and 8 MPI tasks. To run the same job on more nodes, vary the `-N` and `-n` Slurm directives, **ensuring the value of `n` is four times the value of `N`**.  

``` job-script
#!/bin/bash
#SBATCH -J test   		# Job Name
#SBATCH -o test.o%j
#SBATCH -N 2      		# Total number of nodes
#SBATCH -n 8      		# Total number of mpi tasks
#SBATCH -p normal 		# Queue name
#SBATCH -t 24:00:00 	# Run time (hh:mm:ss) - 24 hours

module load namd/2.14
ibrun namd2 +ppn 31 \
			+pemap 1-31,33-63,65-95,97-127 \
			+commap 0,32,64,96 input &> output
```

## [References](#refs) { #refs }

* [NAMD](http://www.ks.uiuc.edu/Research/namd/) website
* [NAMD 2.14 User Guide](http://www.ks.uiuc.edu/Research/namd/2.14/ug/)

{% include 'aliases.md' %}
