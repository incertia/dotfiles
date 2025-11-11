local cmp = require('cmp')
local max_signature_len = 80

function completer(fallback)
  if not cmp.visible() then
    cmp.complete()
  end
  fallback()
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  completion = {
    autocomplete = false,
  },
  -- context aware completions
  enabled = function()
    local disabled = false
    local context = require('cmp.config.context')

    disabled = disabled or (vim.bo.buftype == 'prompt')
    disabled = disabled or (vim.fn.reg_recording() ~= '')
    disabled = disabled or (vim.fn.reg_executing() ~= '')
    disabled = disabled or (context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment'))

    return not disabled
  end,
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  }),
  window = {
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ["."] = completer,
    ["->"] = completer,
    ["::"] = completer,
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
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
      cmp.config.compare.order,
      cmp.config.compare.score,
      cmp.config.compare.kind,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
    },
  },
})

local caps = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', { capabilities = caps })

-- setup omnifunc
vim.opt.omnifunc = ""
vim.keymap.set("i", "<C-x><C-o>", function() require('cmp').complete() end, { silent = true, noremap = true })

cmp.event:on('menu_opened', function()
  vim.b.matchup_matchparen_enabled = false
end)
cmp.event:on('menu_closed', function()
  vim.b.matchup_matchparen_enabled = true
end)
