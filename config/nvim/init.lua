vim.opt.runtimepath:prepend("~/.vim/,")
vim.opt.runtimepath:append("~/.vim/after")
vim.cmd("let &packpath = &runtimepath")
vim.cmd("source ~/.vim/vimrc")

-- loads lazy.nvim
require("config.lazy")

-- load fzf
require('fzf-lua').setup({'fzf-native'})

-- load user configs
require('opts')
require('keymaps')
require('lsp')
require('colorscheme')
