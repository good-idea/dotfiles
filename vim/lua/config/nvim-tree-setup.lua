-- vim.g.nvim_tree_git_hl = 1 -- highlight git status
-- vim.g.nvim_tree_highlight_opened_files = 1
-- vim.g.nvim_tree_add_trailing = 1
-- vim.g.nvim_tree_disable_window_picker = 1
-- vim.g.nvim_tree_show_icons = {
--   git = 0
-- }

vim.cmd [[
  highlight NvimTreeLspDiagnosticsError guifg=#c63629
  highlight NvimTreeLspDiagnosticsWarning guifg=yellow

  highlight NvimTreeGitDirty guifg=#FFBD61
  highlight NvimTreeGitStaged guifg=#0ee375
  highlight NvimTreeGitNew guifg=#FCE77C
]]
