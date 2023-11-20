#!/bin/env sh
# init.sh
# Initialises home environment by installing packages

# Update and install base-devel and git
sudo pacman -Syu
sudo pacman -S --needed base-devel
sudo pacman -S git curl

# pikaur
git clone https://aur.archlinux.org/pikaur.git
cd pikaur
makepkg -fsri

# Install zsh and change shell
pikaur -Syu
pikaur -S zsh ttf-firacode-nerd
chsh -s /bin/zsh

# Install zap
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

