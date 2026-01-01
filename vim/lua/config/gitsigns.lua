require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_formatter = '<abbrev_sha> • <author>, <author_time:%Y-%m-%d> - <summary>',
  current_line_blame_opts = {
    virt_text = false,       -- turn off inline virtual text
    -- delay = 1000,            -- delay before showing blame
    ignore_whitespace = false,
  },

  on_attach = function(bufnr)
    vim.api.nvim_create_user_command("Blame",":Gitsigns blame", {})
  end,
}
