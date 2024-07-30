# PyLauncher at TACC
*Last update: July 30, 2024* 

*This document is in progress*

## What is PyLauncher { #intro }

PyLauncher (**Py**thon + **Launcher**) is a Python-based parametric job launcher, a utility for distributing and executing many small jobs in parallel, using fewer resources than would be necessary to execute all jobs simultaneously. On many batch-based cluster computers this is a better strategy than submitting many small individual small jobs.

While TACC's deprecated Launcher utility worked on serial codes, PyLauncher works with multi-threaded and MPI executables.  

**Example**: You need to run a program with 1000 different input values, and you want to use 100 cores for that; PyLauncher will then cycle through your list of commands using cores as they become available. 

The PyLauncher source code is written in Python, but this need not concern you: in the simplest scenario you use a two line Python script. However, for more sophisticated scenarios the code can be extended or integrated into a Python application.

## Installations

PyLauncher is available on all TACC systems via the [Lmod modules system][TACCLMOD].  

Use the following in your Slurm batch script or `idev` session.

```cmd-line
$ module load pylauncher
```

!!! important
    Some Python installations do not include the required `paramiko` module.  You may need to perform a one-time setup:
    `$ pip install paramiko`


## Basic Setup { #setup }

PyLauncher, like any compute-intensive application, must be invoked from a Slurm job script, or interactively within an [`idev` session][TACCIDEV]. PyLauncher interrogates Slurm's environment variables to query the available computational resources, so it is important that you set the `--ntasks-per-node` `#SBATCH` directive appropriately.  See each resource's user guide's System Architecture section for more information.

```job-script
#SBATCH --ntasks-per-node 56  # for frontera
#SBATCH --ntasks-per-node 48  # for stampede3 skx queue
#SBATCH --ntasks-per-node 128 # for lonestar6
```

<!-- The number of nodes to request depends on how much work you have. -->

Load the PyLauncher module to set the `TACC_PYLAUNCHER_DIR` and `PYTHONPATH` environment variables.

```cmd-line
c123-456$ module load pylauncher
```

Your batch script can then invoke `python3` on the launcher code:

```job-script
mylauncher.py.
import pylauncher 
pylauncher.ClassicLauncher("commandlines")
```

PyLauncher will now execute the lines in the file "commandlines":

```syntax
# this is a comment
./yourprogram value1
./yourprogram value2
```

The commands in the `commandlines` file can be as complicated as you wish, e.g.:

`mkdir output1 && cd output1 && ../yourprogram value1`

!!! tip
	If your command lines use a consecutive input parameter, you can use the string `PYL_ID` which expands to the number of the command. 

	`./yourprogram -n PYL_ID      # expands to 1`
	`./yourprogram -n PYL_ID      # expands to 2`
	`./yourprogram -n PYL_ID      # expands to 3`
	`./yourprogram -n PYL_ID      # expands to 4`


PyLauncher will now distribute each command in the `commandlines` file across the number of nodes requested,  producing final statistics:

