
" frontend: https://qiita.com/janus_wel/items/e1820a670a32ab09c5fc
"  indent: http://blog.restartr.com/2014/04/20/vimrc-noexpandtab-in-golang/
augroup JSSetting
  autocmd!
  autocmd BufNewFile,BufRead *.{js} set filetype=javascript noexpandtab tabstop=4 shiftwidth=4
augroup END

"
" " TODO:  Eslint/Prettier でjQuery許容
" " let g:ale_linters = {
" let g:ale_fixers = {
" \   'javascript': ['prettier'],
" \}
" " auto lint
" let g:ale_fix_on_save = 1
"
" " auto complete
" let g:ale_completion_enabled = 1
"
"
"
" " standard is not good for `jQuery`
" autocmd bufwritepost *.js silent !standard --fix %
" set autoread
