#!/bin/bash
set -e

GO_VERSION="1.25.1"

ARCH=$(uname -m)
case $ARCH in
    x86_64|amd64)
        GO_ARCH="amd64"
        ;;
    aarch64|arm64)
        GO_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

GO_TARBALL="go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
GO_URL="https://go.dev/dl/${GO_TARBALL}"

echo "Downloading Go ${GO_VERSION} for ${GO_ARCH}..."
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