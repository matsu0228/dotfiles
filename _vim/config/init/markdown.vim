" markdown
augroup Markdown
  autocmd!
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END
let g:memolist_path = "~/Documents/2017"
let g:memolist_memo_suffix = "md"
let g:memolist_template_dir_path = "~/.vim/config/memolist"
let g:memolist_memo_date = "%y%m%d"
