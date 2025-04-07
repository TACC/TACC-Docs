# MATLAB at TACC
*Last update: January 16, 2024* 

<table cellpadding="5" cellspacing="5"><tr>
<td><img src="../imgs/matlab-logo.png" style="width:50%"></td>
<td></td>
</tr></table>

[Mathwork's](https://www.mathworks.com/) MATLAB is installed and supported at TACC and is available on the following TACC resources: [Frontera][TACCFRONTERAUG], [Stampede3][TACCSTAMPEDE3UG] and [Lonestar6][TACCLONESTAR6UG].  

## Licenses { #license }

MathWork's agreement with the University of Texas now allows TACC users to access MATLAB for **non-commercial**, **academic** use. If you have your own network licenses for toolboxes that are not available through the University of Texas, we can help you configure these licenses on TACC systems.  If you would like access to MATLAB [submit a help desk ticket][HELPDESK].  Include in your ticket: 

* your institutional affiliation If you are affiliated with the University of Texas, include your academic department in your help desk ticket.
* and a brief statement confirming that you will use MATLAB only for **non-commercial**, **academic** purposes. 


## Interactive Mode { #interactive }

MATLAB is normally launched with the MATLAB Desktop UI and used in interactive mode. Create a DCV or VNC session following the directions in the [Remote Desktop Access][TACCREMOTEDESKTOPACCESS] tutorial.  You can also launch a non-GUI enabled MATLAB from within an [`idev`][TACCIDEV] session.

MATLAB is managed under the [Lmod](https://lmod.readthedocs.io/en/latest/) modules system on TACC resources. Whether within an `idev`, VNC, or DCV session, launch MATLAB by loading the MATLAB module with the following command:

	c202-002$ module load matlab

You can always get the MATLAB help information by typing the following standard `module help` command.

	c202-002$ module help matlab

### DCV session { #interactive-dcv } 

The following figures demonstrate how to launch MATLAB inside a DCV session in the [TACC Analysis Portal][TACCANALYSISPORTAL].

1. Submit a New Job request, this may take a few minutes:

	<figure id="figure1"> <img alt="" src="../imgs/matlab-dcv-1.png" width="600"><figcaption></figcaption></figure>

2. Once your DCV session is established, click "Connect" to launch.  This will open a separate window where you may be required to enter your TACC credentials once again.

	<figure id="figure3"> <img alt="" src="../imgs/matlab-dcv-3.png" width="600"><figcaption></figcaption></figure>

3. Then invoke MATLAB as described above: 

	<figure id="figure2"> <img alt="" src="../imgs/matlab-dcv-2.png" width="600"><figcaption></figcaption></figure>

!!! important
	Do NOT launch MATLAB on the login nodes. This may fail and, more importantly, it will prevent other users from doing their work, as your execution will take up too many cycles on the shared login node. Using MATLAB on the login nodes is considered system abuse, and will be treated as such.  See TACC's [Acceptable Use Policy][TACCAUP].

## Batch Mode { #batch }

You can also start a MATLAB session with a batch script.  submit your MATLAB job to each resources' compute nodes on the TACC resources, e.g. Frontera, Stampede3, or Lonestar6. To do so, first make sure that the MATLAB module has been loaded, and then launch matlab with the `-nodesktop`, `-nodisplay`, `-nosplash` options as shown in the sample Frontera job script below.

### Sample Frontera Job Script { #example1 }

```job-script
#!/bin/bash
#SBATCH -J matlabjob                # job name
#SBATCH -e matlabjob.%j.err         # error file name
#SBATCH -o matlabjob.%j.out         # output file name
#SBATCH -N 1                        # request 1 node
#SBATCH -n 16                       # request all 16 cores
#SBATCH -t 01:00:00                 # designate max run time
#SBATCH -A myproject                # charge job to myproject
#SBATCH -p small                    # designate queue

module load matlab
matlab -nodesktop -nodisplay -nosplash < mymatlabprog.m
```

Then submit the job to the Slurm scheduler in the standard way. 

```cmd-line
login1$ sbatch myjobscript
```

## Parallel MATLAB { #parallelmatlab }

The parallel computing toolbox is available on the TACC resources as well.  The following two examples demonstrate parallel operations **across one node** using the `parfor` and `matlabpool` functions.  Consult the [MATLAB Parallel Toolbox](https://www.mathworks.com/products/parallel-computing.html) documentation for detailed descriptions and advanced features.

### MATLAB `parfor` { #example2 }
``` syntax
Mat=zeros(100,1);
parfor i = 1:100
    Mat(i) = i*i;
end
```

### MATLAB `matlabpool` { #example3 }

``` syntax
if (matlabpool('size') ) == 0 
    matlabpool(12);
else
    matlabpool close;
    matlabpool(12);
end
```


## MATLAB Toolboxes { #toolbox } 

MATLAB, Simulink, and many other MATLAB toolboxes are available on the TACC resources. To see a complete list of installations and version information, type the `ver` command at the MATLAB prompt:

	>> ver
	-----------------------------------------------------------------------------------------------------
	MATLAB Version: 9.14.0.2206163 (R2023a)
	MATLAB License Number: 875352
	Operating System: Linux 3.10.0-1160.90.1.el7.x86_64 #1 SMP Thu May 4 15:21:22 UTC 2023 x86_64
	Java Version: Java 1.8.0_202-b08 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode
	-----------------------------------------------------------------------------------------------------
	5G Toolbox                                            Version 2.6         (R2023a)
	AUTOSAR Blockset                                      Version 3.1         (R2023a)
	Aerospace Blockset                                    Version 6.0         (R2023a)
	Aerospace Toolbox                                     Version 4.4         (R2023a)
	Antenna Toolbox                                       Version 5.4         (R2023a)
	Audio Toolbox                                         Version 3.4         (R2023a)
	...
	Wireless Testbench                                    Version 1.2         (R2023a)
	>> exit
	

## Mathworks References { #refs }

Explore Mathworks' excellent collection of documentation, videos and webinars.

* [Parallel Computing Toolbox](https://www.mathworks.com/products/parallel-computing.html)
* [Parallel Computing Coding Examples](https://www.mathworks.com/help/parallel-computing/examples.html)
* [MATLAB and Simulink Videos](https://www.mathworks.com/videos/series/parallel-and-gpu-computing-tutorials-97719.html)

## Help { #help } 

MATLAB is a commercial product of MathWorks. Please solicit help from [Mathworks](https://www.mathworks.com/) regarding MATLAB code. If you need further assistance related to access or running issues, request help via your [TACC Dashboard][TACCUSERPORTAL].


## References 

* [`idev` at TACC][TACCIDEV]
* [Remote Desktop Access at TACC][TACCREMOTEDESKTOPACCESS]
{% include 'aliases.md' %}

