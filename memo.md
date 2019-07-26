# packages memo

* `jq` is JSON parser. https://stedolan.github.io/jq/download/
* ghq, peco, hub: https://qiita.com/itkrt2y/items/0671d1f48e66f21241e2

* PHP-CS-Fixer: https://github.com/FriendsOfPHP/PHP-CS-Fixer
```
$ php-cs-fixer --version
PHP CS Fixer 2.12.1 Long Journey
```

## vim8 install on CentOS

```
# install via github
mkdir ~/src; cd ~/src
git clone https://github.com/vim/vim.git

cd ~/src/vim
./configure \
  --disable-selinux \
  --enable-cscope \
  --enable-fontset \
  --enable-gpm \
  --enable-multibyte \
  --enable-rubyinterp \
  --enable-xim

make

make install

# setup
which vim #=> /usr/local/bin/vim

sudo mv /usr/local/bin/vim /usr/local/bin/vim.7
sudo cp src/vim /usr/local/bin/vim.8
```
