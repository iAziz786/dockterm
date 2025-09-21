# DockTerm

Ubuntu 24.04 development container with modern tools pre-installed.

## Quick Start

```bash
git clone https://github.com/iAziz786/dockterm.git
cd dockterm
make flow
```

That's it! You're now inside a fully configured development environment.

## Commands

```bash
make flow    # Start and connect (use this most of the time)
make stop    # Stop container
make exec    # Connect without SSH (faster)
make help    # Show all commands
```

## Adding Tools

Need a new tool? Create a migration:

```bash
make migrate TYPE=user NAME=install_something
```

Edit the generated file in `migrations/user/`, then rebuild:

```bash
make build
make flow
```

## What's Included

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
- **vim** & **nano**

### Package Managers
- **cargo** (Rust)
- **uv** (Python)
- **bun** (JavaScript)
- **mise** - Runtime version manager

### Database Clients
- PostgreSQL, MySQL, SQLite, Redis

## SSH Access

```bash
ssh -p 2222 developer@localhost
# Password: devpassword
```

## Volumes

- Your code: `/home/developer/Code` (persists across rebuilds)
- Home directory: `/home/developer` (includes tools and dotfiles)

## License

MIT