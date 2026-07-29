local opt = vim.opt

-- *******************
-- General settings
-- *******************

-- If vim is running slowly, increase this number.
-- note: this will affect autocmd CursorHold time
opt.updatetime = 300
opt.signcolumn = "yes"
vim.g.mapleader = ","
opt.dir = "/tmp/"
opt.number = true     -- line numbers
opt.wrap = false      -- don't wrap lines
opt.linebreak = true  -- wrap lines at convenient points
opt.relativenumber = true
opt.visualbell = true -- no sounds
opt.cursorline = true -- highlight current line
opt.autoread = true   -- reload files changed outside vim
opt.scrolloff = 8     -- leave 8 lines below bottom & top scroll
opt.cmdheight = 2     -- more space for messages

-- search
opt.hlsearch = true      -- highlight search results
opt.incsearch = true     -- highlight search results while typing
opt.ignorecase = true    -- make searches case-insensitive
opt.smartcase = true     -- make searches case-sensitive when including capital letters
opt.title = true         -- set window title to filename (see :help title)
opt.termguicolors = true -- colors!

-- Allow backspace to:
-- indent    allow backspacing over autoindent
-- eol       allow backspacing over line breaks (join lines)
-- start     allow backspacing over the start of insert; CTRL-W and CTRL-U
--           stop once at the start of insert.
opt.backspace = "indent,eol,start"
opt.clipboard = "unnamed" -- use the clipboard register '*' instead of unnamed
opt.mouse = "a"           -- enable mouse support

-- Tabs and panes
opt.splitbelow = true -- put new buffers in a horizontal split below
opt.splitright = true -- put new buffers in a vertical split to the right

-- Indentation
local indent = 2
opt.tabstop = indent
opt.shiftwidth = indent
opt.softtabstop = indent
opt.expandtab = true

-- *******************
-- Autocommands
-- *******************

-- Auto reload a buffer on file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.api.nvim_echo({
      { "File changed on disk. Buffer reloaded.", "WarningMsg" }
    }, false, {})
  end,
  desc = "Notify when file is reloaded after external change"
})

-- Open :help in a vertical split
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.txt",
  callback = function()
    if vim.bo.buftype == "help" then
      vim.cmd("wincmd L")
    end
  end,
  desc = "Open help windows in vertical split"
})

-- vim-pencil setup for markdown and text files
vim.g['pencil#wrapModeDefault'] = 'soft'
vim.g['pencil#conceallevel'] = 0

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mkd", "text" },
  callback = function()
    vim.fn['pencil#init']()
  end,
  desc = "Initialize vim-pencil for markdown and text files"
})

-- *******************
-- Theme
-- *******************

vim.cmd [[syntax on]]

-- Tmux is the workspace theme authority. Light tmux sessions use Kanagawa
-- Lotus; dark sessions intentionally leave Neovim's default theme untouched.
local tmux_theme
if vim.env.TMUX then
  local result = vim.system({ "tmux", "show-option", "-gv", "@dotfiles_theme" }, { text = true }):wait()
  if result.code == 0 then
    tmux_theme = vim.trim(result.stdout)
  end
end

if tmux_theme == "light" then
  vim.o.background = "light"
  vim.cmd [[colorscheme kanagawa-lotus]]
else
  vim.cmd [[colorscheme edge]]
end
