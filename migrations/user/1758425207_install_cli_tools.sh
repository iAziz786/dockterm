#!/bin/bash

set -euo pipefail

echo "Installing modern CLI tools from prebuilt binaries..."

ARCH=$(uname -m)
case $ARCH in
    x86_64|amd64)
        ARCH_TYPE="x86_64"
        BAT_ARCH="x86_64-unknown-linux-gnu"
        EZA_ARCH="x86_64-unknown-linux-gnu"
        STARSHIP_ARCH="x86_64-unknown-linux-musl"
        ZELLIJ_ARCH="x86_64-unknown-linux-musl"
        NU_ARCH="x86_64-unknown-linux-gnu"
        ZOXIDE_ARCH="x86_64-unknown-linux-musl"
        ATUIN_ARCH="x86_64-unknown-linux-gnu"
        ;;
    aarch64|arm64)
        ARCH_TYPE="aarch64"
        BAT_ARCH="aarch64-unknown-linux-gnu"
        EZA_ARCH="aarch64-unknown-linux-gnu"
        STARSHIP_ARCH="aarch64-unknown-linux-musl"
        ZELLIJ_ARCH="aarch64-unknown-linux-musl"
        NU_ARCH="aarch64-unknown-linux-musl"
        ZOXIDE_ARCH="aarch64-unknown-linux-musl"
        ATUIN_ARCH="aarch64-unknown-linux-gnu"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH_TYPE"

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

INSTALL_DIR="${HOME}/.cargo/bin"
mkdir -p "$INSTALL_DIR"

echo "Installing to: $INSTALL_DIR"

echo "Installing bat..."
BAT_VERSION=$(get_latest_release "sharkdp/bat")
wget -q "https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION}-${BAT_ARCH}.tar.gz"
tar xzf bat-*.tar.gz
cp bat-*/bat "$INSTALL_DIR/"
echo "✓ bat installed"

echo "Installing eza..."
wget -qO eza.tar.gz "https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}.tar.gz"
tar xzf eza.tar.gz
mv eza "$INSTALL_DIR/"
echo "✓ eza installed"

echo "Installing starship..."
STARSHIP_VERSION=$(get_latest_release "starship/starship")
wget -q "https://github.com/starship/starship/releases/download/${STARSHIP_VERSION}/starship-${STARSHIP_ARCH}.tar.gz"
tar xzf starship-*.tar.gz
mv starship "$INSTALL_DIR/"
echo "✓ starship installed"

echo "Installing zellij..."
wget -q "https://github.com/zellij-org/zellij/releases/latest/download/zellij-${ZELLIJ_ARCH}.tar.gz"
tar xzf zellij-*.tar.gz
chmod +x zellij
mv zellij "$INSTALL_DIR/"
echo "✓ zellij installed"

echo "Installing nushell..."
NU_VERSION=$(get_latest_release "nushell/nushell")
NU_VERSION_CLEAN=${NU_VERSION#v}
if wget -q "https://github.com/nushell/nushell/releases/download/${NU_VERSION}/nu-${NU_VERSION_CLEAN}-${NU_ARCH}.tar.gz"; then
    tar xzf nu-*.tar.gz
    cp nu-*/nu "$INSTALL_DIR/"
    echo "✓ nushell installed"
else
    echo "⚠ nushell ${NU_ARCH} build not available, skipping..."
fi

echo "Installing zoxide..."
ZOXIDE_VERSION=$(get_latest_release "ajeetdsouza/zoxide")
if wget -q "https://github.com/ajeetdsouza/zoxide/releases/download/${ZOXIDE_VERSION}/zoxide-${ZOXIDE_VERSION#v}-${ZOXIDE_ARCH}.tar.gz"; then
    tar xzf zoxide-*.tar.gz
    chmod +x zoxide
    mv zoxide "$INSTALL_DIR/"
    echo "✓ zoxide installed"
else
    echo "⚠ zoxide ${ZOXIDE_ARCH} build not available, trying alternative..."
    if [ "$ARCH_TYPE" = "aarch64" ]; then
        echo "Building zoxide from source via cargo..."
        if command -v cargo >/dev/null 2>&1; then
            cargo install zoxide
            echo "✓ zoxide installed via cargo"
        else
            echo "✗ cargo not found, skipping zoxide"
        fi
    fi
fi

echo "Installing atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/download/v18.8.0/atuin-installer.sh | sh
echo "✓ atuin installed"

cd /
rm -rf "$TEMP_DIR"

echo ""
echo "All tools installed successfully in $INSTALL_DIR"
echo "Make sure $INSTALL_DIR is in your PATH"

echo ""
echo "Verifying installations:"
for tool in bat eza starship zellij nu zoxide; do
    if [ -f "$INSTALL_DIR/$tool" ]; then
        echo "✓ $tool found"
    else
        echo "✗ $tool not found"
    fi
done

if [ -f "$HOME/.atuin/bin/atuin" ]; then
    echo "✓ atuin found"
else
    echo "✗ atuin not found"
fi