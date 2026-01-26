# Transferring Very Large Datasets with Globus { #datatransfer_globus }

Globus is the **recommended tool for transferring very large datasets** (e.g. 100 GB to many TB) to and from TACC and other research computing facilities. It is designed for **high performance, reliability, and fault tolerance** over wide-area networks.


### Key Concepts

### Endpoints
A Globus transfer always occurs between two endpoints:

- A TACC system endpoint (e.g., Stampede, Frontera, Lonestar)
- A source endpoint (your laptop, another HPC center, cloud storage, etc.)

Endpoints may be:

- **Managed endpoints** (TACC systems, institutional servers)
- **Globus Connect Personal (GCP) endpoints** (your laptop or desktop)

### Paths
Transfers use **absolute paths** on each endpoint:
- Example TACC paths:  
  `/scratch/`, `/work/`, `/corral/`, or resource‑specific directories

You must have permission to read/write the paths used.

  
## Using Globus

Globus uses **federated login**, where you authenticate with your home institution. Authentication tokens are cached and renewed automatically.

This document walks you through the steps required to set up access to Globus at TACC for first-time use. Some steps must be repeated each time you configure a new data endpoint. Once configured, Globus can be used not only for transfers to and from TACC, but also to access cyberinfrastructure resources worldwide.

To start using Globus, you need to do two things: Generate a unique identifier, or **ePPN**, for all Globus services, and enroll the machine you are transferring data to/from with Globus.  This can be your personal laptop or desktop, or a server to which you have access. Follow this one-time process to set up the Globus file transfer capability.


!!! important 
	You must use your institution's credentials and **not your personal email account (e.g. Google, Yahoo!, AOL)** when setting up Globus.  You will encounter problems with the transfer endpoints (e.g. Frontera, Stampede3, Corral, Ranch) if you use your personal account information.


### Step 1. **Retrieve your Unique ePPN**.  { #step1 }

Login to [CILogon](https://cilogon.org) and click on "User Attributes".  Make note of your **case-sensitive** ePPN.

<figure id="figure4">
<img src="../imgs/globus-CIlogin.png" style="width:65%"> 
<figcaption>Figure 4. Make note of your ePPN</figcaption>
</figure>

### Step 2. **Associate your ePPN with your TACC Account.**  { #step2 }

Login to the [TACC Accounts Portal][TACCACCOUNTS], click "Account Information" in the left-hand menu, then add or edit your ePPN from Step 1.

!!! warning
	The institution (ePPN) listed in your [TACC account profile](https://accounts.tacc.utexas.edu/account_info) must match the ePPN you are using to log into Globus.  


<figure id="figure5">
<img src="../imgs/globus-setup-step2.png" style="width:65%">
<figcaption>Figure 5. Update your TACC user profile.</figcaption>
</figure>

!!! tip
	Once you update your ePPN, please allow up to 2 hours for the changes to propagate across TACC systems.


### Using the Globus File Manager (Web Interface)

Once you've completed these steps, you will be able to use the [Globus File Manager](https://app.globus.org) as usual.  If you encounter any issues, please [submit a support ticket](https://tacc.utexas.edu/portal/tickets).

Globus-based transfers usually utilize an endpoint name (usually the name of the HPC or Storage resource you are connecting to) rather than a hostname, but you will still need to know the endpoint name, and you will always need the PATH that you are addressing, in order to successfully transfer data.

1. Go to: [https://app.globus.org](https://app.globus.org)
2. Activate the source endpoint
3. Activate the destination endpoint
4. Select source files/directories
5. Select destination path
6. Click **Start**

Transfers run **asynchronously** — you may close your browser.

### Using the Globus CLI (Advanced)

If you currently use a shell script / cron job to migrate data using scp/sftp/rsync, the Globus CLI is useful for scripting and automation. 

See our [Globus CLI Guide](datatransfer_globus_cli.md) for a short summary of using the Globus CLI. 


### Recommended Practices

- Transfer files into **scratch or work**, not your home directory, unless required
- Group many small files into tar archives if possible
- Verify quotas and permissions before starting large transfers
- Avoid transferring directly into running job directories

### Monitoring Transfers

- Progress is visible in the Globus web UI
- Email notifications can be enabled
- Failed file transfers are clearly reported

## Summary

Globus is the **preferred, safest, and fastest** way to move very large datasets to and from TACC systems. It minimizes user effort while maximizing throughput and reliability, especially over long‑distance or unstable networks.


For smaller datasets, see the [TACC SSH-based Tools Guide](datatransfer_ssh.md). 

