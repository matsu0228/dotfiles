#! /bin/bash

# make dein
mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git \
    ~/.vim/dein/repos/github.com/Shougo/dein.vim

# for vim
ln -sf ~/.dotfiles/_vim/config  ~/.vim/config
ln -sf ~/.dotfiles/_vimrc       ~/.vimrc
cp -r ~/.dotfiles/_vim/doc      ~/.vim/
cp -r ~/.dotfiles/_vim/syntax   ~/.vim/

# for pandoc
# https://github.com/matsu0228/tools/tree/master/pandoc
ln -s ~/.dotfiles/_pandoc ~/.pandoc

# for bash
mkdir ~/.bash
ln -sf ~/.dotfiles/_bash_conf/ ~/.bash/conf
ln -sf ~/.dotfiles/_inputrc     ~/.inputrc
echo -e "you should write following in your ~/.bashrc

# for load bash_conf
bash_conf=~/.bash/conf
. $bash_conf/alias-init.bash    # aliasの設定
. $bash_conf/function-init.bash # 関数の設定
. $bash_conf/prompt-init.bash   # プロンプトの設定

# for z
. /usr/local/etc/profile.d/z.sh
"

