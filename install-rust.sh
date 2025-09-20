#!/bin/bash
set -e

# Install Rust using rustup
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

# Add cargo bin to PATH for verification
export PATH="$HOME/.cargo/bin:$PATH"

# Verify installation
echo "Verifying Rust installation..."
$HOME/.cargo/bin/rustc --version
$HOME/.cargo/bin/cargo --version

echo "Rust installation completed successfully!"