local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup {
  nextls = {enable = true},
  elixirls = {
    on_attach = function(client, bufnr)
      -- not actually that helpful..
      -- vim.keymap.set("n", "<leader>fp", ":ElixirFromPipe<cr>", {buffer = true, noremap = true})
      -- vim.keymap.set("n", "<leader>tp", ":ElixirToPipe<cr>", {buffer = true, noremap = true})
      -- vim.keymap.set("v", "<leader>em", ":ElixirExpandMacro<cr>", {buffer = true, noremap = true})
    end
  }
}
