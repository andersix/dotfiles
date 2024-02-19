# my dotfiles
Welcome to my $HOME.
I use Linux (various flavors, mostly Arch, Debian, and RHEL variants), and MacOS, so my dotfiles are built to accomodate both systems as best as possible. I've mostly migrated to ZSH on my personal machines, however, I maintain BASH since that's where I started, and what my work RHEL systems use.

These dotfiles use an "aliased" command to git---``dotfiles``---to manage the, well, dotfiles.
If you want to start from scratch with none of my dotfiles, and just use the aliased command, modify and use the [First-time Setup](#First-time-Setup) section, and then add/commit your dotfiles with the ``dotfiles`` command.
If you're setting up a new machine, intending to use the same dotfiles, use the [Replication](#Replication) section.

(ymmv)

## First-time Setup
Use this if you just want to use this dotfiles methodology. Otherwise skip and use Replication section to get dotfiles to a new machine.
```sh
git init --bare $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles remote add origin/master git@github.com:andersix/dotfiles.git

Add "dotfiles" alias above to your shell aliases for future use.
```
## Replication
### Setup for replication
On the new machine you want dotfiles on, create a dotfiles alias to git:
```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
### Get dotfiles
Then grab the dotfiles from your repo for the new mahcine:
```sh
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/andersix/dotfiles.git dotfiles-tmp
rsync --recursive --verbose --exclude '.git' dotfiles-tmp/ $HOME/
rm --recursive dotfiles-tmp
```

### Git config needed for dotfiles
Then setup some git config for your dotfiles repo
```sh
dotfiles config status.showUntrackedFiles no
dotfiles remote set-url origin/master git@github.com:andersix/dotfiles.git
```

## Dependencies
Then add dependencies for the shell used on the new machine.
#### If in bash:
```sh
git clone https://github.com/liquidprompt/liquidprompt
```
#### If in zsh:
```sh
cd ~
mkdir .zsh.d
cd .zsh.d
git clone https://github.com/spaceship-prompt/spaceship-prompt.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
```

## Usage
Once you have this in place on a machine, use the ``dotfiles`` command just like you would git. It only operates on the files in your dotfile repo.
```sh
# get changes from upstream:
dotfiles pull
```
```sh
# add a new file to your dotfiles:
dotfiles status
dotfiles add .gitconfig
dotfiles commit -m 'Add gitconfig'
# fetch any changes from upstream and rebase
dotfiles fetch
dotfiles rebase
# fix any conflicts, then push
dotfiles push
```
