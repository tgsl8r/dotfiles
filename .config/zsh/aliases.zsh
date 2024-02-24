
# ░█▀█░█░░░▀█▀░█▀█░█▀▀░█▀▀░█▀▀░
# ░█▀█░█░░░░█░░█▀█░▀▀█░█▀▀░▀▀█░
# ░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░


## User
alias shactivate="eval '$(ssh-agent -s)' && ssh-add ~/.ssh/tobytab"

# Dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'

# Dir stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

## Applications
alias l="eza -lah"
alias cat="bat --paging=never"
alias less="bat"
alias vim="nvim"

# todo.sh
alias t="todo.sh"
alias ta="todo.sh add"
alias tl="todo.sh list"
alias tla="todo.sh listall"
alias tdo="todo.sh do"
alias tpush="shactivate && git -C $HOME/.cache/repos/perfiles add todo/ && git -C $HOME/.cache/repos/perfiles commit -m 'TODO SAVE' && git -C $HOME/.cache/repos/perfiles push"


## Package management
# Fuzzy search Arch packages and install
alias pacs='pacman --color always -Sl | sed -e "s: :/:; /installed/d" | cut -f 1 -d " " | f#zf --multi --ansi --preview "pacman -Si {1}" | xargs -ro sudo pacman -S'

# Fuzzy search installed packages and uninstall
alias pacr="pacman --color always -Q | cut -f 1 -d ' ' | fzf --multi --ansi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

# Fuzzy search AUR packages with paru
alias pars='paru --color always -Sl | sed -e "s: :/:; s/ unknown-version//; /installed/d" | fzf --multi --ansi --preview "paru -Si {1}" | xargs -ro paru -S'
