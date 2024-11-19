# BLAS and LAPACK at TACC
*Last update: August 22, 2024*

BLAS (Basic Linear Algebra Subprograms) is a set of definitions of common operations on vectors and (dense) matrices. LAPACK is the Linear Algebra Package that builds on BLAS and that offers numerical algorithms such as linear system solving and eigenvalue calculations. The so-called "reference" implementations of BLAS/LAPACK are written in Fortran and can be found on <http://netlib.org>, but in practice you don't want to use them since they have low performance. Instead, TACC offers libraries that conform to the specification, but that achieve high performance. They are typically written in a combination of C and Assembly.

## Implementations { #blas }

Your makefile may contain `libblas.a` or `-lblas`. Most Linux distributions indeed have a library by that name, but it will not be tuned for the TACC processor types. Instead, use one of the following libraries.

### MKL { #mkl }

Intel's Math Kernel Library (MKL) is a high performance implementation of BLAS/LAPACK and several other packages. MKL is installed on TACC's Frontera, Stampede3 and Lonestar6 resources. See each resource's user guide for detailed information on linking the MKL into your code.

* [Frontera](../../hpc/frontera#mkl)
* [Stampede3](../../hpc/stampede3#mkl)
* [Lonestar6](../../hpc/lonestar6#mkl)

In general:

* Under the Intel compiler, using BLAS/LAPACK is done through adding the flag `-mkl` both at compile and link time.

* Under the GCC compiler, there is a module `mkl` that defines the `TACC_MKL_DIR` and `TACC_MKL_LIB` environment variables. What libraries you need depends on your application, but often the following works:

		-L${TACC_MKL_LIB} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread

* If you are installing PETSc, use the the following options: 

		--with-blas-lapack-dir=${TACC_MKL_DIR}

	This variable is automatically defined when using the Intel compiler. 

* If you are installing software using `cmake`, add this flag (exact flag may differ by package):

		-D LAPACK_LIBRARIES=${TACC_MKL_DIR}/lib/intel64_lin/libmkl_intel_lp64.so;${TACC_MKL_DIR}/lib/intel64_lin/libmkl_core.so

* If paths and library names are separately specified:

		-D LAPACK_LIBRARY_DIRS:PATH="${TACC_MKL_LIB}"
		-D LAPACK_LIBRARY_NAMES:STRING="mkl_intel_lp64;mkl_sequential;mkl_core;pthread"


### BLIS { #blis }

BLIS (BLAS-like Library Instantiation Software Framework) is an open source high performance implementation of BLAS/LAPACK. It can be accessed through a module: `module load blis`. You will then find the library file in `$TACC_BLIS_LIB`. BLIS extends the BLAS specification; for documentation see <https://github.com/flame/blis>.

### Reference BLAS/LAPACK { #reflapack }

The reference implementation for BLAS/LAPACK is written in Fortran and is very low performance. However, for debugging purposes it can be useful. You can load it with:

	module load referencelapack

This gives access to the compiled Fortran sources from netlib.org/lapack. When building your program with this library, you either need to use the Fortran compiler as linker, or add `-lgfortran` to the link line.


### Goto Blas and OpenBlas { #goto }

Older implementations such as Goto Blas (after former TACC employee Kazushige Goto), and its offshoot, OpenBlas, are no longer maintained and should not be used. Instead, use MKL or BLIS as described above.

### NVIDIA Performance Libraries { #nvpl }

The Vista cluster does not have the Intel compiler suite and therefore is missing MKL. Instead, BLAS and LAPACK functionality can be found in the NVIDIA Performance Libraries (NVPL): 

	module load nvpl

With that, you can use link lines such as:

```
-L${TACC_NVPL_LIB} \
    -lnvpl_lapack_lp64_seq -lnvpl_lapack_core \
    -lnvpl_blas_lp64_seq -lnvpl_blas_core
```



