""" Peekaboo plugin
let g:peekaboo_window='botright 35new'
let g:peekaboo_compact=1
" don't open the pane immediately, especially for obvious macros e.g. `@@` to
" repeat the last
let g:peekaboo_delay=300

function! s:vim_peekaboo_win()
  setlocal nolist
  setlocal nonumber
  setlocal signcolumn=no
  setlocal colorcolumn=
  setlocal scrolloff=0
  setlocal winhighlight=Normal:Pmenu
endfunction

augroup PeekabooWindow
  autocmd!
  autocmd FileType peekaboo call s:vim_peekaboo_win()
augroup END
