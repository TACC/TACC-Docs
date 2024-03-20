## [Job Scripts](#scripts) { #scripts }

This section provides sample Slurm job scripts for each Stampede3 node type: 

* Ponte Vecchio (PVC),
* Sapphire Rapids (SPR),
* Ice Lake (ICX),
* Sky Lake (SKX).

Each section also contains sample scripts for serial, MPI, OpenMP and hybrid (MPI + OpenMP) programming models.  Copy and customize each script for your own applications.

### [PVC Nodes](#scripts-pvc) { #scripts-pvc }

*Coming Soon*

### [SPR Nodes](#scripts-spr) { #scripts-spr }

Click on a tab for a customizable job-script.

/// tab | MPI Job in Normal Queue
``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SPR nodes
#
#   *** MPI Job on SPR Normal Queue ***
# 
# Last revised: 14 Dec 2023
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch spr.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per SPR node: 112
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      on more nodes using fewer tasks and/or threads 
#      per node to give each task access to more memory.
#
#   -- Don't worry about task layout.  By default, ibrun
#      will provide proper affinity and pinning.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p spr-normal      # Queue (partition) name
#SBATCH -N 4               # Total # of nodes 
#SBATCH -n 448             # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...
module list
pwd
date

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec
```
///

/// tab | OpenMP Job in Normal Queue
``` job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SPR nodes
#
#   *** OpenMP Job on SPR Normal Queue ***
# 
# Last revised: 14 Dec 2023
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch spr.openmp.slurm" on a Stampede3 login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 80 (1 thread per core) but may be higher.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p spr-normal      # Queue (partition) name
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

export OMP_NUM_THREADS=112   # this is 1 thread/core; may want to start lower

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch OpenMP code...

./myprogram         # Do not use ibrun or any other MPI launcher
```
///

/// tab | Hybrid Job in Normal Queue
``` job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script
# for TACC Stampede3 SPR nodes
#
#   *** Hybrid Job on SPR Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         28 OpenMP threads per MPI task (112 threads per node)
#
# Last revised: 14 Dec 2023
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch spr.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- In most cases it's best to keep
#      ( MPI ranks per node ) x ( threads per rank )
#      to a number no more than 112 (total cores).
#
#   -- If you're running out of memory, try running
#      fewer tasks and/or threads per node to give each 
#      process access to more memory.
#
#   -- If you're running out of memory, try running
#      on more nodes using fewer tasks and/or threads 
#      per node to give each task access to more memory.
#
#   -- Don't worry about task layout.  By default, ibrun
#      will provide proper affinity and pinning.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p icx-normal      # Queue (partition) name
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

export OMP_NUM_THREADS=28

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///

### [ICX Nodes](#scripts-icx) { #scripts-icx }

Click on a tab for a customizable job-script.

/// tab | MPI Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 ICX nodes
#
#   *** MPI Job on ICX Normal Queue ***
# 
# Last revised: 09 Mar 2022
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch icx.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per ICX node: 80
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      on more nodes using fewer tasks and/or threads 
#      per node to give each task access to more memory.
#
#   -- Don't worry about task layout.  By default, ibrun
#      will provide proper affinity and pinning.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p icx-normal      # Queue (partition) name
#SBATCH -N 4               # Total # of nodes 
#SBATCH -n 320             # Total # of mpi tasks
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
/// 

/// tab | OpenMP Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
#
# Sample Slurm job script
#   for TACC Stampede3 ICX nodes
#
#   *** OpenMP Job on ICX Normal Queue ***
# 
# Last revised: 09 Mar 2022
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch icx.openmp.slurm" on a Stampede3 login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 80 (1 thread per core) but may be higher.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and exectuable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p icx-normal      # Queue (partition) name
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

export OMP_NUM_THREADS=80   # this is 1 thread/core; may want to start lower

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch OpenMP code...

./myprogram         # Do not use ibrun or any other MPI launcher

