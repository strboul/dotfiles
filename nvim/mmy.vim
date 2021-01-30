" M.Y.'s custom vim commands

" ----- Utils ------------------------------------------------------------

" Get character under the cursor (https://vi.stackexchange.com/a/19709/)
  function mmy#GetCharUnderCursor()
    return strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
  endfunction

" ----- Functions --------------------------------------------------------

" Check nvim version, display a warning message if versions aren't the same
  function mmy#CheckNvimVersion(compatible_version)
    let l:nvim_v=matchstr(execute('version'), 'NVIM v\zs[^\n]*')
    if l:nvim_v !~ a:compatible_version
      echohl WarningMsg |
        \ echo printf(
        \ 'Warning: This config is designed to be compatible with neovim
        \ version "%s" (you have "%s")',
        \ a:compatible_version,
        \ l:nvim_v
        \ ) |
        \ echohl None
    endif
  endfunction

" Read a file (e.g. a txt) as a conf by removing commented and empty lines:
  function mmy#ReadTxtConfFile(file_path)
    let l:file=readfile(glob(a:file_path))
    let l:out_array=filter(filter(l:file, 'v:val !~ "#.*$"'), 'v:val !~ "^\s*$"')
    return l:out_array
  endfunction

" Get git ignored files as a list (if the current wd is a git repository)
  function mmy#GetGitIgnoredFiles()
    let l:git_ignored=system('git status --ignored --porcelain')
    let l:ignored_text=matchstr(l:git_ignored, '!!.*')
    let l:text=substitute(l:ignored_text, '!!', '', 'g')
    let l:text=substitute(l:text, '/', '', 'g')
    let l:sp=split(l:text, '\n')
    let l:esc_tail=map(copy(l:sp), 'escape(fnamemodify(trim(v:val), ":t"), ".")')
    let l:out=uniq(l:esc_tail)
    return l:out
  endfunction

" ----- Commands ---------------------------------------------------------

" Echo buffer file path and put them in the register
  function mmy#FunEchoRegisterBufferPath()
    let l:abs_pat=expand('%:p')
    let l:rel_pat=expand('%')
    if l:abs_pat != ""
      call setreg('f', l:abs_pat)
      call setreg('g', l:rel_pat)
      echohl Statement |echon printf('"%s" ', l:rel_pat) | echohl None
      echon 'relative path stored in :reg'
      echohl Statement | echon ' "g' | echohl None
      echon ' and absolute path in'
      echohl Statement | echon ' "f' | echohl None
    else
      echohl WarningMsg | echo 'No file in the buffer' | echohl None
    endif
  endfunction

  command EchoRegisterBufferPath :call mmy#FunEchoRegisterBufferPath()
  nnoremap <silent> <C-g> :EchoRegisterBufferPath<CR>


" Convert single quotes to double and vice versa
" FIXME: doesn't work well sometimes
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


" Search & highlight non-ASCII chars (https://stackoverflow.com/a/16987522)
  function mmy#FunSearchNonASCIIChars()
    " built query as <CR> isn't read between double quotes, see:
    " https://vim.fandom.com/wiki/Using_normal_command_in_a_script_for_searching
    let l:query='/[^\x00-\x7F]'
    execute 'normal! /' . l:query . "\<CR>"
  endfunction

  command SearchNonASCIIChars :call mmy#FunSearchNonASCIIChars()


" Remove zero width unicode chars displayed as <200b>
  function mmy#FunRemoveZeroWidthSpaceChars()
    :%s/\%u200b//g
  endfunction

  command RemoveZeroWidthSpaceChars :call mmy#FunRemoveZeroWidthSpaceChars()
