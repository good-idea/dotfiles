require("oil").setup(
  {
    keymaps = {
      ["?"] = "actions.show_help",
      ["v"] = {"actions.select", opts = {vertical = true}, desc = "Open the entry in a vertical split"},
      ["s"] = {"actions.select", opts = {horizontal = true}, desc = "Open the entry in a horizontal split"},
      ["t"] = {"actions.select", opts = {tab = true}, desc = "Open the entry in new tab"}
    },
    view_options = {
      show_hidden = true
    }
  }
)

vim.keymap.set("n", "-", "<CMD>Oil<CR>", {desc = "Open parent directory"})
