# dotfiles

* Arch linux
* Zsh
* Tmux
* Neovim
* Qtile
* ... et al

## Manual Installation

* Clone into bare repo
```sh 
git clone --bare <git-repo-url> $HOME/.dots
```

* Define the alias in current shell scope
```sh
alias dot='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
```

* Checkout required branch
```sh
dot checkout
```

* Hide untracked files
```sh
dot config --local status.showUntrackedFiles no
```
