## [Remote Desktop Access](#remote-desktop-access)

Remote desktop access to Maverick2 is formed through a VNC connection to one or more visualization nodes. Users must first connect to a Maverick2 login node (see System Access) and submit a special interactive batch job that:

*  allocates a set of Maverick2 visualization nodes 
*  starts a vncserver process on the first allocated node 
*  sets up a tunnel through the login node to the vncserver access port 

Once the vncserver process is running on the visualization node and a tunnel through the login node is created, an output message identifies the access port for connecting a VNC viewer. A VNC viewer application is run on the user's remote system and presents the desktop to the user.

!!! tip
	If this is your first time connecting to Maverick2, you must run `vncpasswd` to create a password for your VNC servers. This should NOT be your login password! This mechanism only deters unauthorized connections; it is not fully secure, as only the first eight characters of the password are saved. All VNC connections are tunneled through SSH for extra security, as described below.

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

	See more `sbatch` options in the [Common `sbatch` Options](../stampede2#table6) section of the Stampede2 resource guide.

	All arguments after the job script name are sent to the vncserver command. For example, to set the desktop resolution to 1440x900, use:

	```cmd-line
	login1$ sbatch /share/doc/slurm/job.vnc -geometry 1440x900
	```

	The `vnc.job` script starts a vncserver process and writes to the output file, `vncserver.out` in the job submission directory, with the connect port for the vncviewer. Watch for the "To connect via VNC client" message at the end of the output file, or watch the output stream in a separate window with the commands:

	```cmd-line
	login1$ touch vncserver.out ; tail -f vncserver.out
	```

	The lightweight window manager, `xfce`, is the default VNC desktop and is recommended for remote performance. Gnome is available; to use gnome, open the `~/.vnc/xstartup` file (created after your first VNC session) and replace `startxfce4` with `gnome-session`. Note that gnome may lag over slow internet connections.

1. Create an SSH Tunnel to Maverick2 

	TACC requires users to create an SSH tunnel from the local system to the Maverick2 login node to assure that the connection is secure.   The tunnels created for the VNC job operate only on the `localhost` interface, so you must use `localhost` in the port forward argument, not the Maverick2 hostname.  On a Unix or Linux system, execute the following command once the port has been opened on the Maverick2 login node:

	```cmd-line
	localhost$ ssh -f -N -L xxxx:localhost:yyyy username@maverick2.tacc.utexas.edu
	```

	where:

	*  <code><i>yyyy</i></code> is the port number given by the vncserver batch job 
	*  <code><i>xxxx</i></code> is a port on the remote system. Generally, the port number specified on the Maverick2 login node, <code><i>yyyy</i></code>, is a good choice to use on your local system as well 
	*  `-f` instructs SSH to only forward ports, not to execute a remote command 
	*  `-N` puts the `ssh` command into the background after connecting 
	*  `-L` forwards the port 

	On Windows systems find the menu in the Windows SSH client where tunnels can be specified, and enter the local and remote ports as required, then `ssh` to Maverick2.

1. Connecting vncviewer 

	Once the SSH tunnel has been established, use a [VNC client](https://en.wikipedia.org/wiki/Virtual_Network_Computing) to connect to the local port you created, which will then be tunneled to your VNC server on Maverick2. Connect to <code>localhost:<i>xxxx</i></code>, where <code><i>xxxx</i></code> is the local port you used for your tunnel. In the examples above, we would connect the VNC client to <code>localhost::<i>xxxx</i></code>. (Some VNC clients accept <code>localhost:<i>xxxx</i></code>).

	We recommend the [TigerVNC](http://sourceforge.net/projects/tigervnc/) VNC Client, a platform independent client/server application.

	Once the desktop has been established, two initial xterm windows are presented (which may be overlapping). One, which is white-on-black, manages the lifetime of the VNC server process. Killing this window (typically by typing `exit` or `ctrl-D` at the prompt) will cause the vncserver to terminate and the original batch job to end. Because of this, we recommend that this window not be used for other purposes; it is just too easy to accidentally kill it and terminate the session.

	The other xterm window is black-on-white, and can be used to start both serial programs running on the node hosting the vncserver process, or parallel jobs running across the set of cores associated with the original batch job. Additional xterm windows can be created using the window-manager left-button menu.


