UID ?= $(shell id -u)

COMPOSE = env UID=$(UID) docker-compose -f docker-compose.yml -f docker-compose.mount-volume.yml
COMPOSE_DEVELOPMENT = env UID=$(UID) RAILS_ENV='development' docker-compose -f docker-compose.yml -f docker-compose.mount-volume.yml

.PHONY: docker-down
docker-down:
	$(COMPOSE) down

.PHONY: docker-build
docker-build:
	$(COMPOSE) build --parallel

.PHONY: shell
shell: docker-down docker-build
	$(COMPOSE) up -d
	$(COMPOSE) exec app ash

.PHONY: spec
spec: docker-down docker-build test lint

.PHONY: test
test: docker-down docker-build
	$(COMPOSE) run --rm app bundle exec rspec

.PHONY: lint
lint:
	$(COMPOSE) run --rm app bundle exec rubocop

.PHONY: fix
fix:
	$(COMPOSE) run --rm app bundle exec rubocop -a

.PHONY: serve
serve: docker-down docker-build
	$(COMPOSE_DEVELOPMENT) run --rm --service-ports app
