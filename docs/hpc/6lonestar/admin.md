## [Access the System](#access) { #access }

### [Secure Shell (SSH)](#access-ssh) { #access-ssh }

The `ssh` command (SSH protocol) is the standard way to connect to Lonestar6 (**`ls6.tacc.utexas.edu`**). SSH also includes support for the file transfer utilities `scp` and `sftp`. [Wikipedia](https://en.wikipedia.org/wiki/Secure_Shell) is a good source of information on SSH. SSH is available within Linux and from the terminal app in the Mac OS. If you are using Windows, you will need an SSH client that supports the SSH-2 protocol: e.g. [Bitvise](http://www.bitvise.com), [OpenSSH](http://www.openssh.com), [PuTTY](http://www.putty.org), or [SecureCRT](https://www.vandyke.com/products/securecrt/). Initiate a session using the `ssh` command or the equivalent; from the Linux command line the launch command looks like this:

```cmd-line
localhost$ ssh username@ls6.tacc.utexas.edu
```

The above command will rotate connections across all available login nodes, `login1-login3`, and route your connection to one of them. To connect to a specific login node, use its full domain name:

```cmd-line
localhost$ ssh username@login2.ls6.tacc.utexas.edu
```

To connect with X11 support on Lonestar6 (usually required for applications with graphical user interfaces), use the `-X` or `-Y` switch:

```cmd-line
localhost$ ssh -X username@ls6.tacc.utexas.edu
```

To report a connection problem, execute the `ssh` command with the `-vvv` option and include the verbose output when submitting a help ticket.
**Do not run the `ssh-keygen` command on Lonestar6.** This command will create and configure a key pair that will interfere with the execution of job scripts in the batch system. If you do this by mistake, you can recover by renaming or deleting the `.ssh` directory located in your home directory; the system will automatically generate a new one for you when you next log into Lonestar6.

1. execute `mv .ssh dot.ssh.old` 
1. log out
1. log into Lonestar6 again

After logging in again the system will generate a properly configured key pair.

Regardless of your research workflow, <b>you'll need to master Linux basics</b> and a Linux-based text editor (e.g. `emacs`, `nano`, `gedit`, or `vi/vim`) to use the system properly. However, this user guide does not address these topics. There are numerous resources in a variety of formats that are available to help you learn Linux<!-- , SDL including some listed on the <a href="https://xortal.tacc.utexas.edu/training/course-materials">TACC</a> and training sites-->. If you encounter a term or concept in this user guide that is new to you, a quick internet search should help you resolve the matter quickly.

## [Account Administration](#admin) { #admin }

### [Check your Allocation Status](#admin-allocations) { #admin-allocations }

**You must be added to a Lonestar6 allocation in order to have access/login to Lonestar6.** The ability to log on to the TACC User Portal does NOT signify access to Lonestar6 or any TACC resource. Submit Lonestar6 allocations requests via [TACC's Resource Allocation System](https://tacc-submit.xras.xsede.org/). Continue to [manage your allocation's users][TACCALLOCATIONS] via the TACC Portal. 

### [Multi-Factor Authentication](#admin-mfa) { #admin-mfa }

Access to all TACC systems now requires Multi-Factor Authentication (MFA). You can create an MFA pairing on the TACC User Portal. After login on the portal, go to your account profile (Home->Account Profile), then click the "Manage" button under "Multi-Factor Authentication" on the right side of the page. See [Multi-Factor Authentication at TACC](../../../tutorials/mfa) for further information. 

<!-- SDL 
### [Password Management](#admin-password) { #admin-password }

Use your TACC User Portal password for direct logins to TACC resources. You can change your TACC password through the [TACC User Portal](http://xortal.tacc.utexas.edu/). Log into the portal, then select "Change Password" under the "HOME" tab. If you've forgotten your password, go to the [TACC User Portal](http://xortal.tacc.utexas.edu/) home page and select "Password Reset" under the Home tab.

-->


### [Linux Shell](#admin-shell) { #admin-shell }

The default login shell for your user account is Bash. To determine your current login shell, execute: 

```cmd-line
$ echo $SHELL
```

If you'd like to change your login shell to `csh`, `sh`, `tcsh`, or `zsh`, [submit a helpdesk ticket][HELPDESK]. The `chsh` ("change shell") command will not work on TACC systems. 

When you start a shell on Lonestar6, system-level startup files initialize your account-level environment and aliases before the system sources your own user-level startup scripts. You can use these startup scripts to customize your shell by defining your own environment variables, aliases, and functions. These scripts (e.g. `.profile` and `.bashrc`) are generally hidden files: so-called dotfiles that begin with a period, visible when you execute: `ls -a`.

Before editing your startup files, however, it's worth taking the time to understand the basics of how your shell manages startup. Bash startup behavior is very different from the simpler `csh` behavior, for example. The Bash startup sequence varies depending on how you start the shell (e.g. using `ssh` to open a login shell, executing the `bash` command to begin an interactive shell, or launching a script to start a non-interactive shell). Moreover, Bash does not automatically source your `.bashrc` when you start a login shell by using `ssh` to connect to a node. Unless you have specialized needs, however, this is undoubtedly more flexibility than you want: you will probably want your environment to be the same regardless of how you start the shell. The easiest way to achieve this is to execute `source ~/.bashrc` from your `.profile`, then put all your customizations in `.bashrc`. The system-generated default startup scripts demonstrate this approach. We recommend that you use these default files as templates.

For more information see the [Bash Users' Startup Files: Quick Start Guide](../../../tutorials/bashstartup) and other online resources that explain shell startup. To recover the originals that appear in a newly created account, execute `/usr/local/startup_scripts/install_default_scripts`.

### [Environment Variables](#admin-envvars) { #admin-envvars }

Your environment includes the environment variables and functions defined in your current shell: those initialized by the system, those you define or modify in your account-level startup scripts, and those defined or modified by the [modules](#admin-modules) that you load to configure your software environment. Be sure to distinguish between an environment variable's name (e.g. `HISTSIZE`) and its value (`$HISTSIZE`). Understand as well that a sub-shell (e.g. a script) inherits environment variables from its parent, but does not inherit ordinary shell variables or aliases. Use `export` (in Bash) or `setenv` (in `csh`) to define an environment variable.

Execute the `env` command to see the environment variables that define the way your shell and child shells behave. 

Pipe the results of `env` into `grep` to focus on specific environment variables. For example, to see all environment variables that contain the string GIT (in all caps), execute:

```cmd-line
$ env | grep GIT
```

The environment variables `PATH` and `LD_LIBRARY_PATH` are especially important. `PATH` is a colon-separated list of directory paths that determines where the system looks for your executables. `LD_LIBRARY_PATH` is a similar list that determines where the system looks for shared libraries.

{% include './include/sanitytool.md' %}

TACC's `sanitytool` module loads an account-level diagnostic package that detects common account-level issues and often walks you through the fixes. You should certainly run the package's `sanitycheck` utility when you encounter unexpected behavior. You may also want to run `sanitycheck` periodically as preventive maintenance. To run `sanitytool`'s account-level diagnostics, execute the following commands:

```cmd-line
login1$ module load sanitytool
login1$ sanitycheck
```

Execute `module help sanitytool` for more information. -->

### [Using Modules to Manage your Environment](#admin-modules) { #admin-modules }

[Lmod](https://www.tacc.utexas.edu/research-development/tacc-projects/lmod), a module system developed and maintained at TACC, makes it easy to manage your environment so you have access to the software packages and versions that you need to conduct your research. This is especially important on a system like Lonestar6 that serves thousands of users with an enormous range of needs. Loading a module amounts to choosing a specific package from among available alternatives:

```cmd-line
$ module load intel          # load the default Intel compiler v19.1.14
$ module load intel/19.1.1   # load a specific version of the Intel compiler
```

A module does its job by defining or modifying environment variables (and sometimes aliases and functions). For example, a module may prepend appropriate paths to `$PATH` and `$LD_LIBRARY_PATH` so that the system can find the executables and libraries associated with a given software package. The module creates the illusion that the system is installing software for your personal use. Unloading a module reverses these changes and creates the illusion that the system just uninstalled the software:

```cmd-line
$ module load   netcdf  # defines DDT-related env vars; modifies others
$ module unload netcdf  # undoes changes made by load
```

The module system does more, however. When you load a given module, the module system can automatically replace or deactivate modules to ensure the packages you have loaded are compatible with each other. In the example below, the module system automatically unloads one compiler when you load another, and replaces Intel-compatible versions of IMPI and FFTW3 with versions compatible with gcc:

```cmd-line
$ module load intel  # load default version of Intel compiler
$ module load fftw3  # load default version of fftw3
$ module load gcc    # change compiler
```

Lmod is automatically replacing "intel/19.0.4" with "gcc/9.1.0".

Inactive Modules:
1) python2

Due to MODULEPATH changes, the following have been reloaded:
1) fftw3/3.3.8     2) impi/19.0.4

On Lonestar6, modules generally adhere to a TACC naming convention when defining environment variables that are helpful for building and running software. For example, the `papi` module defines `TACC_PAPI_BIN` (the path to PAPI executables), `TACC_PAPI_LIB` (the path to PAPI libraries), `TACC_PAPI_INC` (the path to PAPI include files), and `TACC_PAPI_DIR` (top-level PAPI directory). After loading a module, here are some easy ways to observe its effects:

```cmd-line
$ module show netcdf   # see what this module does to your environment
$ env | grep NETCDF    # see env vars that contain the string PAPI
$ env | grep -i netcdf # case-insensitive search for 'papi' in environment
```

To see the modules you currently have loaded:

```cmd-line
$ module list
```

To see all modules that you can load right now because they are compatible with the currently loaded modules:

```cmd-line
$ module avail
```

To see all installed modules, even if they are not currently available because they are incompatible with your currently loaded modules:

```cmd-line
$ module spider   # list all modules, even those not available to load
```

To filter your search:

```cmd-line
$ module spider netcdf             # all modules with names containing 'slep'
$ module spider netcdf/3.6.3       # additional details on a specific module
```

Among other things, the latter command will tell you which modules you need to load before the module is available to load. You might also search for modules that are tagged with a keyword related to your needs (though your success here depends on the diligence of the module writers). For example:

```cmd-line
$ module keyword performance
```

You can save a collection of modules as a personal default collection that will load every time you log into Lonestar6. To do so, load the modules you want in your collection, then execute:

```cmd-line
$ module save    # save the currently loaded collection of modules 
```

Two commands make it easy to return to a known, reproducible state:

```cmd-line
$ module reset   # load the system default collection of modules
$ module restore # load your personal default collection of modules
```

On TACC systems, the command `module reset` is equivalent to `module purge; module load TACC`. It's a safer, easier way to get to a known baseline state than issuing the two commands separately.

Help text is available for both individual modules and the module system itself:

```cmd-line
$ module help swr     # show help text for software package swr
$ module help         # show help text for the module system itself
```

See [Lmod's online documentation](http://lmod.readthedocs.org) for more extensive documentation. The online documentation addresses the basics in more detail, but also covers several topics beyond the scope of the help text (e.g. writing and using your own module files).

It's safe to execute module commands in job scripts. In fact, this is a good way to write self-documenting, portable job scripts that produce reproducible results. If you use `module save` to define a personal default module collection, it's rarely necessary to execute module commands in shell startup scripts, and it can be tricky to do so safely. If you do wish to put module commands in your startup scripts, see Lonestar6's default startup scripts for a safe way to do so.


