# WARNING: Using `docker-compose` is deprecated
DOCKER_COMPOSE_CMD := $(shell if command -v docker-compose > /dev/null; then echo "docker-compose"; else echo "docker compose"; fi)

.PHONY: build
build:
	$(DOCKER_COMPOSE_CMD) -f ./docker-compose.yml build

.PHONY: start
start:
	$(DOCKER_COMPOSE_CMD) -f docker-compose.yml up

.PHONY: stop
stop:
	$(DOCKER_COMPOSE_CMD) -f docker-compose.yml down
