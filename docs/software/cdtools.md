# CDTools at TACC
*Last update: April 11, 2024*

Leveraging each node's `/tmp` directory space can effectively minimize the I/O load on the global Lustre file system and can also improve the performance of I/O work. Due to its limited size, the `/tmp` space is appropriate for executables/binaries, frequently-used object files, and small size common files, e.g. the global configuration files or the initial/pre-processed data files. 

Collect-Distribute (CDTools) has been designed and developed to distribute files or directories to or from each compute node's `/tmp` directory. 

CDTools has two utilities: 

1. `distribute.bash` - copy/clone the binaries and frequently accessed input files to the local `/tmp` space on each compute node prior to computation/when a job starts, 
2. `collect.bash` - collect output files and log files back to `$WORK` or `$SCRATCH` after computation is complete/before a job finishes. 

You can employ CD Tools within a job script, or interactively within an `idev` session.

## Using CD Tools { #setup }

CDTools is currently installed on TACC's Stampede3, Frontera, and Lonestar6 resources.  

### 1. Initialize CD Tools Environment Variable { #setup-1 }

Load the CDtools module in your job script or within an [`idev`][TACCIDEV] session: 

``` cmd-line
$ module load cdtools
```

### 2. Distribute Files to Each Node's `/tmp` Space { #setup-2 }

Distribute your files/directories to the local `/tmp` space of each compute node allotted for your job:

``` cmd-line
$ distribute.bash ${SCRATCH}/inputfile #put the full path of your input file here
```
or

``` cmd-line
$ distribute.bash ${SCRATCH}/inputdir #put the full path of the directory of your input files here
```

If you `ssh` to those compute nodes after running the above command, you would find an identical copy of your input file or directory in the `/tmp` directory on each node.

### 3. Collect your Output Files { #setup-3 }


!!! Important
	Each node's `/tmp` directory is purged once a job ends and before the node is released back into the pool of available nodes.  


Collect the job output files from the `/tmp` space of each node using the `collect.bash` script.  Place this at the end of your job script or issue this command at the end of your `idev` session.

``` job-script
collect.bash /tmp/outputdir ${SCRATCH}/output_collected
```
or                                        
``` cmd-line
$ collect.bash /tmp/outputfile ${SCRATCH}/output_collected
```

You will obtain a list of output files or directories copied back to your target directories in `$SCRATCH`. These output files or directories have been appended with an underscore and a number that indicates the rank of compute nodes. For example, given a job run on four nodes: files `outputfile_0`, `outputfile_1`, "`outputfile_2` and "`outputfile_3` will all be placed in the "`/output_collected` directory.

## Sample Job Script { #job-script }

```job-script
#!/bin/bash
#SBATCH -J testrun           # Job name
#SBATCH -o CDtest.%j.out     # Name of stdout output file (%j expands to jobId)
#SBATCH -e CDtest.%j.err
#SBATCH -p development       # Queue name
#SBATCH -N 2                 # Total number of nodes requested
#SBATCH -n 16                # Total number of cores requested
#SBATCH -t 00:30:00          # Run time (hh:mm:ss) - 5.0 hours
#SBATCH -A P-1234567         # <-- Allocation name to charge job against

# 0. Preparation

module load cdtools

# 1. Run distribute: Distribute input files and directories
#    to /tmp on each compute node.
#    Distribute your programs/binaries if necessary.

distribute.bash ${SCRATCH}/datafiles/inputfile
distribute.bash ${SCRATCH}/datafiles/inputdir

wait

# 2. Run your application here!

ibrun ./myapp

wait

# 3. Run collect: Collect output files and directories from /tmp.
#    All importnat data files must be archived 
#    to $WORK or $SCRATCH before the job finishes!

collect.bash /tmp/outputdir ${SCRATCH}/datafiles/new_output_collected
```

## Notes { #notes }

* This tool should work for both batch mode and interactive mode. 
* Always test your workflow with CDTools before any substantial productions runs to ensure required files are successfully distributed and collected.
* Users should still understand and respect the `/tmp` limit and other I/O rules. 

## References { #refs }

* [Managing I/O on TACC Resources][TACCMANAGINGIO]
* [`idev` at TACC][TACCIDEV]


{% include 'aliases.md' %}
