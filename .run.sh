#!/bin/bash
# https://github.com/emilyst/home

cd ~/

curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.8.1.tar.bz2
tar xf MacPorts-2.8.1.tar.bz2
cd MacPorts-2.8.1
./configure --prefix=$HOME/local --with-install-user=$USER --with-install-group=staff --without-startupitems
make && make install
export PATH=$HOME/local/bin:$PATH
port -N install autoconf automake bison bison-runtime boost176 brotli bzip2 cargo cmake cmake-bootstrap curl curl-ca-bundle docbook-xml docbook-xsl-nons expat gettext gettext-runtime gettext-tools-libs gmp gperf icu libarchive libb2 libcxx libedit libevent libffi libgit2 libiconv libidn2 libpsl libssh2 libtermkey libtextstyle libtool libunistring libutf8proc libuv libvterm libxml2 lua51 lua51-lpeg lua51-luarocks lua51-mpack luajit luarocks_select luv-luajit lz4 lzma lzo2 m4 msgpack msgpack-c msgpack-cpp ncurses neovim nghttp2 ninja nodejs19 npm9 openssl openssl3 p7zip pcre2 pkgconfig python3_select python311 python_select re2c readline rlwrap rust sqlite3 tmux tmux-pasteboard tree-sitter-cli unibilium wget xmlcatmgr xz zlib zstd

port -v selfupdate
port select --set luarocks lua51-luarocks
port -f activate python311
port select --set python python311
port select --set python3 python311

cd ~/Library/Fonts && {
wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf'
wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf'
wget 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'
cd -; }

wget 'https://iterm2.com/downloads/stable/iTerm2-3_4_19.zip'
unzip iTerm2-3_4_19.zip
mv iTerm2.app Applications/

echo "check Terminal, iTerm2 font settings"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

