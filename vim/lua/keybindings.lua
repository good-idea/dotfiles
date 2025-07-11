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
local function showCodeActions()
  vim.lsp.buf.code_action(
    {
      filter = function(action)
        return true
      end
    }
  )
end

-- map("n", "<leader>va", showCodeActions, opts)
vim.keymap.set("n", "<leader>va", showCodeActions, opts)
-- view diagnostics for line with ,vs
map("n", "<leader>vd", "<cmd>lua vim.diagnostic.open_float(nil, { focusable = true, max_height = 20 })<CR>", opts)
-- list diagnostics in location list
map("n", "<leader>dl", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
-- navigate to next diagnostic
map("n", "<leader>dj", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
-- navigate to prev diagnostic
map("n", "<leader>dk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
-- View diagnostics for entire buffer with ,vD
map(
  "n",
  "<leader>vD",
  "<cmd>lua vim.diagnostic.open_float(0, { focusable = true, max_height = 20, scope = 'buffer' })<CR>",
  opts
)

-- Definitions
-- view signature with ,vs
map("n", "<leader>vs", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
-- go to definition with ,gd
map("n", "<Leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- go to definition with ,gd
-- view symbol references with ,vr
map("n", "<leader>vr", "<cmd>Telescope lsp_references<CR>", opts)

-- Theme
map("n", "<leader>th", "<cmd>Telescope colorscheme<CR>", opts)

-- Help
map("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", opts) -- search help docs
-- TODO: question for josh!
-- map("c", "searchhelp", "<cmd>Telescope help_tags<CR>", opts) -- search help docs
-- map("c", "sh", "<cmd>Telescope help_tags<CR>", opts) -- search help docs
map("n", "<leader>sc", "<cmd>Telescope commands<CR>", opts) -- search help docs

-- File search & navigation
-- "ctrl-p" file finding with ,p -- uses git_files if in git repo, falls back to working directory
-- map("n", "<Leader>p", "<CMD>lua require'config/telescope'.project_files()<CR>", {noremap = true, silent = true})
map("n", "<Leader>p", "<CMD>Telescope frecency<CR>", {noremap = true, silent = true})

map("n", "<leader>ag", "<cmd>Telescope live_grep<CR>", opts) -- "ag" like live grep with ,ag
map("n", "<leader>b", "<cmd>NvimTreeToggle<CR>", opts) -- open nvim-tree explorer
map("n", "<leader>B", "<cmd>NvimTreeFindFile<CR>", opts) -- open nvim-tree explorer
map("n", "<leader>wk", "<cmd>WhichKey<CR>", opts)
map("n", "<leader>cG", "<cmd>CopyGitRelPath<CR>", opts) -- copy path relative to git root, see ./commands.lua

-- Git
map("n", "<leader>vpr", "<cmd>GHSearchPRs<CR>is:open", opts)
map("n", "<leader>lg", "<cmd>LazyGit<CR>", opts)

-- Neotest
-- map("n", "<leader>t", "<cmd>lua require('neotest').run.run()<CR>", opts)
-- map("n", "<leader>t", function() require("neotest").run.run() end)
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
-- map("n", "<leader>tw", "<cmd>TWValues<CR>", opts) -- display applied Tailwind styles

-- -- ChatGPT
map("v", "<leader>gpte", ":ChatGPTEditWithInstructions<CR>", opts)

-- Run a single test
vim.keymap.set(
  "n",
  "<leader>t",
  function()
    require("neotest").run.run()
  end
)

-- Run all tests in a file
vim.keymap.set(
  "n",
  "<leader>ta",
  function()
    require("neotest").run.run(vim.fn.expand("%"))
  end
)
-- Toggle the test summary open & closed
vim.keymap.set(
  "n",
  "<leader>ts",
  function()
    require("neotest").summary.toggle()
  end
)

-- Run all tests in a project
-- vim.keymap.set(
--   "n",
--   "<leader>tp",
--   function()
--     require("neotest").run.run({vim.fn.getcwd(), jestCommand = "yarn jest --watchAll"})
--   end
-- )
