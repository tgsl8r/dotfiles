alias vim="nvim"

alias shactivate="eval '$(ssh-agent -s)' && ssh-add ~/.ssh/toby-archpad"

# todo.sh
alias t="todo.sh"
alias ta="todo.sh add"
alias tl="todo.sh list"
alias tla="todo.sh listall"
alias tdo="todo.sh do"
alias tpush="shactivate && git -C $HOME/.cache/repos/perfiles add todo/ && git -C $HOME/.cache/repos/perfiles commit -m 'TODO SAVE' && git -C $HOME/.cache/repos/perfiles push"

# Packages
# Fuzzy search Arch packages with pacman
alias pacs='pacman --color always -Sl | sed -e "s: :/:; /installed/d" | cut -f 1 -d " " | f#zf --multi --ansi --preview "pacman -Si {1}" | xargs -ro sudo pacman -S'
# Fuzzy search installed packages and uninstall
alias pacr="pacman --color always -Q | cut -f 1 -d ' ' | fzf --multi --ansi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

# Fuzzy search AUR packages with pikaur
# TODO: sed needs fixing for pikaur?
alias pars='pikaur --color always -Sl | sed -e "s: :/:; s/ unknown-version//; /installed/d" | fzf --multi --ansi --preview "pikaur -Si {1}" | xargs -ro pikaur -S'
