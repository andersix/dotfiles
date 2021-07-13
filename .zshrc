# vim:tabstop=4:softtabstop=4:shiftwidth=4:textwidth=79:expandtab:autoindent:fileformat=unix:
# Enable colors and change prompt:
autoload -U colors && colors

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Include hidden files.

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




# History
# {{{
# do not permits to recall dangerous commands in bash history
export HISTIGNORE='&:[bf]g:exit:*>|*:*rm*-rf*'
unset HISTFILESIZE
## add the full date and time to lines
#HISTTIMEFORMAT='%F %T '
#set history size
export HISTSIZE=100000
#save history after logout
export SAVEHIST=100000
#history file
export HISTFILE=~/.zhistory
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
if [[ "$OSTYPE" == linux-gnu ]]; then
  #export TERM=xterm-256color
  export TERM=xterm-direct  # seems to work after installing "ncurses-term"
  alias ls='ls -hF --color'       # add colors for filetype recognition
  alias lm='ls -al --color=none|less'  # pipe through 'less'
  alias lx='ls -lXB'              # sort by extension
fi

# OSX specific config {{{
if [[ "$OSTYPE" == darwin* ]]; then
  export TERM=xterm-256color
  alias lm='ls -al |less'  # pipe through 'less'
  alias ls='ls -G'
  alias gvim='mvim'  # install mvim from macports
fi
# }}}

# The 'ls' family
alias l='ls -1'
alias la='ls -Al'               # show hidden files
alias lk='ls -lSr'              # sort by size
alias lc='ls -lcr'              # sort by change time
alias lu='ls -lur'              # sort by access time
alias lr='ls -lR'               # recursive ls
alias lt='ls -ltr'              # sort by date
alias ll='ls -l'
alias tree='tree -Csu'          # nice alternative to 'ls'

# changes the default head/tail behaviour to output x lines,
# where x is the number of lines currently displayed on your terminal
alias head='head -n $((${LINES:-`tput lines 2>/dev/null||echo -n 12`} - 2))'
alias tail='tail -n $((${LINES:-`tput lines 2>/dev/null||echo -n 12`} - 2))'

# If the output is smaller than the screen height is smaller,
# less will just cat it
# + support ANSI colors
export LESS="-FX -R"

# Syntax coloring with pygments in less, when opening source files
# MacOS: brew install pygments
#export LESSOPEN='|~/lessfilter.sh %s'
export LESSOPEN='|pygmentize -O style=solarized-dark -g %s'

function psg() {
    #        do not show grep itself           color matching string              color the PID
    ps aux | grep -v grep | grep --ignore-case --color=always $1 | colout '^\S+\s+([0-9]+).*$' blue
}



# default editor
export EDITOR='gvim --nofork'

# ipython shell with correct default apps
alias ipy='ipython -pylab -p scipy --editor="gvim"'

# shortcut to display the url config of remote repo in a git root
alias git_remotes="grep -A 2 \"\[remote\" .git/config|grep -v fetch|sed \"s/\[remote \\\"//\"|sed ':a;N;\$!ba;s/\"\]\n\s*url = /\t/g'"

# Pretty git log
alias git_log="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Take a snapshot of the current git repository and zip it.
# The archive file name has the current date in its name.
function git_archive()
{
    last_commit_date=$(git log -1 --format=%ci | awk '{print $1"_"$2;}' | sed "s/:/-/g")
    project=$(basename $(pwd))
    name=${project}_${last_commit_date}
    git archive --prefix=$name/ --format zip master > $name.zip
    echo $name.zip
}


# Intuitive calculator on the command line
# $ = 3 × 5.1 ÷ 2
# 7,65
calc() {
    calc="$@"
    # We can use the unicode signs × and ÷
    calc="${calc//×/*}"
    calc="${calc//÷//}"
    echo -e "$calc\nquit" | gcalccmd | sed 's/^> //g'
}

# Global aliases  {{{
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases  # bash and zsh aliases same they are
fi
# }}}

# alias I want to learn
function h()
{
echo "la : show hidden files"
echo "lx : sort by extension"
echo "lk : sort by size"
echo "lc : sort by change time"
echo "lu : sort by access time"
echo "lr : recursive ls"
echo "lt : sort by date"
echo "lm : pipe through 'less'"
echo "md : mkdir, cd"
}

# Oh my zsh, is not for me. I use liquidprompt...
# Use liquidprompt only if in an interactive shell
if [[ $- == *i* ]]; then
    # Super nice prompt
    if [[ -e ~/.liquidpromptrc ]]; then
        source ~/.liquidpromptrc
    fi
    source ~/.liquidprompt
fi

# The following package provides syntax highlighting zsh.
# get from:
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# MUST be sourced last in zshrc
if [[ -e ~/.zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source ~/.zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

