FROM python:3.12-slim AS python-base

LABEL maintainer="TACC COA CMD <coa-cmd@tacc.utexas.edu>"

ARG DEBIAN_FRONTEND=noninteractive

# https://python-poetry.org/docs/configuration/#using-environment-variables
ENV POETRY_VERSION=2.1.1 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

RUN apt-get update && apt-get install -y --no-install-recommends locales \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

FROM python-base AS builder-base

RUN pip3 install --upgrade pip setuptools wheel \
    && pip3 install "poetry==${POETRY_VERSION}"

# copy project requirement files here to ensure they will be cached.
WORKDIR $PYSETUP_PATH
COPY pyproject.toml poetry.lock ./

# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
RUN poetry install --only main --no-root

# `production` image is used for deployed runtime environments
FROM python-base AS production

COPY --from=builder-base $PYSETUP_PATH $PYSETUP_PATH

COPY . /docs
WORKDIR /docs
