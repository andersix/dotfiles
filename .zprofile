#
# ~/.zprofile — login shell setup (macOS + Linux)
# Sourced for login shells BEFORE .zshrc
# Keep this self-contained; doesn't rely on .shell_aliases

# Homebrew setup (macOS only)
# Use brew shellenv for proper PATH, MANPATH, etc.
if [[ "$OSTYPE" == darwin* ]]; then
  export HOMEBREW_NO_ANALYTICS=1
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [[ -x /usr/local/bin/brew   ]] && eval "$(/usr/local/bin/brew shellenv)"
fi

# Local bin paths (put before system PATH)
path=( "$HOME/bin" "$HOME/.local/bin" $path )
export PATH

# XDG Base Directory Specification
# Set here since most shells are login shells
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Locale (avoid perl/python warnings)
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

