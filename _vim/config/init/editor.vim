" 各種オプションの設定
" ---------------------------------------------------
" 行番号を表示する
set number
"新しい行のインデントを現在行と同じにする
set autoindent
"クリップボードをMacと連携する
set clipboard+=unnamed,autoselect
"タブの代わりに空白文字を指定する
set expandtab
"タブ幅の設定
set tabstop=2
"新しい行を作った時に高度な自動インデントを行う
set smarttab
"オートインデント時にインデントする文字数
set shiftwidth=2
"http://blogs.yahoo.co.jp/momongamemonga/39861534.html
set backspace=indent,eol,start
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
" 小文字のみで検索したときに大文字小文字を無視する
set smartcase
" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch
" 構文毎に文字色を変化させる
syntax on
"検索結果をハイライトする
set hlsearch
"保存時に末尾の改行コードを取り除く
set binary noeol
"インデントの際、タブ文字ではなく、半角スペースが挿入される
set expandtab
" ファイルが更新されたら自動的にリロード
set autoread

" NERDTreeの設定
"------------------------------------------------
"<C-e>でNERDTreeをオンオフ。いつでもどこでも。
"http://blog.livedoor.jp/kumonopanya/archives/51048805.html
 nmap <silent> <C-e>      :NERDTreeToggle<CR>
 vmap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
 omap <silent> <C-e>      :NERDTreeToggle<CR>
" imap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
 cmap <silent> <C-e> <C-u>:NERDTreeToggle<CR>
 autocmd VimEnter * if !argc() | NERDTree | endif
 autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endi
 let g:NERDTreeShowHidden=1
 let g:NERDTreeHighlightCursorline=1
 let g:NERDTreeMinimalUI=1

" 全角スペースの表示
"----------------------------------------
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction
if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
  augroup END
  call ZenkakuSpace()
endif


" 最後のカーソル位置を復元する
"----------------------------------------------
if has("autocmd")
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
endif

" vim linter
"----------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" snipet
" ---------------------------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

"set snippet file dir
let g:neosnippet#snippets_directory='~/.vim/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets,~/.vim/snippets'

:let mapleader = "\<Space>"
