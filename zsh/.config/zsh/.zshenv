#
# .zshenv - Zsh environment file, loaded always.
#

export ZDOTDIR=~/.config/zsh

# XDG
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state
export XDG_RUNTIME_DIR=~/.xdg
export XDG_PROJECTS_DIR=~/projects

# Custom
export GNUPGHOME=$XDG_DATA_HOME/gnupg
export REPO_HOME=$XDG_CACHE_HOME/repos
export DOTFILES=$REPO_HOME/dotfiles

# Ensure path arrays do not contain duplicates.
typeset -gU fpath path cdpath

# Set the list of directories that cd searches.
cdpath=(
  $DOTFILES
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
export TERMINAL=/usr/bin/alacritty
export EDITOR=nvim
export VISUAL=code
export PAGER=less
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Regional settings
export LANG='en_GB.UTF-8'

# Misc
export KEYTIMEOUT=1

# Use `< file` to quickly view the contents of any file.
[[ -z "$READNULLCMD" ]] || READNULLCMD=$PAGER
