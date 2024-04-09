# Pylauncher at TACC
*Last update: April 09, 2024*

## [What is Pylauncher](#intro) { #intro }

Pylauncher (**Py**thon + **launcher**) is a python-based parametric job launcher, a utility for distributing and executing many small jobs in parallel, using fewer  resources than would be necessary to execute all jobs simultaneously. On many batch-based cluster computers this is a better strategy than submitting many small individual small jobs.

While TACC's deprecated [`launcher`](../launcher) utility works on serial codes, Pylauncher works with multi-threaded and MPI executables.  

Example: you need to run a program with 1000 different input values, and you want to use 100 cores for that; the pylauncher will then cycle through your list of commands using cores as they become available. 

The Pylauncher source code is written in python, but this need not concern you: in the simplest scenario you use a two line python script. However, for more sophisticated scenarios the code can be extended or integrated into a python application.

## [Installations](#installations)

Pylauncher is available on all TACC systems via the [Lmod][TACCLMOD] modules system.  Use the following in your batch script or `idev` session:

```cmd-line
$ module load pylauncher
```

!!! tip
	On Stampede3, the Python installation is missing a required module.<br>You need to one-time do:<br>
	`$ pip install paramiko`
 
## Basic setup

Pylauncher, like any compute-intensive application, must be run from a slurm batch script, or interactively within an `idev` session. Pylauncher interrogates the slurm environment variables to see what computational resources are available, so it is important that you set the `-tasks-per-node` `#SBATCH` directive appropriately:

```job-script
#SBATCH -tasks-per-node 56      # frontera
#SBATCH -tasks-per-node 48      # stampede3
#SBATCH -tasks-per-node 128     # lonestar6
```

The number of nodes needed ("`-N`" option) will depend on how much work you have.

Load the pylauncher module to set the `$TACC_PYLAUNCHER_DIR` and `$PYTHONPATH` environment variables. To find the pylauncher software, first do

```cmd-line
c123-456$ module load pylauncher
```

Which defines the `$TACC_PYLAUNCHER_DIR` variable and sets the `$PYTHONPATH` so that the software can be found.

Your batch script can then invoke python3 on the launcher code:

```syntax
mylauncher.py.
from pylauncher import pylauncher as launcher
launcher.ClassicLauncher("commandlines")
```

Pylauncher will now execute the lines in the file "`commandlines`":

```job-script
# this is a comment
./yourprogram value1
./yourprogram value2
```

The commands can be complicated as you wish, e.g.:

```job-script
mkdir output1 && cd output1 && ../yourprogram value1
```

If your inputs are regular, you can use the string `PYL_ID` which expands to the number of the command. 

The launcher will now run your commandlines, producing final statistics:

```syntax
Launcherjob run completed.

total running time: 222.22

# tasks completed: 160
tasks aborted: 0
max runningtime:  97.95
avg runningtime:  36.59
aggregate  	: 5854.60
speedup    	:  26.35

Host pool of size 40.

Number of tasks executed per node:
max: 11
avg: 4
```

This reports that 160 commands were executed, using 40 cores. Ideally we would expect a 40 times speedup, but because of variations in run time the aggregate running time of all commands was reduced by only 25.

If you want more detailed trace output during the run, add an option:

```syntax
launcher.ClassicLauncher("commandlines",debug="host+job")
```

### [Output files](#setup-outputfiles) { #setup-outputfiles }

Pylauncher will create a directory "`pylauncher_tmp123456`" where "`123456`" is the job number. The output of your commandlines needs to be explicitly stored. For instance, the commands in your `commandlines` file could say:

```syntax
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input1
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input2
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input3
...
```

A file "`queuestate`" is generated with a listing of the commands that were successfully executed, and, in case the job times out, which commands were pending or not scheduled. This information can be used to restart your job.

## [Parallel runs](#parallel) { #parallel }

### [Multi-Threaded](#parallel-multithreaded) { #parallel-multithreaded }

If your program is multi-threaded, you can specify more than one core with:

	launcher.ClassicLauncher("commandlines",cores=4)

1. This can also be used if your program takes more memory than would normally be assigned to a single core.  
2. Alternatively, you can leave out the cores clause, and decrease the SLURM `tasks-per-node` value.

### [MPI](#parallel-mpi) { #parallel-mpi }

If your program is MPI parallel, replace the ClassicLauncher call with the following:

```syntax
launcher.IbrunLauncher("parallellines",cores=3)
```

The "parallellines" file consists of command lines **without the MPI job starter**, which is supplied by the pylauncher:

```syntax
./parallelprogram 0 10
./parallelprogram 1 10
./parallelprogram 2 10
```

In the launcher invocation, the "`debug`" parameter causes trace output to be printed during the run. 

```syntax
tick 104
Queue:
completed  60 jobs: 0-44 47-48 50-53 56 58 60-61 64 66 68 70 75
aborted 	0 jobs:
queued  	5 jobs: 99-103
running	39 jobs: 45-46 49 54-55 57 59 62-63 65 67 69 71-74 76-98
```

This output states that in the 104'th stage some jobs were completed/queued for running/actually running. 

The  "tick" message is output every half second. This can be changed, for instance to 1/10th of a second, by specifying "delay=.1" in the launcher command.

## [Sample Job Setup](#sample)  { #sample }

Your job setup will consist of three files:

1. A Slurm job script
2. Pylauncher file
3. A command lines file

### Slurm Job Script File on Frontera

```job-script
#!/bin/bash
#SBATCH   -p development
#SBATCH   -J pylaunchertest
#SBATCH   -o pylaunchertest.o%j
#SBATCH   -e pylaunchertest.o%j
#SBATCH   -n 32
#SBATCH   -N 2
#SBATCH   -t 0:40:00
#SBATCH   -A YourProject

module load python3
python3 example_classic_launcher.py
```

### Pylauncher File

where "example_classic_launcher.py" contains:

```syntax
import pylauncher3 as launcher
launcher.ClassicLauncher("commandlines",debug="host+job")
```

### [Command Lines File](#setup-commandlines) { #setup-commandlines } 

where "`commandlines`" contains your parameter sweep:

```job-script
./myparallelprogram arg1 argA
./myparallelprogram arg1 argB
...
```

# [References](#refs)

* [Github: Pylauncher](https://github.com/TACC/pylauncher)
* [Launcher at TACC](https://docs.tacc.utexas.edu/software/launcher)
* [YouTube: Intro to PyLauncher](https://www.youtube.com/watch?v=-zIO8GY7ev8)
* [`idev` at TACC][TACCIDEV]


{% include 'aliases.md' %}
