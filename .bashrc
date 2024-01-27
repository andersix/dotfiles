# .bashrc

#Global options {{{
export SHELL_SESSION_HISTORY=0
export HISTFILESIZE=
export HISTSIZE=""
export HISTCONTROL=ignoredups:ignorespace
export PAGER=less
shopt -s checkwinsize
shopt -s progcomp

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

# Fixes hg/mercurial {{{
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# }}}

# Global aliases  {{{
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# }}}

# Global functions (aka complex aliases) {{{
function findf {
  find . -type f | grep -v .svn | grep -v .git | grep -i $1
}

# print only column x of output
function col {
  awk -v col=$1 '{print $col}'
}

# skip first x words in line
function skip {
    n=$(($1 + 1))
    cut -d' ' -f$n-
}

# global search and replace OSX
function sr {
    find . -type f -exec sed -i '' s/$1/$2/g {} +
}

# shows last modification date for trunk and $1 branch
function glogm {
  echo master $(git log -u master $2 | grep -m1 Date:)
  echo $1 $(git log -u $1 $2 | grep -m1 Date:)
}

# git rename current branch and backup if overwritten
function gmvb {
  curr_branch_name=$(git branch | grep \* | cut -c 3-);
  if [ -z $(git branch | cut -c 3- | grep -x $1) ]; then
    git branch -m $curr_branch_name $1
  else
    temp_branch_name=$1-old-$RANDOM;
    echo target branch name already exists, renaming to $temp_branch_name
    git branch -m $1 $temp_branch_name
    git branch -m $curr_branch_name $1
  fi
}

# git search for extension $1 and occurrence of string $2
function gfe {
  git f \.$1 | xargs grep -i $2 | less
}

#open with vim from a list of files, nth one (vim file number x)
function vfn {
  last_command=$(history 2 | head -1 | cut -d" " -f2- | cut -c 2-);
  vim $($last_command | head -$1 | tail -1)
}

#open a scratch file in Dropbox
function sc {
  gvim ~/Dropbox/$(openssl rand -base64 10 | tr -dc 'a-zA-Z').txt
}
function scratch {
  gvim ~/Dropbox/$(openssl rand -base64 10 | tr -dc 'a-zA-Z').txt
}
# }}}

# Do ripgrep then puts fuzzy searching in the resulting files+text on top while showing context:
function frg {
  result=`rg --ignore-case --color=always --line-number --no-heading "$@" |
    fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'`
  file="${result%%:*}"
  linenumber=`echo "${result}" | cut -d: -f2`
  if [ ! -z "$file" ]; then
          $EDITOR +"${linenumber}" "$file"
  fi
}


# Linux specific config {{{
if [ $(uname) == "Linux" ]; then
  export TERM=xterm-256color
  #shopt -s autocd
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias ls='ls -hp --color=always'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
  fi

  # Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

  #apt aliases
  alias apt='sudo apt-get'
  alias cs='sudo apt-cache search'
  alias pacman='sudo pacman'
  alias pac='sudo pacman'

  alias ls='ls -hp --color'
  alias ll='ls -l --color'
  alias la='ls -al --color'
  alias less='less -R'
fi
# }}}

# Specific project aliases and settings{{{
if [ -f ~/.bash_project_aliases ]; then
    . ~/.bash_project_aliases
fi
# }}}

# Synopsys Verdi {{{
if [ -f ~/verdi_custom.tcl ]; then
	export NOVAS_AUTO_SOURCE='~/verdi_custom.tcl'
fi
# }}}

# OSX specific config {{{
if [ $(uname) == "Darwin" ]; then
  export TERM=xterm-256color
  export HOMEBREW_NO_ANALYTICS=1

  #aliases {{{
  alias ls='ls -G'
  alias ll='ls -ltr'
  alias la='ls -al'
  alias less='less -R'
  alias fnd='open -a Finder'
  alias gitx='open -a GitX'
  alias grp='grep -RIi'
  alias dm='docker-machine'
  alias dc='docker-compose'
  alias dk='docker'
  alias dn='docker network'
  # }}}

  #open macvim
  # install macvim from homebrew if not already
  function gvim {
    if [ -e $1 ];
      then open -a MacVim $@;
      else touch $@ && open -a MacVim $@;
    fi
  }
  #open visual studio code
  function vsc {
    if [ -e $1 ];
      then open -a Visual\ Studio\ Code $@;
      else touch $@ && -a Visual\ Studio\ Code $@;
    fi
  }

  #homebrew git autocompletions {{{
  if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
    . `brew --prefix`/etc/bash_completion.d/git-completion.bash
  fi
  #}}}

  #Pipe2Eval folder for vim extension
  export PIP2EVAL_TMP_FILE_PATH=/tmp/shms

#  export WORKON_HOME="~/dev/envs"
#  export VIRTUALENV_USE_DISTRIBUTE=1
#  [[ -n "/usr/local/bin/virtualenvwrapper.sh" ]] && source virtualenvwrapper.sh
fi
# }}}

# MINGW32_NT-5.1 (winxp) specific config {{{
if [ $(uname) == "MINGW32_NT-5.1" ]; then
  alias ls='ls --color'
  alias ll='ls -l --color'
  alias la='ls -al --color'
  alias less='less -R'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
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

# {{{
# I've setup pip3 to require a python virtualenv, so running pip3 outside a virtualenv will fail.
# To update or install global python packages, use the shell command gpip, i.e.,
#    gpip install --upgrade pip setuptools wheel virtualenv
# }}}
gpip(){
   PIP_REQUIRE_VIRTUALENV="0" pip3 "$@"
}


# Liquid Prompt {{{
LP_ENABLE_SVN=0
LP_ENABLE_FOSSIL=0
LP_ENABLE_BZR=0
LP_ENABLE_BATT=0
LP_ENABLE_LOAD=0
LP_ENABLE_PROXY=0
LP_USER_ALWAYS=1
LP_HOSTNAME_ALWAYS=0
LP_ENABLE_RUNTIME=0
LP_ENABLE_TIME=0
LP_ENABLE_PERM=0
LP_ENABLE_TITLE=1
[[ $- = *i* ]] && source ~/.liquidprompt
#make sure the history is updated at every command
shopt -s histappend
#PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
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
    echo "Environment modules not found"
fi
# }}}


# Set my home bin in PATH, I like it first {{{
export PATH=$HOME/bin:$PATH
# }}}

