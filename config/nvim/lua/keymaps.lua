local km = vim.keymap.set

-- fzf
km("n", "<C-\\>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
-- km("n", "<C-k>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {})
km("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
km("n", "<C-m>", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]], {})
km("n", "<C-g>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
-- km("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})

-- remap : to ;
km({ "n", "v" }, ";", ":", { noremap = true })
km({ "n", "v" }, ":", ";", { noremap = true })

-- setup <C-f> <C-b> <C-u> <C-d> to center
km({ "n", "v" }, "<C-f>", "<C-f>zz", { silent = true, noremap = true })
km({ "n", "v" }, "<C-b>", "<C-b>zz", { silent = true, noremap = true })
km({ "n", "v" }, "<C-u>", "<C-u>zz", { silent = true, noremap = true })
km({ "n", "v" }, "<C-d>", "<C-d>zz", { silent = true, noremap = true })

-- remap v and <C-v> because visual block is much better than visual
km({ "n", "v" }, "v", "<C-v>", { silent = true, noremap = true })
km({ "n", "v" }, "<C-v>", "v", { silent = true, noremap = true })

-- set scroll up to <C-q> so scrolling is done via q and e
km({ "n", "v" }, "<C-q>", "<C-y>", { silent = true, noremap = true })

-- use <C-{h,j,k,l}> to navigate splits
km("n", "<C-h>", "<C-w>h", { silent = true, noremap = true })
km("n", "<C-j>", "<C-w>j", { silent = true, noremap = true })
km("n", "<C-k>", "<C-w>k", { silent = true, noremap = true })
km("n", "<C-l>", "<C-w>l", { silent = true, noremap = true })

-- use mapleader instead <C-w> to control split width/heights
km("n", "<leader>-", "<C-w>-", { silent = true, noremap = true })
km("n", "<leader>+", "<C-w>+", { silent = true, noremap = true })
km("n", "<leader><", "<C-w><", { silent = true, noremap = true })
km("n", "<leader>>", "<C-w>>", { silent = true, noremap = true })

-- use <M-{j,k}> to navigate quickfix
km("n", "<M-j>", "<cmd>cnext<CR>", { silent = true, noremap = true })
km("n", "<M-k>", "<cmd>cprev<CR>", { silent = true, noremap = true })
