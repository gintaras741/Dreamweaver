# Run `make help` to see all targets.
# Recipes run in bash (Git Bash on Windows).

ifeq ($(OS),Windows_NT)
# bash on PATH is WSL's, so point to Git Bash directly (short path, make doesn't like spaces)
# if git is installed somewhere else: make GIT_BASH=path/to/bash.exe <target>
GIT_BASH ?= C:/PROGRA~1/Git/bin/bash.exe
SHELL := $(GIT_BASH)
else
SHELL := bash
endif
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

# load .env so the API gets the config
ifneq (,$(wildcard .env))
include .env
export
endif

API_PROJECT  := backend/Dreamweaver.Api
EF           := dotnet tool run dotnet-ef --project $(API_PROJECT)
COMPOSE_DEV  := docker compose -f docker-compose.dev.yml
COMPOSE_PROD := docker compose -f docker-compose.yml

.PHONY: help setup dev-db dev migrate migration reset-db openapi test demo-api up down

help: ## List available targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

setup: ## Restore .NET packages and tools, install npm packages, create .env
	dotnet restore backend/Dreamweaver.sln
	dotnet tool restore
	npm ci
	npm ci --prefix frontend
	@if [ ! -f .env ]; then cp .env.example .env && echo "Created .env from .env.example"; fi

dev-db: ## Start PostgreSQL (docker-compose.dev.yml) and wait until it is healthy
	$(COMPOSE_DEV) up -d --wait

dev: dev-db ## Run the API (dotnet watch, https://localhost:5001) and Vite (http://localhost:5173)
	npx concurrently --kill-others-on-fail --names api,web --prefix-colors cyan,magenta \
		"dotnet watch --project $(API_PROJECT) run --launch-profile https" \
		"npm run dev --prefix frontend"

migrate: ## Apply EF Core migrations
	$(EF) database update

migration: ## Add a migration: make migration name=AddSomething
	@if [ -z "$${name:-}" ]; then echo "Usage: make migration name=MigrationName"; exit 1; fi
	$(EF) migrations add $(name) --output-dir Data/Migrations

reset-db: ## Drop the database and re-apply migrations (the API seeds on next start)
	$(EF) database drop --force
	$(EF) database update

openapi: ## Export the OpenAPI spec to docs/openapi.json and regenerate the Orval client
	dotnet build $(API_PROJECT) -p:OpenApiGenerateDocuments=true
	@if [ -f frontend/src/api/http.ts ]; then npm run generate:api --prefix frontend; \
	else echo "Skipping Orval: frontend/src/api/http.ts (the fetch mutator) does not exist yet."; fi

test: ## Backend integration tests + frontend typecheck and lint
	dotnet test --solution backend/Dreamweaver.sln
	npm run typecheck --prefix frontend
	npm run lint --prefix frontend

demo-api: ## Run the Postman collection with Newman against the local API
	npx newman run postman/dreamweaver.postman_collection.json \
		-e postman/local.postman_environment.json --insecure --reporters cli

up: ## Start the full production-like stack (docker-compose.yml)
	$(COMPOSE_PROD) up -d --build --wait

down: ## Stop the full stack
	$(COMPOSE_PROD) down
