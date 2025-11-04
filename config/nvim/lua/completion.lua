local cmp = require('cmp')
local max_signature_len = 80

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  }),
  window = {
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  formatting = {
    format = function(entry, vim_item)
      -- set the signature field to empty if it exists
      if vim_item.menu ~= nil then
        local len = string.len(vim_item.menu)
        if len > max_signature_len then
          vim_item.menu = string.sub(vim_item.menu, 0, max_signature_len - 2) .. "…" .. string.sub(vim_item.menu, -1)
        end
      end
      return vim_item
    end
  },
  sorting = {
    comparators = {
      cmp.config.compare.kind,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.order,
    },
  },
})

local caps = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', { capabilities = caps })
