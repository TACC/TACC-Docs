# Gaussian at TACC
*Last update: April 22, 2024* 

<!-- ![Gaussian logo](../imgs/gaussian-logo.png){ .align-right width="300" } -->
<img src="../imgs/gaussian-logo.webp" width="300" alt="Gaussian logo" align="right">

Gaussian is a quantum mechanics package for calculating molecular properties from first principles. From the Gaussian website:

> Starting from the fundamental laws of quantum mechanics, Gaussian 16 predicts the energies, molecular structures, vibrational frequencies and molecular properties of compounds and reactions in a wide variety of chemical environments. Gaussian 16's models can be applied to both stable species and compounds which are difficult or impossible to observe experimentally, whether due to their nature (e.g., toxicity, combustibility, radioactivity) or their inherent fleeting nature (e.g., short-lived intermediates and transition structures).


## Licenses { #licenses }

TACC's Gaussian license allows academic users who have signed a Usage Agreement to use the Gaussian software on TACC compute systems. Users do not need to bring their own individual licenses.  Depending on your home institution, gaining access to Gaussian requires that you sign and return one of the following forms:

### UT Austin Students, Staff, and Faculty { #access-ut }

TACC must maintain a physical copy of a [Confidentiality Agreement](../taccdocs/UT_gaussian_confidentiality_agreement.pdf) for all UT Austin users.  It is easiest to print, sign, and send back this [Confidentiality Agreement](../taccdocs/UT_gaussian_confidentiality_agreement.pdf) by campus mail to "TACC - Gaussian" at mail code R8700.  Submit a consulting ticket notifying TACC staff that you have mailed the agreement so that we can expect it and easily follow up with you.


### Other Academic Users { #access-other }

Please fill out the [Usage Agreement](../taccdocs/UT_gaussian_user_agreement.pdf) and open a consulting ticket with the agreement as an attachment to the ticket.  TACC maintains digital copies of Usage Agreements for all TACC users not from UT Austin. Once you have sent in a signed version of the [required agreement](../taccdocs/UT_gaussian_user_agreement.pdf), TACC staff can open up access to you of the Gaussian module on all systems on which the module is installed.  


## Running Gaussian { #running }

Gaussian 16 is currently installed on TACC's Stampede3, Frontera and Lonestar6 compute resources. Gaussian is accessed via TACC's [Lmod module][TACCLMOD] system. Use `module spider gaussian` and `module help gaussian` to list and explore installed versions. Then, either interactively or via a batch script, load the appropriate module:

``` cmd-line
login1$ module load gaussian
```

## Sample Job Script { #script }

The Linda MPI addon is not part of TACC's Gaussian module, so each Gaussian execution cannot use more than one node. In the Gaussian input file, (`input.conf` in the example below), set the `%NProcShared` variable to the number of CPU cores you wish to use. Do not use the `ibrun` invocation. 

Gaussian job submission scripts should look something like the following: 

```job-script
#!/bin/bash
#SBATCH -J my_job_name   # Job Name
#SBATCH -o output.%j     # Output file name (%j expands to jobID)
#SBATCH -e error.%j      # Error file name (%j expands to jobID)
#SBATCH -N 1 -n 1        # Gaussian only uses one node
#SBATCH -p normal        # Queue name -- normal, development, etc.
#SBATCH -t 24:00:00      # Run time (hh:mm:ss)
#SBATCH -A project       # You can remove this line if you only have one allocation

module load gaussian

g16 < input.conf > output.log
```

## References { #refs }

* [Gaussian site](https://gaussian.com)
* [Gaussian manual](https://gaussian.com/man/)

{% include 'aliases.md' %}
