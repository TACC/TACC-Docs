## Launching Applications { #launching }

The primary purpose of your job script is to launch your research application. How you do so depends on several factors, especially (1) the type of application (e.g. MPI, OpenMP, serial), and (2) what you're trying to accomplish (e.g. launch a single instance, complete several steps in a workflow, run several applications simultaneously within the same job). While there are many possibilities, your own job script will probably include a launch line that is a variation of one of the examples described in this section.

### One Serial Application { #launching-serial }

To launch a serial application, simply call the executable. Specify the path to the executable in either the PATH environment variable or in the call to the executable itself:
	
```job-script 
myprogram                   			# executable in a directory listed in $PATH
$SCRATCH/apps/myprov/myprogram 			# explicit full path to executable
./myprogram                 			# executable in current directory
./myprogram -m -k 6 input1  			# executable with notional input options
```

### One Multi-Threaded Application { #launching-multithreaded }

Launch a threaded application the same way. Be sure to specify the number of threads. Note that the default OpenMP thread count is 1.

```job-script
export OMP_NUM_THREADS=56   	# 56 total OpenMP threads (1 per CLX core)
./myprogram
```

### One MPI Application { #launching-mpi }

To launch an MPI application, use the TACC-specific MPI launcher `ibrun`, which is a Frontera-aware replacement for generic MPI launchers like `mpirun` and `mpiexec`. In most cases the only arguments you need are the name of your executable followed by any arguments your executable needs. When you call `ibrun` without other arguments, your Slurm `#SBATCH` directives will determine the number of ranks (MPI tasks) and number of nodes on which your program runs.

```job-script
#SBATCH -N 5				
#SBATCH -n 200
ibrun ./myprogram				# ibrun uses the $SBATCH directives to properly allocate nodes and tasks
```

To use `ibrun` interactively, say within an `idev` session, you can specify:

```cmd-line
login1$ idev -N 2 -n 100 				
c123-456$ ibrun ./myprogram	   # ibrun uses idev's arguments to properly allocate nodes and tasks
```

### One Hybrid (MPI+Threads) Application { #launching-hybrid }


When launching a single application you generally don't need to worry about affinity: both Intel MPI and MVAPICH2 will distribute and pin tasks and threads in a sensible way.

```job-script 
export OMP_NUM_THREADS=8    # 8 OpenMP threads per MPI rank
ibrun ./myprogram           # use ibrun instead of mpirun or mpiexec
```

As a practical guideline, the product of `$OMP_NUM_THREADS` and the maximum number of MPI processes per node should not be greater than total number of cores available per node (56 cores in the development/small/normal/large/flex [queues](#queues).


### More Than One Serial Application in the Same Job { #launching-multiserial }

TACC's `pylauncher` utility provides an easy way to launch more than one serial application in a single job. This is a great way to engage in a popular form of High Throughput Computing: running parameter sweeps (one serial application against many different input datasets) on several nodes simultaneously. The PyLauncher utility will execute your specified list of independent serial commands, distributing the tasks evenly, pinning them to specific cores, and scheduling them to keep cores busy.  Consult [PyLauncher at TACC][TACCPYLAUNCHER] for more information.

### MPI Applications One at a Time { #launching-mpisequential }

To run one MPI application after another (or any sequence of commands one at a time), simply list them in your job script in the order in which you'd like them to execute. When one application/command completes, the next one will begin.

```job-script
module load git
module list
./preprocess.sh
ibrun ./myprogram input1    # runs after preprocess.sh completes
ibrun ./myprogram input2    # runs after previous MPI app completes
```

### More than One MPI Application Running Concurrently { #launching-mpiconcurrent }

To run more than one MPI application simultaneously in the same job, you need to do several things:

* use ampersands to launch each instance in the background;
* include a wait command to pause the job script until the background tasks complete;
* use `ibrun`'s `-n` and `-o` switches to specify task counts and hostlist offsets respectively; and
* include a call to the `task_affinity` script in your `ibrun` launch line.

If, for example, you use `#SBATCH` directives to request N=4 nodes and n=112 total MPI tasks, Slurm will generate a hostfile with 112 entries (28 entries for each of 4 nodes). The `-n` and `-o` switches, which must be used together, determine which hostfile entries ibrun uses to launch a given application; execute `ibrun --help` for more information. Don't forget the ampersands ("&") to launch the jobs in the background, and the `wait` command to pause the script until the background tasks complete:

```job-script 
ibrun -n 56 -o  0 task_affinity ./myprogram input1 &    # 56 tasks; offset by  0 entries in hostfile.
ibrun -n 56 -o 56 task_affinity ./myprogram input2 &    # 56 tasks; offset by 56 entries in hostfile.
wait                                                    # Required; else script will exit immediately.
```

The `task_affinity` script manages task placement and memory pinning when you call ibrun with the `-n`, `-o` switches (it's not necessary under any other circumstances). 

### More than One OpenMP Application Running Concurrently { #launching-multimpiconcurrent }

 
You can also run more than one OpenMP application simultaneously on a single node, but you will need to distribute and pin OpenMP threads appropriately.  The most portable way to do this is with OpenMP Affinity.
 
An OpenMP executable sequentially assigns its N forked threads (thread number 0,...N-1) at a parallel region to the sequence of "places" listed in the `OMP_PLACES` environment variable.  Each place is specified within braces ({}}. The sequence "{0,1},{2,3},{4,5}" has three places, and OpenMP thread numbers 0, 1, and 2 are assigned to the processor ids (proc-ids) 0,1 and 2,3 and 4,5, respectively. The hardware assigned to the proc-ids can be found in the /proc/cpuinfo file.
 
On CLX nodes the sequence of proc-ids on socket 0 are even:

``` syntax
0,2,4,...,108, 110 
```

and on socket 1 they are oddly numbered:

``` syntax
1,3,5,...,109,111 
```

Note, there are 56 cores on CLX, and since hyperthreading is turned on, the list of processors (proc-ids) goes from 0 to 111.  
 
Specifically, the proc-id mapping to the cores for CLX is:

``` syntax
|------- Socket 0 ------------|-------- Socket 1 ---------|
#   0   1   2,..., 25, 26, 27 |  0   1   2,..., 25, 26, 27
0   0   2   4,..., 50, 52, 54 |  1   3   5,..., 51, 53, 55
1  56  58  60,...,106,108,110 | 57  59  61,...,107,109,111
```

Hence, to bind OpenMP threads to a sequence of 3 cores on these systems, the places would be:
 
```job-script 
CLX socket 0:  export OMP_PLACES="{0,56},{2,58},{4,60}"
CLX socket 1:  export OMP_PLACES="{1,57},{3,59},{5,61}"
```
 
Interval notation can be used to express a sequences of places.  The syntax is: {proc-ids},N,S, where N is the number of places to create from the base place ({proc-ids}) with a stride of S.  Hence the above sequences could have been written:
 
```job-script 
CLX socket 0:  export OMP_PLACES="{0,56},3,2"
CLX socket 1:  export OMP_PLACES="{1,57},3,2"
```
 
In the example below two OpenMP programs are executed on a single node, each using 28 threads. The first program uses the cores on socket 0.  It is put in the background, using the ampersand (&) character at the end of the line, so that the job script execution can continue to the second OpenMP program execution, which uses the cores on socket 1.  It, too, is put in the background, and the job execution waits for both to finish with the wait command at the end.
 
```job-script 
export OMP_NUM_THREADS=28
env OMP_PLACES="{0,56},28,2" ./omp.exe &   #execution on socket 0 cores
env OMP_PLACES="{1,57},28,2" ./omp.exe &   #execution on socket 1 cores
wait
```

