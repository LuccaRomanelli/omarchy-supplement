# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an Omarchy Linux supplemental configuration repository that provides automated installation scripts for system setup, dotfiles management, and application configuration. It uses a modular approach with individual install scripts that can be run independently or collectively via `start.sh`.

## Primary Entry Points

- `./start.sh` - Main installation entry point that runs multiple installation scripts
- Individual `install-*.sh` scripts can be run independently for specific components

## Core Architecture

### Git Repository Synchronization (`git_sync_repo.sh`)

Central utility script used by multiple installers to clone or update git repositories:
- Usage: `./git_sync_repo.sh <REPO_URL> [REPO_NAME] [BRANCH]`
- Automatically clones if repository doesn't exist, otherwise pulls latest changes
- Default branch is `main` if not specified
- Used by `install-dotfiles.sh` and `install-shell-scripts.sh`

### Core Installation Utilities

Centralized package installation scripts that handle package existence checks and installation:

**YAY Package Installer (`install-yay-package.sh`)**
- Usage: `./install-yay-package.sh <package_name> [binary_name]`
- Checks if binary exists using `command -v`
- Installs package via yay with `--noconfirm --needed` flags if not present
- If binary_name differs from package_name, specify it as second parameter
- Example: `./install-yay-package.sh zen-browser-bin zen-browser`

**Pacman Package Installer (`install-pacman-package.sh`)**
- Usage: `./install-pacman-package.sh <package_name> [binary_name]`
- Same functionality as yay installer but uses `sudo pacman`
- Example: `./install-pacman-package.sh ripgrep rg`

