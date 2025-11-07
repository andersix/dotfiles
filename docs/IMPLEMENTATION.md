# My Dotfiles Implementation

*This document describes my specific dotfiles configuration—the actual configs I use on my machines and manage in this repository.*

## What's Included

**Supported Platforms:**
- macOS
- Linux (Arch, Debian, RHEL variants)
- Both bash and zsh (zsh for personal machines, bash for work systems)

**Key Features:**
- Cross-platform shell configuration with shared aliases and functions
- Starship prompt (with Liquidprompt/Spaceship fallbacks)
- Vim with vim-plug and modular plugin architecture
- Tmux with TPM and custom prefix (Ctrl-a instead of Ctrl-b)
- XDG Base Directory Specification compliance
- Integration with modern CLI tools (bat, eza, fzf, ripgrep)
- Automatic OS detection for platform-specific behavior
- Graceful degradation when optional tools aren't installed

**Architecture Highlights:**
- **Shared configuration**: `.shell_aliases` and `.shell_functions` sourced by both bash and zsh
- **OS detection**: `IS_MACOS` and `IS_LINUX` environment variables for platform-specific logic
- **Prompt auto-detection**: Automatically uses Starship if available, falls back to Liquidprompt/Spaceship
- **XDG compliance**: Shell history and cache files stored in XDG directories to keep `$HOME` clean
- **Modular vim config**: Plugin definitions separate from main `.vimrc`, individual plugin configs in dedicated files
- **Git submodules**: Alacritty themes managed as a submodule for easy updates

## Prerequisites (My Dotfiles)

**Required from the Methodology:**
- `git` - Version control system
- `rsync` - For copying files during installation

**Required (in addition to methodology prerequisites):**
- `bash` or `zsh`
- `vim` (if using vim configs)

**Optional but Recommended:**
- `tmux` (if using tmux configs)
- `curl` or `wget` (for installing dependencies)

**Platform-Specific:**
- **macOS**: Homebrew (`https://brew.sh/`)
- **Linux**: Your distro's package manager (apt, pacman, dnf, etc.)

## Installation Options

### Install As-Is

Use this approach to install my dotfiles exactly as-is on your machine.

#### ⚠️ Warning
This will overwrite existing dotfiles in your home directory. **Back up your existing configs first:**
```sh
mkdir ~/dotfiles-backup
cp ~/.bashrc ~/.zshrc ~/.vimrc ~/.tmux.conf ~/dotfiles-backup/ 2>/dev/null || true
```

#### 1. Create a temporary alias
```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

#### 2. Clone the repository
```sh
git clone --separate-git-dir="$HOME/.dotfiles" https://github.com/andersix/dotfiles.git "$HOME/dotfiles-tmp"
```

If you get errors about existing files, either back them up or add `--force` to the clone command (use with caution).

#### 3. Copy files to your home directory
```sh
rsync -av --exclude '.git' "$HOME/dotfiles-tmp/" "$HOME/"
rm -rf "$HOME/dotfiles-tmp"
```

#### 4. Configure the repository
```sh
# Hide untracked files (required for this methodology)
dotfiles config status.showUntrackedFiles no
```

**Note:** The `dotfiles` alias is already included in my dotfiles (`.shell_aliases`), so it will persist after you restart your shell.

#### 5. Initialize submodules
```sh
# Initialize and update submodules (for Alacritty themes)
dotfiles submodule update --init --recursive
```

#### 6. Reload your shell
```sh
# For bash:
source ~/.bashrc

