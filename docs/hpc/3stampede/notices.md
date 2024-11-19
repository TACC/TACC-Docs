# Stampede3 User Guide 
*Last update: October 30, 2024*

## Notices { #notices }

* **Important**: Please note [TACC's new SU charge policy](#sunotice). (09/20/2024)
* **Attention Jupyter users: learn how to [configure your environment](#python-jupyter) to enable notebooks.** (05/16/2024)
* **Attention VASP users: DO NOT run VASP using Stampede3's SPR nodes!**  TACC staff has noticed many VASP jobs causing issues on the SPR nodes and impacting overall system stability and performance.  Please run your VASP jobs using either the [SKX](../../hpc/stampede3#table3) or [ICX](../../hpc/stampede3#table4) nodes.  See [Running VASP Jobs](../../software/vasp/#running) for more information.  (05/06/2024)


## Introduction { #intro }

The National Science Foundation (NSF) has generously awarded the University of Texas at Austin funds for TACC's Stampede3 system ([Award Abstract # 2320757](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2320757)).  Please [reference TACC](https://tacc.utexas.edu/about/citing-tacc/) when providing any citations.   

### Allocations { #intro-allocations }

Submit all Stampede3 allocations requests through the NSF's [ACCESS](https://allocations.access-ci.org/) project. General information related to allocations, support and operations is available via the ACCESS website <http://access-ci.org>.

Requesting and managing allocations will require creating a username and password on this site. These credentials do not have to be the same as those used to access the TACC User Portal and TACC resources. Principal Investigators (PIs) and their allocation managers will be able to add/remove users to/from their allocations and submit requests to renew, supplement, extend, etc. their allocations. PIs attempting to manage an allocation via the [TACC User Portal](https://tacc.utexas.edu/portal/dashboard) will be redirected to the ACCESS website.

