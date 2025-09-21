#!/bin/bash
set -e

echo "Configuring system settings..."

# Unminimize Ubuntu to get the full server experience
yes | unminimize

# Create SSH runtime directory
mkdir -p /var/run/sshd

# Configure SSH for password authentication
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Set root password
echo 'root:devpassword' | chpasswd

# Create developer user
useradd -m -s /bin/zsh -G sudo developer
echo 'developer:devpassword' | chpasswd

# Configure sudo for developer
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create necessary directories for developer
mkdir -p /home/developer/.ssh /home/developer/Code /home/developer/.config
chmod 700 /home/developer/.ssh
chown -R developer:developer /home/developer/.ssh /home/developer/Code /home/developer/.config

echo "System configuration completed!"