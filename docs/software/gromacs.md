# GROMACS at TACC
*Last update: April 14, 2025*

<img style="float:left; padding-bottom:10px; padding-right:20px; width:200px;" alt="GROMACS logo" src="../imgs/gromacs-logo.png">**GRO**ningen **MA**chine for **C**hemical **S**imulations (GROMACS) is a free, open-source, molecular dynamics package. GROMACS can simulate the Newtonian equations of motion for systems with hundreds to millions of particles. GROMACS is primarily designed for biochemical molecules like proteins, lipids and nucleic acids that have a lot of complicated bonded interactions, but since GROMACS is extremely fast at calculating the nonbonded interactions (that usually dominate simulations), many groups are also using it for research on non-biological systems, e.g., polymers.   


## Installations { #installations }

GROMACS is currently installed on TACC's [Stampede3][TACCSTAMPEDE3UG], [Frontera][TACCFRONTERAUG], [Lonestar6][TACCLONESTAR6UG] and [Vista][TACCVISTAUG] systems.  GROMACS is managed under the [Lmod](https://lmod.readthedocs.io/en/latest/) modules system on TACC resources.  To run simulations, simply load the module with the following command:

```cmd-line
login1$ module load gromacs    # load default version
```

As of this date, the latest versions of GROMACS are 2024 (Stampede3, Lonestar6, Frontera, and Vista). Execute the `module spider` command to show all the installed GROMACS versions on the system:

```cmd-line
login1$ module spider gromacs  # list installed GROMACS versions
```
The module file defines the environment variables listed below. 

**Table 1. GROMACS Environment Variables**

Variable | Value
--       | --
`TACC_GROMACS_DIR` | GROMACS installation root directory
`TACC_GROMACS_BIN` | binaries
`TACC_GROMACS_DOC` | documentation
`TACC_GROMACS_LIB` | libraries
`TACC_GROMACS_INC` | include files
`GMXLIB` | topology file directory

Learn more from the module's help file:

```cmd-line
login1$ module help gromacs
```

