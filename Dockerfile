FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install essential packages
RUN apt-get update && apt-get upgrade -y && \
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
  python3 \
  python3-pip \
  nodejs \
  npm \
  default-jdk \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  apt-transport-https

# Install additional development tools
RUN apt-get install -y \
  zsh \
  tmux \
  screen \
  jq \
  sqlite3 \
  postgresql-client \
  mysql-client \
  redis-tools \
  net-tools \
  iputils-ping \
  telnet \
  nmap \
  strace \
  ltrace \
  stow \
  fd-find \
  ripgrep \
  fzf \
  zoxide \
  golang-go \
  nvim

# Unminimize Ubuntu to get the full server experience
RUN yes | unminimize

# Create SSH directory and set permissions
RUN mkdir /var/run/sshd
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Set root password (change this to something secure)
RUN echo 'root:devpassword' | chpasswd

# Create a non-root user for development
RUN useradd -m -s /bin/bash -G sudo developer
RUN echo 'developer:devpassword' | chpasswd
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create SSH directory for developer user
RUN mkdir -p /home/developer/.ssh
RUN chmod 700 /home/developer/.ssh
RUN chown developer:developer /home/developer/.ssh

# Switch to developer user for user-specific installations
USER developer
WORKDIR /home/developer

# Install Rust and cargo for developer user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/developer/.cargo/bin:${PATH}"

# Install modern CLI tools via cargo
RUN /home/developer/.cargo/bin/cargo install bat eza atuin starship zellij nu --locked

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install uv (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/developer/.local/bin:${PATH}"

# Install mise (runtime version manager)
RUN curl https://mise.run | sh

# Install bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/home/developer/.bun/bin:${PATH}"

# Create .config directory
RUN mkdir -p /home/developer/.config

# Switch back to root for sshd
USER root

# Expose SSH port
EXPOSE 22

# Keep container running with SSH service
CMD ["/usr/sbin/sshd", "-D"]
