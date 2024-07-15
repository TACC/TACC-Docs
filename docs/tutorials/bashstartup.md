# Bash Users' Startup Files: Quick Start Guide
*Last update: May 29, 2019*

While the startup behavior of the bash shell can seem to require a Ph.D in Shellology, here we try to simplify the discussion to the minimum required to get you started. In general, every time you interactively access a TACC resource, Bash will source either your `~/.profile` or `~/.bashrc` file.  Which one is sourced is complicated and not really important; see the troubleshooting notes below for some additional fine print.  In either case, to get the same behavior in all of the interactive shells, you'll need to have your `~/.profile` source the `~/.bashrc` and put all the important statements in your `~/.bashrc`.

```job-script
# ~/.profile

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi
```

One important idea is that every interactive sub-shell will source your `~/.bashrc`.  This means that if you wish to add personal directories to your `$PATH`, you'll only want do it once.  An environment variable (called `MYPATH` in the example) can be used to enforce this behavior:

```job-script
# ~/.bashrc            

if [ -z "$MYPATH" ]; then
	export MYPATH=1
	export PATH=$HOME/bin:$PATH
fi
```


A TACC user may wish to have many things defined every time on login such as:

* Certain modules loaded
* Define useful aliases and shell functions
* Add personal directories to `$PATH`.
* Set environment variables

Rather than describe all these steps here we have sample startup scripts that you can copy and modify to suit. They can be found on all machines in this location:

	/usr/local/startup_scripts/dot.*

Your account may already have these files, but if not run the following script:

```cmd-line
login1$ /usr/local/startup_scripts/install_default_scripts
```

Then edit your new `~/.bashrc` to suit yourself.

To test always have one terminal to edit and another terminal to test with.


## Troubleshooting { #troubleshooting }

* Your `~/.profile` is not read during a login shell.

	Check to see if your home directory contains `~/.bash_profile` or `~/.bash_login`.  For a login shell bash will search first for `~/.bash_profile`, if doesn't exist, then it searches for `~/.bash_login`. Finally it searches for a `~/.profile`.  Please pick one of the three and stick with that.


* For every sub-shell your path gets longer and longer.

	Check to see if you are changing the `$PATH` variable outside of a guarded if-block similar to the one above.

## Reference { #refs }

This quickstart guide covers the basics.  For more information please look at the web.  Here are two resources:

* [Bash Reference Manual](http://www.gnu.org/software/bash/manual/bashref.html#Bash-Startup-Files)
* [Shell Startup Scripts](http://blog.flowblok.id.au/2013-02/shell-startup-scripts.html)


