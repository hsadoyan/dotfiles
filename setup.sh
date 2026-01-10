#!/bin/bash

# Dotfiles Setup Script for Manjaro Linux
# This script configures a fresh Manjaro installation with all necessary tools and configurations
#
# Usage:
#   ./setup.sh           - Run the full setup
#   ./setup.sh --dry-run - Show what would be done without making changes

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Parse command line arguments
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}    DRY RUN MODE${NC}"
    echo -e "${CYAN}    No changes will be made${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo
fi

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_dry_run() {
    echo -e "${MAGENTA}[DRY-RUN]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run commands (or just print them in dry-run mode)
run_cmd() {
    local cmd="$1"
    local description="$2"

    if [ "$DRY_RUN" = true ]; then
        print_dry_run "$description"
        echo -e "  ${CYAN}Command:${NC} $cmd"
    else
        eval "$cmd"
    fi
}

# Function to create symlinks
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

# Function to create directory
create_dir() {
    local dir="$1"

    if [ "$DRY_RUN" = true ]; then
        if [ ! -d "$dir" ]; then
            print_dry_run "Would create directory: $dir"
        fi
    else
        mkdir -p "$dir"
    fi
}

# Update system
print_info "System update..."
if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would run: sudo pacman -Syu --noconfirm"
else
    sudo pacman -Syu --noconfirm
    print_success "System updated"
fi

# Install packages using subscript
print_info "Running package installation script..."
if [ "$DRY_RUN" = true ]; then
    bash "$DOTFILES_DIR/install_packages.sh" "true"
else
    bash "$DOTFILES_DIR/install_packages.sh" "false"
fi

# ---------- NEOVIM SETUP ----------
echo
print_info "========== NEOVIM SETUP =========="

create_dir ~/.config/nvim

# Link vimrc for vim
if [ -f "$DOTFILES_DIR/vimrc" ]; then
    create_symlink "$DOTFILES_DIR/vimrc" ~/.vimrc
    if [ "$DRY_RUN" = false ]; then
        print_success "Vim configuration linked"
    fi
else
    print_error "vimrc not found in $DOTFILES_DIR"
fi

# Link init.lua for neovim
if [ -f "$DOTFILES_DIR/nvim/init.lua" ]; then
    create_symlink "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
    if [ "$DRY_RUN" = false ]; then
        print_success "Neovim configuration linked"
    fi
else
    print_error "nvim/init.lua not found in $DOTFILES_DIR"
fi

# Set neovim as default editor
if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would create: /usr/local/bin/vim -> /usr/bin/nvim"
    if command_exists nvim; then
        echo -e "  ${GREEN}neovim is installed${NC}"
    else
        echo -e "  ${YELLOW}neovim would need to be installed first${NC}"
    fi
else
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
    print_success "Neovim set as default editor (vim -> nvim)"
fi

# Install vim-plug
print_info "vim-plug installation..."
if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would download vim-plug for neovim to ~/.local/share/nvim/site/autoload/plug.vim"
    print_dry_run "Would download vim-plug for vim to ~/.vim/autoload/plug.vim"
    if [ -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
        echo -e "  ${GREEN}vim-plug for neovim already exists${NC}"
    fi
    if [ -f ~/.vim/autoload/plug.vim ]; then
        echo -e "  ${GREEN}vim-plug for vim already exists${NC}"
    fi
else
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    print_success "vim-plug installed"
fi

# Install vim plugins
print_info "Vim plugins installation..."
if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would run: nvim +PlugInstall +qall"
    echo -e "  ${CYAN}Plugins from vimrc:${NC}"
    if [ -f "$DOTFILES_DIR/vimrc" ]; then
        grep "^Plug " "$DOTFILES_DIR/vimrc" | sed "s/^/    /" || echo "    (no plugins found)"
    fi
else
    nvim +PlugInstall +qall
    print_success "Vim plugins installed"
fi

# ---------- GIT CONFIGURATION ----------
echo
print_info "========== GIT CONFIGURATION =========="

create_dir ~/.config/git

if [ -f "$DOTFILES_DIR/gitconfig" ]; then
    create_symlink "$DOTFILES_DIR/gitconfig" ~/.gitconfig
    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${CYAN}Git config preview:${NC}"
        head -n 10 "$DOTFILES_DIR/gitconfig" | sed "s/^/    /"
    else
        print_success "Git config linked"
    fi
else
    print_error "gitconfig not found in $DOTFILES_DIR"
fi

if [ -f "$DOTFILES_DIR/gitignore_global" ]; then
    create_symlink "$DOTFILES_DIR/gitignore_global" ~/.config/git/ignore
    if [ "$DRY_RUN" = false ]; then
        print_success "Global gitignore linked"
    fi
else
    print_error "gitignore_global not found in $DOTFILES_DIR"
fi

# ---------- ZSH SETUP ----------
echo
print_info "========== ZSH SETUP =========="

if [ -f "$DOTFILES_DIR/zshrc" ]; then
    create_symlink "$DOTFILES_DIR/zshrc" ~/.zshrc
    if [ "$DRY_RUN" = false ]; then
        print_success "Zsh configuration linked"
    fi
else
    print_error "zshrc not found in $DOTFILES_DIR"
fi

# Change default shell to zsh
if [ "$DRY_RUN" = true ]; then
    current_shell="$SHELL"
    zsh_path="$(which zsh 2>/dev/null || echo '/usr/bin/zsh')"
    if [ "$current_shell" != "$zsh_path" ]; then
        print_dry_run "Would change default shell from $current_shell to $zsh_path"
        print_dry_run "Command: chsh -s $zsh_path"
    else
        echo -e "  ${GREEN}Default shell is already zsh${NC}"
    fi
else
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        print_success "Default shell changed to zsh (logout required to take effect)"
    else
        print_success "Zsh is already the default shell"
    fi
fi

# ---------- TMUX SETUP ----------
echo
print_info "========== TMUX SETUP =========="

if [ -f "$DOTFILES_DIR/tmux.conf" ]; then
    create_symlink "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
    if [ "$DRY_RUN" = false ]; then
        print_success "Tmux configuration linked"
    fi
else
    print_warning "tmux.conf not found in $DOTFILES_DIR"
fi

# ---------- PARU INSTALLATION ----------
echo
print_info "========== PARU (AUR HELPER) =========="

if command_exists paru; then
    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${GREEN}Paru is already installed${NC}"
    else
        print_success "Paru is already installed"
    fi
else
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would clone https://aur.archlinux.org/paru.git to /tmp/paru"
        print_dry_run "Would run: makepkg -si --noconfirm"
        print_dry_run "Would remove: /tmp/paru"
    else
        print_info "Building Paru from source..."
        cd /tmp
        git clone https://aur.archlinux.org/paru.git
        cd paru
        makepkg -si --noconfirm
        cd ~
        rm -rf /tmp/paru
        print_success "Paru installed"
    fi
fi

# ---------- NERD FONTS INSTALLATION ----------
echo
print_info "========== DEJAVU NERD FONT =========="

if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would install: ttf-dejavu-nerd (from AUR)"
    if fc-list | grep -qi "DejaVu.*Nerd"; then
        echo -e "  ${GREEN}DejaVu Nerd Font appears to be already installed${NC}"
    fi
    print_dry_run "Would run: fc-cache -fv (update font cache)"
else
    if command_exists paru; then
        paru -S --needed --noconfirm ttf-dejavu-nerd
        fc-cache -fv
        print_success "DejaVu Nerd Font installed"
        print_info "Configure it in your terminal settings"
    else
        print_warning "Paru not available, skipping nerd font installation"
    fi
fi

# ---------- FZF SETUP ----------
echo
print_info "========== FZF SETUP =========="

if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${GREEN}fzf key bindings already configured${NC}"
    else
        print_success "fzf already configured"
    fi
else
    print_info "fzf shell integration will be configured by zshrc"
fi

# ---------- SWAY AND WAYBAR SETUP (OPTIONAL) ----------
echo
print_info "========== SWAY AND WAYBAR (OPTIONAL) =========="

INSTALL_SWAY="n"
if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would prompt: Do you want to install Sway and Waybar? (y/n)"
    echo -e "  ${CYAN}If yes, would install:${NC}"
    echo "    - sway, waybar, swaybg, swaylock, swayidle"
    echo "    - wofi (launcher), kitty (terminal)"
    echo "    - grim, slurp (screenshots)"
    echo "    - wl-clipboard, brightnessctl"
    echo "    - pulseaudio, pavucontrol"
    echo "    - network-manager-applet, blueman"
    echo
    if [ -f "$DOTFILES_DIR/sway_config" ]; then
        echo -e "  ${GREEN}sway_config found${NC} - would link to ~/.config/sway/config"
    else
        echo -e "  ${YELLOW}sway_config not found${NC} in $DOTFILES_DIR"
    fi
    if [ -f "$DOTFILES_DIR/waybar_config" ]; then
        echo -e "  ${GREEN}waybar_config found${NC} - would link to ~/.config/waybar/config"
    else
        echo -e "  ${YELLOW}waybar_config not found${NC} in $DOTFILES_DIR"
    fi
    print_dry_run "Would create directory: ~/Pictures/Screenshots"
else
    read -p "$(echo -e ${YELLOW}Do you want to install Sway and Waybar? \(y/n\): ${NC})" -n 1 -r
    echo
    INSTALL_SWAY="$REPLY"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installing Sway and Waybar..."

        sudo pacman -S --needed --noconfirm \
            sway \
            waybar \
            swaybg \
            swaylock \
            swayidle \
            wofi \
            kitty \
            grim \
            slurp \
            wl-clipboard \
            brightnessctl \
            pulseaudio \
            pavucontrol \
            network-manager-applet \
            blueman

        print_success "Sway and Waybar installed"

        # Link sway config
        print_info "Setting up Sway configuration..."
        mkdir -p ~/.config/sway
        if [ -f "$DOTFILES_DIR/sway_config" ]; then
            ln -sf "$DOTFILES_DIR/sway_config" ~/.config/sway/config
            print_success "Sway configuration linked"
        else
            print_warning "sway_config not found in $DOTFILES_DIR"
        fi

        # Link waybar config
        print_info "Setting up Waybar configuration..."
        mkdir -p ~/.config/waybar
        if [ -f "$DOTFILES_DIR/waybar_config" ]; then
            ln -sf "$DOTFILES_DIR/waybar_config" ~/.config/waybar/config
            print_success "Waybar configuration linked"
        else
            print_warning "waybar_config not found in $DOTFILES_DIR"
        fi

        # Create Screenshots directory for sway
        mkdir -p ~/Pictures/Screenshots
        print_success "Screenshots directory created"
    else
        print_info "Skipping Sway and Waybar installation"
    fi
fi

# ---------- FINAL STEPS ----------
echo
print_info "========== FINAL CONFIGURATION =========="

if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would configure npm prefix to ~/.local"
    if command_exists npm; then
        echo -e "  ${GREEN}npm is available${NC}"
    else
        echo -e "  ${YELLOW}npm would need to be installed first${NC}"
    fi
else
    if command_exists npm; then
        npm config set prefix ~/.local
        print_success "npm configured"
    else
        print_warning "npm not found, skipping npm configuration"
    fi
fi

# ---------- SUMMARY ----------
echo
echo -e "${GREEN}========================================${NC}"
if [ "$DRY_RUN" = true ]; then
    echo -e "${CYAN}    DRY RUN SUMMARY${NC}"
    echo -e "${CYAN}    (No changes were made)${NC}"
else
    echo -e "${GREEN}    Setup Complete!${NC}"
fi
echo -e "${GREEN}========================================${NC}"
echo
print_info "Summary of components:"
echo "  • Neovim with vim-plug and plugins"
echo "  • Git configuration"
echo "  • Zsh as default shell"
echo "  • Tmux configuration"
echo "  • Paru (AUR helper)"
echo "  • Powerline"
echo "  • DejaVu Nerd Font"
echo "  • Modern CLI tools: fzf, ripgrep, fd, bat, eza, bottom, tldr"
if [[ $INSTALL_SWAY =~ ^[Yy]$ ]]; then
    echo "  • Sway and Waybar"
fi
echo

if [ "$DRY_RUN" = true ]; then
    echo -e "${CYAN}To run the actual setup, execute:${NC}"
    echo -e "${CYAN}  ./setup.sh${NC}"
    echo
else
    print_warning "Please log out and log back in for all changes to take effect"
    print_warning "Or run: exec zsh"
    echo
    print_info "To start using Sway, run: sway"
    echo
fi
