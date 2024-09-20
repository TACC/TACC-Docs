# Vista User Guide 
*Last update: September 20, 2024*

## Notices { #notices }

* **Important**: Please note [TACC's new SU charge policy](#sunotice). (09/20/2024)
* **[Subscribe][TACCSUBSCRIBE] to Vista User News**. Stay up-to-date on Vista's status, scheduled maintenances and other notifications.  (09/01/2024)

## Introduction { #intro }

<!-- Please [reference TACC](https://tacc.utexas.edu/about/citing-tacc/) when providing any citations.   -->

Vista is funded by the National Science Foundation (NSF) via a supplement to the Computing for the Endless Frontier award, [Award Abstract #1818253](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1818253).  Vista expands the Frontera project's support of Machine Learning and GPU-enabled applications with a system based on NVIDIA Grace Hopper architecture and provides a path to more power efficient computing with NVIDIA's Grace Grace ARM CPUs. 

The Grace Hopper Superchip introduces a novel architecture that combines the GPU and CPU in one module.  This technology removes the bottleneck of the PCIe bus by connecting the CPU and GPU directly with NVLINK and exposing the CPU and GPU memory space as separate NUMA nodes.  This allows the programmer to easily access CPU or GPU memory from either device.  This greatly reduces the programming complexity of GPU programs while providing increased bandwidth and reduced latency between CPU and GPU.  

The Grace Superchip connects two 72 core Grace CPUs using the same NVLINK technology used in the Grace Hopper Superchip to provide 144 ARM cores in 2 NUMA nodes.  Using LPDDR memory, each Superchip offers over 850 GiB/s of memory bandwidth and up to 7 TFlops of double precision performance. 

### Allocations { #intro-allocations }

*Coming soon*.



