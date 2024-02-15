## [Building Software](#building) { #building }

The phrase "building software" is a common way to describe the process of producing a machine-readable executable file from source files written in C, Fortran, or some other programming language. In its simplest form, building software involves a simple, one-line call or short shell script that invokes a compiler. More typically, the process leverages the power of makefiles, so you can change a line or two in the source code, then rebuild in a systematic way only the components affected by the change. Increasingly, however, the build process is a sophisticated multi-step automated workflow managed by a special framework like autotools or cmake, intended to achieve a repeatable, maintainable, portable mechanism for installing software across a wide range of target platforms.

This section of the user guide does nothing more than introduce the big ideas with simple one-line examples. You will undoubtedly want to explore these concepts more deeply using online resources. You will quickly outgrow the examples here. We recommend that you master the basics of makefiles as quickly as possible: even the simplest computational research project will benefit enormously from the power and flexibility of a makefile-based build process.

### [Compilers](#building-compilers) { #building-compilers }

#### [Intel Compilers](#building-intel) { #building-intel }

Intel is the recommended and default compiler suite on Stampede3. Each Intel module also gives you direct access to mkl without loading an mkl module; see Intel MKL for more information. 

!!! note
	The latest Intel distribution uses the OneAPI compilers which have different names than the traditional Intel compilers:

	Classic	| OneAPI
	---     | ---
	`icc`     | `icx`
	`icpc`    | `icpx`
	`ifort`   | `ifx`

Here are simple examples that use the Intel compiler to build an executable from source code:

	$ icx mycode.c                    # C source file; executable a.out
	$ icx main.c calc.c analyze.c     # multiple source files
	$ icx mycode.c     -o myexe       # C source file; executable myexe
	$ icpx mycode.cpp  -o myexe       # C++ source file
	$ ifx mycode.f90 -o myexe         # Fortran90 source file

Compiling a code that uses OpenMP would look like this:

	$ icx -qopenmp mycode.c -o myexe  # OpenMP

See the published Intel documentation, available both online and in `${TACC_INTEL_DIR}/documentation`, for information on optimization flags and other Intel compiler options.

#### [GNU Compilers](#building-gnu) { #building-gnu }

The GNU foundation maintains a number of high quality compilers, including a compiler for C (gcc), C++ (g++), and Fortran (gfortran). The gcc compiler is the foundation underneath all three, and the term "gcc" often means the suite of these three GNU compilers.

Load a gcc module to access a recent version of the GNU compiler suite. Avoid using the GNU compilers that are available without a gcc module — those will be older versions based on the "system gcc" that comes as part of the Linux distribution.

Here are simple examples that use the GNU compilers to produce an executable from source code:

	$ gcc mycode.c                    # C source file; executable a.out
	$ gcc mycode.c          -o myexe  # C source file; executable myexe
	$ g++ mycode.cpp        -o myexe  # C++ source file
	$ gfortran mycode.f90   -o myexe  # Fortran90 source file
	$ gcc -fopenmp mycode.c -o myexe  # OpenMP; GNU flag is different than Intel

Note that some compiler options are the same for both Intel and GNU (e.g. `-o`), while others are different (e.g. `-qopenmp` vs `-fopenmp`). Many options are available in one compiler suite but not the other. See the online GNU documentation for information on optimization flags and other GNU compiler options.

### [Compiling and Linking](#buildings-steps) { #buildings-steps }

Building an executable requires two separate steps: (1) compiling (generating a binary object file associated with each source file); and (2) linking (combining those object files into a single executable file that also specifies the libraries that executable needs). The examples in the previous section accomplish these two steps in a single call to the compiler. When building more sophisticated applications or libraries, however, it is often necessary or helpful to accomplish these two steps separately.

Use the `-c` ("compile") flag to produce object files from source files:

	$ icx -c main.c calc.c results.c

Barring errors, this command will produce object files main.o, calc.o, and results.o. Syntax for the Intel and GNU compilers is similar.

You can now link the object files to produce an executable file:

	$ icx main.o calc.o results.o -o myexe

The compiler calls a linker utility (usually `/bin/ld`) to accomplish this task. Again, syntax for other compilers is similar.

### [Include and Library Paths](#building-paths) { #building-paths }

Software often depends on pre-compiled binaries called libraries. When this is true, compiling usually requires using the `-I` option to specify paths to so-called header or include files that define interfaces to the procedures and data in those libraries. Similarly, linking often requires using the `-L` option to specify paths to the libraries themselves. Typical compile and link lines might look like this:

	$ icx        -c main.c -I${WORK}/mylib/inc -I${TACC_HDF5_INC}                  # compile
	$ icx main.o -o myexe  -L${WORK}/mylib/lib -L${TACC_HDF5_LIB} -lmylib -lhdf5   # link

On Stampede3, both the hdf5 and phdf5 modules define the environment variables `$TACC_HDF5_INC` and `$TACC_HDF5_LIB`. Other module files define similar environment variables; see Using Modules to Manage Your Environment for more information.

