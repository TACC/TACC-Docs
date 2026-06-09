## Allocations { #allocations }

Lonestar6 is available to researchers from all University of Texas System institutions and to our partners, Texas A&amp;M University, Texas Tech University and University of North Texas.

UT System Researchers may submit allocation requests for compute time on Lonestar6 via TACC's new [Texas Resource Allocation System](https://submit-tacc.xras.org) (TxRAS).  Consult the [Allocations](https://tacc.utexas.edu/use-tacc/allocations/) page for details.

Researchers at our partner institutions may submit allocation requests through the links below.

* [Texas A&amp;M University](https://hprc.tamu.edu/user_services/new_user_information.html)
* [Texas Tech University](https://www.depts.ttu.edu/hpcc/about/services.php)
* [University of North Texas](https://research.unt.edu/research-services/research-computing)

!!! important 
	You must be added to a Lonestar6 allocation in order to have access/login to Lonestar6.

### Monitor Allocation Usage { #admin-allocations }

Once you've been awarded or added to an allocation, you may monitor usage in one of two ways:


1. The `taccinfo` command will display a summary of your TACC project balances and disk quotas at any time.  Invoke the command using the absolute path as shown below.  This output is generally more current than balances displayed on the portals.

	```cmd-line
	login1$ /usr/local/etc/taccinfo			
	--------------------- Project balances for user bjones ------------------------
	| Name           Avail SUs     Expires | Name           Avail SUs     Expires |
	| A-ccsc            342808  2030-09-30 | A-cciq              4828  2026-09-30 |
	------------------------ Disk quotas for user blones --------------------------
	| Disk         Usage (GB)     Limit    %Used   File Usage       Limit   %Used |
	| /scratch            6.6       0.0     0.00        22742           0    0.00 |
	| /home1              2.5      10.0    25.07        18488           0    0.00 |
	| /work               1.1    1024.0     0.11        23890     3000000    0.80 |
	-------------------------------------------------------------------------------
	```

1.  Principal Investigators can monitor allocation usage via the [TACC User Portal][TACCUSERPORTAL] under ["Allocations->Projects and Allocations"][TACCALLOCATIONS]. Be aware that the figures shown on the portal may lag behind the most recent usage.  

