alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
# do not delete / or prompt if deleting more than 3 files at a time #
# Macos does not support this: alias rm='rm -I --preserve-root'
alias rm='rm -i'
# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias genpass="openssl rand -base64 20"

alias nowdate='date +"%Y-%m-%d"'
alias ping="ping -c 5 "
alias ports='netstat -tulanp'
alias sha="shasum -a 256 "
alias untar="tar xvf "
#
alias vi='vim'
alias vimo='vim -O '
alias dpaste="curl -F 'content=<-' https://dpaste.de/api/"
#alias vncstart='vncserver :12 -geometry 3320x965 -depth 16  -AlwaysShared'
#alias vncstop='vncserver -kill :12'
#
alias svnstat='svn stat | grep -E "^(M|A)"'
alias svnstat="svn stat ${PROJWS} | grep -E \"^(M|A)\""
#
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
