# User Services Frequently Asked Questions
*Last update: May 5, 2026*

<style id="faq-style">
summary {
    font-weight: var(--medium);
}
details {
    margin-block: 1em;
}
</style>


## FAQ Categories { #categories }

* [Accounts and Access](#accounts)
* [Queues and Jobs](#queues)
* [Storage and File Systems](#storage)
* [Policies ](#policies)

---
<!-- template for Q and A 
/// details | QUESTION
ANSWER
///
-->

## Accounts and Access { #accounts }

/// details | I can log into the TACC User Portal, but the same password doesn't work on Frontera/Lonestar6/Stampede3/Vista. How can I log in to my machine?
Your account must be approved and associated with an active project in order to log on to resources associated with that project.  Make sure that your account has an active allocation.  Examine your allocations on the [TACC User Portal](https://tacc.utexas.edu/portal/projects).   
///


/// details | A member of my group has left. How can i get access to their files?      
[Submit a support ticket][SUBMITTICKET] and TACC User Services staff will respond.
///

/// details | I can't log in because of "Improper ssh configuration!" How do I fix this?
Consult the [Login Problems: "Improper ssh configuration!"](https://docs.tacc.utexas.edu/basics/accounts/#login-problems-improper-ssh-configuration) section in [Managing Your TACC Account][TACCMANAGINGACCOUNT].
///

/// details | How do I share my files with my project members?  
See the [Sharing Project files at TACC][TACCSHARINGPROJECTFILES] documentation.
///

---
## Queues and Jobs { #queues }

/// details | Queue wait times are so long.  Is there anything I can do to help my job run sooner?

The wait times on any of our systems depends on the number and nature of the jobs in the queue and the resources (time, number of nodes, queue) requested.  Queue wait-times can vary significantly.  Busy periods coincide with ends of semesters, and allocation period endings.  

Here are some helpful ways to reduce wait times on TACC systems:

* **Request only the resources you need**.  Make sure your job scripts request only the resources, e.g. time, number of nodes,  that are needed for that job.  The scheduler will have an easier time finding a slot for a job requesting 2 nodes for 2 hours, than for a job requesting 4 nodes for 24 hours. 
* **Test your submission scripts.** Start small: Make sure everything works on 2 nodes before trying 20. Work out submission bugs and kinks with 5 minute jobs that won't wait long in the queue and involve short, simple substitutes for your real workload: simple test problems; hello world codes; one-liners like ibrun hostname; or an ldd on your executable (https://docs.tacc.utexas.edu/basics/conduct/#conduct-jobs).
* **Make use of the [`PyLauncher`][TACCPYLAUNCHER] utility**.  PyLauncher is ideal for running multiple serial jobs in parallel on a single node. 
///

/// details | My job is currently running but it's going to run out of time.  Can you give it more time?

No. The Slurm Workload Manager does not allow TACC staff to add resources, e.g. time, to a running job.
///


/// details | I need more than 48 hours to run my job, can you allow an extension or give me an exception?

No.  The 48-hour time limit is set to balance resource availability across TACC's user base. 

Workarounds: 

* **Implement checkpointing in your workflow**.  Many software packages contain checkpointing, the ability to save the state of a job at periodic intervals.  Should your job end due to time limits or node failure, you can re-submit the job allowing it to resume from the last checkpoint in a new job submission.

* **Split up your jobs and use Slurm job dependencies to manage workflows that require multiple steps**.  See also [PyLauncher][TACCPYLAUNCHER].
///

/// details | My job has been waiting in the queue, but I see a bunch of idle nodes in the same partition.  Why isn't my job running?  

If your job is in the queue pending with reason "Priority", but there are idle nodes, then those nodes are likely being collected for a larger job that is ahead in the queue. The same nodes for large jobs are shared with small jobs, so strictly looking at the idle nodes can sometimes be misleading. 
///

/// details | I can no longer submit jobs. I got the message "One or more of your jobs...", How can i fix this.?

Revocation of queue access is almost always the result of not following the TACC Good Conduct guidelines.  

* Running computationally excessive tasks on the login nodes
* Taxing the `$WORK` file system, e.g. not running your jobs out of `$SCRATCH`
* Improper use of AI tools
///

/// details | Why didn't you notify me before suspending my queue access?

The system admins are responsible for several thousand users and multiple machines. Their priority is to keep the machines in a healthy state for all users.  If your jobs are impeding the optimal functioning of the machine for others users, our User Services team usually does not have time to reach out beforehand.     
///

---
## Storage and File Systems { #storage }

/// details | My allocated `$WORK` space of 1TB isn't sufficient.  Can I request more?

No.  The Stockyard file system is mounted across all TACC High Performance Computing (HPC)  resources: Stampede3, Lonestar6, Frontera and Vista, and thus is shared by thousands of users.  As with many of our policies, we must balance resource availability, in this case disk space, for all our users.  

Workaround: Each HPC resource contains a scratch file system, with no quotas on file space or limits.  Store important data in your `/work` directory while allowing your jobs to output data to `/scratch` without dealing with a quota. 

!!! warning
	Every `/scratch` file system has a 10-day purge policy.   
///

---
## Policies  { #policies }

/// details | Can I run Artificial Intelligence (AI) tools on TACC's systems?

Yes, but only on each resource's compute nodes.  Running AI tools on the login nodes may result in account suspension.  See [AI on TACC Resources](https://docs.tacc.utexas.edu/basics/conduct/#ai) in TACC's [Good Conduct Guide][TACCGOODCONDUCT].  
///


{% include 'aliases.md' %}
