## [Programming and Performance](#programming) { #programming }

Programming for performance is a broad and rich topic. While there are no shortcuts, there are certainly some basic principles that are worth considering any time you write or modify code.

### [Timing and Profiling](#programming-general-timingprofiling) { #programming-general-timingprofiling }

**Measure performance and experiment with both compiler and runtime options.** This will help you gain insight into issues and opportunities, as well as recognize the performance impact of code changes and temporary system conditions.

Measuring performance can be as simple as prepending the shell keyword `time` or the command `perf stat` to your launch line. Both are simple to use and require no code changes. Typical calls look like this:

``` cmd-line
perf stat ./a.out    # report basic performance stats for a.out
time ./a.out         # report the time required to execute a.out
time ibrun ./a.out   # time an MPI code
ibrun time ./a.out   # crude timings for each MPI task (no rank info)
```

As your needs evolve you can add timing intrinsics to your source code to time specific loops or other sections of code. There are many such intrinsics available; some popular choices include [`gettimeofday`](http://man7.org/linux/man-pages/man2/gettimeofday.2.html), [`MPI_Wtime`](https://www.mpich.org/static/docs/v3.2/www3/MPI_Wtime.html) and [`omp_get_wtime`](https://www.openmp.org/spec-html/5.0/openmpsu160.html). The resolution and overhead associated with each of these timers is on the order of a microsecond.

It can be helpful to compare results with different compiler and runtime options: e.g. with and without [vectorization](http://software.intel.com/en-us/fortran-compiler-18.0-developer-guide-and-reference-vec-qvec), [threading](#running-launching-multi), or [Lustre striping](#files-striping). You may also want to learn to use profiling tools like [Intel VTune Amplifier](http://software.intel.com/en-us/intel-vtune-amplifier-xe) <u>(`module load vtune`)</u> or GNU [`gprof`](http://sourceware.org/binutils/docs/gprof/).

### [Data Locality](#programming-general-datalocality) { #programming-general-datalocality }

**Appreciate the high cost (performance penalty) of moving data from one node to another**, from disk to RAM, and even from RAM to cache. Write your code to keep data as close to the computation as possible: e.g. in RAM when needed, and on the node that needs it. This means keeping in mind the capacity and characteristics of each level of the memory hierarchy when designing your code and planning your simulations. A simple KNL-specific example illustrates the point: all things being equal, there's a good chance you'll see better performance when you keep your data in the KNL's [fast MCDRAM](#programming-knl-memorymodes) instead of the slower DDR4.

When possible, best practice also calls for so-called "stride 1 access" -- looping through large, contiguous blocks of data, touching items that are adjacent in memory as the loop proceeds. The goal here is to use "nearby" data that is already in cache rather than going back to main memory (a cache miss) in every loop iteration.

To achieve stride 1 access you need to understand how your program stores its data. Here C and C++ are different than (in fact the opposite of) Fortran. C and C++ are row-major: they store 2d arrays a row at a time, so elements `a[3][4]` and `a[3][5]` are adjacent in memory. Fortran, on the other hand, is column-major: it stores a column at a time, so elements `a(4,3)` and `a(5,3)` are adjacent in memory. Loops that achieve stride 1 access in the two languages look like this:

<table border="1" cellspacing="3" cellpadding="3">
<tr><th>Fortran example</th><th>C example</th></tr>
<tr><td>
``` syntax
real*8 :: a(m,n), b(m,n), c(m,n)
 ...
! inner loop strides through col i
do i=1,n
  do j=1,m
    a(j,i)=b(j,i)+c(j,i)
  end do
end do
```
</td>
<td>
``` syntax
double a[m][n], b[m][n], c[m][n];
 ...
// inner loop strides through row i
for (i=0;i<m;i++){
  for (j=0;j<n;j++){
    a[i][j]=b[i][j]+c[i][j];
  }
}
```
</td></tr>
</table>


### [Vectorization](#programming-general-vectorization) { #programming-general-vectorization }

**Give the compiler a chance to produce efficient, [vectorized](http://software.intel.com/en-us/articles/vectorization-essential) code**. The compiler can do this best when your inner loops are simple (e.g. no complex logic and a straightforward matrix update like the ones in the examples above), long (many iterations), and avoid complex data structures (e.g. objects). See Intel's note on [Programming Guidelines for Vectorization](http://software.intel.com/en-us/node/522571) for a nice summary of the factors that affect the compiler's ability to vectorize loops.

It's often worthwhile to generate [optimization and vectorization reports](http://software.intel.com/en-us/articles/getting-the-most-out-of-your-intel-compiler-with-the-new-optimization-reports) when using the Intel compiler. This will allow you to see exactly what the compiler did and did not do with each loop, together with reasons why.

### [Learning More](#programming-general-more) { #programming-general-more }

The literature on optimization is vast. Some places to begin a systematic study of optimization on Intel processors include: Intel's [Modern Code](http://software.intel.com/en-us/modern-code) resources; and the [Intel Optimization Reference Manual](http://intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-optimization-manual). <!-- SDL and [TACC training materials](http://xortal.tacc.utexas.edu/training#/session/64). -->

### [Programming and Performance: KNL](#programming-knl) { #programming-knl }

#### [Architecture](#programming-knl-architecture) { #programming-knl-architecture }

KNL cores are grouped in pairs; each pair of cores occupies a tile. Since there are 68 cores on each Stampede2 KNL node, each node has 34 active tiles. These 34 active tiles are connected by a two-dimensional mesh interconnect. Each KNL has 2 DDR memory controllers on opposite sides of the chip, each with 3 channels. There are 8 controllers for the fast, on-package MCDRAM, two in each quadrant.

Each core has its own local L1 cache (32KB, data, 32KB instruction) and two 512-bit vector units. Both vector units can execute `AVX512` instructions, but only one can execute legacy vector instructions (`SSE`, `AVX`, and `AVX2`). Therefore, to use both vector units, you must compile with `-xMIC-AVX512`.

Each core can run up to 4 hardware threads. The two cores on a tile share a 1MB L2 cache. Different [cluster modes](#programming-knl-clustermodes) specify the L2 cache coherence mechanism at the node level.

#### [Memory Modes](#programming-knl-memorymodes) { #programming-knl-memorymodes }

The processor's memory mode determines whether the fast MCDRAM operates as RAM, as direct-mapped L3 cache, or as a mixture of the two. The output of commands like `top`, `free`, and `ps -v` reflect the consequences of memory mode. Such commands will show the amount of RAM available to the operating system, not the hardware (DDR + MCDRAM) installed.


<figure id="figure-knlmemorymodes"><img src="../../imgs/stampede2/KNL-Memory-Modes.png"><figcaption>Figure 4. KNL Memory Modes</figcaption></figure>

* **Cache Mode**. In this mode, the fast MCDRAM is configured as an L3 cache. The operating system transparently uses the MCDRAM to move data from main memory. In this mode, the user has access to 96GB of RAM, all of it traditional DDR4. **Most Stampede2 KNL nodes are configured in cache mode.**

* **Flat Mode**. In this mode, DDR4 and MCDRAM act as two distinct Non-Uniform Memory Access (NUMA) nodes. It is therefore possible to specify the type of memory (DDR4 or MCDRAM) when allocating memory. In this mode, the user has access to 112GB of RAM: 96GB of traditional DDR and 16GB of fast MCDRAM. By default, memory allocations occur only in DDR4. To use MCDRAM in flat mode, use the `numactl` utility or the `memkind` library; see [Managing Memory](#programming-knl-managingmemory) for more information. If you do not modify the default behavior you will have access only to the slower DDR4.

* **Hybrid Mode (not available on Stampede2)**. In this mode, the MCDRAM is configured so that a portion acts as L3 cache and the rest as RAM (a second NUMA node supplementing DDR4).

#### [Cluster Modes](#programming-knl-clustermodes) { #programming-knl-clustermodes }

The KNL's core-level L1 and tile-level L2 caches can reduce the time it takes for a core to access the data it needs. To share memory safely, however, there must be mechanisms in place to ensure cache coherency. Cache coherency means that all cores have a consistent view of the data: if data value x changes on a given core, there must be no risk of other cores using outdated values of x. This, of course, is essential on any multi-core chip, but it is especially difficult to achieve on manycore processors.

The details for KNL are proprietary, but the key idea is this: each tile tracks an assigned range of memory addresses. It does so on behalf of all cores on the chip, maintaining a data structure (tag directory) that tells it which cores are using data from its assigned addresses. Coherence requires both tile-to-tile and tile-to-memory communication. Cores that read or modify data must communicate with the tiles that manage the memory associated with that data. Similarly, when cores need data from main memory, the tile(s) that manage the associated addresses will communicate with the memory controllers on behalf of those cores.

The KNL can do this in several ways, each of which is called a cluster mode. Each cluster mode, specified in the BIOS as a boot-time option, represents a tradeoff between simplicity and control. There are three major cluster modes with a few minor variations:

* **All-to-All**. This is the most flexible and most general mode, intended to work on all possible hardware and memory configurations of the KNL. But this mode also may have higher latencies than other cluster modes because the processor does not attempt to optimize coherency-related communication paths.  Stampede2 does not have nodes in this cluster mode.

* **Quadrant (variation: hemisphere)**. This is Intel's recommended default, and the cluster mode of most Stampede2 queues. This mode attempts to localize communication without requiring explicit memory management by the programmer/user. It does this by grouping tiles into four logical/virtual (not physical) quadrants, then requiring each tile to manage MCDRAM addresses only in its own quadrant (and DDR addresses in its own half of the chip). This reduces the average number of "hops" that tile-to-memory requests require compared to all-to-all mode, which can reduce latency and congestion on the mesh.  

* **Sub-NUMA 4 (variation: Sub-NUMA 2)**. This mode, abbreviated **SNC-4**, divides the chip into four NUMA nodes so that it acts like a four-socket processor. SNC-4 aims to optimize coherency-related on-chip communication by confining this communication to a single NUMA node when it is possible to do so. To achieve any performance benefit, this requires explicit manual memory management by the programmer/user (in particular, allocating memory within the NUMA node that will use that memory). Stampede2 does not have nodes in this cluster mode.

<figure id="figure-knlclustermodes"><img src="../../imgs/KNL-Cluster-Modes.png"><figcaption>Figure 5. KNL Cluster Modes</figcaption></figure>

TACC's early experience with the KNL suggests that there is little reason to deviate from Intel's recommended default memory and cluster modes. Cache-quadrant tends to be a good choice for almost all workflows; it offers a nice compromise between performance and ease of use for the applications we have tested. Flat-quadrant is the most promising alternative and sometimes offers moderately better performance, especially when memory requirements per node are less than 16GB. We have not yet observed significant performance differences across cluster modes, and our current recommendation is that configurations other than cache-quadrant and flat-quadrant are worth considering only for very specialized needs. For more information see [Managing Memory](#knl-programming-managingmemory) and [Best Known Practices...](#knl-programming-bestpractices).


#### [Managing Memory](#programming-knl-managingmemory) { #programming-knl-managingmemory }

By design, any application can run in any memory and cluster mode, and applications always have access to all available RAM. Moreover, regardless of memory and cluster modes, there are no code changes or other manual interventions required to run your application safely. However, there are times when explicit manual memory management is worth considering to improve performance. The Linux `numactl` (pronounced "NUMA Control") utility allows you to specify at runtime where your code should allocate memory.

When running in flat-quadrant mode, launch your code with [simple `numactl` settings](#example) to specify whether memory allocations occur in DDR or MCDRAM. See [TACC Training Materials](/training) for additional information.

```job-script
numactl       --membind=0    ./a.out    # launch a.out (non-MPI); use DDR (default)
ibrun numactl --membind=0    ./a.out    # launch a.out (MPI-based); use DDR (default)

numactl       --membind=1    ./a.out    # use only MCDRAM
numactl       --preferred=1  ./a.out    # (<b>RECOMMENDED</b>) MCDRAM if possible; else DDR
numactl       --hardware                # show numactl settings
numactl       --help                    # list available numactl options
```

Examples. Controlling memory in flat-quadrant mode: `numactl` options  

Intel's new `memkind` library adds the ability to manage memory in source code with a special memory allocator for C code and a corresponding attribute for Fortran. This makes possible a level of control over memory allocation down to the level of the individual data element. As this library matures it will likely become an important tool for those who need fine-grained control of memory.

When you're running MPI codes in the flat-quadrant queue, the `mem_affinity` script simplifies memory management by calling `numactl` "under the hood" to make plausible NUMA (Non-Uniform Memory Access) policy choices. For MPI and hybrid applications, the script attempts to ensure that each MPI process uses MCDRAM efficiently. To launch your MPI code with `mem_affinity`, simply place `mem_affinity` immediately after `ibrun`:

	ibrun mem_affinity a.out

It's safe to use `mem_affinity` even when it will have no effect (e.g. cache-quadrant mode). Note that `mem_affinity` and `numactl` cannot be used together.

On Stampede2 the keyword `tacc_affinity` was originally an older name for what is now the `mem_affinity` script. To ensure backward compatibility, `tacc_affinity` is now a symbolic link to `mem_affinity`. Note that `mem_affinity` and the symbolic link `tacc_affinity` do not pin MPI tasks.

#### [Best Known Practices and Preliminary Observations (KNL)](#programming-knl-bestpractices) { #programming-knl-bestpractices }

**Hyperthreading. It is rarely a good idea to use all 272 hardware threads simultaneously**, and it's certainly not the first thing you should try. In most cases it's best to specify no more than <u>64-68</u> MPI tasks or independent processes per node, and 1-2 threads/core. One exception is worth noting: when calling threaded MKL from a serial code, it's safe to set `OMP_NUM_THREADS` or `MKL_NUM_THREADS` to 272. This is because MKL will choose an appropriate thread count less than or equal to the value you specify. See [Controlling Threading in MKL](#mkl-threading) for more information. In any case remember that the default value of `OMP_NUM_THREADS` is 1.

**When measuring KNL performance against traditional processors, compare node-to-node rather than core-to-core.** KNL cores run at lower frequencies than traditional multicore processors. Thus, for a fixed number of MPI tasks and threads, a given simulation may run 2-3x slower on KNL than the same submission ran on Stampede1's Sandy Bridge nodes. A well-designed parallel application, however, should be able to run more tasks and/or threads on a KNL node than is possible on Sandy Bridge. If so, it may exhibit better performance per KNL node than it does on Sandy Bridge.

**General Expectations**. From a pure hardware perspective, a single Stampede2 KNL node could outperform Stampede1's dual socket Sandy Bridge nodes by as much as 6x; this is true for both memory bandwidth-bound and compute-bound codes. This assumes the code is running out of (fast) MCDRAM on nodes configured in flat mode (450 GB/s bandwidth vs 75 GB/s on Sandy Bridge) or using cache-contained workloads on nodes configured in cache mode (memory footprint &lt; 16GB). It also assumes perfect scalability and no latency issues. In practice we have observed application improvements between 1.3x and 5x for several HPC workloads typically run in TACC systems. Codes with poor vectorization or scalability could see much smaller improvements. In terms of network performance, the Omni-Path network provides 100 Gbits per second peak bandwidth, with point-to-point exchange performance measured at over 11 GBytes per second for a single task pair across nodes. Latency values will be higher than those for the Sandy Bridge FDR Infiniband network: on the order of 2-4 microseconds for exchanges across nodes.

**MCDRAM in Flat-Quadrant Mode**. Unless you have specialized needs, we recommend using `mem_affinity` or launching your application with `numactl --preferred=1` when running in flat-quadrant mode (see [Managing Memory](#knl-programming-managingmemory) above). If you mistakenly use `--membind=1`, only the 16GB of fast MCDRAM will be available. If you mistakenly use `--membind=0`, you will not be able to access fast MCDRAM at all.

**Task Affinity**. If you're running one threaded, MPI, or hybrid application at a time, default affinity settings are usually sensible and often optimal. <!-- SDL See [TACC training materials](https://xortal.tacc.utexas.edu/training#/session/41) for more information.--> If you run more than one threaded, MPI, or hybrid application at a time, you'll want to pay attention to affinity. For more information see the appropriate sub-sections under [Launching Applications](#running-launching). 

**MPI Initialization**. Our preliminary scaling tests with Intel MPI on Stampede2 suggest that the time required to complete MPI initialization scales quadratically with the number of MPI tasks (lower case `-n` in your Slurm submission script) and linearly with the number of nodes (upper case `-N`).

**Tuning the Performance Scaled Messaging (PSM2) Library**. When running on KNL with MVAPICH2, set the environment variable `PSM2_KASSIST_MODE` to the value `none` per the [MVAPICH2 User Guide](http://mvapich.cse.ohio-state.edu/static/media/mvapich/mvapich2-2.3b-userguide.html#x1-890006.19). Do not use this environment variable with IMPI; doing so may degrade performance. <!-- The `ibrun` launcher will eventually control this environment variable automatically. -->


### [Programming and Performance: SKX and ICX](#programming-skx) { #programming-skx }

**Hyperthreading. It is rarely a good idea to use all the hardware threads simultaneously**, and it's certainly not the first thing you should try. In most cases it's best to specify no more than 48 MPI tasks or independent processes per SKX node (80 per ICX node), and 1-2 threads/core. One exception is worth noting: when calling threaded MKL from a serial code, it's safe to set `OMP_NUM_THREADS` or `MKL_NUM_THREADS` to 96 for SKX or 160 for ICX. This is because MKL will choose an appropriate thread count less than or equal to the value you specify. See [Controlling Threading in MKL](#mkl-threading) for more information.  In any case remember that the default value of `OMP_NUM_THREADS` is 1.

**Clock Speed.** The published nominal clock speed of the Stampede2 SKX processors is 2.1GHz and for the ICX processors it is 2.3GHz. But [actual clock speed varies widely](https://www.intel.com/content/www/us/en/architecture-and-technology/turbo-boost/turbo-boost-technology.html): it depends on the vector instruction set, number of active cores, and other factors affecting power requirements and temperature limits. At one extreme, a single serial application using the `AVX2` instruction set may run at frequencies approaching 3.7GHz, because it's running on a single core (in fact a single hardware thread). At the other extreme, a large, fully-threaded MKL `dgemm` (a highly vectorized routine in which all cores operate at nearly full throttle) may run at 1.4GHz.

**Vector Optimization and `AVX2`.** In some cases, using the `AVX2` instruction set may produce better performance than `AVX512`. This is largely because cores can run at higher [clock speeds](#clockspeeds) when executing `AVX2` code. To compile for `AVX2`, replace the [multi-architecture flags](#building-performance-architecture) described above with the single flag `-xCORE-AVX2`. When you use this flag you will be able to build and run on any Stampede2 node.

**Vector Optimization and 512-Bit ZMM Registers.** If your code can take advantage of wide 512-bit vector registers, you may want to try [compiling for SKX and ICX](#building-performance-architecture) with (for example):

	-xCORE-AVX512 -qopt-zmm-usage=high

The `qopt-zmm-usage` flag affects the algorithms the compiler uses to decide whether to vectorize a given loop with `AVX51` intrinsics (wide 512-bit registers) or `AVX2` code (256-bit registers). When the flag is set to `-qopt-zmm-usage=low` (the default when compiling for SKX and ICX using <b>`CORE-AVX512`)</b>, the compiler will choose `AVX2` code more often; this may or may not be the optimal approach for your application. The `qopt-zmm-usage` flag is available only on Intel compilers newer than 17.0.4. Do not use [`$TACC_VEC_FLAGS`](#building-performance-architecture) when specifying `qopt-zmm-usage`. This is because `$TACC_VEC_FLAGS` specifies `AVX2-CORE` as the base architecture, and the compiler will ignore `qopt-zmm-usage` unless the base target is a variant of `AVX512`. See the recent [Intel white paper](https://software.intel.com/en-us/articles/tuning-simd-vectorization-when-targeting-intel-xeon-processor-scalable-family), the [compiler documentation](https://software.intel.com/en-us/cpp-compiler-18.0-developer-guide-and-reference-qopt-zmm-usage-qopt-zmm-usage), the compiler man pages, and the notes above for more information.

**Vector Optimization and `COMMON-AVX512`.** We have encountered a few complex packages that currently fail to build or run when compiled with [`CORE-AVX512`](#building-performance-architecture) (native SKX or ICX). In all cases so far, these packages build and run well on all KNL, SNL and ICX when compiled as a single-architecture binary with [`-xCOMMON-AVX512`](#building-performance-architecture).

**Task Affinity.** If you run one MPI application at a time, the `ibrun` MPI launcher will spread each node's tasks evenly across an SKX or ICX node's two sockets, with consecutive tasks occupying the same socket when possible.

**Hardware Thread Numbering.** Execute `lscpu` or `lstopo` on an SKX or ICX node to see the numbering scheme for hardware threads. Note that hardware thread numbers alternate between the sockets: even numbered threads are on NUMA node 0, while odd numbered threads are on NUMA node 1. Furthermore, the two hardware threads on a given core have thread numbers that differ by exactly 48 for SKX and 80 for ICX (e.g. threads 3 and 51 are on the same core on SKX nodes).

**Tuning the Performance Scaled Messaging (PSM2) Library**. When running on SKX with MVAPICH2, setting the environment variable `PSM2_KASSIST_MODE` to the value `none` may or may not improve performance. For more information see the [MVAPICH2 User Guide](http://mvapich.cse.ohio-state.edu/static/media/mvapich/mvapich2-2.3b-userguide.html#x1-890006.19). Do not use this environment variable with IMPI; doing so may degrade performance. The `ibrun` launcher will eventually control this environment variable automatically.


### [File Operations: I/O Performance](#programming-fileio) { #programming-fileio }

This section includes general advice intended to help you achieve good performance during file operations. See [Navigating the Shared File Systems](#files-filesystems) for a brief overview of Stampede2's Lustre file systems and the concept of striping. See [TACC Training material](https://learn.tacc.utexas.edu/) for additional information on I/O performance.

**Follow the advice in [Good Conduct](#shared-lustre-file-systems)** to avoid stressing the file system.

**Stripe for performance**. If your application writes large files using MPI-based parallel I/O (including [MPI-IO](http://mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf), [parallel HDF5](https://support.hdfgroup.org/HDF5/PHDF5/), and [parallel netCDF](https://www.unidata.ucar.edu/software/netcdf/docs/parallel_io.html), you should experiment with stripe counts larger than the default values (2 stripes on `$SCRATCH`, 1 stripe on `$WORK`). See [Striping Large Files](#files-striping) for the simplest way to set the stripe count on the directory in which you will create new output files. You may also want to try larger stripe sizes up to 16MB or even 32MB; execute `man lfs` for more information. If you write many small files you should probably leave the stripe count at its default value, especially if you write each file from a single process. Note that it's not possible to change the stripe parameters on files that already exist. This means that you should make decisions about striping when you *create* input files, not when you read them.

**Aggregate file operations**. Open and close files once. Read and write large, contiguous blocks of data at a time; this requires understanding how a given programming language uses memory to [store arrays](#programming-general-datalocality).

**Be smart about your general strategy**. When possible avoid an I/O strategy that requires each process to access its own files; such strategies don't scale well and are likely to stress a Lustre file system. A better approach is to use a single process to read and write files. Even better is genuinely parallel MPI-based I/O.

**Use parallel I/O libraries**. Leave the details to a high performance package like [MPI-IO](http://mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf) (built into MPI itself), [parallel HDF5](https://support.hdfgroup.org/HDF5/PHDF5/) <u>(`module load phdf5`)</u>, and [parallel netCDF](https://www.unidata.ucar.edu/software/netcdf/docs/parallel_io.html) <u>(`module load pnetcdf`)</u>.

When using the Intel Fortran compiler, **compile with "[`-assume buffered_io`](https://software.intel.com/en-us/fortran-compiler-18.0-developer-guide-and-reference-assume)"**. Equivalently, set the environment variable [`FORT_BUFFERED=TRUE`](https://software.intel.com/en-us/node/680054). Doing otherwise can dramatically slow down access to variable length unformatted files. More generally, direct access in Fortran is typically faster than sequential access, and accessing a binary file is faster than ASCII.

