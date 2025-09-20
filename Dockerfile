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
  fzf

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

# Create a non-root user for development with zsh as default shell
RUN useradd -m -s /bin/zsh -G sudo developer
RUN echo 'developer:devpassword' | chpasswd
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create SSH directory for developer user
RUN mkdir -p /home/developer/.ssh
RUN chmod 700 /home/developer/.ssh
RUN chown developer:developer /home/developer/.ssh


# Switch to developer user for user-specific installations
USER developer
WORKDIR /home/developer

# Copy install scripts
COPY --chown=developer:developer install-tools.sh /tmp/install-tools.sh
COPY --chown=developer:developer setup-dotfiles-docker.sh /tmp/setup-dotfiles-docker.sh
COPY --chown=developer:developer install-go.sh /tmp/install-go.sh
COPY --chown=developer:developer install-rust.sh /tmp/install-rust.sh
RUN chmod +x /tmp/install-tools.sh /tmp/setup-dotfiles-docker.sh /tmp/install-go.sh /tmp/install-rust.sh

# Create .config directory
RUN mkdir -p /home/developer/.config

# Install oh-my-zsh FIRST (before dotfiles, since .zshrc expects it)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Rust FIRST (before other tools that use .cargo/bin)
RUN /tmp/install-rust.sh && rm /tmp/install-rust.sh

# Install Go from official binary
RUN /tmp/install-go.sh && rm /tmp/install-go.sh

# Install modern CLI tools (after Rust, so .cargo/bin exists properly)
RUN /tmp/install-tools.sh && rm /tmp/install-tools.sh

# Set up PATH for cargo and atuin binaries
ENV PATH="/home/developer/.cargo/bin:/home/developer/.atuin/bin:${PATH}"

# Set up dotfiles LAST (after oh-my-zsh and tools are installed)
RUN /tmp/setup-dotfiles-docker.sh && rm /tmp/setup-dotfiles-docker.sh

# Install NeoVim (using latest stable release)
RUN curl -LO https://github.com/neovim/neovim-releases/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && \
  tar -xzf nvim-linux-x86_64.tar.gz && \
  sudo mv nvim-linux-x86_64 /opt/nvim && \
  rm nvim-linux-x86_64.tar.gz && \
  sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim

# Install uv (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install mise (runtime version manager)
RUN curl https://mise.run | sh

# Install bun
RUN curl -fsSL https://bun.sh/install | bash



# Switch back to root for sshd
USER root

# Expose SSH port
EXPOSE 22

# Keep container running with SSH service
CMD ["/usr/sbin/sshd", "-D"]
