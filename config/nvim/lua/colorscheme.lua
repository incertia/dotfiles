-- setup an autocommand to fix bufcount in tabs
vim.api.nvim_create_autocmd(
  { 'User' },
  {
    pattern = { 'TintedColorsPost' },
    callback = function()
      local colors = require('tinted-colorscheme').colors
      vim.cmd('hi clear MatchParen')
      vim.cmd('hi MatchParen gui=bold,underline guifg=' .. colors.base16)
      vim.cmd('hi LspReferenceText gui=underline guibg=' .. colors.base02)
      vim.cmd('hi LspReferenceRead gui=underline guibg=' .. colors.base02)
      vim.cmd('hi LspReferenceWrite gui=underline guibg=' .. colors.base02)
      vim.cmd('hi LspReferenceTarget gui=underline guibg=' .. colors.base02)

      -- clear highlighting for variables, these can just be normal
      vim.cmd('hi clear TSVariable')
    end
  }
)

-- vim.g.tinted_italic = 0
vim.g.tinted_colorspace = 256
require('tinted-colorscheme').with_config({
  supports = {
    tinty = true,
    live_reload = true,
    tinted_shell = false,
  },
})
require('tinted-colorscheme').setup()
