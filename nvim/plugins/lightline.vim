" lightline plugin
  let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'gitbranch', 'readonly', 'filename' ]
    \   ],
    \   'right': [
    \     [ 'lineinfo' ],
    \     [ 'percent' ],
    \     [ 'fileformat', 'fileencoding', 'filetype' ]
    \   ]
    \ },
    \ 'inactive': {
    \   'left': [ ],
    \   'right': [ [ 'relativepath' ] ],
    \ },
    \ 'component_function': {
    \   'gitbranch':    'LightlineGitBranch',
    \   'readonly':     'LightlineReadonly',
    \   'filename':     'LightlineFilename',
    \   'fileformat':   'LightlineFileFormat',
    \   'fileencoding': 'LightlineFileEncoding',
    \ },
    \ }

  let g:lightline.separator={ 'left': "\ue0b0", 'right': "\ue0b2" }
  let g:lightline.subseparator={ 'left': "\ue0b1", 'right': "\ue0b3" }

  " Git integration
  function! LightlineGitBranch()
    if FugitiveHead() ==# ''
      return ''
    endif
    return nr2char(0x2387) . '  ' . FugitiveHead()
  endfunction

  " Hide the filetype in the help pane
  function! LightlineReadonly()
    return &readonly && &filetype !=# 'help' ? 'RO' : ''
  endfunction

  " Hide the filename in the help pane
  function! LightlineFilename()
    return &filetype ==# 'help' ? 'help' :
      \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  endfunction

  " don't show file format if it's unix, check `help 'fileformat'`
  function LightlineFileFormat()
    return &fileformat ==# 'unix' ? '' : &fileformat
  endfunction

  " don't show file encoding if it's utf-8
  function LightlineFileEncoding()
    return &fileencoding ==# 'utf-8' ? '' : &fileencoding
  endfunction
