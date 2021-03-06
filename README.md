# dotfiles
My dotfiles. This is my $HOME, and I'm constantly redecorating... (ymmv)

## First-time Setup
```sh
git init --bare $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles remote add origin git@github.com:andersix/dotfiles.git

Add "dotfiles" alias above to your shell aliases for future use.
```
or;
## Setup for replication
```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles remote add origin git@github.com:andersix/dotfiles.git

Add "dotfiles" alias above to your shell aliases for future use.
```

## Replication
```sh
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/andersix/dotfiles.git dotfiles-tmp
rsync --recursive --verbose --exclude '.git' dotfiles-tmp/ $HOME/
rm --recursive dotfiles-tmp
```

## Configuration
```sh
dotfiles config status.showUntrackedFiles no
dotfiles remote set-url origin git@github.com:andersix/dotfiles.git
```

## Usage
```sh
dotfiles status
dotfiles add .gitconfig
dotfiles commit -m 'Add gitconfig'
dotfiles push

dotfiles pull

# etc...
```
