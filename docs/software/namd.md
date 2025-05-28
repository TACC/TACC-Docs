# NAMD at TACC
*Last update: April 28, 2025*

<!-- ![NAMD logo](../imgs/namd-logo.png){ .align-right } -->
<img src="../imgs/namd-logo.png" width="300" alt="NAMD logo" class="align-right">

[NAMD](http://www.ks.uiuc.edu/Research/namd/), **Na**noscale **M**olecular **D**ynamics program, is a parallel molecular dynamics code designed for high-performance simulation of large biomolecular systems. Based on Charm++ parallel objects, NAMD scales to hundreds of cores for typical simulations and beyond 500,000 cores for the largest simulations. NAMD uses the popular molecular graphics program VMD for simulation setup and trajectory analysis, but is also file-compatible with AMBER, CHARMM, and X-PLOR. NAMD can perform geometry optimization, molecular dynamics simulations, chemical and conformational free energy calculations, enhanced sampling via replica exchange. It also supports Tcl based scripting and steering forces.  

## Installations { #installations }

NAMD is currently installed on TACC's [Frontera][TACCFRONTERAUG], [Stampede3][TACCSTAMPEDE3UG], [Lonestar6][TACCLONESTAR6UG] and [Vista][TACCVISTAUG] compute resources.  NAMD is managed under the [Lmod][TACCLMOD] module system on TACC resources. 

!!! important
	Read the following instructions carefully. NAMD performance is particularly sensitive to its configuration.  Try running benchmarks with different configurations to find your optimal NAMD set up. You can initiate interactive [`idev`][TACCIDEV] debugging sessions on all systems.

You are welcome to install different NAMD versions in your own directories. See [Building Third-Party Software](../../basics/software/#building-third-party-software) in the [Software at TACC](../../basics/software) documentation.

## Vista { #vista }

The following sample job scripts demonstrate how to run NAMD on Vista's [Grace-Hopper](../../hpc/vista/#system-gh) and [Grace-Grace](../../hpc/vista/#system-gg) GPU nodes.

### GH 1 Task per Node

Job script for Vista's Grace-Hopper nodes: 1 task per node.

```job-script
#!/bin/bash
#SBATCH -J test         # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2            # Total number of nodes
#SBATCH -n 2            # Total number of mpi tasks
#SBATCH -p gh           # Queue name
#SBATCH -t 24:00:00     # Run time (hh:mm:ss) - 24 hours

module load cuda/12.6
module load nvmath/12.6.0
module load openmpi/5.0.5
module load namd-gpu/3.0.1
      
run_namd_gpu test.namd test.out
```

### GG 4 Tasks per Node

Job script for Vista's Grace-Grace nodes: 4 tasks per node.

```job-script
#!/bin/bash
#SBATCH -J test          # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2             # Total number of nodes
#SBATCH -n 8             # Total number of mpi tasks
#SBATCH -p gg            # Queue name
#SBATCH -t 24:00:00      # Run time (hh:mm:ss) - 24 hours

module load namd/3.0.1
srun --mpi=pmpi2 namd3 +ppn 35 +pemap 1-35,37-71,73-107,109-143 +commap 0,36,72,108 input &> output
```

### GG 8 Tasks per Node

Job script for Vista's Grace-Grace nodes: 8 tasks per node.

```job-script
#!/bin/bash
#SBATCH -J test         # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12           # Total number of nodes
#SBATCH -n 96           # Total number of mpi tasks
#SBATCH -p gg           # Queue name
#SBATCH -t 24:00:00     # Run time (hh:mm:ss) - 24 hours

module load namd/3.0.1
srun --mpi=pmi2 namd3 +ppn 17 +pemap 1-17,19-35,37-53,55-71,73-89,91-107,109-125,127-143 +commap 0,18,36,54,72,90,108,126 input &> output
```

## Frontera { #frontera }

The recommended and latest installed NAMD version is 3.0 on Frontera. 

``` cmd-line
login1$ module load namd/3.0
```
!!! tip
	TACC staff recommends you attempt runs with 4 tasks per node and 8 tasks per node (scales better at large number of nodes), then pick the configuration that provides the best performance.

The following sample job scripts demonstrate how to run NAMD on Frontera's [Cascade Lake](../../hpc/frontera/#system-clx) and [GPU](../../hpc/frontera/#system-gpu) nodes.

### CLX 4 Tasks per Node

Job script for Frontera's Cascade Lake nodes: 4 tasks per node.

``` job-script
#SBATCH -J test         # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2            # Total number of nodes
#SBATCH -n 8            # Total number of mpi tasks
#SBATCH -p normal       # Queue (partition) name 
#SBATCH -t 24:00:00     # Run time (hh:mm:ss) - 24 hours

module load namd/3.0
ibrun namd3 +ppn 13 \
			+pemap 2-26:2,30-54:2,3-27:2,31-55:2 \
			+commap 0,28,1,29 input &> output
```

### CLX 8 Tasks per Node

Job script for Frontera's Cascade Lake nodes: 8 tasks per node.

``` job-script
#SBATCH -J test         # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12           # Total number of nodes
#SBATCH -n 96           # Total number of mpi tasks
#SBATCH -p normal       # Queue (partition) name -- skx-normal, skx-dev, etc.
#SBATCH -t 24:00:00     # Run time (hh:mm:ss) - 24 hours

module load namd/3.0
ibrun namd3 +ppn 6 \
			+pemap 2-12:2,16-26:2,30-40:2,44-54:2,3-13:2,17-27:2,31-41:2,45-55:2\
			+commap 0,14,28,42,1,15,29,43 input &> output
```

### GPU 1 Task per Node

Job script for Frontera's GPU nodes: 1 task per node.

``` job-script
#!/bin/bash
#SBATCH -J test         # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2            # Total number of nodes
#SBATCH -n 2            # Total number of mpi tasks
#SBATCH -p gtx          # Queue name
#SBATCH -t 24:00:00     # Run time (hh:mm:ss) - 24 hours

run_namd_gpu namd_input output
```

## Stampede3 { #stampede3 }

The following sample job scripts demonstrate how to run NAMD on Stampede3's [Sapphire Rapids](../../hpc/stampede3/#system-spr), [Skylake](../../hpc/stampede3/#system-skx) and [Icelake](../../hpc/stampede3/#system-icx) nodes.

### SPR 4 Tasks per Node 

Job script for Stampede3's Sapphire nodes: 4 tasks per node.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2                  # Total number of nodes
#SBATCH -n 8                  # Total number of mpi tasks
#SBATCH -p spr                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0
ibrun namd3 +ppn 27 \
			+pemap 2-54:2,58-110:2,3-55:2,59-111:2 \
			+commap 0,56,1,57 input &> output
```

### SPR 8 Tasks per Node

Job script for Stampede3's Sapphire nodes: 8 tasks per node.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12                 # Total number of nodes
#SBATCH -n 96                 # Total number of mpi tasks
#SBATCH -p spr                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0
ibrun namd3 +ppn 13 \
			+pemap 2-26:2,30-54:2,58-82:2,86-110:2,3-27:2,31-55:2,59-83:2,87-111:2 \
			+commap 0,28,56,84,1,29,57,85 input &> output
```

### ICX 4 Tasks per Node

Job script for Stampede3's Icelake nodes: 4 tasks per node.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2                  # Total number of nodes
#SBATCH -n 8                  # Total number of mpi tasks
#SBATCH -p icx                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0
ibrun namd3 +ppn 19 \
			+pemap 2-38:2,42-78:2,3-39:2,43-79:2 \
			+commap 0,40,1,41 input &> output
```

### ICX 8 Tasks per Node

Job script for Stampede3's Icelake nodes: 8 tasks per node.

```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12                 # Total number of nodes
#SBATCH -n 96                 # Total number of mpi tasks
#SBATCH -p icx                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0
ibrun namd3 +ppn 9 \
			+pemap 2-18:2,22-38:2,42-58:2,62-78:2,3-19:2,23-39:2,43-59:2,63-79:2 \
			+commap 0,20,40,60,1,21,41,61 input &> output
```

### SKX 4 tasks per node

Job script for Stampede3's Skylake nodes: 4 tasks per node.


```job-script
#!/bin/bash
#SBATCH -J test               # Job Name
#SBATCH -o test.o%j
#SBATCH -N 2                  # Total number of nodes
#SBATCH -n 8                  # Total number of mpi tasks
#SBATCH -p skx                # Queue name
#SBATCH -t 24:00:00           # Run time (hh:mm:ss) - 24 hours

module load namd/3.0
ibrun namd3 +ppn 11 \ 
			+pemap 2-22:2,26-46:2,3-23:2,27-47:2 \ 
			+commap 0,24,1,25 input &> output
```

### SKX 8 Tasks per Node

Job script for Stampede3's Skylake nodes: 8 tasks per node.

```job-script
#!/bin/bash
#SBATCH -J test              # Job Name
#SBATCH -o test.o%j
#SBATCH -N 12                # Total number of nodes
#SBATCH -n 96                # Total number of mpi tasks
#SBATCH -p skx               # Queue name
#SBATCH -t 24:00:00          # Run time (hh:mm:ss) - 24 hours

module load namd/3.0
ibrun namd3 +ppn 5 \
			+pemap 2-10:2,14-22:2,26-34:2,38-46:2,3-11:2,15-23:2,27-35:2,39-47:2 \
			+commap 0,12,24,36,1,13,25,37 input &> output
```


## Lonestar6 { #lonestar6 }

### CPU Nodes: 4 Tasks per Node
NAMD ver3.0 is installed on Lonestar6 as this version provides best performance. 

```cmd-line
login1$ module load namd/3.0
```

TACC staff recommends assigning 4 tasks per node for NAMD jobs running on Lonestar6's CPU [compute](../../hpc/lonestar6/#system-compute) nodes.

The following Lonestar6 job script requests 2 node and 8 MPI tasks. To run the same job on more nodes, vary the `-N` and `-n` Slurm directives, **ensuring the value of `n` is four times the value of `N`**.  

``` job-script
#!/bin/bash
#SBATCH -J test   		# Job Name
#SBATCH -o test.o%j
#SBATCH -N 2      		# Total number of nodes
#SBATCH -n 8      		# Total number of mpi tasks
#SBATCH -p normal 		# Queue name
#SBATCH -t 24:00:00 	# Run time (hh:mm:ss) - 24 hours

module load namd/3.0

ibrun namd3 +ppn 31 \
			+pemap 1-31,33-63,65-95,97-127 \
			+commap 0,32,64,96 input &> output
```

### GPU Nodes: 1 Task per Node
NAMD ver3.0 is installed on Lonestar6 as this version provides best performance. 

```cmd-line
login1$ module load namd_gpu/3.0
```

TACC staff recommends assigning 1 task per node for NAMD jobs running on Lonestar6's GPU [compute](../../hpc/lonestar6/#system-compute) nodes.

The following Lonestar6 job script requests 3 GPU nodes. To run the same job on more nodes, vary the `-N` and `-n` Slurm directives, **ensuring the value of `n` is the same as that of `N`**.  

``` job-script
#!/bin/bash
#SBATCH -J test   		# Job Name
#SBATCH -o test.o%j
#SBATCH -N 3      		# Total number of nodes
#SBATCH -n 3      		# Total number of mpi tasks
#SBATCH -p gpu-a100 		# Queue name
#SBATCH -t 24:00:00 	# Run time (hh:mm:ss) - 24 hours

module load gcc/11.2
module load mkl
module load cuda/12.2
module load namd_gpu/3.0

run_namd_gpu input output
```
## References { #refs }

* [NAMD](http://www.ks.uiuc.edu/Research/namd/) website
* [NAMD 3.01 User Guide](https://www.ks.uiuc.edu/Research/namd/3.0.1/ug/)

{% include 'aliases.md' %}
