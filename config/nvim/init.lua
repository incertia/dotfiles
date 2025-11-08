vim.opt.runtimepath:prepend("~/.vim/,")
vim.opt.runtimepath:append("~/.vim/after")
vim.cmd("let &packpath = &runtimepath")
vim.cmd("source ~/.vim/vimrc")

local error = false
local errors = ""
local function prequire(mod)
  success, result = pcall(require, mod)
  if success == false then
    error = true
    errors = errors .. result
  end
end

-- loads lazy.nvim
require("config.lazy")

-- load fzf
prequire('fzf')

-- load user configs
prequire('opts')
prequire('keymaps')
prequire('colorscheme')
prequire('treesitter')
prequire('matchup')
prequire('diagnostics')
prequire('completion')
prequire('lsp')

if error then
  vim.notify(errors, vim.log.levels.ERROR)
end
