source $HOME/dotfiles/nvim/mmy.vim

call mmy#CheckNvimVersion('0.5.0-741')

" ----- General settings ---------------------------------------------------

" Essentials
  set hidden         " able to keep multiple open buffers
  set encoding=utf-8 " string encoding always UTF-8
  set mouse=a        " enable mouse use (if supported)
  set t_Co=256       " support 256 colors
  set termguicolors  " 24-bit RGB, use 'gui' instead of 'cterm' attributes
  let mapleader=','  " leader key


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
  set ignorecase       " case insensitive search
  set smartcase        " case sensitive search (if any uppercase char exists)
  set incsearch        " start matching as soon as something is typed
  set inccommand=split " preview substitution in split window (nvim specific)

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
  set smartindent                " makes indenting smart
  set autoindent                 " use indendation of previous line


" listchars
  set list                       " show listchars
  set listchars=tab:\¦\ ,space:␣
  set listchars+=trail:·


" virtual editing on the window, can do block/rectangular selections:
  set virtualedit=block


" Timeout when press on ESC to switch from Insert to Normal mode
" If use nvim with tmux, be sure tmux.conf has: `set -s escape-time 0`
  set timeout timeoutlen=500 ttimeout ttimeoutlen=10


" Default (4000 ms ~ 4 s) is too slow. And a very low value can slow down vim.
  set updatetime=100


" darken the screen after the 80th char
  let &colorcolumn='80,'.join(range(80,999),',')


" stop continuing comments (see `:help formatoptions` and `:help fo-table`)
" FIXME doesn't work, it's a bug in vim
  " autocmd FileType * setlocal formatoptions-=cro


" essential autocommands
  source $HOME/dotfiles/nvim/autocmds.vim


" Quickfix
  " - ESC closes the window
  autocmd BufWinEnter quickfix
    \ setlocal number |
    \ setlocal norelativenumber |
    \ setlocal signcolumn=no |
    \ setlocal nolist |
    \ nnoremap <buffer><silent> <ESC> :cclose<CR>


" Help
  " - ESC closes the window
  autocmd FileType help nnoremap <buffer><silent> <ESC> :helpclose<CR>


" Clear cmd messages after some time (https://unix.stackexchange.com/a/613645)
  function! s:clear_message(timer)
    if mode() ==# 'n' | echon '' | endif
  endfunction

  augroup clear_cmd_messages
      autocmd!
      autocmd CmdlineLeave : call timer_start(5000, funcref('s:clear_message'))
  augroup END


  source $HOME/dotfiles/nvim/filetypes.vim
  source $HOME/dotfiles/nvim/mappings.vim

" ----- Plugins ------------------------------------------------------------

" https://github.com/junegunn/vim-plug
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
    \ call fzf#vim#grep(
    \ "rg --column --line-number --no-heading --color=always --smart-case ".<q-args>,
    \ 1, fzf#vim#with_preview(), <bang>0
    \ )

  " use fzf as 'split windows', not as 'project drawer'
  " open fzf pane in current buffer window, not in whole tab
  let g:fzf_layout={'window': '20split enew'}

  augroup fzfsettings
    autocmd!
    " ESC closes the window
    autocmd FileType fzf tnoremap <buffer> <ESC> <C-C>
  augroup END


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

  let nerd_tree_ignore_defaults=['^\.git$']
  " don't show the git ignored files
  let g:nerd_tree_ignore=uniq(filter(
    \ nerd_tree_ignore_defaults + mmy#GetGitIgnoredFiles(),
    \ 'len(v:val)>0'
    \ ))

  let NERDTreeIgnore=g:nerd_tree_ignore

  " Toggle NERDTree window
  " 1. if the active buffer exists, find (point out) the file in NERDTree
  " 2. else, toggle NERDTree window only
  function! s:MyNERDTreeToggleFind()
    if g:NERDTree.IsOpen() && &filetype == 'nerdtree'
      " collapse all other open folders - P (jump to root) X (close recursively)
      :normal PX
      :NERDTreeToggle
    else
      let s:bn=bufname('%')
      if s:bn != '' && s:bn != 'NERD_tree_\d'
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
    autocmd FileType nerdtree nnoremap <buffer><silent> <ESC> :call <SID>MyNERDTreeToggleFind()<CR>
  augroup END


" nerdcommenter
  Plug 'https://github.com/preservim/nerdcommenter'
  " add an extra space after comment symbol
  let NERDSpaceDelims=1


" vim-airline
  Plug 'https://github.com/vim-airline/vim-airline'
  Plug 'https://github.com/vim-airline/vim-airline-themes'

  " powerline symbols
  let g:airline_powerline_fonts=1

  " statusline settings
    " simplify line, col info:
    let g:airline_section_z='%p%% ' . nr2char(0x2630) . ' %l:%c'

    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif

    let g:airline_symbols.branch=nr2char(0x2387) . ' '
    let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

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

  " extensions
    let g:airline#extensions#tagbar#enabled=1


" icons/patched fonts
  Plug 'https://github.com/ryanoasis/vim-devicons'


" coc.nvim
  Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
  source $HOME/dotfiles/nvim/plugins/coc/coc.vim


