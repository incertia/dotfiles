require('fzf-lua').setup({
  'fzf-native',
  files = {
    no_ignore = true,
    follow = true,
    hidden = true,
    rg_opts = [[--color=never --hidden --files -g "!.git" -g "!.cache"]],
  },
  grep = {
    no_ignore = true,
    follow = true,
    hidden = true,
  },
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept"
    },
  },
})
