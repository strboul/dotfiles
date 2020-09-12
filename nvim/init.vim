""" ---------------------------------------------------------------------------
""" init file for nvim
"""
""" Measure the startup speed:
""" `for i in $(seq 1 5); do time nvim -c quit; done`
"""
""" Profile the startup time:
""" (https://github.com/mhinz/vim-galore#profiling-startup-time)
""" `nvim --startuptime /tmp/startup.log +q && nvim /tmp/startup.log`
"""
""" ---------------------------------------------------------------------------


" Check nvim version, display a message if using a non-compatible version
" (compatible means the most recent used & tested version with this config)
  function s:CheckNvimVersion()
    let l:compatible_version='0.4.3'
    if has(join(["nvim-", l:compatible_version], '-'))
      echohl WarningMsg |
        \ echo printf(
        \ 'Warning: This config is designed to be compatible with neovim
        \ (version greater than or equal to "%s")',
        \ l:compatible_version
        \ ) |
        \ echohl None
    endif
  endfunction
  call s:CheckNvimVersion()

""" ---------------------------------------------------------------------------
""" General settings
""" ---------------------------------------------------------------------------

" leader key
  let mapleader=','


" Essentials
  syntax enable      " syntax is enabled by default
  set hidden         " able to keep multiple open buffers
  set encoding=utf-8 " string encoding always UTF-8
  set mouse=a        " enable mouse use (if supported)
  set t_Co=256       " support 256 colors


" Window display
  set nonumber         " line numbers
  set norelativenumber " relative line numbers
  set cursorline       " horizontal cursor bar for the current line
  set laststatus=2     " always show the status bar
  set showtabline=2    " always show the tab bar
  set noshowmode       " no showmode e.g. --INSERT-- display, check statusbar
  set splitright       " always open h-splits at the right side
  set splitbelow       " always open v-splits at the below side
  set scrolloff=1      " off the lines when scrolling down
  set signcolumn=yes   " always show signcolumn for linting, diagnostics, etc.
  set shortmess+=I     " don't give the intro message at the start `:intro`
  set ruler            " always show cursor position


" Searching
  set ignorecase " case insensitive search
  set smartcase  " case-sensitive search if any uppercase char exists in the search term
  set incsearch  " start matching as soon as something is typed


" No swap & backups - VCS everywhere
  set noswapfile
  set nobackup
  set nowritebackup


" Pasting
  set nopaste                " Disable paste mode (see `:help paste`)
  set clipboard+=unnamedplus " Set system clipboard for yank/put/delete


" Indentation and spacing
  set nowrap                     " don't wrap
  set tabstop=2                  " insert 2 spaces for a tab
  set shiftwidth=2               " use 2 spaces when indenting
  set smarttab                   " tabbing detects when e.g. you have 2 or 4
  set expandtab                  " always add spaces when tab
  set smartindent                " makes indenting smart # FIXME test this?
  set autoindent                 " use indendation of previous line
  set list                       " show listchars
  set listchars=tab:\¦\ ,space:␣ " mark space and tab chars


" darken the screen after the 80th char
  let &colorcolumn='80,'.join(range(80,999),',')


" stop continuing comments (see `:help formatoptions` and `:help fo-table`)
" FIXME doesn't work, it's a bug in vim
  " autocmd BufNewFile,BufRead * setlocal formatoptions-=cro


" Auto save on focus out (but not in insert-mode, which is by `CursorHoldI`).
" (https://github.com/justinforce/dotfiles/blob/master/files/nvim/init.vim#L82)
  autocmd BufLeave,CursorHold,FocusLost * silent! wa


" Trigger autoread when changing buffers or coming back to vim.
" (https://stackoverflow.com/a/20418591)
  autocmd FocusGained,BufEnter * :silent! !


" Smarter cursorline - enabled only in the Insert mode
  autocmd InsertLeave,WinEnter * set cursorline
  autocmd InsertEnter,WinLeave * set nocursorline


" Restore cursor position when opening file (from :marks)
" TODO I'm not sure if I want that...
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif


" Timeout when press on ESC to switch from Insert to Normal mode
" If use nvim with tmux, be sure tmux.conf has: `set -s escape-time 0`
  set timeout timeoutlen=500 ttimeout ttimeoutlen=10


" Default (4000 ms ~ 4 s) is too slow. And a very low value can slow down vim.
  set updatetime=300


" for (neo)vim inside tmux
  if has('termguicolors')
    let &t_8f='\<Esc>[38;2;%lu;%lu;%lum'
    let &t_8b='\<Esc>[48;2;%lu;%lu;%lum'
    set termguicolors
  endif


" netrw
  " absolute width of netrw window
  " tree-view
  let g:netrw_liststyle=3
  let g:netrw_banner=0
  " use netrw as 'split windows', not as 'project drawer'
  let g:netrw_browse_split=0
  let g:netrw_altv=1
  let s:hide_list_for_netrw=join(['.*\.swp$','.DS_Store','*/tmp/*','*.so',
    \ '*.swp','*.zip','.git/*','^\.\.\=/\=$'], ',')
  let g:netrw_list_hide=s:hide_list_for_netrw

  " - ESC quits netrw window (FIXME)
  autocmd FileType netrw
    \ setlocal nolist |
    \ nnoremap <buffer><silent> <ESC> :Rexplore<CR>

  " open netrw in abs project path:
  nnoremap <leader>e :exe 'Explore' getcwd()<CR>


" Quickfix
  " - ESC closes the window
  " - disable line highlight
  autocmd BufWinEnter quickfix
    \ setlocal number |
    \ setlocal norelativenumber |
    \ setlocal signcolumn=no |
    \ setlocal nolist |
    \ nnoremap <buffer><silent> <ESC> :cclose<CR> |
    \ highlight QuickFixLine cterm=bold ctermfg=Black ctermbg=DarkGray gui=bold guifg=Black guibg=DarkGray


" Help
  " - ESC closes the window
  autocmd FileType help nnoremap <buffer><silent> <ESC> :helpclose<CR>


" terminal
  " ESC turns terminal to normal mode
  tnoremap <Esc> <C-\><C-n>
  " <C-w> window navigation returns to normal mode
  tnoremap <C-w> <C-\><C-n> <C-w>

  autocmd TermOpen *
    \ setlocal nonumber |
    \ setlocal norelativenumber |
    \ setlocal signcolumn=no |
    \ setlocal scrolloff=0

  " Have terminal Insert mode when cursor is moved there
  " (Source: https://vi.stackexchange.com/a/3765)
  "autocmd BufWinEnter,WinEnter term://* startinsert
  "autocmd BufLeave term://* stopinsert


" Language specific configs are here
  source $HOME/dotfiles/nvim/filetypes.vim

""" ---------------------------------------------------------------------------
""" Custom keymappings
""" ---------------------------------------------------------------------------

  " clear the search and redraw the screen
  " (https://github.com/mhinz/vim-galore/blob/b64abe3e6afaa90e4da5928d78a5b3fa03829548/README.md#saner-ctrl-l)
  nnoremap <silent> <C-l>
    \ :nohlsearch<CR>:diffupdate<CR>
    \ :syntax sync fromstart<CR>
    \ :echo 'Search cleared'<CR>


  " Use // to search for visually selected text
  " (https://vim.fandom.com/wiki/Search_for_visually_selected_text)
  vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>


" o adds new line within the normal mode
  nnoremap o o<Esc>
  nnoremap O O<Esc>


" Jump to the middle of the viewport when navigating with n or {
  nnoremap n nzz
  nnoremap N Nzz

  nnoremap } }zz
  nnoremap { {zz


" Custom commands
  source $HOME/dotfiles/nvim/mmy.vim

""" ---------------------------------------------------------------------------
""" Plugins
""" ---------------------------------------------------------------------------

" FIXME is it required in neovim?
  filetype plugin on

" Auto installation vim-plug
  " FIXME is it still relevant?
  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif


" Specify directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Debug: - check the running paths with `:set runtimepath?`
" - Use full URL because it's easy to go to the link with `gx`
call plug#begin('~/.local/share/nvim/plugged')

" fzf
  Plug 'https://github.com/junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'https://github.com/junegunn/fzf.vim'

  " map commands
  nnoremap <silent> <c-p> :Files<CR>
  nnoremap <silent> <c-a-p> :Commands<CR>

  " list open buffers
  nnoremap <silent> <leader>b :Buffers<CR>
  " search lines in current buffer.
  nnoremap <silent> <leader>l :BLines<CR>

  " Rg with arguments
  " (https://github.com/junegunn/fzf.vim/issues/838#issuecomment-509902575)
  command! -bang -nargs=* Rg
  \  call fzf#vim#grep(
  \  "rg --column --line-number --no-heading --color=always --smart-case ".<q-args>,
  \  1, fzf#vim#with_preview(), <bang>0)

  " use fzf as 'split windows', not as 'project drawer'
  " open fzf pane in current buffer window, not in whole tab
  let g:fzf_layout={'window': '20split enew'}

  " - ESC closes the window
  autocmd FileType fzf tnoremap <buffer> <ESC> <C-C>

" NERDTree
" Use NERDTree as 'project drawer'
  Plug 'https://github.com/preservim/nerdtree'

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
    " ignore some files in NERDTree
  let NERDTreeIgnore=['^\.vim$', '^\.git$', '\.DS_Store$',
  \ '\.Rhistory$', '\.Rproj\.user$',
  \ '__pycache__$'
  \ ]

  " - ESC closes the window
  autocmd FileType nerdtree nnoremap <buffer><silent> <ESC> :NERDTreeClose<CR>

  " Toggle NERDTree window
  " 1. if the active buffer exists, find (point out) the file in NERDTree
  " 2. else, toggle NERDTree window only
  function MyNERDTreeToggleFind()
    if &filetype == 'nerdtree' && g:NERDTree.IsOpen()
      :NERDTreeToggle
    else
      if bufname('%') != '' && bufname('%') != 'NERD_tree_\d'
        :NERDTreeFind
      else
        :NERDTreeToggle
      endif
    endif
  endfunction
  nnoremap <silent> <leader>n :call MyNERDTreeToggleFind()<CR>


" nerdcommenter
  Plug 'https://github.com/preservim/nerdcommenter'

  " add an extra space after comment symbol
  let NERDSpaceDelims=1


" vim-airline
" (100% vim script. Better than 'vim-powerline' requiring python)
  Plug 'https://github.com/vim-airline/vim-airline'
  Plug 'https://github.com/vim-airline/vim-airline-themes'

  " tabline settings
  let g:airline#extensions#tabline#enabled=1
  let g:airline#extensions#tabline#show_close_button=0
  " smart file paths display:
  let g:airline#extensions#tabline#formatter='unique_tail'
  let g:airline#extensions#tabline#show_tab_nr=0
  " change labels:
  let g:airline#extensions#tabline#buffers_label=''
  let g:airline#extensions#tabline#tabs_label='TABS'
  " show buffer numbers (as shown in `:ls`):
  let g:airline#extensions#tabline#buffer_nr_show=1
  let g:airline#extensions#tabline#buffer_nr_format='%s '


" coc.nvim
  Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}

  function ReadCocExtensionsFile()
    let s:file=readfile(glob('$HOME/dotfiles/nvim/coc-extensions.txt'))
    " filter out commented lines and empty lines:
    let s:coc_exts=filter(filter(s:file, 'v:val !~ "#.*$"'), 'v:val !~ "^\s*$"')
    return s:coc_exts
  endfunction
  let g:coc_global_extensions=ReadCocExtensionsFile()

  so $HOME/dotfiles/nvim/coc.vim


