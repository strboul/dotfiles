" ----- Common file extensions & types --------------------------------------

" On text files:
" - check spelling
" - do automatic word wrapping on markdown files
autocmd BufNewFile,BufRead *.txt,*.md
  \ setlocal spell spelllang=en_us |
  \ setlocal wrap textwidth=79

autocmd BufNewFile,BufRead *.c,*.cpp
  \ setlocal tabstop=4 |
  \ setlocal shiftwidth=4

" don't span arguments when indenting (see `:help ft-r-indent`)
autocmd BufNewFile,BufRead *.R
  \ let r_indent_align_args=0 |
  \ let r_indent_ess_compatible=1

" PEP-8 recommends 4 spaces, instead of tabs
autocmd BufNewFile,BufRead *.py
  \ setlocal tabstop=4 |
  \ setlocal softtabstop=4 |
  \ setlocal shiftwidth=4 |
  \ setlocal smartindent

autocmd BufNewFile,BufRead *.yaml,*.yml setlocal tabstop=4 shiftwidth=4
autocmd FileType make setlocal noexpandtab
