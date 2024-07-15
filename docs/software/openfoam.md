# OpenFOAM at TACC
*Last update: April 14, 2020*

<img alt="OpenFOAM logo" src="../imgs/openfoam-logo.png" style="width: 75px;" />
The <a href="https://www.openfoam.org">OpenFOAM</a> (**O**pen **F**ield **O**peration and **M**anipulation) Toolbox is a free, open source Computational Fluid Dynamics (CFD) software package providing an extensive range of features, from solving complex fluid flows involving chemical reactions, turbulence and heat transfer, to solid dynamics and electromagnetics.


## Running on Frontera and Stampede2 { #running }

TACC staff has built and installed OpenFOAM 7.0 on both [Stampede2](../../hpc/stampede2) and [Frontera](../../hpc/frontera) compute resources. The Stampede2 executable is built with intel/18.0.2 and impi/18.0.2, while the Frontera executable is built with intel/19.0.5 and impi/19.0.5. Follow the steps below to set up the environment and run an OpenFOAM tutorial example.

### Set Up Computing Environment { #running-compenv }

Set up the proper computing environment by loading the latest OpenFoam module:

``` cmd-line
login1$ module load openfoam/7.0
```

OpenFOAM places its [cases](https://cfd.direct/openfoam/user-guide/cases/) in the directory defined by the `$FOAM_RUN` environment variable.  TACC staff suggests using your `$SCRATCH` file space to run OpenFOAM cases.  The following commands set this environment variable and create the `$FOAM_RUN` directory in the user's `$SCRATCH` directory.

``` cmd-line
login1$ export FOAM_RUN=$SCRATCH/My_OpenFOAM/7.0/run
login1$ mkdir -p $FOAM_RUN
```

## Run Tutorials { #tutorials }

**Do NOT run the following commands on the login nodes.**
You may either [submit a batch job](../../hpc/stampede2#running), or start an interactive session using TACC's [`idev`](../../software/idev) utility.

The following demonstrates running the OpenFOAM's [Lid-driven Cavity Flow](https://cfd.direct/openfoam/user-guide/v7-cavity/#x5-40002.1) test case involving isothermal, incompressible flow in a two-dimensional square domain.

* Copy OpenFOAM's tutorials into the OpenFOAM work directory created above, then change to the cavity case directory:

	``` cmd-line
	login1$ idev
	...
	c557-804$ cp -r $FOAM_TUTORIALS $FOAM_RUN 
	c557-804$ cd $FOAM_RUN/tutorials/incompressible/icoFoam/cavity/cavity
	```

* Use the pre-processing tool, **`blockMesh`**, to generate the mesh.  Then run the **`icoFoam`** solver.  

	``` cmd-line
	c557-804$ blockMesh
	c557-804$ icoFoam
	c557-804$ exit
	login1$
	```

## References { #refs }

* [OpenFOAM user guide](https://www.openfoam.org/resources/)
* [Working with Modules][TACCLMOD]
* [OpenFOAM and ParaView](https://cfd.direct/openfoam/features/)


{% include 'aliases.md' %}