" UltiSnips
  Plug 'https://github.com/sirver/UltiSnips'
  " don't use any expand key (because using `coc-snippets` for)
  let g:UltiSnipsExpandTrigger='<nop>'


" neoterm
  Plug 'https://github.com/kassio/neoterm', {'commit': 'e011fa1'}

  let g:neoterm_default_mod='belowright'
  let g:neoterm_size=16
  let g:neoterm_autoscroll=1
  let g:neoterm_direct_open_repl=1
  " calling :Tclose or :Ttoggle kills the terminal
  let g:neoterm_keep_term_open=0

  " set REPLs
  if executable('radian')  | let g:neoterm_repl_r='radian'       | endif
  if executable('bpython') | let g:neoterm_repl_python='bpython' | endif

  " send current line and move down
  nnoremap <silent><leader><cr> :TREPLSendLine<cr>j
  " send visual selection
  " ('> goes to the beginning of the last line of the last selected Visual
  " area in the current buffer)
  vnoremap <silent><leader><cr> :TREPLSendSelection<cr>'>j
  " toggle terminal
  nnoremap <silent><leader>tt :Ttoggle<CR>
  tnoremap <silent><leader>tt <C-\><C-n>:Ttoggle<CR>


" vim-bufkill
  Plug 'https://github.com/qpkorr/vim-bufkill'
  " don't let bufkill create leader mappings, use commands:
  let g:BufKillCreateMappings=0


