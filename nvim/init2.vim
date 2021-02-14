" Experimental nvim config file - WIP
"
" Start with:
" nvim -u $HOME/dotfiles/nvim/init2.vim
"
" Source config file without loading it.
" :so $HOME/dotfiles/nvim/init2.vim

set termguicolors

call plug#begin('~/.local/share/nvim/plugged2')

Plug 'https://github.com/mhartington/oceanic-next'
let g:oceanic_next_terminal_bold=1
let g:oceanic_next_terminal_italic=1

" --------- Lua plugins ---------

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'https://github.com/kyazdani42/nvim-web-devicons'

" telescope.nvim
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" nnoremap <C-p> <cmd>lua require'telescope.builtin'.find_files{}<CR>
nnoremap <c-p> <cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({  }))<CR>

Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'https://github.com/nvim-lua/completion-nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'https://github.com/norcalli/snippets.nvim'
Plug 'https://github.com/hoob3rt/lualine.nvim'

Plug 'https://github.com/kevinhwang91/nvim-hlslens'


call plug#end()

lua << EOF
	require'lspconfig'.vimls.setup{}
EOF

lua << EOF
	local lualine = require('lualine')
	lualine.status()
EOF

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

" No swap & backups - VCS everywhere
set noswapfile
set nobackup
set nowritebackup

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

nnoremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
            \<Cmd>lua require('hlslens').start()<CR>
nnoremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
            \<Cmd>lua require('hlslens').start()<CR>
nnoremap * *<Cmd>lua require('hlslens').start()<CR>
nnoremap # #<Cmd>lua require('hlslens').start()<CR>
nnoremap g* g*<Cmd>lua require('hlslens').start()<CR>
nnoremap g# g#<Cmd>lua require('hlslens').start()<CR>

" TODO make it work with no cursor style
nnoremap <silent> * :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR><Cmd>lua require('hlslens').start()<CR>
