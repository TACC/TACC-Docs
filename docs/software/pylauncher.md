# PyLauncher at TACC
*Last update: February 17, 2025* 

## What is PyLauncher		{ #intro }

PyLauncher (**Py**thon + **Launcher**) is a Python-based parametric job launcher, a utility for distributing and executing many small jobs in parallel, using fewer resources than would be necessary to execute all jobs simultaneously. On many batch-based cluster computers this is a better strategy than submitting many small individual small jobs.

While TACC's deprecated Launcher utility worked on serial codes, PyLauncher works with multi-threaded and MPI executables.  

**Example**: You need to run a program with 1000 different input values, and you want to use 100 cores for that; PyLauncher will cycle through your list of commands using cores as they become available. 


The PyLauncher source code is written in Python, but this need not concern you: in the simplest scenario you use a two line Python script. However, for more sophisticated scenarios the code can be extended or integrated into a Python application.

## Installations		{ #installations }

PyLauncher is available on all TACC systems via the [Lmod modules system][TACCLMOD].  Use the following in your batch script or [`idev`][TACCIDEV] session.

```cmd-line
$ module load pylauncher
```
!!! important 
	1. PyLauncher requires at least Python version 3.9:

		`$ module load python3/3.9 # or newer`
	
	1. On some systems the Python installation is missing a required module. 
	Do a one-time setup:   

		`$ pip install paramiko`


## Basic setup { #setup }

PyLauncher, like any compute-intensive application, must be invoked from a Slurm job script, or interactively within an `idev` session. PyLauncher interrogates Slurm's environment variables to query the available computational resources, but the only parameter you have to set is Slurm's `-N` directive.  The number of nodes depends on how much work you have.

```job-script
#SBATCH -N 5 # number of nodes you want to use
```

Pylauncher will then use all the cores of these nodes, running by default one commandline per core. See below for exceptions.

The `pylauncher` module sets the `TACC_PYLAUNCHER_DIR` and `PYTHONPATH` environment variables. 


Your batch script can then invoke Python3 on the launcher code:

```job-script
## file: mylauncher.py
import pylauncher 
pylauncher.ClassicLauncher("commandlines")
```

PyLauncher will now execute the lines in the file `commandlines`:

```file
# this is the commandlines file
./yourprogram value1
./yourprogram value2
```

The commands can be complicated as you wish, e.g.:

```file
mkdir output1 && cd output1 && ../yourprogram value1
```

!!! tip
	If the commands use a consecutive input parameter, you can use the string `PYLTID` which expands to the number of the command. 

		./yourprogram -n PYLTID #1
		./yourprogram -n PYLTID #2
		./yourprogram -n PYLTID #3
		./yourprogram -n PYLTID #4

At the end of the run, PyLauncher will produce final statistics:

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

This reports that 160 commands were executed, using 40 cores. Ideally we would expect a 40 times speedup, but because of variations in run time the aggregate running time of all commands was reduced by only 26.

If you want more detailed trace output during the run, add an option:

```job-script
launcher.ClassicLauncher("commandlines",debug="host+job")
```

## Output files

PyLauncher will create a directory "`pylauncher_tmp123456`" where "`123456`" maps to the job number. You can set the name of this directory explicitly:

```job-script
pylauncher.ClassicLauncher("commandlines",workdir="pylauncher_out")
```

However, note that PyLauncher will not allow you to re-use that directory, so you need to delete it in between runs.

You need to take care of the output of your commandlines explicitly. For instance, your commandlines file could say

```file
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input1
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input2
mkdir -p myoutput && cd myoutput && ${HOME}/myprogram input3
...
```

A file "`queuestate`" is generated with a listing of which of your commands were successfully executed, and, in case your job times out, which ones were pending or not scheduled. This can be used to restart your job. See below.

## Launcher types

The ClassicLauncher uses by default a single core per commandline. The following options / launcher types are available
if you want to run multi-threaded, MPI, or GPU-accelerated tasks.

### Multi-Threaded

If your program is multi-threaded, you can give each command line more than one core with:

