## Accessing the System { #access }

Access to all TACC systems now requires Multi-Factor Authentication (MFA). You can create an MFA pairing on the TACC User Portal. After login on the portal, go to your account profile (Home->Account Profile), then click the "Manage" button under "Multi-Factor Authentication" on the right side of the page. See [Multi-Factor Authentication at TACC][TACCMFA] for further information. 

### Secure Shell (SSH) { #access-ssh }

The `ssh` command (SSH protocol) is the standard way to connect to Stampede2. SSH also includes support for the file transfer utilities `scp` and `sftp`. [Wikipedia](https://en.wikipedia.org/wiki/Secure_Shell) is a good source of information on SSH. SSH is available within Linux and from the terminal app in the Mac OS. If you are using Windows, you will need an SSH client that supports the SSH-2 protocol: e.g. [Bitvise](http://www.bitvise.com), [OpenSSH](http://www.openssh.com), [PuTTY](http://www.putty.org), or [SecureCRT](https://www.vandyke.com/products/securecrt/). Initiate a session using the `ssh` command or the equivalent; from the Linux command line the launch command looks like this:

``` cmd-line
localhost$ ssh myusername@stampede2.tacc.utexas.edu
```

The above command will rotate connections across all available login nodes and route your connection to one of them. To connect to a specific login node, use its full domain name:

``` cmd-line
localhost$ ssh myusername@login2.stampede2.tacc.utexas.edu
```

To connect with X11 support on Stampede2 (usually required for applications with graphical user interfaces), use the `-X` or `-Y` switch:

``` cmd-line
localhost$ ssh -X myusername@stampede2.tacc.utexas.edu
```

Use your TACC password for direct logins to TACC resources. You can change your TACC password through the [TACC User Portal][TACCUSERPORTAL]. Log into the portal, then select "Change Password" under the "HOME" tab. If you've forgotten your password, go to the [TACC User Portal][TACCUSERPORTAL] home page and select "Password Reset" under the Home tab.

To report a connection problem, execute the `ssh` command with the `-vvv` option and include the verbose output when submitting a help ticket.

**Do not run the `ssh-keygen` command on Stampede2.** This command will create and configure a key pair that will interfere with the execution of job scripts in the batch system. If you do this by mistake, you can recover by renaming or deleting the `.ssh` directory located in your home directory; the system will automatically generate a new one for you when you next log into Stampede2.

1. execute `mv .ssh dot.ssh.old` 
1. log out
1. log into Stampede2 again

After logging in again the system will generate a properly configured key pair.

