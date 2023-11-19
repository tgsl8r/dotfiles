alias vim="nvim"

# Fuzzy search Arch packages with pacman
alias pacs='pacman --color always -Sl | sed -e "s: :/:; /installed/d" | cut -f 1 -d " " | f#zf --multi --ansi --preview "pacman -Si {1}" | xargs -ro sudo pacman -S'
# Fuzzy search AUR packages with paru
alias pars='paru --color always -Sl | sed -e "s: :/:; s/ unknown-version//; /installed/d" | fzf --multi --ansi --preview "paru -Si {1}" | xargs -ro paru -S'
# Fuzzy search installed packages and uninstall
alias pacr="pacman --color always -Q | cut -f 1 -d ' ' | fzf --multi --ansi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

