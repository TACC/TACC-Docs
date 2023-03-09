# ANSYS at TACC
*Last update: March 8, 2022*

<table cellpadding="5" cellspacing="5"><tr>
<td><img alt="ANSYS logo" src="../../../imgs/software/ansys-logo.png"> </td>
<td>ANSYS offers a comprehensive software suite that spans the entire range of physics, providing access to virtually any field of engineering simulation that a design process requires. ANSYS sofware is used to simulate computer models of structures, electronics, or machine components for analyzing strength, toughness, elasticity, temperature distribution, electromagnetism, fluid flow, and other attributes.</td>
</tr></table>

ANSYS is currently installed on TACC's [Frontera](../../hpc/frontera), [Lonestar6](../../hpc/lonestar6) and [Stampede2](../../hpc/stampede2) resources. 

## [ANSYS Licenses](#licenses)

TACC's current ANSYS license allows TACC users to access ANSYS for **non-commercial**, **academic** use. If you would like access to ANSYS, [submit a help desk ticket](https://portal.tacc.utexas.edu/tacc-consulting/-/consult/tickets/create) through the [TACC User Portal](https://portal.tacc.utexas.edu/). Include in your ticket your institutional affiliation and a brief statement confirming that you will use ANSYS only for **non-commercial**, **academic** purposes. If you are affiliated with the University of Texas, include your academic department in your help desk ticket.

If you have your own ANSYS licenses or would like to install your own copy, you are allowed to do so.

## [ANSYS Installations](#installations)

ANSYS is currently installed under `/home1/apps/ANSYS` on TACC's Frontera and Stampede2, and `/scratch/tacc/apps/ANSYS` on TACC's Lonestar6 resources. Installations on Frontera and Stampede2 include the main components: Structures, Fluids, Electronics and LS-Dyna. However, installations on Lonestar6 only include Structures, Fluids and LS-Dyna. Electronics is not included since it is not supported on LS6’s operating system. All packages are installed under the default locations based on the ANSYS naming convention. Table 


### [Table 1. ANSYS Installations at TACC](#table1)

Resource | ANSYS Version |Components |Location
--- | --- | --- | ---
Frontera |2021R2 |Structures, Fluids, Electronics, LS-Dyna | <code>/home1/apps/ANSYS/2021R2/v212</code><br><code>/home1/apps/ANSYS/2021R2/AnsysEM21.2</code>
Stampede2 | 2021R2 | Structures, Fluids, Electronics, LS-Dyna | <code>/home1/apps/ANSYS/2021R2/v212</code><br><code>/home1/apps/ANSYS/2021R2/AnsysEM21.2</code>
Lonestar6 | 2022R1 | Structures, Fluids, LS-Dyna | <code>/scratch/tacc/apps/ANSYS/2022R1/v221</code>

## [Running ANSYS](#running)

### [Interactive Mode](#running-interactive)

