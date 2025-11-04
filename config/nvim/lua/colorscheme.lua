-- setup an autocommand to fix bufcount in tabs
vim.api.nvim_create_autocmd(
  { 'ColorScheme' },
  {
    pattern = { 'base*-tomorrow-night' },
    callback = function()
      vim.cmd('call Tinted_Hi("Title", g:tinted_gui0E, "", g:tinted_cterm0E, "")')
      vim.cmd('call Tinted_Hi("TabLineSel", "", g:tinted_gui02, "", g:tinted_cterm02)')
      vim.cmd('call Tinted_Hi("Todo", g:tinted_gui08, "", g:tinted_cterm08, "", "bold")')
    end
  }
)

-- vim.g.tinted_italic = 0
vim.g.tinted_colorspace = 256
vim.cmd.colorscheme('base24-tomorrow-night')
