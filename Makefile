# WARNING: Using `docker-compose` is deprecated
DOCKER_COMPOSE_CMD := $(shell if command -v docker-compose > /dev/null; then echo "docker-compose"; else echo "docker compose"; fi)
DOCKERHUB_REPO := taccwma/tacc-docs
DOCKER_TAG_SHORTSHA ?= $(shell git rev-parse --short HEAD)
DOCKER_IMAGE_SHORTSHA := $(DOCKERHUB_REPO):$(DOCKER_TAG_SHORTSHA)
DOCKER_IMAGE_LATEST := $(DOCKERHUB_REPO):latest

####
# `DOCKER_IMAGE_BRANCH` tag is the git tag for the commit if it exists, else the branch on which the commit exists
DOCKER_IMAGE_BRANCH := $(DOCKERHUB_REPO):$(shell git describe --exact-match --tags 2> /dev/null || git symbolic-ref --short HEAD | sed 's/[^[:alnum:]\.\_\-]/-/g')

.PHONY: build
build:
	$(DOCKER_COMPOSE_CMD) -f ./docker-compose.yml build

.PHONY: build-full
build-full:
	$(DOCKER_COMPOSE_CMD) -f ./docker-compose.yml -t $(DOCKER_IMAGE_SHORTSHA) build
	docker tag $(DOCKER_IMAGE_SHORTSHA) $(DOCKER_IMAGE_BRANCH) # Note: Special chars replaced with dashes

.PHONY: publish
publish:
	docker push $(DOCKER_IMAGE_SHORTSHA)
	docker push $(DOCKER_IMAGE_BRANCH)

.PHONY: publish-latest
publish-latest:
	docker tag $(DOCKER_IMAGE_SHORTSHA) $(DOCKER_IMAGE_LATEST)
	docker push $(DOCKER_IMAGE_LATEST)

.PHONY: start
start:
	$(DOCKER_COMPOSE_CMD) -f docker-compose.yml up

.PHONY: stop
stop:
	$(DOCKER_COMPOSE_CMD) -f docker-compose.yml down
