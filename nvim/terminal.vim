" ----- Terminal emulator ---------------------------------------------------

" ESC turns terminal to normal mode
tnoremap <Esc> <C-\><C-n>
" <C-w> window navigation returns to normal mode
tnoremap <C-w> <C-\><C-n> <C-w>


autocmd TermOpen *
  \ setlocal nonumber |
  \ setlocal signcolumn=no |
  \ setlocal scrolloff=0


" disable cursorline in terminal
" TODO remove unnecessary autocmd groups, experiment it
autocmd BufWinEnter,WinEnter,TermOpen term://* set nocursorline
autocmd BufLeave,TermLeave term://* set cursorline!


" Terminal Insert mode when cursor is moved there
" (https://vi.stackexchange.com/a/3765)
  "autocmd BufWinEnter,WinEnter term://* startinsert
  "autocmd BufLeave term://* stopinsert


highlight DefaultTerminal guifg=#eeeeec guibg=Black

function! s:terminal_buffer_colors()
  if &buftype ==# 'terminal'
    setlocal winhighlight=Normal:DefaultTerminal
  endif
endfunction

autocmd TermOpen,WinEnter * call s:terminal_buffer_colors()
