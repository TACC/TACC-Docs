## Account Administration { #admin }

This section explores ways to configure and manage your Linux account on Stampede3.  Stampede3 nodes run Rocky Linux. Regardless of your research workflow, you'll likely need to master Linux command-line basics along with a Linux-based text editor (e.g. `emacs`, `nano`, `gedit`, or `vi`/`vim`) to use the system properly. If you encounter a term or concept in this user guide that is new to you, a quick internet search should help you resolve the matter quickly.

### Allocation Status { #admin-allocation }

If your password is rejected while attempting to log in, it's possible your account or project has not been added to a Stampede3 allocation.  You can list and manage your allocations via the [TACC Portal](https://tacc.utexas.edu/portal/projects).  

### Linux Shell { #admin-linux }

The default login shell for your user account is Bash. To determine your current login shell, examine the contents of the `$SHELL` environment variable: 

```cmd-line
$ echo $SHELL
```

!!! tip
	If you'd like to change your login shell to `csh`, `tcsh`, or `zsh`, [submit a help ticket][HELPDESK]. 
	The `chsh` ("change shell") command will not work on TACC systems.

When you start a shell on Stampede3, system-level startup files initialize your account-level environment and aliases before the system sources your own user-level startup scripts. You can use these startup scripts to customize your shell by defining your own environment variables, aliases, and functions. These scripts (e.g. `.profile` and `.bashrc`) are generally hidden files: so-called "dotfiles" that begin with a period, visible when you execute: `ls -a`.

Before editing your startup files, however, it's worth taking the time to understand the basics of how your shell manages startup. Bash startup behavior is very different from the simpler `csh` behavior, for example. The Bash startup sequence varies depending on how you start the shell (e.g. using `ssh` to open a login shell, executing the `bash` command to begin an interactive shell, or launching a script to start a non-interactive shell). Moreover, Bash does not automatically source your `.bashrc` file when you start a login shell by using `ssh` to connect to a node. Unless you have specialized needs, however, this is undoubtedly more flexibility than you want: you will probably want your environment to be the same regardless of how you start the shell. The easiest way to achieve this is to execute `source ~/.bashrc` from your `.profile`, then put all your customizations in your `.bashrc` file. The system-generated default startup scripts demonstrate this approach. We recommend that you use these default files as templates.

