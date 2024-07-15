# Using Grid Community Toolkit at TACC
*Last update: September 1, 2022* 


TACC users now have access to Grid Community Toolkit and the Grid Community Toolkit utilities to transfer files directly into and out of TACC systems. This new feature allows users to associate new Distinguished Names (DNs) with their TACC account, thereby allowing TACC users access to [Grid Community Toolkit](http://globus.org) to transfer files.

In order to transfer files using Grid Community Toolkit you will need to:

1. [Find a DN](#step1)
2. [Add the DN to your TACC Profile](#step2)
3. [Activate the Grid Community Toolkit Endpoints](#step3)
4. [Transfer Files](#step4)

## Step 1: Find a DN from a MyProxy or MyProxy OAuth provider { #step1 }

To create a DN, you need to log in from some authoritative source that can verify your identity, typically your university or employer. If you already have a DN from another source, you can use that. If you do not, you can associate one with your account from many of the major universities in the world via the "CI Logon" service.

!!! tip
	You must use your institution’s credentials and not your personal Google account when setting up Grid Community Toolkit. If you use a personal account, you will encounter an issue with the endpoint.

Grid Community Toolkit supports MyProxy and MyProxy OAuth identity providers. While you should be able to use any MyProxy/MyProxy OAuth provider, for this documentation we will be using [CILogon.org](https://cilogon.org/).

To retrieve your DN, go to [https://cilogon.org](https://cilogon.org/) in your browser. Select an Identity Provider from the drop-down list and click "Log On".

<figure id="figure1"><img alt="" src="../imgs/GCT-1.png">
<figcaption></figcaption></figure>

We have selected "University of Texas at Austin". After successfully authenticating at your chosen identity provider, you are redirected back to CILogon, where you can see your certificate subject:

`/DC=org/DC=cilogon/C=US/O=University of Texas at Austin/CN=Sample Person A00000` 

This is the data you need to associate with your TACC account.

<figure id="figure2"><img alt="" src="../imgs/GCT-2.png">
<figcaption></figcaption></figure>


## Step 2: Associate the DN with our TACC Account { #step2 } 

Login to the [TACC User Portal][TACCUSERPORTAL] and click "Manage your Profile" from the Dashboard actions or select "Account Profile" from the main menu under the "Home" dropdown. You can also navigate directly to [https://portal.tacc.utexas.edu/account-profile](https://portal.tacc.utexas.edu/account-profile). On the left of the page is a list of account actions, select "Manage DNs". You will be presented with a list of the DNs currently associated with your TACC account.

<figure id="figure3"><img alt="" src="../imgs/GCT-3.png">
<figcaption></figcaption></figure>

On the Manage DNs page, near the bottom, is a form to associate a DN to your account. Enter the Certificate Subject obtained from CILogon.org in the text field. Click the button to "Associate DN". This will associate the new DN with your account. 


<figure id="figure4"><img alt="" src="../imgs/GCT-4.png">
<figcaption></figcaption></figure>

!!! note
	It may take up to 30 minutes for this change to propagate to all TACC systems.</p>

<figure id="figure5"><img alt="" src="../imgs/GCT-5.png">
<figcaption></figcaption></figure>

## Step 3: Activate Grid Community Toolkit Endpoints { #step3 } 

Now that you have associated the DN with your TACC account **and** given the DN time to propagate to the systems (up to thirty minutes), you can activate the Grid Community Toolkit transfer endpoints and begin transferring files.


Go to [https://globus.org](https://globus.org), log in, and click "Manage Data". Alternatively, navigate directly to [https://app.globus.org/file-manager](https://app.globus.org/file-manager). In one of the transfer endpoint form boxes, search for endpoints prefixed `tacc#`. For example, you should be able to find `tacc#stampede2`. 


<figure id="figure6"><img alt="" src="../imgs/GCT-6.png">
<figcaption></figcaption></figure>

After selecting the endpoint you'll be prompted to authenticate in order to active the endpoint. Click `Continue` and you will be redirected to a Grid Community Toolkit-branded CILogon authentication page. Select the same identity provider that you used when you retrieved your certificate above and re-authenticate. 


<figure id="figure7"><img alt="" src="../imgs/GCT-7.png">
<figcaption></figcaption></figure>


## Step 4: Transfer Files { #step4 } 

After successfully authenticating, you will be redirected back to Grid Community Toolkit and you will now be able to access your data on Stampede2.

<figure id="figure8"><img alt="" src="../imgs/GCT-8.png">
<figcaption></figcaption></figure>

{% include 'aliases.md' %}
