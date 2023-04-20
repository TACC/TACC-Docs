# Stampede2 User Guide
Last update: September 16, 2022 
see <a href="#history">revision history</a>
  
## [Notices](#notices) { #notices }

 
* **The XSEDE project concluded formal operations as an NSF-funded project on August 31, 2022**.  Similar services are now operated through NSF's follow-on program, Advanced Cyberinfrastructure Coordination Ecosystem: Services &amp; Support, or ACCESS.  Find out more at the [ACCESS website](http://access-ci.org). (09/01/2022)
* **Stampede2 has deployed 240 Intel "Ice Lake" (ICX) compute nodes, replacing 448 KNL compute nodes.**  Each ICX processor has 80 cores on 2 sockets (40 cores/socket). Hyperthreading is enabled: there are two hardware threads per core, for a total of 80 x 2 = 160 hardware threads per node. See [ICX Compute Node](#table2a) specifications, new [ICX job scripts](#scripts), and the new [`icx-normal` queue](#queues) for more information. (03/09/22)

