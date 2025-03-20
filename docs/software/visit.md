# VisIt at TACC
*Last update: August 12, 2024*

Parallel VisIt is an Open Source, interactive, scalable, visualization, animation and analysis tool. Users can quickly generate visualizations, animate them through time, manipulate them with a variety of operators and mathematical expressions, and save the resulting images and animations for presentations. VisIt contains a rich set of visualization features to enable users to view a wide variety of data including scalar and vector fields defined on two- and three-dimensional (2D and 3D) structured, adaptive and unstructured meshes. Owing to its customizable plugin design, VisIt is capable of visualizing data from over 120 different scientific data formats.

## Installations { #installations }

VisIt is installed on TACC's Frontera, Stampede3, and Lonestar6 resources. The environment required to run VisIt on each of these resources is slightly different. Use the `module` command to load the required environment for VisIt. 

### Table 1. VisIt Modules per TACC Resource { #table1 }
Resource  | Versions Installed       | Module requirements
--        | --                       | --
Frontera  | 2.13.2, 3.0.1, 3.1.2**   | `intel/19`, `impi`, `swr`&#42;, `qt5`&#42;&#42;, `VisIt`
Stampede3 | 3.4.1**                  | `intel/24` `impi/21.11` 
Lonestar6 | 3.3.0**                  | `gcc`, `impi`, `VisIt`

&#42; Environment managed by VisIt module  
&#42;&#42; Default VisIt version on resource

[Table 1.](#table1) above summarizes the version of VisIt installed and the modules required to run it on each TACC resource. All the modules listed for a particular resource must be loaded for VisIt to run correctly. The VisIt module itself manages loading and unloading of certain dependencies on certain resources. 

Starting the VisIt user interface on TACC resources is very similar to starting [Paraview][TACCPARAVIEW]. Follow the procedure for starting a remote desktop described in the Paraview documentation.

Once a remote desktop is running, start the VisIt user-interface by typing commands into a shell window on that desktop. The commands required are summarized in [Table 2.](#table2)  below. The column labeled "Load Modules" contains commands required to load the environment on the particular resource. The column labeled "Run VisIt" contains the command required to launch VisIt's user-interface. In both columns the text `c442-001$` is simply an example of the command prompt in the shell window. 

### Table 2. Running VisIt { #table2 }

Resource       | Load Modules    | Run VisIt
--             | --              | --
Frontera       | `c442-001$ module load intel`<br>`c442-001$ module load impi`<br>`c442-001$ module load visit` | `c442-001$ swr -p 1 visit`
Lonestar6      | `c442-001$ module load gcc`<br>`c442-001$ module load impi`<br>`c442-001$ module load visit`   | `c442-001$ visit`
Stampede3      | `c442-001$ module load intel`<br>`c442-001$ module load impi`<br>`c442-001$ module load visit` | `c442-001$ visit`

Consider starting VisIt on Stampede3 as an example. Load the `intel`, `impi`, and `visit` modules as indicated by the commands above. Then, type the appropriate `visit` command at the command prompt.  The user interface should appear on the desktop.


## Notes { notes }

The following notes are related to specifics of using VisIt on TACC resources. 

* The `module load ...` command will load the most recent version of a module if no version number is specified. 
* Loading the compiler family (intel, gcc) will modify the currently loaded mpi family as necessary. 
* Launching VisIt on Frontera requires the use of the swr prepend. The argument `-p n` specifies the number of mpi tasks (n=1 in this case) per node that VisIt will use. This flag is used by the software renderer to determine the number of threads used by the swr software renderer. The number of rendering cores = cores per node / n. 
* The total number of mpi ranks used by VisIt is determined by the characteristics of the resource requested when the remote desktop was started. VisIt will start a parallel engine consisting of `n` total MPI ranks distributed across `N` nodes where the values of `N` and `n` correspond to the number of nodes and processes requested by the remote desktop startup procedure. 
* The parallel analysis engine is launched after the user selects a plot type and presses the draw button. At that time VisIt will present the user with a dialog with controls to select either a parallel or serial engine. Parallel is default. There are also controls in that dialog to select the number of nodes and processes. These values have no effect. Changing the number of nodes in the dialog will not change the number of nodes in the analysis due to the fact that the resource is allocated during startup of the remote desktop. 
* VisIt can be used in batch mode via a Python interpreter. See the scripting section of the VisIt User Guide for more information. 


## Preparing Data for Parallel Visit { visit-parallel} 

VisIt reads nearly [150 data formats](https://github.com/visit-dav/visit/tree/develop/src/databases). Except in some limited circumstances (particle or rectilinear meshes in ADIOS, basic netCDF, Pixie, OpenPMD and a few other formats), VisIt piggy-backs its parallel processing off of whatever static parallel decomposition is used by the data producer. This means that VisIt expects the data to be explicitly partitioned into independent subsets (typically distributed over multiple files) at the time of input. Additionally, VisIt supports a metadata file (with a .visit extension) that lists multiple data files of any supported format that hold subsets of a larger logical dataset. VisIt also supports a "brick of values (bov)" format which supports a simple specification for the static decomposition to use to load data defined on rectilinear meshes. For more information on importing data into VisIt, see [Getting Data Into VisIt](https://visit-dav.github.io/visit-website/pdfs/GettingDataIntoVisIt2.0.0.pdf?#page=97).


## References { #refs }

* [VisIt User Manual](https://visit-sphinx-github-user-manual.readthedocs.io/en/develop/)
* [VisIt Web Site](https://visit-dav.github.io/visit-website/)
* [The VisIt Github Page](https://visit-dav.github.io/visit-website/index.html)
* [Getting Data Into VisIt](https://visit-dav.github.io/visit-website/pdfs/GettingDataIntoVisIt2.0.0.pdf?#page=1)


{% include 'aliases.md' %}
