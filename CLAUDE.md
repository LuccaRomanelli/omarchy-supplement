# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an Omarchy Linux supplemental configuration repository that provides automated installation scripts for system setup, dotfiles management, and application configuration. It uses a modular approach with scripts organized into folders by category.

## Folder Structure

```
omarchy-supplement/
├── start.sh                      # Main entry point
├── hyprland-overrides.conf       # Hyprland window manager config
│
├── yay/                          # YAY package management
│   ├── install-package.sh        # Core single-package installer
│   ├── install-packages.sh       # Batch installer
│   ├── packages.list             # Package registry
│   ├── zsh.sh                    # Zsh + Oh-My-Zsh + plugins
│   ├── tmux.sh                   # Tmux + TPM
│   ├── voxtype.sh                # Voxtype speech-to-text
│   └── iriun-webcam.sh           # Iriun Webcam + v4l2loopback
│
├── pacman/                       # Pacman package management
│   ├── install-package.sh        # Core single-package installer
│   ├── install-packages.sh       # Batch installer
│   └── packages.list             # Package registry
│
├── install/                      # Installation scripts
│   ├── dotfiles.sh               # Stow-based dotfiles
│   ├── shell-scripts.sh          # Shell scripts repo
│   ├── ai-tools.sh               # AI CLI tools
│   ├── nhost.sh                  # Nhost CLI
│   ├── omarchy-themes.sh         # Omarchy themes
│   ├── omarchy-webapps.sh        # Webapp shortcuts
│   ├── hyprland-overrides.sh     # Hyprland config setup
│   ├── obsidian-vault.sh         # Obsidian vault
│   └── usb-modeswitch.sh         # USB modem switching
│
├── dev/                          # Development-related scripts
│   ├── dev.sh                    # Node/mise + Laravel + pnpm
│   └── yopki.sh                  # Yopki project repos
│
├── uninstall/                    # Uninstall scripts
│   ├── omarchy-apps.sh           # Remove packages
│   ├── omarchy-themes.sh         # Remove themes
│   └── omarchy-webapps.sh        # Remove webapps
│
└── lib/                          # Shared utilities
    ├── git_sync_repo.sh          # Git clone/pull utility
    └── set-shell.sh              # Change default shell
```

## Primary Entry Points

- `./start.sh` - Main installation entry point that runs all installation scripts in order
- Individual scripts can be run independently from their folders

## Core Architecture

### Git Repository Synchronization (`lib/git_sync_repo.sh`)

Central utility script used by multiple installers to clone or update git repositories:
- Usage: `./lib/git_sync_repo.sh <REPO_URL> [REPO_NAME] [BRANCH]`
- Automatically clones if repository doesn't exist, otherwise pulls latest changes
- Default branch is `main` if not specified
- Used by `install/dotfiles.sh`, `install/shell-scripts.sh`, and `dev/yopki.sh`

### YAY Package Management (`yay/`)

**Core Installer (`yay/install-package.sh`)**
- Usage: `./yay/install-package.sh <package_name>`
- Checks if package is installed using `pacman -Qi`
- Installs package via yay with `--noconfirm --needed` flags if not present
- Example: `./yay/install-package.sh zen-browser-bin`

