-- TODO try plenary.path for the paths https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/path.lua
local dotfiles_path = os.getenv("HOME") .. "/dotfiles/nvim/lua"
package.path = package.path .. dotfiles_path
require("utils")
require("plugins")

-- Neovim automatically runs :PackerCompile whenever plugins.lua is updated:
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

vim.cmd([[colorscheme OceanicNext]])

-- required vim files
vim.cmd("source $HOME/dotfiles/nvim/essential.vim")
vim.cmd("source $HOME/dotfiles/nvim/filetypes.vim")
vim.cmd("source $HOME/dotfiles/nvim/mappings.vim")
vim.cmd("source $HOME/dotfiles/nvim/autocmds.vim")
vim.cmd("source $HOME/dotfiles/nvim/terminal.vim")
