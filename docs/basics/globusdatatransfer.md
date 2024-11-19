## Globus Data Transfer Guide { #globus }
Last update: *August 30, 2024*

Globus supplies high speed, reliable, asynchronous transfers to the portal. Globus is fast, for large volumes of data, as it uses multiple network sockets simultaneously to transfer data. It is reliable for large numbers of directories and files, as it can automatically fail and restart itself, and will only notify you when the transfers are completed successfully.

This document leads you through the steps required to set up Globus to use for the first time. Several steps will need to be repeated each time you set up a new computer to use Globus for the portal. Once you are set up, you can use Globus not only for transfers to and from the portal, but also to access other cyberinfrastructure resources at TACC and around the world.

To start using Globus, you need to do two things: Generate a unique identifier, an ePPN (an acronym-to not-worry-about), for all Globus services, and enroll the machine you are transferring data to/from with Globus.  This can be your personal laptop or desktop, or a server to which you have access. Follow this one-time process to set up the Globus file transfer capability.

!!! tip
	ePPN is an unfortunate acronym for "**e**du**P**erson**P**rincipal**N**ame", an identifier indicating a unique person within an LDAP schema.  


!!! Note 
	**Globus Transition**. Globus has transitioned to version 5.4. This transition impacts all TACC researchers who use Globus and requires you to update your profile with an ePPN to continue using the Globus service. The use of "Distinguished Names", or DNs, is no longer supported.

!!! important 
	You must use your institution's credentials and **not your personal email account (e.g. Google, Yahoo!, Hotmail)** when setting up Globus.  You will encounter problems with the transfer endpoints (e.g. Frontera, Stampede3, Corral, Ranch) if you use your personal account information.


### Step 1. **Retrieve your Unique ePPN**.  { #step1 }

