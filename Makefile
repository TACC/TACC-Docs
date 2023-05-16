.PHONY: build
build:
	docker-compose -f ./docker-compose.yml build

.PHONY: start
start:
	docker-compose -f docker-compose.yml up

.PHONY: stop
stop:
	docker-compose -f docker-compose.yml down
