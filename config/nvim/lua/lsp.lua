-- enable LSP files (see config/lsp/*.lua)
vim.lsp.enable('clangd')
vim.lsp.enable('rust-analyzer')
vim.lsp.enable('zls')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
    end
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars
      -- vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      --
      -- NOTE: completion should be given by cmp
    end
    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    local km = vim.keymap.set
    local opts = { silent = true, buffer = bufnr };

    -- fix hover and signature_help
    km("n", "K", function() vim.lsp.buf.hover { border = "double" } end, opts)
    km("i", "<C-s>", function() vim.lsp.buf.signature_help { border = "double" } end, opts)

    -- use mapleader bindings
    km("n", "<leader><F2>", function() vim.lsp.buf.rename() end, opts)
    km("n", "<leader>ca", function() require('tiny-code-action').code_action() end, opts)
    km("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
    km("n", "<leader>gD", function() vim.lsp.buf.declaration() end, opts)
    km("n", "<leader>gt", function() vim.lsp.buf.type_definition() end, opts)
    km("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)

    -- by default, [d and ]d go to the previous and next diagnostic
    km("n", "<leader>dd", function() vim.diagnostic.open_float({ desc = "Diagnostics" }) end, opts)
    km("n", "<leader>dv", function() vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text }) end, opts)
    km("n", "<leader>dl", function() vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines }) end, opts)

    -- use cmp for <C-x><C-o> omni
    vim.opt.omnifunc = ""
    km("i", "<C-x><C-o>", function() require('cmp').complete() end, opts)
  end,
})
