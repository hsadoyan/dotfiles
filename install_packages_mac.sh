#!/bin/bash

# Package Installation Script for macOS (Homebrew)
# Called by setup_mac.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

DRY_RUN="${1:-false}"

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_dry_run() { echo -e "${MAGENTA}[DRY-RUN]${NC} $1"; }

BREW_PACKAGES=(
    neovim
    tmux
    fzf
    ripgrep
    fd
    bat
    eza
    tldr
    bottom
    yazi
    git
    git-delta
    difftastic
    tree-sitter
    go
    gopls
    lua-language-server
    pyright
    starship
    colima
    docker
    docker-compose
    lazygit
)

BREW_FONT_CASKS=(
    font-hack-nerd-font
)

print_info "Updating Homebrew..."
if [ "$DRY_RUN" = "true" ]; then
    print_dry_run "Would run: brew update && brew upgrade"
else
    brew update && brew upgrade
    print_success "Homebrew updated"
fi

echo
print_info "Installing Homebrew packages..."
if [ "$DRY_RUN" = "true" ]; then
    print_dry_run "Would install: ${BREW_PACKAGES[*]}"
else
    brew install "${BREW_PACKAGES[@]}"
    print_success "Homebrew packages installed"
fi

echo
print_info "Installing kitty..."
if [ "$DRY_RUN" = "true" ]; then
    print_dry_run "Would run: brew install --cask kitty"
else
    brew install --cask kitty
    print_success "kitty installed"
fi

echo
print_info "Installing Nerd Fonts..."
if [ "$DRY_RUN" = "true" ]; then
    print_dry_run "Would install font casks: ${BREW_FONT_CASKS[*]}"
else
    brew install --cask "${BREW_FONT_CASKS[@]}"
    print_success "Nerd Fonts installed"
fi
