/ Albert Lu, Susan Lindsey	  
/ http://portal.tacc.utexas.edu/software/gromacs  
<span style="font-size:225%; font-weight:bold;">GROMACS at TACC</span><br>
<span style="font-size:90%"><i>Last update: December 7, 2022</i></span>


%table(cellspacing="5" cellpadding="5")
	%tr
		%td <img alt="GROMACS logo" src="/documents/10157/1667013/GROMACS+logo/ef476aac-36aa-4d87-9a67-6e37781096d8?t=1540578380106" style="width: 150px; height: 100px;" />


		%td <b>GRO</b>ningen <b>MA</b>chine for <b>C</b>hemical <b>S</b>imulations (GROMACS) is a free, open-source, molecular dynamics package. GROMACS can simulate the Newtonian equations of motion for systems with hundreds to millions of particles. GROMACS is primarily designed for biochemical molecules like proteins, lipids and nucleic acids that have a lot of complicated bonded interactions, but since GROMACS is extremely fast at calculating the nonbonded interactions (that usually dominate simulations), many groups are also using it for research on non-biological systems, e.g. polymers.

#tacc
	:markdown
		# [TACC and GROMACS](#tacc)

		GROMACS is currently installed on TACC's [Stampede2](/user-guides/stampede2), [Frontera](https://frontera-portal.tacc.utexas.edu/user-guide), and [Lonestar6](/user-guides/lonestar6) systems. GROMACS is managed under the [Modules](https://portal.tacc.utexas.edu/software/modules) system on TACC resources. To run simulations, simply load the module with the following command:

		<pre class="cmd-line">login1$ <b>module load gromacs</b></pre>

		As of this date, the GROMACS versions are 2022.1 on Stampede2, 2019.6 on Frontera, and 2021.3 on Lonestar6. Users are welcome to install different versions of GROMACS in their own directories. See [Building Third Party Software](/user-guides/stampede2#building-basics-thirdparty) in the Stampede2 User Guide. The module file defines the environment variables listed below. Learn more from the module's help file:

		<pre class="cmd-line">login1$ <b>module help gromacs</b></pre>

#table1
	:markdown
		## [Table 1. GROMACS Environment Variables](#table1)

	%table(border=1 cellpadding=3 cellspacing=1)
		%tr
			%th Variable
			%th Value
		%tr
			%td <code>TACC_GROMACS_DIR</code>
			%td GROMACS installation root directory
		%tr
			%td <code>TACC_GROMACS_BIN</code>
			%td binaries
		%tr
			%td <code>TACC_GROMACS_DOC</code>
			%td documentation
		%tr
			%td <code>TACC_GROMACS_LIB</code>
			%td libraries
		%tr
			%td <code>TACC_GROMACS_INC</code>
			%td include files
		%tr
			%td <code>GMXLIB</code>
			%td topology file directory
#running
	:markdown
		# [Running GROMACS at TACC](#running)


		To launch simulation jobs, please use the TACC-specific MPI launcher "`ibrun`", which is a TACC-system-aware replacement for generic MPI launchers like `mpirun` and `mpiexec`. The executable, "`gmx_mpi`", is the parallel component of GROMACS. It can be invoked in a job script like this:

		<pre class="job-script">ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log</pre>

		In the above command, "`gmx_mpi`" (single-precision) can be replaced by "`gmx_mpi_d`" (double-precision) or "`gmx_tmpi`" (single-precision, single-node thread-MPI). Please refer to the GROMACS manual for more information.

		On Stampede2, the executables with a "`_knl`" postfix should be run on the KNL nodes only in the appropriate queues.

		On Frontera and Lonestar6, you may use "`gmx_mpi_gpu`" instead of "`gmx_mpi`" to run GROMACS on GPUs nodes. Note that not all GROMACS modules on the TACC systems support GPU acceleration. Consult "`module help`" to find details about supported functionality.

		You can also compile and link your own source code with the GROMACS libraries:

		<pre class="cmd-line">login1$ <b>icc -I$TACC_GROMACS_INC test.c -L$TACC_GROMACS_LIB –lgromacs</b></pre>


#running-batch
	:markdown
		## [Running GROMACS in Batch Mode](#running-batch)

		Use Slurm's "`sbatch`" command to submit a batch job to one of the Stampede2 queues:

		<pre class="cmd-line"> login1$ <b>sbatch myjobscript</b></pre>

		Here "`myjobscript`" is the name of a text file containing `#SBATCH` directives and shell commands that describe the particulars of the job you are submitting. 

#jobscript-frontera
	:markdown
		## [Frontera Job Scripts](#jobscript-frontera)

		Here are two job scripts for running the latest version of GROMACS on Frontera.  The first script runs on Frontera's CPUs and the second runs on Frontera's GPUs.

#jobscript-frontera-cpu
	:markdown
		### [CPU](#jobscript-frontera-cpu)

		The following job script requests 4 nodes (56 cores/node) for 24 hours using Frontera CLX compute nodes (`normal` queue).

		<pre class="jobs-script">
		#!/bin/bash
		#SBATCH -J myjob              # job name
		#SBATCH -e myjob.%j.err       # error file name 
		#SBATCH -o myjob.%j.out       # output file name 
		#SBATCH -N 4                  # request 4 nodes
		#SBATCH -n 224                # request 4x56=224 MPI tasks 
		#SBATCH -p normal             # designate queue 
		#SBATCH -t 24:00:00           # designate max run time 
		#SBATCH -A myproject          # charge job to myproject 
		module load gromacs/2022.1
		export OMP_NUM_THREADS=1      # 1 OMP thread per MPI task

		ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log</pre>
		 
#jobscript-frontera-gpu
	:markdown
		### [GPU](#jobscript-frontera-gpu)

		The following job script requests 4 RTX GPU nodes on Frontera. The "`-gpu_id 0000`" directive indicates all four MPI ranks on the same node share the same GPU with id 0. You may use, for example "`-gpu_id 0123`", to use all four available GPUs on each RTX node.

		<pre class="jobs-script">
		#!/bin/bash
		#SBATCH -J myjob      	      # job name
		#SBATCH -e myjob.%j.err       # error file name
		#SBATCH -o myjob.%j.out   	  # output file name
		#SBATCH -N 4              	  # request 4 nodes
		#SBATCH -n 16              	  # request 4x4=16 MPI tasks
		#SBATCH -p rtx  	          # designate queue
		#SBATCH -t 24:00:00       	  # designate max run time
		#SBATCH -A myproject      	  # charge job to myproject
		module load gromacs/2022.1
		export OMP_NUM_THREADS=4      # 4 OMP threads per MPI task

		# Case 1: all 4 MPI tasks on the same node share a GPU with id '0'
		ibrun gmx_mpi_gpu mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log -gpu_id 0000

		# Case 2: the 4 MPI tasks on the same node run on GPU 0, 1, 2, and 3 respectively
		ibrun gmx_mpi_gpu mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log -gpu_id 0123</pre>

#jobscript-stampede2
	:markdown
		## [Stampede2 Job Script](#jobscript-stampede2)

		The following job script requests 2 nodes (48 cores/node) for 24 hours using Stampede2's Skylake compute nodes (skx-normal queue).

		<pre class="jobs-script">
		#!/bin/bash
		#SBATCH -J myjob              # job name
		#SBATCH -e myjob.%j.err       # error file name 
		#SBATCH -o myjob.%j.out       # output file name 
		#SBATCH -N 2                  # request 2 nodes
		#SBATCH -n 96                 # request 2x48=96 MPI tasks 
		#SBATCH -p skx-normal         # designate queue 
		#SBATCH -t 24:00:00           # designate max run time 
		#SBATCH -A myproject          # charge job to myproject 
		module load gromacs/2022.1

		ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log</pre>
		 
		NOTE: To run on Stampede2's KNL nodes, substitute "`gmx_mpi`" with one of the following executables: "`gmx_mpi_knl`", "`gmx_tmpi_knl`", or "`gmx_mpi_d_knl`".


#jobscript-lonestar6
	:markdown
		## [Lonestar6 Job Scripts](#running-lonestar6)

		Here are two job scripts for running the latest version of GROMACS on Lonestar6.  The first script runs on Lonestar6's CPUs and the second runs on Lonestar6's GPUs.

#jobscript-lonestar6-cpu
	:markdown
		### [CPU](#running-lonestar6-cpu)

		The following job script requests 4 nodes (128 cores/node) for 24 hours using Lonestar6 AMD EPYC CPU nodes (`normal` queue).

		<pre class="job-script">
		#!/bin/bash
		#SBATCH -J myjob              # job name
		#SBATCH -e myjob.%j.err       # error file name 
		#SBATCH -o myjob.%j.out       # output file name 
		#SBATCH -N 4                  # request 4 nodes
		#SBATCH -n 512                # request 4x128=512 MPI tasks 
		#SBATCH -p normal             # designate queue 
		#SBATCH -t 24:00:00           # designate max run time 
		#SBATCH -A myproject          # charge job to myproject 

		module load gromacs/2022.1
		export OMP_NUM_THREADS=1      # 1 OMP thread per MPI task
		ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log</pre>
		 
#jobscript-lonestar6-gpu
	:markdown
		### [GPU](#running-lonestar6-gpu)

		The following job script requests two [A100 GPU nodes on Lonestar6](/user-guides/lonestar6#gpu-nodes). The "`-gpu_id 000`" directive indicates all three MPI ranks on the same node share the same GPU with id 0.  You may use, for example "`-gpu_id 012`", to use all three available GPUs on each A100 GPU node.

		<pre class="job-script">
		#!/bin/bash
		#SBATCH -J myjob      	     # job name
		#SBATCH -e myjob.%j.err      # error file name
		#SBATCH -o myjob.%j.out      # output file name
		#SBATCH -N 2              	 # request 2 nodes
		#SBATCH -n 6              	 # request 2x3=6 MPI tasks
		#SBATCH -p gpu-a100  	     # designate queue
		#SBATCH -t 24:00:00       	 # designate max run time
		#SBATCH -A myproject      	 # charge job to myproject

		module load gromacs/2022.1
		export OMP_NUM_THREADS=4     # 4 OMP threads per MPI task 

		# Case 1: all 3 MPI tasks on the same node share a GPU with id '0'
		ibrun gmx_mpi_gpu mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log -gpu_id 000

		# Case 2: the 3 MPI tasks on the same node run on GPU 0, 1, and 2 respectively
		ibrun gmx_mpi_gpu mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log -gpu_id 012</pre>
		
#refs
	:markdown
		# [References](#refs)

		* [GROMACS Home](http://www.gromacs.org/)
		* [GROMACS Documentation](http://www.gromacs.org/Documentation)
		* [GROMACS acceleration and parallelization](http://www.gromacs.org/Documentation/Acceleration_and_parallelization)
		

