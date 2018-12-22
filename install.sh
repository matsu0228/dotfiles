#! /bin/bash

# configure
# ------------------------------------------------------
if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
  OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi
echo "your OS is $OS. INSTALL --------------------"


# zsh
# ------------------------------------------------------
if ! type zsh >/dev/null 2>&1; then
  echo -e "
  zshをインストールしてください
  "
fi


if ! type peco >/dev/null 2>&1; then
  echo -e "
  pecoをインストールしてください
  install here: https://github.com/peco/peco/releases
  "
fi

echo -e "intro -------------
シェル一覧を表示)
cat /etc/shells

ログインシェル変更)
chsh -s /bin/zsh
"
