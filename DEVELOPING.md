# How to Develop

Manage dependencies via [Poetry v2](https://python-poetry.org/). Serve docs via [MkDocs](https://www.mkdocs.org/). [Test manually.](#testing) Deploys are [automated](./PUBLISHING.md).

## How to Edit the Theme

To change the TACC documentation theme, [contribute to `mkdocs-tacc`](https://github.com/TACC/mkdocs-tacc/blob/main/CONTRIBUTING.md).

To change just this project, learn how to [configure](https://tacc.github.io/mkdocs-tacc/configure) & [customize](https://tacc.github.io/mkdocs-tacc/customize).

To make functional changes, [use extensions](https://tacc.github.io/mkdocs-tacc/extensions/).

## How to Upgrade the Theme

1. ```shell
    poetry remove mkdocs-tacc
    poetry add "mkdocs-tacc[all]"@latest
    ```
2. Verify changes in:
    - `pyproject.toml`
    - `poetry.lock`
3. Test.
4. Commit.

## How to Test Your Changes

> [!NOTE]
> Testing is manual and requires using a command prompt.

You can [test with **PIP** or **Poetry** or **Docker** or **Make**](https://tacc.github.io/mkdocs-tacc/test/#test-locally).
