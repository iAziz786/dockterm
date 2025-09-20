#!/bin/bash

echo "Stopping DockTerm environment..."

# Stop and remove containers
if docker compose ps --quiet 2>/dev/null; then
    echo "Stopping Docker containers..."
    docker compose down
else
    echo "No running containers found"
fi

# Remove .docker-keys directory if it exists
if [ -d ".docker-keys" ]; then
    echo "Removing .docker-keys directory..."
    rm -rf .docker-keys
    echo ".docker-keys directory removed"
else
    echo "No .docker-keys directory found"
fi

echo "DockTerm environment cleaned up successfully!"