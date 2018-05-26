#!/bin/sh
path=$1
username=$GIT_CORP_NAME
password=$GIT_CORP_PASS
email=$GIT_CORP_MAIL

# debug
echo  path=${path} / pass=${password} / mail=${email} / user=${username}
git remote set-url origin  https://${username}:${password}@github.com/${username}/${path}.git

# cd ${path}
echo  "

[user]
	name = ${username}
	email = ${email}
" >> .gitconfig


# check 
git remote -v
git config -l