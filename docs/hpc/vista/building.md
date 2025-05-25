## Building Software

The phrase "building software" is a common way to describe the process of producing a machine-readable executable file from source files written in C, Fortran, CUDA, or some other programming language. In its simplest form, building software involves a simple, one-line call or short shell script that invokes a compiler. More typically, the process leverages the power of makefiles, so you can change a line or two in the source code, then rebuild in a systematic way only the components affected by the change. Increasingly, however, the build process is a sophisticated multi-step automated workflow managed by a special framework like autotools or cmake, intended to achieve a repeatable, maintainable, portable mechanism for installing software across a wide range of target platforms.

!!!important
    TACC maintains a database of currently installed software packages and libraries across all HPC resources.
    Navigate to TACC's [Software List][TACCSOFTWARELIST] to see where, or if, a particular package is already installed on a particular resource.

This section of the user guide does nothing more than introduce the big ideas with simple one-line examples. You will undoubtedly want to explore these concepts more deeply using online resources. You will quickly outgrow the examples here. We recommend that you master the basics of CMake and/or makefiles as quickly as possible: even the simplest computational research project will benefit enormously from the power and flexibility of a CMakefile or makefile-based build process.

### NVIDIA Compilers

NVIDIA is the recommended and default compiler suite on Vista. 

Here are simple examples that use the NVIDIA compiler to build an executable from source code:

```cmd-line
$ nvc mycode.c                    # C source file; executable a.out
$ nvc main.c calc.c analyze.c     # multiple source files
$ nvc mycode.c         -o myexe   # C source file; executable myexe
$ nvcpc mycode.cpp     -o myexe   # C++ source file
$ nvfortran mycode.f90 -o myexe   # Fortran90 source file
```

Compiling a code that uses OpenMP would look like this:

```cmd-line
$ nvc -openmp mycode.c -o myexe   # OpenMP
```

See the published NVIDIA documentation, available online at <https://docs.nvidia.com/hpc-sdk//index.html>.

### GNU Compilers

The GNU foundation maintains a number of high quality compilers, including a compiler for C (`gcc`), C++ (`g++`), and Fortran (`gfortran`). The `gcc` compiler is the foundation underneath all three, and the term "`gcc`" often means the suite of these three GNU compilers.

Load a GCC module to access a recent version of the GNU compiler suite. Avoid using the GNU compilers that are available without a `gcc` module — those will be older versions based on the "system GCC" that comes as part of the Linux distribution.

Here are simple examples that use the GNU compilers to produce an executable from source code:

```cmd-line
$ gcc mycode.c                    # C source file; executable a.out
$ gcc mycode.c          -o myexe  # C source file; executable myexe
$ g++ mycode.cpp        -o myexe  # C++ source file
$ gfortran mycode.f90   -o myexe  # Fortran90 source file
$ gcc -fopenmp mycode.c -o myexe  # OpenMP
```

Note that some compiler options are the same for both NVIDIA and GNU (e.g. `-o`), while others are different (e.g. `-openmp` vs `-fopenmp`). Many options are available in one compiler suite but not the other. See the online GNU documentation for information on optimization flags and other GNU compiler options.

### Compiling and Linking

Building an executable requires two separate steps: (1) compiling (generating a binary object file associated with each source file); and (2) linking (combining those object files into a single executable file that also specifies the libraries that executable needs). The examples in the previous section accomplish these two steps in a single call to the compiler. When building more sophisticated applications or libraries, however, it is often necessary or helpful to accomplish these two steps separately.

Use the `-c` ("compile") flag to produce object files from source files:

```cmd-line
$ nvc -c main.c calc.c results.c
```

Barring errors, this command will produce object files main.o, calc.o, and results.o. Syntax for the NVIDIA and GNU compilers is similar.
You can now link the object files to produce an executable file:

```cmd-line
$ nvc main.o calc.o results.o -o myexe
```

