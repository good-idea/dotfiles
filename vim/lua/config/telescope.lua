local actions = require "telescope.actions"
local telescope = require "telescope"
local map = vim.api.nvim_set_keymap
local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

telescope.setup {
  defaults = {
    file_ignore_patterns = {"node_modules", ".git", "dist", "_next"},
    layout_strategy = "flex",
    scroll_strategy = "cycle",
    mappings = {
      ["i"] = {
        ["<C-k>"] = actions.preview_scrolling_up,
        ["<C-j>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
      }
    }
  },
  extensions = {},
  pickers = {
    find_files = {
      theme = "dropdown",
      cwd = git_root
    },
    lsp_references = {theme = "dropdown"},
    lsp_code_actions = {theme = "dropdown"},
    lsp_definitions = {theme = "dropdown"},
    lsp_implementations = {theme = "dropdown"},
    buffers = {
      sort_lastused = true,
      previewer = false
    }
  }
}
