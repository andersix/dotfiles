# .bashrc
# return if non-interactive
case $- in *i*) ;; *) return ;; esac

#Global options {{{
HOSTNAME=$(hostname)
export HOSTNAME
export SHELL_SESSION_HISTORY=0
export HISTFILESIZE=
export HISTSIZE=""
export HISTCONTROL=ignoredups:ignorespace
# Use XDG for history file (XDG variables set in .shell_aliases)
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
mkdir -p "${HISTFILE%/*}"  # Create directory if it doesn't exist
shopt -s checkwinsize
shopt -s progcomp
#make sure the history is updated at every command
shopt -s histappend

#!! sets vi mode for shell
set -o vi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# }}}

## # Bashmarks from https://github.com/huyng/bashmarks (see copyright there) {{{
## 
## # USAGE:
## # s bookmarkname - saves the curr dir as bookmarkname
## # g bookmarkname - jumps to the that bookmark
## # g b[TAB] - tab completion is available
## # l - list all bookmarks
## 
## # save current directory to bookmarks
## touch ~/.sdirs
## function s {
##   cat ~/.sdirs | grep -v "export DIR_$1=" > ~/.sdirs1
##   mv ~/.sdirs1 ~/.sdirs
##   echo "export DIR_$1=$PWD" >> ~/.sdirs
## }
## 
## # jump to bookmark
## function g {
##   source ~/.sdirs
##   cd $(eval $(echo echo $(echo \$DIR_$1)))
## }
## 
## # list bookmarks with dirnam
## function l {
##   source ~/.sdirs
##   env | grep "^DIR_" | cut -c5- | grep "^.*="
## }
## # list bookmarks without dirname
## function _l {
##   source ~/.sdirs
##   env | grep "^DIR_" | cut -c5- | grep "^.*=" | cut -f1 -d "="
## }
## 
## # completion command for g
## function _gcomp {
##     local curw
##     COMPREPLY=()
##     curw=${COMP_WORDS[COMP_CWORD]}
##     COMPREPLY=($(compgen -W '`_l`' -- $curw))
##     return 0
## }
## 
## # bind completion command for g to _gcomp
## complete -F _gcomp g
## # }}}

# Shared configuration files {{{
# All shared aliases and environment settings in ~/.shell_aliases
if [ -f ~/.shell_aliases ]; then
    . ~/.shell_aliases
fi

# All shared functions in ~/.shell_functions
if [ -f ~/.shell_functions ]; then
    . ~/.shell_functions
fi
# }}}

# Bash-specific functions can go here {{{
# }}}


# Linux specific config {{{
if [ "$IS_LINUX" -eq 1 ]; then
  export TERM=xterm-256color
  #shopt -s autocd
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
  fi
fi
# }}}

# Specific project aliases and settings{{{
if [ -f ~/.bash_project_aliases ]; then
    . ~/.bash_project_aliases
fi
# }}}

# Synopsys Verdi {{{
if [ -f ~/verdi_custom.tcl ]; then
	export NOVAS_AUTO_SOURCE="$HOME/verdi_custom.tcl"
fi
# }}}

# OSX specific config {{{
if [ "$IS_MACOS" -eq 1 ]; then
  export TERM=xterm-256color
  export HOMEBREW_NO_ANALYTICS=1

  #homebrew git autocompletions {{{
  # Cache brew --prefix for performance (it's slow ~100-200ms)
  BREW_PREFIX=$(brew --prefix)
  if [ -f "$BREW_PREFIX/etc/bash_completion.d/git-completion.bash" ]; then
    . "$BREW_PREFIX/etc/bash_completion.d/git-completion.bash"
  fi
  unset BREW_PREFIX
  #}}}

  #Pipe2Eval folder for vim extension
  export PIP2EVAL_TMP_FILE_PATH=/tmp/shms

#  export WORKON_HOME="~/dev/envs"
#  export VIRTUALENV_USE_DISTRIBUTE=1
#  [[ -n "/usr/local/bin/virtualenvwrapper.sh" ]] && source virtualenvwrapper.sh
fi
# }}}

# Specific systems configs {{{
# }}}

# SSH configs {{{
#SSH_ENV="$HOME/.ssh/environment"
#
#function start_agent {
#    echo "Initialising new SSH agent..."
#    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#    echo succeeded
#    chmod 600 "${SSH_ENV}"
#    . "${SSH_ENV}" > /dev/null
##    /usr/bin/ssh-add;
#}
#
## Source SSH settings, if applicable
#
#if [ -f "${SSH_ENV}" ]; then
#    . "${SSH_ENV}" > /dev/null
#    #ps ${SSH_AGENT_PID} doesn't work under cywgin
#    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#        start_agent;
#    }
#else
#    start_agent;
#fi
# }}}

# Get Environment Modules {{{
if [ -f /usr/share/Modules/init/bash ]; then
    . /usr/share/Modules/init/bash
elif [ -f /usr/share/modules/init/bash ]; then
    . /usr/share/modules/init/bash
elif [ -f /etc/modules/init/bash ]; then
    . /etc/modules/init/bash
elif [ -f /usr/local/opt/modules/init/bash ]; then  # macos, brew install modules
    . /usr/local/opt/modules/init/bash
else
    echo "[INFO] Environment modules not found"
fi
# }}}


# Set my home bin in PATH, I like it first {{{
export PATH=$HOME/bin:$PATH
# }}}


## Liquid Prompt {{{
# NOTE: LP options are in ~/.config/liquidpromptrc
## }}}

# pick prompt
[ -f "$HOME/.shell_prompt_choice" ] && source "$HOME/.shell_prompt_choice"

