### Job Accounting { #jobaccounting }

Like all TACC systems, Stampede3's accounting and allocation system is based on node-hours: one unadjusted Service Unit (SU) represents a single compute node used for one hour (a node-hour). For any given job, the total cost in SUs is the use of one compute node for one hour of wall clock time plus any charges or discounts for the use of specialized queues, e.g. Stampede3's `pvc` queue, Lonestar6's `gpu-a100` queue, and Frontera's `flex` queue. The [queue charge rates](#queues) are determined by the supply and demand for that particular queue or type of node used and are subject to change.  

The Slurm scheduler tracks and charges for usage to a granularity of a few seconds of wall clock time. **The system charges only for the resources you actually use, not those you request.** If your job finishes early and exits properly, Slurm will release the nodes back into the pool of available nodes. Your job will only be charged for as long as you are using the nodes.

TACC does not implement node-sharing on any compute resource. Each Stampede3 compute node can be assigned to only one user at a time; hence a complete node is dedicated to a user's job and accrues wall-clock time for all the node's cores/GPUs whether or not all cores/GPUs are used.

#### TACC Charging Policy

**Stampede3 SUs billed = (# nodes) x max(job duration in wall clock hours,.25) x (charge rate per node-hour)**

All running jobs are charged a minimum of 15 minutes (.25 hrs) of queue time regardless of actual runtime. This policy ensures equal access to the queues for all users as TACC's user base expands.

For example: a 4-node job in Stampede3's [`spr` queue](#queues) which runs for five minutes would be charged as follows:

	4 nodes * 0.25 hrs * 2 SUs/node-hour = 2 SUs

We strongly encourage users launching large jobs to do thorough testing of your code at smaller node counts prior to maximizing your runs.


