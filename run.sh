#!/bin/sh

sudo dnf -y install neovim python39 luarocks zsh

tmux set-option -g default-shell /bin/zsh

cd ~/
sh ./install.sh
rm install.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

mv .zshrc.pre-oh-my-zsh .zshrc
