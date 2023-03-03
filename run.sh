#!/bin/sh

if [ $USER = "root" ]; then
  sudo dnf -y install neovim python39 luarocks zsh npm
  exit
fi

cd ~/
rm -rf .config
mv Linux_env/.config .
mv Linux_env/.tmux.conf .
mv Linux_env/install.sh .
sh ./install.sh
rm ./install.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

rm .zshrc.pre-oh-my-zsh
rm ./.zshrc
mv Linux_env/.zshrc .
# mv bigpath.zsh-theme .oh-my-zsh/themes/

rm -rf Linux_env
