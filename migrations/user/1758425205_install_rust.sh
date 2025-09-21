#!/bin/bash
set -e

# Install Rust using rustup
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable

# Verify installation
echo "Verifying Rust installation..."
$HOME/.cargo/bin/rustc --version
$HOME/.cargo/bin/cargo --version

echo "Rust installation completed successfully!"