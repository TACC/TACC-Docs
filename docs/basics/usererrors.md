# Common User Mistakes -- reword

In any of the following scenarios, TACC User Support will likely notify users of a warning from the admins and required changes to the workflow. In the event that any of the above scenarios have already caused significant harm to the system, the admins will revoke queue access for the health of the systems, and users can work with TACC User Support to regain queue access.

1. Causing high loads on /WORK

	* If a user causes high loads on /WORK, they will lose access to queues, and will be unable to run jobs until admin review and approval.

	* Additionally, the user’s overall account may also get suspended.

1. Running the entire workflow (code as well as data) out of /WORK

	* If all of the code, intermediate and non-intermediate data resides in /WORK and is run out of there, it will cause an overload on /WORK and result in consequences described in Point 1.

	* Ensure /SCRATCH is used for intermediate IO and actual job activity, while /HOME and /WORK are for storage and keeping track of important items (Refer: https://docs.tacc.utexas.edu/basics/conduct/#table-file-system-usage-recommendations)

	* Compute nodes should not reference /WORK unless it is to stage data in/out only before/after jobs.

1. Multiple accounts

	* If a user has multiple accounts, the user’s identity will be verified, and all accounts belonging to the user will be merged into one.
TACC staff will disable all the other accounts.

1. PyLauncher - Too many tasks

	* If a user is running too many large tasks or a large number of small tasks on PyLauncher and it overloads the system, the user’s queue access will be revoked until the workflow is redesigned to account for reasonable IO, number of tasks, and size. 
	* An upper limit for the number of tasks cannot be provided as it is entirely dependent on the specifications of the user’s workflow, but should a user have questions about their set-up, they may reach out to TACC User Support for assistance.

1. Automatic sourcing of a conda environment 

	* If a user’s workflow is designed to source a conda environment automatically, it is detrimental to the health of our systems.
	* The user could lose queue access until they change their workflow to only manually source and run a conda environment.

1. Hardcoding environment variables in the bashrc file

	* If a user hardcodes environment variables, it affects the entire shared filesystem, as all processes and sub-processes will inherit this, including batch jobs. This could potentially destabilize the cluster, and will result in the user losing queue access.
	* We strongly recommend users employ ‘module load’, job-specific exports, .env files, etc.

1. Poor file organization

	* Example: If thousands of files are in a single directory, etc.
	* This could adversely affect the filesystem and might result in a user’s account getting suspended or queue access getting revoked until files are managed and admins review it.



1. Running jobs on login nodes

	* Under no circumstances should a user run jobs on login nodes. Login nodes are strictly for submitting jobs, the actual jobs must be run on compute nodes only.
	* If a user runs jobs on login nodes, their queue access will be revoked until written assurance that they will not do so going forward. 

1. Running research applications on login nodes

	* Users should not run frameworks like MATLAB, R, and other computationally and IO intensive python scripts, and doing so will result in queue access getting revoked.
	* If a user needs interactive access, they may use the idev utility or Slurm's srun to schedule one or more compute nodes.

1. Launching too many simultaneous processes on login nodes

	* Users may compile on a login node, but commands like "make -j 16" (which compiles on 16 cores) may impact other users.
	* Doing so will result in the user’s queue access getting revoked.

1. Launching too many transfer sessions on login nodes

	* This is similar to the process overload in Point 10, and will result in the user’s queue access getting revoked.

1. Improper poll job status scripts

	* Poll job status scripts are permitted if they are run every few minutes, but should not be run several times a second.
	* Running them several times a second will result in the user’s queue access getting revoked.

1. Storing important, long term data and files in /SCRATCH

	* /SCRATCH is a temporary storage space and is subject to routine purging (https://docs.tacc.utexas.edu/basics/conduct/#scratchpolicy)
	* Users may lose data permanently and this cannot be recovered if users don’t save their important files in /WORK or /HOME.

1. Running jobs out of the /HOME directory

	* /HOME is for routine file management, not parallel jobs. 
	* Jobs run out of /HOME may likely overload the system and result in a revocation of the user’s queue access.

1. Exceeding filesystem quotas

	* If a user reaches their quota, it will stress the shared filesystem.
	* Users are encouraged to routinely review their files and delete all unnecessary files.
	* Overloading storage will result in a notification from the admins through User Support, and failure to stay within the limits will result in a revocation of queue access.

1. I/O intensive sessions

	* Lots of reads and writes to the disk or rapidly opening and closing files will stress the shared filesystem.
	* Overloading the system will result in a revocation of queue access.

1. Large, unmanaged file transfers 

	* Ensure receiving directories are striped, avoid too many simultaneous file transfers and recursive file transfers: https://docs.tacc.utexas.edu/basics/conduct/#conduct-transfers 
	* Overloading the system will result in a revocation of queue access.



