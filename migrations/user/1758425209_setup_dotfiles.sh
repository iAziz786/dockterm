#!/bin/bash

# Script to set up dotfiles in Docker container during build
# This runs as the developer user in the container

set -e

echo "Setting up dotfiles in Docker container..."

# Ensure we're in the home directory
cd /home/developer

# Create necessary directories
mkdir -p ~/.config

# Clone the dotfiles repository using HTTPS (no SSH keys during build)
echo "Cloning dotfiles repository..."
git clone https://github.com/iAziz786/dotfiles.git ~/dotfiles

# Checkout specific commit
cd ~/dotfiles
echo "Checking out commit 8770529263f7986b64407eb4bf20ef3a15387bd1..."
if ! git checkout 8770529263f7986b64407eb4bf20ef3a15387bd1; then
    echo "Error: Failed to checkout specific commit"
    echo "Available commits:"
    git log --oneline | head -5
    exit 1
fi

# List of packages to stow (excluding desktop apps)
PACKAGES=(
  "atuin"
  "bat"
  "claude"
  "eza"
  "nushell"
  "nvim"
  "starship"
  "zellij"
  "zsh"
)

echo "Creating symlinks with GNU Stow..."

# Remove existing .zshrc if it's a regular file (not a symlink)
# This handles the oh-my-zsh default .zshrc
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo "Removing existing .zshrc (will be replaced by dotfiles version)"
  rm "$HOME/.zshrc"
fi

for package in "${PACKAGES[@]}"; do
  if [ -d "$package" ]; then
    echo "Stowing $package..."
    stow -v --target="$HOME" "$package" 2>&1 || echo "Warning: Failed to stow $package"
  else
    echo "Warning: $package directory not found"
  fi
done

# Set zsh as default shell (requires sudo)
echo "Setting zsh as default shell..."
sudo chsh -s $(which zsh) developer

echo "Dotfiles setup complete in Docker container!"

