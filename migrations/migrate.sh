#!/bin/bash
set -e

# Run all migration scripts in chronological order
# System scripts run as root, user scripts run as developer

SCRIPT_DIR="/tmp/migrations"
MIGRATION_STATE_FILE="$HOME/.dockterm/migrations.state"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo "      Docker Terminal Setup Migrations"
echo -e "==========================================${NC}"

# Create state directory if it doesn't exist
mkdir -p "$(dirname "$MIGRATION_STATE_FILE")"
touch "$MIGRATION_STATE_FILE"

# Get current user
CURRENT_USER=$(whoami)
echo -e "${YELLOW}Running as: $CURRENT_USER${NC}"

# Function to check if migration has run
has_run() {
    grep -q "^$1$" "$MIGRATION_STATE_FILE" 2>/dev/null
}

# Function to mark migration as complete
mark_complete() {
    echo "$1" >> "$MIGRATION_STATE_FILE"
}

# Function to run a single migration
run_migration() {
    local script="$1"
    local script_name=$(basename "$script")

    # Check if already run
    if has_run "$script_name"; then
        echo -e "${YELLOW}  ⊙ Skipping (already run): $script_name${NC}"
        return 0
    fi

    echo -e "${BLUE}  → Running: $script_name${NC}"

    # Make executable and run
    chmod +x "$script"
    if "$script"; then
        mark_complete "$script_name"
        echo -e "${GREEN}  ✓ Completed: $script_name${NC}"
    else
        echo -e "${RED}  ✗ Failed: $script_name${NC}"
        exit 1
    fi
}

# Process system migrations (only as root)
if [ "$CURRENT_USER" = "root" ]; then
    echo -e "\n${BLUE}[System Migrations]${NC}"

    if [ -d "$SCRIPT_DIR/system" ]; then
        # Sort scripts by timestamp (filename already contains it)
        for script in $(ls "$SCRIPT_DIR/system"/*.sh 2>/dev/null | sort); do
            run_migration "$script"
        done
    else
        echo -e "${YELLOW}  No system migrations found${NC}"
    fi
else
    echo -e "\n${YELLOW}[System Migrations] - Skipping (requires root)${NC}"
fi

# Process user migrations (only as developer)
if [ "$CURRENT_USER" = "developer" ]; then
    echo -e "\n${BLUE}[User Migrations]${NC}"

    if [ -d "$SCRIPT_DIR/user" ]; then
        # Sort scripts by timestamp (filename already contains it)
        for script in $(ls "$SCRIPT_DIR/user"/*.sh 2>/dev/null | sort); do
            run_migration "$script"
        done
    else
        echo -e "${YELLOW}  No user migrations found${NC}"
    fi
else
    echo -e "\n${YELLOW}[User Migrations] - Skipping (requires developer user)${NC}"
fi

echo -e "\n${GREEN}=========================================="
echo "       All migrations completed!"
echo -e "==========================================${NC}"