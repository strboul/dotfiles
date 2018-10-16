
" Auto installation vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" Essentials
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'majutsushi/tagbar'

" git wrapper
Plug 'tpope/vim-fugitive'

" Syntax checkers
" Plug 'vim-syntastic/syntastic'
Plug 'w0rp/ale'

" Auto completion
if has("python3")
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif
" Plug 'Valloric/YouCompleteMe'

" Colors
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'
Plug 'ntpeters/vim-better-whitespace'

" Snippets
if has("python")
	Plug 'SirVer/ultisnips'
endif
"Plug 'honza/vim-snippets'

" Text editing
Plug 'tpope/vim-surround'
Plug 'mbbill/undotree'
Plug 'plasticboy/vim-markdown'

" Distraction-free writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/limelight.vim'

" TeX/LaTeX
Plug 'lervag/vimtex'

" R plugins
Plug 'jalvesaq/Nvim-R'
Plug 'gaalcaras/ncm-R'

call plug#end()

