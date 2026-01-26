# Omarchy Supplement

Automated installation scripts for Arch Linux / Omarchy system setup.

## Quick Start

```bash
git clone git@github.com:LuccaRomanelli/omarchy-supplement.git
cd omarchy-supplement
./start.sh
```

## Architecture

```
omarchy-supplement/
├── start.sh              # Main entry point
├── yay/                  # AUR packages (via yay)
├── pacman/               # Official packages (via pacman)
├── npm/                  # Global npm packages
├── curl/                 # Curl-based installers
├── git/                  # Git repository cloning
├── install/              # Custom installation scripts
├── uninstall/            # Cleanup scripts
├── dev/                  # Development environment setup
└── lib/                  # Shared utilities
```

Each folder follows the same pattern:
- `install-package.sh` / `clone-repo.sh` - Single item installer
- `install-packages.sh` / `clone-repos.sh` - Batch installer from list file
- `packages.list` / `repos.list` - Registry of items to install

## What Gets Installed

### Shell & Terminal
| Tool | Description |
|------|-------------|
| **zsh** | Z shell with Oh-My-Zsh framework |
| **zsh-autosuggestions** | Fish-like autosuggestions for zsh |
| **zsh-syntax-highlighting** | Syntax highlighting for zsh commands |
| **tmux** | Terminal multiplexer with TPM plugin manager |
| **ghostty** | GPU-accelerated terminal emulator |
| **starship** | Cross-shell prompt (via dotfiles) |

### Development
| Tool | Description |
|------|-------------|
| **Node.js 24** | JavaScript runtime (via mise) |
| **pnpm** | Fast, disk space efficient package manager |
| **devcontainers/cli** | Dev container CLI for VS Code-style containers |
| **stow** | Symlink farm manager for dotfiles |

### AI Tools
| Tool | Description |
|------|-------------|
| **Claude Code** | Anthropic's CLI for Claude AI |
| **Voxtype** | Speech-to-text with Whisper (GPU-accelerated) |

### Media & Utilities
| Tool | Description |
|------|-------------|
| **Zen Browser** | Privacy-focused Firefox fork |
| **yazi** | Terminal file manager |
| **jellyfin-mpv-shim** | Jellyfin media player integration |
| **Iriun Webcam** | Use phone as wireless webcam |
| **ripgrep** | Fast recursive grep |
| **jq** | JSON processor |
| **w3m** | Text-based web browser |
| **googler** | Google search from command line |

### Document Processing
| Tool | Description |
|------|-------------|
| **pandoc** | Universal document converter |
| **texlive** | LaTeX distribution (basic + xetex) |
| **msmtp** | SMTP client for sending mail |

### Backend
| Tool | Description |
|------|-------------|
| **Nhost CLI** | Backend-as-a-service local development |

### Repositories Cloned
| Repo | Description |
|------|-------------|
| **dotfiles** | Personal configurations (zsh, tmux, ghostty, waybar, git) |
| **shell** | Custom shell scripts |
| **obsidian** | Obsidian vault |

## Hyprland Integration

The `hyprland-overrides.conf` provides:
- Multi-monitor setup (ultrawide + vertical)
- Custom keybindings for webapps and tools
- Voxtype speech-to-text (SUPER+D)
- Input device configuration

## Post-Installation

After running `start.sh`, logout/login or reboot for:
- Zsh as default shell
- Input group membership (for Voxtype)
- Tmux plugins (press `prefix + I` in tmux)
