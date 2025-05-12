# TACC Analysis Portal (TAP) 
*Last update: May 12, 2025*

The [TACC Analysis Portal][TACCANALYSISPORTAL] (TAP) provides simplified access to interactive sessions on TACC large-scale computing resources. TAP targets users who want the convenience of web-based portal access while maintaining control over low-level job behavior.  

Any user with an allocation on one of TACC's HPC Systems, e.g. Frontera, Stampede3, Lonestar6, has access to the TACC Analysis Portal.  TAP-Supported applications include:

* DCV remote desktop
* VNC remote desktop
* Jupyter Notebook[&#42;](#s3note)
* RStudio

<a id="s3note">
!!! important
	&#42;Stampede3 users see the [Jupyter Notebooks](/hpc/stampede3/#python-jupyter) section in the [Stampede3 User Guide][TACCSTAMPEDE3UG].


## Accessing the Portal { #access }

The [TACC Analysis Portal][TACCANALYSISPORTAL] is available to users with an allocation on any TACC HPC resource. Log in to TAP using the same username and password that you use to access the TACC User Portal. Once you've logged in you'll be directed to the Home Screen where you can begin scheduling jobs.

<figure id="figure1"><img alt="" src="../imgs/1TAP.png"><br />
<figcaption>Figure 1. TAP Home Screen</figcaption></figure>

## Job Management { #jobmanagement }

Submit, end and resubmit jobs on the TACC Analysis Portal.

### Submitting a Job using TAP { #jobmanagement-submit }

A TACC Analysis Portal job requires the following inputs:  <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;1&nbsp;)</span>

* **System:** where the job will run. The system selector drop-down will contain the TAP-supported TACC systems where you have an allocation. The system must be selected first, as the values of the other selectors are determined by the selected system.  
* **Application:** which application the job will run. The application selector will contain the applications available on the selected system.  
* **Project:** which project allocation to bill for the job run. The project selector will contain the projects associated with your account on the selected system.  
* **Queue:** which system queue will receive the job. The queue selector will contain the TAP-supported queues on the selected system.  
* **Nodes:** the number of nodes the job will occupy. We recommend leaving this setting at 1 unless you know you need more nodes. This is equivalent to the `-N` option in Slurm.  
* **Tasks:** the number of MPI tasks the job will use. We recommend leaving this setting at 1 unless you know you need more tasks. This is equivalent to the `-n` option in Slurm.  

A TAP job also accepts these additional optional inputs:  <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;2&nbsp;)</span>

* **Time Limit:** how long the job will run. If left blank, the job will use the TAP default runtime of 2 hours.  
* **Reservation:** the reservation in which to run the job. If you have a reservation on the selected system and want the job to run within that reservation, specify the name here.  
* **VNC Desktop Resolution:** desktop resolution for a VNC job. If this is left blank, a VNC job will use the default resolution of 1024x768.  

After specifying the job inputs, select the **Submit** <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;8&nbsp;)</span> &nbsp;button, and your job will be submitted to the remote system. After submitting the job, you will be automatically redirected to the job status page. You can get back to this page from the **Status** <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;3&nbsp;)</span> &nbsp;button. If the job is already running on the system, click the **Connect** <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;5&nbsp;)</span>&nbsp; button from the Home Screen or Job status to connect to your application.

<figure id="figure2"><img alt="" src="../imgs/2TAP.png"><br />
<figcaption>Figure 2. Job Status</figcaption></figure>

Click the "Check Status" button to update the page with the latest job status. The diagnostic information will include an estimated start time for the job if Slurm is able to provide one. Jobs submitted to development queues typically start running more quickly than jobs submitted to other queues. 


### Ending a Submitted Job { #jobmanagement-end }

When you are finished with your job, you can end your job using the **End** <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;4&nbsp;)</span>&nbsp; button on the TAP Home Screen page or on the Job Status page. Note that closing the browser window will not end the job. Also note that if you end the job from within the application (for example, pressing "Enter" in the red xterm in a DCV or VNC job), TAP will still show the job as running until you check status for the job, click "End Job" within TAP, or the requested end time of the job is reached.

### Resubmitting a Past Job { #jobmanagement-resubmit }

