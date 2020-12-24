" Experimental nvim config file - WIP
"
" Start with:
" nvim -u $HOME/dotfiles/nvim/init2.vim
"
" Source config file without loading it.
" :so $HOME/dotfiles/nvim/init2.vim

set termguicolors

call plug#begin('~/.local/share/nvim/plugged2')

Plug 'https://github.com/strboul/urlview.vim'

" disable arrow keys
Plug 'https://github.com/wikitopian/hardmode'
let g:HardMode_level='wannabe'
let g:HardMode_hardmodeMsg=''
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()


Plug 'https://github.com/junegunn/vim-peekaboo'
let g:peekaboo_window='botright 35new'
let g:peekaboo_compact=1
let g:peekaboo_delay=300


Plug 'https://github.com/mhartington/oceanic-next'
let g:oceanic_next_terminal_bold=1
let g:oceanic_next_terminal_italic=1


Plug 'https://github.com/itchyny/lightline.vim'
Plug 'https://github.com/itchyny/vim-gitbranch'

let g:lightline={
  \ 'colorscheme': 'wombat',
  \ 'enable': {
  \   'statusline': 1,
  \   'tabline': 1
  \ }
  \ }

function! LightlineModified()
  return &ft =~# 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler' && &readonly ? 'RO' : ''
endfunction
function! LightlineFullFilename()
  return (LightlineReadonly() !=# '' ? LightlineReadonly() . ' ' : '') .
    \ (&ft ==# 'vimfiler' ? vimfiler#get_status_string() :
    \  &ft ==# 'unite' ? unite#get_status_string() :
    \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]') .
    \ (LightlineModified() !=# '' ? ' ' . LightlineModified() : '')
endfunction

let g:lightline.component_function={
  \ 'gitbranch': 'gitbranch#name',
  \ 'fullfilename': 'LightlineFullFilename'
  \ }

let g:lightline.active={
  \ 'left': [ [ 'mode', 'paste' ],
  \           [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ }
let g:lightline.inactive = {
  \ 'left': [ [ 'filename' ] ]
  \ }

let g:lightline.separator={'left':"\ue0b0",'right':"\ue0b2"}
let g:lightline.subseparator={'left':"\ue0b1",'right':"\ue0b3"}


" --------- Lua plugins ---------

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'https://github.com/kyazdani42/nvim-web-devicons'

" telescope.nvim
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" nnoremap <C-p> <cmd>lua require'telescope.builtin'.find_files{}<CR>
nnoremap <c-p> <cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({  }))<CR>

" Plug 'romgrk/barbar.nvim'
" let bufferline={}
" let bufferline.animation=v:false
" let bufferline.closable=v:false
" let bufferline.maximum_padding=1

" Plug 'akinsho/nvim-bufferline.lua'

Plug 'https://github.com/neovim/nvim-lspconfig'

Plug 'https://github.com/nvim-lua/completion-nvim'

Plug 'norcalli/nvim-colorizer.lua'

Plug 'https://github.com/norcalli/snippets.nvim'

Plug 'https://github.com/tjdevries/express_line.nvim'

call plug#end()

lua << EOF
require'lspconfig'.vimls.setup{}
EOF


"lua << EOF
"  require'bufferline'.setup{
"    options = {
"      numbers = "buffer_id",
"      number_style = "",
"      show_buffer_close_icons = false,
"      separator_style = "thin",
"    }
"  }
"EOF


lua require'colorizer'.setup()


lua require'snippets'.use_suggested_mappings()

" <c-k> will either expand the current snippet at the word or try to jump to
" the next position for the snippet.
inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>

" <c-j> will jump backwards to the previous field.
" If you jump before the first field, it will cancel the snippet.
inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>

lua << EOF
require'snippets'.snippets = {
  -- The _global dictionary acts as a global fallback.
  -- If a key is not found for the specific filetype, then
  --  it will be lookup up in the _global dictionary.
  _global = {
    -- Insert a basic snippet, which is a string.
    todo = "TODO(metin): ";

    uname = function() return vim.loop.os_uname().sysname end;
    date = os.date;
  }
}
EOF


set statusline+=%{nvim_treesitter#statusline(65)}

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true
  },
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()


" --- Colors ---
colorscheme OceanicNext

" TODO create nvim/essential.vim
let mapleader=','
set mouse=a
set hidden
" don't show tabline (experimental)
set laststatus=2
set showtabline=0
set signcolumn=yes
set noshowmode
set cursorline
set splitright
set splitbelow

source $HOME/dotfiles/nvim/filetypes.vim
source $HOME/dotfiles/nvim/mappings.vim
source $HOME/dotfiles/nvim/autocmds.vim
source $HOME/dotfiles/nvim/terminal.vim

function! s:oceanic_next_tweak()
  highlight Comment gui=italic
  highlight SignColumn guibg=#1c1c1c
  highlight Todo guibg=#800000 guifg=#d0d090
endfunction

augroup colorschemes
  autocmd!
  autocmd VimEnter,ColorScheme * call s:oceanic_next_tweak()
augroup END
