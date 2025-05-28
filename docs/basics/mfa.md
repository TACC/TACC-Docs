# Multifactor Authentication at TACC 
*Last update: May 28, 2025*

!!! tip
	TACC's [Login Support Tool][TACCLOGINSUPPORT] tool can assist you if you are having difficulty logging into TACC resources.  
	See also [Managing Your TACC Account][TACCMANAGINGACCOUNT].

## What is MFA? { #whatismfa }

Authentication is the process of determining if you are you. Traditional methods of associating a user account with a single password are no longer sufficient.  Multi-Factor Authentication (MFA) requires another step, or "factor", in the authenticaton process. In addition to the usual password, users must complete authentication using another device unique to them, usually their mobile phone/device. 

## Setting up MFA at TACC { #setupmfa }

!!! important
	TACC requires Multi-Factor Authentication (MFA) as an additional security measure when accessing all compute and storage resources.  All TACC account holders must maintain a valid MFA pairing.  

If you are familiar with the pairing process, you can proceed directly to the [pairing page](https://accounts.tacc.utexas.edu/mfa) on the [TACC Accounts Portal][TACCACCOUNTPORTAL], otherwise follow the steps below to set up MFA..


### 1. Manage Account { #setupmfa-step1 }

<table border="0"><tr>
<td><figure id="figure1a"><img border="1" src="../imgs/mfa-manage-account-2.png"> 
<figcaption>Figure 1a.</figcaption></figure></td>
<td><figure id="figure1b"><img border="1" src="../imgs/mfa-manage-account-1.png"> 
<figcaption>Figure 1b.</figcaption></figure></td>
</tr></table>


From the "Manage Account" page, click "Pair a Device" to continue to the TACC device pairing page (Figure 2.). 

<figure id="figure2"><img border="1" alt="Pair Device" src="../imgs/mfa-pairdevice.png" style="size:50%"> <figcaption>Figure 2.</figcaption></figure>
	
### 2. Select Pairing Method { #setupmfa-step2 }

TACC offers two mutually-exclusive authentication (pairing) methods.  You may choose to authenticate with one and only one method. 

* Authenticator applications e.g., Google Authenticator, Duo, 1Password  
or
* Standard SMS text messaging.  

<!-- !!! important
	DesignSafe users **must** pair using a [Multi-Factor Authentication app](#mfaapps) method.  DesignSafe users may not pair using SMS text messaging. -->

!!! important
	Users located outside the U.S. **must** pair using a [Multi-Factor Authentication app](#mfaapps) method. Because the cost associated with sending multiple international text messages is prohibitive, international users may NOT set up multi-factor authentication with SMS.

####  Authentication Apps { #mfaapps }

Users with Apple iOS and Android devices may set up device pairing using a one of a variety of authentication applications available for both <a href="https://itunes.apple.com/us/app/tacc-token/id1081516137?mt=8">Android</a> and <a href="https://itunes.apple.com/us/app/tacc-token/id1081516137?mt=8">iPhone</a> devices.

Download and install your preferred MFA App on your Apple IOS or Android device, then follow the app instructions to pair your mobile device.  Table 1. features a few of the more popular applications along with links to the respective Apple App and Google Play stores.

#### Table 1. MFA Apps { #table1 }

Operating System | MFA Authentication Apps
--- | ---
IOS / Apple devices<br>Apple App Store | <a href="https://apps.apple.com/us/app/duo-mobile/id422663827" target="_blank">Duo</a><sup>&#8663;</sup>   <a href="https://apps.apple.com/us/app/1password-password-manager/id568903335" target="_blank">1Password</a><sup>&#8663;</sup>   <a href="https://apps.apple.com/us/app/google-authenticator/id388497605" target="_blank">Google Authenticator</a><sup>&#8663;</sup>
Android<br>Google Play | <a href="https://play.google.com/store/apps/details?id=com.duosecurity.duomobile&hl=en_US&gl=US" target="_blank">Duo</a><sup>&#8663;</sup>   <a href="https://play.google.com/store/apps/details?id=com.onepassword.android&hl=en_US&gl=US" target="_blank">1Password</a><sup>&#8663;</sup>   <a href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_US&gl=US" target="_blank">Google Authenticator</a><sup>&#8663;</sup>

#### SMS (text) Messaging { #sms }

Instead of using an app, users may instead enable multi-factor authentication with SMS, standard text messaging.

<!-- !!! attention 
	The SMS pairing option is not available to DesignSafe users.  DesignSafe users may pair using any of the authentication applications listed above.-->

When logging into a TACC resource you'll be prompted for your standard password, and then prompted for a "TACC Token Code".  At this point a text message will be sent to your phone with a unique six-digit code.  Enter this code at the prompt.  

**This token code is valid for this login session only and cannot be re-used.  It may take up to 60 seconds for the text to reach you.  We advise clearing out your text messages in order to avoid confusion during future logins.**

### Example: Pairing with an Authentication App { #authapp }

This tutorial demonstrates pairing with the Duo App, though you may use any any MFA app you like. 

1. Begin by pressing the "Pair Device" button in the upper-right corner of "Manage Account" page (Figure 3).

	<figure id="figure3"><img border="1" alt="Begin Pairing" src="../imgs/mfa-beginpairing.png" style="size:50%"> <figcaption>Figure 3.</figcaption></figure>

1. Select "Token App" from the Authentication Pairing page (Figure 4a), then click on the empty box to generate a personalized QR code (Figure 4b).

	<table border="0"><tr>
	<td><figure id="figure4a"><img border="1" src="../imgs/mfa-authenticationpairing-1.png"> <figcaption>Figure 4a.</figcaption></figure>  </td>
	<td><figure id="figure4b"><img border="1" src="../imgs/mfa-authenticationpairing-2.png"> <figcaption>Figure 4b.</figcaption></figure>  </td>
	</tr></table>

1. Open the Duo App on your device. Your mobile device screen should appear similar to Figure 5a. Tap the "+" in the upper right corner of the app to start the pairing process.  The app will launch the mobile device's camera.  Scan the generated QR code on your computer screen.  Do not scan the image on this tutorial's page. Show the Duo token code on your device (Figure 5b) and then enter that token into the web form (Figure 5c).

	<table border="0"><tr>
	<td><figure id="figure5a"><img border="1" src="../imgs/mfa-duo-showcode.png"> <figcaption>Figure 5a.</figcaption></figure></td>
	<td><figure id="figure5b"><img border="1" src="../imgs/mfa-duo-314193.png"> <figcaption>Figure 5b.</figcaption></figure></td>
	<td><figure id="figure5c"><img border="1" src="../imgs/mfa-authenticationpairing-3.png"> <figcaption>Figure 5c.</figcaption></figure></td>
	</tr></table>

1. You've now paired your device! (Figure 6.)  If you have any problems with this process, please [submit a help ticket](CREATETICKET).

	<figure id="figure6"><img border="1" src="../imgs/mfa-pairingsuccessful.png" style="width:50%; height:50%"> <figcaption>Figure 6.</figcaption></figure>

## Logging into TACC Resources { #login }

Once you've established MFA on your TACC account, you'll be able to login to all TACC resources where you have an allocation.  A typical login session will look something like this: 

``` 
% ssh -l taccusername ls6.tacc.utexas.edu
To access the system:

1) If not using ssh-keys, please enter your TACC password at the password prompt
2) At the TACC Token prompt, enter your 6-digit code followed by <return>.  

(taccusername@ls6.tacc.utexas.edu) Password: 
(taccusername@ls6.tacc.utexas.edu) TACC Token Code:
Last login: Fri Jan 13 11:01:11 2023 from 70.114.210.212
------------------------------------------------------------------------------
Welcome to the Lonestar6 Supercomputer
Texas Advanced Computing Center, The University of Texas at Austin
------------------------------------------------------------------------------
...
% 
```

After typing in your password, you'll be prompted for "**`TACC Token Code:`**".  At this point, turn to your mobile device/phone, open your authenticator application and enter in the current token displayed..  

* If you've paired with an authenticator app, open the app and the enter the six-digit number currently being displayed.  If you mis-type the number, just wait till the app cycles (every 30-60 seconds) and try again with the next number (figure 9b).

* If you've paired with SMS, you'll receive a text message containing a six digit verification code (figure 9a).  Enter this code at the **`TACC Token Code:`** prompt.  Please note that it may take up to 60 seconds for the text containing the token code to reach you.  Each token code is valid for one login only and cannot be re-used.  


## International Users and Travelers { #international }

!!! important 
	Users located outside the U.S. **must** pair using a [Multi-Factor Authentication app](#mfaapps) of your choice. Because the cost associated with sending multiple international text messages is prohibitive, international users may NOT set up multi-factor authentication with SMS.  

## Unpairing your Device { #unpair }

Unpair your device via the same method you originally paired: by app token or by SMS.  If you've lost access to the device you originally paired with, you may unpair using email notification. 

1. Go to your "[Manage Account](https://www.tacc.utexas.edu/portal/account)" page (Figure 7a), and click the "Unpair" link to proceed (Figure 7b).    

	<table border="0"><tr>
	<td><figure id="figure7a"><img alt="" src="../imgs/mfa-unpairdevice.png">
	<figcaption>Figure 7a.</figcaption></figure></td>
	<td><figure id="figure7b"><img alt="" src="../imgs/mfa-unpairingchoice.png">
	<figcaption>Figure 7b.</figcaption></figure></td>
	</tr></table>

1. Similar to the pairing process, you must verify unpairing by entering your device's token code when prompted (Figures 8a and 8b).  

	<table border="0"><tr>
	<td><figure id="figure8a"><img alt="" src="../imgs/mfa-duo-626574.png">
	<figcaption>Figure 8a.</figcaption></figure></td>
	<td><figure id="figure8a"><img alt="" src="../imgs/mfa-unpairing.png">
	<figcaption>Figure 8b.</figcaption></figure></td>
	</tr></table>

1. Once you've unpaired with this device, you are free to pair again with another device or another method.

{% include 'aliases.md' %}
