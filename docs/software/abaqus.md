# ABAQUS at TACC
*Last update: November 2, 2021*


<table cellpadding="5" cellspacing="5">
<tr><td><img alt="ABAQUS logo" src="../imgs/abaqus-logo.png"></td>
<td valign="middle">The ABAQUS software suite from Dassault Systems is used for finite element analysis and computer-aided engineering.  The ABAQUS software is used on TACC resources for projects from a variety of domains, such as petroleum engineering, biomedical engineering, and aerospace engineering. </td>
</tr></table>

## Request Access { #access }

TACC's ABAQUS license agreement allows access to the software installation and license tokens only to UT Austin students and staff. 

* **UT Austin users**  will need to [submit a ticket][HELPDESK] requesting to be added to the "ABAQUS" group. Potential ABAQUS users must agree to use ABAQUS for purely academic purposes. 

* **Non-UT Austin users** are welcome to install ABAQUS in their own accounts on TACC systems using their local license server.

For all ABAQUS technical questions, contact the customer care for Dassault Systems through a support ticket.

### License Tokens { #access-license }

**TACC has a limited number of ABAQUS license tokens available.** Please submit a support ticket requesting the license server name.  In this document we'll refer to the license server as `port-number@license-server`. In order to use this license server, the ABAQUS users should add the following line to their job script: 

``` cmd-line
$ export ABAQUSLM_LICENSE_FILE=port-number@license-server
```

Setting this environment variable on the login node before submitting the job will also work.

Users can also set the information about the license server by setting the value of `abaquslm_license_file` in the `abaqus_v6.env` file. For example: 

``` syntax
abaquslm_license_file="port-number@license-server"
```

!!! tip
	You can estimate your token needs here: <https://www.simuleon.com/abaqus-token-calculator/>

Since the number of ABAQUS licenses are linited, we encourage you to bring your own license tokens (from your local license server) if you have the option to do so.  If using your own license, you may need to work with the license server's administrator to open the appropriate firewalls for accepting connections from TACC resources. The license server administrator will need the [IP addresses range](#ips) of the TACC systems (Stampede2 or Frontera).  Users will then use the port number and hostname of their license server to set the values of `ABAQUSLM_LICENSE_FILE` in either their job script or the value of `abaquslm_license_file` in the `abaqus_v6.env`.

## Installations { #installations }

The ABAQUS 2019 and 2020 executables are available using the TACC's module system. After users are granted access to ABAQUS, they will be able to load the abaqus module.

``` cmd-line
login1$ module load abaqus
```

## Running ABAQUS { #running }

