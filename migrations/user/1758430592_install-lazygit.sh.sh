#!/bin/bash
set -e

# Migration: install-lazygit.sh
# Type: user
# Created: Sun Sep 21 04:56:32 UTC 2025

echo "Running migration: install-lazygit.sh"

#############################################
# Add your migration commands below
#############################################

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

#############################################
# End of migration commands
#############################################

echo "✓ Migration completed: install-lazygit.sh"
