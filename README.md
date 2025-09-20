# DockTerm

A Docker-based development environment with SSH access, providing a consistent Ubuntu 24 workspace across different platforms.

## Features

- Ubuntu 24.04 base image with development tools pre-installed
- SSH server for remote access
- Persistent home directory
- Automatic SSH key management
- Git-ready environment with private repository support

## Prerequisites

- Docker and Docker Compose installed
- SSH keys configured in `~/.ssh/` (optional)

## Quick Start

1. Clone this repository:

```bash
git clone https://github.com/iAziz786/dockterm.git
cd dockterm
```

2. Start and connect to the container:

```bash
./start.sh
```

This will start the container and automatically SSH into it.

To connect manually later:

```bash
ssh -p 2222 developer@localhost
```

Default password: `devpassword` (only used if SSH keys are not set up)

## SSH Key Setup

The `start.sh` script automatically copies your SSH keys from `~/.ssh/` to the container, allowing:

- Passwordless SSH access to the container
- Git operations with private repositories

### Passwordless SSH Login

To enable passwordless SSH login to the container, add this to your `~/.ssh/config`:

```
Host dockterm
    HostName localhost
    Port 2222
    User developer
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

Then you can simply connect using:

```bash
ssh dockterm
```

## Script Options

The `start.sh` script supports several options:

```bash
# Default: Copy SSH keys from ~/.ssh
./start.sh

# Use custom SSH directory
./start.sh --ssh-dir /path/to/ssh

# Skip SSH key copying entirely
./start.sh --no-ssh

# Show help
./start.sh --help
```

## Directory Structure

- `.docker-keys/` - Temporary directory for SSH keys (git-ignored)
  - `authorized_keys` - Combined public keys for SSH access
  - Individual SSH key files copied from your system

## Working with Git

The container includes your SSH keys, allowing you to:

1. Clone private repositories:

```bash
ssh dockterm
cd /tmp
git clone git@github.com:your-username/private-repo.git
```

2. Configure Git (first time):

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Managing the Container

```bash
# Start the container
./start.sh

# Stop and clean up all resources
./stop.sh

# View container logs
docker compose logs -f

# Execute commands directly
docker exec dockterm-dev-env-1 <command>

# Restart with fresh SSH keys
./stop.sh
./start.sh
```

## Volumes

The following volumes are mounted:

- `.docker-keys:/home/developer/.ssh` - SSH configuration and keys
- `dev-home:/home/developer` - Persistent home directory

## Installed Software

The container includes:

- Development tools: git, vim, nano, tmux, screen
- Languages: Python 3, Node.js, npm, Java (OpenJDK)
- Database clients: PostgreSQL, MySQL, SQLite, Redis
- Network tools: curl, wget, nettools, nmap
- Build tools: build-essential, gcc, make

## Troubleshooting

### SSH Connection Refused

- Ensure the container is running: `docker compose ps`
- Check if port 2222 is available: `lsof -i :2222`

### Permission Denied (SSH)

- Run `./start.sh` to copy your SSH keys
- Ensure your public key exists: `ls ~/.ssh/*.pub`

### Git Clone Fails

- The container needs your private keys for authentication
- Ensure SSH agent forwarding or key copying is working
- You may need to add GitHub/GitLab to known_hosts first:

  ```bash
  ssh-keyscan github.com >> ~/.ssh/known_hosts
  ```

### Multi-platform Build Error

If you get "multiple platforms feature is not supported for docker driver":

- Enable Docker Buildx (one-time setup):

  ```bash
  docker buildx create --use --name multiarch
  ```

- Alternatively, build for current platform only:

  ```bash
  docker build -t dockterm .
  ```

## Security Notes

- The default password should be changed for production use
- SSH keys are copied to `.docker-keys/` which is git-ignored
- The container runs SSH on port 2222 to avoid conflicts with host SSH

## License

MIT

