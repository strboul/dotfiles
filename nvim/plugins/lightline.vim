" lightline plugin

  let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'gitbranch', 'readonly', 'filename', 'modified' ]
    \   ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead',
    \   'filename': 'LightlineFilename',
    \   'readonly': 'LightlineReadonly',
    \ },
    \ }

  " Hide the filename in the help pane
  function! LightlineFilename()
    return &filetype ==# 'help' ? '' :
      \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  endfunction

  " Hide the filetype in the help pane
  function! LightlineReadonly()
    return &readonly && &filetype !=# 'help' ? 'RO' : ''
  endfunction
