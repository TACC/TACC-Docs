# Multifactor Authentication at TACC 
*Last update: April 12, 2023 in progress*

TACC requires Multi-Factor Authentication (MFA) as an additional security measure when accessing all compute and storage resources.  <!-- To set up MFA pairing at TACC on your approved account, proceed directly to the [TACC pairing page](https://tacc.utexas.edu/portal/mfa). -->

## [What is Multi-Factor Authentication?](#whatismfa) { #whatismfa }

Authentication is the process of determining if you are you. Traditional methods of associating a user account with a single password have not been 100% successful. Multi-Factor Authentication (MFA) requires another step, or "factor", in the authenticaton process. In addition to the usual password users must complete authentication using another device unique to them, usually the user's mobile phone/device. 

## [Setting up MFA at TACC](#setupmfa) { #setupmfa }

!!! important
	You will not be able to pair a new device or generate a QR Code if you are trying to set up MFA on a new account until after your account request is accepted by TACC Staff. Account requests are usually approved within 24 hours.

### [1. Manage Account](#setupmfa-step1) { #setupmfa-step1 }

* Sign into the TACC Portal, then click on "Manage Account" under your name in the top right-hand corner:

<table border="0"><tr>
<td><figure id="figure1a"><img border="1" src="../../imgs/tutorials/mfa-manage-account-2.png"> 
<figcaption>Figure 1a.</figcaption></figure></td>
<td><figure id="figure1b"><img border="1" src="../../imgs/tutorials/mfa-manage-account-1.png"> 
<figcaption>Figure 1b.</figcaption></figure></td>
</tr></table>

<!-- Users who've not set up MFA before will see a message similar to Figure 1.
<figure id="figure1"><img border="1" alt="" src="../../imgs/tutorials/MFA-1.png" style="width:50%">
<figcaption>Figure 1. Profile with no MFA enabled</figcaption></figure> -->

* From the "Manage Account" page, click "Pair a Device" to continue to the TACC device pairing page. 

<figure><img border="1" alt="Pair Device" src="../../imgs/tutorials/mfa-pairdevice.png" style="size:50%"> <figcaption></figcaption></figure>
	
### [2. Select Pairing Method](#setupmfa-step2) { #setupmfa-step2 }

TACC offers two mutually-exclusive authentication (pairing) methods.  You may choose to authenticate with one and only one method.: 

* authenticator applications e.g., Google Authenticator, Duo, 1Password
* standard SMS text messaging.

!!! note
	Users located outside the U.S. **must** pair using a [Multi-Factor Authentication app](#mfaapps) method. Because the cost associated with sending multiple international text messages is prohibitive, international users may NOT set up multi-factor authentication with SMS.

####  [Authentication Apps](#mfaapps) { #mfaapps }

Users with Apple iOS and Android devices may set up device pairing using a one of a variety of authentication applications available for both <a href="https://itunes.apple.com/us/app/tacc-token/id1081516137?mt=8">Android</a> and <a href="https://itunes.apple.com/us/app/tacc-token/id1081516137?mt=8">iPhone</a> devices.

Download and install your preferred MFA App on your Apple IOS or Android device, then follow the app instructions to pair your mobile device.  Table 1. features a few of the more popular applications along with links to the respective Apple App and Google Play stores.

#### [Table 1. MFA Apps](#table1) { #table1 }

Operating System | MFA Authentication Apps
--- | ---
IOS / Apple devices<br>Apple App Store | <a href="https://apps.apple.com/us/app/duo-mobile/id422663827" target="_blank">Duo</a><sup>&#8663;</sup>   <a href="https://apps.apple.com/us/app/1password-password-manager/id568903335" target="_blank">1Password</a><sup>&#8663;</sup>   <a href="https://apps.apple.com/us/app/google-authenticator/id388497605" target="_blank">Google Authenticator</a><sup>&#8663;</sup>
Android<br>Google Play | <a href="https://play.google.com/store/apps/details?id=com.duosecurity.duomobile&hl=en_US&gl=US" target="_blank">Duo</a><sup>&#8663;</sup>   <a href="https://play.google.com/store/apps/details?id=com.onepassword.android&hl=en_US&gl=US" target="_blank">1Password</a><sup>&#8663;</sup>   <a href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_US&gl=US" target="_blank">Google Authenticator</a><sup>&#8663;</sup>


#### [SMS (text) Messaging](#sms) { #sms }

Instead of using an app, users may instead enable multi-factor authentication with SMS, standard text messaging.

When logging into a TACC resource you'll be prompted for your standard password, and then prompted for a "TACC Token Code".  At this point a text message will be sent to your phone with a unique six-digit code.  Enter this code at the prompt.  

**This token code is valid for this login session only and cannot be re-used.  It may take up to 60 seconds for the text to reach you.  We advise you to clear out your text messages in order to avoid confusion during future logins.**

<!-- <table border="1"><tr>
<td><figure id="figure3a"><img border="1" alt="" src="../../imgs/tutorials/MFA-3a.png" style="width:50%">
<figcaption>Figure 3a. SMS pairing code</figcaption></figure></td>
<td><figure id="figure3b"><img border="1" alt="" src="../../imgs/tutorials/MFA-3b.png" style="width:50%">
<figcaption>Figure 3b. Pairing with SMS</figcaption></figure></td></tr></table> -->

## [Example: Pairing with an Authentication App](#authapp) { #authapp }

This tutorial demonstrates pairing with the Duo App, though you may use any any MFA app you like. 

Begin by pressing the "Pair Device" button in the upper-right corner of "Manage Account" page.

<figure><img border="1" alt="Pair Device" src="../../imgs/tutorials/mfa-pairdevice.png" style="size:50%"> <figcaption></figcaption></figure>

Select "Token App" from the Authentication Pairing page, then click on the empty box to generate a personalized QR code:

<table border="0"><tr>
<td><figure><img border="1" src="../../imgs/tutorials/mfa-authenticationpairing-1.png"> <figcaption></figcaption></figure>  </td>
<td><figure><img border="1" src="../../imgs/tutorials/mfa-authenticationpairing-2.png"> <figcaption></figcaption></figure>  </td>
</tr></table>

Open the Duo App on your device. Your mobile device screen should appear similar to Figure 5a. Tap the "+" in the upper right corner of the app to start the pairing process.  The app will launch the mobile device's camera.  Scan the generated QR code on your computer screen.  Do not scan the image on this tutorial's page. Then enter the Duo token code.

<table border="0"><tr>
<td><figure id="figurexa"><img border="1" src="../../imgs/tutorials/mfa-duo-showcode.png"> <figcaption></figcaption></figure></td>
<td><figure id="figurexa"><img border="1" src="../../imgs/tutorials/mfa-duo-314193.png"> <figcaption></figcaption></figure></td>
<td><figure id="figurexb"><img border="1" src="../../imgs/tutorials/mfa-authenticationpairing-3.png"> <figcaption></figcaption></figure></td>
</tr></table>

Pairing successful


<figure><img border="1" src="../../imgs/tutorials/mfa-pairingsuccessful.png" style="width:50%; height:50%"> <figcaption></figcaption></figure>

## [Logging into TACC Resources](#login) { #login }

A typical login session will look something like this:

``` 
% ssh -l slindsey ls6.tacc.utexas.edu
To access the system:

1) If not using ssh-keys, please enter your TACC password at the password prompt
2) At the TACC Token prompt, enter your 6-digit code followed by <return>.  

(slindsey@ls6.tacc.utexas.edu) Password: 
(slindsey@ls6.tacc.utexas.edu) TACC Token Code:
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


<!-- <table border="0"><tr>
<td><figure id="figure6a"><img alt="" src="../../imgs/tutorials/MFA-6a.png">
<figcaption> Figure 6a. SMS token code </figcaption></figure></td>
<td><figure id="figure6b"><img border="1" alt="" src="../../imgs/tutorials/MFA-6b.png">
<figcaption> Figure 6b. TACC Token App token code</figcaption></figure></td></tr></table> -->

## [International Users and Travelers](#international) { #international }

Users located outside the U.S. **must** pair using a [Multi-Factor Authentication app](#mfaapps) of your choice. Because the cost associated with sending multiple international text messages is prohibitive, international users may NOT set up multi-factor authentication with SMS.  

## [Unpairing your Device](#unpair) { #unpair }

You can unpair your device from the "Manage Account".  Depending upon the method of pairing you'll see a message similar to Figure 7.  

<figure id=""><img src="../../imgs/tutorials/mfa-unpairdevice.png" style="width:800px"></p>
<figcaption></figcaption></figure>

On the next screen you'll be asked to to confirm the unpairing.  Similar to the pairing process, you must verify unpairing by entering the token code when prompted.  If you've lost access to the device you originally paired with, you may unpair using email notification.

<table border="0"><tr>
<td><figure id=""><img alt="" src="../../imgs/tutorials/mfa-duo-626574.png" style="height:700px"></td>
<figcaption></figcaption></figure>
<td><figure id=""><img alt="" src="../../imgs/tutorials/mfa-unpairing.png" style="width:800px"></td>
<figcaption></figcaption></figure>
</tr></table>


