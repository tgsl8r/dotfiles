# dotfiles

* Arch linux
* Zsh
* Tmux
* Neovim
* Qtile
* ... et al


## Lazy Installation
```sh
curl -LJO https://raw.githubusercontent.com/tgsl8r/dotfiles/bare/init.sh | /bin/bash
```

## Manual Installation

* Install requirements
```sh
sudo pacman -Syu
sudo pacman -S zsh less tmux fzf fd ripgrep eza bat lynx net-tools unzip \ 
               wlroots pywlroots python-pywayland python-xkbcommon qtile \
               ttf-firacode-nerd qt6-wayland wl-clipboard \
               alacritty qutebrowser zathura imv mpd
```

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

* Change shell to zsh if necessary (then relog)
```sh
chsh -s $(which zsh)
```
