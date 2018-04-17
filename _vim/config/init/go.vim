" go: (vim-go) https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt
augroup GoSetting
  autocmd!
  autocmd BufNewFile,BufRead *.{go} set filetype=go
  autocmd BufWritePre *.{go} :GoImports
  autocmd BufWritePre *.{go} :GoMetaLinter
augroup END
