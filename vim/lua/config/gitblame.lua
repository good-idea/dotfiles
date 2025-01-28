vim.cmd [[
  let g:gitblame_message_template = '<sha> • <date> • <summary> • <author>'
  let g:gitblame_enabled = 0
]]

vim.api.nvim_create_user_command("Blame", ":GitBlameToggle", {})
