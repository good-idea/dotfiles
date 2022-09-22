local tree_cb = require "nvim-tree.config".nvim_tree_callback

require "nvim-tree".setup {
  actions = {
    open_file = {
      window_picker = {
        enable = true
      }
    }
  },
  renderer = {
    add_trailing = true,
    highlight_opened_files = "name",
    highlight_git = true,
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false
      }
    },
    indent_markers = {
      enable = true
    }
  },
  diagnostics = {
    enable = true,
    icons = {
      warning = "●",
      error = "●",
      hint = "",
      info = ""
    }
  },
  git = {
    enable = true
  },
  filters = {
    exclude = {
      ".env",
      ".env."
    }
  },
  view = {
    mappings = {
      list = {
        {key = "m", cb = tree_cb("rename")},
        {key = "v", cb = tree_cb("vsplit")},
        {key = "x", cb = tree_cb("split")},
        {key = "t", cb = tree_cb("tabnew")},
        {key = "p", cb = tree_cb("parent_node")},
        {key = "h", cb = tree_cb("togglehelp")}
      }
    }
  }
}
