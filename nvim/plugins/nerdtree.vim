""" NERDTree plugin
" Use NERDTree as 'project drawer'

" position of NERDTree panel
  let NERDTreeWinPos='right'
  " define the default size of panel
  let NERDTreeWinSize=70
  " show hidden (dot) files
  let NERDTreeShowHidden=1
  " hide help panel on the top
  let NERDTreeMinimalUI=1
  " click nodes with a single mouse click (not double)
  let NERDTreeMouseMode=3
  " close tab after opening file
  let NERDTreeQuitOnOpen=1

  " Smart ignore for NERDTree.
  " Excludes a list of hand-selected files/folders. Also excludes the git
  " ignored files.
  " But it's also possible to force allow files (regardless git ignore).
  function! s:NERDTreeSmartIgnore(list_ignore, list_allow)
    let l:git_ignored_files=mmy#GetGitIgnoredFiles()
    let l:ignore_uniq=uniq(filter(
      \ a:list_ignore + l:git_ignored_files,
      \ 'len(v:val)>0'
      \ ))
    let l:with_allow=filter(l:ignore_uniq, 'index(a:list_allow, v:val)<0')
    return l:with_allow
  endfunction

  let s:nerd_tree_default_ignore=['^\.git$']
  let s:nerd_tree_default_allow=['\.env']
  let NERDTreeIgnore=s:NERDTreeSmartIgnore(
    \ s:nerd_tree_default_ignore,
    \ s:nerd_tree_default_allow
    \ )

  " Toggle NERDTree window
  " 1. if the active buffer exists, find (point out) the file in NERDTree
  " 2. else, toggle NERDTree window only
  function! s:MyNERDTreeToggleFind()
    if g:NERDTree.IsOpen() && &filetype == 'nerdtree'
      " collapse all other open folders - P (jump to root) X (close recursively)
      :normal PX
      :NERDTreeToggle
    else
      let l:bn=bufname('%')
      if l:bn != '' && l:bn != 'NERD_tree_\d'
        :NERDTreeFind
      else
        :NERDTreeToggle
      endif
    endif
  endfunction

  nnoremap <silent> <leader>n :call <SID>MyNERDTreeToggleFind()<CR>

  augroup NERDTreeWindow
    autocmd!
    " - Pressing ESC in nerdtree window toggles the window
    autocmd FileType nerdtree
      \ setlocal signcolumn=no |
      \ nnoremap <buffer><silent> <ESC> :call <SID>MyNERDTreeToggleFind()<CR>
  augroup END
