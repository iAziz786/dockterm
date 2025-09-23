.PHONY: help setup migrate

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Setup system with all migrations
	@./bin/rehost-migrate

migrate: ## Create a new migration script (usage: make migrate TYPE=system NAME=install_package)
	@if [ -z "$(TYPE)" ] || [ -z "$(NAME)" ]; then \
		echo "Usage: make migrate TYPE=system|user NAME=script_name"; \
		echo "Example: make migrate TYPE=system NAME=install_nodejs"; \
		exit 1; \
	fi
	@./migrations/create.sh $(TYPE) $(NAME)