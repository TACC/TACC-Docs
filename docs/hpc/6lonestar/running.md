## Running Jobs { #running }

This section provides an overview of how compute jobs are charged to allocations and describes the **S**imple **L**inux **U**tility for **R**esource **M**anagement (Slurm) batch environment, Lonestar6 queue structure, lists basic Slurm job control and monitoring commands along with options.

{% include 'include/lonestar6-jobaccounting.md' %}

<a id="queues">
### Production Queues { #running-queues }

Lonestar6's new queue, `vm-small` is designed for users who only need a subset of a node's entire 128 cores in the "normal" queue.  Run your jobs in this queue if your job requires 16 cores or less and needs less than 29 GB of memory.  If your job is memory bandwidth dependent, your performance may decrease since your job will be possibly sharing memory bandwidth with other jobs.  

The jobs in this queue consume 1/7 the resources of a full node.  Jobs are charged accordingly at .143 SUs per node hour.

#### Table 5. Production Queues { #table5 }

!!! important
    **Queue limits are subject to change without notice.**
    Frontera admins may occasionally adjust queue <!--the QOS--> settings in order to ensure fair scheduling for the entire user community.
    TACC's `qlimits` utility will display the latest queue configurations.

<!--
10/20/2025
login2.ls6(493)$ qlimits
Current queue/partition limits on TACC's ls6 system:

Name             MinNode  MaxNode     MaxWall  MaxNodePU  MaxJobsPU   MaxSubmit
development            1        8    02:00:00          8          1           3
gpu-a100               1        8  2-00:00:00         12          8          32
gpu-a100-dev           1        2    02:00:00          2          1           3
gpu-a100-small         1        1  2-00:00:00          3          3          12
gpu-h100               1        1  2-00:00:00          1          1           4
large                 65      256  2-00:00:00        256          1           4
normal                 1       64  2-00:00:00         75         20         100
vm-small               1        1  2-00:00:00          4          4          16

/usr/local/etc/queue.map
development:1.0
gpu-a100:3.0
gpu-a100-dev:3.0
gpu-a100-small:1.5
gpu-h100:6.0
large:1.0
normal:1.0
vm-small:0.143
-->

Queue Name | Min/Max Nodes per Job<br>(assoc'd cores)&#42; | Max Job<br>Duration | Max Nodes<br>per User | Max Jobs<br>per User | Max Submit | Charge Rate<br>(per node-hour)
--- | --- | --- | --- | --- | --- | ---
<code>development</code>                         | 8 nodes<br>(1024 cores)       |  2 hours |   8 |  1 | 3 | 1 SU
<code>gpu-a100</code>                            | 8 nodes<br>(1024 cores)       | 48 hours |  12 |  8 | 32 | 3 SUs
<code>gpu-a100-dev</code>                        | 2 nodes<br>(256 cores)        |  2 hours |   2 |  1 | 3 | 3 SUs
<code>gpu-a100-small</code><sup>&#42;&#42;</sup> | 1 node                        | 48 hours |   3 |  3 | 12 | 1.5 SUs
<code>gpu-h100</code>                            | 1 node                        | 48 hours |   1 |  1 | 4 | 6 SUs | (96 cores)
<code>large</code><sup>&#42;</sup>               | 65/256 nodes<br>(65536 cores) | 48 hours | 256 |  1 | 4 | 1 SU
<code>normal</code>                              | 1/64 nodes<br>(8192 cores)    | 48 hours |  75 | 20 | 100 | 1 SU
<code>vm-small</code><sup>&#42;&#42;</sup>       | 1 node<br>(16 cores)          | 48 hours |   4 |  4 | 16 | 0.143 SU


&#42; Access to the `large` queue is restricted. To request more nodes than are available in the normal queue, submit a consulting (help desk) ticket through the TACC User Portal. Include in your request reasonable evidence of your readiness to run under the conditions you're requesting. In most cases this should include your own strong or weak scaling results from Lonestar6.

&#42;&#42; The `gpu-a100-small` and `vm-small` queues contain virtual nodes with fewer resources (cores) than the nodes in the other queues.



