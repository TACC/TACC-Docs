<style>
.grid {
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
}
</style>


# Managing your TACC Account
*Last update: February 17, 2025*

In order to access any TACC compute or storage resource you must maintain an "Active" TACC user account.  You may view your account status at any time on the [TACC Accounts Portal][TACCACCOUNTS] in the User Profile section. [Table 1.](#table1) below lists all possible conditions for your account.


!!! tip
	If you are having login issues see TACC's [Login Support Tool][TACCLOGINSUPPORT] to resolve problems.  

	If your [account status](#account-status) is "Active" and you still can't login, try [un-pairing and re-pairing your MFA device][TACCMFA].


## Table 1. TACC Account Status { #table1 }

Account Status             | Description
           --              | -- 
Active                     | All is well.  Active account holders may log on to the TACC User Portal as well as any **allocated** TACC resources. 
Pending Email Confirmation | You haven't confirmed your email account.  If you haven't received the confirmation email, check your spam or junk folder and any filters. Add "`no-reply@tacc.utexas.edu`" to your safe senders list, then request the activation link again.  
Pending                    | Your account is under administrative review. 
Deactivated                | If you have not accessed your account within the past 120 consecutive days, your account will be automatically deactivated in accordance with UT's [security protocols](https://security.utexas.edu/policies/irusp).  Reactivate your account by logging into the [TACC Accounts Portal][TACCACCOUNTS]  and requesting an activation link.  **You will have to re-pair MFA once your account is reactivated**.
Suspended                  | If your account is suspended you will be prohibited from logging into the TACC User Portal and as well as any TACC HPC resources.  Please [submit a help desk ticket](SUBMITTICKET) and a member of our User Services team will respond. Account suspension may result if: <li>your HPC jobs are violating [Good Conduct Policies][TACCGOODCONDUCT] or causing harm to our systems <li>your account usage is in violation of TACC's [Acceptable Use Policy][TACCUSAGEPOLICY].     


## New Accounts


Any user of TACC resources must first obtain a TACC account.  A TACC account email is of the form *username*@tacc.utexas.edu.  All new users are required to authenticate with a [UT approved Identity Provider](#identity-management).  

To create a new account: 

1. Go to the [TACC Accounts Portal][TACCACCOUNTS] and click "Create a New Account" to begin registration.
1. Check for an email containing a confirmation and activation link.  Once you confirm your email, your account status will update to either "Pending" or "Active".
1. If your account status is "Pending" then your account request will need further review by our User Services team. No action is required and a team member will reach to you.
1. Once your account is "Active":
	* Set up [Multi-Factor Authentication](TACCMFA) (MFA) on your account. 
	* Log onto the [TACC User Portal](TACCPORTAL) to view your allocation status.

!!! warning 
	An individual may not have more than one TACC account.  Shared accounts and/or multi-user accounts are strictly prohibited.  

!!! tip
	In order to log on to TACC's HPC resources, your TACC account must be Active **AND** you must have an active allocation on that particular resource.

### Identity Management

As part of ongoing cybersecurity enhancements, TACC now requires using a 3rd party Identity Provider.  Any user registering for a new account, reactivating a [deactivated](#deactivated) account, or updating their profile will be required to authenticate using one of the UT approved Identity Provider services listed below.  All existing accounts will be required to authenticate with one of these identity providers at the annual account profile update. 

* UT EID
* Apple
* Google
* Microsoft
<!-- * InCommon Federation - commenting out 01/30/2025 due to problems on their end -->

!!! important
	Use your institution's email, not your Apple, Google or Microsoft email, when registering/activating your TACC account.


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

Login requirements: an "[Active](#active)" TACC account  
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
* [TACC Acceptable Use Policy][TACCUSAGEPOLICY]
* [Good Conduct on HPC Resources][TACCGOODCONDUCT]
* [Multi-Factor Authentication at TACC][TACCMFA]

{% include 'aliases.md' %}



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
