ensure_installed = {
  "c",
  "cpp",
  "lua",
  "go",
  "haskell",
  "idris",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "toml",
  "vim",
  "yaml",
  "zig",
}

if vim.fn.executable('tree-sitter') ~= 1 then
  local buf = vim.api.nvim_create_buf(false, true) -- not listed, scratch
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, {
    '',
    '     tree-sitter command not found',
    '     Perhaps you want to install tree-sitter-cli',
    '',
  })

  local gwidth = vim.api.nvim_list_uis()[1].width
  local gheight = vim.api.nvim_list_uis()[1].height
  local width = 60
  local height = 4
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = (gheight - height) * 0.5 - 15,
    col = (gwidth - width) * 0.5,
    border = 'double',
    focusable = true,
  })

  vim.api.nvim_set_option_value('number', false, { win = win })
  vim.api.nvim_set_option_value('relativenumber', false, { win = win })
end

local ts = require('nvim-treesitter')
ts.install(ensure_installed)

vim.api.nvim_create_autocmd('FileType', {
  pattern = ts.get_installed('parsers'),
  callback = function()
    vim.treesitter.start()
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})
