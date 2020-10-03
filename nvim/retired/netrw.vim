" retirement note: it's too buggy

" tree-view
let g:netrw_liststyle=3
" don't show help banner
let g:netrw_banner=0
" use netrw as 'split windows', not as 'project drawer'
" (see https://github.com/tpope/vim-vinegar/)
let g:netrw_browse_split=0
let g:netrw_altv=1
let s:hide_list_for_netrw=join(['.*\.swp$','.DS_Store','*/tmp/*','*.so',
  \ '*.swp','*.zip','.git/*','^\.\.\=/\=$'], ',')
let g:netrw_list_hide=s:hide_list_for_netrw


function! s:ToggleNetrw()
  if &filetype ==# 'netrw'
    let @/=expand('%:t')
    " open netrw in abs project path:
    execute 'Explore' getcwd()
    normal! n
  endif
endfunction

nnoremap <leader>e :call <SID>ToggleNetrw()<CR>


" - ESC quits netrw window
function! s:netrw_pane()
  if &filetype ==# 'netrw'
    setlocal nolist
    " this is important, so the netrw buffer is deleted when it's hidden
    setlocal bufhidden=delete
    nnoremap <buffer><silent> <ESC> :call ToggleNetrw<CR>
  endif
endfunction

autocmd FileType netrw call s:netrw_pane()
