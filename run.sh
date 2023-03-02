#!/bin/sh

sudo dnf -y install neovim python39 luarocks zsh

tmux set-option -g default-shell /usr/bin/zsh

cd ~/
# sh ./install.sh
rm install.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

mv .zshrc.pre-oh-my-zsh .zshrc
# mv bigpath.zsh-theme .oh-my-zsh/themes/
