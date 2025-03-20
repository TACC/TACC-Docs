## Programming and Performance { #programming }

Programming for performance is a broad and rich topic. While there are no shortcuts, there are certainly some basic principles that are worth considering any time you write or modify code.

### Timing and Profiling { #programming-timing }

Measure performance and experiment with both compiler and runtime options. This will help you gain insight into issues and opportunities, as well as recognize the performance impact of code changes and temporary system conditions.

Measuring performance can be as simple as prepending the shell keyword `time` or the command `perf stat` to your launch line. Both are simple to use and require no code changes. Typical calls look like this:

```cmd-line
$ perf stat ./a.out    # report basic performance stats for a.out
$ time ./a.out         # report the time required to execute a.out
$ time ibrun ./a.out   # time an MPI code
$ ibrun time ./a.out   # crude timings for each MPI task (no rank info)
```

As your needs evolve you can add timing intrinsics to your source code to time specific loops or other sections of code. There are many such intrinsics available; some popular choices include [`gettimeofday`](https://man7.org/linux/man-pages/man2/gettimeofday.2.html), [`MPI_Wtime`](https://www.mpich.org/static/docs/v3.2/www3/MPI_Wtime.html) and [`omp_get_wtime`](https://www.openmp.org/spec-html/5.0/openmpsu160.html). The resolution and overhead associated with each of these timers is on the order of a microsecond.

It can be helpful to compare results with different compiler and runtime options: e.g. with and without vectorization, threading, or Lustre striping. You may also want to learn to use profiling tools like Intel VTune Amplifier (`module load vtune`) or GNU `gprof`.

### Data Locality { #performance-datalocality }

Appreciate the high cost (performance penalty) of moving data from one node to another, from disk to memory, and even from memory to cache. Write your code to keep data as close to the computation as possible: e.g. in memory when needed, and on the node that needs it. This means keeping in mind the capacity and characteristics of each level of the memory hierarchy when designing your code and planning your simulations. 

When possible, best practice also calls for so-called "stride 1 access" - looping through large, contiguous blocks of data, touching items that are adjacent in memory as the loop proceeds. The goal here is to use "nearby" data that is already in cache rather than going back to main memory (a cache miss) in every loop iteration.

To achieve stride 1 access you need to understand how your program stores its data. Here C and C++ are different than (in fact the opposite of) Fortran. C and C++ are row-major: they store 2d arrays a row at a time, so elements `a[3][4]` and `a[3][5]` are adjacent in memory. Fortran, on the other hand, is column-major: it stores a column at a time, so elements `a(4,3)` and `a(5,3)` are adjacent in memory. Loops that achieve stride 1 access in the two languages look like this:

<table border="1">
<tr><th>Fortran example</th><th>C example</th></tr>
<tr><td><pre>
real*8 :: a(m,n), b(m,n), c(m,n)
 ...
! inner loop strides through col i
do i=1,n
  do j=1,m
    a(j,i)=b(j,i)+c(j,i)
  end do
end do
</pre>
</td><td><pre>
double a[m][n], b[m][n], c[m][n];
 ...
// inner loop strides through row i
for (i=0;i<m;i++){
  for (j=0;j<n;j++){
    a[i][j]=b[i][j]+c[i][j];
  }
}</pre></td></tr></table>

### Vectorization { #programming-vectorization }

Give the compiler a chance to produce efficient, vectorized code. The compiler can do this best when your inner loops are simple (e.g. no complex logic and a straightforward matrix update like the ones in the examples above), long (many iterations), and avoid complex data structures (e.g. objects). See Intel's note on Programming Guidelines for Vectorization for a nice summary of the factors that affect the compiler's ability to vectorize loops.

It's often worthwhile to generate optimization and vectorization reports when using the Intel compiler. This will allow you to see exactly what the compiler did and did not do with each loop, together with reasons why.

The literature on optimization is vast. Some places to begin a systematic study of optimization on Intel processors include: Intel's Modern Code resources; and the Intel Optimization Reference Manual.

### Programming and Performance: SPR, ICX, and SKX { #programming-nodes }

**Clock Speed**: The published nominal clock speed of the Stampede3 SPR processors is 1.9 GHz, for the SKX processors it is 2.1GHz, and for the ICX processors it is 2.3GHz. But actual clock speed varies widely: it depends on the vector instruction set, number of active cores, and other factors affecting power requirements and temperature limits. At one extreme, a single serial application using the AVX2 instruction set may run at frequencies approaching 3.7GHz, because it's running on a single core (in fact a single hardware thread). At the other extreme, a large, fully-threaded MKL `dgemm` (a highly vectorized routine in which all cores operate at nearly full throttle) may run at 1.9 GHz.

**Vector Optimization and AVX2**: In some cases, using the AVX2 instruction set may produce better performance than AVX512. This is largely because cores can run at higher clock speeds when executing AVX2 code. To compile for AVX2, replace the multi-architecture flags described above with the single flag `-xCORE-AVX2`. When you use this flag you will be able to build and run on any Stampede3 node.

**Vector Optimization and 512-Bit ZMM Registers**. If your code can take advantage of wide 512-bit vector registers, you may want to try compiling for with (for example):

	-xCORE-AVX512 -qopt-zmm-usage=high

The `qopt-zmm-usage` flag affects the algorithms the compiler uses to decide whether to vectorize a given loop with AVX51 intrinsics (wide 512-bit registers) or AVX2 code (256-bit registers). When the flag is set to `-qopt-zmm-usage=low` (the default when compiling for SPR, ICX, and SKX using CORE-AVX512), the compiler will choose AVX2 code more often; this may or may not be the optimal approach for your application.  See the recent Intel white paper, the compiler documentation, the compiler man pages, and the notes above for more information.

**Task Affinity**: If you run one MPI application at a time, the `ibrun` MPI launcher will spread each node's tasks evenly across an SPR, ICX, or SKX node's two sockets, with consecutive tasks occupying the same socket when possible.

**Hardware Thread Numbering**. Execute `lscpu` or `lstopo` on SPR, ICX, or SKX nodes to see the numbering scheme for cores. Note that core numbers alternate between the sockets on SKX and ICX nodes: even numbered cores are on NUMA node 0, while odd numbered cores are on NUMA node 1. 

**Tuning the Performance Scaled Messaging (PSM2) Library**. When running on SKX with MVAPICH, setting the environment variable `PSM2_KASSIST_MODE` to the value `none` may or may not improve performance. For more information see the MVAPICH User Guide. Do not use this environment variable with IMPI; doing so may degrade performance. The `ibrun` launcher will eventually control this environment variable automatically.

### File Operations: I/O Performance { #programming-io }

This section includes general advice intended to help you achieve good performance during file operations. See [Managing I/O at TACC][TACCMANAGINGIO] and [TACC Training](https://tacc.utexas.edu/use-tacc/training/) page for additional information on I/O performance. 

**Follow the advice in [TACC Good Conduct Guide][TACCGOODCONDUCT] to avoid stressing the file system**.

**Aggregate file operations**: Open and close files once. Read and write large, contiguous blocks of data at a time; this requires understanding how a given programming language uses memory to store arrays.

**Be smart about your general strategy**: When possible avoid an I/O strategy that requires each process to access its own files; such strategies don't scale well and are likely to stress a parallel file system. A better approach is to use a single process to read and write files. Even better is genuinely parallel MPI-based I/O.

**Use parallel I/O libraries**: Leave the details to a high performance package like MPI-IO (built into MPI itself), parallel HDF5 (`module load phdf5`), and parallel netCDF (`module load pnetcdf`).

When using the Intel Fortran compiler, compile with the `-assume buffered_io` flag. Equivalently, set the environment variable `FORT_BUFFERED=TRUE`. Doing otherwise can dramatically slow down access to variable length unformatted files. More generally, direct access in Fortran is typically faster than sequential access, and accessing a binary file is faster than ASCII.

