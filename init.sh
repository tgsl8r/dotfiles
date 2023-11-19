#!/bin/env sh
# init.sh
# Initialises home environment by installing packages

# Update and install base-devel and git
sudo pacman -Syu
sudo pacman -S --needed base-devel
sudo pacman -S git

# Install paru
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru/
makepkg -si /tmp/paru

# Install zsh and change shell
paru -Syu
paru -S zsh ttf-firacode-nerd
chsh -s /bin/zsh

# Install zap
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

