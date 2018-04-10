:syntax on
set encoding=utf-8

" 一旦ファイルタイプ関連を無効化する
filetype off

" プラグインのセットアップ
" ----------------------------------------------------------------
if &compatible
  set nocompatible
endif
" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" TODO: toml: http://qiita.com/kawaz/items/ee725f6214f91337b42b
" dein settings {{{
" ----------------------------------------------------------------
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
let s:dein_dir = '~/.vim/dein/'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" プラグイン読み込み＆キャッシュ作成 
" let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/.dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(expand('~/.vim/dein'))
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/unite.vim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('scrooloose/nerdtree')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('tyru/caw.vim')
  call dein#add('ConradIrwin/vim-bracketed-paste')
  "snipets
  call dein#add('Shougo/neocomplete')
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')
  " front-end
  call dein#add('mattn/emmet-vim')
  call dein#add('majutsushi/tagbar')
  call dein#add('othree/yajs')
  call dein#add('hail2u/vim-css3-syntax')
  " call dein#add('mtscout6/syntastic-local-eslint')
  " markdown
  call dein#add('plasticboy/vim-markdown')
  call dein#add('glidenote/memolist.vim')
  " for python
  call dein#add('davidhalter/jedi-vim')
  call dein#add('scrooloose/syntastic')
  call dein#add('Vimjas/vim-python-pep8-indent')
  " call dein#add('andviro/flake8-vim')
  " go
  call dein#add('fatih/vim-go')
  " for window
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#add('kana/vim-submode')
  call dein#add('Shougo/vimproc', {
     \ 'build': {
     \     'mac' : 'make -f make_mac.mak',
     \     'linux' : 'make',
     \     'unix' : 'gmake',
     \    },
     \ })
  call dein#end()
  call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}

"Airline -----------
"set laststatus=2
set showtabline=2 " 常にタブラインを表示
"set t_Co=256 " この設定がないと色が正しく表示されない
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme='papercolor' "落ち着いた色調が好き
let g:airline_powerline_fonts = 1

" load config
runtime! config/init/*.vim
" go
augroup PrevimSetti=ngs
  autocmd!
  autocmd BufNewFile,BufRead *.{go} set filetype=go
augroup END
" markdown
augroup PrevimSetti=ngs
  autocmd!
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END
let g:memolist_path = "~/Documents/2017"
let g:memolist_memo_suffix = "md"
let g:memolist_template_dir_path = "~/.vim/config/memolist"
let g:memolist_memo_date = "%y%m%d"
" Emmet ( <LEAD> , )
let g:user_emmet_leader_key='<c-e>'
" indent
set tabstop=2 shiftwidth=2 expandtab
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'Normal']
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

" vim-flake8
" autocmd BufWritePost *.py call Flake8()

" filetypeの自動検出(最後の方に書いた方がいいらしい)
"----------------------------------------------
filetype on

" vimでmacのトラックパッドスクロールを有効にする
"----------------------------------------------
set mouse=niv
set clipboard=unnamed,autoselect
let g:NERDTreeDirArrows=0

" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>
" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

" indent
filetype plugin indent on
