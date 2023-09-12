## [Running Jobs](#running) { #running }

This section provides an overview of how compute jobs are charged to allocations and describes the **S**imple **L**inux **U**tility for **R**esource **M**anagement (Slurm) batch environment, Lonestar6 queue structure, lists basic Slurm job control and monitoring commands along with options.

{% include 'include/lonestar6-jobaccounting.md' %}

<a id="queues">
### [Production Queues](#running-queues) { #running-queues }

Lonestar6's new queue, `vm-small` is designed for users who only need a subset of a node's entire 128 cores in the "normal" queue.  Run your jobs in this queue if your job requires 16 cores or less and needs less than 29 GB of memory.  If your job is memory bandwidth dependent, your performance may decrease since your job will be possibly sharing memory bandwidth with other jobs.  

The jobs in this queue consume 1/7 the resources of a full node.  Jobs are charged accordingly at .143 SUs per node hour.

#### [Table 5. Production Queues](#table5) { #table5 }

**Queue limits are subject to change without notice.**  Use TACC's `qlimits` utility to see the latest configuration.

Queue Name | Min/Max Nodes per Job<br /> (assoc'd cores)&#42; | Max Job Duration | Max Nodes<br> per User | Max Jobs<br> per User | Charge Rate<br /><u>(per node-hour)</u>
--- | --- | --- | --- | --- | ---
<code>development</code> | 4 nodes<br>(512 cores) | 2 hours | 6 | 1 | 1 SU
<code>gpu-a100</code> | 4 nodes<br>(512 cores) | 48 hours | 6 | 2 | 4 SUs
<code>gpu-a100-dev</code> | 4 nodes<br>(512 cores) | 2 hours | 2 | 1 | 4 SUs
<code>large</code><sup>&#42;</sup> | 65/256 nodes<br>(65536 cores) | 48 hours | 256 | 1 | 1 SU
<code>normal</code> | 1/64 nodes<br>(8192 cores) | 48 hours | 96 | 15 | 1 SU
<code>vm-small</code><sup>&#42;&#42;</sup> | 1/1 node<br>(16 cores) | 48 hours | 4 | 4 | 0.143 SU
<code>gpu-h100</code> | 1 node | 48 hours | 1 | 1 | 6 SUs | (96 cores)


&#42; Access to the `large` queue is restricted. To request more nodes than are available in the normal queue, submit a consulting (help desk) ticket through the TACC User Portal. Include in your request reasonable evidence of your readiness to run under the conditions you're requesting. In most cases this should include your own strong or weak scaling results from Lonestar6.

&#42;&#42; The `vm-small` queue contains virtual nodes with fewer resources (cores) than the nodes in the other queues.



