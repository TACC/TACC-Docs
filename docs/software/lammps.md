# LAMMPS at TACC
*Last update: March 11, 2024*

<img style="float:left; padding-bottom:20px; padding-right:20px; width:300px;" alt="LAMMPS logo" src="../imgs/lammps-logo.png">LAMMPS is a classical molecular dynamics code developed at Sandia National Laboratories and is available under the GPL license. LAMMPS (<b>L</b>arge-scale <b>A</b>tomic/<b>M</b>olecular <b>M</b>assively <b>P</b>arallel <b>S</b>imulator) makes use of spatial-decomposition techniques to partition the simulation domain.  LAMMPS runs in serial or in parallel using MPI. The code is capable of modeling systems with millions or even billions of particles on a large High Performance Computing machine. A variety of force fields and boundary conditions are provided in LAMMPS which can be used to model atomic, polymeric, biological, metallic, granular, and coarse-grained systems.


## Installations { #installations }

LAMMPS is installed on TACC's [Stampede3](../hpc/stampede3.md), [Lonestar6](../hpc/lonestar6.md) and [Frontera](../hpc/frontera.md) systems. As of this date, the latest version installed on the system is 21Nov23.

Users are welcome to install different versions of LAMMPS in their own directories (see [Building Third Party Software](../../hpc/stampede3/#building) in the Stampede3 User Guide).

``` cmd-line
$ module spider lammps      # list installed LAMMPS versions
$ module load lammps        # load default version
```

Once loaded, the `lammps` module defines a set of environment variables for the locations of the LAMMPS home, binaries and more with the prefix `TACC_LAMMPS`. Use the `env` command to display the variables:

``` cmd-line
$ env | grep "TACC_LAMMPS"
```

Note that each installation's executable name differs. The name of the executable is in the format of "lmp_*machine*", where *"machine*" can be either "stampede", "lonestar", or "frontera" depending on the system. The LAMMPS GPU executables, `lmp_gpu`, can only be submitted to Frontera and Lonestar6's GPU queues.

Frontera     | Stampede3    | Lonestar6
--           | --           | --
`lmp_frontera` | `lmp_stampede` | `lmp_lonestar`
`lmp_gpu`      | *Coming soon*           | `lmp_gpu`

## Job Scripts { #scripts }

LAMMPS uses spatial-decomposition techniques to partition the simulation domain into small 3d sub-domains, one of which is assigned to each processor. You will need to set suitable values of `-N` (number of nodes), `-n` (total number of MPI tasks), and `OMP_NUM_THREADS` (number of threads to use in parallel regions) to optimize the performance of your simulation.

Below are sample job scripts for Lonestar6, Frontera and Stampede3.  Stampede3's GPU scripts are coming soon.

### Sample: Stampede3 { #scripts-stampede3 } 

Refer to Stampede3's [Running Jobs](../../hpc/stampede3/#running) section for more Slurm options. 

```job-script
#!/bin/bash
##SBATCH -J test                # Job Name
##SBATCH -A myProject           # Your project name 
##SBATCH -o test.o%j            # Output file name (%j expands to jobID)
##SBATCH -e test.e%j            # Error file name (%j expands to jobID)
##SBATCH -N 1                   # Requesting 1 node
##SBATCH -n 16                  # and 16 tasks
##SBATCH -p icx                 # Queue name (skx, icx, etc.)
##SBATCH -t 24:00:00            # Specify 24 hour run time

module load   intel/24.0
module load   impi/21.11
module load   lammps/21Nov23

export OMP_NUM_THREADS=1   

ibrun lmp_stampede -in lammps_input
```
### Sample: Frontera { #scripts-frontera }

Refer to Frontera's [Running Jobs](../../hpc/frontera/#running) section for more Slurm options. 

``` job-script
#!/bin/bash
##SBATCH -J test                   # Job Name
##SBATCH -A myProject              # Your project name 
##SBATCH -o test.o%j               # Output file name (%j expands to jobID)
##SBATCH -e test.e%j               # Error file name (%j expands to jobID)
##SBATCH -N 1                      # Requesting 1 node
##SBATCH -n 56                     # and 56 tasks
##SBATCH -p small                  # Queue name (development, small, normal, etc.)
##SBATCH -t 24:00:00               # Specify 24 hour run time

module load   intel/19.1.1
module load   impi/19.0.9
module load   lammps/21Nov23

export OMP_NUM_THREADS=1   

ibrun lmp_frontera -in lammps_input
```

### Sample: Lonestar6 { #scripts-lonestar6 }

Refer to Lonestar6's [Running Jobs](../../hpc/lonestar6/#running) section for more Slurm options. 

``` job-script
#!/bin/bash
##SBATCH -J test                   # Job Name
##SBATCH -A myProject              # Your project name 
##SBATCH -o test.o%j               # Output file name (%j expands to jobID)
##SBATCH -e test.e%j               # Error file name (%j expands to jobID)
##SBATCH -N 1                      # Requesting 1 node
##SBATCH -n 128                    # and 128 tasks
##SBATCH -p normal                 # Queue name (development, normal, etc.)
##SBATCH -t 24:00:00               # Specify 24 hour run time

module load   intel/19.1.1
module load   impi/19.0.9
module load   lammps/21Nov23

export OMP_NUM_THREADS=1   

ibrun lmp_lonestar -in lammps_input
```


### Example Job-Script Invocations { #scripts-invocations }

* LAMMPS with [USER-OMP package](https://docs.lammps.org/Speed_omp.html) (e.g. using 2 threads)

	``` job-script
	ibrun lmp_stampede -sf omp -pk omp 2 -in lammps_input
	```

* LAMMPS with GPU package.  

	The GPU LAMMPS executable is `lmp_gpu` on both Frontera and Lonestar6. Set the `-n` directive to a value > 1 to let more than one MPI task share one GPU.

	* Frontera GPU nodes: set `-pk gpu 4` to utilize all four RTX GPUs available on each node. 

	* Lonestar6 A100 or H100 GPU nodes: set `-pk gpu 3` to use all three available GPUs on each node. 

	``` job-script
	#SBATCH -N 1                   # Requesting 1 node
	#SBATCH -n 16                  # and 16 tasks that share 4 GPU
	#SBATCH -p rtx                 # Frontera rtx queue
	
	# Use all 4 GPUs
	ibrun lmp_gpu -sf gpu -pk gpu 4 -in lammps_input
	```

## Running Interactively  { #interactive }

You can also run LAMMPS interactively within an [`idev`][TACCIDEV] session as demonstrated below:

``` cmd-line
login1$ idev
...
c123-456$ module load lammps
c123-456$ lmp_stampede < lammps_input
```
Use the `-h` option to print out a list of all supported functions and packages:

``` cmd-line
c123-456$ lmp_stampede -h
```

## [References](#refs)

* [LAMMPS Documentation (Feb 2024)](https://docs.lammps.org/Manual.html)
* [Build LAMMPS](https://docs.lammps.org/Build.html)
* [`idev` at TACC][TACCIDEV]

{% include "aliases.md" %}
