## Visualization and VNC Sessions { #vis }

Stampede2 uses the SKX and KNL processors for all visualization and rendering operations. We use the Intel OpenSWR library to render raster graphics with OpenGL, and the Intel OSPRay framework for ray traced images inside visualization software. **On Stampede2, `swr` replaces `vglrun` (e.g. `swr glxgears`) and uses similar syntax.** OpenSWR can be loaded by executing `module load swr`. We expect most users will notice little difference in visualization experience on KNL. MCDRAM may improve visualization performance for some users. SKX nodes may provide better interactivity for intensive rendering applications.

There is currently no separate visualization queue on Stampede2. All visualization apps are available on all nodes. VNC and DCV sessions are available on any queue, either through the command line or via the [TACC Analysis Portal](https://tap.tacc.utexas.edu/). We recommend submitting to the `development` queue (for KNL) or the `skx-dev` queue (for SKX) for interactive sessions. If you are interested in an application that is not yet available, please submit a help desk ticket through the TACC User Portal.


### Remote Desktop Access { #vis-remote }

Remote desktop access to Stampede2 is formed through a VNC connection to one or more visualization nodes. Users must first connect to a Stampede2 login node (see System Access) and submit a special interactive batch job that:

*  allocates a set of Stampede2 visualization nodes 
*  starts a vncserver process on the first allocated node 
*  sets up a tunnel through the login node to the vncserver access port 

Once the vncserver process is running on the visualization node and a tunnel through the login node is created, an output message identifies the access port for connecting a VNC viewer. A VNC viewer application is run on the user's remote system and presents the desktop to the user.

!!! tip
	If this is your first time connecting to Stampede2, you must run `vncpasswd` to create a password for your VNC servers. This should NOT be your login password! This mechanism only deters unauthorized connections; it is not fully secure, as only the first eight characters of the password are saved. All VNC connections are tunneled through SSH for extra security, as described below.

Follow the steps below to start an interactive session.

1. Start a Remote Desktop 

	TACC has provided a VNC job script (`/share/doc/slurm/job.vnc`) that requests one node in the [`development` queue](#running-queues) for two hours, creating a [VNC](https://en.wikipedia.org/wiki/VNC) session.

	```cmd-line
	login1$ sbatch /share/doc/slurm/job.vnc
	```

	You may modify or overwrite script defaults with `sbatch` command-line options:

	*  <code>-t <i>hours:minutes:seconds</i></code> modify the job runtime 
	*  <code>-A <i>projectnumber</i></code> specify the project/allocation to be charged 
	*  <code>-N <i>nodes</i></code> specify number of nodes needed 
	*  <code>-p <i>partition</i></code> specify an alternate queue. 

	See more `sbatch` options in the [Common `sbatch` Options](#table6) table above.

	All arguments after the job script name are sent to the vncserver command. For example, to set the desktop resolution to 1440x900, use:

	```cmd-line
	login1$ sbatch /share/doc/slurm/job.vnc -geometry 1440x900
	```

	The `vnc.job` script starts a vncserver process and writes to the output file, `vncserver.out` in the job submission directory, with the connect port for the vncviewer. Watch for the "To connect via VNC client" message at the end of the output file, or watch the output stream in a separate window with the commands:

	```cmd-line
	login1$ touch vncserver.out ; tail -f vncserver.out
	```

	The lightweight window manager, `xfce`, is the default VNC desktop and is recommended for remote performance. Gnome is available; to use gnome, open the `~/.vnc/xstartup` file (created after your first VNC session) and replace `startxfce4` with `gnome-session`. Note that gnome may lag over slow internet connections.

1. Create an SSH Tunnel to Stampede2 

	TACC requires users to create an SSH tunnel from the local system to the Stampede2 login node to assure that the connection is secure.   The tunnels created for the VNC job operate only on the `localhost` interface, so you must use `localhost` in the port forward argument, not the Stampede2 hostname.  On a Unix or Linux system, execute the following command once the port has been opened on the Stampede2 login node:

	```cmd-line
	
	localhost$ ssh -f -N -L xxxx:localhost:yyyy username@stampede2.tacc.utexas.edu
	```

	where:

	*  <code><i>yyyy</i></code> is the port number given by the vncserver batch job 
	*  <code><i>xxxx</i></code> is a port on the remote system. Generally, the port number specified on the Stampede2 login node, <code><i>yyyy</i></code>, is a good choice to use on your local system as well 
	*  `-f` instructs SSH to only forward ports, not to execute a remote command 
	*  `-N` puts the `ssh` command into the background after connecting 
	*  `-L` forwards the port 

	On Windows systems find the menu in the Windows SSH client where tunnels can be specified, and enter the local and remote ports as required, then `ssh` to Stampede2.

1. Connecting vncviewer 

	Once the SSH tunnel has been established, use a [VNC client](https://en.wikipedia.org/wiki/Virtual_Network_Computing) to connect to the local port you created, which will then be tunneled to your VNC server on Stampede2. Connect to <code>localhost:<i>xxxx</i></code>, where <code><i>xxxx</i></code> is the local port you used for your tunnel. In the examples above, we would connect the VNC client to <code>localhost::<i>xxxx</i></code>. (Some VNC clients accept <code>localhost:<i>xxxx</i></code>).

	We recommend the [TigerVNC](http://sourceforge.net/projects/tigervnc/) VNC Client, a platform independent client/server application.

	Once the desktop has been established, two initial xterm windows are presented (which may be overlapping). One, which is white-on-black, manages the lifetime of the VNC server process. Killing this window (typically by typing `exit` or `ctrl-D` at the prompt) will cause the vncserver to terminate and the original batch job to end. Because of this, we recommend that this window not be used for other purposes; it is just too easy to accidentally kill it and terminate the session.

	The other xterm window is black-on-white, and can be used to start both serial programs running on the node hosting the vncserver process, or parallel jobs running across the set of cores associated with the original batch job. Additional xterm windows can be created using the window-manager left-button menu.

### Running Applications on the VNC Desktop { #vis-apps }

From an interactive desktop, applications can be run from icons or from xterm command prompts. Two special cases arise: running parallel applications, and running applications that use OpenGL.

### Running Parallel Applications from the Desktop { #vis-parallelapps }

Parallel applications are run on the desktop using the same `ibrun` wrapper described above (see [Running](#running)). The command:

```cmd-line
c442-001$ ibrun ibrunoptions application applicationoptions
```

will run application on the associated nodes, as modified by the `ibrun` options.

### Running OpenGL/X Applications On The Desktop { #vis-opengl }

Stampede2 uses the OpenSWR OpenGL library to perform efficient rendering. At present, the compute nodes on Stampede2 do not support native X instances. All windowing environments should use a VNC desktop launched via the job script in /share/doc/slurm/job.vnc or using the [TACC Analysis Portal][TACCANALYSISPORTAL]. 

swr: To access the accelerated OpenSWR OpenGL library, it is necessary to use the swr module to point to the swr OpenGL implementation and configure the number of threads to allocate to rendering.  

```cmd-line
c442-001$ module load swr
c442-001$ swr options application application-args
```

### Parallel VisIt on Stampede2 { #vis-visit }

[VisIt](https://wci.llnl.gov/simulation/computer-codes/visit/manuals) was compiled under the Intel compiler and the mvapich2 and MPI stacks. 

After connecting to a VNC server on Stampede2, as described above, load the VisIt module at the beginning of your interactive session before launching the Visit application:

```cmd-line
c442-001$ module load swr visit
c442-001$ swr visit
```

VisIt first loads a dataset and presents a dialog allowing for selecting either a serial or parallel engine. Select the parallel engine. Note that this dialog will also present options for the number of processes to start and the number of nodes to use; these options are actually ignored in favor of the options specified when the VNC server job was started.

#### Preparing Data for Parallel Visit { #vis-visit-preparingdata }

VisIt reads [nearly 150 data formats](https://github.com/visit-dav/visit/tree/develop/src/databases). Except in some limited circumstances (particle or rectilinear meshes in ADIOS, basic netCDF, Pixie, OpenPMD and a few other formats), VisIt piggy-backs its parallel processing off of whatever static parallel decomposition is used by the data producer. This means that VisIt expects the data to be explicitly partitioned into independent subsets (typically distributed over multiple files) at the time of input. Additionally, VisIt supports a metadata file (with a `.visit` extension) that lists multiple data files of any supported format that hold subsets of a larger logical dataset. VisIt also supports a "brick of values (`bov)` format which supports a simple specification for the static decomposition to use to load data defined on rectilinear meshes. For more information on importing data into VisIt, see [Getting Data Into VisIt](https://visit-dav.github.io/visit-website/pdfs/GettingDataIntoVisIt2.0.0.pdf?#page=97).

### Parallel ParaView on Stampede2 { #vis-paraview }

After connecting to a VNC server on Stampede2, as described above, do the following:

1. Set up your environment with the necessary modules. Load the `swr`, `qt5`, `ospray`, and `paraview` modules **in this order**:

	```cmd-line
	c442-001$ module load swr qt5 ospray paraview
	```

1. Launch ParaView: 

	```cmd-line
	c442-001$ swr -p 1 paraview [paraview client options]
	```

1. Click the "Connect" button, or select File -&gt; Connect 

1. Select the "auto" configuration, then press "Connect".  In the Paraview Output Messages window, you'll see what appears to be an 'lmod' error, but can be ignored.  Then you'll see the parallel servers being spawned and the connection established.


