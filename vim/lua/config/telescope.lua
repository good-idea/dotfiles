local actions = require "telescope.actions"
local telescope = require "telescope"

telescope.setup {
  defaults = {
    file_ignore_patterns = { "node_modules", ".git", "dist", "_next", ".elixir-tools", "deps" },
    layout_strategy = "vertical",
    scroll_strategy = "cycle",
    mappings = {
      ["i"] = {
        ["<C-k>"] = actions.preview_scrolling_up,
        ["<C-j>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
      }
    }
  },
  extensions = {
    frecency = {
      matcher = "fuzzy",
      db_safe_mode = false,
      default_workspace = "CWD"
    },
    ["ui-select"] = {
      layout_config = { width = 0.4, height = 0.3 },
      on_complete = {
        function()
          vim.cmd("stopinsert")
        end
      }
    }
  },
  pickers = {
    colorscheme = {
      enable_preview = true
    },
    find_files = {
      theme = "dropdown"
    },
    git_files = {
      theme = "dropdown"
    },
    lsp_references = { theme = "dropdown" },
    lsp_code_actions = { theme = "dropdown" },
    lsp_definitions = { theme = "dropdown" },
    lsp_implementations = { theme = "dropdown" },
    buffers = {
      sort_lastused = true,
      previewer = false
    }
  }
}

telescope.load_extension("ui-select")
telescope.load_extension("frecency")
