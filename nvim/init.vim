
""" ----------------------------------------------------------------------------
""" General vim settings
""" ----------------------------------------------------------------------------

" Essentials
	set nocompatible
	set encoding=utf-8

" Leader key
	let mapleader=","

" swap files recorded in tmp
	set dir=/tmp/

" vv selects the whole line in v.mode
	noremap vv 0v$

" Always show the status bar
	set laststatus=2

" Switch buffers without saving a file
	set hidden

" CTRL+L remapped to nohl
	nnoremap <C-l> :nohlsearch<CR><C-l>:echo "Search cleared"<CR>

" Yank from buffer to clipboard
"	set clipboard+=unnamedplus

" Set relative numbers
	" nnoremap <C-c> :set norelativenumber<CR>:set nonumber<CR>:echo "Line numbers turned off."<CR>
	" nnoremap <C-n> :set relativenumber<CR>:set number<CR>:echo "Line numbers turned on."<CR>
	set relativenumber
	set number

" Case insensitive search
	set ignorecase
	set smartcase

" Open a new (h-/v-)splits right and below side:
	set splitright
	set splitbelow

" Word wrapping
	set textwidth=80

" Backspace, cursor, misc
	syntax on
	set backspace=indent,eol,start
	set cursorline
	set mouse=a
	set incsearch

" Use indendation of previous line
	set autoindent

" Set <Enter> key to add new line in vim command mode
	map <Enter> o<ESC>
	map <S-Enter> O<ESC>

" Move between windows
" Source__ https://github.com/junegunn/dotfiles/blob/master/vimrc#L381
	nnoremap <tab>   <c-w>w
	nnoremap <S-tab> <c-w>W

" Call language specific tabs
	so ~/dotfiles/nvim/filetypes.vim

" Map ESC key to 'jj' as it is not possible to completely disable it (use CTRL+[
" instead -- but note that CTRL+C isn't the same as CTRL+[).
" https://vi.stackexchange.com/questions/3225/disable-esc-but-keep-c/3570
	inoremap jj <Esc>

" Timeout when press on ESC to switch from Insert to Normal mode
" If use nvim with tmux, be sure tmux.conf has: `set -s escape-time 0`
	set timeout timeoutlen=1000 ttimeoutlen=0

""" ----------------------------------------------------------------------------
""" Plugin based settings
""" ----------------------------------------------------------------------------

" Plugins source
	so ~/dotfiles/nvim/plugins.vim

" Set color scheme
	colo seoul256
	let g:seoul256_background = 234

" NERDTree settings
	nnoremap <leader>n :NERDTreeToggle<CR>
	" Show hidden (dot) files
	let NERDTreeShowHidden=1
	" Ignore some files in NERDTree
	let NERDTreeIgnore=['\.git$', '\.DS_Store$', '\.Rhistory$']
	" Show bookmarks on start
	let NERDTreeShowBookmarks=1
	" Click nodes with a single mouse click (not double)
	let g:NERDTreeMouseMode=3
	" Close tab after opening file
	let NERDTreeQuitOnOpen=1

" Map fzf Commands to the leader
	nnoremap <leader>c :Commands<CR>

" Vim TagBar
	" Set a specific ctags location as we install utags as uctags:
	"" How to remove ^@ character system(): https://vi.stackexchange.com/a/17707
        let g:tagbar_ctags_bin=substitute(system("command -v uctags"), '\n', '', 'g')
	" no sorting. display tags in the order as they appear in the source code:
        let g:tagbar_sort = 0

" NERDCommenter
	filetype plugin on "enable it
	let NERDSpaceDelims=1 "add an extra space after comment symbol

" Vim airline theme
	let g:airline_theme='bubblegum'
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#left_alt_sep = '|'

" Trailing whitespace
	highlight ExtraWhitespace ctermbg='red'
	let g:strip_whitespace_on_save = 1

" UltiSnips
	" Don't change that. Instead, we do sym linking to: .config/nvim/
	" let g:UltiSnipsSnippetDirectories=[$HOME.'/dotfiles/nvim/UltiSnips']

" Distraction free mode function
	function! GoyoMode()
		call goyo#execute(0, [])
		" Goyo
		let g:goyo_width = 100
		let g:goyo_height = 90
		" seoul256
		let g:seoul256_background = 234
		colo seoul256
		" UndoTree
		let g:undotree_CustomUndotreeCmd = 'vertical 32 new'
		let g:undotree_CustomDiffpanelCmd= 'belowright 12 new'
	endfunction
	command! GoyoMode call GoyoMode()
	nmap \p :GoyoMode<CR>

" vim-markdown folding disable
	let g:vim_markdown_folding_disabled = 1

" Disable R_assign <- placement by (_) underscore Nvim-R
	let R_assign = 0

" Map fzf :Files to <leader>-f
	nnoremap <leader>f :Files<CR>

" Use deoplete.
	if exists("deoplete")
		let g:deoplete#enable_at_startup = 1
	endif

" vim: set ts=2 sw=2
