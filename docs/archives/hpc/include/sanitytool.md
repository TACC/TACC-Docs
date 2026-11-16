### Account-Level Diagnostics { #using-account-diagnostics }

TACC's `sanitytool` module loads an account-level diagnostic package that detects common account-level issues and often walks you through the fixes. You should certainly run the package's `sanitycheck` utility when you encounter unexpected behavior. You may also want to run `sanitycheck` periodically as preventive maintenance. To run `sanitytool`'s account-level diagnostics, execute the following commands:

```cmd-line
login1$ module load sanitytool
login1$ sanitycheck
```

Execute `module help sanitytool` for more information.

