#!/bin/bash

# Script to install modern CLI tools from prebuilt binaries
# This script downloads and installs: bat, eza, atuin, starship, zellij, nushell
# Target: x86_64 Linux

set -euo pipefail

echo "Installing modern CLI tools from prebuilt binaries..."

# Create temp directory for downloads
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Function to download latest GitHub release
get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Install directory (user's local bin or cargo bin)
INSTALL_DIR="${HOME}/.cargo/bin"
mkdir -p "$INSTALL_DIR"

echo "Installing to: $INSTALL_DIR"

# bat - Better cat with syntax highlighting
echo "Installing bat..."
BAT_VERSION=$(get_latest_release "sharkdp/bat")
wget -q "https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
tar xzf bat-*.tar.gz
cp bat-*/bat "$INSTALL_DIR/"
echo "✓ bat installed"

# eza - Modern ls replacement
echo "Installing eza..."
wget -qO eza.tar.gz "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"
tar xzf eza.tar.gz
mv eza "$INSTALL_DIR/"
echo "✓ eza installed"

# starship - Cross-shell prompt
echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$INSTALL_DIR"
echo "✓ starship installed"

# zellij - Terminal multiplexer
echo "Installing zellij..."
wget -q "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
tar xzf zellij-*.tar.gz
chmod +x zellij
mv zellij "$INSTALL_DIR/"
echo "✓ zellij installed"

# nushell - Modern shell
echo "Installing nushell..."
NU_VERSION=$(get_latest_release "nushell/nushell")
# Remove 'v' prefix if present
NU_VERSION_CLEAN=${NU_VERSION#v}
wget -q "https://github.com/nushell/nushell/releases/download/${NU_VERSION}/nu-${NU_VERSION_CLEAN}-x86_64-unknown-linux-gnu.tar.gz"
tar xzf nu-*.tar.gz
# Nushell has binaries in a subdirectory
cp nu-*/nu "$INSTALL_DIR/"
echo "✓ nushell installed"

# zoxide - Smart directory jumper
echo "Installing zoxide..."
wget -q "https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.8/zoxide-0.9.8-x86_64-unknown-linux-musl.tar.gz"
tar xzf zoxide-*.tar.gz
chmod +x zoxide
mv zoxide "$INSTALL_DIR/"
echo "✓ zoxide installed"

# atuin - Shell history manager
echo "Installing atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/download/v18.8.0/atuin-installer.sh | sh
echo "✓ atuin installed"

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo ""
echo "All tools installed successfully in $INSTALL_DIR"
echo "Make sure $INSTALL_DIR is in your PATH"

# Verify installations
echo ""
echo "Verifying installations:"
for tool in bat eza starship zellij nu zoxide; do
    if [ -f "$INSTALL_DIR/$tool" ]; then
        echo "✓ $tool found"
    else
        echo "✗ $tool not found"
    fi
done

# Check atuin separately (installed in ~/.atuin/bin)
if [ -f "$HOME/.atuin/bin/atuin" ]; then
    echo "✓ atuin found"
else
    echo "✗ atuin not found"
fi