""" Quickfix window
" - ESC closes the window
function! s:quickfix_win()
  setlocal number
  setlocal norelativenumber
  setlocal signcolumn=no
  setlocal nolist
  nnoremap <buffer><silent> <ESC> :cclose<CR>
endfunction
autocmd BufWinEnter quickfix call s:quickfix_win()