```
/// 

/// tab | Hybrid Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script
# for TACC Stampede3 ICX nodes
#
#   *** Hybrid Job on ICX Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         20 OpenMP threads per MPI task (80 threads per node)
#
# Last revised: 09 Mar 2022
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch icx.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- In most cases it's best to keep
#      ( MPI ranks per node ) x ( threads per rank )
#      to a number no more than 80 (total cores).
#
#   -- If you're running out of memory, try running
#      fewer tasks and/or threads per node to give each 
#      process access to more memory.
#
#   -- If you're running out of memory, try running
#      on more nodes using fewer tasks and/or threads 
#      per node to give each task access to more memory.
#
#   -- Don't worry about task layout.  By default, ibrun
#      will provide proper affinity and pinning.
#
#   -- You should always run out of $SCRATCH.  Your input
#      files, output files, and executable should be 
#      in the $SCRATCH directory hierarchy.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p icx-normal      # Queue (partition) name
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

export OMP_NUM_THREADS=20

# Always run your jobs out of $SCRATCH.  Your input files, output files, 
# and exectuable should be in the $SCRATCH directory hierarchy.  
# Change directories to your $SCRATCH directory where your executable is

cd $SCRATCH

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///

### [SKX Nodes](#scripts-skx) { #scripts-skx }

Click on a tab for a customizable job-script.

/// tab | Serial Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SKX nodes
#
#   *** Serial Job on SKX Normal Queue ***
# 
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch skx.serial.slurm" on a Stampede3 login node.
#
#   -- Serial codes run on a single node (upper case N = 1).
#        A serial code ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- For a good way to run multiple serial executables at the
#        same time, execute "module load launcher" followed
#        by "module help launcher".
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p skx-normal      # Queue (partition) name
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

./myprogram         # Do not use ibrun or any other MPI launcher

# ---------------------------------------------------
```
///
/// tab | MPI Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SKX nodes
#
#   *** MPI Job on SKX Normal Queue ***
# 
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch skx.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- Max recommended MPI ranks per SKX node: 48
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      fewer tasks per node to give each task more memory.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p skx-normal      # Queue (partition) name
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

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///
/// tab | OpenMP Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede3 SKX nodes
#
#   *** OpenMP Job on SKX Normal Queue ***
# 
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Launch this script by executing
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch skx.openmp.slurm" on a Stampede3 login node.
#
#   -- OpenMP codes run on a single node (upper case N = 1).
#        OpenMP ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- Default value of OMP_NUM_THREADS is 1; be sure to change it!
#
#   -- Increase thread count gradually while looking for optimal setting.
#        If there is sufficient memory available, the optimal setting
#        is often 48 (1 thread per core) but may be higher.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p skx-normal      # Queue (partition) name
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

export OMP_NUM_THREADS=48   # this is 1 thread/core; may want to start lower

# Launch OpenMP code...

./myprogram         # Do not use ibrun or any other MPI launcher

```
///

/// tab | Hybrid Job in Normal Queue
```job-script
#!/bin/bash
#----------------------------------------------------
# Example Slurm job script
# for TACC Stampede3 SKX nodes
#
#   *** Hybrid Job on SKX Normal Queue ***
# 
#       This sample script specifies:
#         10 nodes (capital N)
#         40 total MPI tasks (lower case n); this is 4 tasks/node
#         12 OpenMP threads per MPI task (48 threads per node)
#
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch skx.mpi.slurm" on Stampede3 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- In most cases it's best to keep
#      ( MPI ranks per node ) x ( threads per rank )
#      to a number no more than 48 (total cores).
#
#      process access to more memory.
#
#   -- IMPI and MVAPICH2 both do sensible process pinning by default.
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p skx-normal      # Queue (partition) name
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

export OMP_NUM_THREADS=12

# Launch MPI code... 

ibrun ./myprogram         # Use ibrun instead of mpirun or mpiexec

```
///

