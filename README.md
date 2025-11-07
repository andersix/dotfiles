# my dotfiles

Welcome to my $HOME. This repository contains my personal configuration files for Linux (Arch, Debian, RHEL variants) and macOS. I've migrated to ZSH on personal machines but maintain BASH for work RHEL systems.

## What is This?

This repository serves two purposes:

1. **A Methodology**: A bare Git repository approach for managing dotfiles—no symlinks, no extra tooling, just Git.

2. **My Implementation**: My personal configuration files managed using this methodology (cross-platform bash/zsh, vim, tmux, Starship prompt, XDG compliance, and modern CLI tool integration).

**Choose your path:**
- **Want to learn the methodology with your own dotfiles?** → See [Option A](#option-a-learn-the-methodology-start-from-scratch) in Part 1 below.
- **Want to use my dotfiles as-is?** → See [Option B](#option-b-use-my-dotfiles-exact-copy) in Part 2 below.
- **Want to fork and customize my dotfiles?** → See [Option C](#option-c-fork-and-customize) in Part 2 below.

---

# Part 1: The Bare Repository Methodology

*This section is universal—applicable to anyone's dotfiles.*

## What is the Bare Repository Approach?

The bare repository methodology uses Git directly to track files in `$HOME` without symlinks or special tools. Files are managed using a `dotfiles` alias to git that operates on a bare repository. Managing your dotfiles becomes as simple as using Git, with commands like `dotfiles add myfile`, `dotfiles commit`, and `dotfiles push`.

**Benefits:**
- No symlink management
- Files tracked with version control
- Different branches for different computers
- Easy replication to new machines
- Works with any shell or configuration files

## Prerequisites (Methodology)

**Required:**
- `git`
- `rsync` (for replication to new machines)

**Platform-Specific:**
- **macOS**: Command line tools (comes with git, or you can install [Homebrew](https://brew.sh/)
- **Linux**: Your distro's package manager (apt, pacman, dnf, etc.)

## How It Works

The `dotfiles` alias points to a bare Git repository in `$HOME/.dotfiles/` with `$HOME` as the working tree:

```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

This allows you to run commands like:
- `dotfiles status` - See what config files have changed
- `dotfiles add ~/.vimrc` - Track a config file
- `dotfiles commit -m "Update vimrc"` - Commit changes
- `dotfiles push` - Push to remote repository

The key configuration that makes this work is:
```sh
dotfiles config status.showUntrackedFiles no
```

This prevents `dotfiles status` from showing every file in `$HOME`, only showing files you've explicitly added to the repository.

## Security Considerations

**Before adding any files to your dotfiles repository, carefully review them for sensitive information:**

- **Passwords, API keys, tokens** - Never commit these to version control
- **Private keys** (SSH, GPG, etc.) - Keep these out of your repository
- **Personal Identifiable Information (PII)** - Email addresses, phone numbers, addresses, etc.
- **Work-specific configurations** - Company-proprietary information or credentials
- **Browser history, cookies, or session data**

**Best Practices:**
- Always review files with `cat` or `vim` before running `dotfiles add`
- Use a `~/.gitignore` file as a safety valve (see below)
- Use environment variables or separate credential files (not tracked) for sensitive data
- Consider using tools like `git-secrets` or pre-commit hooks to prevent accidental commits
- If you accidentally commit sensitive data, you must remove it from git history (see [Troubleshooting](#accidentally-committed-sensitive-data))

### Using `.gitignore` as a Safety Valve

While `dotfiles config status.showUntrackedFiles no` prevents your entire home directory from appearing in `dotfiles status`, a `~/.gitignore` file provides an additional safety layer by preventing accidental commits of sensitive files.

See the `.gitignore` file in my dotfiles repository here for an example.

**How it helps:**
- Prevents `dotfiles add ~/.ssh/id_rsa` from working (git will refuse without `--force`)
- Protects against wildcards like `dotfiles add ~/.config/*` accidentally including sensitive subdirs
- Self-documents what files should never be tracked
- Test it works: `dotfiles check-ignore ~/.ssh/id_rsa` (should output the file path if ignored)

**Important:** `.gitignore` is a safety net, not a replacement for careful review. Always inspect files before adding them. Use specific paths (like `.config/gcloud/`) to avoid blocking your entire `.config/` directory

**Common files to avoid:**
- `.env`, `.env.local` - Environment variables often contain secrets
- `.aws/credentials`, `.ssh/id_*` (private keys), `.gnupg/`
- `.netrc`, `.password-store/`
- Shell history files (properly configured dotfiles should move history to XDG paths, which should not be tracked)

## Option A: Learn the Methodology (Start from Scratch)

Use this option to adopt the bare repository approach with your own dotfiles from scratch.

### 1. Initialize the bare repository
```sh
git init --bare $HOME/.dotfiles
```

### 2a. Create the dotfiles alias
```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### 2b. Add this alias permanently to your shell config:
```sh
# For bash, add to ~/.bashrc:
echo "alias dotfiles='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.bashrc

# For zsh, add to ~/.zshrc:
echo "alias dotfiles='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.zshrc
```

### 3. Configure the repository
```sh
# Hide untracked files (required for this methodology)
dotfiles config status.showUntrackedFiles no

# Add your own remote (replace with your username and repo)
dotfiles remote add origin git@github.com:YOUR_USERNAME/dotfiles.git
```

### 4. Create a `.gitignore` file (recommended)

Create a `~/.gitignore` file to prevent accidentally adding sensitive files. This acts as a safety valve alongside `status.showUntrackedFiles no`.

```sh
cat > ~/.gitignore << 'EOF'
# Credentials and secrets
.env
.env.*
.ssh/id_*
.ssh/*.pem
.aws/credentials
.gnupg/

# Shell history
.bash_history
.zsh_history

# Common sensitive files
credentials.json
**/secrets.yaml
*.key
*.pem
EOF
```

You can customize this file with additional patterns specific to your needs. See the [Security Considerations](#security-considerations) section for more details.

### 5. Start tracking your dotfiles

⚠️ **Important:** Before adding any file, review it to ensure it contains no passwords, API keys, or personal information.

```sh
# Review files first
cat ~/.bashrc
cat ~/.vimrc

# If safe, add them (including .gitignore for safety)
dotfiles add ~/.gitignore
dotfiles add ~/.bashrc
dotfiles add ~/.vimrc
dotfiles commit -m "Initial commit: Add gitignore, bashrc and vimrc"
dotfiles push -u origin main
```

You're done! Now manage your dotfiles using the `dotfiles` command instead of `git`.

**Next steps:** Jump to [Part 3: Daily Usage](#part-3-daily-usage) to learn how to use the methodology day-to-day.

---

# Part 2: My Implementation

*This section describes my specific dotfiles configuration that I use on my machines, and manage in this repo.*

## What's Included

**Supported Platforms:**
- macOS
- Linux: (I use Arch, Debian, and RHEL variants)
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

## Prerequisites (My Dotfiles)

**Required (in addition to methodology prerequisites):**
- `bash` or `zsh`
- `vim` (if using vim configs)

**Optional but Recommended:**
- `tmux` (if using tmux configs)
- `curl` or `wget` (for installing dependencies)

**Platform-Specific:**
- **macOS**: Homebrew (`https://brew.sh/`)
- **Linux**: Your distro's package manager (apt, pacman, dnf, etc.)

## Choose Your Installation Path

> **Important for Options B & C:** After installation, you **must** configure git to hide untracked files:
> ```sh
> dotfiles config status.showUntrackedFiles no
> ```
> This is fundamental to the bare repository methodology. Without it, `dotfiles status` would show every single file in your `$HOME` directory, making the repository unusable.

### Option B: Use My Dotfiles (Exact Copy)

Use this if you want to use my dotfiles as-is on your machine.

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

#### 5. Reload your shell
```sh
# For bash:
source ~/.bashrc

# For zsh:
source ~/.zshrc
```

Now proceed to [Post-Installation Setup](#post-installation-setup).

---

### Option C: Fork and Customize

Use this if you want to start with my dotfiles but customize them for your needs.

#### 1. Fork on GitHub
Fork this repository on GitHub to your own account.

#### 2. Follow Option B instructions, but use your fork's URL:
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

#### 4. Start customizing
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

> **📍 For Options B & C Only**
>
> If you chose **Option A** (learning the methodology), you're done! Skip this section.
>
> If you chose **Option B or C** (using my dotfiles), continue below to install dependencies for full functionality.

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

#### Starship (this is the one I am currently using)

**Starship** is my default prompt... a modern, fast prompt that works with both bash and zsh:
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

### freedesktop.org XDG Base Directory Compliance

The dotfiles follow XDG Base Directory Specification to keep `$HOME` clean:
- `XDG_CONFIG_HOME` - `~/.config` (configuration files)
- `XDG_CACHE_HOME` - `~/.cache` (cache files)
- `XDG_DATA_HOME` - `~/.local/share` (data files)
- `XDG_STATE_HOME` - `~/.local/state` (state files like history)

Shell history files are in XDG paths:
- Bash: `$XDG_STATE_HOME/bash/history`
- Zsh: `$XDG_STATE_HOME/zsh/history`

If you want to know more about XDG, see: (https://en.wikipedia.org/wiki/Freedesktop.org#Base_Directory_Specification)

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

# Part 3: Daily Usage

*This section applies to everyone using the bare repository methodology, regardless of whose dotfiles you're managing.*

Use the `dotfiles` command exactly like `git`:

```sh
# Check what's changed
dotfiles status

# Add a new dotfile (⚠️ Always review first for sensitive data!)
cat ~/.gitconfig  # Review the file first
dotfiles add ~/.gitconfig

# Commit changes
dotfiles commit -m "Update gitconfig with new aliases"

# Get changes from remote
dotfiles pull

# Push your changes
dotfiles push

# View history
dotfiles log

# Create a branch for a specific machine
dotfiles checkout -b laptop-work
```

## Common Workflows

**Adding a new config file:**
```sh
# Always review before adding
cat ~/.config/alacritty/alacritty.yml
# If it contains no sensitive data, add it
dotfiles add ~/.config/alacritty/alacritty.yml
dotfiles commit -m "Add alacritty config"
dotfiles push
```

**Updating dotfiles on another machine:**
```sh
dotfiles pull
source ~/.bashrc  # or source ~/.zshrc
```

**Experimenting with changes:**
```sh
dotfiles checkout -b experimental
# make changes
dotfiles add -u
dotfiles commit -m "Test new prompt settings"
# If you like it:
dotfiles checkout main
dotfiles merge experimental
```

---

# Troubleshooting

*Common issues and solutions for both the methodology and my dotfiles implementation.*

## Conflicts During Clone

**Problem:** Files already exist in `$HOME`

**Solution:**
```sh
# Backup existing files
mkdir ~/dotfiles-backup
cp ~/.bashrc ~/.zshrc ~/.vimrc ~/dotfiles-backup/

# Then retry clone with force
git clone --separate-git-dir="$HOME/.dotfiles" https://github.com/andersix/dotfiles.git "$HOME/dotfiles-tmp" --force
```

## "dotfiles: command not found" After Restart

**Problem:** Alias not persisted

**Solution:** The alias is in `.shell_aliases` which should be sourced by `.bashrc`/`.zshrc`. Verify:
```sh
grep -r "shell_aliases" ~/.bashrc ~/.zshrc
```

If missing, add to your shell config:
```sh
[ -f ~/.shell_aliases ] && source ~/.shell_aliases
```

## Shell Errors on First Login

**Problem:** Missing dependencies (prompt plugins, etc.)

**Solution:** The shell will work even with missing dependencies. Install the optional plugins listed in [Post-Installation Setup](#post-installation-setup) to remove errors.

## Vim Errors on First Launch

**Problem:** Plugins not installed yet

**Solution:** This is normal. Run `:PlugInstall` inside vim to install plugins.

## Git Asks for Username/Password

**Problem:** Using HTTPS instead of SSH

**Solution:** Switch to SSH URLs:
```sh
dotfiles remote set-url origin git@github.com:YOUR_USERNAME/dotfiles.git
```

Or configure Git credential helper for HTTPS.

## Too Many Untracked Files in `dotfiles status`

**Problem:** Forgot to set `status.showUntrackedFiles no`

**Solution:**
```sh
dotfiles config status.showUntrackedFiles no
```

This is required for the bare repository methodology and prevents `dotfiles status` from listing every file in your home directory. Without this setting, the repository is unusable.

## Accidentally Committed Sensitive Data

**Problem:** You committed and pushed a file containing passwords, API keys, or other sensitive information.

**Solution:** You **must** remove it from git history immediately, as simply deleting it in a new commit doesn't remove it from the repository history.

```sh
# Option 1: Using BFG Repo-Cleaner (easiest)
# Install: https://rtyley.github.io/bfg-repo-cleaner/
bfg --delete-files sensitive-file.txt ~/.dotfiles
cd ~
dotfiles reflog expire --expire=now --all
dotfiles gc --prune=now --aggressive
dotfiles push --force

# Option 2: Using git filter-branch
dotfiles filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/sensitive-file' \
  --prune-empty --tag-name-filter cat -- --all
dotfiles push --force
```

**Important:** After removing sensitive data:
- Rotate any exposed credentials immediately (passwords, API keys, tokens)
- Consider the data compromised if the repository was public
- Review what was exposed and take appropriate security measures

---

# References

1. **Original Methodology:** [StreakyCobra on Hacker News](https://news.ycombinator.com/item?id=11070797#11071754) — The elegant bare repository approach that inspired this setup.
> "No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate your configuration easily on new installation." — [StreakyCobra on HN](https://news.ycombinator.com/item?id=11070797#11071754)


2. **Atlassian Tutorial:** [The best way to store your dotfiles](https://www.atlassian.com/git/tutorials/dotfiles) — Comprehensive guide to this methodology.

---

# Need Help?

If you run into issues not covered here, feel free to open an issue on GitHub. When reporting problems, please include:
- Your OS and version
- Your shell (bash/zsh) and version
- The specific error message
- What you were trying to do
