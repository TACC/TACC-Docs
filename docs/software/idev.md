# <code>idev</code>: (Interactive Development) User Guide
*Last update: June 11, 2023*

**The need for interactive access to compute nodes**: While large HPC systems are excellent resources for running production work, they are not configured for development. Often developers use departmental systems, or patiently submit a sequence of jobs to validate code changes. This can be particularly frustrating to new users, who want to "kick the tires", port applications and debug codes on supercomputers.

What most users need for development is interactive access to a set of compute nodes, in order to quickly compile, run and validate MPI or other applications multiple times in rapid succession. To help users with their code development, TACC has created an app that will do that, by allowing users to acquire a set of compute nodes for interactive access. The app is called `idev`, for **I**nteractive **DEV**elopment.

The `idev` utility creates an interactive development environment from the user's login window. In the `idev` window the user is connected directly to a compute node from which the user can launch MPI-compiled executables directly (with the `ibrun` command). 

## How it works { #works }

The `idev` command submits a batch job that creates a copy of the batch environment and then goes to sleep. After the job begins, `idev` acquires a copy of the batch environment, SSH's to the master node, and then re-creates the batch environment. The SSH command allows X11 tunneling for setting up a display back to the user's laptop for debugging.

On any TACC system execute `idev -help` to view an extensive list of options:

``` cmd-line
login2$ idev -help
```

<!--    # command options:  -p partition_name
   #                   -m number_of_minutes
   #                   -N number_of_nodes
   #                   -n number_of_tasks
   #                   -A account_name
   #  default values: -p development -m 30 -N 1 -n <max_for_node> -->

If this is your first time launching `idev` and you have multiple projects/allocations, `idev` will prompt you for the project name and then save your selection as the default interactive account (in `~/.idevrc`); otherwise, it will automatically use your only account. 

By default only a single node is requested for 30 minutes in the development queue.  The limits can be changed with command line options, using syntax similar to the batch request specifications used in a job script.  Also, the common defaults can be changed in the ~/.idevrc file (See idev help.)

##  Accessing Nodes Interactively { #interactive }

It is important to realize that idev acquires compute nodes through the Slurm batch system (this is the normal/only mode for acquiring resources on a supercomputer).  This often means there is a wait to acquire nodes in the normal (production) partitions.  Fortunately, at TACC there is a `development` queue on each TACC system (`idev`'s default partition), and it is often a short wait for `idev` to acquire (one or a few) nodes and allow interactive input.  The `idev` output will report every 4 seconds the progress of accessing the nodes through the batch system.

### Examples { #examples }

Below is an example of `idev`'s progress in creating a session on a Stampede3 Skylake development node (in the `skx-dev` partition, the development default partition is for knl nodes):

``` cmd-line
login1$ idev -p skx-dev

 -> Checking on the status of development queue. OK

 -> Defaults file    : ~/.idevrc    
 -> System           : stampede3    
 -> Queue            : skx-dev        (cmd line: -p        )
 -> Nodes            : 1              (idev  default       )
 -> Tasks per Node   : 68             (idev  default       )
 -> Time (hh:mm:ss)  : 00:30:00       (idev  default       )
 -> Project          : use_default    (SLURM default       )

-----------------------------------------------------------------
          Welcome to the Stampede3 Supercomputer                 
-----------------------------------------------------------------
    ...
 -> We will report the job status every 4 seconds: (PD=pending, R=running).


 -> job status:  PD
    ...
 -> job status:  R

 -> Creating interactive terminal session (login) on master node c506-053.

c506-053[skx]$ 
```

Note the above prompt, `c506-053[skx]$`.  This is your custom `idev` prompt which consists of the (master) node name and the node type (skx = Skylake).  You can test the `ibrun` command by executing `ibrun date` which will return the `date` command's output from each core of your session. Launch MPI applications with `ibrun myapp`.

Explore the syntax as described in the `idev -help` display. Some of the more common options are described below.

``` cmd-line
login1$ idev -help
...
OPTION ARGUMENTS         DESCRIPTION  (only common options shown)

  -A   account_name       sets account name (default: Slurm default )
  -m   minutes            sets time in minutes (default: 30)
  -n   total_tasks        Total number of tasks
  -N   nodes              Number of nodes
  -tpn tpn                Tasks per node
  -p   queue_name         sets queue to named queue (default: -p development)
  -t   hh:mm:ss           sets time to hh:mm:ss (default: 00:30:00, 30 min.)

  -queues                   lists queues for the system
  -pselect                  presents slurm queue to select from
  -- <other SLURM options>  MUST occur after ALL idev options (above and below)
  ... 
```

* Only a subset of the options is presented above. 
* Options may be used in any order. 

## Exiting `idev` { #exit }

To exit `idev` and return to your terminal session, type `exit` or `ctrl-D`.

<!--
  -r   reservation_name   requests use of a specific reservation
 * The `-r` option may be used on any system to request a specific resource (e.g. requesting a specific set of nodes). -->


