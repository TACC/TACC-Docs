# Frequently Asked Questions


##### Q: I can log into the [TACC User Portal][TACCUSERPORTAL], but this same password doesn't work on Frontera/Lonestar6/Stampede3/Vista.  

A: You don't have an allocation on this machine.  You can only log on to those resources where you have an allocation.  Monitor your allocations on the [TACC User Portal](https://tacc.utexas.edu/portal/projects).


##### Q. A member of my group has left - how do i get access/ownership to those files?      

A. Please [submit a support ticket][SUBMITTICKET] and TACC User Services staff will respond.

##### Q. My allocated work space $WORK of 1TB isn't enough.  I need more.  Can I have more?

A. No.  The Stockyard file system is mounted across all TACC HPC resources: Stampede3, Lonestar6, Frontera and Vista, and thus is shared by thousands of users.  As with many of our policies, we must balance resource availabilty, in this case disk space, for all our users.  

Workaround: However, each HPC resource contains a scratch file system, with no quotas on file space or limits.  A common practice is to store important data in your `/work` directory while allowing your jobs to output data to `/scratch` without dealing with a quota. 

!!! warning
	Every `/scratch` file system has a 10-day purge policy.   

##### Q: I can't login because of "Improper ssh Configuration!" How do I fix this?

If you see this message:

```
--> Verifying valid ssh keys...

Improper ssh configuration!
Please reconfigure or contact TACC consulting for assistance.
```

This is most likely because you have modified your `./ssh/known_hosts` file.  The solution is to generate a new `.ssh` folder to clear any conflicting keys/logins.

1. Go to your home directory:

    ```cmd-line
    $ cd $HOME
    ```

2. Rename your `.ssh` folder to `old_ssh` to save the contents should you need to revisit them at any point:

    ```cmd-line
    $ mv .ssh old_ssh
    ```

3. Log out of the system and then log back in.  This will auto-generate a new `.ssh` folder and key for you.


##### Q. How do I share my files with my project members?  

A. See the [Sharing Project files at TACC][TACCSHARINGPROJECTFILES] documentation.


##### Q. My job is currently running but it's going to run out of time.  Can you give it more time?

A. No. The Slurm Workload Manager does not allow TACC staff to add time to a running job.

##### Q. I need more than 48 hours to run my job, can you allow an extension or give me an exception?

A. No.  The 48-hour time limit is set to balance resource availability across TACC's user base. 

Workarounds: 

1. Implement checkpointing in your workflow.  Many software packages contain checkpointing, the ability to save the state of a job at periodic intervals.  Should your job end due to time limits or node failure, you can re-submit the job allowing it to resume from the last checkpoint in a new job submission.

1. Split up your jobs and use Slurm job dependencies to manage workflows that require multiple steps.  See also [PyLauncher][TACCPYLAUNCHER].


{% include 'aliases.md' %}