```job-script
launcher.ClassicLauncher("commandlines",cores=4)
```

This can also be used if your program takes more memory than would normally be assigned to a single core.

If you want each command line to use all the cores of a node, specify:

```job-script
launcher.ClassicLauncher("commandlines",cores="node")
```

The number of simultaneously running commands is then equal to the number of nodes you requested.

If you have a multi-threaded program and you want to set the number of cores individually for each commandline, use the option `cores="file"` (literally, the word "file" in quotes) and prefix each commandline with the core count:

```file
5,myprogram value1
2,myprogram value2
7,myprogram value3
# et cetera
```

### MPI

If your program is MPI parallel, replace the ClassicLauncher call:

```job-script
launcher.IbrunLauncher("parallellines",cores=3)
```

The "parallellines" file consists of command-lines without the MPI job starter, which is supplied by PyLauncher:

```file
./parallelprogram 0 10
./parallelprogram 1 10
./parallelprogram 2 10
```

By default, these lines are prefixed with the `ibrun` specification. 
If your lines need the `ibrun` in a different location, you can use the placeholder `PYL_MPIEXEC`  to indicate this:

```file
mkdir out1 && cd out1 && PYL_MPIEXEC ./parallelprogram 0 10
mkdir out2 && cd out2 && PYL_MPIEXEC ./parallelprogram 2 10
mkdir out3 && cd out3 && PYL_MPIEXEC ./parallelprogram 3 10
```

### GPU launcher

For GPU jobs, use the `GPULauncher`. This needs an extra parameter `gpuspernode` that is dependent on the cluster where you run this.
If you omit this parameter or set it too high, the launcher may start your tasks when no GPUs are available.
```job-script
pylauncher.GPULauncher\
    ("gpucommandlines",
     gpuspernode=3 # adjust for the desired cluster
     )
```

### Submit launcher

The `SubmitLauncher` is the only launcher that should be invoked outside a SLURM job, since it generates SLURM jobs and submits them.
This makes sense in rare cases where you have tasks of widely varying runtime, and you don't want 
a regular launcher run where
multiple nodes fall idle towards the end of the job, and thereby rack up SU's.

This launcher has a second compulsory argument after the commandlines file: 
a specification of the SLURM parameter, the way you would specify them to `idev` or `srun`.
These indicate how each of your commandlines is run as a separate SLURM job.

Here is a sample call:

```
TACCproject = # your allocation identifier
queue = small # adjust for cluster
maxjobs = 3   # queue limit
workdir = "sublauncher_out"
pylauncher.SubmitLauncher\
    ("submitlines",
     f"-A {TACCproject} -N 1 -n 1 -p {queue} -t 0:5:0", # slurm arguments
     nactive=maxjobs,      # two jobs simultaneously
     maxruntime=900,       # this test should not take too long
     workdir=workdir,
     debug="host+queue+exec+job+task", # lots of debug output
     )
```

## Sample Job Setup

### Slurm Job Script File on Frontera

```job-script
#!/bin/bash
#SBATCH   -p development
#SBATCH   -J pylaunchertest
#SBATCH   -o pylaunchertest.o%j
#SBATCH   -e pylaunchertest.o%j
#SBATCH   –ntasks-per-node 1 # this parameter is ignored
#SBATCH   -N 2
#SBATCH   -t 0:40:00
#SBATCH   -A YourProject

module load python3
python3 example_classic_launcher.py
```

### PyLauncher File

where "example_classic_launcher.py" contains:

```job-script
import pylauncher
pylauncher.ClassicLauncher("commandlines",debug="host+job")
```

### Command Lines File

and "commandlines" contains your parameter sweep.  

``` job-script
./myparallelprogram arg1 argA
./myparallelprogram arg1 argB
...
```

## Debugging and tracing

If you want more detailed trace output during the run, add an option:

`launcher.ClassicLauncher("commandlines",debug="job")`

In the launcher invocation, the `debug` parameter causes trace output to be printed during the run. For example, the `debug="job"` setting produces output:

