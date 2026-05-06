-- setup an autocommand to fix bufcount in tabs
vim.api.nvim_create_autocmd(
  { 'ColorScheme' },
  {
    pattern = { '*-tomorrow-night' },
    callback = function()
      local colors = require('tinted-nvim').get_palette()
      vim.cmd('hi clear MatchParen')
      vim.cmd('hi MatchParen gui=bold,underline guifg=' .. colors.base16)
      vim.cmd('hi LspReferenceText gui=underline guibg=' .. colors.base02)
      vim.cmd('hi LspReferenceRead gui=underline guibg=' .. colors.base02)
      vim.cmd('hi LspReferenceWrite gui=underline guibg=' .. colors.base02)
      vim.cmd('hi LspReferenceTarget gui=underline guibg=' .. colors.base02)
      vim.cmd('hi DiffAdd guibg=NONE guifg=' .. colors.base0B)
      vim.cmd('hi DiffDelete guibg=NONE guifg=' .. colors.base08)
      vim.cmd('hi LineNr guibg=NONE guifg=' .. colors.base03)
      vim.cmd('hi CursorLineNr guibg=NONE guifg=' .. colors.base05)

      -- clear highlighting for variables, these can just be normal
      vim.cmd('hi clear TSVariable')
    end
  }
)

-- vim.g.tinted_italic = 0
vim.g.tinted_colorspace = 256
require('tinted-nvim').setup({
  selector = {
    enabled = true,
  },
  overrides = function(colors)
    return {
      DiffAdd = {
        fg = colors.base0c,
        bg = nil,
      },
    }
  end,
})
