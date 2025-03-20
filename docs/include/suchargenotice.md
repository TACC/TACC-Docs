#### New Charging Policy { #sunotice }

!!! important
	Beginning October 1st, 2024, TACC will be implementing a new, minimum SU-charge policy for all jobs run on our systems: 

	**All running jobs will be charged a minimum of 15 minutes of queue time regardless of actual runtime.  All other queue factors will remain the same.**

	For example:  a 2-node job in the Frontera's [`rtx` queue](#queues) which runs for one minute would be charged as follows:

		2 nodes * 0.25 hrs * 3 SUs = 1.5SUs

	These changes are necessary to ensure equal access to the queues for all users as TACC's user base expands.  Larger jobs may be the most affected and we encourage users to do thorough testing at smaller node counts before increasing the size of their jobs in order to reduce the impact of this change.  

