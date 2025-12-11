# Multifactor Authentication at TACC 
*Last update: June 06, 2025*

!!! tip
	TACC's [Login Support Tool][TACCLOGINSUPPORT] tool can assist you if you are having difficulty logging into TACC resources.  
	See also [Managing Your TACC Account][TACCMANAGINGACCOUNT].

## What is MFA? { #whatismfa }

Authentication is the process of determining if you are you. Traditional methods of associating a user account with a single password are no longer sufficient.  Multi-Factor Authentication (MFA) requires another step, or "factor", in the authentication process. In addition to the usual password, users must complete authentication using another device unique to them, usually their mobile phone/device. 

TACC requires Multi-Factor Authentication (MFA) as an additional security measure when accessing all compute and storage resources.  All TACC account holders must maintain a valid MFA pairing.  

## Set up MFA at TACC 

All account management is done via the [TACC Accounts Portal][TACCACCOUNTS].  TACC Accounts Portal utilities include MFA pairing, as well as password, user-profile, and subscription management.  You may also view detailed account information such as your UID, default GID, and home directory path.

Login to the [TACC Accounts Portal][TACCACCOUNTS], select "Multi-factor Auth" in the left-hand navigation, then select your pairing method (Figure 1.).   

TACC offers two mutually-exclusive authentication (pairing) methods: 1) Authenticator applications e.g., Google Authenticator, Duo, 1Password  and 2) Standard SMS text messaging.  You may choose to authenticate with one, and only one, method.  

