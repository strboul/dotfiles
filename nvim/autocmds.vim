" ----- Essential autocommands ---------------------------------------------

" Auto save on focus out (but not in insert-mode, which is by `CursorHoldI`).
" (https://github.com/justinforce/dotfiles/blob/master/files/nvim/init.vim#L82)
  autocmd BufLeave,CursorHold,FocusLost * silent! wa

" Trigger autoread when changing buffers or coming back to vim.
" (https://stackoverflow.com/a/20418591)
  autocmd FocusGained,BufEnter * :silent! !

" Smarter cursorline (enabled only in the Normal mode)
  autocmd InsertLeave,WinEnter * setlocal cursorline
  autocmd InsertEnter,WinLeave * setlocal nocursorline

" Restore cursor position when opening file (from :marks)
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

" Notification after file change (https://vi.stackexchange.com/a/13093)
  autocmd FileChangedShellPost *
    \ echohl WarningMsg |
    \ echo "File changed on disk. Buffer reloaded." |
    \ echohl None

" Keep yanked text highlighted for a given time
  augroup HighlightYankedText
    autocmd!
    autocmd TextYankPost * silent!
      \ lua vim.highlight.on_yank {higroup='IncSearch', timeout=1500}
  augroup END
