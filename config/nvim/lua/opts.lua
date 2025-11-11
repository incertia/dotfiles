local opt = vim.opt

-- 2 is a good number
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- spaces
opt.expandtab = true

-- autoindent
opt.autoindent = true

-- show current number + rel numbers
opt.number = true
opt.relativenumber = true

opt.showmode = false
opt.hidden = true

-- i hate search highlighting
opt.hlsearch = false

opt.splitbelow = true
opt.splitright = true

-- magic
opt.cinoptions = "g0,:0,(0,W1s,E-s"

-- appearance related settings
opt.title = true
opt.scrolloff = 2
opt.wrap = true
opt.showmatch = true -- matches parens/braces/brackets
opt.textwidth = 80
opt.laststatus = 2
opt.list = true     -- shows trailing whitespace/tabs
opt.listchars = "tab:| ,trail:."
opt.cmdheight = 2

-- if any keymaps share the same prefix, e.g. <leader>r and <leader>rr, this
-- will forcibly execute <leader>r
--
-- this is a temporary hack until i figure out what to do with nvim-cmp's insert
-- mode mappings not being nowait
opt.timeoutlen = 0

-- equivalent of :syntax on
opt.syntax = "on"
opt.mouse = ""

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
