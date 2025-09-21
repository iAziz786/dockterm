#!/bin/bash
set -e

# Migration: install-gh
# Type: user
# Created: Sun Sep 21 09:30:20 IST 2025

echo "Running migration: install-gh"

#############################################
# Add your migration commands below
#############################################

(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) &&
  sudo mkdir -p -m 755 /etc/apt/keyrings &&
  out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg &&
  cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
  sudo mkdir -p -m 755 /etc/apt/sources.list.d &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
  sudo apt update &&
  sudo apt install gh -y

#############################################
# End of migration commands
#############################################

echo "✓ Migration completed: install-gh"
