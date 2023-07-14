# Data Transfer and Management Guide
*Last update: June 15, 2023*

Transferring Portal data from your local machine to <a href="#storage">one of TACC's remote storage systems</a> can be accomplished using two methods: command line tools (<code>scp</code>, <code>sftp</code>, <code>rsync</code>) and graphical user interface (Cyberduck).

Table 1. Data Transfer Methods

<table>
<tr> <th>Usage Mode</th> <th>Transfer Method</th> </tr>
<tr> <td>Command Line Tool</td> <td> <a target="_blank" href="https://man7.org/linux/man-pages/man1/scp.1.html"><code>scp</code></a> </td> </tr>
<tr> <td>Command Line Tool</td> <td> <a target="_blank" href="https://man7.org/linux/man-pages/man1/sftp.1.html"><code>sftp</code></a> </td> </tr>
<tr> <td>Command Line Tool</td> <td> <a target="_blank" href="https://man7.org/linux/man-pages/man1/rsync.1.html"><code>rsync</code></a> </td> </tr>
<tr> <td>Graphical Tool</td> <td> <a target="_blank" href="https://cyberduck.io/">Cyberduck</a> </td> </tr>
</table>

<!-- ## What is TACC's Storage Server?

A TACC storage system is a logically defined resource designed to provide data storage and management capabilities to TACC portal users through the portal interface. Each portal is accessible over a URL path (e.g., <code><samp>sub.domain</samp>.tacc.utexas.edu</code>) which we will subsequently refer to as "host".

Storage systems can be configured for both normal and protected data (e.g., HIPAA) in a secured location, depending on the project requirements established for the portal. This location is exposed as a path to a directory on the secure system (e.g., <code>/<kbd>secure-server-root</kbd>/projects/<kbd>directory_name</kbd></code>) which this document will subsequently refer to as <code>/transfer/directory/path</code>.

Storage systems are to be used exclusively for transferring and accessing data through the portal.
-->

<!-- ## Prerequisites for Portal users

There are two prerequisites for accessing a portal and transferring data:

