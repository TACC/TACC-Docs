# TACC Core CMS

The base CMS code for TACC WMA Workspace Portals & Websites

## Local Development Setup

Local development instructions assume the use of Docker.

_You may choose instead to locally develop directly via [MkDocs], in which case you should install Poetry and run `poetry install` before using `mkdocs` commands._

[MkDocs]: https://www.mkdocs.org/

### Prequisites for Running the Docs

#### Via Docker

* Docker v20.10.7 (minimum)
* Docker Compose v1.29.2 (minimum)

The Docs can be run using [Docker][1] and [Docker Compose][2]. You will
need both Docker and Docker Compose pre-installed on the system you wish to run the Docs
on.

If you are on a Mac or a Windows machine, the recommended method is to install
[Docker Desktop](https://www.docker.com/products/docker-desktop), which will install both Docker and Docker Compose as well as Docker
Machine, which is required to run Docker on Mac/Windows hosts.

#### Without Docker

* Python v3.10 (minimum)
* Poetry v1.4 (minimum)

Verify both versions in [Dockerfile] at `python:` and `POETRY_VERSION`.


### Running the Docs

**Via Docker**:

2. [Create and run][docker-compose-up] the CMS and database containers:

    ```bash
    docker-compose up
    ```

[docker-compose-up]: https://docs.docker.com/compose/reference/up/

**Without Docker**:

1. **Create and/or Activate a [Python venv](https://docs.python.org/3/library/venv.html).**
2. Confirm Python and Poetry versions match or exceed those in [Dockerfile].
3. Install dependencies:
    * `poetry install`
4. Build and/or Serve the website:
    * **either** `mkdocs build`\
        and you serve the files
    * **or** `mkdocs serve`

## Linting and Formatting Conventions

Not standardized. See [(internal) Formatting & Linting](https://confluence.tacc.utexas.edu/x/HoBGCw).


## Automatic Builds

Automatic builds (not deploys) should occur on pushes to any branch.[^1]


## Automatic Deployment

Automatic deploys should occur after an automatic build on the `main` branch.[^1]


## Contributing

### Development Workflow

We use a modifed version of [GitFlow](https://datasift.github.io/gitflow/IntroducingGitFlow.html) as our development workflow. Our [development site](https://dev.cep.tacc.utexas.edu) (accessible behind the TACC Network) is always up-to-date with `main`, while the [production site](https://prod.cep.tacc.utexas.edu) is built to a hashed commit tag.
- Feature branches contain major updates, bug fixes, and hot fixes with respective branch prefixes:
    - `task/` for features and updates
    - `bug/` for bugfixes
    - `fix/` for hotfixes

### Best Practices

Sign your commits ([see this link](https://help.github.com/en/github/authenticating-to-github/managing-commit-signature-verification) for help)

### Resources

* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)


<!-- Footnotes -->

[^1]: To manually build or deploy, consult [our internal documentation](https://confluence.tacc.utexas.edu/x/uQaSEg).

<!-- Link Aliases -->

[1]: https://docs.docker.com/get-docker/
[2]: https://docs.docker.com/compose/install/
[Dockerfile]: https://github.com/TACC/TACC-Docs/blob/main/Dockerfile
