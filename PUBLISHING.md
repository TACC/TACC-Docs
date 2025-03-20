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

[Releases](https://github.com/TACC/TACC-Docs/releases) are for a significant set of merged **functional** Pull Requests. Changes to content of documents do **not** merit a release.

> [!NOTE]
> Releases should be uncommon since the theme was migrated to [TACC/mkdocs-tacc](https://github.com/TACC/mkdocs-tacc) (in [TACC/TACC-Docs#95](https://github.com/TACC/TACC-Docs/pull/95)).