1. A TACC Account
1. [Multi-Factor Authentication (MFA) pairing](https://docs.tacc.utexas.edu/basics/mfa/)
        
All portal users will need to create a TACC account in the TACC User Portal (which can be accessed at <a target="_blank" href="https://portal.tacc.utexas.edu/">TACC Portal</a>.  If you have forgotten your TACC account credentials, please refer to your email for a message titled "TACC Account Request Confirmation" or use the TACC Portal's <a href="https://portal.tacc.utexas.edu/password-reset/-/password/">password reset form</a> or <a href="https://portal.tacc.utexas.edu/password-reset/-/password/forgot-username">username recovery form</a>.
      
Access to all TACC resources requires a completed Multi-Factor Authentication pairing with your TACC credentials. To set up MFA, please reference TACC Portal's <a href="https://portal.tacc.utexas.edu/tutorials/multifactor-authentication">Multi-Factor Authentication tutorial</a>.
-->

## Using Command Line Tools to Transfer and Organize Data

A common method of transferring files between TACC resources and/or your local machine is through the command line.

## <code>scp</code>, <code>sftp</code>, &amp; <code>rsync</code>

These three command line tools are secure and can be used to accomplish data transfer. You can run these commands directly from the terminal if your local system runs Linux or macOS.

!!! note
	It is possible to use these command line tools if your local machine runs Windows, but you will need to use a ssh client (ex.  <a target="_blank" href="https://www.putty.org/">PuTTY</a>
          ).
To simplify the data transfer process, it is recommended that Windows users follow the <a href="#cyberduck_transfer">How to Transfer Data with Cyberduck</a> guide as detailed below.
</blockquote>

For users that are new to the command line, using either <code>scp</code> or <code>sftp</code> to transfer data is advised.

## Prerequisites

Before beginning data transfer with command-line tools, you will need to know:

* the path to your data file(s) on your local system
* the path to your transfer directory on the remote storage server

## Determining the Path to Your Data File(s) on Your Local System

In order to transfer your project data, you will first need to know where the files are located on your local system.

To do so, navigate to the location of the files on your computer. This can be accomplished on a Mac by using the Finder application or on Windows with File Explorer application. Common locations for user data at the user's home directory, the Desktop and My Documents.
      
Once you have identified the location of the files, you can right-click on them and select either Get Info (on Mac) or Properties (on Windows) to view the path location on your local system.
      
### Figure 1. Use Get Info to determine "Where" the path of your data file(s) is

<figure id="figure1"><img src="../imgs/dtg-1-determine-path.png" /></a>
<figcaption> Figure 1. Use Get Info to determine "Where" the path of your data file(s) is</figcaption></figure>

For example, a file located in a folder named <kbd>portal-data</kbd> under <code>Documents</code> would have the following path:

<table>
<tr><td>On Mac</td><td><code>/Users/<kbd>username</kbd>/Documents/<kbd>portal-data</kbd>/my_file.txt</code></td></tr>
<dt>On Windows</dt>
<tr><td><code>\Users\<kbd>username</kbd>\My Documents\<kbd>portal-data</kbd>\my_file.txt</code></td></tr>
</table>

## Determining the Path to Your Transfer Directory

A transfer directory on the remote storage server associated with the portal you are accessing it through will be established when your account is given access to the portal and completes the on-boarding procedure. The transfer directory path will be unique for every institution and project.
      
<details class="small"><summary>Examples:</summary>
<code>/corral-secure/projects/A2CPS/submissions/utaustin/</code>
</details>
      
If you are unsure of your transfer directory path, please consult your project PI directly.
        
## How to Transfer Data with <code>scp</code>

<code>scp</code> copies files between hosts on a network. To transfer a file (ex. <code>my_file.txt</code>) to the remote secure system via <code>scp</code>, open a terminal on your local computer and navigate to the path where your data file is located.
      
<table>
<tr><td>On Mac</td> <td><pre style="max-width: 500px"><code><u>localhost$ </u>cd ~/Documents/<kbd>portal-data</kbd>/</code></pre></td></tr>
<tr><td>On Windows</td> <td><pre style="max-width: 500px"><code><u>localhost$ </u>cd %HOMEPATH%\Documents\<kbd>portal-data</kbd>\</code></pre></td></tr>
</table>

Assuming your TACC username is <code>jdoe</code> and you are affiliated with UT Austin, a <code>scp</code> transfer that pushes <code>my_file.txt</code> from the current directory of your local computer to the remote secure system would look like this:

This command will copy your data file directly to your individualized transfer directory on the remote storage system.

```cmd-line
localhost$ scp ./my_file.txt jdoe@host:/transfer/directory/path
```

<em>If you have not done so already, enter this command in your terminal, replacing the file name, TACC username, and your individualized transfer directory path appropriately.</em>

After entering the command, you will be prompted to login to the remote secure system by entering the password associated with your TACC account as well as the token value generated from your TACC token app.

A successful data transfer will generate terminal output similar to this:

<pre style="max-width: 500px"><samp>my_file.txt     100% ##  #.#          KB/s   ##:##</samp></pre>

If you wish to learn more about <code>scp</code> and how to synchronize your file transfer, you can do so <a target="_blank" href="https://man7.org/linux/man-pages/man1/scp.1.html">the online <code>man</code> page for <code>scp</code></a> or follow the file transfer section of the user guide for the appropriate TACC system:

* <a target="_blank" href="https://docs.tacc.utexas.edu/hpc/stampede2/#transferring-scp">Stampede2 User Guide</a>
* <a target="_blank" href="https://docs.tacc.utexas.edu/hpc/frontera/#transferring-scp">Frontera User Guide</a>
* <a target="_blank" href="https://https://docs.tacc.utexas.edu/hpc/lonestar6/#files-transferring-scp">Lonestar6 User Guide</a>

## Using<code>sftp</code>

<code>sftp</code> is a file transfer program that allows you to interactively navigate between your local file system and the remote secure system. To transfer a file (ex. <code>my_file.txt</code>) to the remote secure system via <code>sftp</code>, open a terminal on your local computer and navigate to the path where your data file is located.&nbsp;
      
<table>
<tr><td>On Mac</td><td><pre style="max-width: 500px"><code><u>localhost$ </u>cd ~/Documents/<kbd>portal-data</kbd>/</code></pre></td></tr>
<tr><td>On Windows</td><td><pre style="max-width: 500px"><code><u>localhost$ </u>cd %HOMEPATH%\Documents\<kbd>portal-data</kbd>\</code></pre></td></tr>
</table>

Assuming your TACC username is <code>jdoe</code> and you are affiliated with UT Austin, an <code>sftp</code> transfer that pushes <code>my_file.txt</code> from the current directory of your local computer to the remote secure system would look like this:
      
<pre style="max-width: 1500px"><code><u>localhost$ </u>sftp jdoe@<kbd>host</kbd>:<kbd>/transfer/directory/path</kbd>
<samp>Password:
TACC Token Code:
Connected to <var>host</var>.
Changing to:
  <var>/transfer/directory/path</var></samp>
<u>sftp&gt;</u></code></pre>

<blockquote>
If you have not done so already, enter this command in your terminal, replacing the TACC username and your individualized transfer directory path appropriately.
</blockquote>

      
You are now logged into the remote secure system and have been redirected to your transfer directory. To confirm your location on the server, enter the following command:
      

<pre style="max-width: 1000px"><code><u>sftp&gt; </u>pwd
<samp>Remote working directory:
<var>/transfer/directory/path</var></samp></code></pre>

To list the files currently in your transfer directory:

<pre style="max-width: 500px"><code><u>sftp&gt; </u>ls
<samp>utaustin_dir.txt<samp></code></pre>

      
To list the files currently in your <em>local</em> directory:
      
<pre style="max-width: 500px"><code><u>sftp&gt; </u>lls
<samp>my_file.txt<samp></code></pre>

!!! note
	The leading <code>l</code> in the <code>lls</code> command denotes that you are listing the contents of your <em>local</em> working directory.
      
To transfer <code>my_file.txt</code> from your local computer to your transfer directory:

<pre style="max-width: 1000px"><code><u>sftp&gt; </u>put my_file.txt
<samp>Uploading my_file.txt to <var>/transfer/directory/path</var></samp>
<samp>my_file.txt     100% ##  #.#          KB/s   ##:#</samp></code></pre>

      
To check if <code>my_file.txt</code> is in the <code>utaustin</code> subfolder:
      

<pre style="max-width: 500px"><code><u>sftp&gt; </u>ls
<samp>my_file.txt</samp>
<samp>utaustin_dir.txt</samp></code></pre>

To exit out of <code>sftp</code> on the terminal:

<pre style="max-width: 500px"><code><u>sftp&gt; </u>bye
<u>localhost1$</u></code></pre>

If you wish to learn more about <code>sftp</code>, you can do so at <a target="_blank" href="https://man7.org/linux/man-pages/man1/sftp.1.html">the online <code>man</code> page for <code>scp</code></a>.
      

## How to Transfer Data with <code>rsync</code>

      
<code>rsync</code>is a file copying tool that can reduce the amount of data transferred by sending only the differences between the source files on your local system and the existing files in your transfer directory. To transfer a file (ex. <code>my_file.txt</code>) to the remote secure system via <code>rsync</code>, open a terminal on your local computer and navigate to the path where your data file is located.
      
<table>
<tr><td>On Mac</td><td><pre style="max-width: 500px"><code><u>localhost$ </u>cd ~/Documents/<kbd>portal-data</kbd>/</code></pre></td></tr>
<tr><td>On Windows</td><td><pre style="max-width: 500px"><code><u>localhost$ </u>cd %HOMEPATH%\Documents\<kbd>portal-data</kbd>\</code></pre></td></tr>
</dl>
      
Assuming your TACC username is <code>jdoe</code> and you are affiliated with UT Austin, an <code>rsync</code> transfer that pushes <code>my_file.txt</code> from the current directory of your local computer to the remote secure system would look like this:
      
<pre style="max-width: 1000px"><code><u>localhost$ </u>rsync ./my_file.txt jdoe@<kbd>host</kbd>:<kbd>/transfer/directory/path</kbd></code></pre>

<blockquote>
If you have not done so already, enter this command in your terminal, replacing the TACC username and your individualized transfer directory path appropriately.
</blockquote>
      
If the command returns 0 in your terminal, the data transfer was successful.
      
If you wish to learn more about <code>rsync</code> and how to synchronize your file transfer, you can do so <a target="_blank" href="https://man7.org/linux/man-pages/man1/rsync.1.html">the online <code>man</code> page for <code>rsync</code></a> or follow the file transfer section of the user guide for the appropriate TACC system:
      

Consult your resource's respective user guide's "Transferring Files" section for more detailed information on the `scp` and `rsync` utilities:

* <a href="../hpc/stampede2/#transferring-rsync">Stampede2 User Guide</a>
* <a href="../hpc/lonestar6/#files-transferring-rsync">Lonestar6 User Guide</a>
* <a href="../hpc/frontera/#transferring-rsync">Frontera User Guide</a>

## How to Transfer Data with Cyberduck

<a target="_blank" href="https://cyberduck.io/">Cyberduck</a> is a free graphical user interface for data transfer and is an alternative to using the command line. With a drag-and-drop interface, it is easy to transfer a file from your local system to the remote secure system. You can use <a target="_blank" href="https://cyberduck.io/">Cyberduck</a> for Windows or macOS.


### [Windows]()

<a target="_blank" href="https://cyberduck.io/download/">Download and install Cyberduck for Windows</a> on your local machine.
      
Once installed, click "Open Connection" in the top left corner of your Cyberduck window.

<figure id="figure2"><img src="../imgs/dtg-2-open-connection-context.png" />
<figcaption>Figure 2. Windows Cyberduck and "Open Connection" setup screen<figcaption></figure>

To setup a connection, type in the server name, <kbd>host</kbd>. Add your TACC username and password in the spaces provided. If the "More Options" area is not shown, click the small triangle button to expand the window; this will allow you to enter the path to your transfer directory, <kbd>/transfer/directory/path</kbd>, so that when Cyberduck opens the connection you will immediately be in your individualized transfer directory on the system. Click the "Connect" button to open your connection.

Consult Figure 3. below to ensure the information you have provided is correct.  <em>If you have not done so already, replace the "Path" with the path to your individualized transfer directory.</em>

<figure id="figure3"><img src="../imgs/dtg-3-open-connection-modal.png" />
<figcaption>Figure 3. Windows "Open Connection" setup screen</figcaption></figure>

!!! note
	You will be prompted to "allow unknown fingerprint…" upon connection. Select "allow" and enter your TACC token value.

Once connected, you can navigate through your remote file hierarchy using the graphical user interface. You may also drag-and-drop files from your local computer into the Cyberduck window to transfer files to the system.
      
### [Mac]()

<a target="_blank" href="https://cyberduck.io/download/">Download and install Cyberduck for macOS</a> on your local machine.
      
Once installed, go to "Bookmark &gt; New Bookmark" to setup a connection.
      
!!! note
	You cannot select "Open Connection" in the top left corner of your Cyberduck window as macOS’ setup screen is missing the "More Options" button.
      
To setup a connection using "New Bookmark", type in the server name, <kbd>host</kbd>. Add your TACC username and password in the spaces provided. If the "More Options" area is not shown, click the small triangle or button to expand the window; this will allow you to enter the path to your transfer directory, <kbd>/transfer/directory/path</kbd>, so that when Cyberduck opens the connection you will immediately be in your individualized transfer directory on the system. As you fill out the information, Cyberduck will create the bookmark for you. Exit out of the setup screen and click on your newly created bookmark to launch the connection.
      
<figure id="figure4"><img src="../imgs/dtg-4-new-bookmark.png" />
<figcaption>Figure 4. macOS "New Bookmark" setup screen</figcaption></figure>
      
Consult Figure 4. above to ensure the information you have provided is correct.  <em>If you have not done so already, replace the "Path" with the path to your individualized transfer directory.</em>
      
!!! note
	You will be prompted to "allow unknown fingerprint…" upon connection. Select "allow" and enter your TACC token value.
      
Once connected, you can navigate through your remote file hierarchy using the graphical user interface. You may also drag-and-drop files from your local computer into the Cyberduck window to transfer files to the storage system.

<a target="_blank" href="https://cyberduck.io/">Cyberduck</a> is a free graphical user interface for data transfer and is an alternative to using the command line. With a drag-and-drop interface, it is easy to transfer a file from your local system to the remote secure system. You can use <a target="_blank" href="https://cyberduck.io/">Cyberduck</a> for Windows or macOS.
      
      
## <a href="#references">References</a> 

* [`scp` manual page](https://man7.org/linux/man-pages/man1/scp.1.html)
* [`sftp` manual page](https://man7.org/linux/man-pages/man1/sftp.1.html)
* [`rsync` manual page](https://man7.org/linux/man-pages/man1/rsync.1.html)
