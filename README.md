# Rehost

Automated system setup for fresh Linux VMs with modern development tools.

## Quick Start

```bash
git clone https://github.com/iAziz786/dockterm.git
cd dockterm
make setup
```

That's it! Your development environment is ready.

## What It Does

Rehost automatically sets up a fresh Linux system with:

### Languages & Runtimes
- **Go** 1.25.1
- **Rust** (latest via rustup)
- **Python** 3 with pip
- **Node.js** with npm
- **Java** (OpenJDK)

### Modern CLI Tools
- **bat** - Better cat with syntax highlighting
- **eza** - Modern ls replacement
- **ripgrep** - Blazing fast grep
- **fzf** - Fuzzy finder
- **fd** - User-friendly find
- **zoxide** - Smarter cd
- **atuin** - Shell history sync
- **starship** - Cross-shell prompt
- **zellij** - Terminal multiplexer
- **nushell** - Modern shell

### Development Tools
- **Neovim** 0.11.4
- **tmux** & **screen**
- **git** & **stow**
- **jq** - JSON processor

### Package Managers
- **cargo** (Rust)
- **uv** (Python)
- **bun** (JavaScript)
- **mise** - Runtime version manager

### Database Clients
- PostgreSQL, MySQL, SQLite, Redis

## System Requirements

- Debian/Ubuntu-based Linux
- x86_64 or ARM64 architecture
- Internet connection
- 5GB free disk space

## How It Works

1. **Prechecks**: Validates system compatibility
2. **Migrations**: Runs setup scripts in chronological order
3. **State Tracking**: Skips already-completed steps

Setup files are stored in `~/.local/share/rehost/`

## Adding Custom Tools

Create a new migration:

```bash
make migrate TYPE=user NAME=install_tool
```

Edit the generated file in `migrations/user/`, then run:

```bash
make setup
```

Only new migrations will run.

## For Root vs User

```bash
# User-level tools (dotfiles, development tools)
make setup

# System-level packages (requires root)
sudo make setup
```

## License

MIT