" ----- Custom key mappings -------------------------------------------------

" clear the search and redraw the screen
" (https://github.com/mhinz/vim-galore/blob/b64abe3e6afaa90e4da5928d78a5b3fa03829548/README.md#saner-ctrl-l)
  nnoremap <silent> <C-l>
    \ :nohlsearch<CR>:diffupdate<CR>
    \ :syntax sync fromstart<CR>
    \ :echo 'Search cleared'<CR>

" Highlight word under cursor without jumping to next or prev occurrence
" https://github.com/scrooloose/vimfiles/blob/a9689e8eace5b38d9fb640294e6e4b681e18981a/vimrc#L497-L509
  nnoremap <silent> * :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>:set hls<CR>
  nnoremap <silent> # :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>:set hls<CR>

  " visual selection search with */#
  " FIXME I get a highlighted yank after :nohl, shouldn't get any?
  function! s:VSelectSearch()
    let temp=@@
    normal! gvy
    let @/='\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@=temp
  endfunction

  vnoremap <silent> * :<C-u>call <SID>VSelectSearch()<CR>:set hls<CR>
  vnoremap <silent> # :<C-u>call <SID>VSelectSearch()<CR>:set hls<CR>

" add new lines in the Normal mode
  nnoremap o o<Esc>
  nnoremap O O<Esc>

" these keep the line location unchanged (https://vi.stackexchange.com/a/3881)
  nnoremap <silent> <leader>o :<C-u>call append(line('.'), repeat([''], v:count1))<CR>
  nnoremap <silent> <leader>O :<C-u>call append(line('.')-1, repeat([''], v:count1))<CR>

" make cw consistent with dw (delete word with whitespace)
  map cw dwi

" make Y consistent with D (yanks until the end of the line)
  map Y y$

" disable F1 key opening the vim-help
  nnoremap <F1> <nop>
  inoremap <F1> <nop>

" better x (don't push it to the register)
  nnoremap x "_x

" Jump to the middle of the viewport when navigating with n or {
  nnoremap n nzz
  nnoremap N Nzz

  nnoremap } }zz
  nnoremap { {zz

" delete the whole line without removing the line space
  nnoremap dx 0d$
