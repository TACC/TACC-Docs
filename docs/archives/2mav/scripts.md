## [Job Scripts](#scripts)  { #scripts }

This section provides sample Slurm job scripts for commond programming models: serial applications, MPI, OpenMP and hybrid (MPI + OpenMP) programming models. 

Click on a tab for a job-script.  Copy and customize for your own applications.

/// tab | Serial Job in Normal Queue

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script for TACC Maverick2 nodes
#
#   *** Serial Job in Normal Queue ***
# 
# Last revised: 01 Oct 2018
#
# Notes:
#
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch maverick2.serial.slurm" on a Maverick2 login node.
#
#   -- Serial codes run on a single node (upper case N = 1).
#        A serial code ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- For a good way to run multiple serial executables at the
#        same time, execute "module load launcher" followed
#        by "module help launcher".

#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Launch serial code...

./mycode.exe         # Do not use ibrun or any other MPI launcher

# ---------------------------------------------------
```

///
/// tab | MPI Job in Normal Queue

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script for TACC Maverick2 nodes
#
#   *** MPI Job in Normal Queue ***
# 
# Last revised: 01 Oct 2018
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch maverick2.mpi.slurm" on Maverick2 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- Max recommended MPI tasks per KNL node: 64-68
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
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Launch MPI code... 

ibrun ./mycode.exe         # Use ibrun instead of mpirun or mpiexec

# ---------------------------------------------------
```

///
/// tab | OpenMP Job in Normal Queue

``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script for TACC Maverick2 nodes
#
#   *** OpenMP Job in Normal Queue ***
# 
# Last revised: 01 Oct 2018
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch maverick2.openmp.slurm" on a Maverick2 login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 68 (1 thread per core) or 136 (2 threads per core).

#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for OpenMP)
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for OpenMP)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Set thread count (default value is 1)...

export OMP_NUM_THREADS=34

# Launch OpenMP code...

./mycode.exe         # Do not use ibrun or any other MPI launcher

# ---------------------------------------------------
```

///
/// tab | Hybrid Job in Normal Queue

``` job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script for TACC Maverick2 nodes
#
#   *** Hybrid Job in Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         16 OpenMP threads per MPI task (64 threads per node)
#
# Last revised: 01 Oct 2018
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch maverick2.hybrid.slurm" on Maverick2 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- In most cases it's best to specify no more 
#      than 64-68 MPI ranks or independent processes 
#      per node, and 1-2 threads/core. 
#
#   -- If you're running out of memory, try running
#      fewer tasks and/or threads per node to give each 
#      process access to more memory.
#
#   -- IMPI and MVAPICH2 both do sensible process pinning by default.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 10              # Total # of nodes 
#SBATCH -n 40              # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Set thread count (default value is 1)...

export OMP_NUM_THREADS=16

# Launch MPI code... 

ibrun ./mycode.exe         # Use ibrun instead of mpirun or mpiexec

# ---------------------------------------------------
```

///

Your job will run in the environment it inherits at submission time; this environment includes the modules you have loaded and the current working directory. In most cases you should **run your applications(s) after loading the same modules that you used to build them**.  You can of course use your job submission script to modify this environment by defining new environment variables; changing the values of existing environment variables; loading or unloading modules; changing directory; or specifying relative or absolute paths to files. **Do not use the Slurm `--export` option to manage your job's environment**: doing so can interfere with the way the system propagates the inherited environment.

