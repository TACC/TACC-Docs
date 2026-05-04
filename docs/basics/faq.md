# Frequently Asked Questions
*Last update: May 4, 2026*

## Accounts and Access

* **[I can log into the TACC User Portal, but this same password doesn't work on Frontera/Lonestar6/Stampede3/Vista. How can I login to my machine?](#q1)**  
* **[A member of my group has left - how do i get access/ownership to those files?](#q2)**   
* **[I can't login because of "Improper ssh Configuration!" How do I fix this?](#q3)**   
* **[How do I share my files with my project members?](#q5)**   

## Queues and Jobs

* **[My job is currently running but it's going to run out of time.  Can you give it more time?](#q6)**   
* **[I need more than 48 hours to run my job, can you allow an extension or give me an exception?](#q7)**   
* **[Queue wait times are so long.  Is there anything I can do to help my job run faster??](#q8)**   
* **[My job has been waiting in the queue, but I see a bunch of idle nodes.  Why isn't my job running?](#q9)**  

## Storage and File Systems

* **[My allocated work space $WORK of 1TB isn't enough.  I need more.  Can I have more?](#q9)**   

## Policies 

* **[Can I run Artificial Intelligence (AI) tools on TACC HPC systems?](#q10)**  

---

### Accounts and Access

<a id="q1"></a>
#### Q: I can log into the [TACC User Portal][TACCUSERPORTAL], but this same password doesn't work on Frontera/Lonestar6/Stampede3/Vista.  

A:  Make sure that you have an active have an active allocation on that particular machine.  Monitor your allocations on the [TACC User Portal](https://tacc.utexas.edu/portal/projects).   If you are not added to an 


<a id="q2"></a>
#### Q. A member of my group has left - how do i get access/ownership to their files?      

A. Please [submit a support ticket][SUBMITTICKET] and TACC User Services staff will respond.

<a id="q3"></a>
#### Q: I can't login because of "Improper ssh configuration!" How do I fix this?

Consult the [Login Problems: "Improper ssh configuration!"](https://docs.tacc.utexas.edu/basics/accounts/#login-problems-improper-ssh-configuration) section in [Managing Your TACC Account][TACCMANAGEACCOUNT].


<a id="q5"></a>
#### Q. How do I share my files with my project members?  

A. See the [Sharing Project files at TACC][TACCSHARINGPROJECTFILES] documentation.

---

### Queues and Jobs

<a id="q6"></a>
#### Q. My job is currently running but it's going to run out of time.  Can you give it more time?

A. No. The Slurm Workload Manager does not allow TACC staff to add resources, e.g. time, to a running job.


<a id="q7"></a>
#### Q. I need more than 48 hours to run my job, can you allow an extension or give me an exception?

A. No.  The 48-hour time limit is set to balance resource availability across TACC's user base. 

Workarounds: 

* **Implement checkpointing in your workflow**.  Many software packages contain checkpointing, the ability to save the state of a job at periodic intervals.  Should your job end due to time limits or node failure, you can re-submit the job allowing it to resume from the last checkpoint in a new job submission.

* **Split up your jobs and use Slurm job dependencies to manage workflows that require multiple steps**.  See also [PyLauncher][TACCPYLAUNCHER].

<a id="q9"></a>
#### Q. My job has been waiting in the queue, but I see a bunch of idle nodes in the same partition.  Why isn't my job running?  

A. If your job is in the queue pending with reason "Priority", but there are idle nodes, then those nodes are likely being collected for a larger job that is ahead in the queue. The same nodes for large jobs are shared with small jobs, so strictly looking at the idle nodes can sometimes be misleading. 


<a id="q8"></a>
#### Q. Queue wait times are so long.  Is there anything I can do to help my job run faster??

A. The wait times on any of our systems depends on the number and nature of the jobs in the queue and the resources (time, number of nodes, queue) requested.  Queue wait-times can sometimes be high for various reasons.  Busy times include ends of semesters, and allocation period endings.  

Here are some helpful ways to reduce wait times on TACC systems:

* **Request only the resources you need**.  Make sure your job scripts request only the resources, e.g. time, number of nodes,  that are needed for that job.  The scheduler will have an easier time finding a slot for a job requesting 2 nodes for 2 hours, than for a job requesting 4 nodes for 24 hours. 
* **Test your submission scripts.** Start small: Make sure everything works on 2 nodes before you try 20. Work out submission bugs and kinks with 5 minute jobs that won't wait long in the queue and involve short, simple substitutes for your real workload: simple test problems; hello world codes; one-liners like ibrun hostname; or an ldd on your executable (https://docs.tacc.utexas.edu/basics/conduct/#conduct-jobs).
* **Make use of the [`pylauncher`][TACCPYLAUNCHER] utility**.  PyLauncher is ideal for running multiple serial jobs in parallel on a single node. 

---
### Storage and File Systems

<a id="q9"></a>
#### Q. My allocated work space $WORK of 1TB isn't enough.  I need more.  Can I have more?

A. No.  The Stockyard file system is mounted across all TACC HPC resources: Stampede3, Lonestar6, Frontera and Vista, and thus is shared by thousands of users.  As with many of our policies, we must balance resource availabilty, in this case disk space, for all our users.  

Workaround: However, each HPC resource contains a scratch file system, with no quotas on file space or limits.  A common practice is to store important data in your `/work` directory while allowing your jobs to output data to `/scratch` without dealing with a quota. 

!!! warning
	Every `/scratch` file system has a 10-day purge policy.   

---

### Policies

<a id="q10"></a>
#### Q. Can I run Artificial Intelligence (AI) tools on TACC HPC systems?

A. Yes, but only on each resource's compute nodes.  Running AI tools on the login nodes may result in account suspension.  See [AI on TACC Resources](https://docs.tacc.utexas.edu/basics/conduct/#ai) in TACC's [Good Conduct Guide][TACCGOODCONDUCT].  


{% include 'aliases.md' %}
