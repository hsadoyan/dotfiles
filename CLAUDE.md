# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for Manjaro Linux that manages configuration for development tools and terminal environment. The setup script creates symlinks from the home directory to these dotfiles, enabling version-controlled configuration management.

## Key Commands

### Initial Setup
```bash
# Preview what would be done without making changes
./setup.sh --dry-run

# Run full setup (requires sudo for package installation)
./setup.sh
```

### Package Management
```bash
# Install/update packages separately
bash install_packages.sh false

# Use paru (AUR helper) after initial setup
paru -S <package>
```

### Testing Configuration Changes
After modifying any configuration file:
- **Neovim**: Open nvim and check for errors. Plugins auto-install via lazy.nvim on first launch
- **Tmux**: `tmux source ~/.tmux.conf` or press `<prefix>r` (C-z r)
- **Kitty**: Kitty auto-reloads config changes
- **Zsh**: `exec zsh` or `source ~/.zshrc`
- **Git**: Changes take effect immediately

### Neovim Plugin Management
```bash
# Install/update plugins (via lazy.nvim)
nvim
# Then use:
:Lazy sync              # Update all plugins
:Lazy install           # Install missing plugins
:TSUpdate              # Update treesitter parsers
```

### LSP Server Installation
LSP servers must be installed separately (not managed by the config):
```bash
# Go
go install golang.org/x/tools/gopls@latest

# Python
pip install pyright

# Lua
sudo pacman -S lua-language-server

# Elixir - managed automatically by elixir-tools.nvim plugin
```

## Architecture

### Configuration Structure

The repository uses a flat structure with configs in the root and subdirectories for tools with multiple files:

- `setup.sh` - Main orchestration script that creates all symlinks and installs components
- `install_packages.sh` - Package installation logic (separated for modularity)
- Individual config files in root: `vimrc`, `gitconfig`, `tmux.conf`, `zshrc`, `kitty.conf`, etc.
- `nvim/` - Neovim configuration (init.lua only, uses lazy.nvim for plugins)
- `yazi/` - File manager configuration (yazi.toml, .yaziignore)

### Setup Script Architecture

The setup script (`setup.sh`) is organized in stages:

1. **System update** - Ensures base system is current
2. **Package installation** - Delegates to `install_packages.sh`
3. **Tool-specific setup blocks** - Each tool (Neovim, Git, Zsh, Tmux, Kitty, Yazi) has its own section that:
   - Creates necessary directories
   - Creates symlinks from `~/.config/` or `~/` to dotfiles
   - Performs tool-specific setup (e.g., vim-plug installation)
4. **Optional components** - Sway/Waybar installation is interactive
5. **Final configuration** - Sets npm prefix and displays summary

### Neovim Configuration Architecture

The Neovim config (`nvim/init.lua`) uses the modern Neovim 0.11+ API:

- **Plugin manager**: lazy.nvim (auto-bootstraps on first run)
- **LSP**: Native Neovim 0.11 LSP API with `vim.lsp.config()` and `vim.lsp.enable()`
  - No mason or lspconfig-style auto-installation
  - Explicit server configuration in the config file
  - Configured servers: gopls, pyright, lua_ls, ElixirLS (via elixir-tools.nvim)
- **Treesitter**: Uses Neovim 0.11 native highlighting (`vim.treesitter.start()`)
  - Parser installation via nvim-treesitter plugin
  - Auto-installs parsers on first FileType encounter
- **Completion**: nvim-cmp with LSP, buffer, path, and snippet sources
- **Key plugins**:
  - fzf.vim for fuzzy finding (bound to `<leader>f`, `<leader>g`, etc.)
  - nvim-tree for file exploration (C-n)
  - gitsigns for git integration
  - vim-tmux-navigator for seamless tmux/vim pane switching
  - Comment.nvim, vim-surround for editing
  - claudecode.nvim for Claude Code integration (`<leader>cc`)

Leader key is `,` (comma).

### Terminal Stack Integration

The configuration creates a tightly integrated terminal development environment:

- **Terminal emulator**: Kitty with powerline tab bar style
- **Shell**: Zsh with powerline prompt (Manjaro defaults)
- **Multiplexer**: Tmux with custom prefix (C-z instead of C-b)
  - Vim-style pane navigation (h/j/k/l)
  - Wayland clipboard integration (wl-clipboard)
  - Seamless integration with Neovim via vim-tmux-navigator
- **Modern CLI tools** (aliased in zshrc):
  - `bat` (cat replacement)
  - `eza` (ls replacement)
  - `fd` (find replacement)
  - `rg`/ripgrep (grep replacement)
  - `bottom` (top replacement)
  - `tldr` (man replacement)
  - `yazi` (file manager)

### Git Configuration

The gitconfig includes:
- `delta` as pager for enhanced diff viewing
- `difftastic` as alternative difftool (`git difft`)
- Common aliases: `co`, `br`, `ci`, `st`, `lg` (oneline graph), `difft`
- Auto-setup remote for push
- Rerere enabled (reuse recorded resolution)
- Default branch: main
- Editor: nvim

### Platform Specifics

This setup is tailored for **Manjaro Linux** (Arch-based):
- Package installation uses `pacman` and `paru` (AUR)
- Designed for Wayland (clipboard integration, optional Sway/Waybar)
- Font: Expects Nerd Fonts (ttf-dejavu-nerd or Hack Nerd Font Mono)

## Working with This Repository

### Adding New Configurations

When adding a new tool configuration:

1. Add the config file to the repository root (or create subdirectory if multiple files)
2. Update `setup.sh` to add a new setup block that creates necessary symlinks
3. If new packages are needed, add them to `install_packages.sh` in the appropriate section
4. Test with `./setup.sh --dry-run` first

### Modifying Neovim Config

The Neovim config is a single `nvim/init.lua` file organized in sections (see comments). When modifying:

- Plugin changes: Edit the `require("lazy").setup({})` section
- LSP changes: Edit the LSP configuration section (~line 355-465)
- Keymaps: Edit the keymaps section (~line 514-559)
- Core settings: Edit the core settings section (~line 8-77)

Always restart Neovim after config changes. lazy.nvim will auto-install new plugins.

### Symlink Philosophy

The setup script uses `ln -sf` (force symlink) so running it multiple times is safe. The dotfiles remain in this repository; the home directory only contains symlinks. This allows easy version control of all configs.

## Shell Aliases and Shortcuts

Important aliases defined in `zshrc`:
- `vim` → `nvim`
- `cat` → `bat`
- `ls` → `eza`
- `man` → `tldr`
- `top` → `bottom`

Tmux prefix: `C-z` (not the default `C-b`)

Neovim leader: `,` (comma)

## Maintenance

To update the system and tools:

```bash
# Update packages
sudo pacman -Syu
paru -Syu

# Update Neovim plugins
nvim
:Lazy sync

# Update Treesitter parsers
:TSUpdate

# Re-run setup if dotfiles changed
./setup.sh
```
