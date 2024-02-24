
# ░█▀▀░█▀▀░█▀▄░▀█▀░█▀█░▀█▀░█▀▀░
# ░▀▀█░█░░░█▀▄░░█░░█▀▀░░█░░▀▀█░
# ░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░░░░▀░░▀▀▀░


# man - Colourized man pages
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;40;35m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;33m") \
        man "$@"
}

# trun - Run a program from the terminal and disown process
trun() {
    "$@" &> /dev/null & disown
}

# mkcd - Create directory and go there
mkcd() {
    local dir="$*";
    local mkdir -p "$dir" && cd "$dir";
}

# bcal - Echo math to bc
bcal() {
    bc -l <<< "$@"
}

# passg - Generate a random password
pass() {
    local size=${1:-20}
    cat /dev/random | tr -dc '[:graph:]' | head -c$size
}

# cheat - Get a cheat sheet
cheat() {
    curl cheat.sh/$1
}

# cht - TODO: Is this better than above?
cht() {
    curl -s "cheat.sh/$(echo -n "$*" | jq -sRr @uri)"
}

# ddg - Lookup with duckduckgo in lynx
ddg() {
    lynx -vikeys -accept_all_cookies "https://lite.duckduckgo.com/lite/?q=$@"
}

# wiki - Lookup with wikipedia in lynx
wikipedia() {
    lynx -vikeys -accept_all_cookies "https://en.wikipedia.org/wiki?search=$@"
}

# bak - Create a backup copy of a file or files
bak() {
    for file in "$@"; do
        cp "$file" "$file".bak
    done
}

# dbak - Backup disc or image to disc
dbak () {
    if [ ! -z $1 ] && [ ! -z $2 ]; then
        if [ ! -z $3 ]; then
            BS=$3
        else
            BS="512k"
        fi

        dialog --defaultno --title "Are you sure?" --yesno "This will copy $1 to $2 (bitsize: $BS). Everything on $2 will be deleted.\n\n
        Are you sure?"  15 60 || exit

        (sudo pv -n $1 | sudo dd of=$2 bs=$BS conv=notrunc,noerror) 2>&1 | dialog --gauge "Backup from disk $1 to disk $2... please wait" 10 70 0
    else
        echo "You need to provide an input disk as first argument (i.e /dev/sda) and an output disk as second argument (i.e /dev/sdb)"
    fi
}

# ex - Extract files
ex() {
    for file in "$@"
    do
        if [ -f $file ]; then
            _ex $file
        else
            echo "'$file' is not a valid file"
        fi
    done
}

# mkex - Extract files in their own directories
mkex() {
    for file in "$@"
    do
        if [ -f $file ]; then
            local filename=${file%\.*}
            mkdir -p $filename
            cp $file $filename
            cd $filename
            _ex $file
            rm -f $file
            cd -
        else
            echo "'$1' is not a valid file"
        fi
    done
}

# Internal function to extract any file
_ex() {
    case $1 in
        *.tar.bz2)  tar xjf $1      ;;
        *.tar.gz)   tar xzf $1      ;;
        *.bz2)      bunzip2 $1      ;;
        *.gz)       gunzip $1       ;;
        *.tar)      tar xf $1       ;;
        *.tbz2)     tar xjf $1      ;;
        *.tgz)      tar xzf $1      ;;
        *.zip)      unzip $1        ;;
        *.7z)       7z x $1         ;; # require p7zip
        *.rar)      7z x $1         ;; # require p7zip
        *.iso)      7z x $1         ;; # require p7zip
        *.Z)        uncompress $1   ;;
        *)          echo "'$1' cannot be extracted" ;;
    esac
}

# mnt - Mount external disc
mnt() {
    local FILE="/mnt/external"
    if [ ! -z $2 ]; then
        FILE=$2
    fi

    if [ ! -z $1 ]; then
        sudo mount "$1" "$FILE" -o rw
        echo "Device in read/write mounted in $FILE"
    fi

    if [ $# = 0 ]; then
        echo "You need to provide the device (/dev/sd*) - use lsblk"
    fi
}

# umnt - Unmount specified or all external discs
umnt() {
    local DIRECTORY="/mnt"
    if [ ! -z $1 ]; then
        DIRECTORY=$1
    fi
    MOUNTED=$(grep $DIRECTORY /proc/mounts | cut -f2 -d" " | sort -r)
    cd "/mnt"
    sudo umount $MOUNTED
    echo "$MOUNTED unmounted"
}

# ports - View open ports with fzf
ports() {
    sudo netstat -tulpn | grep LISTEN | fzf;
}

# fdr - Browse the zsh dir stack with fzf
fdr() {
    # Only work with alias d defined as:
    
    # alias d='dirs -v'
    # for index ({1..9}) alias "$index"="cd +${index}"; unset index

    d | fzf --height="20%" | cut -f 1 | source /dev/stdin
}

# fman - Search through all man pages with fzf
fman() {
    man -k . | fzf -q "$1" --prompt='man> '  --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

# fgl - Browse git log with fzf
fgl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fgb - Checkout git branch with fzf
fgb() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# ftmux - Browse tmux sessions with fzf
ftmux() {
    if [[ ! -n $TMUX ]]; then
        # get the IDs
        ID="`tmux list-sessions`"
        if [[ -z "$ID" ]]; then
            tmux new-session
        fi
        create_new_session="Create New Session"
        ID="$ID\n${create_new_session}:"
        ID="`echo $ID | fzf | cut -d: -f1`"
        if [[ "$ID" = "${create_new_session}" ]]; then
            tmux new-session
        elif [[ -n "$ID" ]]; then
            printf '\033]777;tabbedx;set_tab_name;%s\007' "$ID"
            tmux attach-session -t "$ID"
        else
            :  # Start terminal normally
        fi
    fi
}

# fpdf - Browse pdfs with fzf and open with Zathura
fpdf() {
    result=$(find -type f -name '*.pdf' | fzf --bind "ctrl-r:reload(find -type f -name '*.pdf')" --preview "pdftotext {} - | less")
    [ -n "$result" ] && nohup zathura "$result" &> /dev/null & disown
}

# fepub - browse epubs with fzf and Open with Zathura
fepub() {
    result=$(find -type f -name '*.epub' | fzf --bind "ctrl-r:reload(find -type f -name '*.epub')")
    [ -n "$result" ] && nohup zathura "$result" &> /dev/null & disown
}


## Package browsing (TODO: Pick these or aliases)
# fpac - Browse and install packages with fzf
fpac() {
    pacman -Slq | fzf --multi --reverse --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}

# fpar - Browse and install aur packages with fzf
fpar() {
    paru -Slq | fzf --multi --reverse --preview 'paru -Si {1}' | xargs -ro paru -S
}
