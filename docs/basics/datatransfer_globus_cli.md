# Globus CLI Guide

You can use the [Globus Command Line Interface (CLI)](https://docs.globus.org/cli/) to manage Globus transfers from the command line, or from a script or cron job.

## Installation QuickStart (Linux)

```bash
sudo apt install pipx
pipx install globus-cli
```

Add `globus` to your `$PATH` (example):

```text
/home/username/.local/bin
```

Log in to Globus:

```bash
globus login
```

## Globus Transfer Command

```bash
globus transfer --help
```

Usage:

```text
globus transfer [OPTIONS] SOURCE_ENDPOINT_ID[:SOURCE_PATH] DEST_ENDPOINT_ID[:DEST_PATH]
```

## Finding Globus Endpoint IDs

To copy files between two Globus servers using the CLI, you must first obtain the endpoint IDs.

Example searches:

```bash
globus endpoint search "TACC"
```

ID for TACC DTN on Stampede3:

```text
1e9ddd41-fe4b-406f-95ff-f3d79f9cb523
```

```bash
globus endpoint search "myHomeInstitution"
```

## Directory Listing for an Endpoint

```bash
globus ls 1e9ddd41-fe4b-406f-95ff-f3d79f9cb523
```

## Starting a Transfer

For example, copy data from your home institution to Stampede3:

```bash
globus transfer   my_instutions_globus_id:/my_dataset 1e9ddd41-fe4b-406f-95ff-f3d79f9cb523:/scratch/my_tacc_username
```

This command returns a **task ID**.

## Monitoring a Transfer

```bash
globus task show <TASK_ID>
```

You can also monitor transfer status by logging into [globus.org](https://globus.org) and selecting **Activity**.

---

## Transferring Files to a Laptop or Desktop

To transfer files to your local machine, use **Globus Connect Personal (GCP)**.

## GCP Installation (Linux)

```bash
wget https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz
tar xvzf globusconnectpersonal-latest.tgz
cd globusconnectpersonal-3.2.7
./globusconnectpersonal -setup
```

## Starting GCP

```bash
./globusconnectpersonal -start &
```

(Runs in the background)

## Finding Your Local Endpoint ID

```bash
globus endpoint local-id
```

Use this endpoint ID with `globus transfer` as shown above.

## Additional Documentation

- [Globus CLI Quickstart](https://docs.globus.org/cli/quickstart/)
- [Globus Connect Personal](https://docs.globus.org/globus-connect-personal)
