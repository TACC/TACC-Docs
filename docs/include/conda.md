## Installing and Running Conda 

Quick review: each TACC HPC resource has access to three file systems, $HOME, $WORK, and $SCRATCH.  The $HOME and $SCRATCH file systems are *local* to each resource, and the $WORK file system is accessible and available across *all* resources.  

TACC's `$WORK` file system is a globally accessible repo across all TACC HPC resources, but is not optimized to handle Python/Conda installations on the order of TACC's increasing user-base.  Conda and Python environments especially cause extremely high loads on this file system leading to disruptions for all users and account suspensions.  

Therefore TACC staff advises you to install your python virtual environments and Conda installation in either the $SCRATCH or $HOME directories, with regular  backups to the `$WORK` directory.

TACC staff recommends the following Conda workflow.

1. Install Conda in either $HOME or $SCRATCH file system

	```cmd-line
	vista.login1$ cd $SCRATCH
	vista.login1$ conda init
	```

	| File System | $HOME | $SCRATCH |
	-- | -- | -- | 
	| Pros | not purged | unlimited disk space |
	| Cons | very limited disk space - | subject to purge

	&#42; if you're close to your quota limit, can interfere with job submissions | occasionally purged |

2. Backup this installation to $WORK via the `rsync` utility.

	```cmd-line
	vista.login$ cd $SCRATCH
	vista.login$ rsync mycondainstallation $WORK/
	```

3. All job scripts and/or interactive sessions via `idev` or the TACC Analysis Portal (TAP) **must** point to your Conda installation in `$HOME` or `$WORK`.  
4. Bash edits

	QUESTION: initializing conda in the .bash script - problem right?

	what are common env var initializations?

		LD_LIBRARY_PATH, PYTHON_PATH
		export LD_LIBRARY_PATH=$SCRATCH/miniconda3/envs/py311/lib:$LD_LIBRARY_PATH
		export PYTHONPATH=$WORK:$SCRATCH/miniconda3/envs/py311:$PYTHONPATH



