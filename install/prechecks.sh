#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CHECKS_PASSED=true

echo -e "${BLUE}Running system prechecks...${NC}"

check_os() {
    echo -n "Checking OS type... "
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]] || [[ "$ID_LIKE" == *"debian"* ]]; then
            echo -e "${GREEN}✓ Debian-based system detected ($NAME)${NC}"
            return 0
        else
            echo -e "${RED}✗ Not a Debian-based system ($NAME)${NC}"
            echo -e "${YELLOW}  This setup is designed for Ubuntu/Debian systems${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Cannot determine OS type${NC}"
        return 1
    fi
}

check_architecture() {
    echo -n "Checking architecture... "
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
        echo -e "${GREEN}✓ x86_64 architecture${NC}"
        return 0
    elif [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
        echo -e "${YELLOW}⚠ ARM64 architecture detected${NC}"
        echo -e "${YELLOW}  Some tools may need ARM-specific versions${NC}"
        return 0
    else
        echo -e "${RED}✗ Unsupported architecture: $ARCH${NC}"
        return 1
    fi
}

check_package_manager() {
    echo -n "Checking package manager... "
    if command -v apt &> /dev/null; then
        echo -e "${GREEN}✓ apt is available${NC}"
        return 0
    else
        echo -e "${RED}✗ apt is not available${NC}"
        return 1
    fi
}

check_sudo() {
    echo -n "Checking sudo access... "
    if [ "$EUID" -eq 0 ]; then
        echo -e "${GREEN}✓ Running as root${NC}"
        return 0
    elif command -v sudo &> /dev/null && sudo -n true 2>/dev/null; then
        echo -e "${GREEN}✓ sudo is available (passwordless)${NC}"
        return 0
    elif command -v sudo &> /dev/null; then
        echo -e "${YELLOW}⚠ sudo is available (may require password)${NC}"
        return 0
    else
        echo -e "${RED}✗ No sudo access${NC}"
        echo -e "${YELLOW}  System-level installations will be skipped${NC}"
        return 0
    fi
}

check_internet() {
    echo -n "Checking internet connection... "
    if ping -c 1 -W 2 8.8.8.8 &> /dev/null || ping -c 1 -W 2 1.1.1.1 &> /dev/null; then
        echo -e "${GREEN}✓ Internet connection available${NC}"
        return 0
    else
        echo -e "${RED}✗ No internet connection${NC}"
        echo -e "${YELLOW}  Internet is required for downloading packages${NC}"
        return 1
    fi
}

check_disk_space() {
    echo -n "Checking disk space... "
    AVAILABLE=$(df "$HOME" | awk 'NR==2 {print $4}')
    REQUIRED=$((5 * 1024 * 1024))

    if [ "$AVAILABLE" -gt "$REQUIRED" ]; then
        AVAILABLE_GB=$((AVAILABLE / 1024 / 1024))
        echo -e "${GREEN}✓ Sufficient disk space (${AVAILABLE_GB}GB available)${NC}"
        return 0
    else
        AVAILABLE_MB=$((AVAILABLE / 1024))
        echo -e "${RED}✗ Insufficient disk space (${AVAILABLE_MB}MB available, 5GB required)${NC}"
        return 1
    fi
}

check_essential_tools() {
    echo -n "Checking essential tools... "
    local missing_tools=()

    for tool in git curl wget; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -eq 0 ]; then
        echo -e "${GREEN}✓ All essential tools available${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Missing tools: ${missing_tools[*]}${NC}"
        echo -e "${BLUE}  Installing missing tools...${NC}"
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y ${missing_tools[*]}
            return 0
        else
            return 1
        fi
    fi
}

echo ""

if ! check_os; then
    CHECKS_PASSED=false
fi

if ! check_architecture; then
    CHECKS_PASSED=false
fi

if ! check_package_manager; then
    CHECKS_PASSED=false
fi

check_sudo

if ! check_internet; then
    CHECKS_PASSED=false
fi

if ! check_disk_space; then
    CHECKS_PASSED=false
fi

if ! check_essential_tools; then
    CHECKS_PASSED=false
fi

echo ""
if [ "$CHECKS_PASSED" = true ]; then
    echo -e "${GREEN}All prechecks passed!${NC}"
    exit 0
else
    echo -e "${RED}Some prechecks failed!${NC}"
    exit 1
fi