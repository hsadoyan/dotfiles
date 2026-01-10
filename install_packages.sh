#!/bin/bash

# Package Installation Script for Manjaro Linux
# This script installs all necessary packages for the dotfiles setup

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get dry run flag from parent script
DRY_RUN="${1:-false}"

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_dry_run() {
    echo -e "${MAGENTA}[DRY-RUN]${NC} $1"
}

# Function to check package installation status
check_packages() {
    local packages=("$@")
    local missing=()
    local installed=()

    for pkg in "${packages[@]}"; do
        if pacman -Qi "$pkg" &> /dev/null; then
            installed+=("$pkg")
        else
            missing+=("$pkg")
        fi
    done

    if [ ${#installed[@]} -gt 0 ]; then
        echo -e "  ${GREEN}Already installed:${NC} ${installed[*]}"
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "  ${YELLOW}Would install:${NC} ${missing[*]}"
    fi
}

# Define base packages
BASE_PACKAGES=(
    base-devel
    git
    curl
    wget
    zsh
    neovim
    tmux
    fzf
    ripgrep
    fd
    bat
    eza
    tldr
    bottom
    wl-clipboard
    nodejs
    npm
    python
    python-pip
    difftastic
    git-delta
)

# Define powerline packages
POWERLINE_PACKAGES=(
    powerline
    powerline-fonts
)

# Install base packages
print_info "Base packages installation..."
if [ "$DRY_RUN" = "true" ]; then
    print_dry_run "Would install base packages"
    check_packages "${BASE_PACKAGES[@]}"
else
    sudo pacman -S --needed --noconfirm "${BASE_PACKAGES[@]}"
    print_success "Base packages installed"
fi

# Install powerline packages
echo
print_info "Powerline packages installation..."
if [ "$DRY_RUN" = "true" ]; then
    print_dry_run "Would install powerline packages"
    check_packages "${POWERLINE_PACKAGES[@]}"
else
    sudo pacman -S --needed --noconfirm "${POWERLINE_PACKAGES[@]}"
    print_success "Powerline packages installed"
fi