Follow the examples below where we demonstrate how to pair using the [DUO authentication](#authapp) app and [standard SMS](#sms).  

<figure id="figure1">
<img alt="" src="../imgs/mfa-selectpairing.png" style="width:800px;">
<figcaption>Figure 1. Select pairing method</figcaption>
</figure>

!!! important 
	Users located outside the U.S. **must** pair using a [Multi-Factor Authentication app](#mfaapps) of your choice. Because the cost associated with sending multiple international text messages is prohibitive, international users may NOT set up multi-factor authentication with SMS.  

### Example: Pairing with an Authentication App { #authapp }

Users with Apple iOS and Android devices may set up device pairing using a one of a variety of authentication applications available for both platforms.  Table 1. below features a few of the more popular applications along with links to the respective Apple App and Google Play stores.

#### Table 1. MFA Apps { #table1 }

MFA App | IOS/Apple devices<br>Apple App Store | Android<br>Google Play
--- | --- | ---
<img src="../imgs/1password-logo.png" width="50px;"> | <a href="https://apps.apple.com/us/app/1password-password-manager/id568903335" target="_blank">1Password</a> | <a href="https://play.google.com/store/apps/details?id=com.onepassword.android&hl=en_US&gl=US" target="_blank">1Password</a>
<img src="../imgs/duo-logo.png" width="50px;"> | <a href="https://apps.apple.com/us/app/duo-mobile/id422663827" target="_blank">Duo</a> | <a href="https://play.google.com/store/apps/details?id=com.duosecurity.duomobile&hl=en_US&gl=US" target="_blank">Duo</a>
<img src="../imgs/google-authenticator-logo.png" width="50px;"> | <a href="https://apps.apple.com/us/app/google-authenticator/id388497605" target="_blank">Google Authenticator</a> | <a href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_US&gl=US" target="_blank">Google Authenticator</a>   


1. Download and install your preferred MFA App on your Apple IOS or Android device. This tutorial demonstrates pairing with the Duo App, though you may use any any MFA app you like. 
1. Select "Authenticator App" to proceed to the authentication application pairing screen (Figure 2).  

	<table border="0"><tr><td>
	<figure id="figure2"><img border="1" alt="" src="../imgs/mfa-selectpairing.png" style="width:800px;">
	<figcaption>Figure 2. MFA authentication application pairing screen</figcaption></figure>
	</td></table>


1. Open the authentication app on your device.  Tap the "+" in the upper right corner of the app to start the pairing process.  The app will launch the mobile device's camera.  Scan the generated QR code on your computer screen.  Do not scan the image on this tutorial's page. Enter the Duo token code shown on your device (Figure 3) and then enter that token into the web form (Figure 2. above).

	<table border="0"><tr><td>
	<figure id="figure3"><img border="1" src="../imgs/mfa-duo-626574.png" style="width:300px;"> 
	<figcaption>Figure 3.</figcaption></figure></td>
	</td></table>

1. You've now paired your device! (Figure 4)  If you have any problems with this process, please [submit a help ticket][CREATETICKET].

	<table border="0"><tr><td>
	<figure id="figure4"><img border="1" alt="" src="../imgs/mfa-mfapairingsuccessful.png" style="width:800px;">
	<figcaption>Figure 4. Authentication application pairing screen</figcaption></figure>
	</td></table>


### Example: Pairing with SMS (text) Messaging { #sms }

Instead of using an authentication application, you may instead enable multi-factor authentication with SMS, standard text messaging. Follow the instructions on the SMS pairing form below (Figure 5).

<table border="0"><tr><td>
<figure id="figure5"><img border="1" src="../imgs/mfa-smspairing.png" style="width:800px;"> 
<figcaption>Figure 5.</figcaption></figure></td>
</tr></table>

<!-- <table border="0"><tr><td>
<figure id="figurexx"><img border="1" src="../imgs/mfa-smspairingsuccessful.png" style="width:800px;"> 
<figcaption>Figure xx.</figcaption></figure></td>
</tr></table> -->


## Logging into TACC Resources { #login }

Once you've established MFA on your TACC account, you'll be able to login to all TACC resources **where you have an allocation**.  

When logging into a TACC resource you'll be prompted for your standard password, and then prompted for a "TACC Token Code".  At this point a text message will be sent to your phone with a unique six-digit code.  Enter this code at the prompt.  

**This token code is valid for this login session only and cannot be re-used.  It may take up to 60 seconds for the text to reach you.  We advise clearing out your text messages in order to avoid confusion during future logins.**

A typical login session will look something like this: 

<figure id="figure5">
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
<figcaption>Figure 5. Sample session: logging into TACC resources via command-line.</figcaption></figure>

After typing in your password, you'll be prompted for "**`TACC Token Code:`**".  At this point, turn to your mobile device/phone, open your authenticator application and enter in the current token displayed..  

* If you've paired with an authenticator app, open the app and the enter the six-digit number currently being displayed.  If you mis-type the number, just wait till the app cycles (every 30-60 seconds) and try again with the next number.

* If you've paired with SMS, you'll receive a text message containing a six digit verification code.  Enter this code at the **`TACC Token Code:`** prompt.  Please note that it may take up to 60 seconds for the text containing the token code to reach you.  Each token code is valid for one login only and cannot be re-used.  


## Unpairing your Device { #unpair }


1. Login to the [TACC Accounts Portal][TACCACCOUNTS], click on Multi-Factor Auth in the left-hand navigation, and click the "Unpair" link to proceed (Figure 6).   

	<table border="0"><tr>
	<td><figure id="figure6"><img alt="" src="../imgs/mfa-mfaunpair.png" style="width:800px;">
	<figcaption>Figure 6.</figcaption></figure></td>
	</tr></table>

1. You'll unpair your device via the same method you originally paired: by authentication app or by SMS.  If you've lost access to the device you originally paired with, you may unpair using email notification (Figure 7).  

	<table border="0"><tr>
	<td><figure id="figure7"><img alt="" src="../imgs/mfa-unpair-email.png" style="width:800px;">
	<figcaption>Figure 7.</figcaption></figure></td>
	</tr></table>

1. Similar to the pairing process, you must verify unpairing by entering your device's token code when prompted (Figure 8).  

	<table border="0"><tr>
	<td><figure id="figure8"><img alt="" src="../imgs/mfa-smsunpair.png" style="width:800px;">
	<figcaption>Figure 8. Unpair with SMS</figcaption></figure></td>
	</tr></table>


1. Once you've unpaired with this device, you are free to pair again with another device or another method (Figure 9). If you had paired using an authentication app, be sure to remove the corresponding TACC entry.

	<figure id="figure9"><img border="1" alt="" src="../imgs/mfa-unpairing-successful.png" style="width:800px;">
	<figcaption>Figure 9. Re-pair your device</figcaption></figure>

{% include 'aliases.md' %}