ANSYS can be launched with the ANSYS GUI used in interactive mode. Use the [TACC Vis Portal](https://vis.tacc.utexas.edu/) or create a VNC session following the directions in the [Remote Desktop Access](https://portal.tacc.utexas.edu/user-guides/stampede2#vis-remote) section.

!!! caution
	Do NOT launch ANSYS, or any other codes, on the login nodes.

ANSYS is managed under [Lmod](https://lmod.readthedocs.io/en/latest/) Environmental Module System on TACC resources. Within the VNC session, load the ANSYS module with the following command:

``` cmd-line
$ module load ansys
```

You can always get the help information using the module's &quot;`help`&quot; command:

``` cmd-line
$ module help ansys
```

Launch the ANSYS GUI within the VNC session:

``` cmd-line
$ /home1/apps/ANSYS/2021R2/v212/ansys/bin/launcher212
```

<figure id="figure1">>
	<img alt="ANSYS1" src="../../../imgs/software/ansys-1.png"/>
	<figcaption>Figure 1. Commands to run Ansys Mechanical Ansys Parametric Design Language (APDL) jobs </figcaption></figure>


### [Batch Mode](#running-batch) { #running-batch }

You can also submit your ANSYS job to the batch nodes (compute nodes) on TACC resources. To do so, first make sure that the ANSYS module has been loaded, and then launch your ANSYS programs as shown in the sample Frontera job script below.

``` job-script
#!/bin/bash
#SBATCH -J ansysjob              # job name
#SBATCH -e ansysjob.%j.err       # error file name 
#SBATCH -o ansysjob.%j.out       # output file name 
#SBATCH -N 1                     # request 1 node
#SBATCH -n 56                    # request 56 cores 
#SBATCH -t 01:00:00              # designate max run time 
#SBATCH -A myproject             # charge job to myproject 
#SBATCH -p normal                # designate queue 

module load ansys
# Your-ANSYS-COMMAND-HERE
# Define your working directory
MY_JOB_DIR = /scratch1/01234/joe/Ansys_test

# Run ANSYS Job
"/home1/apps/ANSYS/v201/ansys/bin/mapdl" \
		-p ansys -dis -mpi INTELMPI -np 56 -lch    \
		-dir "$MY_JOB_DIR" \
		-j "Ansys_test" -s read -l en-us -b \
		&lt; "$MY_JOB_DIR/Ansys_test_input.txt" &gt; "$MY_JOB_DIR/Ansys_test_output.out"
```

To obtain the correct <span style="color:blue;font-style:bold">`Your-ANSYS-COMMAND-HERE`</span>, launch the ANSYS GUI used in interactive mode. Here, we use the ANSYS Mechanical APDL as an example. After entering the correct *Working directory*, *Job Name*, *Input File*, *Output File*, and *Number of Processors*, you can click Tools and then Display Command Line to get the complete command to run ANSYS jobs in batch mode. No `ibrun` or `mpirun` command is needed for running ANSYS jobs.

Other ANSYS binaries, e.g. Aqwa, CFX, Fluent, can be found at `/home1/apps/ANSYS/2021R2/v212`. 
	
#### [Table 2. ANSYS Binaries Location](#table2) { #table2 }

<table border="1" cellpadding="5" cellspacing="3">
	<tr>
		<th align="right"> Aqwa: 
		<td><code> /home1/apps/ANSYS/2021R2/v212/aqwa/bin/linx64</code>
	<tr>
		<th align="right"> Autodyn: 
		<td><code> /home1/apps/ANSYS/2021R2/v212/autodyn/bin</code>
	<tr>
		<th align="right"> CFX: 
		<td><code> /home1/apps/ANSYS/2021R2/v212/CFX/bin</code>
	<tr>
		<th align="right"> Electronics: 
		<td><code> /home1/apps/ANSYS/2021R2/v212/Electronics/Linux64</code>
	<tr>
		<th align="right"> Fluent: 
		<td><code> /home1/apps/ANSYS/2021R2/v212/fluent/bin</code>
	<tr>
		<th align="right"> Icepak: 
		<td><code> /home1/apps/ANSYS/2021R2/v212/Icepak/bin</code>
	<tr>
		<th align="right"> LS-Dyna: 
		<td><code> /home1/apps/ANSYS/2021R2/v212/ansys/bin</code>
</tr></table>


			
In the figure below, the small window on top displays the command to run an ANSYS Mechanical job through the command line, which corresponds to the information (i.e., Working directory, Job Name, Input File, Output File) entered on the bottom.

<figure id="figure2">> <img alt="ANSYS2" src="../../../imgs/software/ansys-2.png">
	<figcaption> Figure 2. Ansys Mechanical Ansys Parametric Design Language (APDL) Product Launcher </figcaption></figure>
		

Submit the job to the Slurm scheduler in the standard way. Consult each resource's "Running Jobs" section in the respective user guide.

#### [Table 3. User Guides - Running Jobs](#table3)  { #table3 }

Frontera | Stampede2 | Lonestar6
--- | --- | ---
<code>login1$ <b>sbatch myjobscript</b></code> | <code>login1$ <b>sbatch myjobscript</b><code> | <code>login1$ <b>sbatch myjobscript</b><code>
<a href="https://fronteraweb.tacc.utexas.edu/user-guide/running/">Running Jobs on Frontera</a> | <a href="https://portal.tacc.utexas.edu/user-guides/stampede2#running">Running Jobs on Stampede2</a> | <a href="https://portal.tacc.utexas.edu/user-guides/lonestar6#running">Running Jobs on Lonestar6</a>

## [References](#refs)

* [Remote Desktop Access at TACC][TACCREMOTEDESKTOPACCESS]
* ANSYS is a commercial package. If you have further scientific or technical questions, <a href="https://support.ansys.com/portal/site/AnsysCustomerPortal">contact ANSYS support</a> directly.

{% include 'aliases.md' %}
