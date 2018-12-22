#! /bin/bash

# vim
# ------------------------------------------------------

# make dein
mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git \
    ~/.vim/dein/repos/github.com/Shougo/dein.vim

# for vim
ln -sf ~/.dotfiles/_vim/config  ~/.vim/config
ln -sf ~/.dotfiles/_vim/_vimrc       ~/.vimrc
cp -r ~/.dotfiles/_vim/doc      ~/.vim/
cp -r ~/.dotfiles/_vim/syntax   ~/.vim/



# bash
# ------------------------------------------------------

mkdir ~/.bash
ln -sf ~/.dotfiles/bash/conf/       ~/.bash/conf
ln -sf ~/.dotfiles/bash/_inputrc    ~/.inputrc
echo -e "you should write following in your ~/.bashrc

# for load bash_conf
bash_conf=~/.bash/conf
. $bash_conf/alias-init.bash    # aliasの設定
. $bash_conf/function-init.bash # 関数の設定
. $bash_conf/prompt-init.bash   # プロンプトの設定
"
# # for z
# . /usr/local/etc/profile.d/z.sh

# zsh
# ------------------------------------------------------

mkdir ~/.zsh
ln -sf ~/.dotfiles/zsh/conf/     ~/.zsh/conf
ln -sf ~/.dotfiles/zsh/zsh_init     ~/.zsh/.zsh_init
echo -e "you should write following in your ~/.zrc

[ -f ~/.zsh/.zsh_init ] && source ~/.zsh/.zsh_init
[ -f ~/.zsh/local/zsh_local ] && source ~/.zsh/local/zsh_local
"
