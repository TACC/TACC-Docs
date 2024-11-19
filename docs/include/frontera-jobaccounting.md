### Job Accounting { #jobaccounting }

{% include 'include/suchargenotice.md' %}

Like all TACC systems, Frontera's accounting system is based on node-hours: one unadjusted Service Unit (SU) represents a single compute node used for one hour (a node-hour). For any given job, the total cost in SUs is the use of one compute node for one hour of wall clock time plus any charges or discounts for the use of specialized queues, e.g. Stampede3's `pvc` queue, Lonestar6's `gpu-a100` queue, and Frontera's `flex` queue. The [queue charge rates](#queues) are determined by the supply and demand for that particular queue or type of node used and are subject to change.  

**Frontera SUs billed = (# nodes) x (job duration in wall clock hours) x (charge rate per node-hour)**

The Slurm scheduler tracks and charges for usage to a granularity of a few seconds of wall clock time. **The system charges only for the resources you actually use, not those you request.** If your job finishes early and exits properly, Slurm will release the nodes back into the pool of available nodes. Your job will only be charged for as long as you are using the nodes.

!!! note
	TACC does not implement node-sharing on any compute resource. Each Frontera node can be assigned to only one user at a time; hence a complete node is dedicated to a user's job and accrues wall-clock time for all the node's cores whether or not all cores are used.

<!--- this doesn't belong here 
!!! tip 
	Your queue wait times will be less if you request only the time you need: the scheduler will have a much easier time finding a slot for the 2 hours you really need than say, for the 12 hours requested in your job script. 
-->

Principal Investigators can monitor allocation usage via the [TACC User Portal][TACCUSERPORTAL] under ["Allocations->Projects and Allocations"][TACCALLOCATIONS]. Be aware that the figures shown on the portal may lag behind the most recent usage. Projects and allocation balances are also displayed upon command-line login.

!!! tip
	To display a summary of your TACC project balances and disk quotas at any time, execute:<br><br><code>login1$ <b>/usr/local/etc/taccinfo</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Generally more current than balances displayed on the portals.</code>


