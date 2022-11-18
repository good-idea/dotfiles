-- *******************
-- Keybindings
-- *******************
--

-- map takes 4 arguments:
--   the mode for which the mapping will take effect, (n, nvo, v, etc..)
--   the key sequence, (the alias we want to use)
--   the command to execute (the command we want to run)
--   and a table of options (:h :map-arguments).

local map = vim.api.nvim_set_keymap
local opts = {noremap = true} -- default options to make the command non-recursive

map("n", "U", "<C-R>", opts) -- Redo with U instead of Ctrl+R
map("n", "n", "nzzzv", opts) -- better search next
map("n", "N", "Nzzzv", opts) -- better search previous
map("n", "H", "0", opts) -- go to beginning of line with 0
map("n", "L", "$", opts) -- go to end of line with $
map("v", "J", "10j", opts) -- use J to go 10 lines down
map("v", "K", "10k", opts) -- use K to go 10 lines up
map("n", "J", "10j", opts) -- use J to go 10 lines down
map("n", "K", "10k", opts) -- use K to go 10 lines up
map("n", "<tab>", "%", opts) -- use Tab to go to next bracket/paren pair
map("v", "<tab>", "%", opts) -- use Tab to go to next bracket/paren pair
map("o", "<tab>", "%", opts) -- use Tab to go to next bracket/paren pair

-- Diagnostics
-- view code actions ,va
map("n", "<leader>va", "<cmd>CodeActionMenu<CR>", opts)
-- view signature with ,vs
map("n", "<leader>vs", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
-- view diagnostics for line with ,vs
map("n", "<leader>vd", "<cmd>lua vim.diagnostic.open_float(nil, { focusable = true, max_height = 20 })<CR>", opts)
-- View diagnostics for entire buffer with ,vD
map(
  "n",
  "<leader>vD",
  "<cmd>lua vim.diagnostic.open_float(0, { focusable = true, max_height = 20, scope = 'buffer' })<CR>",
  opts
)

-- File search & navigation
map("n", "<Leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- go to definition with ,gd
map("n", "<leader>vg", "<cmd>Telescope git_files<CR>", opts) -- view changed git files with ,vg
map("n", "<leader>vr", "<cmd>Telescope lsp_references<CR>", opts) -- view file references with ,vr
map("n", "<leader>p", "<cmd>Telescope find_files hidden=true<CR>", opts) -- "ctrl-p" file finding with ,p
map("n", "<leader>ag", "<cmd>Telescope live_grep<CR>", opts) -- "ag" like live grep with ,ag
map("n", "<leader>b", "<cmd>NvimTreeToggle<CR>", opts) -- open nvim-tree explorer
map("n", "<leader>B", "<cmd>NvimTreeFindFile<CR>", opts) -- open nvim-tree explorer
map("n", "<leader>wk", "<cmd>WhichKey<CR>", opts)

-- Git
map("n", "<leader>vpr", "<cmd>GHSearchPRs<CR>is:open", opts)

-- Misc
map("n", '<leader>"', 'ysiw"', opts) -- use ," to surround a word with "quotes"
map("n", "<leader>'", "ysiw'", opts) -- use ," to surround a word with 'single quotes'
map("n", "<leader>)", "ysiw)", opts) -- use ,) to surround a word with (parens)
map("n", "<leader>]", "ysiw]", opts) -- use ,] to surround a word with [brackets]
map("n", "<leader>}", "ysiw}", opts) -- use ,} to surround a word with {braces}
map("n", "<leader>yw", "yiww", opts) -- use ,yw to yank the entire (inner) word
map("v", "<leader>yw", "yiww", opts) -- use ,yw to yank the entire (inner) word
map("n", "<leader>rc", ':so $MYVIMRC | echo "⚡️ Reloaded config!"<CR>', opts) -- reload vim config with ,rc
map("n", "Q", "@q", opts) -- qq to record macros, q to stop, Q to apply
map("v", "Q", ":norm @q<CR>", opts)
map("n", "<S-l>", "gt", opts) -- Shift + L for next tab
map("n", "<S-h>", "gT", opts) -- Shift + L for previous tab
map("c", "qt", ":tabclose", opts) -- close tab with :qt
