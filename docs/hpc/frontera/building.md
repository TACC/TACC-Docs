## [Building Software](#building) { #building }

<p class="introtext">The phrase "building software" is a common way to describe the process of producing a machine-readable executable file from source files written in C, Fortran, or some other programming language. In its simplest form, building software involves a simple, one-line call or short shell script that invokes a compiler. More typically, the process leverages the power of <a href="http://www.gnu.org/software/make/manual/make.html">makefiles</a>, so you can change a line or two in the source code, then rebuild in a systematic way only the components affected by the change. Increasingly, however, the build process is a sophisticated multi-step automated workflow managed by a special framework like <a href="http://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html">autotools</a> or <a href="http://cmake.org"><code>cmake</code></a>, intended to achieve a repeatable, maintainable, portable mechanism for installing software across a wide range of target platforms.</p>

### [Basics of Building Software](#building-basics) { #building-basics }

This section of the user guide does nothing more than introduce the big ideas with simple one-line examples. You will undoubtedly want to explore these concepts more deeply using online resources. You will quickly outgrow the examples here. We recommend that you master the basics of makefiles as quickly as possible: even the simplest computational research project will benefit enormously from the power and flexibility of a makefile-based build process.

#### [Intel Compilers](#building-basics-intel) { #building-basics-intel }

