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
opt.number = true -- line numbers
opt.wrap = false -- don't wrap lines
opt.linebreak = true -- wrap lines at convenient points
opt.relativenumber = true
opt.visualbell = true -- no sounds
opt.cursorline = true -- no sounds
opt.autoread = true -- reload files changed outside vim
opt.scrolloff = 8 -- leave 8 lines below bottom & top scroll
opt.cmdheight = 2 -- more space for messages

-- search
opt.hlsearch = true -- highlight search results
opt.incsearch = true -- highlight search results while typing
opt.ignorecase = true -- make searches case-insensitive
opt.smartcase = true -- make searches case-sensitive when including capital letters
opt.title = true -- set window title to filename (see :help title)
opt.termguicolors = true -- colors!

-- Allow backspace to:
-- indent    allow backspacing over autoindent
-- eol       allow backspacing over line breaks (join lines)
-- start     allow backspacing over the start of insert; CTRL-W and CTRL-U
--           stop once at the start of insert.
opt.backspace = "indent,eol,start"
opt.clipboard = "unnamed" -- use the clipboard register '*' instead of unnamed
opt.mouse = "a" -- enable mouse support

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

-- auto reload a buffer on file change
opt.autoread = true
vim.cmd(
  [[
  autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]]
)

-- typescript syntax

-- augroup {
--   'ts-syntax',
--   {
--     { 'BufNewFile,BufRead', '*.ts', 'set', 'syntax=typescript' },
--     { 'BufNewFile,BufRead', '*.tsx', 'set', 'syntax=typescript' }
--   }
-- }
vim.cmd(
  [[
  augroup TsSyntax
    autocmd!
    autocmd BufNewFile,BufRead *.ts,*.tsx set syntax=typescript
  augroup END

]]
)

-- open :help in a vertical split
vim.cmd(
  [[
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END
]]
)

-- auto formatting. Add extensions below
vim.cmd(
  [[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.ts,*.tsx,*.json,*.md,*.js,*.rs,*.lua,*.css,*.scss,*.sass,*.vue FormatWrite
  augroup END
]],
  true
)

vim.cmd [[
  set nocompatible
  filetype plugin on       " may already be in your .vimrc
  let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'

  augroup pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
    autocmd FileType text         call pencil#init()
  augroup END
]]

-- ]]

-- return to the same line when re-opening a file
-- augroup {
--   'line_return',
--   {{
--     'BufReadPost', {
--        if line("'\"") > 0 && line("'\"") <= line("$") |
--        execute 'normal! g`"zvzz' |
--        endif
--     }
--   }}
-- }

-- *******************
-- Theme
-- *******************

vim.cmd [[syntax on]]
vim.cmd [[color challenger_deep]]