**Batch Installer (`yay/install-packages.sh`)**
- Installs all packages listed in `yay/packages.list`
- Reads one package per line
- Skips empty lines and comments (lines starting with #)

**Complex Installers:**
- `yay/zsh.sh` - Installs zsh + Oh-My-Zsh + plugins
- `yay/tmux.sh` - Installs tmux + TPM (Tmux Plugin Manager)
- `yay/voxtype.sh` - Installs voxtype speech-to-text with Hyprland integration
- `yay/iriun-webcam.sh` - Installs Iriun Webcam with v4l2loopback kernel module

### Pacman Package Management (`pacman/`)

**Core Installer (`pacman/install-package.sh`)**
- Usage: `./pacman/install-package.sh <package_name>`
- Same functionality as yay installer but uses `sudo pacman`
- Example: `./pacman/install-package.sh ripgrep`

**Batch Installer (`pacman/install-packages.sh`)**
- Installs all packages listed in `pacman/packages.list`
- Same format as yay batch installer

### Package List Files

- `yay/packages.list` - Central registry of all yay packages (stow, yazi, zen-browser-bin, pnpm, lsof, ghostty, jellyfin-mpv-shim, postman-bin, devpod-bin)
- `pacman/packages.list` - Central registry of all pacman packages (ripgrep, usbutils, usb_modeswitch, pandoc, msmtp, texlive-*, wtype, wl-clipboard)
- Format: `package_name` (one per line)

### Dotfiles Management

Uses GNU Stow for symlink management:
- Dotfiles are stored in a separate repository: `git@github.com:LuccaRomanelli/dotfiles.git`
- `install/dotfiles.sh` clones/updates the dotfiles repo and stows configurations for:
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
- Cloned to `~/shell` via `install/shell-scripts.sh`
- Referenced by Hyprland keybindings for custom workflows

### Hyprland Configuration Override System

`hyprland-overrides.conf` provides custom Hyprland window manager settings:
- Installed via `install/hyprland-overrides.sh` which adds a source line to `~/.config/hypr/hyprland.conf`
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

### USB Mode Switch (`install/usb-modeswitch.sh`)

Utility script for USB modem detection and mode switching:
- Automatically installs `usb_modeswitch` and `usbutils` if not present
- Detects USB devices from known vendors (MediaTek, Huawei, ZTE, T&A Mobile Phones)
- Switches devices from storage mode to modem mode automatically
- Non-interactive for use in automated installations
- Shows network interfaces after switching

## Key Configuration Details

### AI Tools Installation (`install/ai-tools.sh`)

Installs CLI tools for AI services via npm:
- `@anthropic-ai/claude-code` (Claude CLI)
- `@google/gemini-cli` (Gemini CLI)
- `@abacus-ai/cli` (AbacusAI CLI)

### Nhost CLI Installation (`install/nhost.sh`)

Installs the Nhost CLI for backend-as-a-service development:
- Uses official installer script from nhost repository
- Provides local development environment for Nhost projects

### Development Tools (`dev/dev.sh`)

Installs development environment:
- Node.js versions via mise (latest + LTS 24)
- Laravel via omarchy-install-dev-env
- pnpm package manager

### Hyprland Keybindings

Custom keybindings defined in `hyprland-overrides.conf`:
- `SUPER SHIFT A` - ChatLLM webapp (AbacusAI)
- `SUPER SHIFT C` - Google Calendar
- `SUPER SHIFT W` - WhatsApp
- `SUPER SHIFT M` - YouTube Music
- `SUPER SHIFT G` - GitHub
- `SUPER ALT G` - GitLab
- `SUPER ALT S/O/Y` - Custom shell scripts (start.sh, onhappy.sh, yopki.sh)
- `SUPER D` - Voxtype speech-to-text (hold to record, release to transcribe)
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
./install/dotfiles.sh           # Update dotfiles configurations
./install/hyprland-overrides.sh # Apply Hyprland customizations
./install/shell-scripts.sh      # Update custom shell scripts
./install/ai-tools.sh           # Install/update AI CLI tools
```

### Batch Package Installation
```bash
./yay/install-packages.sh       # Install all yay packages from list
./pacman/install-packages.sh    # Install all pacman packages from list

# Or install individual packages
./yay/install-package.sh <package>
./pacman/install-package.sh <package>
```

### Theme Management
```bash
./install/omarchy-themes.sh     # Install multiple Omarchy themes
./uninstall/omarchy-themes.sh   # Remove themes
```

### Webapp Management
```bash
./install/omarchy-webapps.sh    # Install webapp shortcuts
./uninstall/omarchy-webapps.sh  # Remove webapp shortcuts
```

### App Management
```bash
./uninstall/omarchy-apps.sh     # Remove Omarchy applications
```

### Shell Configuration
```bash
./lib/set-shell.sh              # Change default shell to zsh
```

### USB Mode Switch
```bash
./install/usb-modeswitch.sh     # Detect and switch USB modems from storage mode
```

### Complex Package Installations
```bash
./yay/zsh.sh                    # Install zsh + Oh-My-Zsh + plugins
./yay/tmux.sh                   # Install tmux + TPM (Tmux Plugin Manager)
./yay/voxtype.sh                # Install voxtype speech-to-text
./yay/iriun-webcam.sh           # Install Iriun Webcam + v4l2loopback
./dev/dev.sh                    # Install node, laravel, pnpm
```

## Dependencies

The installation scripts assume:
- Arch Linux with `yay` AUR helper installed
- `pacman` package manager
- `git` for repository cloning
- `stow` for dotfiles management (installed via batch installer)
- Node.js and npm (for AI tools installation)
- Omarchy Linux base system with custom commands
- Hyprland window manager

## Installation Script Execution Order

The `start.sh` script executes installations in the following order:

1. Install zsh (with Oh-My-Zsh + plugins) - `yay/zsh.sh`
2. Batch install YAY packages - `yay/install-packages.sh`
3. Batch install Pacman packages - `pacman/install-packages.sh`
4. Obsidian vault - `install/obsidian-vault.sh`
5. Dotfiles (stowed configurations) - `install/dotfiles.sh`
6. Development tools - `dev/dev.sh`
7. Tmux (with TPM post-install) - `yay/tmux.sh`
8. Shell scripts repository - `install/shell-scripts.sh`
9. AI tools - `install/ai-tools.sh`
10. Nhost CLI - `install/nhost.sh`
11. Omarchy themes - `install/omarchy-themes.sh`
12. Omarchy webapps - `install/omarchy-webapps.sh`
13. Uninstall Omarchy apps (cleanup) - `uninstall/omarchy-apps.sh`
14. Uninstall Omarchy webapps (cleanup) - `uninstall/omarchy-webapps.sh`
15. Hyprland overrides - `install/hyprland-overrides.sh`
16. Yopki project repos - `dev/yopki.sh`
17. USB Mode Switch - `install/usb-modeswitch.sh`
18. Iriun Webcam - `yay/iriun-webcam.sh`
19. Voxtype speech-to-text - `yay/voxtype.sh`
20. Set default shell to zsh - `lib/set-shell.sh`

**Note:** After running `start.sh`, logout and login (or reboot) is required for shell change and voxtype input group to take effect.

## Script Compatibility

All scripts use the zsh-compatible SCRIPT_DIR pattern:
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
```

This ensures scripts work correctly when called from `start.sh` via zsh.
