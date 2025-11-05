vim.opt.runtimepath:prepend("~/.vim/,")
vim.opt.runtimepath:append("~/.vim/after")
vim.cmd("let &packpath = &runtimepath")
vim.cmd("source ~/.vim/vimrc")

local function prequire(mod)
  pcall(require(mod))
end

-- loads lazy.nvim
require("config.lazy")

-- load fzf
require('fzf-lua').setup({'fzf-native'})

-- load user configs
prequire('opts')
prequire('keymaps')
prequire('colorscheme')
prequire('treesitter')
prequire('diagnostics')
prequire('completion')
prequire('lsp')
