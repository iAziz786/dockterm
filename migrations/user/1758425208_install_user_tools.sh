#!/bin/bash
set -e

echo "Installing additional user tools..."

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install NeoVim
echo "Installing NeoVim..."
curl -LO https://github.com/neovim/neovim-releases/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim
rm nvim-linux-x86_64.tar.gz
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim

# Install Python package managers
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install runtime version manager
echo "Installing mise..."
curl https://mise.run | sh

# Install JavaScript runtime
echo "Installing bun..."
curl -fsSL https://bun.sh/install | bash

echo "Additional user tools installed!"