.PHONY: help build start stop restart logs shell clean migrate flow

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	docker compose build

start: ## Start the container
	docker compose up -d

stop: ## Stop the container
	docker compose down

restart: stop start ## Restart the container

shell: ## SSH into the container
	ssh -p 2222 developer@localhost

exec: ## Direct exec into container (no SSH)
	docker exec -it -u developer -w /home/developer/Code $$(docker compose ps -q dockterm) zsh

flow: ## Start container if needed and SSH into it (usage: make flow [ARGS="--no-ssh"])
	@./scripts/setup-ssh.sh $(ARGS)
	@if ! docker compose ps | grep -q "Up"; then \
		echo "Container not running. Starting..."; \
		docker compose up -d; \
		echo "Waiting for SSH service..."; \
		sleep 3; \
	fi
	@for i in {1..10}; do \
		if ssh -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 developer@localhost exit 2>/dev/null; then \
			echo "SSH service is ready!"; \
			break; \
		fi; \
		echo "Waiting for SSH service... ($$i/10)"; \
		sleep 1; \
	done
	@ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 developer@localhost

clean: ## Clean up containers and volumes
	docker compose down -v

migrate: ## Create a new migration script (usage: make migrate TYPE=system NAME=install_package)
	@if [ -z "$(TYPE)" ] || [ -z "$(NAME)" ]; then \
		echo "Usage: make migrate TYPE=system|user NAME=script_name"; \
		echo "Example: make migrate TYPE=system NAME=install_nodejs"; \
		exit 1; \
	fi
	@./migrations/create.sh $(TYPE) $(NAME)