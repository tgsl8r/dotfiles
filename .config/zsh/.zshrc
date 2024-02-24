
# ░▀▀█░█▀▀░█░█░█▀▄░█▀▀░
# ░▄▀░░▀▀█░█▀█░█▀▄░█░░░
# ░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░


## Config files
source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/scripts.zsh"
source "${ZDOTDIR}/completion.zsh"
source "${ZDOTDIR}/prompt.zsh"


## Apps
# asdf
. "$HOME/.local/bin/asdf/asdf.sh"
# fzf
source "/usr/share/fzf/completion.zsh"
source "/usr/share/fzf/key-bindings.zsh"
# tmux
source "${ZDOTDIR}/plugins/tmux.zsh"


## Shell options
unsetopt beep
setopt autocd               # cd without cd command
setopt HIST_SAVE_NO_DUPS    # Do not add duplicate entries to history
setopt AUTO_PUSHD           # Push the current directory visited onto the stack
setopt PUSHD_IGNORE_DUPS    # Do not add duplicate directories to the stack
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd


## Completion system
zstyle :compinstall filename '/home/toby/.zshrc'
autoload -Uz compinit
compinit