**Batch YAY Installer (`install-yay-packages.sh`)**
- Installs all packages listed in `yay-packages.list`
- Reads one package per line with optional binary name
- Skips empty lines and comments (lines starting with #)

**Batch Pacman Installer (`install-pacman-packages.sh`)**
- Installs all packages listed in `pacman-packages.list`
- Same format as yay batch installer

**Package List Files**
- `yay-packages.list` - Central registry of all yay packages (stow, tmux, yazi, zen-browser-bin, pnpm, lsof, zsh, ghostty)
- `pacman-packages.list` - Central registry of all pacman packages (ripgrep, usbutils, usb_modeswitch)
- Format: `package_name [binary_name]` (one per line)

### Dotfiles Management

Uses GNU Stow for symlink management:
- Dotfiles are stored in a separate repository: `git@github.com:LuccaRomanelli/dotfiles.git`
- `install-dotfiles.sh` clones/updates the dotfiles repo and stows configurations for:
  - zshrc
  - ghostty (terminal emulator)
  - tmux
  - waybar
  - starship (shell prompt)
  - gitconfig
  - gitconfig-gitlab
- Before stowing, removes old configs from `~/.config/ghostty`, `~/.config/waybar`, and `~/.config/starship.toml`

### Shell Scripts Repository

Custom shell scripts are maintained in a separate repository:
- Repository: `https://github.com/LuccaRomanelli/shell.git`
- Cloned to `~/shell` via `install-shell-scripts.sh`
- Referenced by Hyprland keybindings for custom workflows

### Hyprland Configuration Override System

`hyprland-overrides.conf` provides custom Hyprland window manager settings:
- Installed via `install-hyprland-overrides.sh` which adds a source line to `~/.config/hypr/hyprland.conf`
- Defines multi-monitor setup (ultrawide + vertical LG TV)
- Custom keybindings for webapps and shell scripts
- Input device configuration (keyboard repeat rate, mouse sensitivity, touchpad)
- Terminal: ghostty (wrapped with `uwsm app`)
- Browser: zen-browser with custom scaling factor

### Omarchy Ecosystem Integration

The repository integrates with Omarchy's custom commands:
- `omarchy-theme-install <repo_url>` - Installs Omarchy themes from git repositories
- `omarchy-webapp-install <name> <url> <icon_url>` - Creates .desktop files for web applications
- `omarchy-launch-or-focus-webapp <name> <url>` - Launches or focuses existing webapp window
- `omarchy-launch-webapp <url>` - Launches webapp in new window
- `omarchy-cmd-screenshot` - Custom screenshot tool
- `omarchy-menu screenrecord` - Screen recording menu

### Package Installation Pattern

The repository uses centralized installation scripts for consistency:
1. **Individual package installations:** Call `install-yay-package.sh` or `install-pacman-package.sh` with package name
2. **Batch installations:** Use `install-yay-packages.sh` or `install-pacman-packages.sh` to install from list files
3. **Package management:** Add/remove packages by editing `yay-packages.list` or `pacman-packages.list`

The centralized installers handle:
- Checking if package binary exists using `command -v`
- Installing via `yay` or `pacman` with `--noconfirm --needed` flags
- Supporting package/binary name mismatches (e.g., zen-browser-bin vs zen-browser)

Individual `install-*.sh` scripts delegate to these centralized installers, maintaining post-installation setup where needed (e.g., Oh-My-Zsh for zsh, TPM for tmux).

### USB Mode Switch (`usb-modeswitch.sh`)

Utility script for USB modem detection and mode switching:
- Automatically installs `usb_modeswitch` and `usbutils` if not present
- Detects USB devices from known vendors (MediaTek, Huawei, ZTE, T&A Mobile Phones)
- Switches devices from storage mode to modem mode automatically
- Non-interactive for use in automated installations
- Shows network interfaces after switching

## Key Configuration Details

### AI Tools Installation (`install-ai-tools.sh`)

Installs CLI tools for AI services via npm:
- `@anthropic-ai/claude-code` (Claude CLI)
- `@google/gemini-cli` (Gemini CLI)
- `@abacus-ai/cli` (AbacusAI CLI)

### Hyprland Keybindings

Custom keybindings defined in `hyprland-overrides.conf`:
- `SUPER SHIFT A` - ChatLLM webapp (AbacusAI)
- `SUPER SHIFT C` - Google Calendar
- `SUPER SHIFT W` - WhatsApp
- `SUPER SHIFT M` - YouTube Music
- `SUPER SHIFT G` - GitHub
- `SUPER ALT G` - GitLab
- `SUPER ALT S/O/Y` - Custom shell scripts (start.sh, onhappy.sh, yopki.sh)
- `Page_Down` - Screenshot with editing
- `SHIFT Page_Down` - Screenshot to clipboard
- `ALT Page_Down` - Screen recording
- `SUPER Page_Down` - Color picker

### Monitor Configuration

Hyprland multi-monitor setup:
- Main monitor: DP-2 (2560x1080@60, ultrawide, horizontal)
- Secondary: HDMI-A-1 (1920x1080@60, vertical rotation, scaled 1.33x)
- Workspace 1 fixed to HDMI-A-1 (vertical monitor)
- Workspaces 2-10 fixed to DP-2 (main ultrawide)
- Laptop lid switch handling (disables/enables eDP-1)

## Common Tasks

### Full System Setup
```bash
./start.sh
```

### Install Specific Components
```bash
./install-dotfiles.sh      # Update dotfiles configurations
./install-hyprland-overrides.sh  # Apply Hyprland customizations
./install-shell-scripts.sh # Update custom shell scripts
./install-ai-tools.sh      # Install/update AI CLI tools
```

### Batch Package Installation
```bash
./install-yay-packages.sh    # Install all yay packages from list
./install-pacman-packages.sh # Install all pacman packages from list

# Or install individual packages
./install-yay-package.sh <package> [binary]
./install-pacman-package.sh <package> [binary]
```

### Theme Management
```bash
./install-omarchy-themes.sh   # Install multiple Omarchy themes
./uninstall-omarchy-themes.sh  # Remove themes
```

### Webapp Management
```bash
./install-omarchy-webapps.sh    # Install webapp shortcuts
./uninstall-omarchy-webapps.sh  # Remove webapp shortcuts
```

### App Management
```bash
./uninstall-omarchy-apps.sh     # Remove Omarchy applications
```

### Shell Configuration
```bash
./set-shell.sh                  # Change default shell to zsh
```

### USB Mode Switch
```bash
./usb-modeswitch.sh             # Detect and switch USB modems from storage mode
```

### Individual Package Installations

**Scripts with post-install setup:**
```bash
./install-zsh.sh                # Install zsh + Oh-My-Zsh + plugins
./install-tmux.sh               # Install tmux + TPM (Tmux Plugin Manager)
./install-dev.sh                # Install node, laravel, pnpm
```

**Simple package installers** (can use batch installers instead):
```bash
./install-ghostty.sh            # Install Ghostty terminal emulator
./install-zen.sh                # Install Zen browser
./install-yazi.sh               # Install Yazi file manager
./install-lsof.sh               # Install lsof utility
./install-ripgrep.sh            # Install ripgrep search tool
./install-stow.sh               # Install GNU Stow
```

**Note:** The simple package installers above are kept for individual use, but `start.sh` uses batch installers for efficiency.

## Dependencies

The installation scripts assume:
- Arch Linux with `yay` AUR helper installed
- `pacman` package manager
- `git` for repository cloning
- `stow` for dotfiles management (installed via `install-stow.sh`)
- Node.js and npm (for AI tools installation)
- Omarchy Linux base system with custom commands
- Hyprland window manager

## Installation Script Execution Order

The `start.sh` script supports **auto-resume after reboot** and executes in two phases:

### Phase 1: Pre-Reboot (shell setup)
1. Install zsh (with Oh-My-Zsh + plugins)
2. Set default shell to zsh
3. **REBOOT** - Creates autostart entry and reboots to apply shell change

### Phase 2: Post-Reboot (main installation)
4. Batch install YAY packages (stow, yazi, zen-browser-bin, pnpm, lsof, ghostty)
5. Batch install Pacman packages (ripgrep)
6. Obsidian vault
7. Dotfiles (stowed configurations)
8. Development tools (node, laravel, pnpm)
9. Tmux (with TPM post-install)
10. Shell scripts repository
11. AI tools (Claude, Gemini, AbacusAI CLIs)
12. Omarchy themes
13. Omarchy webapps
14. Uninstall Omarchy apps (cleanup)
15. Uninstall Omarchy webapps (cleanup)
16. Hyprland overrides
17. Yopki
18. USB Mode Switch (detect and switch USB modems)

### Auto-Resume System

The installation uses a state file (`~/.local/state/omarchy-supplement/install-progress`) to track progress:
- Saves current step after each successful installation
- Creates autostart entry (`~/.config/autostart/omarchy-supplement-resume.desktop`) before reboot
- Automatically continues from saved step after login
- Cleans up state and autostart files when complete
- Skips reboot if zsh is already the default shell

**Note:** Most packages are installed via batch installers for efficiency. Individual install scripts are kept for packages requiring post-installation setup (zsh, tmux) or special handling (dev tools).
