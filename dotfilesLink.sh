#! /bin/bash

# make dein
mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git \
    ~/.vim/dein/repos/github.com/Shougo/dein.vim

# for vim
ln -sf ~/.dotfiles/_vim/config  ~/.vim/config
ln -sf ~/.dotfiles/_vimrc       ~/.vimrc
cp -r ~/.dotfiles/_vim/doc      ~/.vim/
cp -r ~/.dotfiles/_vim/syntax      ~/.vim/
ln -sf ~/.dotfiles/_inputrc     ~/.inputrc

