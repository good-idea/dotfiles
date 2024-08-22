require "nvim-treesitter.configs".setup {
  ensure_installed = {"html", "javascript", "typescript", "elixir", "heex", "eex", "lua", "vim", "vimdoc", "query"},
  auto_install = true,
  textobjects = {
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = {
        ["<leader>vF"] = "@function.outer",
        ["<leader>vC"] = "@class.outer"
      }
    }
  }
}