You can resubmit a past job using the **Resubmit** <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;7&nbsp;)</span>&nbsp;  button from the Home Screen page. The job will be submitted with the same inputs used for the past job, including any optional inputs. Select **Details**  <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;6&nbsp;)</span>&nbsp;  to see the inputs that were specified for the past job.

<figure id="figure3"><img alt="" src="../imgs/3TAP.png" style="width:50%;">
<figcaption>Figure 3. TAP Job Details</figcaption></figure>

## Utilities { #utilities }

TAP provides certain useful diagnostic and logistic utilities on the Utilities page. Access the Utilities page by selecting the **Utilities**  <span style="background-color:#FF7F00; color:#FFFFFF;">(&nbsp;9&nbsp;)</span>&nbsp;  button on the Home Screen page.

<figure id="figure4"><img alt="" src="../imgs/4TAP.png"><br />
<figcaption>Figure 4. TAP Utilities</figcaption></figure>


### Obtaining TACC Account Status { #utilities-status }

The Status section provides system information and diagnostics. "Check TACC Info" will show account balances and filesystem usage for the selected system. "Run Sanity Tool" performs a series of sanity checks to catch common account issues that can impact TAP jobs (for example, being over filesystem quota on your `$HOME` directory).
Configuring Jupyter Notebook

The Utilities section provides access to several common actions related to Jupyter Notebooks. "Use Python3" sets the TACC Python3 module as part of your default modules so that TAP will use Python3 for Jupyter Notebooks. If you want to use a non-default Python installation, such as Conda, you will need to install it yourself via the system command line. TAP will use the first "jupyter-notebook" command in your `$PATH`, so make sure that the command "which jupyter-notebook" returns the Jupyter Notebook you want to use. Conda install typically configures your environment so that Conda is first on your `$PATH`.

"Link `$WORK` from `$HOME`" and "Link `$SCRATCH` from `$HOME`" create symbolic links in your `$HOME` directory so that you can access `$WORK` and `$SCRATCH` from within a Jupyter Notebook. TAP launches Jupyter Notebooks from within your `$HOME` directory, so these other file systems are not reachable without such a linking mechanism. The links will show up as "WORK" and "SCRATCH" in the Jupyter file browser. You only need to create these links once and they will remain available for all future jobs.

### Setting a Remote Desktop to Full Screen Mode { #utilities-fullscreen }

Both DCV and VNC support full-screen mode. DCV will automatically adjust the desktop resolution to use the full screen, whereas VNC will keep the original desktop resolution within the full-screen view.

In DCV, click the Fullscreen button in the upper left corner of the DCV desktop.

<figure id="figure5"><img alt="" src="../imgs/5TAP.png"><br />
<figcaption>Figure 5. DCV Full Screen<figcaption></figure>


In VNC, open the control bar on the left side of the screen, then click the Fullscreen button.

<figure id="figure6"><img alt="" src="../imgs/6TAP.png"><br />
<figcaption>Figure 6. VNC Full Screen</figcaption></figure>

## Troubleshooting { #troubleshooting }

### No Allocation Available { #troubleshooting-noallocation }

If TAP cannot find an allocation for your account on a supported system, you will see the message below. If the issue persists, [create a ticket][HELPDESK] in the TACC Consulting System.

<figure id="figure7"><img alt="" src="../imgs/7TAP.png"><br />
<figcaption>Figure 7. TAP Error: No Allocation</figcaption></figure>


### Job Submission returns PENDING { #troubleshooting-pending }

If the job does not start immediately, TAP will load a status page with some diagnostic information. If the job status is "PENDING", the job was successfully submitted and has not yet started running. If Slurm can predict when the job will start, that information will be in the `squeue --start` output in the message window. Clicking the "Check Status" button will update the job status. When the job has started, TAP will show a "Connect" button.

<figure id="figure8"><img alt="" src="../imgs/8TAP.png"><br />
<figcaption>Figure 8. TAP Error: PENDING</figcaption></figure>


### Job Submission returns ERROR { #troubleshooting-error }

If the TAP status page shows that the job status is "ERROR", then there was an issue with the Slurm submission, and the message box will contain details. If you have difficulty interpreting the error message or resolving the issue, please create a ticket in the TACC Consulting System and include the TAP message.

<figure id="figure9"><img alt="" src="../imgs/9TAP.png"><br />
<figcaption>Figure 9. TAP "Error"</figcaption></figure>


{% include 'aliases.md' %}



