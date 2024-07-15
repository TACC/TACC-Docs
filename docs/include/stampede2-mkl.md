### Intel Math Kernel Library (MKL) { #mkl }

The [Intel Math Kernel Library](http://software.intel.com/intel-mkl) (MKL) is a collection of highly optimized functions implementing some of the most important mathematical kernels used in computational science, including standardized interfaces to:

* [BLAS](http://netlib.org/blas) (Basic Linear Algebra Subroutines), a collection of low-level matrix and vector operations like matrix-matrix multiplication 
* [LAPACK](http://netlib.org/lapack) (Linear Algebra PACKage), which includes higher-level linear algebra algorithms like Gaussian Elimination
* FFT (Fast Fourier Transform), including interfaces based on [FFTW](http://fftw.org) (Fastest Fourier Transform in the West)
* [ScaLAPACK](http://netlib.org/scalapack) (Scalable LAPACK), [BLACS](http://netlib.org/blacs) (Basic Linear Algebra Communication Subprograms), Cluster FFT, and other functionality that provide block-based distributed memory (multi-node) versions of selected [LAPACK](https://software.intel.com/en-us/mkl-developer-reference-c-lapack-routines), [BLAS](https://software.intel.com/en-us/mkl-developer-reference-c-blas-and-sparse-blas-routines), and [FFT](https://software.intel.com/en-us/mkl-developer-reference-c-fft-functions) algorithms;
* [Vector Mathematics](http://software.intel.com/en-us/node/521751) (VM) functions that implement highly optimized and vectorized versions of special functions like sine and square root.

#### MKL with Intel C, C++, and Fortran Compilers { #mkl-intel }

There is no MKL module for the Intel compilers because you don't need one: the Intel compilers have built-in support for MKL. Unless you have specialized needs, there is no need to specify include paths and libraries explicitly. Instead, using MKL with the Intel modules requires nothing more than compiling and linking with the `-mkl` option.; e.g.

```cmd-line
$ icc   -mkl mycode.c
$ ifort -mkl mycode.c
```

The `-mkl` switch is an abbreviated form of `-mkl=parallel`, which links your code to the threaded version of MKL. To link to the unthreaded version, use `-mkl=sequential`. A third option, `-mkl=cluster`, which also links to the unthreaded libraries, is necessary and appropriate only when using ScaLAPACK or other distributed memory packages. For additional information, including advanced linking options, see the [MKL documentation](http://software.intel.com/intel-mkl) and [Intel MKL Link Line Advisor](http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor).


#### MKL with GNU C, C++, and Fortran Compilers { #mkl-gnu }

When using a GNU compiler, load the MKL module before compiling or running your code, then specify explicitly the MKL libraries, library paths, and include paths your application needs. Consult the [Intel MKL Link Line Advisor](http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor) for details. A typical compile/link process on a TACC system will look like this:

```cmd-line
$ module load gcc
$ module load mkl                         # available/needed only for GNU compilers
$ gcc -fopenmp -I$MKLROOT/include         \
		 -Wl,-L${MKLROOT}/lib/intel64     \
		 -lmkl_intel_lp64 -lmkl_core      \
		 -lmkl_gnu_thread -lpthread       \
		 -lm -ldl mycode.c
```

For your convenience the `mkl` module file also provides alternative TACC-defined variables like `$TACC_MKL_INCLUDE` (equivalent to `$MKLROOT/include`). Execute `module help mkl` for more information.

#### Using MKL as BLAS/LAPACK with Third-Party Software { #mkl-thirdparty }

When your third-party software requires BLAS or LAPACK, you can use MKL to supply this functionality. Replace generic instructions that include link options like `-lblas` or `-llapack` with the simpler MKL approach described above. There is no need to download and install alternatives like OpenBLAS.

#### Using MKL as BLAS/LAPACK with TACC's MATLAB, Python, and R Modules { #mkl-tacc }

TACC's MATLAB, Python, and R modules all use threaded (parallel) MKL as their underlying BLAS/LAPACK library. These means that even serial codes written in MATLAB, Python, or R may benefit from MKL's thread-based parallelism. This requires no action on your part other than specifying an appropriate max thread count for MKL; see the section below for more information.

#### Controlling Threading in MKL { #mkl-threading }

Any code that calls MKL functions can potentially benefit from MKL's thread-based parallelism; this is true even if your code is not otherwise a parallel application. If you are linking to the threaded MKL (using `-mkl`, `-mkl=parallel`, or the equivalent explicit link line), you need only specify an appropriate value for the max number of threads available to MKL. You can do this with either of the two environment variables `MKL_NUM_THREADS` or `OMP_NUM_THREADS`. The environment variable `MKL_NUM_THREADS` specifies the max number of threads available to each instance of MKL, and has no effect on non-MKL code. If `MKL_NUM_THREADS` is undefined, MKL uses `OMP_NUM_THREADS` to determine the max number of threads available to MKL functions. In either case, MKL will attempt to choose an optimal thread count less than or equal to the specified value. Note that `OMP_NUM_THREADS` defaults to 1 on TACC systems; if you use the default value you will get no thread-based parallelism from MKL.

If you are running a single serial, unthreaded application (or an unthreaded MPI code involving a single MPI task per node) it is usually best to give MKL as much flexibility as possible by setting the max thread count to the total number of hardware threads on the node (272 on KNL, 96 on SKX, 160 on ICX). Of course things are more complicated if you are running more than one process on a node: e.g. multiple serial processes, threaded applications, hybrid MPI-threaded applications, or pure MPI codes running more than one MPI rank per node. See <http://software.intel.com/en-us/articles/recommended-settings-for-calling-intel-mkl-routines-from-multi-threaded-applications> and related Intel resources for examples of how to manage threading when calling MKL from multiple processes. 

#### Using ScaLAPACK, Cluster FFT, and Other MKL Cluster Capabilities { #mkl-othercapabilities }

See "[Working with the Intel Math Kernel Library Cluster Software](https://software.intel.com/en-us/mkl-linux-developer-guide-working-with-the-intel-math-kernel-library-cluster-software)" and "[Intel MKL Link Line Advisor](http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor)" for information on linking to the MKL cluster components.
