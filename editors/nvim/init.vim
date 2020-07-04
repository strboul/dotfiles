""" ---------------------------------------------------------------------------
""" General vim settings
""" ---------------------------------------------------------------------------

" Essentials
  set nocompatible
  set encoding=utf-8
  filetype plugin on
  syntax on
  set backspace=indent,eol,start " make backspace key better
  set cursorline " horizontal cursor bar for the current line
  set mouse=a " enable mouse use (if the terminal supports)


  " term guicolors
  if has('termguicolors')
    " for vim inside tmux
    let &t_8f='\<Esc>[38;2;%lu;%lu;%lum'
    let &t_8b='\<Esc>[48;2;%lu;%lu;%lum'
    set termguicolors
  endif


" Leader key
  let mapleader=','


" always add spaces when tab
  set expandtab


" Searching
  set ignorecase " case insensitive search
  set smartcase " case-sensitive if upper-case chars exists in search term
  set incsearch " start matching as soon as something is typed


" don't freely move the cursor as it messes up the yanking
  set virtualedit=""


" No swap & backups
  set noswapfile
  set nobackup
  set nowritebackup


" Always show the status bar
  set laststatus=2
" Always show the tab bar
  set showtabline=2
" Don't show mode (e.g. Insert, Visual) in command, rely on the status bar
  set noshowmode


" Off the scroll lines a bit when scrolling down
  set scrolloff=1


" Can switch buffers without saving files
  set hidden


" Disable paste mode (see `:help paste`)
  set nopaste


" Default (4000 ms ~ 4 s) is too slow. And very low value may slow vim down.
  set updatetime=750


" Auto save on focus out.
" (https://github.com/justinforce/dotfiles/blob/master/files/nvim/init.vim#L82)
  autocmd BufLeave,CursorHold,CursorHoldI,FocusLost * silent! wa


" Trigger autoread when changing buffers or coming back to vim.
" (https://stackoverflow.com/a/20418591)
  autocmd FocusGained,BufEnter * :silent! !


" ctrl+l clears the latest search
  nnoremap <C-l> :nohlsearch<CR><C-l>:echo 'Search cleared'<CR>


" Use // to search for visually selected text
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
  vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>


" Set system clipboard for yank/put/delete
  set clipboard+=unnamedplus


" ESC turns neovim terminal to normal mode
  tnoremap <Esc> <C-\><C-n>
" Ctrl+w window navigation returns to normal mode
  tnoremap <C-w> <C-\><C-n> <C-w>


" Set relative numbers
  set relativenumber
  set number


" Always open a new (h-/v-)splits right and below side:
  set splitright
  set splitbelow


" Don't wrap and set a vertical reference
  set nowrap
" darken the screen after the 80th char
  let &colorcolumn='80,'.join(range(80,999),',')


" Use indendation of previous line
  set autoindent


" Remap those to add new line in vim normal mode
  nnoremap o o<Esc>
  nnoremap O O<Esc>


" Always show the signcolumn for e.g. linting, diagnostics etc.
  set signcolumn=yes


" Mark space and tab chars
  set list
  set listchars=tab:\¦\ ,space:␣


" Remove buffer without losing the split window
" `:bdkw` (buffer delete keep window)
" https://stackoverflow.com/a/4468491
  command Bdkw :bp|bd #


" Language specific configs
  so ~/dotfiles/editors/nvim/filetypes.vim


" R (rstats)
" don't span arguments when indenting (see :help ft-r-indent)
  let r_indent_align_args=0
  let r_indent_ess_compatible=1


" Timeout when press on ESC to switch from Insert to Normal mode
" If use nvim with tmux, be sure tmux.conf has: `set -s escape-time 0`
  set timeout timeoutlen=1000 ttimeoutlen=0


""" ---------------------------------------------------------------------------
""" Plugins
""" ---------------------------------------------------------------------------


" Auto installation vim-plug
  " TODO is it still relevant?
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

  " search files starting from the root of the currently open buffer
  nnoremap <silent> <C-g> :Files %:p:h<cr>
  nnoremap <silent> <c-b> :Buffers<CR>

  " search lines in current buffer.
  nnoremap <silent> <leader>l :BLines<CR>


" NERDTree
  Plug 'https://github.com/scrooloose/nerdtree'

  " position of NERDTree panel
  let NERDTreeWinPos='right'
  " show hidden (dot) files
  let NERDTreeShowHidden=1
  " ignore some files in NERDTree
  let nerd_others=['^\.vim$', '^\.git$', '\.DS_Store$']
  let nerd_r=['\.Rhistory$', '\.Rproj\.user$']
  let nerd_py=['__pycache__$']
  let NERDTreeIgnore=nerd_others+nerd_r+nerd_py
  " hide help panel on the top
  let NERDTreeMinimalUI=1
  " click nodes with a single mouse click (not double)
  let g:NERDTreeMouseMode=3
  " close tab after opening file
  let NERDTreeQuitOnOpen=1

  " toggle NERDTree window with pre-selecting the file opened in the current
  " buffer
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
  Plug 'https://github.com/scrooloose/nerdcommenter'

  " add an extra space after comment symbol
  let NERDSpaceDelims=1


" vim-airline
" (100% vim script. Better than 'vim-powerline' requiring python)
  Plug 'https://github.com/vim-airline/vim-airline'
  Plug 'https://github.com/vim-airline/vim-airline-themes'

  let g:airline#extensions#tabline#enabled=1
  let g:airline#extensions#tabline#left_alt_sep='|'


