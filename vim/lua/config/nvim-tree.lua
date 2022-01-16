local tree_cb = require "nvim-tree.config".nvim_tree_callback

require "nvim-tree".setup {
  diagnostics = {
    enable = "true",
    icons = {
      warning = "●",
      error = "●",
      hint = "",
      info = ""
    }
  },
  git = {
    enable = "true"
  },
  filters = {
    custom = {
      ".git",
      "!.env"
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
