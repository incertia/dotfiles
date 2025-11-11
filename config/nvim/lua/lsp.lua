-- enable LSP files (see config/lsp/*.lua)
vim.lsp.enable('clangd')
vim.lsp.enable('hls')
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
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
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
    -- Prefer LSP folding if client supports it
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
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
    km("n", "<leader>rr", function() vim.lsp.buf.references(nil, {
      on_list = function(items, title, context)
        vim.fn.setqflist({}, ' ', items)
        local l = vim.fn.getqflist()
        print(#l .. " references")
        local success, fzf = pcall(require, 'fzf-lua')
        if success == true then
          fzf.quickfix()
        end
      end,
    }) end, opts)

    -- by default, [d and ]d go to the previous and next diagnostic
    km("n", "<leader>dd", function() vim.diagnostic.open_float({ desc = "Diagnostics" }) end, opts)
    km("n", "<leader>dv", function() vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text }) end, opts)
    km("n", "<leader>dl", function() vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines }) end, opts)

    -- use cmp for <C-x><C-o> omni
    -- vim.opt.omnifunc = ""
    -- km("i", "<C-x><C-o>", function() require('cmp').complete() end, opts)

    if client.server_capabilities.documentHighlightProvider then
      local doc_highlight = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      km("n", "<leader>h", function()
        vim.lsp.buf.document_highlight()
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = doc_highlight }
        vim.api.nvim_create_autocmd("CursorMoved", {
          callback = function()
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { buffer = bufnr, group = doc_highlight }
          end,
          buffer = bufnr,
          group = doc_highlight,
          desc = "clear all the references",
        })
        end, opts)
    end
  end,
})
