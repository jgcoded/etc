#!/usr/bin/env bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

cd ~

sudo apt-get update
sudo apt install git make clang libpython3-dev
git clone https://github.com/vim/vim.git --depth 1
cd vim/src
sed -i 's/#CONF_OPT_PYTHON3 = --enable-python3interp$/CONF_OPT_PYTHON3 = --enable-python3interp/' Makefile
make
sudo make install
which vim
cd ~

mkdir ~/.vim
cp ~/etc/vimrc ~/.vimrc
cp ~/etc/custom.vimrc ~/.vim/custom.vimrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1

git clone https://github.com/universal-ctags/ctags.git --depth 1
cd ctags
sudo apt install autoconf pkg-config
./autogen.sh
./configure
make
sudo make install
cd ~

# Install latest nodejs
curl --fail -LSs https://install-node.now.sh/latest | sh

mkdir -p ~/.config/coc/extensions
cp ~/etc/coc-package.json ~/.config/coc/extensions
cd ~

# install vim plugins and then quit
vim -c 'PluginInstall | q'

sudo apt install python3-pip
pip3 install powerline-shell
mkdir ~/.config/powerline-shell
cp ~/etc/powerline-shell-config.json ~/.config/powerline-shell/config.json

sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish
mkdir ~/.config/fish
cp ~/etc/config.fish ~/.config/fish/config.fish

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cat 'cd ~' >> ~/.bashrc
cat 'fish' >> ~/.bashrc

