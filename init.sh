#!/bin/env sh
# init.sh
# Initialises home environment by installing packages

# Update and install base-devel and git
sudo pacman -Syu
sudo pacman -S --needed base-devel
sudo pacman -S git curl

# pikaur
cd /tmp
git clone https://aur.archlinux.org/pikaur.git
cd pikaur
makepkg -fsri

# Install progs and change shell
progs=(
	ttf-firacode-nerd
	zsh
	asdf-vm
	bat
	fzf
	ranger
	neovim
	fuzzel
	dunst
	kanshi
	swaylock
	brightnessctl
	wl-clipboard
	clipman
	qt6-wayland
	qutebrowser
	mpv
	zathura
	zathura-pdf-poppler
	bitwarden-cli
)
pikaur -Syu
pikaur -S ${progs[@]}
chsh -s /bin/zsh

# Install zap
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

