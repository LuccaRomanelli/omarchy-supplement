---
name: add-install
description: Add new packages or repositories to the omarchy-supplement installation system. Use when the user wants to add a yay package, pacman package, npm package, curl-based installer, or git repository to the project's package lists.
---

# Add Install Skill

Guide the process of adding new packages or repositories to the omarchy-supplement automated installation system.

## Workflow

### Step 1: Determine Installation Type

Use AskUserQuestion to ask:

**Question:** "What type of installation would you like to add?"

**Options:**
1. **yay** - AUR packages (community-maintained)
2. **pacman** - Official Arch Linux packages
3. **npm** - Global Node.js packages
4. **curl** - Curl-based installer scripts
5. **git** - Git repositories to clone
6. **Don't know** - I'll help you figure it out

---

### Step 2A: If "Don't know" is Selected

1. Ask what software the user wants to install
2. Use **WebSearch** to find how to install it on Arch Linux:
   - Search Arch Wiki, AUR, official docs
3. Present a plan:
   - Installation method (yay/pacman/npm/curl/git)
   - Package/repo name
   - Source of information
   - Any additional setup needed (custom script like zsh.sh, tmux.sh)
4. If confirmed, add the entry to the appropriate list file and proceed to Step 3

---

### Step 2B: If Specific Type Chosen

#### YAY Packages
Ask for package name with examples:
- Format: One package per line
- Examples: `zen-browser-bin`, `jellyfin-mpv-shim`
- Add to: `yay/packages.list`

#### Pacman Packages
Ask for package name with examples:
- Format: One package per line
- Examples: `ripgrep`, `pandoc`
- Add to: `pacman/packages.list`

#### NPM Packages
Ask for package name with examples:
- Format: One package per line (supports scoped)
- Examples: `@anthropic-ai/claude-code`, `@devcontainers/cli`
- Add to: `npm/packages.list`

#### Curl Packages
Ask for three fields with examples:
- Format: `<name> <check_command> <install_url>`
- Example: `nhost nhost https://raw.githubusercontent.com/nhost/cli/main/get.sh`
- Add to: `curl/packages.list`

#### Git Repositories
Ask for 1-4 fields with examples:
- Format: `<repo_url> [repo_name] [branch] [post_clone_script]`
- Examples:
  - `git@github.com:user/repo.git repo main`
  - `git@github.com:user/dotfiles.git dotfiles main setup.sh`
- Add to: `git/repos.list`

---

### Step 3: Documentation Updates

After adding the entry:

1. **README.md** - Update if significant tool added (add to "What Gets Installed" tables)
2. **CLAUDE.md** - Update if new patterns, dependencies, or quirks discovered

---

## Reference: Complex Installers

If package needs post-install setup, create dedicated script like:
- `yay/zsh.sh` - Multiple components (Oh-My-Zsh + plugins)
- `yay/tmux.sh` - Plugin manager setup
- `yay/voxtype.sh` - User groups + Hyprland bindings
