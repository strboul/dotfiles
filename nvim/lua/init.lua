require("utils")

vim.cmd("colorscheme slate") -- colorscheme OceanicNext

--Plug 'https://github.com/mhartington/oceanic-next'
-- let g:oceanic_next_terminal_bold=1
-- let g:oceanic_next_terminal_italic=1
--
-- function! s:oceanic_next_tweak()
  -- highlight Comment gui=italic
  -- highlight SignColumn guibg=#1c1c1c
  -- highlight Todo guibg=#800000 guifg=#d0d090
-- endfunction

-- augroup colorschemes
  -- autocmd!
  -- autocmd VimEnter,ColorScheme * call s:oceanic_next_tweak()
-- augroup END

-- Plug 'https://github.com/kyazdani42/nvim-web-devicons'

-- Plug 'https://github.com/hoob3rt/lualine.nvim'
-- local lualine = require('lualine')
-- lualine.status()

-- Plug 'https://github.com/kevinhwang91/nvim-hlslens'

vim.cmd("source $HOME/dotfiles/nvim/essential.vim")
vim.cmd("source $HOME/dotfiles/nvim/filetypes.vim")
vim.cmd("source $HOME/dotfiles/nvim/mappings.vim")
vim.cmd("source $HOME/dotfiles/nvim/autocmds.vim")
vim.cmd("source $HOME/dotfiles/nvim/terminal.vim")
