## Mac specific settings

# Brew
source "${ZDOTDIR}/plugins/brew.zsh"

# fzf
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source "/opt/homebrew/opt/fzf/shell/completion.zsh"
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# java development kit
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
