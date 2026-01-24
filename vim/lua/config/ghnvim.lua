require("litee.lib").setup()
require("litee.gh").setup({
  map_resize_keys = false,
  disable_keymaps = false,
  icon_set = "default",
  debug_logging = true,
  git_buffer_completion = true,
  keymaps = {
    open = "<CR>",
    expand = "zo",
    collapse = "zc",
    goto_issue = "gd",
    details = "d",
    submit_comment = "<C-s>",
    actions = "<C-a>",
    resolve_thread = "<C-r>",
    goto_web = "gx"
  }
})
