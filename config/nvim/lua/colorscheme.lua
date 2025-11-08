vim.g.tinted_colorspace = 256
require('tinted-colorscheme').with_config({
  supports = {
    tinty = true,
    live_reload = true,
    tinted_shell = false,
  },
})
require('tinted-colorscheme').setup()
