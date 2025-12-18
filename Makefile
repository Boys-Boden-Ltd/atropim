# --- VARIABLES ---
# We use 'grep' to look inside your .env files and grab the PROJECT_NAME variable.
# This ensures that if you change the name in the file, the Makefile automatically updates.

DEV_PROJECT := $(shell grep PROJECT_NAME .env.dev | cut -d '=' -f2)
STAGING_PROJECT := $(shell grep PROJECT_NAME .env.staging | cut -d '=' -f2)
PROD_PROJECT := $(shell grep PROJECT_NAME .env.prod | cut -d '=' -f2)

# --- COMMANDS ---
# We use the variable $(DEV_PROJECT) instead of a hardcoded name
CMD_DEV := docker-compose -p $(DEV_PROJECT) -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev
CMD_STAGING := docker-compose -p $(STAGING_PROJECT) -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.staging
CMD_PROD := docker-compose -p $(PROD_PROJECT) -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod

# --- HELP ---
help:
	@echo "Current Dev Project Name: $(DEV_PROJECT)"
	@echo "----------------------------------------------------------------------"
	@echo "  make dev          : Start Local Dev Server"
	@echo "  make dev-down     : Stop Local Dev Server"
	@echo "  make dev-clean    : Destroy Dev Database & Networks (Start Fresh)"

# --- DEVELOPMENT (Local) ---
dev:
	$(CMD_DEV) up -d
	@echo ">> Dev environment started (Project: $(DEV_PROJECT))"

dev-logs:
	$(CMD_DEV) logs -f

dev-down:
	$(CMD_DEV) down

# Run this if you get network errors!
dev-clean:
	$(CMD_DEV) down -v --remove-orphans
	@echo ">> Cleaned up $(DEV_PROJECT)"

dev-enter:
	$(CMD_DEV) exec app bash

# --- STAGING & PROD (Keep these simple for now) ---
staging:
	$(CMD_STAGING) up -d

prod:
	$(CMD_PROD) up -d
