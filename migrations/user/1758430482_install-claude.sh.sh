#!/bin/bash
set -e

# Migration: install-claude.sh
# Type: user
# Created: Sun Sep 21 04:54:42 UTC 2025

echo "Running migration: install-claude.sh"

#############################################
# Add your migration commands below
#############################################

sudo npm install -g @anthropic-ai/claude-code

#############################################
# End of migration commands
#############################################

echo "✓ Migration completed: install-claude.sh"
