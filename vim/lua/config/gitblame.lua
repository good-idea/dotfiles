vim.cmd [[
  let g:gitblame_message_template = '<sha> • <date> • <summary> • <author>'
  let g:gitblame_enabled = 0
]]

-- Disable virtual text
vim.g.gitblame_display_virtual_text = 0

-- vim.api.nvim_create_user_command("Blame", ":GitBlameToggle", {})
