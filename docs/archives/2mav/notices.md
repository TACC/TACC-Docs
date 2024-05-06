# Maverick2 User Guide
Last update: May 3, 2023



## [Notices](#notices) { #notices }

* <span style="color:red;">**Maverick2 will be retired from production on May 31, 2023.  Please contact TACC User Services with any questions.**</span> (05/01/2023)
* Maverick2 is TACC's dedicated Deep Learning Machine.  Allocation requests must include a justification explaining your need for this resource. 
* Maverick2 does not support any Visualization applications. 
* Maverick2 does not mount a `/scratch` (`$SCRATCH`) file system.


## [Introduction](#intro) { #intro }

Maverick2 is an extension to TACC's services to support GPU accelerated Machine Learning and Deep Learning research workloads. The power of this system is in its multiple GPUs per node and it is mostly intended to support workloads that are better supported with a dense cluster of GPUs and little CPU compute. The system is designed to support model training via GPU powered frameworks that can take advantage of the 4 GPUs in a node. In addition to the 96 1080-TI Nvidia GPU cards, a limited number of Pascal 100 and Volta 100 cards are available to support any workloads that cannot be done in the smaller memory footprints of the primary GPU cards. The system software supports Tensorflow and Caffe and can also be augmented to run other frameworks. 

