#! /bin/bash

# vim
# ----------------------------------------------------

# make dein
mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git \
    ~/.vim/dein/repos/github.com/Shougo/dein.vim

# for vim
ln -sf ~/.dotfiles/_vim/config  ~/.vim/config
ln -sf ~/.dotfiles/_vimrc       ~/.vimrc
cp -r ~/.dotfiles/_vim/doc      ~/.vim/
cp -r ~/.dotfiles/_vim/syntax   ~/.vim/

# zsh
# ----------------------------------------------------


# https://github.com/sorin-ionescu/prezto
zsh

# リポジトリをclone
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# # 既存の設定ファイルを退避(必要な場合)
# $ mkdir zsh_orig && mv zshmv .zlogin .zlogout .zprofile .zshenv .zshrc zsh_orig

# 設定ファイルを作成
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Shellのデフォルトに設定
chsh -s /bin/zsh

# for zsh config
mkdir ~/.zsh
ln -sf ~/.dotfiles/zsh/conf ~/.zsh/conf
echo -e "you should write following in your ~/.zrc

# for load zsh_conf
zsh_conf=~/.zsh/conf
source $zsh_conf/alias-init.bash    # aliasの設定
source $zsh_conf/function-init.bash # 関数の設定
source $zsh_conf/prompt-init.bash   # プロンプトの設定

# for z
. /usr/local/etc/profile.d/z.sh
"

