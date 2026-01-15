# Managing your TACC Account
*Last update: January 6, 2025*

## Notices

* (01/06/2026) Beginning immediately, **all users are required to have an approved institutional affiliation with an associated email address**.  See [New Accounts](#newaccounts) below for more information.
* (11/03/2025) **VSCode users:  TACC staff are aware of the difficulties VSCode users are experiencing when attempting to login to TACC HPC resources.**  Please see [Resolving VSCode issues](#vscode) below.

## How to Access TACC Resources

In order to access any TACC compute or storage resource you must maintain an "Active" TACC user account.  You may view your account status at any time on the [TACC Accounts Portal][TACCACCOUNTS] in the User Profile section. [Table 1.](#table1) below lists all possible conditions for your account.  New users please see the [New Accounts](#newaccounts) section below.  If you are a current user having issues logging in, see TACC's [Login Support Tool][TACCLOGINSUPPORT] to resolve problems.  

!!! important
	An active TACC user account does not guarantee or imply access to any of TACC's compute resources.  You must be added to an active allocation in order to gain access to that project's resources.  


!!! tip
	If your [account status](#table1) is "Active" and you still can't login, try [un-pairing and re-pairing your MFA device](https://docs.tacc.utexas.edu/basics/mfa/#unpair).

## New Accounts { #newaccounts }

Any user of TACC resources must first obtain a TACC account.  A TACC account email is of the form  <code><i>username</i>@tacc.utexas.edu</code>.  

!!!important
	You must have an approved institutional affiliation with an associated email address. For example, if you are affiliated with The University of Texas at Austin, you will need to have a `utexas.edu` email address associated with your account.  Generic domains such as `gmail.com`, `yahoo.com`, or `qq.com` are prohibited. 

To create a new account: 

1. Go to the [TACC Accounts Portal][TACCACCOUNTS] and click "Create a New Account" to begin registration.
1. Set up [Multi-Factor Authentication][TACCMFA] (MFA) on your account. 
1. Check for an email containing a confirmation and activation link.  Once you confirm your email, your account status will update to either "Pending" or "Active".
1. If your account status is "Pending" then your account request will need further review by our User Services team. No action is required and a team member will reach to you.
1. Once your account is "Active" log onto the [TACC User Portal][TACCUSERPORTAL] to view your allocation status.

!!! warning 
	An individual may not have more than one TACC account.  Shared accounts and/or multi-user accounts are strictly prohibited.  

<!-- repeated above
!!! tip
	In order to log on to TACC's HPC resources, your TACC account must be "[Active](#table1)" **AND** you must have an active allocation on that particular resource.
--> 

## Login Problems: Windows Users

Windows users attempting to login with PowerShell may have to amend the SSH command line with additional flags:

```cmd-line
$ ssh -m hmac-sha2-512 taccusername@ls6.tacc.utexas.edu
```

## Login Problems: Resolving VSCode Issues { #vscode }

Recent upgrades by Microsoft to the VSCode application have resulted in the program causing issues with user accounts.  TACC Staff are aware of the problems users are experiencing.  Until Microsoft fixes this bug, we are only able to offer possible solutions and workarounds.   

1. **Downgrade your VSCode version**: Version 1.98 appears to be the most consistent and stable when connecting to TACC resources.
1. **Edit your .bashrc file:** Connect via a terminal application to your compute resource and append the following line to your `$HOME/.bashrc` file: 

		export NODE_OPTIONS="--disable-wasm-trap-handler"

1. The [TACC Analysis Portal][TACCANALYSISPORTAL] (TAP) offers simplified access to common interactive sessions such as DCV, VNC, and JupyterNotebooks..  

!!! important
	VSCode consumes significant resources when running and can interfere with the needs of a multi-user environment such as the shared login nodes on each resource. Thus, TACC staff encourage all VSCode users to run the program on a compute node and not any of the login nodes.

	If you choose to run VSCode on the login node and it begins to impact the system or other users, your account will be suspended and we will ask you to move to a compute node.

	Also note that VSCode access is **prohibited** on TACC's Ranch and Corral storage resources.

## Login Problems: `Improper ssh Configuration!`

If you see this message:

```
--> Verifying valid ssh keys...

Improper ssh configuration!
Please reconfigure or contact TACC consulting for assistance.
```

This is most likely because you have modified your `./ssh/known_hosts` file.  The solution is to generate a new `.ssh` folder to clear any conflicting keys/logins.  

1. Go to your home directory:

	```cmd-line
	$ cd $HOME
	```

2. Rename your `.ssh` folder to `old_ssh` to save the contents should you need to revisit them at any point: 

	```cmd-line
	$ mv .ssh old_ssh
	```

3. Log out of the system and then log back in.  This will auto-generate a new `.ssh` folder and key for you. 



## Table 1. TACC Account Status { #table1 }

Account Status             | Description
           --              | -- 
Active                     | All is well.  Active account holders may log on to the TACC User Portal as well as any **allocated** TACC resources. 
Pending Email Confirmation | You haven't confirmed your email account.  If you haven't received the confirmation email, check your spam or junk folder and any filters. Add "`no-reply@tacc.utexas.edu`" to your safe senders list, then request the activation link again.  
Pending                    | Your account is under administrative review. 
Deactivated                | Reactivate your account by logging into the [TACC Accounts Portal][TACCACCOUNTS] and requesting an activation link.  **You will have to re-pair MFA once your account is reactivated**.
Suspended                  | If your account is suspended you will be prohibited from logging into the TACC User Portal and as well as any TACC HPC resources.  Please [submit a help desk ticket](SUBMITTICKET) and a member of our User Services team will respond. Account suspension may result if: <li>your HPC jobs are violating [Good Conduct Policies][TACCGOODCONDUCT] or causing harm to our systems <li>your account usage is in violation of TACC's [Acceptable Use Policy][TACCAUP].     


## Deactivated Accounts

If you have not accessed your account within the past 120 consecutive days, your account will be automatically deactivated in accordance with UT's [security protocols](https://security.utexas.edu/policies/irusp).  To re-activate your acccount, login to the [TACC Accounts Portal][TACCACCOUNTS] and request an activation link.  

!!! important
	Once you have re-activated your account, you will need to [un-pair and re-pair][TACCMFA] your two-factor authentication.

## TACC Portals 

TACC provides two portals for account and job management, the [TACC Accounts Portal][TACCACCOUNTS] and the [TACC User Portal][TACCUSERPORTAL].  

/// html | section.section--muted.section--has-border
//// html | div.grid
///// html | div[style="grid-column: 2"]

/////

///// html | article.card--plain
     markdown: block

### TACC Accounts Portal

Login Requirements: None  
<http://accounts.tacc.utexas.edu>

The [TACC Accounts Portal][TACCACCOUNTS] provides the following services:

* New account creation
* User profile management
* Password management
* View account status
* View allocation/s status
* TACC Login Support Tool
* Subscribe to User News
/////

///// html | article.card--plain
     markdown: block

### TACC User Portal

Login requirements: an "[Active](#table1)" TACC account  
<https://tacc.utexas.edu/portal>

The [TACC User Portal][TACCUSERPORTAL] provides the following services:

* Monitor your HPC jobs 
* Monitor HPC Resource status
* Monitor your allocation usage and SU consumption
* PI's may add users to their allocations
* Check your MFA pairing status

/////
////
///


## References

* [TACC Login Support Tool][TACCLOGINSUPPORT]
* [TACC Acceptable Use Policy][TACCAUP]
* [Good Conduct on HPC Resources][TACCGOODCONDUCT]
* [Multi-Factor Authentication at TACC][TACCMFA]

{% include 'aliases.md' %}

<!-- sources
Jack sez there's a workaround
* **Kill Zombied processes**: We have seen issues with zombied processes remaining on the login nodes after users run with VSCode, leading to them running into the process limits set in "`ulimit -a`".  This can manifest with this error:
To remedy, You can always check the logins for running tasks from your account with "ps -ef | grep $USER" and shut down anything that isn't needed with "kill [process_id]".

https://consult.tacc.utexas.edu/Ticket/Display.html?id=111310

"computationally expensive" as noted in Good Conduct Guide 
-->

<!-- 
###  Corrupted Mac on Input
PS C:\Users\allis> ssh ans5695@ls6.tacc.utexas.edu
Corrupted MAC on input.
ssh_dispatch_run_fatal: Con


We recently updated security ciphers for TACC systems, which has been determined to be root cause of the issue you are experiencing. While we work to resolve this, a temporary work around is to slightly change your ssh command to the following:

ssh -m hmac-sha2-512 <user_name>@<remote_address>
-->




<!--
///// html | article.card--plain
     markdown: block

### HPC Resources

Login requirements: An "[Active](#active)" TACC Portal account AND belong to a project with an active allocation.  

Currently our HPC resources consist of:

*  <a href="http://docs.tacc.utexas.edu/hpc/frontera">Frontera</a>
*  <a href="http://docs.tacc.utexas.edu/hpc/lonestar6">Lonestar6</a>
*  <a href="http://docs.tacc.utexas.edu/hpc/stampede3">Stampede3</a>
*  <a href="http://docs.tacc.utexas.edu/hpc/vista">Vista</a>

/////

///// html | article.card--plain
     markdown: block

### TACC Documentation

Login requirements: None  
<http://docs.tacc.utexas.edu>

The [TACC Documentation Portal][TACCDOCS] provides TACC-specific technical documentation:

* HPC resource user guides 
* Software package user guides
* TACC tutorials

/////
-->
