## [Accessing the System](#access) { #access }

Access to all TACC systems now requires Multi-Factor Authentication (MFA). You can create an MFA pairing on the TACC User Portal. After login on the portal, go to your account profile (Home->Account Profile), then click the "Manage" button under "Multi-Factor Authentication" on the right side of the page. See [Multi-Factor Authentication at TACC][TACCMFA] for further information. 

### [Secure Shell (SSH)](#access-ssh) { #access-ssh }

The `ssh` command (SSH protocol) is the standard way to connect to Maverick2. SSH also includes support for the file transfer utilities `scp` and `sftp`. [Wikipedia](https://en.wikipedia.org/wiki/Secure_Shell) is a good source of information on SSH. SSH is available within Linux and from the terminal app in the Mac OS. If you are using Windows, you will need an SSH client that supports the SSH-2 protocol: e.g. [Bitvise](https://www.bitvise.com), [OpenSSH](http://www.openssh.com), [PuTTY](https://www.putty.org), or [SecureCRT](https://www.vandyke.com/products/securecrt/). Initiate a session using the `ssh` command or the equivalent; from the Linux command line the launch command looks like this:

```cmd-line
localhost$ ssh username@maverick2.tacc.utexas.edu
```

Use your TUP password for direct logins to Maverick2. **Only users with an allocation on Maverick2 may log on.** You can change your TACC password through the [TACC User Portal][TACCUSERPORTAL]. Log into the portal, then select "Change Password" under the "HOME" tab. If you've forgotten your password, go to the [TACC User Portal][TACCUSERPORTAL] home page and select "Password Reset" under the Home tab.

To report a connection problem, execute the `ssh` command with the `-vvv` option and include the verbose output when submitting a help ticket.