# For zsh:
source ~/.zshrc
```

Now proceed to [Post-Installation Setup](#post-installation-setup).

---

### Fork and Customize

Use this approach to start with my dotfiles and customize them for your needs.

#### 1. Fork on GitHub
Fork this repository on GitHub to your own account.

#### 2. Follow the Install As-Is instructions above, but use your fork's URL:
```sh
git clone --separate-git-dir="$HOME/.dotfiles" https://github.com/YOUR_USERNAME/dotfiles.git "$HOME/dotfiles-tmp"
rsync -av --exclude '.git' "$HOME/dotfiles-tmp/" "$HOME/"
rm -rf "$HOME/dotfiles-tmp"
```

#### 3. Configure the repository
```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config status.showUntrackedFiles no
```

**Note:** The `dotfiles` alias is already included in the dotfiles (`.shell_aliases`), so it will persist after you restart your shell.

#### 4. Initialize submodules
```sh
# Initialize and update submodules (for Alacritty themes)
dotfiles submodule update --init --recursive
```

#### 5. Start customizing
```sh
# Edit files as needed
vim ~/.bashrc

# Commit your changes
dotfiles add ~/.bashrc
dotfiles commit -m "Customize bashrc for my setup"
dotfiles push
```

---

## Post-Installation Setup

> **📍 Required After Installation**
>
> This section is required if you installed my dotfiles using either approach above. Continue below to install dependencies for full functionality.

### Shell Dependencies

#### For Bash Users

**Liquidprompt** (shell prompt):
```sh
cd ~
git clone https://github.com/liquidprompt/liquidprompt.git
ln -s liquidprompt/liquidprompt .liquidprompt
```

**Environment Modules** (optional):
```sh
# Debian/Ubuntu:
sudo apt install environment-modules

# Arch:
sudo pacman -S environment-modules

# macOS:
brew install modules
```

#### For Zsh Users

Create the zsh plugins directory and clone plugins:
```sh
mkdir -p ~/.zsh.d
cd ~/.zsh.d

# Spaceship Prompt (alternative prompt)
git clone https://github.com/spaceship-prompt/spaceship-prompt.git

# Syntax highlighting (must be sourced last in .zshrc)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

# Autosuggestions (fish-like suggestions)
git clone https://github.com/zsh-users/zsh-autosuggestions.git
```

#### Starship (Recommended)

**Starship** is my default prompt—a modern, fast prompt that works with both bash and zsh:
```sh
# macOS:
brew install starship

# Linux (universal installer):
curl -sS https://starship.rs/install.sh | sh

# Or using package manager:
# Arch: sudo pacman -S starship
# Debian/Ubuntu: Check https://starship.rs for latest instructions
```

The dotfiles will auto-detect and use Starship if available, otherwise fall back to Liquidprompt/Spaceship.

### Vim Setup

#### 1. Install vim-plug (plugin manager)
```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

#### 2. Install vim plugins
```sh
vim
# Inside vim, run:
:PlugInstall
```

Press Enter to dismiss any errors on first run, then `:PlugInstall` will work.

### Tmux Setup

#### 1. Install TPM (Tmux Plugin Manager)
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

#### 2. Install tmux plugins
```sh
tmux
# Inside tmux, press:
# Ctrl-a (my prefix, not default Ctrl-b) + Shift-i
```

Note: My tmux prefix is remapped from `Ctrl-b` to `Ctrl-a`.

### Optional Modern Tools

These dotfiles integrate with modern CLI tools if they're installed:

```sh
# macOS:
brew install bat eza fzf ripgrep

# Arch:
sudo pacman -S bat eza fzf ripgrep

# Debian/Ubuntu:
sudo apt install bat fzf ripgrep
# For eza: https://github.com/eza-community/eza/blob/main/INSTALL.md
```

- `bat` - Better `cat` with syntax highlighting
- `eza` - Modern `ls` replacement
- `fzf` - Fuzzy finder with keybindings
- `ripgrep` - Faster `grep` alternative

My dotfiles detect these automatically and use them when available.

## Architecture Details

### Cross-Platform Shell Configuration

The repository supports both **bash** and **zsh** on **Linux** and **macOS**. Configuration is structured for maximum code reuse:

**OS Detection** (`.shell_aliases`):
- Sets `IS_MACOS` and `IS_LINUX` environment variables (1 or 0)
- Use these variables for platform-specific logic

