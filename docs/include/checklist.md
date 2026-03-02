### Account-Level Diagnostics { #using-account-diagnostics }

TACC's `checklist` module loads an account-level diagnostic package that detects common account-level issues and often walks you through the fixes. You should certainly run the package's `checklist` utility when you encounter unexpected behavior. You may also want to run `checklist` periodically as preventive maintenance. To run `checklist`'s account-level diagnostics, execute the following commands:

```cmd-line
login1$ module load checklist
login1$ checklist
```

Execute `module help checklist` for more information.

