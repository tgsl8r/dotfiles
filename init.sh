git clone --bare git@github.com:tgsl8r/dotfiles.git $HOME/.dots
function config {
   /usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME $@
}
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    mkdir -p .config-backup
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

chsh -s $(which zsh)

