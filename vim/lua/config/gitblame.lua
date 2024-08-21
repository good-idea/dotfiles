vim.cmd [[
  let g:gitblame_message_template = '<sha> • <date> • <summary> • <author>'
  " Disable in-line blame
  let g:gitblame_display_virtual_text = 0
  let g:gitblame_date_format = "%r"
]]
