#!/usr/bin/fish
set XDG_CONFIG_HOME $HOME/.config

set DOTFILE $HOME/.config/dotfile
set KB_DOTFILE $HOME/.config/kb_dotfile

ln -sf $DOTFILE/starship.toml  $XDG_CONFIG_HOMEg/starship.toml

mkdir -p $DOTFILE/fish
rm $XDG_CONFIG_HOME/fish/config.fish
ln -sf $DOTFILE/fish/config.fish $XDG_CONFIG_HOME/fish/config.fish
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

fisher install jethrokuan/fzf
fisher install jhillyerd/plugin-git
fisher install danhper/fish-ssh-agent
fisher install oh-my-fish/plugin-aws
