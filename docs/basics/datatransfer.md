# Data Transfer

TACC supports two primary data transfer technologies: **SSH-based tools** (SCP, SFTP, rsync) and **Globus** (formerly GridFTP). All TACC systems support SSH-based transfers, and most large TACC systems also support Globus. Globus uses its own authentication system and will require additional setup steps.


Note that SSH-based transfers perform poorly on **high-latency network paths**. For large data transfers (e.g. > 200 GB) over paths with round-trip times (RTT) greater than ~10 ms (e.g. outside Texas), Globus is strongly recommended. In these environments, Globus is often **orders of magnitude faster** than `scp`, frequently achieving **100× or greater throughput improvements**.  

Globus also provides **end-to-end file-level checksum verification by default**, which is critical for ensuring data integrity during large transfers. SSH-based tools report transfer success based on transport-layer completion but **do not verify file content equivalence** at the source and destination. Unlike Globus, `scp` lacks built-in checksum verification and robust resume capabilities, making it unsuitable for validating large or irreplaceable datasets without manual checksum comparison (e.g., MD5 or SHA-256).

File-level checksums act as a digital fingerprint of file content. Comparing checksums before and after transfer ensures that data arrives intact and protects against silent data corruption introduced during disk I/O, staging, or wide-area network transfer.


## Smaller Datasets (SSH-based tools)

For smaller data sets, SSH-based tools are likely easier to work with. 
See the [TACC SSH-based Tools Guide](datatransfer_ssh.md). 

## Larger Datasets (Globus)

We recommend Globus when:

- Transferring **large datasets (>200 GB)**  
- Moving **many thousands of files**
- Transfers may take **hours**
- You need **automatic restart** after network interruptions
- You want **parallel, optimized transfers** without manual tuning

See the [TACC Globus Guide](datatransfer_globus.md). 

## Performance Expectations

If you want to compare your data transfer performance to others, you can use the [TACC NetSage Portal](https://tacc.netsage.io/). For example [this page](https://tacc.netsage.io/grafana/d/-l3_u8nWl/1b22d62) shows transfer rates for Globus jobs between TACC and the rest of the world. In general, you should be able to get at least 1 Gbps transfer speeds.