1. Familiarize yourself with the Stampede2 and/or Frontera user guide sections on "Running Applications".

	* [Stampede2 - Running Jobs](../../hpc/stampede2#running)
	* [Frontera - Running Jobs](../../hpc/frontera#running)

	As with all other software packages, do not run ABAQUS on the login nodes. All ABAQUS invocations must occur within an `idev` session or submitted to the compute nodes as a batch job using the [job script](#jobscript) below.


### Interactively { #running-interactive }

On a compute node obtained through an `idev` session, the users can run the following command to test their access to ABAQUS and also check the available number of license tokens:

``` cmd-line
c123-456$ ml abaqus 
c123-456$ $TACC_ABAQUS_BIN/abaqus licensing lmstat -a &gt; abaqus_license.txt
```

### Batch Mode { #running-batch }

1. ABAQUS jobs will continue polling for licensing tokens till the required number of tokens become available or the jobs time-out of the queue. In order to save SUs in the event the necessary tokens are not available, include the following line in the ABAQUS environment file. This will limit the ABAQUS waiting time to five minutes. 

	lmhanglimit=5

1. To run a test job, run the following commands on a compute node after replacing `myinputfile` with the actual name of your input file:

	``` cmd-line
	$ unset SLURM_GTIDS
	$ ml abaqus
	$ $TACC_ABAQUS_BIN/abaqus input=myinputfile job=test interactive
	```

	This command will block until completion or give an error. Check the log file (`jobname.log`). If no error, it should say the job checked out licenses and completed successfully.

1. Compile user modules on the login nodes:

	``` cmd-line
	login1$ $TACC_ABAQUS_BIN/abaqus make library=<sourcefile>
	```

1. Place resulting files (`sourcefile-basename.o`, `sourcefile-basename.so`) into a directory: `/path-to-the-directory/abaqus_libs`

1.	In the ABAQUS environment file, add the following line.  In a normal use-case the `usub_lib_dir` will be in your scratch, work or home directory. 

		usub_lib_dir="/path-to-the-directory/abaqus_libs"

1. In order to debug the ABAQUS errors, users might find it useful to run the ABAQUS commands with the `verbose` option. Set verbose to "3" to retrieve all run details:

	``` cmd-line
	c123-456$ $TACC_ABAQUS_BIN/abaqus cpus=1 input=myinputfile job=test2 \
		interactive scratch="." verbose=3
	```

## Job Script { #jobscript }

The following job script demonstrates an example of running ABAQUS in parallel, on one node, and can be run on the Stampede2 and Frontera systems after adjusting the number of nodes and cores, the values of `-N` and, `-n` respectively.  This script is also located in `$TACC_ABAQUS_DIR/tacc_test/abaqus.slm`.

``` job-script
#!/bin/bash
#SBATCH -J myabaqusjob
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -o abaqus.o%j
#SBATCH -p normal

ml abaqus/2020
# ml abaqus/2019

# Set this to the correct environment file
# for the test we will use some reasonable defaults
cp $TACC_ABAQUS_DIR/tacc_test/abaqus_v6.env ./
abaqus_environment_file=abaqus_v6.env

# Figure out what nodes this job should run on
node_list=$(scontrol show hostname $cores_per_node | sort | uniq)

# This assumes that there will be an even number of tasks across
# each node, if you have configured your job to run with different
# numbers of tasks on each node, you will need to change the task
# calculations below and create a modified mp_host_list.
cores_per_node=$(echo $SLURM_TASKS_PER_NODE | grep -oP '^[^0-9]*\K[0-9]+')

# Make node list and count the number of nodes
core_count=0
mp_host_list="["

for i in ${node_list} ; do
	mp_host_list="${mp_host_list}['$i', ${cores_per_node}],"
	number_of_nodes=$((number_of_nodes + 1))
done

echo $mp_host_list

# Calculate the amount of cores per node and multiply it by the amount
# of nodes we are running on
core_count=$(($number_of_nodes*$cores_per_node))
echo "Running on nodes: $cores_per_node"
echo "Running on $cores_per_node cores per node for a total of $core_count processes"

mp_host_list=`echo ${mp_host_list} | sed -e "s/,$//"`
mp_host_list="${mp_host_list}]"

echo "mp_host_list=${mp_host_list}" >> $abaqus_environment_file

unset SLURM_GTIDS

# Copy test input files to scratch directory
cp $TACC_ABAQUS_DIR/tacc_test/knee_bolster* ./

$TACC_ABAQUS_BIN/abaqus job=test_abaqus_job cpus=$core_count \
	input=./knee_bolster.inp -verbose 3 mp_mode=mpi \
	standard_parallel=all interactive scratch="."

sed -i "/mp_host_list/d" $abaqus_environment_file
```

## TACC Resources IP Address Ranges { #ips }

<table border='1' cellpadding="5">
<tr>
<th>System</th>
<th>Compute Nodes</th>
<th>Login Nodes</th>
</tr>
<td>Frontera</code></td>
<td valign="top"><code>129.114.64.0/19<br>129.114.44.0/22</code></td>
<td valign="top"><code>129.114.63.96/27</code></td>
</tr>
<tr>
<td>Stampede2</td>
<td valign="top"><code>206.76.192.0/19</code></td>
<td valign="top"><code>129.114.63.32/27</code></td>
</tr>
<tr>
</table>

## References { #refs }

* <a href="https://www.3ds.com/products-services/simulia/products/abaqus/abaquscae/">Dassault Systemes: Abaqus</a>

{% include 'aliases.md' %}
