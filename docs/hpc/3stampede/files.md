## [Managing Your Files](#files) { #files }

Stampede3 mounts three file systems that are shared across all nodes: the home, work, and scratch file systems. Stampede3's startup mechanisms define corresponding account-level environment variables `$HOME`, `$SCRATCH`, and `$WORK` that store the paths to directories that you own on each of these file systems. Consult the Stampede3 File Systems table for the basic characteristics of these file systems, File Operations: I/O Performance for advice on performance issues, and Good Conduct for tips on file system etiquette.

### [Navigating the Shared File Systems](#files-filesystems) { #files-filesystems }

Stampede3's `/home` and `/scratch` file systems are mounted only on Stampede3, but the work file system mounted on Stampede3 is the Global Shared File System hosted on [Stockyard](https://tacc.utexas.edu/systems/stockyard/).  Stockyard is the same work file system that is currently available on Frontera, Lonestar6, and several other TACC resources.

The `$STOCKYARD` environment variable points to the highest-level directory that you own on the Global Shared File System. The definition of the `$STOCKYARD` environment variable is of course account-specific, but you will see the same value on all TACC systems that provide access to the Global Shared File System. This directory is an excellent place to store files you want to access regularly from multiple TACC resources.

Your account-specific `$WORK` environment variable varies from system to system and is a sub-directory of `$STOCKYARD` (Figure 1). The sub-directory name corresponds to the associated TACC resource. The `$WORK` environment variable on Stampede3 points to the `$STOCKYARD/stampede3` subdirectory, a convenient location for files you use and jobs you run on Stampede3. Remember, however, that all subdirectories contained in your `$STOCKYARD` directory are available to you from any system that mounts the file system. If you have accounts on both Stampede3 and Frontera, for example, the `$STOCKYARD/stampede3` directory is available from your Frontera account, and `$STOCKYARD/frontera` is available from your Stampede3 account.

!!! note 
	Your quota and reported usage on the Global Shared File System reflects **all files that you own on Stockyard**, regardless of their actual location on the file system.

See the example for fictitious user bjones in the figure below.  All directories are accessible from all systems, however a given sub-directory (e.g. lonestar6, frontera) will exist only if you have an allocation on that system.  [Figure 1](#figure1) below illustrates account-level directories on the `$WORK` file system (Global Shared File System hosted on Stockyard).   

<figure id="#figure1"><img src="../imgs/Stockyard2024.png">
<figcaption>Stockyard 2024</figcaption></figure>

Note that the resource-specific sub-directories of `$STOCKYARD` are nothing more than convenient ways to manage your resource-specific files. You have access to any such sub-directory from any TACC resources. If you are logged into Stampede3, for example, executing the alias cdw (equivalent to cd `$WORK`) will take you to the resource-specific sub-directory `$STOCKYARD/stampede3`. But you can access this directory from other TACC systems as well by executing cd `$STOCKYARD/stampede3`. These commands allow you to share files across TACC systems. In fact, several convenient account-level aliases make it even easier to navigate across the directories you own in the shared file systems:

### [Table 6. Built-in Account Level Aliases](#table6) { #table6 }

Alias | Command
--- | ---
`cd` or `cdh` | `cd $HOME`
`cdw` | `cd $WORK`
`cds` | `cd $SCRATCH`
`cdy` or `cdg` | `cd $STOCKYARD`


### [Sharing Files with Collaborators](#files-sharing) { #files-sharing }

If you wish to share files and data with collaborators in your project, see [Sharing Project Files on TACC Systems](../../tutorials/sharingprojectfiles) for step-by-step instructions. Project managers or delegates can use Unix group permissions and commands to create read-only or read-write shared workspaces that function as data repositories and provide a common work area to all project members.

