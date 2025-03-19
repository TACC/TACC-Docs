# Contributing to TACC Technical Documentation

All contributions should be made via a GitHub pull request.  The pull requests will be reviewed by TACC's User Services staff, and if approved, incorporated into our documentation.

## Step by Step

1. [Fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) this repository.
1. [Edit](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files) relevant files that need update.  [Upload images](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository) as necessary.
1. [Commit](https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/about-commits) your changes, writing [clear commit messages](#writing-commit-messages).
1. [Test](./TESTING.md) your changes if comfortable using a command prompt.
1. [Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) a review. This creates a "Pull Request".


## Style Guide

* Use [Markdown](https://www.markdownguide.org/) for your source text.
* Use `cwd`-relative paths to images e.g. instead of `/hpc/imgs/myimage.png`, use `../imgs/myimage.png` so that images load on the website **and** in GitHub preview.
* Some [Python-Markdown extensions](https://python-markdown.github.io/extensions/) and [PyMdown exensions](https://facelessuser.github.io/pymdown-extensions/#extensions) are enabled.  See enabled extensions at [`mkdocs.base.yml`](https://github.com/TACC/TACC-Docs/blob/main/mkdocs.base.yml) under `markdown_extensions:`.

### Writing Commit Messages

Always write a clear log message for your commits. One-line messages are fine for small/typo changes, but more involved edits should include:

> **A brief summary of the commit**
> A not-so-brief description of what changed and its impact.

## Important Resources

  * [Known Issues](https://github.com/TACC/TACC-Docs/issues)
  * [Active Proposals](https://github.com/TACC/TACC-Docs/pulls)
  * [How to Test](./TESTING.md)


