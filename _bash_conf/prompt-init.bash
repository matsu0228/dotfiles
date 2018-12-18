# $bash_conf/prompt-init.bash   # プロンプトの設定
# ------------------------------------------

# define color
# ------------------------------------
export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[1;30m'
#
export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH
export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'
export LC_MESSAGES='ja_JP.UTF-8'
export LC_CTYPE=C
export LESSCHARSET=utf-8
export DISPLAY=:0.0
export TERM=xterm-color

# define HISTRY
#---------------------------------------
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups
export HISTSIZE HISTFILESIZE HISTCONTROL
# ヒストリサーチ機能
bind '"\e[A": history-search-backward'
bind '"\C-p": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\C-n": history-search-forward'


# 大文字小文字を区別しない
#  @ ~/.inputrc:  set completion-ignore-case on
# --------------------------------------
shopt -s nocaseglob

# PATH
# ------------------------------------
PATH="$PATH":/usr/local/src/tree-tagger/cmd
PATH="$PATH":/usr/local/src/tree-tagger/bin
export PATH=$PATH

# less editor
export VISUAL='vim'
