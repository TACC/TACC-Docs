# Frequently Asked Questions

## Login Problems

Q:  I can log into the [TACC User Portal][TACCUSERPORTAL], but this same password doesn't work on Frontera/Lonestar6/Stampede3/Vista.

A: You don't have an allocation on this machine.  Check your allocations here.


## SSH Problems

Q. ssh configuration keys blah

## Ownership 

Q. A member of my group has left - how do i get access/ownership to those files?


## Running Jobs 

Q. My job is currently running but it's going to run out of time.  Can you give it more time?

A. No. Slurm does not allow TACC staff to add time to a running job.

---

Q. I need more than 48 hours to run my job, can you allow an extension or give me an exception?

A. No.  The 48-hour time limit is set to balance resource availability across TACC's user base. 

Many software packages contain checkpointing ability. Checkpointing saves the state of your job at intervals, allowing it to resume from the last checkpoint in a new job submission.
We recommend implementing checkpointing in your workflow.  You can also split up your jobs and use job dependencies to manage workflows that require multiple steps, the see Slurm job dependencies blah. and pylauncher.

---

Q. My allocated work space $WORK isn't enough.  I need more.  Can I have more?

A. No.

The Stockyard file system is mounted across all TACC HPC resources: Stampede3, Lonestar6, Frontera and Vista, and thus is shared by thousands of users.  As with many of our policies, we must balance resource availabilty, in this case disk space, for all our users.  

However, each HPC resource contains a scratch file system, with no quotas on file space or limits.  A common practice is to store important data in your `/work` directory while allowing your jobs to output data to `/scratch` without dealing with a quota. 

``` important
	Scratch has a 10-day purge policy - see each 



{% include 'aliases.md' %}