" vim-better-whitespace (highlight and remove trailing whitespace)
  Plug 'https://github.com/ntpeters/vim-better-whitespace'

  let g:better_whitespace_ctermcolor='red'
  let g:strip_whitespace_on_save=1


" vim-easy-align
  Plug 'https://github.com/junegunn/vim-easy-align'

  " align backslashes in e.g. multi-line bash, C macros etc.:
  let g:easy_align_delimiters={
    \ '\': {'pattern': '\\$'}
  \ }


" git and other VCS
  " fugitive
  Plug 'https://github.com/tpope/vim-fugitive'
  " rhubarb for GitHub (for `:Gbrowse`)
  Plug 'https://github.com/tpope/vim-rhubarb'


" vim-polyglot (syntax highlighting)
  Plug 'https://github.com/sheerun/vim-polyglot'


" ale (syntax checker)
" it's still useful for some checks, e.g. shellcheck for bash/zsh
  Plug 'https://github.com/dense-analysis/ale'


  " disable linting on some files
  " https://github.com/dense-analysis/ale/issues/371#issuecomment-304313091
  let g:ale_pattern_options={
    \ '.R$':   {'ale_enabled': 0},
    \ '.Rmd$': {'ale_enabled': 0},
    \ '.py$':  {'ale_enabled': 0}
  \}


" vim-highlightedyank
  Plug 'https://github.com/machakann/vim-highlightedyank'

  " redefine highlight yank time
  let g:highlightedyank_highlight_duration=2500


" Colors
  Plug 'https://github.com/romainl/Apprentice'
  Plug 'https://github.com/chriskempson/base16-vim'


call plug#end()


""" ---------------------------------------------------------------------------
""" Colors
""" ---------------------------------------------------------------------------

colorscheme apprentice

set background=dark
let g:airline_theme='bubblegum'


" #### THE END ####

