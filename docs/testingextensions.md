Fri Feb 17 12:30:15 CST 2023

# Documentation Meeting

## alert boxes

<p class="portlet-msg-alert">This is an alert and it should be a call out box</p>

See example: <https://portal.tacc.utexas.edu/user-guides/stampede2#files-filesystems>

## info box

<p class="portlet-msg-info">This is an info box and it should be a call out</p>

See example: <https://portal.tacc.utexas.edu/user-guides/lonestar6#scratchpurgepolicy>

## 'cmd-line' class examples

<pre class="cmd-line">login1$ <b>module load kitten</b></pre>

``` { .bash }
login1$ { .bash }
login1$ module load kitten
```

```cmd-line
login1$ { .bash .cmd-line}
login1$ module load kitten
```


See example: <https://portal.tacc.utexas.edu/user-guides/stampede2#building-basics-mpi>

## 'job-script' class examples

<pre class="job-script">
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede2 KNL nodes
#
#   *** Serial Job on Normal Queue ***
#   -- Serial codes run on a single node (upper case N = 1).
#        A serial code ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- For a good way to run multiple serial executables at the
#        same time, execute "module load launcher" followed
#        by "module help launcher".

#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -o myjob.o%j       # Name of stdout output file
#SBATCH -e myjob.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes (must be 1 for serial)
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

module load kitten
ibrun -np 4 -N 2 -p small myexecutable
</pre>


```job-script
#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede2 KNL nodes
#
#   *** Serial Job on Normal Queue ***
#
# Last revised: 20 Oct 2017
#
#----------------------------------------------------

#SBATCH -J myjob           # Job name
#SBATCH -n 1               # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 01:30:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=username@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A myproject       # Allocation name (req'd if you have more than 1)

module load randomsoftware
ibrun -N 6 -n 12 myexecutable

```

## Styles I use

### details and summary tags

See: <https://docs.tacc.utexas.edu/hpcugs/stampede2/stampede2/#jobscripts>

??? "Cheesy example - click on arrow to expand"

    I'm not a big fan of this arrow. <br>
    Can we add some margin/whitespace at the bottom? <br>
    Also, markdown __now works__ within these tags.


### Images

I use image tags `<figure>` and `<figcaption>`.

See real life example here: <https://portal.tacc.utexas.edu/user-guides/stampede2#programming-knl-memorymodes>

and demonstrated here
<figure><img src="../imgs/louis.jpg" width="50%">
<figcaption>Louis</figcaption></figure>

## Need more space for long command lines

See old: <https://portal.tacc.utexas.edu/user-guides/stampede2#building-performance-architecture>

vs.

See new: <https://docs.tacc.utexas.edu/hpc/stampede2/#building-performance-architecture>

## Table renderings are very small

See <https://docs.tacc.utexas.edu/hpc/stampede2/#table6>

## Need a style called "introtext"

Only used in Frontera User Guide.  

p class="introtext" - it's just a larger font, used as introductory text.  

See <https://frontera-portal.tacc.utexas.edu/user-guide/running/>.  The first sentences, prior to "Job Accounting" should be displayed in a larger than normal font.

## Code Examples

See <a href="/code-examples">Fiddling: Code Examples</a>.


## `admonition` extension


I use "attention", "note", "warning" the most

!!! caution
    ````caution` Do not run jobs or perform intensive computational activity on the login nodes or the shared file systems. Your account may be __suspended__ and you will lose access to the queues if your jobs are impacting other users.

!!! important
    ````important` Example: <https://portal.tacc.utexas.edu/user-guides/stampede2#files-striping>

!!! error
    ````error`

!!! warning
    ````warning` Your account may be __suspended__ and you will lose access to the queues if your jobs are impacting other users.

!!! tip
    ````tip` This box should hold a useful bit of info for a user, not a general message. We can use the notes for that.

!!! note
    ````note` TACC does not implement node-sharing on any compute resource.

!!! attention "Pay Attention"
    ````attention "Pay Attention"`

!!! hint "Do This"
    ````hint "Do This"`

!!! danger "Don't Do This"
    ````danger "Don't Do This"`




## `attr_list`

| set on td    | set on em   |
|--------------|-------------|
| *a* { .foo } | *b*{ .foo } |


