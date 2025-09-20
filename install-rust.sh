#!/bin/bash
set -e

# Install Rust using rustup
echo "Installing Rust..."

# Download and run rustup-init
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh
chmod +x /tmp/rustup-init.sh
/tmp/rustup-init.sh -y --no-modify-path --default-toolchain stable

# Clean up installer
rm /tmp/rustup-init.sh

# Ensure .cargo/bin exists
if [ ! -d "$HOME/.cargo/bin" ]; then
    echo "Error: Cargo bin directory not found after installation"
    exit 1
fi

# List contents of cargo bin for debugging
echo "Contents of .cargo/bin:"
ls -la $HOME/.cargo/bin/

# Verify installation using full paths
echo "Verifying Rust installation..."
if [ -f "$HOME/.cargo/bin/rustc" ]; then
    $HOME/.cargo/bin/rustc --version
else
    echo "Error: rustc not found at $HOME/.cargo/bin/rustc"
    exit 1
fi

if [ -f "$HOME/.cargo/bin/cargo" ]; then
    $HOME/.cargo/bin/cargo --version
else
    echo "Error: cargo not found at $HOME/.cargo/bin/cargo"
    exit 1
fi

echo "Rust installation completed successfully!"