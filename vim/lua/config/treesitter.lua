require'nvim-treesitter.configs'.setup {
  textobjects = {
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>vF"] = "@function.outer",
        ["<leader>vC"] = "@class.outer",
      },
    },
  },
}

