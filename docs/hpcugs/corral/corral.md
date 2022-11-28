<style>.help{box-sizing:border-box}.help *,.help *:before,.help *:after{box-sizing:inherit}.row{margin-bottom:10px;margin-left:-15px;margin-right:-15px}.row:before,.row:after{content:" ";display:table}.row:after{clear:both}[class*="col-"]{box-sizing:border-box;float:left;position:relative;min-height:1px;padding-left:15px;padding-right:15px}.col-1-5{width:20%}.col-2-5{width:40%}.col-3-5{width:60%}.col-4-5{width:80%}.col-1-4{width:25%}.col-1-3{width:33.3%}.col-1-2,.col-2-4{width:50%}.col-2-3{width:66.7%}.col-3-4{width:75%}.col-1-1{width:100%}article.help{font-size:1.25em;line-height:1.2em}.text-center{text-align:center}figure{display:block;margin-bottom:20px;line-height:1.42857143;border:1px solid #ddd;border-radius:4px;padding:4px;text-align:center}figcaption{font-weight:bold}.lead{font-size:1.7em;line-height:1.4;font-weight:300}.embed-responsive{position:relative;display:block;height:0;padding:0;overflow:hidden}.embed-responsive-16by9{padding-bottom:56.25%}.embed-responsive .embed-responsive-item,.embed-responsive embed,.embed-responsive iframe,.embed-responsive object,.embed-responsive video{position:absolute;top:0;bottom:0;left:0;width:100%;height:100%;border:0}</style>
# Corral User Guide
<span style="font-size:90%;"><i>Last update: November 24, 2021</i></span>  


## System Overview

Corral is a collection of storage and data management resources located at TACC, with 40PB of on-line storage located in the primary TACC datacenter, and a tape-based replica located in a secondary TACC datacenter for additional data protection.  Corral services provide high-reliability, high-performance storage for research requiring persistent access to large quantities of structured or unstructured data. Such data could include data used in analysis or other computational and visualization tasks on other TACC resources, as well as data used in collaborations involving many researchers who need to share large amounts of data.

PIs may request any quantity of storage across multiple allocations.  The first 5TB of storage for each PI, on one project, is available to researchers at all UT System institutions at no cost. For storage needs larger than 5TB, and for multiple project allocations, access to Corral is available at a cost of $118/TB/year.  There is also a limit of 200,000 files per allocated terabyte imposed on all Corral allocations - for example, if you are allocated 5TB of storage, you may store 1 million files within that 5TB, and if you need to store additional files you must request a larger allocation.  This policy is subject to change, and users with long-term storage needs are encouraged to plan for the costs of storing their data in future years.


### Available Services

There are two primary mechanisms for storing and managing data stored on Corral: simple file storage ("file system access" and the iRODS data management service. File system access is appropriate for users who will make use of their data on Lonestar6 or other TACC systems and are comfortable with UNIX command-line utilization, while the iRODS service is appropriate for users who have complex metadata associated with their data, users who wish to manage their data using web and/or GUI interfaces, and users who wish to develop a data collection for open web sharing. 

In addition, there are a variety of more specialized data management and sharing applications that may be supported on Corral, including open-source databases such as Postgres and MySQL, discipline- or data-specific web applications, and tools for generating metadata or other derivative file formats. Users are encouraged to contact the Data Management and Collections group at TACC <data@tacc.utexas.edu> to discuss specialized needs or to ask about specific applications.


### Consulting and Data Management Plans

The Data Management and Collections group at TACC can provide specialized consulting services to help make the best use of Corral, either for existing projects or for planned research tasks. The group can also assist with developing data management plans for research that would incorporate the use of Corral and other TACC resources as part of research and data management workflows. For more information or to inquire about such consulting services, please contact us at <data@tacc.utexas.edu>.


### Object/Cloud Storage on Corral

Corral can provide a cloud storage interface compatible with the S3 version 4 API, available only by request. If you wish to utilize the S3 interface to Corral, submit a request for the Corral resource as if you were requesting the usual file-based access, but add a note to your allocation request that you wish your storage to be accessible via the S3 API rather than the file system interface. If and when your allocation request is approved, a project-specific endpoint will be created and will be sent to you in lieu of a directory path.

For consult the [S3 API](http://docs.aws.amazon.com/AmazonS3/latest/API/Welcome.html) for further information.  

The S3 interface is most suitable for programmatic interaction from within custom applications. We recommend the minio client for command-line access and testing purposes. Documentation and download links for the minio client are available at: <https://docs.minio.io/docs/minio-client-complete-guide>. 

Please direct any further questions you may have regarding the cloud storage interface to Corral through the [TACC ticket system][CREATETICKET].

<figure><img alt="Corral4 Data Storage" src="../../../imgs/corral/Corral4.jpg" style="width: 800px; height: 530px; border-width: 1px; border-style: solid;" /> 
<figcaption>Figure 1. Corral4 Data Storage</figcaption></figure>


## System Access
Corral is available to researchers at all UT System campuses, including both academic and health institutions. Corral is intended to support research activities involving large quantities of data and/or complex data management requirements. There is no requirement that users have allocations on other TACC systems, and Corral can be utilized independently of TACC computational and visualization resources. All Corral users must have TACC accounts; if you do not yet have a TACC account you can create one on the [TACC user portal][TACCUSERPORTAL].

You may request an allocation on Corral through the TACC User Portal. When requesting an allocation, indicate the quantity of storage you expect to utilize in terabytes, the nature of the research project that will be supported through the use of Corral, and the service or services you expect to utilize. It is also helpful if you provide a suggested name for the directory or a collection name under which your data will be stored on Corral.  Once your allocation has been granted, you will receive an e-mail indicating the location of your data within iRODS and/or directly in the file system accessible from the Corral login/data movement nodes.


### Basic File System Access from Lonestar6 and Other TACC systems

The access mechanism you will use will be based on the specific service or services you request, and could include either or both command-line and graphical tools. Basic command-line access through SSH is provided on the login node: **`data.tacc.utexas.edu`**. This node is not suitable for significant computational or analysis tasks but is provided for use in transferring and organizing data through command-line utilities.

Users with the basic file system allocation type can directly access their data on Lonestar6 and the Corral login node, as well as most TACC system login nodes.  The full path to your project directory will be provided to you when your allocation is granted. The file system may be mounted on other systems within TACC at the discretion of the system administrators. Please submit a help ticket if you have questions about whether a system has Corral mounted or wish to request that it be mounted.

Note that while the Corral file systems are mounted on Lonestar6 compute nodes, the local Lustre `SCRATCH` and `WORK` file systems may provide better performance for compute jobs, and users are encouraged to incorporate staging of their data to and from the SCRATCH file systems in particular as part of their job scripts.


## Usage Policies

### "Category 1", HIPAA-PHI, and other restricted data types

Corral storage can be used for data subject to special security controls, such as HIPAA Personal Health Information and data subject to FERPA controls, but only in controlled circumstances after appropriate review and approval by both TACC and the organization or PI which owns the data. Users with sensitive data are REQUIRED to review and complete the forms referenced on the [TACC Protected Data Service](https://www.tacc.utexas.edu/protected-data-service) page to initiate the process of receiving a protected data allocation.  Corral-protected requests that are not accompanied by the required forms and documentation will be rejected without review. 


### Quotas

Corral group quotas will be set to the quantity each project has been allocated. Default quotas are set to 1TB for all groups without an allocation, thus it is important to ensure that your data is owned by the correct project group. 

There are no limitations on the size of files stored on Corral nor are there limits on the number of files per-directory; by default, there is a limit of 1 million files per 5TB allocated, but limited exceptions to allow for higher file counts can be granted on request. You may submit an exception request through the ticket system if your dataset will have exceptionally high file counts. Limitations on overall usage are set through quotas on the project group - once you go over the allocated limit, you will receive quota errors when trying to write new data or create new files on the file system. Quotas can also be set on a per-user basis if project PIs wish to control the usage of individuals within a research group.

When creating files on Corral, it is important that you be aware of your current Group Identity (GID), as this will control the sharing permissions and the project against which the data will be charged. You may use the command "<code>newgrp <i>groupname</i></code>" to change your effective GID before writing data, and you can check your default group either through the user portal or with the "`id`" command on any TACC system.


### Data Retention Policies

Files on Corral are never "purged" using automated processes, however each allocation lasts for only one year and must be renewed at the end of that year.  Once an allocation has expired, data will typically be retained for 6 months after the expiration of the allocation, however data may be deleted at any time at the discretion of the system administrators unless there is an allocation request pending. Important data should never be stored on only one system, and users are encouraged to maintain a second copy of their most important data on another system at TACC or elsewhere. 



## Transferring your Files to Corral

Data transfer mechanisms differ depending on whether you are using iRODS or basic file system access. For iRODS users, please see the iRODS user guide. Data transfer to and from the file system is described below.

**For Secure data:** All the instructions for SCP and Cyberduck as shown below can be used for transferring data to a secure location on Corral, however please substitute the hostname "`secure.corral.tacc.utexas.edu`" for "`data.tacc.utexas.edu`". You will be given access to this system when you are granted access to a secure Corral folder, and this system can be used exclusively for accessing your secure data area on Corral. Secure locations on Corral are not generally accessible from TACC data transfer and login nodes.

### Command-line data transfer

Data transfer from any Unix/Linux system can be accomplished using the `scp` utility to copy data to and from the login node. A file can be copied from your local system to the remote server using the command:

<pre class="cmd-line">login1$ <b>scp <i>filename</i> \
	 <i>username</i>@data.tacc.utexas.edu:/path/to/project/directory</b></pre>

Where <i>filename</i> is the path to the file on your local system, and the path is what was provided to you when your allocation was granted. While a whole directory can be copied recursively using the "`-r`" switch:

<pre class="cmd-line">login1$ <b>scp -r <i>directory</i> \
	<i>username</i>@data.tacc.utexas.edu:/<i>path/to/project/directory</i></b></pre>

Copying data from the Corral system to your local machine is similar, but reverse the order of the arguments:

<pre class="cmd-line">login1$ <b>scp <i>username</i>@data.tacc.utexas.edu:<i>/path/to/project/directory/filename</i> \
	 <i>/path/to/local/directory</i></b></pre>

The `scp` utility has many options and allows you to provide many defaults and other options in a configuration file to make transfers easier. Type "`man scp`" at the prompt to get extensive documentation of the options available for transferring files.


### Staging to and from Lonestar6 File Systems

If you are performing computational and analysis tasks on Lonestar6, and those tasks are I/O intensive, you may achieve improved performance by "staging" data to the Lonestar6 `$WORK` or `$SCRATCH` file systems before running a compute task. This is due to the use of the high-performance network of Lonestar6 for access to `$WORK` and `$SCRATCH`, as opposed to the slightly slower TCP/IP network used for access to Corral. The simplest way to stage a file is to copy it to your `$SCRATCH` directory before you submit your job:

<pre class="cmd-line">login1$ <b>cp /corral-repl/utexas/myproject/myfile $SCRATCH/job_directory/</b></pre>

The above example stages a single file. If you wish to stage a whole directory instead, use the "`-r`" switch to cp:

<pre class="cmd-line">
login1$ <b>cp -r /corral-repl/utexas/myproject/job_directory $SCRATCH/</b></pre>

When the job is completed, you may wish to copy the output data back to Corral:

<pre class="cmd-line">
login1$ <b>cp -r $SCRATCH/job_directory/output_files /corral-repl/utexas/myproject/job_directory</b></pre>

You can also include these staging commands as part of your job script itself; however, if you do so, be sure to account for the time required to copy data in your requested job time.


### Transferring Using Cyberduck

A wide variety of graphical tools are available that support the secure copy (SCP/SFTP) protocol; you may use whichever tool you prefer, but we recommend the open-source Cyberduck utility for both Mac and Windows users that do not already have a preferred tool. See examples below of configuring the Cyberduck utility for transferring data to TACC.  You may use the same parameters in any tool with similar functionality.

#### Cyberduck Configuration and Use

**<a href="http://download.cnet.com/Cyberduck/3000-2160_4-10246246.html">Download Cyberduck here</a>**

Click on the "Open Connection" button in the top right corner of the Cyberduck window to open a connection configuration window (as shown below) transfer mechanism, and type in the server name "`data.tacc.utexas.edu`". Add your username and password in the spaces provided, and if the "more options" area is not shown click the small triangle or button to expand the window; this will allow you to enter the path to your project area so that when Cyberduck opens the connection you will immediately see your data. Then click the "Connect" button to open your connection.

**Note that in addition to your account password, you will be prompted for your TACC token value and will need to have the [MFA pairing][TACCMFA] step completed to connect to the system.

Once connected, you can navigate through your remote file hierarchy using familiar graphical navigation techniques. You may also drag-and-drop files into and out of the Cyberduck window to transfer files to and from Corral.

<figure><img alt="Cyberduck-SSH" src="../../../imgs/corral/CorralCyberduck-1.jpg" style="width: 475px; height: 544px;" />
<figcaption>Figure 2. Cyberduck connection setup screen</figcaption></figure>


## Managing Files &amp; Permissions

It is crucial that users understand and utilize the available access controls on Corral and other storage systems. If permissions are not explicitly set on files added to this and other systems, the default permissions may allow anyone (or no one) to view that data. This represents a potential threat to the security and confidentiality of users' data, and can lead to additional time and effort later on as changing permissions after the fact can be very time-consuming, particularly in complex hierarchies. 

Both files and directories have permissions settings, and it is important to set permissions on both files and directories in order to secure the data and grant access to the right individuals. While TACC makes every effort to ensure the security of our systems and the data they store from unauthorized users, it is your responsibility to ensure that your data is protected from other authorized users of the system, and thus that only the right individuals have access to your data.

With this in mind, it is a good practice to explicitly set the permissions on new data at the end of each upload or data-generation session, using the "[`chmod`](#managing-chmod)" command or the permissions controls in a graphical client such as [Cyberduck](#cyberduck). This ensures that your data always has the right permissions, and that data is appropriately protected as soon as it is added to the system.

### Unix Permissions

Permissions on files and directories have 3 important categories, for each of which there are 3 levels of access that can be provided. The 3 categories are the owner, the group, and "other" meaning all users of the system. The 3 levels of access are read, write, and "execute" which allows a program to be run in the case of files or allows a directory's contents to be accessed in the case of directories or folders. Typically, users outside of your project group will not be able to access your files unless you explicitly allow them to do so. You can view the permissions for each file in a given directory by typing:

<pre class="cmd-line">login1$ <b>ls -l</b></pre>

within that directory, or 

<pre class="cmd-line">login1$ <b>ls -l /full/path/of/directory</b></pre>

at any time  

Permissions are shown as a set of three letters for each group, as in the following example line of output from "`ls -l`":

<pre>drwxrwxr-x 3 ctjordan G-802037 4096 Mar 6 10:08 mydirectory</pre>

In this example, the "`d`" at the front indicates that this is a directory, and it is **r**eadable and **w**ritable by the user and anyone in the user's group. Other users on the system can list the directory's contents but cannot write to it.

### Managing Files and Permissions using ACLs

For a more fine-grained approach to files and permissions, use **A**ccess **C**ontrol **L**ists or ACLs. With ACLS you can create customized groups of users with customized permissions.  Please consult TACC's document "<a href="https://portal.tacc.utexas.edu/tutorials/acls">Manage Permissions with Access Control Lists</a>" for detailed information.


### Managing Permissions with `chmod`

File permissions can be managed using the "`chmod`" command from the command-line prompt, and from the permissions window in [Cyberduck](#cyberduck). The permissions window is shown below, and can be accessed by right-clicking on a file or folder in Cyberduck and selecting "Info ..." from the menu. Other graphical fie transfer utilities may have a similar window or panel used to control permissions. The `chmod` command has a straightforward syntax:

<pre>chmod <i>permissions-to-change</i> <i>filename</i></pre>

where <i>permissions-to-change</i> can be any or all of "`u`" for user, "`g`" for group, and "`o`" for other, a "`+`" to add permissions or a minus, "`-`", to remove permissions, and the initials of permissions to add or removed, "`r`" for read, "`w`" for write, and "`x`" for execution. For example, to add read access for all users of the system the command would be:

<pre class="cmd-line">
login1$ <b>chmod o+r <i>filename</i></b></pre>

There are various shortcuts one can use to apply specific permissions, and the user is encouraged to read the documentation for the `chmod` command by typing "`man chmod`" at the command-line prompt. The `chown` command may also be of interest in understanding permissions, and full documentation can be read using "`man chown`".

<figure><img alt="Cyberduck-SSH" src="../../../imgs/corral/CorralCyberduck-2.jpg" style="width: 475px; height: 544px;" />
<figcaption>Figure 3. Cyberduck interface for setting permissions</figcaption></figure>

## Snapshots and File Retrieval

The Corral tape replica tracks active changes to the file system and is not intended to provide traditional backup and restore capabilities.  Instead, Corral4 creates snapshots, a catalog of the file system at a given point in time.  Snapshots are taken at the beginning of each week, to preserve the state of the file system for a short period of time, and to allow for retrieval of recent versions of data during a 14-day window. Should you accidentally delete a file or directory, you may request retrieval of the file via the TACC ticket system. This capability only applies to files which are present at the time snapshots are taken, and snapshots are retained for no longer than 14 days. Therefore if you create a file and then immediately delete it, or if you deleted a file more than two weeks ago, it will not be available through the snapshot facility. But in most cases where a file has been accidentally removed, or changed, and you request retrieval in a timely fashion, we can restore the state of the file at the time of the weekly snapshot.

This policy applies to both the main and "protected" areas of Corral4. 


## References

* [Manage Permissions with Access Control Lists](https://portal.tacc.utexas.edu/tutorials/acls)
* [Lonestar6 User Guide][LONESTAR6UG]  
* [iRODS][TACCIRODS]  
* [Cyberduck home page][CYBERDUCK]  
* [UNIX man pages](https://www.freebsd.org/cgi/man.cgi)

{% include 'aliases.md' %}
