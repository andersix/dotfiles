# ~/.zshenv — keep this tiny (runs for ALL zsh invocations)

# Fast bailouts: don’t source big files here.
export ZDOTDIR="${ZDOTDIR:-$HOME}"

# Ensure POSIX-y umask
umask 022

# If you truly must export something globally (env for non-interactive tools), do it here.
# Avoid PATH edits here; prefer .zprofile for login shells.

# claude code
export DISABLE_TELEMETRY=1
export DISABLE_ERROR_REPORTING=1
export DISABLE_BUG_COMMAND=1
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

