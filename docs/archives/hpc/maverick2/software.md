## Software { #software }

As of January 17, 2023, the following software modules are currently installed on Maverick2. You can discover already installed software using TACC's [Software Search](https://www.tacc.utexas.edu/use-tacc/software-list/) tool or via `module` commands e.g., `module spider`, `module avail` to retrieve the most up-to-date listing.

``` cmd-line
login1$ module avail

-------------------- /opt/apps/intel18/impi18_0/modulefiles --------------------
   boost/1.66                     phdf5/1.10.4   (D)
   fftw3/3.3.6                    pnetcdf/1.8.1
   parallel-netcdf/4.3.3.1        python2/2.7.16 (L,D)
   parallel-netcdf/4.6.2   (D)    python3/3.7.0  (D)
   phdf5/1.8.16

------------------------ /opt/apps/intel18/modulefiles -------------------------
   hdf5/1.8.16        mkl-dnn/0.18.1    netcdf/4.3.3.1        python3/3.7.0
   hdf5/1.10.4 (D)    nco/4.6.9         netcdf/4.6.2   (D)    udunits/2.2.25
   impi/18.0.2 (L)    ncview/2.1.7      python2/2.7.16

---------------------------- /opt/apps/modulefiles -----------------------------
   TACC          (L)      git/2.24.1       (L)      mcr/9.6
   autotools/1.2 (L)      hwloc/1.11.2              mcr/9.9                (D)
   cmake/3.8.2            idev/1.5.5                ncl_ncarg/6.3.0
   cmake/3.10.2           intel/16.0.3              nvhpc/21.3.0
   cmake/3.16.1  (L,D)    intel/17.0.4              ooops/1.3
   cuda/10.0     (g)      intel/18.0.2     (L,D)    sanitytool/2.0
   cuda/10.1     (g)      launcher_gpu/1.0          settarg
   cuda/11.0     (g)      lmod                      swr/18.3.3
   cuda/11.3     (g,D)    mathematica/12.0          tacc-singularity/3.7.2
   gcc/5.4.0              matlab/2018b              tacc_tips/0.5
   gcc/6.3.0              matlab/2019a              xalt/2.9.6             (L)
   gcc/7.1.0              matlab/2020b     (D)
   gcc/7.3.0     (D)      mcr/9.5

  Where:
   D:  Default Module
   L:  Module is loaded
   g:  built for GPU
```

At this time, with the limited size of the local disks on Maverick2, we are keeping the number of packages supported to a reduced size to accommodate the work done on this system that is not possible or practical on other TACC systems.

Users must provide their own license for commercial packages. TACC will work on a best effort level with any commercial vendors to support that software on the system, but make no guarantee that licences can migrate to our systems or can be supported within the support framework at TACC.

You are welcome to install packages in your own `$HOME` or `$WORK` directories. No super-user privileges are needed, simply use the `--prefix` option when configuring then making the package.

### Deep Learning Packages { #software-ml }

See: [Tensorflow at TACC](../../software/tensorflow)


See the [Remote Desktop Access at TACC][TACCREMOTEDESKTOPACCESS] tutorial to set up a VNC or DCV connection.

### Building Software { #software-building }

Like Stampede2, Maverick2's default programming environment is based on the Intel compiler and Intel MPI library.  For compiling MPI codes, the familiar commands `mpicc`, `mpicxx`, `mpif90` and `mpif77` are available. Also, the compilers `icc`, `icpc`, and `ifort` are directly accessible. To access the most recent versions of GCC, load the `gcc` module.

You're welcome to download third-party research software and install it in your own account. Consult the [Stampede2 User Guide](../stampede2) for detailed information on [building software](../stampede2#building).  

