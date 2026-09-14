.PHONY: help setup deps db-up db-down ecto-setup reset assets assets-watch server console test format precommit clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: deps db-up ecto-setup assets ## Install deps, start the db, and build assets

deps: ## Fetch mix dependencies
	mix deps.get

db-up: ## Start the database container
	docker compose up -d

db-down: ## Stop the database container
	docker compose down

ecto-setup: ## Create, migrate and seed the database
	mix ecto.setup

reset: ## Drop and recreate the database
	mix ecto.reset

assets: ## Install and build frontend assets (npm + elm)
	mix assets.setup
	mix assets.build

assets-watch: ## Watch and rebuild assets on change
	cd assets && npm run watch

server: db-up ## Start the Phoenix server
	mix phx.server

console: db-up ## Start an interactive shell with the app loaded
	iex -S mix

test: ## Run the test suite
	mix test

format: ## Format the codebase
	mix format

precommit: ## Run compile, format and test checks before committing
	mix precommit

clean: db-down ## Stop the db and remove build artifacts
	rm -rf _build deps assets/node_modules priv/static
