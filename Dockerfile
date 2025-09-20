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
  ltrace

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


# Expose SSH port
EXPOSE 22

# Keep container running with SSH service
CMD ["/usr/sbin/sshd", "-D"]
