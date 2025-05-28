# OpenFOAM at TACC
*Last update: January 27, 2025*

<!-- ![OpenFOAM logo](../imgs/openfoam-logo.png){ .align-left width="75px" } -->
<img src="../imgs/openfoam-logo.png" width="300" alt="OpenFOAM logo" class="align-right">

The [OpenFOAM](https://www.openfoam.org) (**O**pen **F**ield **O**peration and **M**anipulation) Toolbox is a free, open source Computational Fluid Dynamics (CFD) software package providing an extensive range of features, from solving complex fluid flows involving chemical reactions, turbulence and heat transfer, to solid dynamics and electromagnetics.

OpenFOAM has two distributions and respective naming conventions: 

* **OPENFOAM**&reg; (<a href="http://www.openfoam.com">www.openfoam.com</a>) is a registered trade mark of OpenCFD Limited, producer and distributor of the OpenFOAM software via www.openfoam.com.

	* OpenCFD is part of the ESI group, which is why it is usually referred to ESI-OpenCFD.
	* ESI-OpenCFD uses the numbering convention "vYYMM", for example: "v1706", which stands for having been released in June (6th month) of 2017.

* **The OpenFOAM Foundation** (<a href="http://www.openfoam.org">www.openfoam.org</a>) was originally founded by OpenCFD and SGI in 2011, when SGI acquired OpenCFD. 

	* This Foundation has permission to use the OPENFOAM&reg; trade mark.
	* The OpenFOAM Foundation uses the numbering convention "I.J", for example: 4.0, 4.1 and 5.0.

Both distributions are actively developed, and each provide advantages depending on specific features or solvers required. See [OpenFOAM.com versus OpenFOAM.org: Which version to use?](https://www.cfd-online.com/Forums/openfoam/197150-openfoam-com-versus-openfoam-org-version-use.html) for additional information. 


## Environment Setup

Both distributions of OpenFOAM are available on TACC systems. Refer to the table below to load your desired version.

System      | Version             | Load with:
    --      | --                  | --
Frontera    | OpenFOAM 9          | `module load openfoam/9.0`
            | OpenFOAM v2012      | `module load openfoam/v2012`
Stampede3   | OpenFOAM 12         | `module load openfoam/12`
            | OpenFOAM v2312      | `module load openfoam/v2312`
Lonestar6   | OpenFOAM 12         | `module load intel/24.1 impi/21.12 openfoam/12`
            | OpenFOAM v2406      | `module load intel/24.1 impi/21.12 openfoam/v2406`
Vista       | OpenFOAM 12         | `module load gcc/14.2.0 openfoam/12`


OpenFOAM places its [cases](https://doc.cfd.direct/openfoam/user-guide-v12/cases) in the directory defined by the `$FOAM_RUN` environment variable. TACC staff recommends using your `$SCRATCH` file space to run OpenFOAM cases. The following commands set this environment variable and create the `$FOAM_RUN` directory in the user's `$SCRATCH` directory.

```cmd-line
login1$ export FOAM_RUN=$SCRATCH/My_OpenFOAM/12/run
login1$ mkdir -p $FOAM_RUN
```

## Run Tutorials

!!!important
	Do NOT run the following commands on any resource's login nodes. You may either submit a batch job, or start an interactive session using TACC's [`idev`][TACCIDEV]  utility.

The following demonstrates running the OpenFOAM's <a href="https://cfd.direct/openfoam/user-guide/v7-cavity/%23x5-40002.1">Lid-driven Cavity Flow</a> test case involving isothermal, incompressible flow in a two-dimensional square domain.

Within an `idev` session, copy OpenFOAM's tutorials into the OpenFOAM work directory created above:

Version        | Command
     --        | --
OpenFOAM 12    | `cp -r $FOAM_TUTORIALS/incompressibleFluid/cavity .`
OpenFOAM v2312 | `cp -r $FOAM_TUTORIALS/incompressible/icoFoam/cavity/cavity .`

Change to the cavity case directory, then invoke the pre-processing tool, `blockMesh`, to generate the mesh. Then run the `icoFoam` solver.

```cmd-line
c557-804$ cd cavity
c557-804$ blockMesh
c557-804$ icoFoam
c557-804$ exit
login1$
```

## References

* [OpenFOAM v12 User Guide](https://doc.cfd.direct/openfoam/user-guide-v12/)

{% include 'aliases.md' %}
