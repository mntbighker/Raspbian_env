#!/bin/bash

## git clone http://github.com/mntbighker/Raspbian_env

if [ $USER = "root" ]; then
  echo "Don't run as root to execute this script."
  exit
fi

export CLONE_DIR='Raspbian_env'

sudo sed -i -e 's/^CONF_SWAPSIZE=100/CONF_SWAPSIZE=900/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo systemctl restart dphys-swapfile
sudo sed -i -e 's/^arm_boost=1/# arm_boost=1/' /boot/firmware/config.txt

sudo apt -y install luarocks zsh npm wget cmake ninja-build gettext # for neovim
sudo rm -rf /var/lib/apt/lists/*

## build neovim
cd $HOME
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install
cd $HOME
rm -rf neovim

## Install oh_my_zsh
sudo apt -y install tmux
rm -rf .config
mv $CLONE_DIR/.config .
mv $CLONE_DIR/.tmux.conf .
echo -e "### Type exit after the oh-my-zsh install script finishes, to complete setup ###\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

rm ./.zshrc
mv $CLONE_DIR/.zshrc .
mv $CLONE_DIR/.bashrc .

rm -rf $CLONE_DIR

wget https://github.com/junegunn/fzf/releases/download/0.53.0/fzf-0.53.0-linux_arm64.tar.gz
tar xzf fzf-0.53.0-linux_arm64.tar.gz
mv fzf ~/.local/bin/
rm fzf-0.53.0-linux_arm64.tar.gz

cat << 'EOF' >> ~/.zshrc

# ---- FZF -----
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

EOF

wget https://github.com/sharkdp/fd/releases/download/v10.1.0/fd-v10.1.0-arm-unknown-linux-musleabihf.tar.gz
tar xzf fd-v10.1.0-arm-unknown-linux-musleabihf.tar.gz
mv fd-v10.1.0-arm-unknown-linux-musleabihf/fd ~/.local/bin/
rm -rf fd-*

cat << 'EOF' >> ~/.zshrc

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

EOF

cat << 'EOF' >> ~/.zshrc

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

EOF

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
# https://github.com/nanotee/zoxide
cat << 'EOF' >> ~/.zshrc

eval "$(zoxide init zsh --cmd cd)"
EOF
