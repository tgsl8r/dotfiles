
# ░▀▀█░█▀▀░█░█░█▀▄░█▀▀░
# ░▄▀░░▀▀█░█▀█░█▀▄░█░░░
# ░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░


## Config files
source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/scripts.zsh"
source "${ZDOTDIR}/completion.zsh"
source "${ZDOTDIR}/prompt.zsh"


# Mac/linux specific settings
if [[ $(uname) == "Darwin" ]]; then
    source "${ZDOTDIR}/os/mac.zsh"
else
    source "${ZDOTDIR}/os/linux.zsh"
fi


## Apps
# asdf
. "$HOME/.local/bin/asdf/asdf.sh"
# git
source "${ZDOTDIR}/plugins/git.zsh"
# tmux
source "${ZDOTDIR}/plugins/tmux.zsh"
# cargo
. "$HOME/.cargo/env"
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


## Shell options
unsetopt beep
setopt autocd               # cd without cd command
setopt HIST_SAVE_NO_DUPS    # Do not add duplicate entries to history
setopt AUTO_PUSHD           # Push the current directory visited onto the stack
setopt PUSHD_IGNORE_DUPS    # Do not add duplicate directories to the stack
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd
plugins=(
  vi-mode
  )
VI_MODE_SET_CURSOR=true

# keybinds
bindkey -v '^?' backward-delete-char
bindkey -M viins "^A" beginning-of-line
bindkey -M vicmd "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
bindkey -M vicmd "^E" end-of-line

## Completion system
zstyle :compinstall filename "${ZDOTDIR}/.zshrc"
autoload -Uz compinit
compinit
