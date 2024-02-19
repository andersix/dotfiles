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
alias free='free -m'

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
#
alias notes='vim ~/notes/notes-$(date +'%Y%m%d').md'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

alias yt-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' "

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

