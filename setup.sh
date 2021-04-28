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
mkdir -p ~/.vim
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

# Install latest nodejs
cd ~
curl --fail -LSs https://install-node.now.sh/latest -o install-node.sh
chmod +x ./install-node.sh
sudo ./install-node.sh
rm ./install-node.sh

mkdir -p ~/.config/coc/extensions
cp ~/etc/coc-package.json ~/.config/coc/extensions

# install vim plugins and then quit
vim +PluginInstall +qall

sudo apt install python3-pip
pip3 install powerline-shell
mkdir -p ~/.config/powerline-shell
cp ~/etc/powerline-shell-config.json ~/.config/powerline-shell/config.json

sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish
mkdir -p ~/.config/fish
cp ~/etc/config.fish ~/.config/fish/config.fish

sudo apt install silversearcher-ag

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh
chmod +x rustup.sh
./rustup.sh
rm ./rustup.sh

echo 'cd ~' >> ~/.bashrc
echo 'fish' >> ~/.bashrc

fish

