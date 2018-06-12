#!/bin/sh
path=$1
username=$GIT_CORP_NAME
corpname=$GIT_CORP_CORPNAME
password=$GIT_CORP_PASS
email=$GIT_CORP_MAIL

# debug
echo  path=${path} / pass=${password} / mail=${email} / corp=${corpname} / user=${username}
git remote set-url origin  https://${username}:${password}@github.com/${corpname}/${path}.git

# cd ${path}
echo  "

git config --local user.name ${username}
git config --local user.email ${email}
"
# [user]
# 	name = ${username}
# 	email = ${email}
# " >> .gitconfig


# check 
git remote -v
git config -l