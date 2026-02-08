
# ░▀▀█░█▀▀░█░█░█▀▀░█▀█░█░█░
# ░▄▀░░▀▀█░█▀█░█▀▀░█░█░▀▄▀░
# ░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░░▀░░


export ZDOTDIR=~/.config/zsh

# Apps
export ASDF_DIR=~/.local/bin/asdf
export FZF_DEFAULT_OPTS=""
export FZF_DEFAULT_COMMAND="fd --type f"

# XDG
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state
export XDG_PROJECTS_DIR=~/projects

# Custom
export GNUPGHOME=$XDG_DATA_HOME/gnupg
export GPG_TTY=$(tty)
export REPO_HOME=$XDG_CACHE_HOME/repos
export DOTFILES=$REPO_HOME/dotfiles

# History
export HISTFILE="$ZDOTDIR/.history"
export HISTSIZE=10000
export SAVEHIST=10000

# Ensure path arrays do not contain duplicates.
typeset -gU fpath path cdpath

# Set the list of directories that cd searches.
cdpath=(
  $REPO_HOME
  $XDG_PROJECTS_DIR(N/)
  $XDG_PROJECTS_DIR/tslater(N/) 
  $XDG_PROJECTS_DIR/obc(N/)
  $cdpath
)

# Set the list of directories that Zsh searches for programs.
path=(
  # core
  $HOME/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  # apps
  $HOME/.gem/ruby/*/bin(N)
  # path
  $path
)

# Apps
export TERMINAL=alacritty
export EDITOR=nvim
export VISUAL=nvim
export PAGER=bat

# Regional settings
export LANG='en_GB.UTF-8'

# Misc
export KEYTIMEOUT=1

# Use `< file` to quickly view the contents of any file.
[[ -z "$READNULLCMD" ]] || READNULLCMD=$PAGER
