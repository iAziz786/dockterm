#!/bin/bash
set -e

# Install Rust using rustup
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Source cargo environment for current session
source "$HOME/.cargo/env"

# Verify installation
echo "Verifying Rust installation..."
rustc --version
cargo --version

echo "Rust installation completed successfully!"