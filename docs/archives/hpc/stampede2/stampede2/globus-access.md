## Globus for ACCESS Users { # }

ACCESS users may connect to Stampede2 and Ranch via Globus endpoints to manage and transfer files (called collections). 

<p class="portlet-msg-info"><b>Tip</b> <b>Key Concept: <i>Collection</i></b> A collection is a named location containing data you can access with Globus. Collections can be hosted on many different kinds of systems, including campus storage, HPC clusters, laptops, Amazon S3 buckets, Google Drive, and scientific instruments.  When you use Globus, you don't need to know a physical location or details about storage. You only need a collection name. A collection allows authorized Globus users to browse and transfer files. Collections can also be used for sharing data with others and for enabling discovery by other Globus users. <a href="https://www.globus.org/globus-connect" target="_blank">Globus Connect</a> is used to host collections.</p>

### Transfer a file { # }

This step-by-step guide will show ACCESS users how to log into Globus and use it to transfer files reliably and securely. See [Globus' Getting Started Guide](https://docs.globus.org/how-to/get-started/) for more detailed information. 

In this step-by-step guide we'll demonstrate a *trivial* example of transferring a file from TACC's Stampede2 to TACC's Ranch archival tape system. 

### 1. Do all the necessary authentications (globus, then ACCESS) { # }

Log in to <a href="https://www.globus.org/" target="_blank">www.globus.org</a> with your ACCESS (formerly XSEDE) credentials.  Click &quot;Login&quot; at the top right of the page. 

<img width="600px" src="./imgs/Globus-01.png">  

On the Globus login page, choose an ACCESS-CI organization.   

<img width="600px" src="./imgs/Globus-02.png">  

You'll be redirected to the ACCESS login page. Use your ACCESS credentials for that organization to login. 

<img width="600px" src="./imgs/Globus-03.png">  

### 2. The File Manager - Access your collections. { # }

After you've signed up and logged in to Globus, you'll land at the Globus File Manager. 

<img width="600px" src="./imgs/Globus-04.png">  

The first time you use the File Manager, all fields will be blank. 

<img alt="" src="/documents/10157/2162551/ACCESS-Globus-4/47a545d6-c8f4-42d7-90be-be43cc30cda5?t=1663790136000" style="width: 700px; height: 488px; border-width: 1px; border-style: solid;" />  
<img width="600px" src="./imgs/Globus-05.png">  


3. Find your TACC Stampede2 or Ranch directories that are available using ACCESS OAuth authentication. 

Click in the Collection field at the top of the File Manager page 

	<img alt="" src="/documents/10157/2162551/ACCESS-Globus-5/0efe4b3d-242b-411e-9ec2-d205aee9aa04?t=1663790161000" style="width: 700px; height: 290px; border-width: 1px; border-style: solid;" />

<img width="600px" src="./imgs/Globus-06.png">  

4. View your Stampede2 (or Ranch)  Collection 

	<img alt="" src="/documents/10157/2162551/ACCESS-Globus-6/9f5da937-3a3f-4439-9dc5-487b0f2dfd0d?t=1663790185000" style="width: 700px; height: 287px; border-width: 1px; border-style: solid;" />

<p class="portlet-msg-info"><b>Tip</b> <b>Key Concept: <i>Fire-And-Forget Data Transfer</i></b> After you request a file transfer, Globus takes over and does the work on your behalf. You can navigate away from the File Manager, close the browser window, and even logout. Globus will optimize the transfer for performance, monitor the transfer for completion and correctness, and recover from network errors and collection downtime. </p>

### Initiate a File Transfer  { # }

Click Transfer or Sync to... in the command panel on the right side of the page. A new collection panel will open, with a &quot;Transfer or Sync to&quot; field at the top of the panel. 

<img alt="" src="/documents/10157/2162551/ACCESS-Globus-7/510750c8-62ee-4dba-a0cb-31622fb08ef2?t=1663790214000" style="width: 700px; height: 305px; border-width: 1px; border-style: solid;" />

Click on the left collection and select a file. The Start&gt; button at the bottom of the panel will activate. 

<img alt="" src="/documents/10157/2162551/ACCESS-Globus-8/f1304f5d-f421-485c-92dc-bca783cb57db?t=1663790241000" style="width: 700px; height: 296px; border-width: 1px; border-style: solid;" />

Between the two Start buttons at the bottom of the page, the Transfer &amp; Sync Options tab provides access to several options. By default, Globus verifies file integrity after transfer using checksums.  

<img alt="" src="/documents/10157/2162551/ACCESS-Globus-9/337f0eb9-d532-438c-846c-e03a48f4bf0b?t=1663790270000" style="width: 700px; height: 296px; border-width: 1px; border-style: solid;" />

Click the Start&gt; button to transfer the selected files to the collection in the right panel.  Globus will display a green notification panel—​confirming that the transfer request was submitted—​and add a badge to the Activity item in the command menu on the left of the page.   

<img alt="" src="/documents/10157/2162551/ACCESS-Globus-10/cb3cae0d-37dd-49e7-9060-626c93df0f84?t=1663790297000" style="width: 700px; height: 278px; border-width: 1px; border-style: solid;" />


6. Verify transfer completion 

Click Activity in the command menu on the left of the page to go to the Activity page.

<img alt="" src="/documents/10157/2162551/ACCESS-Globus-11/8896a4c5-48fb-462d-9403-9df8e6531ac6?t=1663790330000" style="width: 700px; height: 278px; border-width: 1px; border-style: solid;" />

On the Activity page, click the arrow icon on the right to view details about the transfer. You will also receive an email with the transfer details.   
<img alt="" src="/documents/10157/2162551/ACCESS-Globus-12/6f1085be-9676-4de0-88a1-8e9ed5866116?t=1663790368000" style="width: 700px; height: 314px; border-width: 1px; border-style: solid;" />

Click File Manager in the command menu on the left of the Activity page to return to the File Manager. The collections you were viewing before will reappear. Click the refresh icon (circular arrows) at the top of the collection panel to see the updated contents 


### More Info { # }


