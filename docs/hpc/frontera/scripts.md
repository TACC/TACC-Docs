## [Sample Job Scripts](#scripts) { #scripts }

Copy and customize the following jobs scripts by specifying and refining your job's requirements.

* specify the maximum run time with the `-t` option. 
* specify number of nodes needed with the `-N` option
* specify total number of MPI tasks with the `-n` option
* specify the project to be charged with the `-A` option.

Consult [Table 7](#table7) for a more detailed listing of common Slurm `#SBATCH` options.

Click on a tab header below to display it's job script, then copy and customize to suit your own application.

/// tab | Serial Jobs 
Serial Jobs

Serial codes should request 1 node (`#SBATCH -N 1`) with 1 task (`#SBATCH -n 1`). 

!!! important
	Run all serial jobs in the `small` queue.  

Consult the [Launcher at TACC](../../software/launcher) documentation to run multiple serial executables at one time.

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Frontera CLX nodes
#
#   *** Serial Job in Small Queue***
# 
# Last revised: 22 June 2021
#
# Notes:
#
#  -- Copy/edit this script as desired.  Launch by executing
#     "sbatch clx.serial.slurm" on a Frontera login node.
#
#  -- Serial codes run on a single node (upper case N = 1).
#       A serial code ignores the value of lower case n,
#       but slurm needs a plausible value to schedule the job.
#
#  -- Use TACC's launcher utility to run multiple serial 
#       executables at the same time, execute "module load launcher" 
#       followed by "module help launcher".
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p small           # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=username@tacc.utexas.edu

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Launch serial code...
./myprogram         # Do not use ibrun or any other MPI launcher
```
///
/// tab | MPI Jobs
MPI Jobs

This script requests 4 nodes (`#SBATCH -N 4`) and 32 tasks (`#SBATCH -n 32`), for 8 MPI rasks per node.  

If your job requires only one or two nodes, submit the job to the `small` queue instead of the `normal` queue.

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Frontera CLX nodes
#
#   *** MPI Job in Normal Queue ***
# 
# Last revised: 20 May 2019
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch clx.mpi.slurm" on a Frontera login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do NOT use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per CLX node: 56
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      fewer tasks per node to give each task more memory.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 4               # Total # of nodes 
#SBATCH -n 32              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=username@tacc.utexas.edu

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Launch MPI code... 
ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///
/// tab | OpenMP Jobs
OpenMP Jobs

* **Hyperthreading is not currently enabled on Frontera**
* **Run all OpenMP jobs in the `small` queue.**  

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Frontera CLX nodes
#
#   *** OpenMP Job in Small Queue ***
# 
# Last revised: July 6, 2021
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch clx.openmp.slurm" on a Frontera login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 56 (1 thread per core) but may be higher.

#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p small           # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for OpenMP)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for OpenMP)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH -A myproject       # Project/Allocation name (req'd if you have more than 1)

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Set thread count (default value is 1)...
export OMP_NUM_THREADS=56   # this is 1 thread/core; may want to start lower

# Launch OpenMP code...
./myprogram         # Do not use ibrun or any other MPI launcher

```
///
/// tab | Hybrid (MPI + OpenMP) Job
Hybrid (MPI + OpenMP) Jobs

This script requests 10 nodes (`#SBATCH -N 10`) and 40 tasks (`#SBATCH -n 40`).  

If your job requires only one or two nodes, submit the job to the `small` queue instead of the `normal` queue.

``` job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script
# for TACC Frontera CLX nodes
#
#   *** Hybrid Job in Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         14 OpenMP threads per MPI task (56 threads per node)
#
# Last revised: 20 May 2019
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch clx.hybrid.slurm" on Frontera login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do NOT use mpirun or mpiexec.
#
#   -- In most cases it's best to keep
#      ( MPI ranks per node ) x ( threads per rank )
#      to a number no more than 56 (total cores).
#
#   -- If you're running out of memory, try running
#      fewer tasks and/or threads per node to give each 
#      process access to more memory.
#
#   -- IMPI does sensible process pinning by default.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 10              # Total # of nodes 
#SBATCH -n 40              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=username@tacc.utexas.edu

# Any other commands must follow all #SBATCH directives...
module list
pwd
date

# Set thread count (default value is 1)...
export OMP_NUM_THREADS=14

# Launch MPI code... 
ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///
/// tab | Parametric Sweep / HTC Jobs
Parametric / HTC Jobs

Consult the [Launcher at TACC](../../software/launcher) documentation for instructions on running parameter sweep and other High Throughput Computing workflows.
///

