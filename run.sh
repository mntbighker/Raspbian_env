#!/bin/sh

if ! [ -f $HOME/Linux_env/.tmux.conf ]; then
  echo -e "Please git clone into $HOME before running run.sh\n"
  exit
fi

if ! [ -f /usr/bin/nvim ]; then
  sudo dnf -y install neovim python39 luarocks zsh npm tmux
  exit
fi

cd $HOME
rm -rf .config
mv Linux_env/.config .
mv Linux_env/.tmux.conf .
mv Linux_env/install.sh .
echo -e "### Type exit after the oh-my-zsh install script finishes, to complete setup ###\n"
sh ./install.sh && rm ./install.sh
git clone "https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone "https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k"

rm ./.zshrc
mv Linux_env/.zshrc .

rm -rf Linux_env
