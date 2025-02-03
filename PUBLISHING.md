# How to Publish

> [!TIP]
> Any merge (or commit) to `main` branch will publish the documentation.

All commits to `main` will trigger a Docker build and push a new image to `taccwma/tacc-docs:latest`.

A Watchtower service will monitor new pushes to this dockerhub repo and pull down new images _on the fly_ to [https://docs.tacc.utexas.edu/](https://docs.tacc.utexas.edu/).

## Automation

* Automatic build for every commit to `main` branch
* Automatic deploy for every build off `main` branch
* Manually build via [GitHub Actions](https://github.com/TACC/TACC-Docs/actions)
* Manually deploy via [internal process](https://tacc-main.atlassian.net/wiki/x/aBhv)

## Releases

[Releases](https://github.com/TACC/TACC-Docs/releases) are made when a significant set of **functional** Pull Requests have been merged.

> [!NOTE]
> Releases are only used by clients of the TACC MkDocs [configuration](https://github.com/TACC/TACC-Docs/blob/v0.14.0/mkdocs.base.yml) and [theme](https://github.com/TACC/TACC-Docs/tree/v0.14.0/themes/tacc-readthedocs), so changes to the content of documents do **not** merit a release.
