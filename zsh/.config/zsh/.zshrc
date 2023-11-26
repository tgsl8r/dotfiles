# Source shell utils
# Powerlevel10k and config (.p10k.zsh)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
# asdf
. /opt/asdf-vm/asdf.sh

# Shell options
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
setopt autocd
unsetopt beep
bindkey -e

# Zap plugin manager remote plugins
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-completions"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
# local plugins
# plug "$HOME/.config/zsh/plugins/git"
# plug $HOME/.config/zsh/plugins/asdf.plugin.zsh
# local files
plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/exports.zsh"

# Load and initialise completion system
zstyle :compinstall filename '/home/toby/.zshrc'
autoload -Uz compinit
compinit
