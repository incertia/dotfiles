-- setup an autocommand to fix bufcount in tabs
vim.api.nvim_create_autocmd(
  { 'User' },
  {
    pattern = { 'TintedColorsPost' },
    callback = function()
      local colors = require('tinted-colorscheme').colors
      vim.cmd('hi clear MatchParen')
      vim.cmd('hi MatchParen gui=bold,underline guifg=' .. colors.base16)
      --vim.cmd('call Tinted_Hi("Title", g:tinted_gui0E, "", g:tinted_cterm0E, "")')
      --vim.cmd('call Tinted_Hi("TabLineSel", "", g:tinted_gui02, "", g:tinted_cterm02)')
      --vim.cmd('call Tinted_Hi("Todo", g:tinted_gui08, "", g:tinted_cterm08, "", "bold")')
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
