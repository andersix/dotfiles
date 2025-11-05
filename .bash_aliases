alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'

# safer rm per-OS
if [[ "$(uname)" == "Darwin" ]]; then
#  alias rm='rm -i'
  command -v trash >/dev/null && alias rm='trash' || alias rm='rm -i'
else
  alias rm='rm -I --preserve-root'  # GNU coreutils
fi

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

alias rechoose_prompt='CHOOSE_PROMPT_ALREADY_SET=0; choose_prompt'