You are welcome to install different versions of GROMACS in your own directories. See [Building Third Party Software](../../hpc/stampede3/#building) in the Stampede3 User Guide. 

## Batch Jobs { #batch }

To launch simulation jobs, please use the TACC-specific MPI launcher `ibrun`, a TACC-system-aware replacement for generic MPI launchers like `mpirun` and `mpiexec`. The executable, `gmx_mpi`, is the parallel component of GROMACS. It can be invoked in a job script like this:

```job-script
ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
```

In the above command, `gmx_mpi` (single-precision) can be replaced by `gmx_mpi_d` (double-precision) or `gmx_tmpi` (single-precision, single-node thread-MPI). Refer to the GROMACS manual for more information.

On Frontera and Lonestar6, you may use `gmx_mpi_gpu` instead of `gmx_mpi` to run GROMACS on GPUs nodes. 

!!! tip
	Not all GROMACS modules on the TACC systems support GPU acceleration.   See `module help` and `module spider` to find details about supported functionality.

## Job Scripts { #scripts }

Use Slurm's `sbatch` command to submit a batch job to one of the queues.  Here "myjobscript" is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting.

```cmd-line
login1$ sbatch myjobscript
```

### Stampede3  { #scripts-stampede3 }

#### CPU { #scripts-stampede3-cpu }

The following job script requests 2 nodes (48 cores/node) for 24 hours using Stampede3's Skylake compute nodes ([`skx` queue](../../hpc/stampede3/#queues)).

```job-script
#!/bin/bash
#SBATCH -J myjob              # job name
#SBATCH -e myjob.%j.err       # error file name 
#SBATCH -o myjob.%j.out       # output file name 
#SBATCH -N 2                  # request 2 nodes
#SBATCH -n 96                 # request 2x48=96 MPI tasks 
#SBATCH -p skx                # designate queue 
#SBATCH -t 24:00:00           # designate max run time 
#SBATCH -A myproject          # charge job to myproject 
module load intel/24.0
module load impi/21.11
module load gromacs/2024

ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
```
#### GPU  { #scripts-stampede3-gpu }

*Coming Soon*

### Frontera  { #scripts-frontera }

#### CPU { #scripts-frontera-cpu }

The following job script requests 4 nodes (56 cores/node) for 24 hours using Frontera CLX compute nodes ([`normal queue`](../../hpc/frontera/#queues)).

```job-script
#!/bin/bash
#SBATCH -J myjob              # job name
#SBATCH -e myjob.%j.err       # error file name 
#SBATCH -o myjob.%j.out       # output file name 
#SBATCH -N 4                  # request 4 nodes
#SBATCH -n 224                # request 4x56=224 MPI tasks 
#SBATCH -p normal             # designate queue 
#SBATCH -t 24:00:00           # designate max run time 
#SBATCH -A myproject          # charge job to myproject 
module load gcc/9.1.0
module load impi/19.0.9
module load gromacs/2024
export OMP_NUM_THREADS=1      # 1 OMP thread per MPI task

ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
```

#### GPU { #scripts-frontera-gpu }

The following job script requests 4 RTX GPU nodes on Frontera. The directive `-gpu_id 0000` indicates all four MPI ranks on the same node share the same GPU with `id 0`.  For example, `-gpu_id 0123` uses all four available GPUs on each RTX node.

```job-script
#!/bin/bash
#SBATCH -J myjob      	      # job name
#SBATCH -e myjob.%j.err       # error file name
#SBATCH -o myjob.%j.out       # output file name
#SBATCH -N 4                  # request 4 nodes
#SBATCH -n 16                 # request 4x4=16 MPI tasks
#SBATCH -p rtx  	      # designate queue
#SBATCH -t 24:00:00           # designate max run time
#SBATCH -A myproject          # charge job to myproject
module load gcc/9.1
module load impi/19.0.9
module load cuda/11.3
module load gromacs/2024
export OMP_NUM_THREADS=4      # 4 OMP threads per MPI task

# Case 1: all 4 MPI tasks on the same node share a GPU with id '0'
ibrun gmx_mpi_gpu mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log -gpu_id 0000

# Case 2: the 4 MPI tasks on the same node run on GPU 0, 1, 2, and 3 respectively
ibrun gmx_mpi_gpu mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log -gpu_id 0123
```

### Lonestar6  { #scripts-lonestar6 }

#### CPU { #scripts-lonestar6-cpu }

The following job script requests 4 nodes (128 cores/node) for 24 hours using Lonestar6 AMD EPYC CPU nodes ([`normal queue`](../../hpc/lonestar6/#queues)).

```job-script
#!/bin/bash
#SBATCH -J myjob              # job name
#SBATCH -e myjob.%j.err       # error file name 
#SBATCH -o myjob.%j.out       # output file name 
#SBATCH -N 4                  # request 4 nodes
#SBATCH -n 512                # request 4x128=512 MPI tasks 
#SBATCH -p normal             # designate queue 
#SBATCH -t 24:00:00           # designate max run time 
#SBATCH -A myproject          # charge job to myproject 
module load gcc/11.2.0
module load impi/19.0.9
module load gromacs/2024
export OMP_NUM_THREADS=1      # 1 OMP thread per MPI task

ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
```

#### GPU { #scripts-lonestar6-gpu }

The following job script requests two A100 GPU nodes on Lonestar6. The directive `-gpu_id 000` indicates all three MPI ranks on the same node share the same GPU with `id 0`. You may use, for example, `-gpu_id 012`, to use all three available GPUs on each A100 GPU node.

```job-script
#!/bin/bash
#SBATCH -J myjob      	      # job name
#SBATCH -e myjob.%j.err       # error file name
#SBATCH -o myjob.%j.out       # output file name
#SBATCH -N 2                  # request 2 nodes
#SBATCH -n 6                  # request 2x3=6 MPI tasks
#SBATCH -p gpu-a100  	      # designate queue
#SBATCH -t 24:00:00           # designate max run time
#SBATCH -A myproject          # charge job to myproject

module load gcc/11.2.0
module load impi/19.0.9
module load cuda/11.4
module load gromacs/2024


export OMP_NUM_THREADS=4      # 4 OMP threads per MPI task 

# Case 1: all 3 MPI tasks on the same node share a GPU with id '0'
ibrun gmx_mpi_gpu mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log -gpu_id 000

# Case 2: the 3 MPI tasks on the same node run on GPU 0, 1, and 2 respectively
ibrun gmx_mpi_gpu mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log -gpu_id 012
```

### Vista  { #scripts-vista }

#### CPU { #scripts-vista-cpu }

The following job script requests 4 nodes (144 cores/node) for 24 hours using Vista Grace/Grace CPU nodes ([`gg queue`](../../hpc/vista/#queues)).

```job-script
#!/bin/bash
#SBATCH -J myjob              # job name
#SBATCH -e myjob.%j.err       # error file name 
#SBATCH -o myjob.%j.out       # output file name 
#SBATCH -N 4                  # request 4 nodes
#SBATCH -n 576                # request 4x144=576 MPI tasks 
#SBATCH -p gg                 # designate queue 
#SBATCH -t 24:00:00           # designate max run time 
#SBATCH -A myproject          # charge job to myproject 
module load nvidia/24.7
module load openmpi/5.0.5
module load gromacs/2024
export OMP_NUM_THREADS=1      # 1 OMP thread per MPI task

ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
```

#### GPU { #scripts-vista-gpu }

The following job script requests four Grace/Hopper GPU nodes on Vista. To improve multi-node performance, direct GPU communication and PME decomposition on GPUs are enabled in this example.

```job-script
#!/bin/bash
#SBATCH -J myjob      	      # job name
#SBATCH -e myjob.%j.err       # error file name
#SBATCH -o myjob.%j.out       # output file name
#SBATCH -N 4                  # request 4 nodes
#SBATCH -n 8                  # request 4x2=8 MPI tasks
#SBATCH -p gh  	      	      # designate queue
#SBATCH -t 24:00:00           # designate max run time
#SBATCH -A myproject          # charge job to myproject

module load gcc/11.2.0
module load nvidia/24.7
module load cuda/12.5
module load openmpi/5.0.5
module load cu-gromacs/2024


export OMP_NUM_THREADS=16              # 16 OMP threads per MPI task
export GMX_ENABLE_DIRECT_GPU_COMM=1    # Enable direct GPU communication in a multi-rank parallel run
export GMX_GPU_PME_DECOMPOSITION=1     # Enable the support for PME decomposition on GPU
export PMETASKS=4                      # Set the number of PME tasks to 4 (1 task per node)

ibrun gmx_mpi_gpu mdrun \
      -noconfout -pin on \
      -bonded gpu -nb gpu \
      -pme gpu -ntomp $OMP_NUM_THREADS \
      -s benchPEP.tpr  \
      -npme $PMETASKS \
      -nsteps 1000  \
      -g md.log -nstlist 300
```

## References { #refs }

* [GROMACS Home](https://www.gromacs.org/)
* [GROMACS Documentation](https://manual.gromacs.org/)
* [GROMACS acceleration and parallelization](https://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html)

{% include 'aliases.md' %}

