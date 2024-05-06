### [Intel oneAPI Math Kernel Library (oneMKL)](#mkl) { #mkl }

The [Intel oneAPI Math Kernel Library](http://software.intel.com/intel-mkl) (oneMKL) is a collection of highly optimized functions implementing some of the most important mathematical kernels used in computational science, including standardized interfaces to:

* [BLAS](http://netlib.org/blas) (Basic Linear Algebra Subroutines), a collection of low-level matrix and vector operations like matrix-matrix multiplication
* [LAPACK](http://netlib.org/lapack) (Linear Algebra PACKage), which includes higher-level linear algebra algorithms like Gaussian Elimination
* FFT (Fast Fourier Transform), including interfaces based on [FFTW](http://fftw.org) (Fastest Fourier Transform in the West)
* [Vector Mathematics](http://software.intel.com/en-us/node/521751) (VM) functions that implement highly optimized and vectorized versions of special functions like sine and square root.
* [ScaLAPACK](http://netlib.org/scalapack) (Scalable LAPACK), [BLACS](http://netlib.org/blacs) (Basic Linear Algebra Communication Subprograms), Cluster FFT, and other functionality that provide block-based distributed memory (multi-node) versions of selected LAPACK, BLAS, and FFT algorithms.


#### [oneMKL with Intel C, C++, and Fortran Compilers](#mkl-intel) { #mkl-intel }

There is no oneMKL module for the Intel compilers because you don't need one: the Intel compilers have built-in support for oneMKL. Unless you have specialized needs, there is no need to specify include paths and libraries explicitly. Instead, using oneMKL with the Intel modules requires nothing more than compiling and linking with the `-qmkl` option.; e.g.

```cmd-line
$ icx -qmkl mycode.c
$ ifx -qmkl mycode.c
```

The `-qmkl` switch is an abbreviated form of `-qmkl=parallel`, which links your code to the threaded version of oneMKL. To link to the unthreaded version, use `-qmkl=sequential`. A third option, `-qmkl=cluster`, which also links to the unthreaded libraries, is necessary and appropriate only when using ScaLAPACK or other distributed memory packages. 

!!! tip
	For additional information, including advanced linking options, see the oneMKL documentation and oneIntel oneMKL Link Line Advisor.

#### [oneMKL with GNU C, C++, and Fortran Compilers](#mkl-gnu) { #mkl-gnu }

When using a GNU compiler, load the oneMKL module before compiling or running your code, then specify explicitly the oneMKL libraries, library paths, and include paths your application needs. Consult the Intel oneMKL Link Line Advisor for details. A typical compile/link process on a TACC system will look like this:

```cmd-line
$ module load gcc
$ module load mkl                         # available/needed only for GNU compilers
$ gcc -fopenmp -I$MKLROOT/include         \
         -Wl,-L${MKLROOT}/lib/intel64     \
         -lmkl_intel_lp64 -lmkl_core      \
         -lmkl_gnu_thread -lpthread       \
         -lm -ldl mycode.c
```

For your convenience the `mkl` module file also provides alternative TACC-defined variables like `$TACC_MKL_INCLUDE` (equivalent to `$MKLROOT/include`). For more information:

```cmd-line
$ module help mkl 
```

#### [Using oneMKL as BLAS/LAPACK with Third-Party Software](#mkl-thirdparty) { #mkl-thirdparty }

When your third-party software requires BLAS or LAPACK, you can use oneMKL to supply this functionality. Replace generic instructions that include link options like `-lblas` or `-llapack` with the simpler oneMKL approach described above. There is no need to download and install alternatives like OpenBLAS.

#### [Using oneMKL as BLAS/LAPACK with TACC's MATLAB, Python, and R Modules](#mkl-tacc) { #mkl-tacc }

TACC's MATLAB, Python, and R modules all use threaded (parallel) oneMKL as their underlying BLAS/LAPACK library. These means that even serial codes written in MATLAB, Python, or R may benefit from oneMKL's thread-based parallelism. This requires no action on your part other than specifying an appropriate max thread count for oneMKL; see the section below for more information.

#### [Controlling Threading in oneMKL](#mkl-threading) { #mkl-threading }

Any code that calls oneMKL functions can potentially benefit from oneMKL's thread-based parallelism; this is true even if your code is not otherwise a parallel application. If you are linking to the threaded oneMKL (using `-qmkl`, `-qmkl=parallel`, or the equivalent explicit link line), you need only specify an appropriate value for the max number of threads available to oneMKL. You can do this with either of the two environment variables `$MKL_NUM_THREADS` or `$OMP_NUM_THREADS`. The environment variable `$MKL_NUM_THREADS` specifies the max number of threads available to each instance of oneMKL, and has no effect on non-MKL code. If `$MKL_NUM_THREADS` is undefined, oneMKL uses `$OMP_NUM_THREADS` to determine the max number of threads available to oneMKL functions. In either case, oneMKL will attempt to choose an optimal thread count less than or equal to the specified value. Note that `$OMP_NUM_THREADS` defaults to 1 on TACC systems; if you use the default value you will get no thread-based parallelism from oneMKL.

If you are running a single serial, unthreaded application (or an unthreaded MPI code involving a single MPI task per node) it is usually best to give oneMKL as much flexibility as possible by setting the max thread count to the total number of hardware threads on the node (96 on SKX, 160 on ICX, 112 on SPR). Of course things are more complicated if you are running more than one process on a node: e.g. multiple serial processes, threaded applications, hybrid MPI-threaded applications, or pure MPI codes running more than one MPI rank per node. See Intel's [Calling oneMKL Functions from Multi-threaded Applications](https://www.intel.com/content/www/us/en/docs/onemkl/developer-guide-linux/2024-1/call-onemkl-functions-from-multi-threaded-apps.html) documentation. 

#### [Using ScaLAPACK, Cluster FFT, and Other oneMKL Cluster Capabilities](#mkl-othercapabilities) { #mkl-othercapabilities }

Intel provides [substantial and detailed documentation](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-documentation.html).  See [Working with the Intel oneAPI Math Kernel Library Cluster Software](https://www.intel.com/content/www/us/en/docs/onemkl/developer-guide-linux/2023-0/working-with-onemkl-cluster-software.html) and [Intel oneAPI Math Kernel Library Link Line Advisor](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-link-line-advisor.html) for information on linking to the oneMKL Cluster components.

