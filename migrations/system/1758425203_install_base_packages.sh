#!/bin/bash
set -e

echo "Installing base system packages..."

# Update and upgrade system
apt-get update && apt-get upgrade -y

# Essential packages
apt-get install -y \
  openssh-server \
  sudo \
  curl \
  wget \
  git \
  vim \
  nano \
  htop \
  tree \
  unzip \
  build-essential \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  apt-transport-https

# Development tools
apt-get install -y \
  zsh \
  tmux \
  screen \
  jq \
  stow \
  fd-find \
  ripgrep \
  fzf

# Language runtimes (from system packages)
apt-get install -y \
  python3 \
  python3-pip \
  nodejs \
  npm \
  default-jdk

# Database clients
apt-get install -y \
  sqlite3 \
  postgresql-client \
  mysql-client \
  redis-tools

# Network tools
apt-get install -y \
  net-tools \
  iputils-ping \
  telnet \
  nmap

# Debug tools
apt-get install -y \
  strace \
  ltrace

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Base packages installed successfully!"