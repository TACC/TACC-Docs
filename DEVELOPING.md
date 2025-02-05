# How to Develop

We use [Poetry](https://python-poetry.org/) to manage dependencies. We deploy via [Docker](https://www.docker.com/) and strongly suggest development via Docker.

## Testing

Testing is manual and requires using a command prompt. You can test [via Python](./TESTING.md#a-via-python) or [via Docker](./TESTING.md#b-via-docker).

## Theming

We use custom files ([CSS, JS, ES, plugins, extensions](https://github.com/TACC/TACC-Docs/blob/v0.15.0/mkdocs.base.yml), and [overrides](https://github.com/TACC/TACC-Docs/tree/v0.15.0/themes/tacc-readthedocs)) to customize MkDocs.

To theme another MkDocs project to look [like this](https://docs.tacc.utexas.edu/), please contact [@wesleyboar](https://www.github.com/wesleyboar).

> [!NOTE]
> We will eventually [update our theme to MkDocs Material](https://github.com/TACC/TACC-Docs/issues/53) and [offer our theme properly](https://github.com/TACC/TACC-Docs/issues/76).
