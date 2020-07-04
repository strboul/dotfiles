
""" --------------------------------------------------------------------------
""" Special panes
""" --------------------------------------------------------------------------

""" nvim terminal
autocmd TermOpen *
  \ setlocal nonumber |
  \ setlocal norelativenumber |
  \ setlocal signcolumn=no |
  \ setlocal scrolloff=0


""" NERDTree
autocmd FileType nerdtree
  \ nnoremap <buffer><silent> <ESC> :NERDTreeClose<CR>


""" Quickfix
""" - ESC quits the window
autocmd BufWinEnter quickfix
  \ setlocal norelativenumber |
  \ setlocal signcolumn=no |
  \ setlocal colorcolumn= |
  \ highlight QuickFixLine cterm=bold ctermfg=none ctermbg=none |
  \ nnoremap <buffer><silent> <ESC> :cclose<CR>


""" fzf.vim
""" - ESC closes the window
autocmd FileType fzf
  \ tnoremap <buffer> <ESC> <C-C>


""" --------------------------------------------------------------------------
""" Common file extensions
""" --------------------------------------------------------------------------

autocmd BufNewFile,BufRead *.sh,*.zsh
  \ setlocal tabstop=2 |
  \ setlocal shiftwidth=2 |
  \ setlocal expandtab


autocmd BufNewFile,BufRead *.c,*.cpp
  \ setlocal tabstop=4 |
  \ setlocal shiftwidth=4


" On text files:
" - check spelling
" - do automatic word wrapping on markdown files
autocmd BufNewFile,BufRead *.txt,*.md
  \ setlocal tabstop=2 |
  \ setlocal shiftwidth=2 |
  \ setlocal spell spelllang=en_us |
  \ setlocal wrap textwidth=80


autocmd BufNewFile,BufRead *.R
  \ setlocal tabstop=2 |
  \ setlocal shiftwidth=2 |
  \ setlocal expandtab


" PEP-8 recommends 4 spaces, instead of tabs
autocmd BufNewFile,BufRead *.py
  \ setlocal tabstop=4 |
  \ setlocal softtabstop=4 |
  \ setlocal shiftwidth=4 |
  \ setlocal textwidth=79 |
  \ setlocal smartindent


autocmd BufNewFile,BufRead *.js
  \ setlocal makeprg=jslint |
  \ setlocal tabstop=2 |
  \ setlocal shiftwidth=2


autocmd BufNewFile,BufRead *.html,*.css
  \ setlocal tabstop=2 |
  \ setlocal softtabstop=2 |
  \ setlocal shiftwidth=2


autocmd BufNewFile,BufRead *.vim setlocal tabstop=2 shiftwidth=2 expandtab
autocmd BufNewFile,BufRead *.yaml,*.yml setlocal tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead Dockerfile setlocal tabstop=2 shiftwidth=2 expandtab

