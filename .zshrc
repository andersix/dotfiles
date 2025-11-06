# vim:tabstop=4:softtabstop=4:shiftwidth=4:textwidth=79:expandtab:autoindent:fileformat=unix:
#
# Oh... this is "my" .zshrc
#
# Here is a non-exhaustive list, in execution-order, of what each zsh file tends to contain:
#
#    .zshenv---is always sourced.
#       It often contains exported variables that should be available to other programs.
#       For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv. Also, you can
#       set $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.
#    .zprofile---is for login shells.
#       It is basically the same as .zlogin except that it's sourced before .zshrc
#       whereas .zlogin is sourced after .zshrc. According to the zsh documentation,
#       ".zprofile is meant as an alternative to .zlogin for ksh fans; the two are not
#       intended to be used together, although this could certainly be done if desired."
#    .zshrc---is for interactive shells.
#       You set options for the interactive shell there with the setopt and unsetopt
#       commands. You can also load shell modules, set your history options, change
#       your prompt, set up zle and completion, etc. You also set any variables that
#       are only used in the interactive shell (e.g. $LS_COLORS).
#    .zlogin---is for login shells.
#       It is sourced on the start of a login shell but after .zshrc, if the shell is
#       also interactive. This file is often used to start X using startx. Some systems
#       start X on boot, so this file is not always very useful.
#    .zlogout---is sometimes used to clear and reset the terminal.
#       It is called when exiting, not when opening.
#

# return if non-interactive
[[ -o interactive ]] || return

HOSTNAME=$(hostname)
export HOSTNAME

# Homebrew setup is done in .zprofile (login shells)
# Completion setup for Homebrew zsh functions
if [ "$IS_MACOS" -eq 1 ] && type brew &>/dev/null; then
  # Cache brew --prefix for performance (it's slow ~100-200ms)
  BREW_PREFIX=$(brew --prefix)
  FPATH="$BREW_PREFIX/share/zsh/site-functions:${FPATH}"
  unset BREW_PREFIX
fi

# Enable colors and change prompt:
autoload -U colors && colors

# Completion (compinit with caching)
# XDG variables are set in .zprofile
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
mkdir -p "${ZSH_COMPDUMP:h}"
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
setopt AUTO_CD AUTO_PUSHD HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY EXTENDED_GLOB
setopt PROMPT_SUBST INTERACTIVE_COMMENTS
compinit -d "$ZSH_COMPDUMP"
_comp_options+=(globdots) # Include hidden files.





# vi mode at command prompt:
# {{{
bindkey -v
export KEYTIMEOUT=1
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
# }}}




# History (XDG-aware)
# {{{
# XDG variables are set in .zprofile
# do not permits to recall dangerous commands in bash history
export HISTIGNORE='&:[bf]g:exit:*>|*:*rm*-rf*'
unset HISTFILESIZE
## add the full date and time to lines
#HISTTIMEFORMAT='%F %T '
#set history size
export HISTSIZE=2147483647
#save history after logout
export SAVEHIST=$HISTSIZE
#history file
#export HISTFILE=~/.zhistory
export HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "${HISTFILE:h}"
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY
alias history="history 1"
alias hist="history"
# }}}


# Linux specific config {{{
if [ "$IS_LINUX" -eq 1 ]; then
  export TERM=xterm-256color
  #export TERM=xterm-direct  # seems to work after installing "ncurses-term"
  #export TERM=xterm
  export COLORTERM=truecolor

  # Load dircolors for LS_COLORS
  if command -v dircolors >/dev/null 2>&1; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  fi
fi
# }}}

# OSX specific config {{{
if [ "$IS_MACOS" -eq 1 ]; then
  export TERM=xterm-256color
  export COLORTERM=truecolor
fi
# }}}

# Shared configuration files {{{
# All shared aliases and environment settings in ~/.shell_aliases
[[ -r "$HOME/.shell_aliases" ]] && source "$HOME/.shell_aliases"

# All shared functions in ~/.shell_functions
[[ -r "$HOME/.shell_functions" ]] && source "$HOME/.shell_functions"

# Optional: XDG layout additional configs
for f in "$XDG_CONFIG_HOME/shell"/{aliases,functions,completion}.sh; do
  [[ -r "$f" ]] && source "$f"
done
# }}}

# ZSH-specific integrations and tools {{{
# fzf key-bindings for zsh
command -v fzf >/dev/null   && [[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
# }}}

# Suggests commands as you type based on history and completions.
#   https://github.com/zsh-users/zsh-autosuggestions
if [[ -e "$HOME/.zsh.d/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.zsh.d/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# The following package provides syntax highlighting zsh.
# get from:
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# MUST be sourced last in zshrc
if [[ -e ~/.zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

#
# The "actual" Oh my zsh setup is not for me. Rather I use an interactive
# prompt, either liquidprompt or starship
#
# # Liquidprompt:
#   https://github.com/liquidprompt/liquidprompt
#
# # Starship Prompt:
#   https://starship.rs/
#   https://github.com/starship/starship
#
# # Nerd Fonts (I use FiraCode Mono)
#   https://www.nerdfonts.com/font-downloads
#
# Load prompt:
if [[ -e "$HOME/.shell_prompt_choice" ]]; then
  source "$HOME/.shell_prompt_choice"
  choose_prompt
fi

# # Set SSH_AUTH_SOCK and verify socket exists
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
# # warn if socket doesn't exist
# if [ ! -S "$SSH_AUTH_SOCK" ]; then
#     echo "Warning: SSH agent socket not found. Is ssh-agent.service running?"
# fi