Intel is the recommended and default compiler suite on Frontera. Each Intel module also gives you direct access to `mkl` without loading an `mkl` module; see [Intel MKL](#building-mkl) for more information. Here are simple examples that use the Intel compiler to build an executable from source code:


Compiling a code that uses OpenMP would look like this:

```cmd-line
 $ icc -qopenmp mycode.c -o myexe  # OpenMP 
```

See the published Intel documentation, available both [online](http://software.intel.com/en-us/intel-software-technical-documentation) and in `${TACC_INTEL_DIR}/documentation`, for information on optimization flags and other Intel compiler options.

#### [GNU Compilers](#building-basics-gnu) { #building-basics-gnu }

The GNU foundation maintains a number of high quality compilers, including a compiler for C (`gcc`), C++ (`g++`), and Fortran (`gfortran`). The `gcc` compiler is the foundation underneath all three, and the term `gcc` often means the suite of these three GNU compilers.

Load a `gcc` module to access a recent version of the GNU compiler suite. Avoid using the GNU compilers that are available without a `gcc` module &mdash; those will be older versions based on the "system gcc" that comes as part of the Linux distribution.

Here are simple examples that use the GNU compilers to produce an executable from source code:

```cmd-line
$ gcc mycode.c                    # C source file; executable a.out
$ gcc mycode.c          -o myexe  # C source file; executable myexe
$ g++ mycode.cpp        -o myexe  # C++ source file
$ gfortran mycode.f90   -o myexe  # Fortran90 source file
$ gcc -fopenmp mycode.c -o myexe  # OpenMP; GNU flag is different than Intel
```

Note that some compiler options are the same for both Intel and GNU <u>(e.g. `-o`)</u>, while others are different (e.g. `-qopenmp` vs `-fopenmp`). Many options are available in one compiler suite but not the other. See the [online GNU documentation](https://gcc.gnu.org/onlinedocs/) for information on optimization flags and other GNU compiler options.

#### [Compiling and Linking as Separate Steps](#building-basics-steps) { #building-basics-steps }

Building an executable requires two separate steps: (1) compiling (generating a binary object file associated with each source file); and (2) linking (combining those object files into a single executable file that also specifies the libraries that executable needs). The examples in the previous section accomplish these two steps in a single call to the compiler. When building more sophisticated applications or libraries, however, it is often necessary or helpful to accomplish these two steps separately.

Use the `-c` ("compile") flag to produce object files from source files:

```cmd-line
$ icc -c main.c calc.c results.c
```

Barring errors, this command will produce object files `main.o`, `calc.o`, and `results.o`. Syntax for other compilers Intel and GNU compilers is similar.

You can now link the object files to produce an executable file:

```cmd-line
$ icc main.o calc.o results.o -o myexe
```

The compiler calls a linker utility (usually `/bin/ld`) to accomplish this task. Again, syntax for other compilers is similar.

#### [Include and Library Paths](#building-basics-paths) { #building-basics-paths }

Software often depends on pre-compiled binaries called libraries. When this is true, compiling usually requires using the `-I` option to specify paths to so-called header or include files that define interfaces to the procedures and data in those libraries. Similarly, linking often requires using the `-L` option to specify paths to the libraries themselves. Typical compile and link lines might look like this:

```cmd-line
$ icc        -c main.c -I${WORK}/mylib/inc -I${TACC_HDF5_INC}                  # compile
$ icc main.o -o myexe  -L${WORK}/mylib/lib -L${TACC_HDF5_LIB} -lmylib -lhdf5   # link
```

On Frontera, both the `hdf5` and `phdf5` modules define the environment variables `$TACC_HDF5_INC` and `$TACC_HDF5_LIB`. Other module files define similar environment variables; see [Using Modules](#admin-configuring-modules) for more information.

The details of the linking process vary, and order sometimes matters. Much depends on the type of library: static (`.a` suffix; library's binary code becomes part of executable image at link time) versus dynamically-linked shared (.so suffix; library's binary code is not part of executable; it's located and loaded into memory at run time). The link line can use rpath to store in the executable an explicit path to a shared library. In general, however, the `LD_LIBRARY_PATH` environment variable specifies the search path for dynamic libraries. For software installed at the system-level, TACC's modules generally modify `LD_LIBRARY_PATH` automatically. To see whether and how an executable named `myexe` resolves dependencies on dynamically linked libraries, execute `ldd myexe`.

A separate section below addresses the [Intel Math Kernel Library](#building-mkl) (MKL).

#### [Compiling and Linking MPI Programs](#building-basics-mpi) { #building-basics-mpi }

Intel MPI (module `impi`) and MVAPICH2 (module `mvapich2`) are the two MPI libraries available on Frontera. After loading an `impi` or `mvapich2` module, compile and/or link using an mpi wrapper (`mpicc`, `mpicxx`, `mpif90`) in place of the compiler:

```cmd-line
$ mpicc    mycode.c   -o myexe   # C source, full build
$ mpicc -c mycode.c              # C source, compile without linking
$ mpicxx   mycode.cpp -o myexe   # C++ source, full build
$ mpif90   mycode.f90 -o myexe   # Fortran source, full build
```

These wrappers call the compiler with the options, include paths, and libraries necessary to produce an MPI executable using the MPI module you're using. To see the effect of a given wrapper, call it with the `-show` option:

```cmd-line
$ mpicc -show  # Show compile line generated by call to mpicc; similarly for other wrappers
```


#### [Building Third-Party Software](#building-basics-thirdparty) { #building-basics-thirdparty }

You can discover already installed software using TACC's [Software Search](https://www.tacc.utexas.edu/use-tacc/software-list/) tool or execute `module spider` or `module avail` on the command-line.

You're welcome to download third-party research software and install it in your own account. In most cases you'll want to download the source code and build the software so it's compatible with the Frontera software environment. You can't use yum or any other installation process that requires elevated privileges, but this is almost never necessary. The key is to specify an installation directory for which you have write permissions. Details vary; you should consult the package's documentation and be prepared to experiment. When using the famous [three-step autotools](http://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html) build process, the standard approach is to use the `PREFIX` environment variable to specify a non-default, user-owned installation directory at the time you execute `configure` or `make`:

```cmd-line
$ export INSTALLDIR=$WORK/apps/t3pio
$ ./configure --prefix=$INSTALLDIR
$ make
$ make install
```

Other languages, frameworks, and build systems generally have equivalent mechanisms for installing software in user space. In most cases a web search like "Python Linux install local" will get you the information you need.

In Python, a local install will resemble one of the following examples:

```cmd-line
$ pip install netCDF4      --user                   # install netCDF4 package to $HOME/.local
$ python3 setup.py install --user                   # install to $HOME/.local
$ pip3 install netCDF4     --prefix=$INSTALLDIR     # custom location; add to PYTHONPATH
```

Similarly in R:

```cmd-line
$ module load Rstats            # load TACC's default R
$ R                             # launch R
> install.packages('devtools')  # R will prompt for install location
```
 
You may, of course, need to customize the build process in other ways. It's likely, for example, that you'll need to edit a `makefile` or other build artifacts to specify Frontera-specific [include and library paths](#building-basics-paths) or other compiler settings. A good way to proceed is to write a shell script that implements the entire process: definitions of environment variables, module commands, and calls to the build utilities. Include `echo` statements with appropriate diagnostics. Run the script until you encounter an error. Research and fix the current problem. Document your experience in the script itself; including dead-ends, alternatives, and lessons learned. Re-run the script to get to the next error, then repeat until done. When you're finished, you'll have a repeatable process that you can archive until it's time to update the software or move to a new machine.

If you wish to share a software package with collaborators, you may need to modify file permissions. See [Sharing Files with Collaborators][TACCSHARINGPROJECTFILES] for more information.

{% include "include/frontera-mkl.md" %} 

### [Building for Performance on Frontera](#building-performance) { #building-performance }

#### [Recommended Compiler](#building-performance-compiler) { #building-performance-compiler }

When building software on Frontera, we recommend using the Intel compiler and Intel MPI stack. This will be the default in the early user period, but may change if we determine one of the other MPI stacks provides superior performance. 

#### [Architecture-Specific Flags](#building-performance-flags) { #building-performance-flags }

To compile for CLX only, include `-xCORE-AVX512` as a build option. The `-x` switch allows you to specify a target architecture. The CLX chips, as well as the Skylake chips (SKX) on Stampede2, support Intel's latest instruction set, CORE-AVX512. You should also consider specifying an optimization level using the `-O` flag:

```cmd-line
$ icc   -xCORE-AVX512  -O3 mycode.c   -o myexe         # will run only on CLX/SKX
$ ifort  -xCORE-AVX512 -O3 mycode.f90 -o myexe         # will run only on CLX/SKX
```

It's best to avoid building with `-xHost` (a flag that means "optimize for the architecture on which I'm compiling now"). Although this will work on Frontera, since the Frontera login nodes are all CLX nodes, if you build on another system, your binary will be based on whatever architecture you built upon. This may not be the same as the architecture on which you will be running.

Also, you should not use the `-fast` flag for the Intel compiler. This flag sets the following options:

<p class="syntax">-ipo -O3 -no-prec-div -static -fp-model fast=2 -xHost</p>

Frontera software libraries, including the MPI libraries, are installed as shared libraries in most cases. The `-static` flag included in `-fast` will cause the compile to fail at the link stage. If you’d like to use the other flags, you’ll have to include each option individually.

For information on the performance implications of your choice of build flags, see the sections on Programming and Performance for CLX.

If you use GNU compilers, see GNU x86 Options for information regarding support for CLX. 

