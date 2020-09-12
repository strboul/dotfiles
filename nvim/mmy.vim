" M.Y.'s custom vim commands

" ----- Utils ------------------------------------------------------------

" Get character under the cursor
" (source: https://vi.stackexchange.com/a/19709/)
  function mmy#GetCharUnderCursor()
    return strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
  endfunction


" ----- Main -------------------------------------------------------------

" Echo buffer absolute file path
  function mmy#FunEchoBufferAbsPath()
    let l:pat=expand('%:p')
    if l:pat != ""
      " put the variable in register:
      call setreg("f", l:pat)
      echo printf('"%s" buffer full path (stored in :reg "f)', l:pat)
    else
      echohl WarningMsg | echo 'No file in the buffer' | echohl None
    endif
  endfunction

  command EchoFileAbsPath :call mmy#FunEchoBufferAbsPath()
  nnoremap <silent> <C-g> :call mmy#FunEchoBufferAbsPath()<CR>


" Convert single quotes to double and vice versa
  function mmy#FunQuoteTypesToggle()
    " (maybe write this fun recursively one day)
    " get the cursor position:
    let l:init_cur_pos=getpos('.')
    let l:init_char=mmy#GetCharUnderCursor()
    normal! f"
    let l:char_after_double=mmy#GetCharUnderCursor()
    if l:init_char == l:char_after_double
      normal! f'
      let l:char_after_single=mmy#GetCharUnderCursor()
      if l:init_char == l:char_after_single
        echohl WarningMsg | echo 'No quotes found around' | echohl None
      else
        normal! r"F'r"
      endif
    else
      normal! r'F"r'
    endif
    " restore the initial cursor position:
    call setpos('.', l:init_cur_pos)
  endfunction

  command QuoteTypesToggle :call mmy#FunQuoteTypesToggle()


" Command to help fix indentation lines
  function mmy#FunIndentToggle()
    if &cursorcolumn | set nocursorcolumn | else | set cursorcolumn | endif
    if &list         | set nolist         | else | set list         | endif
  endfunction

  command IndentToggle :call mmy#FunIndentToggle()


" Break into new lines by (,) comma e.g. `[x=1, y=2, c=3]`
  function mmy#FunSpanLinesByComma()
    :s/,/,\r/g
    " keep cursor position on the line
    normal! ``
  endfunction

  command SpanLinesByComma :call mmy#FunSpanLinesByComma()
