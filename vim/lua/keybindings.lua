-- *******************
-- Keybindings
-- *******************

local map = vim.keymap.set

-- Basic motion improvements
map("n", "U", "<C-R>", { desc = "Redo" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "H", "0", { desc = "Go to beginning of line" })
map("n", "L", "$", { desc = "Go to end of line" })
map("v", "J", "10j", { desc = "Move 10 lines down" })
map("v", "K", "10k", { desc = "Move 10 lines up" })
map("n", "J", "10j", { desc = "Move 10 lines down" })
map("n", "K", "10k", { desc = "Move 10 lines up" })
map("n", "<tab>", "%", { desc = "Jump to matching bracket" })
map("v", "<tab>", "%", { desc = "Jump to matching bracket" })
map("o", "<tab>", "%", { desc = "Jump to matching bracket" })

-- Diagnostics
map("n", "<leader>va", vim.lsp.buf.code_action, { desc = "View code actions" })
map("n", "<leader>vd", function()
  vim.diagnostic.open_float(nil, { focusable = true, max_height = 20 })
end, { desc = "View line diagnostics" })
map("n", "<leader>vD", function()
  vim.diagnostic.open_float(0, { focusable = true, max_height = 20, scope = "buffer" })
end, { desc = "View buffer diagnostics" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })
map("n", "<leader>dj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dk", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- LSP
map("n", "<leader>vs", vim.lsp.buf.hover, { desc = "View signature/hover" })
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>vr", "<cmd>Telescope lsp_references<CR>", { desc = "View references" })

-- Telescope
map("n", "<leader>th", "<cmd>Telescope colorscheme<CR>", { desc = "Theme picker" })
map("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Search help" })
map("n", "<leader>sc", "<cmd>Telescope commands<CR>", { desc = "Search commands" })
map("n", "<leader>p", "<cmd>Telescope frecency<CR>", { desc = "Find files (frecency)" })
map("n", "<leader>ag", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

-- File navigation
map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
map("n", "<C-g>", "<cmd>CopyGitRelPath<CR>", { desc = "Copy git-relative path" })

-- Git
map("n", "<leader>vpr", "<cmd>GHSearchPRs<CR>is:open", { desc = "Search open PRs" })
map("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })

-- Surround shortcuts (via vim-surround)
map("n", '<leader>"', 'ysiw"', { desc = "Surround word with quotes", remap = true })
map("n", "<leader>'", "ysiw'", { desc = "Surround word with single quotes", remap = true })
map("n", "<leader>)", "ysiw)", { desc = "Surround word with parens", remap = true })
map("n", "<leader>]", "ysiw]", { desc = "Surround word with brackets", remap = true })
map("n", "<leader>}", "ysiw}", { desc = "Surround word with braces", remap = true })

-- Misc
map("n", "<leader>yw", "yiww", { desc = "Yank inner word" })
map("v", "<leader>yw", "yiww", { desc = "Yank inner word" })
map("n", "Q", "@q", { desc = "Apply macro q" })
map("v", "Q", ":norm @q<CR>", { desc = "Apply macro q to selection" })
map("n", "<S-l>", "gt", { desc = "Next tab" })
map("n", "<S-h>", "gT", { desc = "Previous tab" })
map("c", "qt", ":tabclose", { desc = "Close tab" })
