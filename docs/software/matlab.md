# MATLAB at TACC
*Last update: August 29, 2023* 

<table cellpadding="5" cellspacing="5"><tr>
<td><img src="../imgs/matlab-logo.png" style="width:50%"></td>
<td></td>
</tr></table>

[Mathwork's](https://www.mathworks.com/) MATLAB is installed and supported at TACC and is available on the following TACC resources: [Frontera](../../hpc/frontera), [Stampede2](../../hpc/stampede2) and [Lonestar6](../../hpc/lonestar6).  

## [Licenses](#license) { #license }

MathWork's agreement with the University of Texas now allows TACC users to access MATLAB for **non-commercial**, **academic** use. If you would like access to MATLAB [submit a help desk ticket][HELPDESK].  Include in your ticket your institutional affiliation and a brief statement confirming that you will use MATLAB only for **non-commercial**, **academic** purposes. If you are affiliated with the University of Texas, include your academic department in your help desk ticket.

If you have your own network licenses for toolboxes that are not available through the University of Texas, we can help you configure these licenses on TACC systems. Again, submit a help desk ticket for assistance.

## [Interactive Mode](#interactive) { #interactive }

MATLAB is normally launched with the MATLAB Desktop UI and used in interactive mode. Create a VNC session following the directions in the [Remote Desktop Access][TACCREMOTEDESKTOPACCESS] section.  


MATLAB is managed under the modules system on the TACC resources. Before you launch MATLAB load the MATLAB module with the following command:

``` cmd-line
login1$ module load matlab
```

You can always get the MATLAB help information by typing the following module help command.

``` cmd-line
login1$ module help matlab
```

The following figure shows how MATLAB is launched inside the VNC session.

### [Figure 1. MATLAB launched in a VNC session](#figure1) { #figure1 }

<figure id="figure1"> <img alt="MATLAB-1" src="../imgs/MATLAB-1.png"><figcaption></figcaption></figure>

!!! important
	Do NOT launch MATLAB on the login nodes. This may fail and, more importantly, it will prevent other users from doing their work, as your execution will take up too many cycles on the shared login node. Using MATLAB on the login nodes is considered system abuse, and will be treated as such.  See TACC [usage policies][TACCUSAGEPOLICY].

## [Batch Mode](#batch) { #batch }

You can also submit your MATLAB job to the batch nodes (compute nodes) on the TACC resources, e.g. Frontera, Stampede2, or Lonestar6. To do so, first make sure that the MATLAB module has been loaded, and then launch `matlab` with the `-nodesktop -nodisplay -nosplash` option as shown in the sample Stampede2 job script below.

### [Example 1. Sample MATLAB job script to run on Stampede2](#example1)

``` job-script
#!/bin/bash
#SBATCH -J matlabjob              # job name
#SBATCH -e matlabjob.%j.err       # error file name 
#SBATCH -o matlabjob.%j.out       # output file name 
#SBATCH -N 1                      # request 1 node
#SBATCH -n 16                     # request all 16 cores 
#SBATCH -t 01:00:00               # designate max run time 
#SBATCH -A myproject              # charge job to myproject 
#SBATCH -p skx-normal             # designate queue 

module load matlab
matlab -nodesktop -nodisplay -nosplash &lt; mymatlabprog.m
```

Then submit the job to the scheduler in the standard way. See the Running Jobs section in the respective user guides

Resource | Submit a batch job
--- | ---
Frontera | <code>login1$ <b>sbatch myjobscript</b></code> | <a href="../../hpc/frontera#running/">Running jobs on Frontera</a>
Stampede2 | <code>login1$ <b>sbatch myjobscript</b></code> | <a href="../../hpc/stampede2#running">Running jobs on Stampede2</a>
Lonestar6 | <code>login1$ <b>sbatch myjobscript</b></code> | <a href="../../hpc/lonestar6#running">Running jobs on Lonestar6</a>

## [Parallel MATLAB](#parallelmatlab) { #parallelmatlab }

The parallel computing toolbox is available on the TACC resources as well.  

The following two examples demonstrate parallel operations using the `parfor` and `matlabpool` functions. Here are the basic examples.

### [Example 2. MATLAB `parfor`](#example2)
``` syntax
Mat=zeros(100,1);
parfor i = 1:100
    Mat(i) = i*i;
end
```

### [Example 3. MATLAB `matlabpool`](#example3)

``` syntax
if (matlabpool('size') ) == 0 
    matlabpool(12);
else
    matlabpool close;
    matlabpool(12);
end
```

Consult the [MATLAB Parallel Toolbox](https://www.mathworks.com/products/parallel-computing.html) documentation for detailed descriptions and advanced features.

## [MATLAB Toolboxes](#toolbox) { #toolbox } 

MATLAB, Simulink, and a lot of MATLAB toolboxes are available on the TACC resources.  Listed below is the complete set of Toolboxes on the TACC resources:

<table><tr>
<td valign="top"> Aerospace Blockset<br>Aerospace Toolbox<br>Bioinformatics Toolbox<br>Communications System Toolbox<br>Computer Vision System Toolbox<br>Control System Toolbox<br>Curve Fitting Toolbox<br>DSP System Toolbox<br>Database Toolbox<br>Econometrics Toolbox<br>Embedded Coder<br>Financial Instruments Toolbox<br>Financial Toolbox<br>Fixed-Point Designer</td>

<td valign="top"> Fuzzy Logic Toolbox <br>Global Optimization Toolbox <br>HDL Verifier <br>Image Acquisition Toolbox <br>Image Processing Toolbox <br>Instrument Control Toolbox <br>LTE System Toolbox <br>MATLAB Coder <br>MATLAB Compiler <br>MATLAB Compiler SDK <br>MATLAB Report Generator <br>Mapping Toolbox <br>Model Predictive Control Toolbox <br>Neural Network Toolbox</td>

<td valign="top"> Optimization Toolbox <br>Parallel Computing Toolbox <br>Partial Differential Equation Toolbox <br>Phased Array System Toolbox <br>RF Blockset <br>RF Toolbox <br>Robust Control Toolbox <br>Signal Processing Toolbox <br>SimBiology <br>Simscape <br>Simscape Driveline <br>Simscape Electronics <br>Simscape Fluids <br>Simscape Multibody</td>

<td valign="top"> Simscape Power Systems <br>Simulink <br>Simulink Check <br>Simulink Coder <br>Simulink Control Design <br>Simulink Coverage <br>Simulink Design Optimization                          <br>Simulink Requirements <br>Stateflow <br>Statistics and Machine Learning Toolbox <br>Symbolic Math Toolbox <br>System Identification Toolbox <br>WLAN System Toolbox <br>Wavelet Toolbox</td></tr></table>


To see a complete list of MATLAB, Simulink, and MATLAB Toolboxes and their version information, type the `ver` command at the MATLAB prompt

``` syntax
>> ver
```

## [Mathworks References](#refs) { #refs }

Mathworks has an excellent collection of documentation, videos and webinars.

* [Parallel Computing Overview](https://www.mathworks.com/products/parallel-computing.html)
* [Parallel Computing Coding Examples](https://www.mathworks.com/products/parallel-computing/code-examples.html)
* [Parallel Computing Documentation](https://www.mathworks.com/help/distcomp/index.html)
* [Parallel Computing Tutorials](https://www.mathworks.com/videos/series/parallel-and-gpu-computing-tutorials-97719.html)
* [Parallel Computing Videos](https://www.mathworks.com/products/parallel-computing/videos.html)
* [Parallel Computing Webinars](https://www.mathworks.com/products/parallel-computing/webinars.html)

## [Help](#help) { #help } 

MATLAB is a commercial product of MathWorks. Please solicit help from Mathworks regarding MATLAB code. If you need any further assistance related to access issues or running issues, request help via the [TACC User Portal][TACCUSERPORTAL].

{% include 'aliases.md' %}
