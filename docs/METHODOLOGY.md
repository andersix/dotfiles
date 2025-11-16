# The Bare Repository Methodology

*A universal approach for managing dotfiles with Git—applicable to anyone's configuration files.*

## What is the Bare Repository Approach?

This bare repository methodology uses Git via an alias to track files you specify in `$HOME` without symlinks or special tools, storing them in a Git bare repository in a "side" folder ($HOME/.dotfiles) using a specially crafted alias so that commands are run against that repository and not the usual .git local folder, which would interfere with any other Git repositories around. Your dotfiles are managed using a `dotfiles` alias to git that operates on the bare repository. Then managing your dotfiles becomes as simple as `dotfiles add myfile`, `dotfiles commit`, and `dotfiles push`.

**Benefits:**
- No symlink management
- Files tracked with version control
- Different branches for different computers
- Easy replication to new machines
- Works with any shell or configuration files

## Prerequisites

**Required:**
- `git`
- `rsync` (for replication to new machines)

**Platform-Specific:**
- **macOS**: Command line tools (comes with git), or you can install [Homebrew](https://brew.sh/)
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
- Always review files before running `dotfiles add`
- Use a `~/.gitignore` file as a safety valve (see below)
- Use environment variables or separate credential files (not tracked) for sensitive data
- Consider using tools like `git-secrets` or pre-commit hooks to prevent accidental commits
- If you accidentally commit sensitive data, you must remove it from git history (see [Troubleshooting](#accidentally-committed-sensitive-data))

### Using `.gitignore` as a Safety Valve

While `dotfiles config status.showUntrackedFiles no` prevents your entire home directory from appearing in `dotfiles status`, a `~/.gitignore` file provides an additional safety layer by preventing accidental commits of sensitive files.

See the [`.gitignore`](../.gitignore) file in this repository for an example.

**How it helps:**
- Prevents `dotfiles add ~/.ssh/id_rsa` from working (git will refuse without `--force`)
- Protects against wildcards like `dotfiles add ~/.config/*` accidentally including sensitive subdirs
- Self-documents what files should never be tracked
- Test it works: `dotfiles check-ignore ~/.ssh/id_rsa` (should output the file path if ignored)

**Important:** `.gitignore` is a safety net, not a replacement for careful review. Always inspect files before adding them. Use specific paths (like `.config/gcloud/`) to avoid blocking your entire `.config/` directory.

**Common files to avoid:**
- `.env`, `.env.local` - Environment variables often contain secrets
- `.aws/credentials`, `.ssh/id_*` (private keys), `.gnupg/`
- `.netrc`, `.password-store/`
- Shell history files (properly configured dotfiles should move history to XDG paths, which should not be tracked)

## Setup from Scratch

Use this approach to adopt the bare repository methodology with your own dotfiles.

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
# Note: Create your repository on GitHub first before running this command
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

**Next steps:** Continue to [Daily Usage](#daily-usage) below to learn day-to-day workflows.

---

# Daily Usage

*Applies to everyone using the bare repository methodology, regardless of whose dotfiles you're managing.*

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
dotfiles submodule update --init --recursive  # Update submodules if needed
source ~/.bashrc  # or source ~/.zshrc
```

**Updating submodules (like Alacritty themes):**
```sh
# Update to latest theme versions
dotfiles submodule update --remote
dotfiles add .config/alacritty/themes
dotfiles commit -m "Update Alacritty themes"
dotfiles push
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

*Common issues and solutions when using the bare repository methodology.*

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

**Solution:** The shell will work even with missing dependencies. If using someone else's dotfiles, check their documentation for required dependencies.

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

