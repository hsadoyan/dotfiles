#!/bin/bash

# Dotfiles Setup Script for macOS
# Requires: Homebrew (brew.sh) already installed
#
# Usage:
#   ./setup_mac.sh           - Run the full setup
#   ./setup_mac.sh --dry-run - Show what would be done without making changes

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}    DRY RUN MODE${NC}"
    echo -e "${CYAN}    No changes will be made${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo
fi

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }
print_dry_run() { echo -e "${MAGENTA}[DRY-RUN]${NC} $1"; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

create_symlink() {
    local source="$1"
    local target="$2"
    if [ "$DRY_RUN" = true ]; then
        if [ -f "$source" ]; then
            print_dry_run "Would create symlink: $target -> $source"
            if [ -e "$target" ] || [ -L "$target" ]; then
                echo -e "  ${YELLOW}Note: $target already exists and would be overwritten${NC}"
            fi
        else
            print_error "Source file not found: $source"
        fi
    else
        if [ -f "$source" ]; then
            ln -sf "$source" "$target"
        else
            print_error "Source file not found: $source"
            return 1
        fi
    fi
}

create_dir() {
    local dir="$1"
    if [ "$DRY_RUN" = true ]; then
        [ ! -d "$dir" ] && print_dry_run "Would create directory: $dir"
    else
        mkdir -p "$dir"
    fi
}

# Guard: must be macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This script is for macOS only. Use setup.sh for Linux."
    exit 1
fi

# Guard: Homebrew required
if ! command_exists brew; then
    print_error "Homebrew is not installed. Install it from https://brew.sh first."
    exit 1
fi

# ---------- PACKAGES ----------
print_info "Running package installation..."
if [ "$DRY_RUN" = true ]; then
    bash "$DOTFILES_DIR/install_packages_mac.sh" "true"
else
    bash "$DOTFILES_DIR/install_packages_mac.sh" "false"
fi

# ---------- NEOVIM ----------
echo
print_info "========== NEOVIM SETUP =========="

create_dir ~/.config/nvim

if [ -f "$DOTFILES_DIR/vimrc" ]; then
    create_symlink "$DOTFILES_DIR/vimrc" ~/.vimrc
    [ "$DRY_RUN" = false ] && print_success "Vim configuration linked"
else
    print_error "vimrc not found in $DOTFILES_DIR"
fi

if [ -f "$DOTFILES_DIR/nvim/init.lua" ]; then
    create_symlink "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
    [ "$DRY_RUN" = false ] && print_success "Neovim configuration linked"
else
    print_error "nvim/init.lua not found in $DOTFILES_DIR"
fi

print_info "vim-plug installation..."
if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would install vim-plug for neovim and vim"
else
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    print_success "vim-plug installed"
fi

print_info "Vim plugins installation..."
if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would run: nvim +PlugInstall +qall"
else
    nvim +PlugInstall +qall
    print_success "Vim plugins installed"
fi

# ---------- GIT ----------
echo
print_info "========== GIT CONFIGURATION =========="

create_dir ~/.config/git

if [ -f "$DOTFILES_DIR/gitconfig" ]; then
    create_symlink "$DOTFILES_DIR/gitconfig" ~/.gitconfig
    [ "$DRY_RUN" = false ] && print_success "Git config linked"
else
    print_error "gitconfig not found in $DOTFILES_DIR"
fi

if [ -f "$DOTFILES_DIR/gitignore_global" ]; then
    create_symlink "$DOTFILES_DIR/gitignore_global" ~/.config/git/ignore
    [ "$DRY_RUN" = false ] && print_success "Global gitignore linked"
else
    print_error "gitignore_global not found in $DOTFILES_DIR"
fi

# Write work email override to ~/.gitconfig.local (included by gitconfig)
if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would write ~/.gitconfig.local with work email (harry.sadoyan@temporal.io)"
else
    cat > ~/.gitconfig.local <<'EOF'
[user]
  email = harry.sadoyan@temporal.io
EOF
    print_success "Work email written to ~/.gitconfig.local"
fi

# ---------- ZSH ----------
echo
print_info "========== ZSH SETUP =========="

if [ -f "$DOTFILES_DIR/zshrc" ]; then
    create_symlink "$DOTFILES_DIR/zshrc" ~/.zshrc
    [ "$DRY_RUN" = false ] && print_success "Zsh configuration linked"
else
    print_error "zshrc not found in $DOTFILES_DIR"
fi

# zsh is the default shell on macOS — only chsh if somehow it isn't
if [ "$DRY_RUN" = true ]; then
    echo -e "  ${CYAN}Default shell: $SHELL${NC}"
else
    if [ "$SHELL" != "/bin/zsh" ]; then
        chsh -s /bin/zsh
        print_success "Default shell set to zsh"
    else
        print_success "Zsh is already the default shell"
    fi
fi

# ---------- TMUX ----------
echo
print_info "========== TMUX SETUP =========="

if [ -f "$DOTFILES_DIR/tmux.conf" ]; then
    create_symlink "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
    [ "$DRY_RUN" = false ] && print_success "Tmux configuration linked"
else
    print_warning "tmux.conf not found in $DOTFILES_DIR"
fi

# ---------- KITTY ----------
echo
print_info "========== KITTY TERMINAL =========="

create_dir ~/.config/kitty

if [ -f "$DOTFILES_DIR/kitty.conf" ]; then
    create_symlink "$DOTFILES_DIR/kitty.conf" ~/.config/kitty/kitty.conf
    [ "$DRY_RUN" = false ] && print_success "Kitty configuration linked"
else
    print_warning "kitty.conf not found in $DOTFILES_DIR"
fi

if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would run: kitten themes --reload-in=all Cobalt2"
else
    if command_exists kitten; then
        kitten themes --reload-in=all "Cobalt2"
        print_success "Kitty theme set to Cobalt2"
    else
        print_warning "kitten not found — run 'kitten themes' manually after first launch"
    fi
fi

# ---------- YAZI ----------
echo
print_info "========== YAZI FILE MANAGER =========="

create_dir ~/.config/yazi

if [ -f "$DOTFILES_DIR/yazi/yazi.toml" ]; then
    create_symlink "$DOTFILES_DIR/yazi/yazi.toml" ~/.config/yazi/yazi.toml
    [ "$DRY_RUN" = false ] && print_success "Yazi config linked"
else
    print_warning "yazi/yazi.toml not found in $DOTFILES_DIR"
fi

if [ -f "$DOTFILES_DIR/yazi/.yaziignore" ]; then
    create_symlink "$DOTFILES_DIR/yazi/.yaziignore" ~/.config/yazi/.yaziignore
    [ "$DRY_RUN" = false ] && print_success "Yazi ignore file linked"
else
    print_warning "yazi/.yaziignore not found in $DOTFILES_DIR"
fi

# ---------- DOCKER / COLIMA ----------
echo
print_info "========== DOCKER / COLIMA =========="

if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would start Colima with 4 CPUs and 8 GB RAM"
    command_exists colima && echo -e "  ${GREEN}colima is installed${NC}"
else
    if command_exists colima; then
        if ! colima status 2>/dev/null | grep -q "Running"; then
            print_info "Starting Colima (4 CPUs, 8 GB RAM)..."
            colima start --cpu 4 --memory 8
        fi
        print_success "Colima running — docker socket available"
    else
        print_warning "colima not found — should have been installed by install_packages_mac.sh"
    fi
fi

# ---------- SUMMARY ----------
echo
echo -e "${GREEN}========================================${NC}"
if [ "$DRY_RUN" = true ]; then
    echo -e "${CYAN}    DRY RUN SUMMARY (No changes made)${NC}"
else
    echo -e "${GREEN}    macOS Setup Complete!${NC}"
fi
echo -e "${GREEN}========================================${NC}"
echo
print_info "Components configured:"
echo "  • Neovim with vim-plug and plugins"
echo "  • Git configuration (~/.gitconfig.local with work email)"
echo "  • Zsh with Homebrew + Starship prompt"
echo "  • Tmux configuration"
echo "  • Kitty terminal (installed via Homebrew cask)"
echo "  • Yazi file manager"
echo "  • Docker via Colima"
echo "  • Nerd Fonts: Hack, DejaVu"
echo "  • Modern CLI tools: fzf, ripgrep, fd, bat, eza, bottom, tldr"
echo

if [ "$DRY_RUN" = false ]; then
    print_warning "Reload your shell: exec zsh"
    print_info "Colima tip: 'colima start' / 'colima stop' to manage the Docker runtime"
fi