" coc.nvim
  Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}

  function ReadCocExtensionsFile()
    let s:file=readfile(glob('~/dotfiles/editors/nvim/coc-extensions.txt'))
    " filter out commented and empty lines:
    let s:coc_exts=filter(filter(s:file, 'v:val !~ "^#"'), 'v:val !~ "^\s*$"')
    return s:coc_exts
  endfunction
  let g:coc_global_extensions=ReadCocExtensionsFile()

  so ~/dotfiles/editors/nvim/coc.vim


" UltiSnips
  Plug 'https://github.com/sirver/UltiSnips'


" neoterm
  Plug 'https://github.com/kassio/neoterm', {'commit': 'e011fa1'}

  let g:neoterm_default_mod='belowright'
  let g:neoterm_size=16
  let g:neoterm_autoscroll=1
  let g:neoterm_direct_open_repl=1
  " calling :Tclose or :Ttoggle kills the terminal
  let g:neoterm_keep_term_open=0
  " set REPLs
  if executable('radian')
    let g:neoterm_repl_r='radian'
  endif
  " send current line and move down
  nnoremap <silent><leader><cr> :TREPLSendLine<cr>j
  " send current selection
  " ('> goes to the last selected Visual area in the current buffer)
  vnoremap <silent><leader><cr> :TREPLSendSelection<cr>'>j
  " toggle terminal
  nnoremap <silent><c-t><c-t> :Ttoggle<CR>
  tnoremap <silent><c-t><c-t> <C-\><C-n>:Ttoggle<CR>


" vim-slime
  Plug 'https://github.com/jpalardy/vim-slime'

  " Have a target with SlimeConfig as e.g. 0.1 (<win idx>.<pane idx)
  let g:slime_target='tmux'


" vim-better-whitespace (highlight and remove trailing whitespace)
  Plug 'https://github.com/ntpeters/vim-better-whitespace'

  let g:better_whitespace_ctermcolor='red'
  let g:strip_whitespace_on_save=1


" vim-bookmarks
  Plug 'https://github.com/MattesGroeger/vim-bookmarks'

  if has('multi_byte')
    let g:bookmark_sign='🚩'
    let g:bookmark_annotation_sign='⛳'
  else
    let g:bookmark_sign='B'
    let g:bookmark_annotation_sign='A'
  endif

  let g:bookmark_auto_close=1
  let g:bookmark_show_warning=1
  let g:bookmark_show_toggle_warning=1
  let g:bookmark_disable_ctrlp=1


" vim-easy-align
  Plug 'https://github.com/junegunn/vim-easy-align'


" vim-indent-guides
  Plug 'https://github.com/nathanaelkane/vim-indent-guides'


" vim-fugitive (git and other VCS)
  Plug 'https://github.com/tpope/vim-fugitive'


" vim-polyglot (syntax highlighting)
  Plug 'https://github.com/sheerun/vim-polyglot'


" vim-markdown
  Plug 'https://github.com/plasticboy/vim-markdown'

  " disable code-folding
  let g:vim_markdown_folding_disabled=1


" ale (syntax checker)
  " it's still useful for some checks, e.g. shellcheck for bash/zsh
  Plug 'https://github.com/dense-analysis/ale'

  " disable linting on some files
  " https://github.com/dense-analysis/ale/issues/371#issuecomment-304313091
  let g:ale_pattern_options={
    \  '.R$': {'ale_enabled': 0},
    \  '.Rmd$': {'ale_enabled': 0}
  \}


" vim-highlightedyank
  Plug 'https://github.com/machakann/vim-highlightedyank'

  " redefine highlight yank time
  let g:highlightedyank_highlight_duration=2500


" vim-diminactive
  " Plug 'https://github.com/blueyed/vim-diminactive'

  " let g:diminactive_use_syntax=1


" Nvim-R
  Plug 'https://github.com/jalvesaq/Nvim-R'

  " Disable R_assign `<-` placement by (_) underscore
  let R_assign=0
  " Make Nvim-R's wd same as the neovim's wd
  let R_nvim_wd=1
  " Show R documentation in new tab
  let R_nvimpager='tabnew'
  " set a minimum source editor width
  let R_min_editor_width=80
  " make sure the console is at the bottom by making it really wide
  let R_rconsole_width=1000
  " Don't expand a dataframe columns by default in the object browser (\ro)
  let R_objbr_opendf=0
  " Radian support (https://github.com/randy3k/radian#nvim-r-support)
  if executable('radian')
    let R_app='radian'
    let R_cmd='R'
    let R_hl_term=0
    let R_bracketed_paste=1
  endif


" Colors
  Plug 'https://github.com/altercation/vim-colors-solarized'
  Plug 'https://github.com/junegunn/seoul256.vim'
  Plug 'https://github.com/arcticicestudio/nord-vim'
  Plug 'https://github.com/chriskempson/base16-vim'
  Plug 'https://github.com/romainl/Apprentice'


call plug#end()

""" ---------------------------------------------------------------------------
""" Color
""" ---------------------------------------------------------------------------

""" Color schemes
  " colorscheme seoul256
  " let g:airline_theme='base16'
  " colorscheme nord
  colorscheme apprentice
  set background=dark
  let g:airline_theme='bubblegum'


" #### THE END ####

" vim: ts=2 sw=2 et
