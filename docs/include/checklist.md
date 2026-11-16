TACC's `checklist` utility detects and diagnoses common account-level issues. Checklist evaluates the access/availability of critical HPC components in a user's environment such as queue availability and access, file system availability and quotas, allocations, SSH keys and more.  

Run this utility when you encounter unexpected account behavior and periodically as preventive maintenance.  

```cmd-line
login1.ls6$ checklist -t          # display terse output

 [PASS] 01 SSH: OK Permissions: keys & .ssh dir; pub key in authorized_keys file.
 [PASS] 02 FILE SYSTEMS: Defined and Accessible (HOME SCRATCH WORK STOCKYARD)
 [PASS] 03 FILESYSTEM QUOTAS: (/tmp 75%  /home1 80%  /work 99%   %remaining)
 [PASS] 04 MODULES: TACC and intel Loaded.
 [PASS] 05 COMPILERS: intel: icc icpc ifort gcc: gcc g++ gfortran
 [PASS] 06 PROJECTS: (A-ccsc 85%  A-cciq 96%  OTH24028 12%  %remain)
 [PASS] 07 BATCH: SLURM cmds found: sbatch scancel squeue.  ALL QUEUES UP.
 [PASS] 08 RESERVATIONS: None.
 [PASS] 09 QUEUE ACCESS:  No Restrictions.
```

