# Software at TACC
Last update: *May 27, 2025*

## System-Installed 

TACC maintains a database of currently installed software packages and libraries across all HPC resources: Lonestar6, Frontera, Stampede3 and Vista.  	

!!!important
	Navigate to TACC's [Software List][TACCSOFTWARELIST] to see where, or if, a particular package is already installed on a particular resource.

If the software search results are inconclusive you have two choices:

1. Request TACC staff make a global, system-wide, installation of your software package
1. Install the software package in your own workspace as outlined below.  You can always make the resulting executable available to project members.


### Resource-Specific Build Instructions

See each resource user guide's Building Software and Performance sections for architecture-specific build instructions:

* [Frontera](../../hpc/frontera#building)
* [Lonestar6](../../hpc/lonestar6#building)
* [Stampede3](../../hpc/stampede3#building)
* [Vista](../../hpc/vista#building)


## Building Third-Party Software { #thirdparty }

You are welcome to download third-party research software and build and install it in your own account. In most cases you'll want to download the source code and build the software so it's compatible with the resource's software environment.

!!!warning
	You cannot use the `sudo` command or any package manager or installation process that requires elevated or "root" user privileges.

Instead, the key is to specify an installation directory for which you have write permissions. Details vary; you should consult the package's documentation and be prepared to experiment. Using the [three-step autotools build process](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html), the standard approach is to use the `$PREFIX` environment variable to specify a non-default, user-owned installation directory at the time you execute `configure` or `make`:

```cmd-line
$ export INSTALLDIR=$WORK/apps/fftw3
$ ./configure --prefix=$INSTALLDIR
$ make
$ make install
```

CMake based installations have a similar workflow where you specify the install location. Unlike with `configure`, you create a separate build location and tell `cmake` where to find the source:

```cmd-line
$ mkdir build && cd build
$ cmake -D CMAKE_INSTALL_PREFIX=$WORK/apps/yourpackage /home/you/src/yourpackage
$ make
$ make install
```

Many packages at TACC set the `$CMAKE_PREFIX_PATH` or `$PKG_CONFIG_PATH` environment variables in their respective modulefiles, so that dependent modules are found automatically.  See CMake's [Getting Started with CMake](https://cmake.org/getting-started/) documentation.  

Other languages, frameworks, and build systems generally have equivalent mechanisms for installing software in user space. In most cases a web search like "Python Linux install local" will get you the information you need.

In Python, a local install will resemble one of the following examples:

```cmd-line
$ pip install netCDF4     --user                    # install netCDF4 package to $HOME/.local
$ python setup.py install --user                    # install to $HOME/.local
$ pip install netCDF4     --prefix=$INSTALLDIR      # custom location; add to PYTHONPATH
```

Similarly in R:

```cmd-line
$ module load Rstats                                # load TACC's default R
$ R                                                 # launch R
> install.packages('devtools')                      # R will prompt for install location
```

You may, of course, need to customize the build process in other ways. It's likely, for example, that you'll need to edit a makefile or other build artifacts to specify resource-specific include and library paths or other compiler settings. A good way to proceed is to write a shell script that implements the entire process: definitions of environment variables, module commands, and calls to the build utilities. Include `echo` statements with appropriate diagnostics. Run the script until you encounter an error. Research and fix the current problem. Document your experience in the script itself; including dead-ends, alternatives, and lessons learned. Re-run the script to get to the next error, then repeat until done. When you're finished, you'll have a repeatable process that you can archive until it's time to update the software or move to a new machine.

If you wish to share a software package with collaborators, you may need to modify file permissions. See [Sharing Files with Collaborators][TACCSHARINGPROJECTFILES] for more information and detailed instructions.


{% include 'aliases.md' %}

<!--
!!! tip 
	On occasion you'll see installation documentation mention the need for `sudo`, but in almost all cases that is because the assumption is that the installation is intended to be across the entire machine. Instead, for the packages and/or dependencies the process would be the same: import/transfer source materials, extract, and build. 

!!!tip
	All software package management at TACC is done with the [TACC's Lmod tool][TACCLMOD].

-->
