#!/bin/bash

# Default values
COPY_SSH=true
SSH_DIR="$HOME/.ssh"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-ssh)
            COPY_SSH=false
            shift
            ;;
        --ssh-dir)
            SSH_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --ssh-dir <path>  Specify SSH directory (default: ~/.ssh)"
            echo "  --no-ssh          Skip copying SSH keys"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use '$0 --help' for usage information"
            exit 1
            ;;
    esac
done

# Create .docker-keys directory if it doesn't exist
DOCKER_KEYS_DIR=".docker-keys"
mkdir -p "$DOCKER_KEYS_DIR"

if [ "$COPY_SSH" = true ]; then
    # Validate SSH directory exists
    if [ ! -d "$SSH_DIR" ]; then
        echo "Error: SSH directory '$SSH_DIR' does not exist"
        exit 1
    fi

    echo "Using SSH directory: $SSH_DIR"

    # Clear/create the authorized_keys file
    AUTHORIZED_KEYS_FILE="$DOCKER_KEYS_DIR/authorized_keys"
    > "$AUTHORIZED_KEYS_FILE"

    # Find all public keys in the SSH directory and combine them for authorized_keys
    echo "Collecting SSH public keys for authorized_keys..."
    for pubkey in "$SSH_DIR"/*.pub; do
        if [ -f "$pubkey" ]; then
            echo "Adding public key: $(basename "$pubkey")"
            cat "$pubkey" >> "$AUTHORIZED_KEYS_FILE"
            echo "" >> "$AUTHORIZED_KEYS_FILE"  # Add newline between keys
        fi
    done

    # Set proper permissions
    chmod 600 "$AUTHORIZED_KEYS_FILE"

    # Count keys added
    KEY_COUNT=$(grep -c "ssh-" "$AUTHORIZED_KEYS_FILE" 2>/dev/null || echo "0")
    echo "Added $KEY_COUNT public key(s) to $AUTHORIZED_KEYS_FILE"

    # Copy private keys (non-.pub files) for git authentication
    echo "Copying SSH private keys..."
    for key in "$SSH_DIR"/id_*; do
        if [[ -f "$key" && ! "$key" =~ \.pub$ ]]; then
            echo "Copying private key: $(basename "$key")"
            cp "$key" "$DOCKER_KEYS_DIR/$(basename "$key")"
            chmod 600 "$DOCKER_KEYS_DIR/$(basename "$key")"
        fi
    done

    # Copy public keys as separate files too (for completeness)
    echo "Copying SSH public keys as files..."
    for pubkey in "$SSH_DIR"/*.pub; do
        if [ -f "$pubkey" ]; then
            echo "Copying public key file: $(basename "$pubkey")"
            cp "$pubkey" "$DOCKER_KEYS_DIR/$(basename "$pubkey")"
            chmod 644 "$DOCKER_KEYS_DIR/$(basename "$pubkey")"
        fi
    done
else
    echo "Skipping SSH key copying (--no-ssh flag provided)"
    # Create empty authorized_keys file to prevent mount errors
    touch "$DOCKER_KEYS_DIR/authorized_keys"
    chmod 600 "$DOCKER_KEYS_DIR/authorized_keys"
fi

# Start docker compose
echo "Starting docker compose..."
docker compose up -d

echo "Container started. Waiting for SSH service to be ready..."

# Wait for SSH service to be ready
for i in {1..10}; do
    if ssh -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 developer@localhost exit 2>/dev/null; then
        echo "SSH service is ready!"
        break
    fi
    echo "Waiting for SSH service... ($i/10)"
    sleep 1
done

# SSH into the container
echo "Connecting to the container..."
ssh -p 2222 developer@localhost