**Shared Configuration Files**:
- `.shell_aliases` - All shared aliases and environment variables
- `.shell_functions` - All shared shell functions
- `.shell_prompt_choice` - Unified prompt selection (Starship or Liquidprompt)

**Shell-Specific Files**:
- `.bashrc` - Bash interactive shell setup, sources shared files
- `.zshrc` - Zsh interactive shell setup, sources shared files
- `.zshenv` - Zsh environment (minimal, runs for all zsh invocations)
- `.zprofile` - Zsh login shell (Homebrew setup, PATH, XDG variables)

**Adding platform-specific logic**:
- Use the following if/then/else structure if you add any platform specific things:
```bash
if [ "$IS_MACOS" -eq 1 ]; then
  # macOS-specific code
elif [ "$IS_LINUX" -eq 1 ]; then
  # Linux-specific code
fi
```

### XDG Base Directory Compliance

The dotfiles follow the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to keep `$HOME` clean:
- `XDG_CONFIG_HOME` - `~/.config` (configuration files)
- `XDG_CACHE_HOME` - `~/.cache` (cache files)
- `XDG_DATA_HOME` - `~/.local/share` (data files)
- `XDG_STATE_HOME` - `~/.local/state` (state files like history)

Shell history files are in XDG paths:
- Bash: `$XDG_STATE_HOME/bash/history`
- Zsh: `$XDG_STATE_HOME/zsh/history`

### Vim Configuration

Vim setup is in `.vimrc` with modular architecture:
- Main settings in `.vimrc`
- Plugin definitions in `~/.vim/plugins.vim`
- Individual plugin configs in `~/.vim/plugin_configs/*.vim`
- Optional modules in `~/.vim/modules/*.vim` (loaded on-demand with `:LoadModule <name>`)

Vim uses vim-plug for plugin management. After adding dotfiles to new machine, run `:PlugInstall` in vim.

### Prompt Selection System

The `.shell_prompt_choice` file provides automatic prompt detection:
1. Checks for Starship (preferred if available)
2. Falls back to Liquidprompt
3. Can be manually overridden with `CHOOSE_PROMPT_FORCE` variable
4. Use `rechoose_prompt` alias to re-run selection

## Platform-Specific Notes

*These describe my implementation choices, not universal requirements.*

### macOS

- Homebrew is initialized in `.zprofile` (login shells)
- Homebrew paths are auto-configured
- Uses macOS-specific commands (e.g., `trash` instead of `rm -i`)
- GUI apps: MacVim via `gvim` alias, Finder via `fnd` alias

### Linux

- Terminal colors configured for xterm-256color
- Package manager aliases (apt, pacman) available
- GNU coreutils options used (e.g., `rm -I --preserve-root`)
- Desktop notifications via `alert` alias

## Key Files and Features

*This describes what's in my dotfiles specifically.*

**Cross-platform shell configs:**
- **`.shell_aliases`** - Shared aliases for bash and zsh (OS detection built-in)
- **`.shell_functions`** - Shared shell functions
- **`.shell_prompt_choice`** - Auto-detects and loads Starship or Liquidprompt

**Shell-specific:**
- **`.bashrc` / `.zshrc`** - Shell initialization (both source shared files)
- **`.zshenv` / `.zprofile`** - Zsh environment and login shell setup

**Application configs:**
- **`.vimrc`** - Modular vim config with vim-plug and plugin architecture
- **`.tmux.conf`** - Tmux with custom prefix (Ctrl-a) and TPM plugins
- **`.gitconfig`** - Git configuration and aliases

**XDG compliance:**
- Shell history in `$XDG_STATE_HOME`
- Zsh completion cache in `$XDG_CACHE_HOME`

## Verification

Test that everything is working:

```sh
# Check the dotfiles alias works
dotfiles status

# Check shell prompt loaded
echo $PROMPT_COMMAND  # bash
echo $PROMPT          # zsh

# Check vim plugins loaded
vim +PlugStatus

# Check tmux (if installed)
tmux ls
```

---

