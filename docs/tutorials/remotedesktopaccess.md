# Remote Desktop Access via DCV and VNC Connections
*Last update: June 08, 2023*
  
Establishing a remote desktop connection from one system to another allows the desktop on the remote computer (TACC resources) to be displayed on the local system (your desktop). For HPC purposes remote desktops are used for [visualization applications](../../hpc/stampede2/stampede2#vis) and other [graphics-library enabled applications](/tutorials/ddt).  

## [Remote Desktop Methods](#methods) { #methods }
	
TACC provides three methods of setting up a remote desktop:

1. **VNC connection**: A (**V**irtual **N**etwork **C**omputing) VNC connection allows you to harness TACC resources' compute or visualization nodes to display an image on your own desktop display. After logging on, submit a special interactive batch job that:

* allocates one or more compute <!-- or visualization (Maverick)--> nodes
* starts a `vncserver` process on the first allocated node
* sets up an SSH tunnel through the login node to the vncserver access port

Once the `vncserver` process is running on the compute node and a tunnel through the login node is created, the job script writes the connection port to the job output file, `vncserver.out`. Then, connect the VNC viewer application to that port. The remote system's desktop is then presented.  

1. **TACC Vis Portal**: Available to all Frontera and Stampede2 users, the [TACC Analysis Portal](http://tap.tacc.utexas.edu) provides an easy-to-use web interface to submit a VNC job script.

1. **DCV connection**: **D**esktop **C**loud **V**isualization (DCV) traffic is encrypted using Transport Layer Security (TLS) through your web browser, obviating the need to create a separate SSH tunnel. A DCV connection is easier to set up than a VNC connection, however TACC is limited to the number of concurrent DCV licenses. Stampede2 and Frontera are currently the only TACC resources allowing DCV connections. The DCV job script writes connection information to a file, `dcvserver.out`. You can connect to a DCV session with any modern web browswer.


## [TACC Analysis Portal](#tap) { #tap }

Connect to the TACC Analysis Portal at <https://tap.tacc.utexas.edu>. Everyone with a project allocation on Frontera or Stampede2 may use the TACC Analysis Portal.  

<figure id="figure1"><img alt="TACC Vis Portal" src="../imgs/RDA-1.png">  
<figcaption>Figure 1. TACC Visualization Portal</figcaption></figure>

## [DCV & VNC at TACC](#scripts) { #scripts }

TACC resources [Frontera](../../hpc/frontera), [Stampede2](../../hpc/stampede2) and [Lonestar6](../../hpc/lonestar6) all offer remote desktop capabilities via a VNC (Virtual Network Computing) connection. Frontera and Stampede2 also provide remote desktop access through a DCV (Desktop Cloud Visualization) connection to one or more nodes.  

TACC has a limited number of DCV licenses available, so concurrent DCV sessions may be limited. TACC has provided two DCV job scripts for two different scenarios:

* `/share/doc/slurm/job.dcv2vnc` 	- request a DCV session, if none is available, then a VNC session is submitted
* `/share/doc/slurm/job.dcv`		- request a DCV session, if none is available, then exit

You can modify or overwrite script defaults with `sbatch` command-line options:

* <code>-t hours:minutes:seconds</code> modify the job runtime 
* <code>-A projectname</code> specify the project/allocation to be charged 
* <code>-N nodes</code> specify number of nodes needed  
* <code>-p partition</code> specify an alternate queue 

See more `sbatch` options in the [Stampede2 User Guide: Common `sbatch` Options](../../hpc/stampede2#table6)

### [Table 1. Job Scripts](#table1) { #table1 }

<table><tr>
<th>System</th>
<th>Connection Type</th>
<th>Script Location</th>
<th>Description of Default Behavior</th></tr>

<th rowspan="3">Frontera</th>
<td align="center">DCV</td>
<td><code>/share/doc/slurm/job.dcv</code></td>
<td>Requests a DCV session, if no license is available then the job exits.<br> Requests 1 node for 2 hours in Frontera's <code>development</code> queue</td></tr>

<td align="center"> DCV</td>
<td nowrap> <code>/share/doc/slurm/job.dcv2vnc</code></td>
<td>Requests a DCV session, but if no DCV licenses are available then a VNC session is submitted.<br>Requests 1 node for 2 hours Frontera's <code>development</code> queue</td></tr>

<td align="center"> VNC</td>
<td><code>/share/doc/slurm/job.vnc</code></td>
<td>Requests 1 node for 2 hours in Frontera's <code>development</code> queue</td></tr>

<th rowspan="3"> Stampede2
<td align="center"> DCV
<td><code>/share/doc/slurm/job.dcv</code>
<td>Requests a DCV session, if no license is available then the job exits.<br>Requests 1 node for 2 hours in Stampede2's <a href="../../hpc/stampede2#queues"><code>skx-dev</code></a> queue</td></tr>

<td align="center"> DCV
<td nowrap> <code>/share/doc/slurm/job.dcv2vnc</code>
<td>Request a DCV session, tried to launch a DCV session but if none is available then a VNC session is submitted.<br>Requests 1 node for 2 hours Stampede2's the <a href="../../hpc/stampede2#running-queues"><code>skx-dev</code></a> queue</td></tr>
<td align="center"> VNC
<td><code>/share/doc/slurm/job.vnc</code>
<td>Requests 1 node for 2 hours in Stampede2's <a href="../../hpc/stampede2#running-queues"><code>skx-dev</code></a> queue</td></tr>
<th nowrap> Lonestar6
<td align="center"> VNC
<td><code>/share/doc/slurm/job.vnc</code>
<td>Requests 1 node for 2 hours in Lonestar6's <a href="../../hpc/lonestar6#running-queues"><code>development</code></a> queue.</td></tr>
</table>

## [Start a DCV Session](#dcv) { #dcv }

Both Frontera and Stampede2 allow DCV connections. Follow the steps below to start an interactive DCV session on either resource. The command-line examples below demonstrate creating a session on Stampede2. You can follow the same steps to establish a session on Frontera.

1. Connect to Stampede2 or Frontera in your usual manner, e.g.:

	```cmd-line
	login1$ ssh -l username stampede2.tacc.utexas.edu
	```

1. **Submit one of two standard job scripts.** If you submit the `job.dcv2vnc` script, then either a DCV or VNC session is created. The following instructions demonstrate submitting the `job.dcv` script.  

	Copy into your home directory, then edit either of the job scripts listed above to include your project allocation:

	```job-script
	#SBATCH -A projectname
	```

	or you can provide the allocation number on the command line as an argument to the `sbatch` command:

	```cmd-line
	login1$ sbatch -A projectname /share/doc/slurm/job.dcv
	login1$ sbatch -A projectname /share/doc/slurm/job.dcv2vnc
	```

	In the following example we also override the time option, requesting one hour instead of the script's default of two hours.

	```cmd-line
	login4(689)$ sbatch -A projectname -t 01:00:00 /share/doc/slurm/job.dcv
	...
	--> Verifying access to desired queue (skx-dev)...OK
	--> Verifying job request is within current queue limits...OK
	--> Checking available allocation (TG-123456)...OK
	Submitted batch job 1965942
	```
	
1. **Poll the queue, waiting till the job runs...**

	You can poll the job's status with the `squeue` command, waiting till the submitted job actually runs, or by waiting for the job output file, (`dcvserver.out` or `vncserver.out` depending on the connection type and job script submitted), to appear in the submission directory.  

	```cmd-line
	login4(690)$ squeue -u slindsey
	  JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
	1965942     skx-dev dcvserve slindsey  R       0:16      1 c506-082
	```

	If your job could not acquire a DCV license and launched a VNC session instead, jump to step 3 of the [VNC connection instructions](#vnc) below.

1. **Display the contents of the job output file to extract the web URL.**

	Once the DCV job starts running, a file called `dcvserver.out` will be created in the submission directory.  

	```cmd-line
	login4(691)$ cat dcvserver.out
	TACC: job 1965942 execution at: Tue Aug 21 14:25:54 CDT 2018
	TACC: running on node c506-082
	TACC: local (compute node) DCV port is 8443
	TACC: got login node DCV port 18606
	TACC: Created reverse ports on Stampede2 logins
	TACC: Your DCV session is now running!
	TACC: To connect to your DCV session, please point a modern web browser to:
	TACC:          https://stampede2.tacc.utexas.edu:18606
	```


1. **Load this generated URL in your favorite browser and then authenticate using your Stampede2 or Frontera password**. 

	<figure id="figure2"><img alt="" src="../imgs/RDA-2.png"> 
	<figcaption>Figure 2. Authenticate with your Stampede2 password.</figcaption></figure>

1. **Start your graphics-enabled application.** Once the desktop is generated ([Figure 3.](#figure3)), you can launch your applications. Here we run a simple visualization program, `glxgears`. ([Figure 4.](#figure4))

	!!! Tip
		The "Terminal" button at the bottom of the DCV window creates a terminal **without `ibrun` support**.   
		To create an xterm with full `ibrun` support, type `xterm &` in the initial xterm window.

	<figure id="figure3"><img alt="" src="../imgs/RDA-3.png">
	<figcaption>Figure 3. DCV Desktop in Chrome Browser</figcaption></figure>

	<figure id="figure4"><img alt="" src="../imgs/RDA-4.png">
	<figcaption>Figure 4. Run a visualization application</figcaption></figure>

7. Once you've completed your work and closed the browser window, remember to kill the job you submitted in Step 2.
		
	```cmd-line
	login4(692)$ scancel 1965942
	login4(693)$ exit
	```

## [Start a VNC Session](#vnc) { #vnc }

Follow the steps below to start an interactive session.

!!! note
	If this is your first time connecting to a resource, you must run `vncpasswd` to create a password for your VNC servers. This should NOT be your login password! This mechanism only deters unauthorized connections; it is not fully secure, as only the first eight characters of the password are saved. All VNC connections are tunneled through SSH for extra security, as described below.

1. **Connect to the TACC resource in your usual manner, e.g.:**

	```cmd-line
	login1$ ssh -l slindsey ls5.tacc.utexas.edu
	```

1. **Submit the standard job script**, `job.vnc`, see [Table 1.](#table1).  

	TACC has provided a VNC job script (`/share/doc/slurm/job.vnc`) that requests one node in Frontera's `development` [queue](../../hpc/frontera#running-queues) for two hours.

	```cmd-line
	login1$ sbatch /share/doc/slurm/job.vnc
	```

	All arguments after the job script name are sent to the `vncserver` command. For example, to set the desktop resolution to 1440x900, use:

	```cmd-line
	login1$ sbatch /share/doc/slurm/job.vnc -geometry 1440x900
	```

1. **Poll and wait till the job runs...**

	```cmd-line
	login1$ squeue -u slindsey
	  JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
	1974882 development vncserve slindsey  R       0:16      1 c455-084
	```

1. **Display the job's output file, `vncserver.out`, to extract the port connection number:**

	The `job.vnc` script starts a vncserver process and writes the connect port for the vncviewer to the output file, `vncserver.out` in the job submission directory. 

	The lightweight window manager, `xfce`, is the default VNC desktop and is recommended for remote performance. Gnome is available; to use gnome, open the `~/.vnc/xstartup` file (created after your first VNC session) and replace `startxfce4` with `gnome-session`. Note that gnome may lag over slow internet connections.

1. **Create an SSH Tunnel to Stampede2**

	TACC requires users to create an SSH tunnel from the local system to the Stampede2 login node to assure that the connection is secure. On a Unix or Linux system, execute the following command once the port has been opened on the Stampede2 login node:

	In a new local terminal window, create the SSH tunnel:

	```cmd-line
	localhost$ ssh -f -N -L xxxx:stampede2.tacc.utexas.edu:yyyy \
	      username@stampede2.tacc.utexas.edu
	```

	where

	*  <code>yyyy</code> is the port number given by the vncserver batch job 
	*  <code>xxxx</code> is a port on the remote system. Generally, the port number specified on the Stampede2 login node, <code>yyyy</code>, is a good choice to use on your local system as well 
	*  `-f` instructs SSH to only forward ports, not to execute a remote command 
	*  `-N` puts the `ssh` command into the background after connecting 
	*  `-L` forwards the port 

	On Windows systems find the menu in the Windows SSH client where tunnels can be specified, and enter the local and remote ports as required, then `ssh` to Stampede2.

1. **Connect the VNC viewer**

	Once the SSH tunnel has been established, use a [VNC client](https://en.wikipedia.org/wiki/Virtual_Network_Computing) to connect to the local port you created, which will then be tunneled to your VNC server on Stampede2. Connect to <code>localhost:xxxx</code>, where <code>xxxx</code> is the local port you used for your tunnel. In the examples above, we would connect the VNC client to <code>localhost::xxxx</code>. (Some VNC clients accept <code>localhost:xxxx</code>).

	!!! tip
		TACC staff recommends the [TigerVNC](http://sourceforge.net/projects/tigervnc/) VNC Client, a platform independent client/server application.

		
	<figure id="figure5"><img alt="" src="../imgs/RDA-5.png"> 
	<figcaption> Figure 5. Connect the VNC client to the local port created in step 5.</figcaption></figure>

1. Once the desktop is generated (Figure 6.), you can start your graphics-enabled application. Here we run a simple visualization program, `glxgears`. (Figure 7.)

	<figure id="figure6"><img alt="" src="../imgs/RDA-6.png"> 
	<figcaption>Figure 6. VNC Desktop</figcaption></figure>

	<figure id="figure7"><img alt="" src="../imgs/RDA-7.png"> 
	<figcaption>Figure 7. Run a Visualization Application</figcaption></figure>

	Once the desktop has been established an initial xterm window appears. (Figure 6.) This window manages the lifetime of the VNC server process. Killing this window (typically by typing `exit` or `ctrl-D` at the prompt) will cause the vncserver to terminate and the original batch job to end. 


1. Once you've completed your work and closed the browser window, remember to kill the job you submitted in Step 2.
		
	```cmd-line
	login4(692)$ scancel 1974882
	login4(693)$ exit
	```

### [Sample VNC session](#vncsession)   { #vncsession }

#### [Window 1](#vncwindow1) { #vncwindow1 }

Submit a VNC job for user `slindsey`.

```cmd-line
localhost$ ssh slindsey@stampede2.tacc.utexas.edu
 ...
login4(804)$ sbatch -A TG-123456 -t 01:00:00 /share/doc/slur m/job.vnc
 ...
 --> Verifying access to desired queue (development)...OK
 --> Verifying job request is within current queue limits...OK
 --> Checking available allocation (UserServStaff)...OK
Submitted batch job STYLEBLUE1974882
login4(805)$ squeue -u slindsey
  JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
1974882 development vncserve slindsey  R       0:16      1 c455-084
login4(806)$ cat vncserver.out 
job execution at: Wed Aug 22 15:43:46 CDT 2018
running on node c455-084
using default VNC server /bin/vncserver
memory limit set to 93767542 kilobytes
set wayness to 
got VNC display :1
local (compute node) VNC port is 5901
got login node VNC port 18455
Created reverse ports on Stampede2 logins
Your VNC server is now running!
To connect via VNC client:  STYLEBLUESSH tunnel port 18455 to stampede2.tacc.utexas.edu:18455
Then connect to localhost::18455
login4(807)$ scancel 1974882
login4(808)$ squeue -u slindsey
JOBID   PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
login4(809)$ exit
logout
Connection to stampede2.tacc.utexas.edu closed.
bash-3.2$ exit
```

#### [Window 2](#vncwindow2) { #vncwindow2 }

Create the SSH tunnel from your local machine to Stampede2

```cmd-line
localhost$ ssh -f -N -L 18455:stampede2.tacc.utexas.edu:18455 slindsey@stampede2.tacc.utexas.edu
...
Password:
TACC Token Code:
localhost$
```

## [Running Apps on the Desktop](#running) { #running }

From an interactive desktop, applications can be run from icons or from `xterm` command prompts. 

See the [Stampede2 User Guide Visualization](../../hpc/stampede2#vis) and [Frontera User Guide Visualization](../../hpc/frontera#vis) sections for details on running parallel applications on the desktop.


		

