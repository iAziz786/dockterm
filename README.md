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

**Languages:** Go 1.25.1, Rust, Python 3, Node.js, Java
**Package Managers:** cargo, npm, pip, uv, bun, mise
**CLI Tools:** bat, eza, ripgrep, fzf, fd, zoxide, atuin
**Editors:** Neovim 0.11.4, vim, nano
**Shells:** zsh with oh-my-zsh, bash
**Database Clients:** PostgreSQL, MySQL, SQLite, Redis
**Others:** tmux, git, docker, terraform, kubectl, aws-cli

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