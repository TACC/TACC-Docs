# Data Transfer

TACC supports two primary data transfer technologies: **SSH-based tools** (SCP, SFTP, rsync) and **Globus** (formerly GridFTP). All TACC systems support SSH-based transfers, and most large TACC systems also support Globus. Globus uses its own authentication system and will require additional setup steps.  When in doubt, we recommend that you start with SSH-based transfer as this requires the least setup and utilizes the TACC authentication system. Globus uses its own authentication system and will require additional setup steps, [outlined below](#globus).

There are many SSH-compatible clients across all platforms, and almost any modern SSH client will successfully interoperate with TACC systems. While we provide [examples using the Cyberduck application](#cyberduck), users are encouraged to select and utilize whichever transfer client is most familiar to them and most functional on your platform. Many SSH clients are organized to assist with specific workflows.

For SSH-based transfers, you will need two pieces of information in addition to your TACC username/password combination: the HOSTNAME of the system you are transferring to, and the PATH that you are attempting to access. Especially if you are uploading data, it is very important that you select the correct path for the resource and project - otherwise your data will be at risk of being lost or misplaced. The path may include a functional name such as /scratch/ or a resource name such as /corral/ .

<!-- Note that SSH-based transfers perform poorly on **high-latency network paths**. For large data transfers (e.g. > 200 GB) over paths with round-trip times (RTT) greater than ~10 ms (e.g. outside Texas), Globus is strongly recommended. In these environments, Globus is often **orders of magnitude faster** than `scp`, frequently achieving **100× or greater throughput improvements**.  -->

Globus-based transfers usually utilize an endpoint name (usually the name of the HPC or Storage resource you are connecting to) rather than a hostname, but you will still need to know the endpoint name, and you will always need the PATH that you are addressing, in order to successfully transfer data.

All TACC resources support SSH-based transfer, and most TACC resources support Globus-based transfer.

<!-- Globus also provides **end-to-end file-level checksum verification by default**, which is critical for ensuring data integrity during large transfers. SSH-based tools report transfer success based on transport-layer completion but **do not verify file content equivalence** at the source and destination. Unlike Globus, `scp` lacks built-in checksum verification and robust resume capabilities, making it unsuitable for validating large or irreplaceable datasets without manual checksum comparison (e.g., MD5 or SHA-256). -->

<!-- File-level checksums act as a digital fingerprint of file content. Comparing checksums before and after transfer ensures that data arrives intact and protects against silent data corruption introduced during disk I/O, staging, or wide-area network transfer. -->

As a broad generalization we'll define "small" data sets as less than 200GB and "large" datasets as greater than 200GB.

## Smaller Datasets (SSH-based tools)

For smaller data sets, SSH-based tools are likely easier to work with.  See the [TACC SSH-based Tools Guide](datatransfer_ssh.md). 

## Larger Datasets (Globus)

We recommend Globus when transferring or moving datasets larger than 200GB.:

<!-- 
- Transferring **large datasets (>200 GB)**  
- Moving **many thousands of files**
- Transfers may take **hours**
- You need **automatic restart** after network interruptions
- You want **parallel, optimized transfers** without manual tuning
-->

See the [TACC Globus Guide](datatransfer_globus.md). 

<!-- ## Performance Expectations

If you want to compare your data transfer performance to others, you can use the [TACC NetSage Portal](https://tacc.netsage.io/). For example [this page](https://tacc.netsage.io/grafana/d/-l3_u8nWl/1b22d62) shows transfer rates for Globus jobs between TACC and the rest of the world. In general, you should be able to get at least 1 Gbps transfer speeds.
-->

