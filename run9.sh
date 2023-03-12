#!/bin/sh

if ! [ -f $HOME/Linux_env/.tmux.conf ]; then
  echo -e "Please git clone into $HOME before running run.sh\n"
  exit
fi

if ! [ -f /usr/bin/nvim ]; then
  sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
  sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
  sudo dnf -y group install "Development Tools"
  sudo dnf -y install neovim python39 ruby ruby-devel rubygems luarocks zsh npm nodejs cargo cmake tmux wget
fi

cd $HOME
rm -rf .config
mv Linux_env/.config .
mv Linux_env/.tmux.conf .
mv Linux_env/install.sh .
gem install colorls
cargo install tree-sitter-cli rust_fzf
echo -e "### Type exit after the oh-my-zsh install script finishes, to complete setup ###\n"
sh ./install.sh && rm ./install.sh
git clone "https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone "https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k"

rm ./.zshrc
mv Linux_env/.zshrc .

rm -rf Linux_env
