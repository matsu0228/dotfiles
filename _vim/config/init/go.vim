" go: (vim-go) https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt

let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

" auto :GoInfo
let g:go_auto_type_info = 1
" auto :GoSameIds
" let g:go_auto_sameids = 1

" quick fix
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
let g:go_list_type = "quickfix"

augroup GoSetting
  autocmd!
  " auto lint
  autocmd BufNewFile,BufRead *.{go} set filetype=go
  autocmd BufWritePre *.{go} :GoImports
  "autocmd BufWritePre *.{go} :GoMetaLinter  "autosaveに移譲
  " go shortcut
  autocmd FileType go nmap <leader>r  <Plug>(go-run)
  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)
  " for :GoAlternaitve  :A, :AV, :AS, :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END