```
tick 104
Queue:
completed  60 jobs: 0-44 47-48 50-53 56 58 60-61 64 66 68 70 75
aborted 	0 jobs:
queued  	5 jobs: 99-103
running	39 jobs: 45-46 49 54-55 57 59 62-63 65 67 69 71-74 76-98
```

This states that in the 104’th stage some jobs were completed/queued for running/actually running. 

The  `tick` message is output every half second. This can be changed, for instance to 1/10th of a second, by specifying `delay=.1` in the launcher command. In some cases, for instance if each command is a python invocation that does many `imports`, you could increase the delay parameter.

For even more trace output, use `debug="host+exec+task+job+ssh"`.


## Advanced PyLauncher usage

### PyLauncher in an `idev` Session

PyLauncher creates a working directory with a name based on the SLURM job number. PyLauncher will also refuse to reuse a working directory. Together this has implications for running PyLauncher twice in an `idev` session: after the first run, the second run will complain that the working directory already exists. You have to delete it yourself, or explicitly designate a different working directory name in the launcher command:

```job-script
pylauncher.ClassicLauncher( "mycommandlines",workdir=<unique name>).
```

### Restart File

PyLauncher leaves behind a restart file titled "queuestate" that lists which commandlines were finished, and which ones were under way, or to be scheduled when the launcher job finished. You can use this in case your launcher job is killed for exceeding the time limit. You can then resume:

```job-script
pylauncher.ResumeClassicLauncher("queuestate",debug="job")
```

The default name "queuestate" can be overridden by giving an explicit name

```job-script
pylauncher.ClassicLauncher( "commandlines",queuestate="queustate5")
```

### GPU Launcher

PyLauncher can handle programs that need a GPU. Use:

``` job-script
pylauncher.GPULauncher("gpucommandlines")
```


!!! important
	Set the Slurm parameter `--ntasks-per-node` to the number of GPUs per node.

### Submit Launcher

Suppose you allocate 10 nodes to a launcher job, and one commandline takes 10 hours longer than the others. This leads to 9 nodes being idle for several hours.
For this sort of use case, consider the `SubmitLauncher', which runs outside of Slurm, and which submits Slurm jobs: For instance, the following command submits jobs to Frontera's [`small` queue](../../hpc/frontera/#table6), and makes sure that the maximum queue limit of 2 nodes is not exceeded:

``` job-script
launcher.SubmitLauncher\
	("commandlines",
 	"-A YourProject -N 1 -n 1 -p small -t 0:15:0", # slurm arguments
 	nactive=2, # queue limit
    )
```

### Debugging PyLauncher Output

Each PyLauncher run stores output to a unique automatically generated subdirectory based on the job ID.

This directory contains three types of files:

* Files with your command lines as they are executed by the launcher.  Names: `exec0`, `exec1`, etc.
* Time stamp files that the PyLauncher uses to determine whether commandlines have finished.  Names: `expire0`, `expire1`, etc
* Standard out/error files. These can be useful if you observe that some commandlines don't finish or don't give the right result.  Names: `out0`, `out1`, et.

### Parameters

Here are some parameters that may sometimes come in handy.

| parameter <option> | description |
      ---            | --- | 
| <code>delay=<i>fraction</i></code><br>default: `delay=.5` | The fraction of a second that PyLauncher waits to start up new jobs, or test for finished ones. If you fire up complicated python jobs, you may want to increase this from the default.
| <code>workdir=<i>directory</i></code><br>default: generated from the SLURM jobid | This is the location of the internal execute/out/test files that PyLauncher generates.
| <code>queuestate=<i>filename</i></code><br>default filename: `queuestate` | This is a file that PyLauncher can use to restart if your jobs aborts, or is killed for exceeding the time limit. If you run multiple simultaneous jobs, you may want to specify this explicitly.


## References

* [Github: PyLauncher](https://github.com/TACC/pylauncher)
* [YouTube: Intro to PyLauncher](https://www.youtube.com/watch?v=-zIO8GY7ev8)
* [`idev` at TACC][TACCIDEV]

{% include 'aliases.md' %}
