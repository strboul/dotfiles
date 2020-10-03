" M.Y.'s custom vim commands

" ----- Utils ------------------------------------------------------------

" Get character under the cursor
" (source: https://vi.stackexchange.com/a/19709/)
  function mmy#GetCharUnderCursor()
    return strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
  endfunction


" ----- Functions --------------------------------------------------------

" Check nvim version, display a warning message if versions aren't the same
  function mmy#CheckNvimVersion(compatible_version)
    let s:nvim_v=matchstr(execute('version'), 'NVIM v\zs[^\n]*')
    if s:nvim_v != a:compatible_version
      echohl WarningMsg |
        \ echo printf(
        \ 'Warning: This config is designed to be compatible with neovim
        \ version "%s" (you have "%s")',
        \ a:compatible_version,
        \ s:nvim_v
        \ ) |
        \ echohl None
    endif
  endfunction


" Read a file (e.g. a txt) as a conf by removing commented and empty lines:
  function mmy#ReadTxtConfFile(file_path)
    let s:file=readfile(glob(a:file_path))
    let s:out_array=filter(filter(s:file, 'v:val !~ "#.*$"'), 'v:val !~ "^\s*$"')
    return s:out_array
  endfunction


" Get git ignored files as a list (if the current wd is a git repository)
  function mmy#GetGitIgnoredFiles()
    let s:git_ignored=system('git status --ignored --porcelain')
    let s:ignored_text=matchstr(s:git_ignored, '!!.*')
    let s:text=substitute(s:ignored_text, '!!', '', 'g')
    let s:text=substitute(s:text, '/', '', 'g')
    let s:sp=split(s:text, '\n')
    let s:esc_tail=map(copy(s:sp), 'escape(fnamemodify(trim(v:val), ":t"), ".")')
    let s:out=uniq(s:esc_tail)
    return s:out
  endfunction


" ----- Commands ---------------------------------------------------------

" Echo buffer absolute file path
  function mmy#FunEchoBufferAbsPath()
    let l:pat=expand('%:p')
    if l:pat != ""
      " put the variable in register:
      call setreg('f', l:pat)
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
" TODO create SplitIntoMultipleLines instead with a prompt for delimiter
  function mmy#FunSpanLinesByComma()
    :s/,/,\r/g
    " keep cursor position on the line
    normal! ``
  endfunction

  command SpanLinesByComma :call mmy#FunSpanLinesByComma()


  " Search & highlight non-ASCII characters
  " (https://stackoverflow.com/a/16987522)
  function mmy#FunSearchNonASCIIChars()
    " built query as <CR> isn't read between double quotes, see:
    " https://vim.fandom.com/wiki/Using_normal_command_in_a_script_for_searching
    let s:query='/[^\x00-\x7F]'
    execute 'normal! /' . s:query . "\<CR>"
  endfunction

  command SearchNonASCIIChars :call mmy#FunSearchNonASCIIChars()
