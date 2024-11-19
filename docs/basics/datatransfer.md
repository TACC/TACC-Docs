# Data Transfer { #datatransfer }
*Last update: August 15, 2024*

This guide will outline and instruct methods of transferring data between TACC resources and and your local machine.  Transfer methods generally fall into two categories:

1. Command-line (CLI) tools e.g. `scp`, `sftp`, `rsync`
1. Graphical User Interface (GUI) tools, e.g. [Globus](#globus), Cyberduck

## Command-Line Tools  { #cli }

A common method of transferring files between TACC resources and/or your local machine is through the command line.  Whether on a Windows or a Mac, open the terminal applicaton on your local laptop to use one of the following Unix command-line (CLI) tools.

These three command line tools are secure and can be used to accomplish data transfer. You can run these commands directly from the terminal if your local system runs Linux or macOS:  `scp`, `sftp`, &amp; `rsync`

!!! note
	It is possible to use these command line tools if your local machine runs Windows, but you will need to use a ssh client (ex.  <a target="_blank" href="https://www.putty.org/">PuTTY</a>).

To simplify the data transfer process, we recommend that Windows users follow the <a href="#datatransfer-cyberduck">How to Transfer Data with Cyberduck</a> guide as detailed below.

### Determining Paths { #cli-paths }

Before beginning data transfer with command-line tools, you will need to know:

* the path to your data file(s) on your local system
* the path to your transfer directory on the remote system

In order to transfer your project data, you will first need to know where the files are located on your local system.

To do so, navigate to the location of the files on your computer. This can be accomplished on a Mac by using the Finder application or on Windows with File Explorer application. Common locations for user data at the user's home directory, the Desktop and My Documents.
      
Once you have identified the location of the files, you can right-click on them and select either Get Info (on Mac) or Properties (on Windows) to view the path location on your local system.
      
Figure 1. Use Get Info to determine "Where" the path of your data file(s) is

<figure id="figure1"><img src="../imgs/dtg-1-determine-path.png" /></a>
<figcaption> Figure 1. Use Get Info to determine "Where" the path of your data file(s) is</figcaption></figure>

For example, a file located in a folder named portal-data under `Documents` would have the following path:

<table>
<tr><td>On Mac</td><td>/Users/username/Documents/portal-data/my_file.txt</td></tr>
<dt>On Windows</dt>
<tr><td>\Users\username\My Documents\portal-data\my_file.txt</td></tr>
</table>

### Transfer with `scp` { #cli-scp }

The `scp` command copies files between hosts on a network. To transfer a file (ex. `my_file.txt`) to the remote secure system via `scp`, open a terminal on your local computer and navigate to the path where your data file is located.
      
<table>
<tr><td>On Mac</td> <td>localhost$ cd ~/Documents/portal-data/</td></tr>
<tr><td>On Windows</td> <td>localhost$ cd %HOMEPATH%\Documents\portal-data\</td></tr>
</table>

Assuming your TACC username is `bjones` and you are affiliated with UT Austin, a `scp` transfer that pushes `my_file.txt` from the current directory of your local computer to the remote secure system would look like this:

This command will copy your data file directly to your individualized transfer directory on the remote storage system.

```cmd-line
localhost$ scp ./my_file.txt bjones@host:/transfer/directory/path
```

*If you have not done so already, enter this command in your terminal, replacing the file name, TACC username, and your individualized transfer directory path appropriately.*

After entering the command, you will be prompted to login to the remote secure system by entering the password associated with your TACC account as well as the token value generated from your TACC token app.

A successful data transfer will generate terminal output similar to this:

```syntax
my_file.txt     100% ##  #.#          KB/s   ##:##g
```

### Transfer with `sftp` { #cli-sftp }

`sftp` is a file transfer program that allows you to interactively navigate between your local file system and the remote secure system. To transfer a file (ex. `my_file.txt`) to the remote secure system via `sftp`, open a terminal on your local computer and navigate to the path where your data file is located.&nbsp;
      
<table>
<tr><td>On Mac</td><td>localhost$ cd ~/Documents/portal-data/</td></tr>
<tr><td>On Windows</td><td>localhost$ cd %HOMEPATH%\Documents\portal-data\</td></tr>
</table>

Assuming your TACC username is `bjones` and you are affiliated with UT Austin, an `sftp` transfer that pushes `my_file.txt` from the current directory of your local computer to the remote secure system would look like this:
      
```cmd-line
localhost$ sftp bjones@host:/transfer/directory/path
Password:
TACC Token Code:
Connected to host.
Changing to:
  /transfer/directory/path
sftp>
```

If you have not done so already, enter this command in your terminal, replacing the TACC username `bjones` and your individualized transfer directory path appropriately.
      
Once you've logged into the remote secure system and have been redirected to your transfer directory, confirm your location on the server:

```cmd-line
sftp> pwd
Remote working directory:
/transfer/directory/path
```

To list the files currently in your transfer directory:

```cmd-line
sftp> ls
utaustin_dir.txt
```
      
To list the files currently in your *local* directory:
      
```cmd-line
sftp> lls
my_file.txt
```

!!! tip
	The leading `l` in the `lls` command denotes that you are listing the contents of your *local* working directory.
      
To transfer `my_file.txt` from your local computer to your transfer directory:

```cmd-line
sftp> put my_file.txt
Uploading my_file.txt to /transfer/directory/path
my_file.txt     100% ##  #.#          KB/s   ##:#
```

To check if `my_file.txt` is in the `utaustin` subfolder:
      

```cmd-line
sftp> ls
my_file.txt
utaustin_dir.txt
```

To exit out of `sftp` on the terminal:

```cmd-line
sftp> bye
localhost1$
```

If you wish to learn more about `sftp`, you can do so at <a target="_blank" href="https://man7.org/linux/man-pages/man1/sftp.1.html">the online man page for scp</a>.
      

### Transfer with `rsync` { #cli-rsync }
      
`rsync`is a file copying tool that can reduce the amount of data transferred by sending only the differences between the source files on your local system and the existing files in your transfer directory. To transfer a file (ex. `my_file.txt`) to the remote secure system via `rsync`, open a terminal on your local computer and navigate to the path where your data file is located.
      
<table>
<tr><td>On Mac</td><td>localhost$ cd ~/Documents/portal-data/</td></tr>
<tr><td>On Windows</td><td>localhost$ cd %HOMEPATH%\Documents\portal-data\</td></tr>
</table>
      
Assuming your TACC username is `bjones` and you are affiliated with UT Austin, an `rsync` transfer that pushes `my_file.txt` from the current directory of your local computer to the remote secure system would look like this:
      
```cmd-line
localhost$ rsync ./my_file.txt bjones@host:/transfer/directory/path
```

If you have not done so already, enter this command in your terminal, replacing the TACC username and your individualized transfer directory path appropriately.
      
If the command returns 0 in your terminal, the data transfer was successful.
      
If you wish to learn more about `rsync` and how to synchronize your file transfer, you can do so <a target="_blank" href="https://man7.org/linux/man-pages/man1/rsync.1.html">the online `man` page for `rsync`</a> or follow the file transfer section of the user guide for the appropriate TACC system:
      
### References { #clirefs }

* [`scp` manual page](https://man7.org/linux/man-pages/man1/scp.1.html)
* [`sftp` manual page](https://man7.org/linux/man-pages/man1/sftp.1.html)
* [`rsync` manual page](https://man7.org/linux/man-pages/man1/rsync.1.html)
* <a target="_blank" href="https://cyberduck.io/">Cyberduck</a> </td> </tr>

Consult your respective resource user guide's "Transferring Files" section for specific examples using the `scp` and `rsync` utilities:

* <a href="../hpc/stampede3/#transferring-rsync">Stampede3 User Guide</a>
* <a href="../hpc/lonestar6/#files-transferring-rsync">Lonestar6 User Guide</a>
* <a href="../hpc/frontera/#transferring-rsync">Frontera User Guide</a>


<!-- ## GUI Tools { #datatransfer-cli-gui } -->

## Cyberduck { #datatransfer-cyberduck }

<a target="_blank" href="https://cyberduck.io/">Cyberduck</a> is a free graphical user interface for data transfer and is an alternative to using the command line. With a drag-and-drop interface, it is easy to transfer a file from your local system to the remote secure system. You can use <a target="_blank" href="https://cyberduck.io/">Cyberduck</a> for Windows or macOS.

<a target="_blank" href="https://cyberduck.io/download/">Download and install Cyberduck for Windows</a> on your local machine.

### Windows { #datatransfer-windows } 

Once installed, click "Open Connection" in the top left corner of your Cyberduck window.

<figure id="figure2"><img src="../imgs/dtg-2-open-connection-context.png" />
<figcaption>Figure 2. Windows Cyberduck and "Open Connection" set up screen<figcaption></figure>

To set up a connection, type in the server name, host. Add your TACC username and password in the spaces provided. If the "More Options" area is not shown, click the small triangle button to expand the window; this will allow you to enter the path to your transfer directory, `/transfer/directory/path`, so that when Cyberduck opens the connection you will immediately be in your individualized transfer directory on the system. Click the "Connect" button to open your connection.

Consult Figure 3. below to ensure the information you have provided is correct.  *If you have not done so already, replace the "Path" with the path to your individualized transfer directory.*

<figure id="figure3"><img src="../imgs/dtg-3-open-connection-modal.png" />
<figcaption>Figure 3. Windows "Open Connection" set up screen</figcaption></figure>

You will be prompted to "allow unknown fingerprint…" upon connection. Select "allow" and enter your TACC token value.  Once connected, you can navigate through your remote file hierarchy using the graphical user interface. You may also drag-and-drop files from your local computer into the Cyberduck window to transfer files to the system.
      
#### Mac { datatransfer-mac }

Once installed, go to "Bookmark &gt; New Bookmark" to set up a connection.
      
!!! note
	You cannot select "Open Connection" in the top left corner of your Cyberduck window as macOS' set up screen is missing the "More Options" button.
      
To set up a connection using "New Bookmark", type in the server name, host. Add your TACC username and password in the spaces provided. If the "More Options" area is not shown, click the small triangle or button to expand the window; this will allow you to enter the path to your transfer directory, /transfer/directory/path, so that when Cyberduck opens the connection you will immediately be in your individualized transfer directory on the system. As you fill out the information, Cyberduck will create the bookmark for you. Exit out of the set up screen and click on your newly created bookmark to launch the connection.
      
<figure id="figure4"><img src="../imgs/dtg-4-new-bookmark.png" width="75%">
<figcaption>Figure 4. macOS "New Bookmark" set up screen</figcaption></figure>
      
Consult Figure 4. above to ensure the information you have provided is correct.  *If you have not done so already, replace the "Path" with the path to your individualized transfer directory.*
      
!!! note
	You will be prompted to "allow unknown fingerprint" upon connection. Select "allow" and then enter your TACC token value.
      
Once connected, you can navigate through your remote file hierarchy using the graphical user interface. You may also drag-and-drop files from your local computer into the Cyberduck window to transfer files to the storage system.

## UTBox and other Third-Party Storage Services { #datatransfer-thirdparty }

Unfortunately TACC does not allow direct access from UT Box or other third-party storage services such as Dropbox, Google or Amazon storage services. To transfer files from one of these services:

1. Manually download the files from one of these services to your laptop
2. Using one of the tools outlined in this document (e.g. `scp` or Cyberduck), upload the files from your laptop to the desired TACC resource (e.g. Stampede3, Frontera).

If you have files stored at another university, see the [Globus instructions](#globus) below.

---

{% include 'basics/globusdatatransfer.md' %}
