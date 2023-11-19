# .zshenv
# Sets zdotdir and sources .zshenv from it

export ZDOTDIR=~/.config/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
