DEV_PROJECT := $(shell grep PROJECT_NAME .env.dev | cut -d '=' -f2)
STAGING_PROJECT := $(shell grep PROJECT_NAME .env.staging | cut -d '=' -f2)
PROD_PROJECT := $(shell grep PROJECT_NAME .env.prod | cut -d '=' -f2)

CMD_DEV := docker-compose -p $(DEV_PROJECT) -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev
CMD_STAGING := docker-compose -p $(STAGING_PROJECT) -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.staging
CMD_PROD := docker-compose -p $(PROD_PROJECT) -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod

help:
	@echo "Current Dev Project Name: $(DEV_PROJECT)"
	@echo "----------------------------------------------------------------------"
	@echo "  make dev          : Start Local Dev Server"
	@echo "  make dev-down     : Stop Local Dev Server"
	@echo "  make dev-clean    : Destroy Dev Database & Networks (Start Fresh)"

dev:
	$(CMD_DEV) up -d
	@echo ">> Dev environment started (Project: $(DEV_PROJECT))"

dev-logs:
	$(CMD_DEV) logs -f

dev-down:
	$(CMD_DEV) down

dev-clean:
	$(CMD_DEV) down -v --remove-orphans
	@echo ">> Cleaned up $(DEV_PROJECT)"

dev-enter:
	$(CMD_DEV) exec app bash

staging:
	$(CMD_STAGING) up -d

prod:
	$(CMD_PROD) up -d
