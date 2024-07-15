## Containers { #containers }

Frontera provides seamless, integrated support for the use of Singularity containers (both custom containers made by users and containers from standard repositories). The use of containers greatly enhances the number of people who contribute to the Frontera software base, promotes portability with other resources, and greatly expands the supported software catalog beyond that found on TACC's other HPC systems.

Frontera supports application containers from any specification-compliant science community (e.g. Biocontainers, with over 3,000 containers and counting, and the Nvidia GPU Cloud Library), opening this important resource for a wide range of new applications and new science communities. To make the experience seamless, our implementation injects mount points and environment variables into the container to match the HPC system environment – the `$SCRATCH`, `$WORK`, and `$HOME` file systems all are identical to what users see natively on any Frontera node. 

See the [Containers @ TACC Workshop](https://containers-at-tacc.readthedocs.io/en/latest/index.html) documentation for more information.
