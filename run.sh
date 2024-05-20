#!/bin/sh

#!/bin/bash

## git clone http://github.com/mntbighker/Raspbian_env

if [ $USER = "root" ]; then
  echo "Don't run as root to execute this script."
  exit
fi

export $CLONE_DIR='Raspbian_env'

sudo sed -i -e 's/^CONF_SWAPSIZE=100/CONF_SWAPSIZE=900/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo systemctl restart dphys-swapfile
sudo sed -i -e 's/^arm_boost=1/# arm_boost=1/' /boot/firmware/config.txt

sudo apt -y install luarocks zsh npm tmux wget cmake ninja-build gettext # for neovim
rm -rf /var/lib/apt/lists/*

## build neovim
cd $HOME
git clone --branch v0.9.0 https://github.com/neovim/neovim
cd /neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

## Install oh_my_zsh
cd $HOME
rm -rf .config
mv $CLONE_DIR/.config .
mv $CLONE_DIR/.tmux.conf .
mv $CLONE_DIR/install.sh .
echo -e "### Type exit after the oh-my-zsh install script finishes, to complete setup ###\n"
sh ./install.sh && rm ./install.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

rm ./.zshrc
mv $CLONE_DIR/.zshrc .

rm -rf $CLONE_DIR