The details of the linking process vary, and order sometimes matters. Much depends on the type of library: static (`.a` suffix; library's binary code becomes part of executable image at link time) versus dynamically-linked shared (`.so` suffix; library's binary code is not part of executable; it's located and loaded into memory at run time).  However, the `$LD_LIBRARY_PATH` environment variable specifies the search path for dynamic libraries. For software installed at the system-level, TACC's modules generally modify `LD_LIBRARY_PATH` automatically. To see whether and how an executable named myexe resolves dependencies on dynamically linked libraries, execute ldd myexe.

<!-- Consult the [Intel Math Kernel Library]() (MKL) section below. -->

<!-- ### [Compiling and Linking MPI Programs](#building-mpi) { #building-mpi } -->
### [MPI Programs](#building-mpi) { #building-mpi }

Intel MPI (module impi) and MVAPICH2 (module mvapich2) are the two MPI libraries available on Stampede3. After loading an impi or mvapich2 module, compile and/or link using an MPI wrapper (`mpicc`, `mpicxx`, `mpif90`) in place of the compiler:

```
$ mpicc    mycode.c   -o myexe   # C source, full build
$ mpicc    -c mycode.c           # C source, compile without linking
$ mpicxx   mycode.cpp -o myexe   # C++ source, full build
$ mpif90   mycode.f90 -o myexe   # Fortran source, full build
```

These wrappers call the compiler with the options, include paths, and libraries necessary to produce an MPI executable using the MPI module you're using. To see the effect of a given wrapper, call it with the `-show` option:

```cmd-line
$ mpicc -show  # Show compile line generated by call to mpicc; similarly for other wrappers
```

### [Building Third-Party Software](#building-thirdparty) { #building-thirdparty }

You are welcome to download third-party research software and install it in your own account. In most cases you'll want to download the source code and build the software so it's compatible with the Stampede3 software environment. 

!!! Warning 
	You cannot use the `sudo` command or any package manager or installation process that requires elevated or "root" user privileges.


Instead, the key is to specify an installation directory for which you have write permissions. Details vary; you should consult the package's documentation and be prepared to experiment. Using the [three-step autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html) build process, the standard approach is to use the `PREFIX` environment variable to specify a non-default, user-owned installation directory at the time you execute `configure` or `make`:

	$ export INSTALLDIR=$WORK/apps/t3pio
	$ ./configure --prefix=$INSTALLDIR
	$ make
	$ make install

CMake based installations have a similar workflow where you specify the install location. Unlike with configure, you create a separate build location and tell cmake where to find the source:

``` cmd-line
$ mkdir build && cd build
$ cmake \
  -D CMAKE_INSTALL_PREFIX=$WORK/apps/whatever \
  /home/you/src/whatever
$ make
$ make install
```

Many packages at TACC set the `CMAKE_PREFIX_PATH` or `PKG_CONFIG_PATH` environment variables in their respective modulefiles, so that dependent modules are found automatically. See the [package documentation](https://cmake.org/getting-started/) for other CMake options. 

Other languages, frameworks, and build systems generally have equivalent mechanisms for installing software in user space. In most cases a web search like "Python Linux install local" will get you the information you need.

In Python, a local install will resemble one of the following examples:

	$ pip install netCDF4     --user                    # install netCDF4 package to $HOME/.local
	$ python setup.py install --user                    # install to $HOME/.local
	$ pip install netCDF4     --prefix=$INSTALLDIR      # custom location; add to PYTHONPATH

Similarly in R:

	$ module load Rstats            # load TACC's default R
	$ R                             # launch R
	> install.packages('devtools')  # R will prompt for install location

You may, of course, need to customize the build process in other ways. It's likely, for example, that you'll need to edit a makefile or other build artifacts to specify Stampede3-specific include and library paths or other compiler settings. A good way to proceed is to write a shell script that implements the entire process: definitions of environment variables, module commands, and calls to the build utilities. Include echo statements with appropriate diagnostics. Run the script until you encounter an error. Research and fix the current problem. Document your experience in the script itself; including dead-ends, alternatives, and lessons learned. Re-run the script to get to the next error, then repeat until done. When you're finished, you'll have a repeatable process that you can archive until it's time to update the software or move to a new machine.

If you wish to share a software package with collaborators, you may need to modify file permissions. See [Sharing Files with Collaborators](../../tutorials/sharingprojectfiles) for more information.

### [Performance](#building-performance) { #building-performance }

#### [Compiler Options](#building-performance-compiler) { #building-performance-compiler }

When building software on Stampede3, we recommend using the most recent Intel compiler and Intel MPI library available on Stampede3. The most recent versions may be newer than the defaults. Execute `module spider intel` and `module spider impi` to see what's installed. When loading these modules you may need to specify version numbers explicitly (e.g. `module load intel/24.0` and `module load impi/21.11`).

#### [Architecture-Specific Flags](#building-performance-archflags) { #building-performance-archflags }

To compile for for all the CPU platforms, include `-xCORE-AVX512` as a build option. The `-x` switch allows you to specify a target architecture.  The `-xCORE-AVX512` is a common subset of Intel's Advanced Vector Extensions 512-bit instruction set that is supported on SPR, ICX, and SKX.  There are some additional 512 bit optimizations implemented for machine learning on Sapphire Rapids.  Besides all other appropriate compiler options, you should also consider specifying an optimization level using the `-O` flag:

	$ icc   -xCORE-AVX512  -O3 mycode.c   -o myexe         # will run only on KNL

Similarly, to build for SKX or ICX, specify the CORE-AVX512 instruction set, which is native to SKX and ICX:

	$ ifort -xCORE-AVX512 -O3 mycode.f90 -o myexe         # will run on SKX or ICX

It's best to avoid building with `-xHost` (a flag that means "optimize for the architecture on which I'm compiling now"). The login nodes are SPR nodes.  Using `-xHost` might include AVX512 instructions that are only supported on SPR nodes. 

Don't skip the `-x` flag in a build: the default is the very old SSE2 (Pentium 4) instruction set. On Stampede3, the module files for the Intel compilers define the environment variable `$TACC_VEC_FLAGS` that stores the recommended architecture flag described above. This can simplify your builds:

	$ echo $TACC_VEC_FLAGS                         
	-xCORE-AVX512
	$ icc $TACC_VEC_FLAGS -O3 mycode.c -o myexe

If you use GNU compilers, see GNU x86 Options for information regarding support for SPR, ICX and SKX. 

