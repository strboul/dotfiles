" FIXME: work in progress
"
" Buffers start with [B] and files start with [F] (different colors for each
" if possible)
"
" - change commands to smaller cases
" - it may be better to use fzf internals directly (if possible)

" command! -bang SmartFinder
  " \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" Sink ------------------------------

function! s:bufopen(elem)
  execute 'buffer' matchstr(a:elem, '^[ 0-9]*')
endfunction

function! s:fileopen(elem)
  execute 'edit' a:elem
endfunction

function! s:smart_finder_sink(elem)
  call s:bufopen(a:elem)
endfunction

" Source ------------------------------

function s:smart_finder_source()
  let l:buflist=BufList()
  let l:git_files=ListGitFiles()
  return l:buflist + l:git_files
endfunction

function! ListGitFiles()
  let l:git_ls = split(system('git ls-files'), '\n')
  return l:git_ls
endfunction

function! ListGitWhatChanged()
  let l:gitwhatchanged = split(system('gitwhatchanged'), '\n')
  return l:gitwhatchanged
endfunction

function! BufList()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

" Command ------------------------------

command! FzfSmartFinder
  \ call fzf#run(fzf#wrap({
  \ 'source': s:smart_finder_source(),
  \ 'sink': function('s:smart_finder_sink'),
  \ 'options': '-m -x +s'
  \ }))

