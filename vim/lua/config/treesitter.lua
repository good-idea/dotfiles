local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

treesitter_configs.setup {
  ensure_installed = {"html", "javascript", "typescript", "tsx", "elixir", "heex", "eex", "lua", "vim", "vimdoc", "query"},
  highlight = {enable = true},
  indent = {enable = true},
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
