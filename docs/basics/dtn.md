## TACC Test DTN (Data Transfer Node)

TACC provides publicly accessible **test Data Transfer Node (DTN)** for high-speed disk-to-disk performance testing. This hosts is intended for users on research and education (R&amp;E) networks worldwide, and support anonymous GridFTP access. This test DTN serves as a reference implementation of a <a href="https://fasterdata.es.net/DTN/">Science DMZ DTN</a>. 

The purpose of this host is to help system administrators at remote sites verify that their DTNs are properly tuned for high-performance data transfers to and from TACC, and to give TACC users a realistic expectation of achievable transfer performance.

### Running tests to TACC Test DTN

The TACC test 100G DTN is available in the <a href="https://app.globus.org/">Globus File Manager</a> as **TACC DME**. (DME = Data Mobility Exhibition). 

### This DTN features:

* Sustained 3.3 **Gb/s** from a single filesystem namespace
	* This result is sending data from TACC DME node to ESnet test DTN in Washington DC using the "50GB-in-medium-files" data set
	* A faster disk subsystem is on order. Hoping for 5-10 Gbps soon. 
	* Note that disk to disk testing results can vary by 2-3x per run, depending one caching, contention, etc. It's best to do multiple test runs. 
* Provides a variety of **test files and directory structures**

## Test Datasets

The following single-file test data (generated from `/dev/urandom`) are available:

	/storage/1M.dat
	/storage/10M.dat
	/storage/50M.dat
	/storage/100M.dat
	/storage/1G.dat
	/storage/10G.dat
	/storage/50G.dat
	/storage/100G.dat
	/storage/500G.dat (coming soon)

### Multi-file Test Data Sets

Several directory-based data sets are provided to evaluate multi-file transfer performance and metadata overhead.

Each data set uses an identical directory structure:

* Directories `a` through `y`
* Nested two levels deep (`a/a` … `y/y`)
* Leaf directories contain data files named by their path (e.g., `a-a-1M.dat`)

This design allows users to measure the relative impact of:

* File and directory creation (metadata performance)
* Data transfer time as file size increases

Available data sets:

* `/storage/5MB-in-tiny-files`<br>
1 KB, 2 KB, and 5 KB files per leaf directory
* `/storage/5GB-in-small-files`<br>
1 MB, 2 MB, and 5 MB files per leaf directory
* `/storage/50GB-in-medium-files`<br>
10 MB, 20 MB, and 50 MB files per leaf directory
* `/storage/500GB-in-large-files`<br>
100 MB, 200 MB, and 500 MB files per leaf directory <em>(coming soon)</em>


## Host Tuning

For optimal wide-area TCP performance, ensure your system is properly tuned:

* TCP buffer sizes must be sufficient for your network path
* Refer to the Fasterdata <a href="https://fasterdata.es.net/host-tuning/">Host Tuning</a> section for recommended settings


## Firewall Considerations

Sites with firewalls must allow **GridFTP ports**:

* TCP 443
* TCP 50000–51000

See the <a href="https://docs.globus.org/globus-connect-server/v5/#open-tcp-ports_section"> Globus firewall documentation</a> for additional details.
      

