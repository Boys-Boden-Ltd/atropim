# Ensure bash is used for consistency
SHELL := /bin/bash

# Extract Project Names from Env Files
DEV_PROJECT := $(shell grep PROJECT_NAME .env.dev 2>/dev/null | cut -d '=' -f2)
STAGING_PROJECT := $(shell grep PROJECT_NAME .env.staging 2>/dev/null | cut -d '=' -f2)
PROD_PROJECT := $(shell grep PROJECT_NAME .env.prod 2>/dev/null | cut -d '=' -f2)

# Define Command Shortcuts
CMD_DEV := docker-compose -p $(DEV_PROJECT) -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev
CMD_STAGING := docker-compose -p $(STAGING_PROJECT) -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.staging
CMD_PROD := docker-compose -p $(PROD_PROJECT) -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod

# Prevent conflicts with file names
.PHONY: help dev dev-build dev-down dev-clean dev-logs dev-enter dev-restart staging prod

help:
	@echo "Project: $(DEV_PROJECT)"
	@echo "----------------------------------------------------------------------"
	@echo "  make dev          : Start Local Dev Server"
	@echo "  make dev-build    : Rebuild Docker Images (No Cache)"
	@echo "  make dev-down     : Stop Local Dev Server"
	@echo "  make dev-restart  : Restart containers"
	@echo "  make dev-logs     : Tail logs (Ctrl+C to exit)"
	@echo "  make dev-enter    : Enter the App container (bash)"
	@echo "  make dev-clean    : Destroy Database, Networks, and DELETE html/ code"

dev:
	@echo ">> Starting Dev Environment..."
	$(CMD_DEV) up -d
	@echo ">> App is starting. Note: First run takes ~60s to install Composer dependencies."

dev-build:
	@echo ">> Rebuilding Images..."
	$(CMD_DEV) build --no-cache
	$(CMD_DEV) up -d

dev-down:
	$(CMD_DEV) down

dev-restart: dev-down dev

dev-logs:
	$(CMD_DEV) logs -f

dev-enter:
	$(CMD_DEV) exec app bash

dev-clean:
	@echo ">> ⚠️  WARNING: This will destroy the Database and ALL code in /html"
	@echo ">> Stops in 3 seconds... (Ctrl+C to cancel)"
	@sleep 3
	$(CMD_DEV) down -v --remove-orphans
	@echo ">> Removing html directory..."
	@# We use a docker container to remove the files to avoid permission issues on Linux
	@docker run --rm -v $(PWD):/mnt alpine sh -c "rm -rf /mnt/html 2>/dev/null || true"
	@echo ">> Environment Reset Complete."

staging:
	$(CMD_STAGING) up -d

prod:
	$(CMD_PROD) up -d