" tagbar
  Plug 'https://github.com/preservim/tagbar'
  " tags should be sorted by order of their apperance, not alphabetically
  let g:tagbar_sort=0


" urlview
  Plug 'https://github.com/strboul/urlview.vim' " :Urlview


" any-jump
  Plug 'https://github.com/pechorin/any-jump.vim' " <leader>j


" UltiSnips
" TODO look for alternatives, as it's slow.
  Plug 'https://github.com/sirver/UltiSnips'
  " don't use any expand key (because using `coc-snippets` for)
  let g:UltiSnipsExpandTrigger='<nop>'


" neoterm
  Plug 'https://github.com/kassio/neoterm', {'commit': 'e011fa1'}

  let g:neoterm_default_mod='belowright'
  " autoscroll to the end of the terminal buffer when new commands are sent
  let g:neoterm_autoscroll=1
  let g:neoterm_direct_open_repl=1
  " calling :Tclose or :Ttoggle kills the terminal
  let g:neoterm_keep_term_open=0

  " set REPLs
  if executable('radian')  | let g:neoterm_repl_r='radian'       | endif
  if executable('bpython') | let g:neoterm_repl_python='bpython' | endif

  " send current line and move down
  nnoremap <silent><leader><CR> :TREPLSendLine<CR>
  " send visual selection
  " ('> goes to the beginning of the last line of the last selected Visual
  " area in the current buffer)
  vnoremap <silent><leader><CR> :TREPLSendSelection<CR>'>
  " toggle terminal
  nnoremap <silent><leader>tt :Ttoggle<CR>zz
  tnoremap <silent><leader>tt <C-\><C-n>:Ttoggle<CR>zz


" vim-bufkill (for :BD)
  Plug 'https://github.com/qpkorr/vim-bufkill'
  " don't let bufkill create leader mappings, use Commands instead:
  let g:BufKillCreateMappings=0


" vim-better-whitespace (highlight and remove trailing whitespace)
  Plug 'https://github.com/ntpeters/vim-better-whitespace'
  let g:better_whitespace_ctermcolor='red'
  let g:strip_whitespace_on_save=1


" vim-peekaboo:  " / @ / C-r
  Plug 'https://github.com/junegunn/vim-peekaboo'
  let g:peekaboo_window='botright 35new'
  let g:peekaboo_compact=1
  " don't open immediately, esp. for obvious ones eg. repeating last macro `@@`
  let g:peekaboo_delay=300

  function! s:vim_peekaboo_win()
    setlocal nolist
    setlocal nonumber
    setlocal signcolumn=no
    setlocal colorcolumn=
    setlocal scrolloff=0
    setlocal winhighlight=Normal:Pmenu
  endfunction

  augroup PeekabooWindow
    autocmd!
    autocmd FileType peekaboo call s:vim_peekaboo_win()
  augroup END


" vim-easy-align
  Plug 'https://github.com/junegunn/vim-easy-align'
  " align backslashes in e.g. multi-line bash, C macros etc.:
  let g:easy_align_delimiters={
    \ '\': {'pattern': '\\$'}
  \ }


" git and other VCS

  " fugitive
  Plug 'https://github.com/tpope/vim-fugitive'
  " - ESC closes the window
  autocmd FileType fugitiveblame nnoremap <buffer><silent> <ESC> :q<CR>


  " rhubarb for GitHub (for `:Gbrowse` mainly)
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


" Colors
  Plug 'https://github.com/romainl/Apprentice'
  Plug 'https://github.com/chriskempson/base16-vim'


" FIXME Experimental plugins ----

  Plug 'https://github.com/bfredl/nvim-luadev'
  nmap <leader>l <Plug>(Luadev-RunLine)
  vmap <leader>l <Plug>(Luadev-Run)


call plug#end()


" ----- Colors -------------------------------------------------------------

" General colorscheme
  colorscheme apprentice
  set background=dark
  let g:airline_theme='bubblegum'

" terminal stuff
  source $HOME/dotfiles/nvim/terminal.vim

" Highlight groups
"
" Debug tips:
"   - `verbose hi <Name>` shows where the hi group is set.
"   - Run `:so $VIMRUNTIME/syntax/hitest.vim` to see all highlight groups.
  highlight Todo guibg=#800000 guifg=#d0d090 gui=italic
  highlight Comment gui=italic
  " the vertical split color:
  highlight VertSplit guibg=NONE
  highlight ColorColumn guibg=#1c1c1c
  highlight CursorLine guibg=#1c1c1c


  function! s:quickfix_highlight()
    highlight QuickFixLine gui=bold guifg=Black guibg=DarkGray
  endfunction
  autocmd BufWinEnter quickfix call s:quickfix_highlight()

  function! s:fzf_colors()
    setlocal winhighlight=Normal:Pmenu
  endfunction
  autocmd FileType fzf call s:fzf_colors()

  function! s:tagbar_colors()
    highlight TagbarHighlight guibg=Black
    setlocal winhighlight=Normal:SignColumn
  endfunction
  autocmd FileType tagbar call s:tagbar_colors()


" lua
  lua require('utils')

" #### THE END ####
