local actions = require "telescope.actions"
local telescope = require "telescope"
local map = vim.api.nvim_set_keymap

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
  -- extensions = {},
  pickers = {
    find_files = {
      theme = "dropdown"
    },
    git_files = {
      theme = "dropdown"
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

-- Falling back to find_files if git_files can't find a .git directory
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory

-- telescope-config.lua
local M = {}

M.project_files = function()
  local opts = {} -- define here if you want to define something
  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    require "telescope.builtin".git_files(
      {
        show_untracked = true
      }
    )
  else
    require "telescope.builtin".find_files(opts)
  end
end

return M