**Retrieve your Unique ePPN**.  Login to [CILogon](https://cilogon.org) and click on "User Attributes".  Make note of your ePPN.

<figure id="figure1">
<img src="../imgs/globus-CIlogin.png" style="width:65%"> 
<figcaption>Figure 1. Make note of your ePPN</figcaption>
</figure>

### Step 2. **Associate your EPPN with your TACC Account.**  { #step2 }

**Associate your EPPN with your TACC Account.**  Login to your [TACC user profile](https://accounts.tacc.utexas.edu), click "Account Information" in the left-hand menu, then add or edit your ePPN from Step 1.

!!! important
	If you update your ePPN, please allow up to 2 hours for the changes to propagate across the systems.


<figure>
<img src="../imgs/globus-setup-step2.png" style="width:65%">
<figcaption>Figure 2. Update your TACC user profile.</figcaption>
</figure>

### Step 3. **Globus File Manager** { #step3 }

Once you've completed these steps, you will be able to use the [Globus File Manager](https://app.globus.org) as usual.  If you encounter any issues, please [submit a support ticket](https://tacc.utexas.edu/portal/tickets).


<!-- 
### Step 3. **Activate Endpoint and Transfer Files**

**Activate Endpoint and Transfer Files**: Now that you have associated the ePPN with your TACC account and given the ePPN time to propagate to the systems (up to thirty minutes), you can activate the Globus transfer endpoints and begin transferring files.

Go to [https://globus.org](https://globus.org/) and log in with your university credentials.

<figure>
<img src="../imgs/gdt-step-2a-login.png" style="width:90%">
<figcaption>Figure 3. Globus login</figcaption>
</figure>

Upon successful login you, you will be directed to the "File Manager" landing page.

<figure>
<img src="../imgs/globus-file-manager.png" style="width:80%">
<figcaption>Figure 4. Globus File Manager</figcaption>
</figure>

Click on "Endpoints".

!!! important
	**Select an endpoint that has "GCS v5.4" in the title.**

<figure>
<img src="../imgs/gdt-step-2c-endpoints.png" style="width:80%">
<figcaption></figcaption>
</figure>

Click "+ Create new endpoint" and follow the instructions to set up your desktop/laptop as an endpoint.

<figure>
<img src="../imgs/gdt-step-2d-access-computer.png" style="width:80%">
<figcaption></figcaption>
</figure>

Enter a Display Name to identify your local endpoint like "My Laptop", or "My Desktop at Home", then click "Generate Setup Key" and click "Copy" to copy the Personal Setup Key.
-->
	
<!-- I think a lot of this stuff is DesignSafe, not sure if it's valuable -->

<!-- 
Download and Install the Globus Connect Personal client.

After install, open the Globus Connect Personal application. A pop menu pops up asking your setup key. Copy the setup key from the previous step to complete the setup.

Click on "File Manager", and next click on the Collection field. You can choose "Your collections" and click on "My Laptop" to select the created endpoint to your computer.

<figure>
<img src="../imgs/gdt-step-2d-create-endpoint.png" style="width:80%">
<figcaption></figcaption>
</figure>


You can now access the files on your desktop/laptop via Globus.

<figure>
<img src="../imgs/gdt-step-2e-your-collections.png" style="width:80%">
<figcaption></figcaption>
</figure>

You can also click on Panels to look at two endpoints at the same time. In the other transfer endpoint, search for "TACC" and select the appropriate allocation storage system (Frontera, Stampede3, Corral, Ranch, etcetera) for the desired data.

<figure>
<img src="../imgs/gdt-step-2f-select-system.png" style="width:80%">
<figcaption></figcaption>
</figure>

After successfully authenticating, you will be redirected back to Globus and you will now be able to access your data on the allocation storage system (Frontera, Stampede3, Corral, Ranch):

-->
<!-- 
### Examples { examples }

To access "My Data", use the appropriate endpoint and set "Path" to the path of your `$WORK` location on your system.

*   To find that path, run the following commands in a terminal.

		localhost$ ssh username@host

		[authenticate with your password and TACC Token]

		login2(#)$ cd $WORK
		login2(#)$ pwd

*   The output of the `pwd` command is your path to your `$WORK` directory.
-->

<!--

&nbsp;   | Stampede3 | Frontera | Lonestar6
-- | -- | -- | --
**Endpoint** | Stampede3 | Frontera | Lonestar6 | `ranch.tacc.utexas.edu`
**Hostname** | `stampede3.tacc.utexas.edu` | `frontera.tacc.utexas.edu` | `ls6.tacc.utexas.edu`

-->

<!--
*   To access a project in "My Projects" use the appropriate endpoint and set <samp>Path</samp> to: <code>/<kbd>path/to/storage</kbd>/<kbd>PORTAL</kbd>/projects/<kbd>PORTAL-ProjectIDNumber</kbd></code>

	`/corral-repl/tacc/aci/FRONTERA/projects/FRONTERA-26`

You will find the Project ID on your "My Projects" list in the second column.

-->

<!--
<figure>
![](imgs/gdt-step-2g-project-id.CEP.png) 
<figcaption></figcaption>
</figure>
<figure>
![3DEM](imgs/gdt-step-2g-project-id.3DEM.png)  
<figcaption></figcaption>
</figure>
-->

<!-- not sure what's going on here - commenting out for now -->
<!-- 
![A2CPS](imgs/gdt-step-2g-project-id.A2CPS.png)
![ECCO](imgs/gdt-step-2g-project-id.ECCO.png)
![PT2050](imgs/gdt-step-2g-project-id.PT2050.png)
![UTRC](../imgs/gdt-step-2g-project-id.UTRC.png)-->

<!-- If you are viewing a project, the Project ID will be appended to the URL in your browser as: -->

<!-- https://<kbd>portal.domain</kbd>/workbench/data/tapis/projects/<kbd>portal</kbd>.project.<kbd>PORTAL-ProjectIDNumber</kbd> -->
<!-- commenting out 8/13/2024 

	https://frontera-portal.tacc.utexas.edu/workbench/data/tapis/projects/frontera.project.FRONTERA-23

To access "Community Data", use the appropriate endpoint and set <samp>Path</samp> to: <code>/<kbd>path/to/portal/data</kbd>/<kbd>PORTAL</kbd>/community/</code>

* `/corral-repl/tacc/aci/UTRC/community/` 
* `/corral-repl/tacc/aci/Frontera/community/`

You can transfer files between the selected endpoints.

Once the transfer is initiated, you can see the task id for the transfer being initiated.

Click activity to check status on all the transfers you have initiated.

You will also receive an email to the registered email address once the transfer is completed.-->


