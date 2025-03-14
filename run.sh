#!/bin/bash

## git clone http://github.com/mntbighker/Raspbian_env

if [ $USER = "root" ]; then
  echo "Don't run as root to execute this script."
  exit
fi

if ! [ -f /usr/bin/zsh ]; then
  sudo dnf -y install zsh
  exit
fi

if ! [ `env | grep "SHELL" | grep zsh` ]; then
  sudo usermod -s /usr/bin/zsh $USER
  echo -e "Log out to swict to zsh\n"
  exit
fi

export CLONE_DIR='Raspbian_env'

sudo sed -i -e 's/^CONF_SWAPSIZE=100/CONF_SWAPSIZE=900/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo systemctl restart dphys-swapfile
sudo sed -i -e 's/^arm_boost=1/# arm_boost=1/' /boot/firmware/config.txt

sudo apt -y install zsh npm lua lua-devel wget cmake ninja-build gettext glances btop zsh-theme-powerlevel9k # for neovim
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install
cd ../
rm -rf luarocks*
exit
sudo rm -rf /var/lib/apt/lists/*

wget -c https://github.com/eza-community/eza/releases/latest/download/eza_aarch64-unknown-linux-gnu.tar.gz -O - | tar xz
mkdir -p $HOME/.local/bin
mv eza ~/.local/bin/
rm -f ~/.zcompdump*; compinit
git clone https://github.com/eza-community/eza.git $HOME/.local/eza/
exit
## build neovim
cd $HOME
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install
cd $HOME
rm -rf neovim
exit
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

rm -rf $CLONE_DIR

wget https://github.com/junegunn/fzf/releases/download/v0.60.3/fzf-0.60.3-linux_arm64.tar.gz
tar xzf fzf-0.60.3-linux_arm64.tar.gz
mv fzf ~/.local/bin/
rm fzf-0.60.3-linux_arm64.tar.gz

cat << 'EOF' >> ~/.zshrc

# ---- FZF -----
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

EOF

wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-arm-unknown-linux-musleabihf.tar.gz
tar xzf fd-v10.2.0-arm-unknown-linux-musleabihf.tar.gz
mv fd-v10.2.0-arm-unknown-linux-musleabihf/fd ~/.local/bin/
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

cat << 'EOF' >> $HOME/.zshrc
alias ls='eza'
EOF

wget https://github.com/jesseduffield/lazygit/releases/download/v0.48.0/lazygit_0.48.0_Linux_arm64.tar.gz
cd $HOME/.local/bin
tar xzf $HOME/lazygit_0.48.0_Linux_arm64.tar.gz
cd $HOME; rm lazygit_0.48.0_Linux_arm64.tar.gz

# https://github.com/sxyazi/yazi
wget https://github.com/sxyazi/yazi/releases/latest/download/yazi-aarch64-unknown-linux-gnu.zip
unzip yazi-aarch64-unknown-linux-gnu.zip
mv yazi-aarch64-unknown-linux-gnu/ya* ~/.local/bin
mkdir ~/.local/yazi
mv yazi-aarch64-unknown-linux-gnu/completions ~/.local/yazi
rm -rf yazi-aarch64-unknown-linux-gnu*

cat << 'EOF' >> ~/.zshrc

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
export FPATH="$HOME/.local/yazi/completions:$FPATH"
autoload -U compinit && compinit
EOF
