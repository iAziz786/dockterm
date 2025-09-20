#!/bin/bash

# Script to set up dotfiles in the container
# This should be run inside the container as the developer user

set -e

echo "Setting up dotfiles..."

# Create necessary directories
mkdir -p ~/.config
cd ~

# Clone the dotfiles repository
if [ ! -d "dotfiles" ]; then
    echo "Cloning dotfiles repository..."
    git clone git@github.com:iAziz786/dotfiles.git
else
    echo "Dotfiles directory already exists, pulling latest changes..."
    cd dotfiles
    git pull
    cd ~
fi

# Use GNU Stow to symlink the configurations
cd ~/dotfiles

# Stow all directories except the ones we want to ignore
echo "Creating symlinks with GNU Stow..."

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

for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        echo "Stowing $package..."
        stow -v --target="$HOME" "$package"
    else
        echo "Warning: $package directory not found"
    fi
done

echo "Dotfiles setup complete!"

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    sudo chsh -s $(which zsh) developer
fi

echo "Setup complete! Please restart your shell or run 'exec zsh' to apply changes."