The compiler calls a linker utility (usually `/bin/ld`) to accomplish this task. Again, syntax for other compilers is similar.

### Include and Library Paths

Software often depends on pre-compiled binaries called libraries. When this is true, compiling usually requires using the `-I` option to specify paths to so-called header or include files that define interfaces to the procedures and data in those libraries. Similarly, linking often requires using the `-L` option to specify paths to the libraries themselves. Typical compile and link lines might look like this:

```cmd-line
$ nvc        -c main.c -I${WORK}/mylib/inc -I${TACC_HDF5_INC}                  # compile
$ nvc main.o -o myexe  -L${WORK}/mylib/lib -L${TACC_HDF5_LIB} -lmylib -lhdf5   # link
```

On Vista, both the HDF5 and PHDF5 modules define the environment variables `$TACC_HDF5_INC` and `$TACC_HDF5_LIB`. Other module files define similar environment variables; see Using Modules to Manage Your Environment for more information.

The details of the linking process vary, and order sometimes matters. Much depends on the type of library: static (.a suffix; library's binary code becomes part of executable image at link time) versus dynamically-linked shared (.so suffix; library's binary code is not part of executable; it's located and loaded into memory at run time). However, the `$LD_LIBRARY_PATH` environment variable specifies the search path for dynamic libraries. For software installed at the system-level, TACC's modules generally modify the `$LD_LIBRARY_PATH` automatically. To see whether and how an executable named myexe resolves dependencies on dynamically linked libraries, execute ldd myexe.

### MPI Programs

OpenMPI (`module ompi`) and MVAPICH (`module mvapich`) are the two MPI libraries available on Vista. After loading an `ompi` or `mvapich2` module, compile and/or link using an MPI wrapper (`mpicc`, `mpicxx`, `mpif90`) in place of the compiler:

```cmd-line
$ mpicc    mycode.c   -o myexe   # C source, full build
$ mpicc -c mycode.c              # C source, compile without linking
$ mpicxx   mycode.cpp -o myexe   # C++ source, full build
$ mpif90   mycode.f90 -o myexe   # Fortran source, full build
```

These wrappers call the compiler with the options, include paths, and libraries necessary to produce an MPI executable using the MPI module you're using. To see the effect of a given wrapper, call it with the `-show` option:

```cmd-line
$ mpicc -show                    # Show compile line generated by call to mpicc; similarly for other wrappers
```

### Third-Party Software

See [Building Third-Party Software](../../basics/software#thirdparty) in the [Software at TACC][TACCSOFTWARE] guide.

## Building for Performance

### Compiler Options

When building software on Vista, we recommend using the most recent NVIDIA compiler and OpenMPI library available on Vista. The most recent versions may be newer than the defaults. Execute module spider nvidia and module spider ompi to see what's installed. When loading these modules you may need to specify version numbers explicitly (e.g. `module load nvidia/24.5` and `module load ompi/5.0`).

### Architecture-Specific Flags

The Grace architecture is based on an Arm design that uses Neoverse V2 cores  The Neovers V2 core support Arm’s Scalable Vector Extension v2(SVE2) and Advanced SIMD(NEON) technologies.  Each core has four 128-bit functional units that support 8 64-bit FMA operations. To compile for this specific architecture, include the -tp neoverse-v2 compile option. 

Normally, we do not recommend using the `-fast` option.  But, in this case, since there is only one chip architecture on Vista, and `-fast` does not enforce `-static`, it is safe to use the `-fast` option with the NVIDIA compilers. It will enable optimizations for the Neoverse V2 architecture. 

You can also use the environment variable `$TACC_VEC_FLAGS`.  This environment variable sets the following flags:

	-Mvect=simd -fast -Mipa=fast,inline

If you use GNU compilers, you can optimize for the Grace architecture using the -mcpu=neoverse-v2 option.  You can also use TACC_VEC_FLAGS as with the NVIDIA compilers.  It enables the following flags:

	-O3 -mcpu-neoverse-v2 

