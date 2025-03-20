## Programming and Performance { #programming } 

### Programming and Performance: General { #programming-general } 

Programming for performance is a broad and rich topic. While there are no shortcuts, there are certainly some basic principles that are worth considering any time you write or modify code.


#### Timing and Profiling { #programming-general-profiling } 

**Measure performance and experiment with both compiler and runtime options.** This will help you gain insight into issues and opportunities, as well as recognize the performance impact of code changes and temporary system conditions.

Measuring performance can be as simple as prepending the shell keyword `time` or the command `perf stat` to your launch line. Both are simple to use and require no code changes. Typical calls look like this:

```cmd-line
$ perf stat ./a.out    # report basic performance stats for a.out
$ time ./a.out         # report the time required to execute a.out
$ time ibrun ./a.out   # time an MPI code
$ ibrun time ./a.out   # crude timings for each MPI task (no rank info)
```

As your needs evolve you can add timing intrinsics to your source code to time specific loops or other sections of code. There are many such intrinsics available; some popular choices include [`gettimeofday`](http://man7.org/linux/man-pages/man2/gettimeofday.2.html), [`MPI_Wtime`](https://www.mpich.org/static/docs/v3.2/www3/MPI_Wtime.html) and [`omp_get_wtime`](https://www.openmp.org/spec-html/5.0/openmpsu160.html). The resolution and overhead associated with each of these timers is on the order of a microsecond.

It can be helpful to compare results with different compiler and runtime options: e.g. with and without [vectorization](http://software.intel.com/en-us/fortran-compiler-18.0-developer-guide-and-reference-vec-qvec), [threading](#launching-multithreaded), or [Lustre striping](#files-striping). You may also want to learn to use profiling tools like [Intel VTune Amplifier](http://software.intel.com/en-us/intel-vtune-amplifier-xe) <u>(`module load vtune`)</u> or GNU [`gprof`](http://sourceware.org/binutils/docs/gprof/).

#### Data Locality { #programming-general-datalocality } 

**Appreciate the high cost (performance penalty) of moving data from one node to another**, from disk to RAM, and even from RAM to cache. Write your code to keep data as close to the computation as possible: e.g. in RAM when needed, and on the node that needs it. This means keeping in mind the capacity and characteristics of each level of the memory hierarchy when designing your code and planning your simulations. 

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
for (i=0;i&lt;m;i++){
  for (j=0;j&lt;n;j++){
    a[i][j]=b[i][j]+c[i][j];
  }
}
```
</td></tr>
</table>


#### Vectorization { #programming-vectorization } 

**Give the compiler a chance to produce efficient, [vectorized](http://software.intel.com/en-us/articles/vectorization-essential) code**. The compiler can do this best when your inner loops are simple (e.g. no complex logic and a straightforward matrix update like the ones in the examples above), long (many iterations), and avoid complex data structures (e.g. objects). See Intel's note on [Programming Guidelines for Vectorization](http://software.intel.com/en-us/node/522571) for a nice summary of the factors that affect the compiler's ability to vectorize loops.

It's often worthwhile to generate [optimization and vectorization reports](http://software.intel.com/en-us/articles/getting-the-most-out-of-your-intel-compiler-with-the-new-optimization-reports) when using the Intel compiler. This will allow you to see exactly what the compiler did and did not do with each loop, together with reasons why.

#### Learning More { #programming-more } 

The literature on optimization is vast. Some places to begin a systematic study of optimization on Intel processors include: Intel's [Modern Code](http://software.intel.com/en-us/modern-code) resources; the [Intel Optimization Reference Manual](http://intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-optimization-manual); and [TACC training materials](https://learn.tacc.utexas.edu/course/).

### Programming and Performance: CLX { #programming-clx } 

<!-- span style="color:red">**Hyperthreading.** Hyperthreading is not enabled on Frontera.</span> It is rarely a good idea to use 96 hardware threads simultaneously**, and it's certainly not the first thing you should try. In most cases it's best to specify no more than 48 MPI tasks or independent processes per node, and 1-2 threads/core. One exception is worth noting: when calling threaded MKL from a serial code, it's safe to set `OMP_NUM_THREADS` or `MKL_NUM_THREADS` to 96. This is because MKL will choose an appropriate thread count less than or equal to the value you specify. See [Controlling Threading in MKL](#mkl-threading) for more information.  In any case remember that the default value of `OMP_NUM_THREADS` is 1.-->

**Clock Speed.** The published nominal clock speed of the Frontera CLX processors is 2.7GHz. But [actual clock speed varies widely](https://www.intel.com/content/www/us/en/architecture-and-technology/turbo-boost/turbo-boost-technology.html): it depends on the vector instruction set, number of active cores, and other factors affecting power requirements and temperature limits. At one extreme, a single serial application using the `AVX2` instruction set may run at frequencies approaching 3.7GHz, because it's running on a single core (in fact a single hardware thread). At the other extreme, a large, fully-threaded MKL `dgemm` (a highly vectorized routine in which all cores operate at nearly full throttle) may run at 2.4GHz.

**Vector Optimization and `AVX2`.** In some cases, using the `AVX2` instruction set may produce better performance than `AVX512`. This is largely because cores can run at higher clock speeds when executing `AVX2` code. To compile for `AVX2`, replace the [multi-architecture flags](#building-performance-flags) described above with the single flag `-xCORE-AVX2`. When you use this flag you will be able to build and run on any Frontera node.

**Vector Optimization and 512-Bit ZMM Registers.** If your code can take advantage of wide 512-bit vector registers, you may want to try [compiling for CLX](#building-basics-intel) with (for example):

``` syntax
-xCORE-AVX512 -qopt-zmm-usage=high
```

The `qopt-zmm-usage` flag affects the algorithms the compiler uses to decide whether to vectorize a given loop with 512 intrinsics (wide 512-bit registers) or `AVX2` code (256-bit registers). When the flag is set to `-qopt-zmm-usage=low` (the default when compiling for the CLX using <u>`CORE-AVX512`)</u>, the compiler will choose `AVX2` code more often; this may or may not be the optimal approach for your application. The `qopt-zmm-usage` flag is available only on Intel compilers newer than 17.0.4. Do not use [`$TACC_VEC_FLAGS`](#building-performance-flags) when specifying `qopt-zmm-usage`. This is because `$TACC_VEC_FLAGS` specifies `CORE-AVX2` as the base architecture, and the compiler will ignore `qopt-zmm-usage` unless the base target is a variant of `AVX512`. See the recent [Intel white paper](https://software.intel.com/en-us/articles/tuning-simd-vectorization-when-targeting-intel-xeon-processor-scalable-family), the [compiler documentation](https://software.intel.com/en-us/cpp-compiler-18.0-developer-guide-and-reference-qopt-zmm-usage-qopt-zmm-usage), the compiler man pages, and the notes above for more information.

**Task Affinity.** If you run one MPI application at a time, the `ibrun` MPI launcher will spread each node's tasks evenly across an CLX node's two sockets, with consecutive tasks occupying the same socket when possible.

**Core Numbering.** Execute `lscpu` or `lstopo` on a CLX node to see the numbering scheme for socket cores. Note that core numbers alternate between the sockets: even numbered cores are on socket 0 (NUMA node 0), while odd numbered cores are on socket 1 (NUMA node 1).<!-- 06/10/2019 hyperthreading not enabled Furthermore, the two hardware threads on a given core have thread numbers that differ by exactly 48 (e.g. threads 3 and 51 are on the same core). -->


### File Operations: I/O Performance { #programming-fileio } 

This section includes general advice intended to help you achieve good performance during file operations. See [Navigating the Shared File Systems](#files-navigating) for a brief overview of Frontera's Lustre file systems and the concept of striping. See [TACC Training material](https://learn.tacc.utexas.edu/) for additional information on I/O performance.

**Follow the advice in [Good Conduct][TACCGOODCONDUCT]** to avoid stressing the file system.

**Stripe for performance**. If your application writes large files using MPI-based parallel I/O (including [MPI-IO](http://mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf), [parallel HDF5](https://support.hdfgroup.org/HDF5/PHDF5/), and [parallel netCDF](https://www.unidata.ucar.edu/software/netcdf/docs/parallel_io.html), you should experiment with stripe counts larger than the default values (2 stripes on `$SCRATCH`, 1 stripe on `$WORK`). See [Striping Large Files](#files-striping) for the simplest way to set the stripe count on the directory in which you will create new output files. You may also want to try larger stripe sizes up to 16MB or even 32MB; execute `man lfs` for more information. If you write many small files you should probably leave the stripe count at its default value, especially if you write each file from a single process. Note that it's not possible to change the stripe parameters on files that already exist. This means that you should make decisions about striping when you *create* input files, not when you read them.

**Aggregate file operations**. Open and close files once. Read and write large, contiguous blocks of data at a time; this requires understanding how a given programming language uses memory to [store arrays](#programming-general-datalocality).

**Be smart about your general strategy**. When possible avoid an I/O strategy that requires each process to access its own files; such strategies don't scale well and are likely to stress a Lustre file system. A better approach is to use a single process to read and write files. Even better is genuinely parallel MPI-based I/O.

**Use parallel I/O libraries**. Leave the details to a high performance package like [MPI-IO](http://mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf) (built into MPI itself), [parallel HDF5](https://support.hdfgroup.org/HDF5/PHDF5/) <u>(`module load phdf5`)</u>, and [parallel netCDF](https://www.unidata.ucar.edu/software/netcdf/docs/parallel_io.html) <u>(`module load pnetcdf`)</u>.

When using the Intel Fortran compiler, **compile with [`-assume buffered_io`](https://software.intel.com/en-us/fortran-compiler-18.0-developer-guide-and-reference-assume)**. Equivalently, set the environment variable [`FORT_BUFFERED=TRUE`](https://software.intel.com/en-us/node/680054). Doing otherwise can dramatically slow down access to variable length unformatted files. More generally, direct access in Fortran is typically faster than sequential access, and accessing a binary file is faster than ASCII.

