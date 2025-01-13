## Accessing the System { #access }

Access to all TACC systems requires Multi-Factor Authentication (MFA). You can create an MFA pairing under "Manage Account" in the TACC Portal.  See [Multi-Factor Authentication at TACC](../../basics/mfa) for further information.

!!! important
	You will be able to log on to Stampede3 **only if** you have an allocation on Stampede3, otherwise your password will be rejected.  
	Monitor your projects &amp; allocations the via the [TACC Portal](https://tacc.utexas.edu/portal/projects).

### Secure Shell (SSH) { #access-ssh }

The `ssh` command (Secure Shell, or SSH protocol) is the standard way to connect to Stampede3 and initiate a login session. SSH also includes support for the UNIX file transfer utilities `scp` and `sftp`.  These commands are available within Linux and the Terminal application within Mac OS. If you are using Windows, you will need a modern terminal application such as [Windows Terminal](https://apps.microsoft.com/detail/9N0DX20HK701?hl=en-US&gl=US), [MobaXterm](https://mobaxterm.mobatek.net/) or [Cyberduck](https://cyberduck.io/download/).  

Initiate an SSH session using the `ssh` command or the equivalent: 

	localhost$ ssh myusername@stampede3.tacc.utexas.edu

The above command will rotate connections across all available login nodes and route your connection to the next available node. 

!!! tip
	Stampede3's login nodes are a *shared resource*. See TACC's <a href="../../basics/conduct">Good Conduct Policy</a> for more information.


To connect to a specific login node, use its full domain name:

	localhost$ ssh myusername@login2.stampede3.tacc.utexas.edu

To connect with X11 support on Stampede3 (usually required for applications with graphical user interfaces), use the `-X` or `-Y` option:

	localhost$ ssh -X myusername@stampede3.tacc.utexas.edu

Use your TACC portal password for direct logins to TACC resources. You can change or reset your TACC password via the [TACC Portal][TACCUSERPORTAL] under "Manage Account".  To report a connection problem, execute the `ssh` command with the `-vvv` option and include this command's verbose output when submitting a help ticket.

Do not run the `ssh-keygen` command on Stampede3. This command will create and configure a key pair that will interfere with the execution of job scripts in the batch system.  If you do this by mistake, you can recover by renaming or deleting the `.ssh` directory located in your home directory; the system will automatically generate a new pair for you when you next log into Stampede3.

1. execute `mv .ssh dot.ssh.old`
1. log out
1. log into Stampede3 again

After logging in again, the system will generate a properly configured key SSH pair.