```
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

```job-script
launcher.ClassicLauncher("commandlines",debug="host+job")
```

### Output files { #output }

PyLauncher will create a directory "`pylauncher_tmp123456`" where "123456" is the job number. The output of your commandlines needs to be explicitly stored. For instance, your commandlines file could say

```file
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input1
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input2
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input3
...
```

A file named "queuestate" is generated with a listing of which of your commands were successfully executed, and, in case your job times out, which ones were pending or not scheduled. This information can be used to restart your job.

## Parallel runs { #parallel }

### Multi-Threaded { #parallel-multi }

If your program is multi-threaded, you can assign more than one core with:

```job-script
launcher.ClassicLauncher("commandlines",cores=4)
```

This can also be used if your program takes more memory than would normally be assigned to a single core.

```important
Note that you still need to set `--ntasks-per-node` to the maximum as described above, since this tells PyLauncher how many cores there are in each node.
```

If you have a multi-threaded program and you want to set the number of cores individually for each commandline, use the option `cores="file"` (literally, the word "file" in quotes) and prefix each commandline with the core count:

```file
5,myprogram value1
2,myprogram value2
7,myprogram value3
...
```

### MPI

If your program is MPI parallel, replace the ClassicLauncher call with:

```syntax
launcher.IbrunLauncher("parallellines",cores=3)
```

The parallellines file consists of command-lines **without the MPI job starter**, since this is supplied by PyLauncher:

```syntax
./parallelprogram 0 10
./parallelprogram 1 10
./parallelprogram 2 10
```

In the launcher invocation, the "debug" parameter causes trace output to be printed during the run. Example:

```
tick 104
Queue:
completed  60 jobs: 0-44 47-48 50-53 56 58 60-61 64 66 68 70 75
aborted 	0 jobs:
queued  	5 jobs: 99-103
running	39 jobs: 45-46 49 54-55 57 59 62-63 65 67 69 71-74 76-98
```

Which states that in the 104'th stage some jobs were completed/queued for running/actually running. 

The  "tick" message is output every half second. This can be changed, for instance to 1/10th of a second, by specifying "delay=.1" in the launcher command.

## Sample Job Setup { #samplejob }

### Slurm Job Script File on Frontera { #samplejob-jobscript }

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

### PyLauncher File { #samplejob-pylauncherfile }

In the job-script above, "example_classic_launcher.py" contains:

```job-script
import pylauncher
pylauncher.ClassicLauncher("commandlines",debug="host+job")
```

### Command Lines File { #samplejob-commandlines }

and "commandlines" contains your parameter sweep.   

./myparallelprogram arg1 argA
./myparallelprogram arg1 argB
…
## Advanced PyLauncher usage { #advanced }

### PyLauncher within an `idev` Session { #advanced-idev }

PyLauncher creates a working directory with a name based on the SLURM job id. PyLauncher will also refuse to reuse a working directory. Together this has implications for running PyLauncher twice within an `idev` session: after the first run, the second run will complain that the working directory already exists. You have to delete it yourself, or explicitly designate a different working directory name in the launcher command:

```job-script
pylauncher.ClassicLauncher( “mycommandlines”,workdir=<unique name>).
```


### Restart file { #advanced-restart }

PyLauncher will generate a restart file titled "queuestate" that lists which commandlines were finished, and which ones were under way, or to be scheduled when the Launcher job finished. You can use this in case your Launcher job is killed for exceeding the time limit. You can then resume:

```
pylauncher.ResumeClassicLauncher("queuestate",debug="job")
```

### GPU Launcher { #advanced-gpu }

PyLauncher can handle programs that need a GPU. Use:

```
pylauncher.GPULauncher("gpucommandlines")
```

Important: Set Slurm's parameter `--ntasks-per-node` to the number of GPUs per node.

### Submit launcher { #advanced-submitlauncher }

If your commandlines take wildly different amounts of time, a launcher job may be wasteful since it will leave cores (and nodes) unused while the longest running commands finish. One solution is the `submit launcher' which runs outside of Slurm, and which submits Slurm jobs: For instance, the following command submits jobs to Frontera's `small` queue, and ensures that a queue limit of 2 is not exceeded:

```job-script
launcher.SubmitLauncher\
	("commandlines",
 	"-A YourProject -N 1 -n 1 -p small -t 0:15:0", # slurm arguments
 	nactive=2, # queue limit
    )
```

### Debugging PyLauncher Output { #advanced-debugging }

Each PyLauncher run stores output to a unique automatically-generated subdirectory based on Slurm's job ID.

This directory contains three types of files:

1. Files with your commandlines as they are executed by the launcher. 
	Names: exec0 exec1 et cetera.

1. Time stamp files that the launcher uses to determine whether commandlines have finished. 
	Names: expire0 expire1 et cetera.

1. Standard out/error files. These can be useful if you observe that some commandlines don't finish or don't give the right result. 
	Names: out0 out1 et cetera.

## Additional Parameters { #parameters }

Here are some parameters that may sometimes come in handy.

| parameter <option> | description |
--- | --- | 
| `delay=*fraction*`<br>default: `default=.5` | The fraction of a second that PyLauncher waits to start up new jobs, or test for finished ones. If you fire up complicated python jobs, you may want to increase this from the default.
| `workdir=<directory>`<br>default: generated from the SLURM jobid | This is the location of the internal execute/out/test files that PyLauncher generates.
| `queuestate=<filename>`<br>default filename: `queuestate` | PyLauncher can use to restart if your jobs aborts, or is killed for exceeding the time limit. If you run multiple simultaneous jobs, you may want to specify this explicitly.

## References { #refs }

* [Github: PyLauncher](https://github.com/TACC/pylauncher)
* [YouTube: Intro to PyLauncher](https://www.youtube.com/watch?v=-zIO8GY7ev8)
* [`idev` at TACC][TACCIDEV]


{% include 'aliases.md' %}