For more information see the [Bash Users' Startup Files: Quick Start Guide][TACCBASHQUICKSTART] and other online resources that explain shell startup. To recover the originals that appear in a newly created account, execute `/usr/local/startup_scripts/install_default_scripts`.

### Diagnostics { #admin-diagnostics }

TACC's `sanitytool` module loads an account-level diagnostic package that detects common account-level issues and often walks you through the fixes. You should certainly run the package's `sanitycheck` utility when you encounter unexpected behavior. You may also want to run `sanitycheck` periodically as preventive maintenance. To run `sanitytool`'s account-level diagnostics, execute the following commands:

```cmd-line
login1$ module load sanitytool
login1$ sanitycheck
```

Execute `module help sanitytool` for more information.

### Environment Variables { #admin-envvars }

Your environment includes the environment variables and functions defined in your current shell: those initialized by the system, those you define or modify in your account-level startup scripts, and those defined or modified by the modules that you load to configure your software environment. Be sure to distinguish between an environment variable's name (e.g. `HISTSIZE`) and its value (`$HISTSIZE`). Understand as well that a sub-shell (e.g. a script) inherits environment variables from its parent, but does not inherit ordinary shell variables or aliases. Use `export` (in Bash) or `setenv` (in `csh`) to define an environment variable.

Execute the `env` command to see the environment variables that define the way your shell and child shells behave.
Pipe the results of `env` into `grep` to focus on specific environment variables. For example, to see all environment variables that contain the string GIT (in all caps), execute:
	
```cmd-line
$ env | grep GIT
```

The environment variables `PATH` and `LD_LIBRARY_PATH` are especially important. The `PATH` is a colon-separated list of directory paths that determines where the system looks for your executables.  The `LD_LIBRARY_PATH` environment variable is a similar list that determines where the system looks for shared libraries.


### Using Modules { #admin-modules }

Lmod, a module system developed and maintained at TACC, makes it easy to manage your environment so you have access to the software packages and versions that you need to using your research. This is especially important on a system like Stampede3 that serves thousands of users with an enormous range of needs and software. Loading a module amounts to choosing a specific package from among available alternatives:

```cmd-line
$ module load intel          # load the default Intel compiler
$ module load intel/24.0.0   # load a specific version of Intel compiler
```

A module does its job by defining or modifying environment variables (and sometimes aliases and functions). For example, a module may prepend appropriate paths to `$PATH` and `$LD_LIBRARY_PATH` so that the system can find the executables and libraries associated with a given software package. The module creates the illusion that the system is installing software for your personal use. Unloading a module reverses these changes and creates the illusion that the system just uninstalled the software:

```cmd-line
$ module load   ddt  # defines DDT-related env vars; modifies others
$ module unload ddt  # undoes changes made by load
```

The module system does more, however. When you load a given module, the module system can automatically replace or deactivate modules to ensure the packages you have loaded are compatible with each other. In the example below, the module system automatically unloads one compiler when you load another, and replaces Intel-compatible versions of IMPI and PETSc with versions compatible with `gcc`:

```cmd-line
$ module load intel  # load default version of Intel compiler
$ module load petsc  # load default version of PETSc
$ module load gcc    # change compiler

Lmod is automatically replacing "intel/24.0.0" with "gcc/13.2.0".

Due to MODULEPATH changes, the following have been reloaded:
1) impi/21.11     2) petsc/3.8
```

!!! tip
	See [Lmod's documentation](https://lmod.readthedocs.io/en/latest/) for extensive information. The online documentation addresses the basics in more detail, but also covers several topics beyond the scope of the help text (e.g. writing and using your own module files).

On Stampede3, modules generally adhere to a TACC naming convention when defining environment variables that are helpful for building and running software. For example, the papi module defines `TACC_PAPI_BIN` (the path to PAPI executables), `TACC_PAPI_LIB` (the path to PAPI libraries), `TACC_PAPI_INC` (the path to PAPI include files), and `TACC_PAPI_DIR` (top-level PAPI directory). After loading a module, here are some easy ways to observe its effects:

```cmd-line
$ module show papi   # see what this module does to your environment
$ env | grep PAPI    # see env vars that contain the string PAPI
$ env | grep -i papi # case-insensitive search for 'papi' in environment
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
$ module spider                  # list all modules, even those not available to load
```

To filter your search:

```cmd-line
$ module spider slep             # all modules with names containing 'slep'
$ module spider sundials/2.5.0   # additional details on a specific module
```

Among other things, the latter command will tell you which modules you need to load before the module is available to load. You might also search for modules that are tagged with a keyword related to your needs (though your success here depends on the diligence of the module writers). For example:

```cmd-line
$ module keyword performance
```

You can save a collection of modules as a personal default collection that will load every time you log into Stampede3. To do so, load the modules you want in your collection, then execute:

```cmd-line
$ module save            # save the currently loaded collection of modules
```

Two commands make it easy to return to a known, reproducible state:

```cmd-line
$ module reset           # load the system default collection of modules
$ module restore         # load your personal default collection of modules
```

On TACC systems, the command `module reset` is equivalent to `module purge; module load` TACC. It's a safer, easier way to get to a known baseline state than issuing the two commands separately.

Help text is available for both individual modules and the module system itself:

```cmd-line
$ module help swr        # show help text for software package swr
$ module help            # show help text for the module system itself
```

It's safe to execute module commands in job scripts. In fact, this is a good way to write self-documenting, portable job scripts that produce reproducible results.  If you use `module save` to define a personal default module collection, it's rarely necessary to execute module commands in shell startup scripts, and it can be tricky to do so safely. If you do wish to put module commands in your startup scripts, see Stampede3's default startup scripts in `/usr/local/startup_scripts` for a safe way to do so.

{% include 'include/stampede3-crontab.md' %}

{% include 'include/tacctips.md' %}
