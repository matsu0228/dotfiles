" go: (vim-go) https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt

" auto :GoInfo
" let g:go_auto_type_info = 1
" auto :GoSameIds
" let g:go_auto_sameids = 1
augroup GoSetting
  autocmd!
  autocmd BufNewFile,BufRead *.{go} set filetype=go
  autocmd BufWritePre *.{go} :GoImports
  autocmd BufWritePre *.{go} :GoMetaLinter
  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)
  " for :GoAlternaitve  :A, :AV, :AS, :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END
