<style>
.grid {
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
}
</style>

# Managing your TACC Account
*Last update: January 23, 2025*

This document introduces the TACC ecosystem that consists not only of HPC resources, but also portals to manage your account, manage your allocations and running jobs and technical documentation. 

<!-- Document the account creation process and troubleshooting tips. -->

/// html | section.section--muted.section--has-border

## TACC Portals and HPC Resources

//// html | div.grid
///// html | div[style="grid-column: span 2"]

TACC provides access to several portals with varying login requirements along with selected access to computing resources.  

/////

///// html | a.card--plain[href="https://accounts.tacc.utexas.edu"]
     markdown: block

<h3>TACC Accounts Portal</h3>

Login Requirements: None

* New account creation
* User profile management
* Password management
* View account status
* TACC Login support tool
* Subscribe to User News

/////


///// html | article.card--plain
     markdown: block

<h3>TACC User Portal</h3>

Login requirements: an "<a href="#active">Active</a>" TACC account

The <a href="https://tacc.utexas.edu/portal/login">TACC User Portal</a> provides the following services:

* Monitor your HPC jobs 
* Monitor HPC Resource status
* Monitor your allocation usage and SU consumption
* PI's may add users to their allocations

/////


///// html | a.card--plain[href="https://docs.tacc.utexas.edu"]
     markdown: block

<h3>TACC Documentation</h3>

Login requirements: None

* HPC resource user guides 
* Software package user guides
* TACC tutorials

/////


///// html | article.card--plain
     markdown: block

<h3>HPC Resources</h3>

Login requirements: 

* An "<a href="#active">Active</a>" TACC Portal account
* Must belong to a project with an active allocation.  (Review your allocation status on the <a href="https://tacc.utexas.edu/portal/login">TACC User Portal</a>.

Currently our HPC resources consist of:

*  <a href="/hpc/frontera">Frontera</a>
*  <a href="/hpc/vista">Vista</a>
*  <a href="/hpc/lonestar6">Lonestar6</a>
*  <a href="/hpc/stampede3">Stampede3</a>

/////
////
///

## New Accounts

Any user of TACC resources, HPC resources, Design-Safe, etc. must have a TACC Portal account.  A TACC account email is of the form *username*@tacc.utexas.edu.  

!!! important 
	An individual may not have more than one TACC account.  Shared accounts and/or multi-user accounts are strictly prohibited.  

To create a new account: 

1. Go to the [TACC Accounts Portal][TACCACCOUNTS] and click "Create a New Account" to begin registration.
1. Something on identity management
1. Once you submit your account request, you will receive an email with a link to confirm and activate your account.  

### Identity Management

Any user registering for a new account, reactivating a [deactivated](#deactivated) account, or updating their profile will be required to authenticate using one of the UT approved Identity Provider services listed below.  All existing accounts will be required to authenticate with one of these identity providers at the annual account profile update. 

* UT EID
* InCommon Federation
* Apple
* Google
* Microsoft

## Diagnosing Login Problems

If you are having issues with your account, TACC's [Login Support Tool][TACCLOGINSUPPORT] is the fastest way to diagnose and resolve any problems. You may also use it to simply check the status of your account. Your user profile will also list the current status of your account. 

### Account Statuses

You may view your account status at any time on the [TACC Accounts Portal][TACCACCOUNTS].

#### Active

All is well.  Active account holders may log on to the TACC User Portal as well as other allocated TACC resources. 


#### Pending Email Confirmation

Once you submit your new account request, your account status immediately updates to this status.   Once you submit your account request, you will receive an email with a link to confirm and activate your account.  Until you click this link, your account status will be listed as `PendingEmailConfirmation`.

If you haven't received the  email, check your spam or junk folder and any filters. Add "`no-reply@tacc.utexas.edu`" to your safe senders list, then request the activation link again.

If your account status turns to Active, you will now need to set up an MFA pairing for your account. You may refer to our MFA instructions page for information on how to set up your MFA. If your account turns into a Pending status after activation, please refer below for the next steps.

#### Pending

If your account status is Pending then your account request will need to undergo further review by our team. You will receive an email from us with the results of the review.  No action is required from you if your account status is Pending, but please do reach out to our help desk if you have any questions or concerns.


#### Deactivated

If you have not logged into your account in the past 120 consecutive days, your account will automatically get deactivated per our security protocols.  You can reactivate your account by logging into the [TACC Accounts Portal][TACCACCOUNTS]  and requesting an activation link.  **You will have to repair MFA once your account is reactivated**.

#### Suspended

If your account is suspended you will be prohibited from logging into the TACC User Portal and logging into any TACC HPC resources.  Account suspension can result if:

* Your HPC jobs are violating [Good Conduct Policies][TACCGOODCONDUCT] or causing harm to our systems
* Your account usage is in violation of TACC's [Acceptable Use Policy][TACCUSAGEPOLICY].

Please [submit a help desk ticket](SUBMITTICKET) and a member of our User Services team will respond.   


<!-- save till later
### SSH Keys

This is most likely because you have modified your known hosts file to facilitate a no-password login. Let us try generating a new ssh folder to clear any conflicting keys/logins (you will still have the contents of your current ssh folder under a different name):

1. Go to your home directory using the command:
cd $HOME
2. Change the name of your .ssh folder to old_ssh (so the contents are still accessible in old_ssh, should you need to revisit them at any point) using the command: 
mv .ssh old_ssh
3. Log out of the system and ssh back in, this will auto-generate a new .ssh folder and key for you. 
Once that happens you can try making the change for a password-less login. Please let me know if that works for you or if you have any other questions.
-->

## References

* [TACC Login Support Tool][TACCLOGINSUPPORT]
* [TACC Acceptable Use Policy][TACCUSAGEPOLICY]
* [Multi-Factor Authentication at TACC][TACCMFA]

{% include 'aliases.md' %}



