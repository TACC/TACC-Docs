# How to Contribute

We are glad you are reading this. We welcome your contribution.

Here are some important resources:

  * [Known Issues](https://github.com/TACC/TACC-Docs/issues)
  * [Active Proposals](https://github.com/TACC/TACC-Docs/pulls)
  * [How to Test](./TESTING.md)

## Step by Step

1. [Fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) this repository.\
    <sup>(unless you are a direct collaborator)</sup>
2. [Edit](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files) relevant files that need update.\
    <sup>([upload images](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository) as necessary)</sup>
4. [Commit](https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/about-commits) your changes.\
    <sup>(write [clear commit messages](#writing-commit-messages))</sup>
5. [Test](#testing) your changes.\
    <sup>(if comfortable using a command prompt)</sup>
6. [Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) a review.\
    <sup>(a.k.a. create a "Pull Request")</sup>

## Writing Commit Messages

Always write a clear log message for your commits. One-line messages are fine for small changes, but bigger changes should look like this:

> **A brief summary of the commit**

> A paragraph describing what changed and its impact.

## Style Guide

Start reading our newer docs and you'll get the hang of it. We optimize for readability:

* We add a new line before starting a list
* We indent using tab character
* We create lists with asterisks
* We should use [Markdown](https://www.markdownguide.org/extended-syntax/) where available[^1]
* We use some [Python-Markdown extensions](https://python-markdown.github.io/extensions/) and [PyMdown exensions](https://facelessuser.github.io/pymdown-extensions/#extensions)[^2]
* Use `cwd`-relative paths to images e.g. instead of `/hpc/imgs/blah.gif`, use `../imgs/blah.gif`.[^3]

[^1]: If some of our documents use HTML, please forgive us and use Markdown yourself.
[^2]: See enabled extensions at [`mkdocs.base.yml`](https://github.com/TACC/TACC-Docs/blob/main/mkdocs.base.yml) under `markdown_extensions:`.
[^3]: So that images load on the website **and** in GitHub preview.

Thanks,
Texas Advanced Computing Center
