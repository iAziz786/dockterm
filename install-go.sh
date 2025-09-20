#!/bin/bash
set -e

# Go version to install
GO_VERSION="1.25.1"
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://go.dev/dl/${GO_TARBALL}"

# Download Go
echo "Downloading Go ${GO_VERSION}..."
curl -L -o /tmp/${GO_TARBALL} ${GO_URL}

# Remove any previous Go installation
echo "Removing previous Go installation..."
sudo rm -rf /usr/local/go

# Extract the archive to /usr/local
echo "Installing Go ${GO_VERSION}..."
sudo tar -C /usr/local -xzf /tmp/${GO_TARBALL}

# Clean up downloaded tarball
rm /tmp/${GO_TARBALL}

# Verify installation
echo "Verifying Go installation..."
/usr/local/go/bin/go version

echo "Go installation completed successfully!"