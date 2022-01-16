local popup = require("popup")

vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=green ]]
vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=blue guibg=pink]]

LspDiagnosticsFloatingError = {fg = color1, bg = none, style = "bold"}
LspDiagnosticsFloatingWarning = {fg = color2, bg = none, style = "bold"}
LspDiagnosticsFloatingInformation = {fg = color3, bg = none, style = "italic"}
LspDiagnosticsFloatingHint = {fg = color4, bg = none, style = "italic"}

-- Config for the diagnostic window
vim.diagnostic.config(
  {
    virtual_text = false,
    underline = true,
    signs = true,
    float = {
      show_header = false,
      source = "always",
      border = "single",
      focusable = false
    }
  }
)

vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "single"
  }
)

-- config for the signature window
vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {
    silent = true,
    focusable = false
  }
)

-- Nicer icons for diagnostic signs
local signs = {Error = "●", Warn = "○", Hint = "○", Info = "○"}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-- Auto-display the signature on hver when in Insert mode and within parens
vim.cmd [[
  autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
  autocmd CursorHold * silent! lua vim.lsp.diagnostic.show_line_diagnostics()
  " autocmd CursorHold * silent! PrintDiagnostics()
]]
-- autocmd CursorHold * silent! lua vim.lsp.buf.hover()

-- -- Print diagnostics to the message buffer instead of a popup
-- TODO: Work on this to have a nicer diagnostics popup
-- function PrintDiagnostics(opts, bufnr, line_nr, client_id)
--   opts = opts or {}
--
--   bufnr = bufnr or 0
--   line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
--
--   local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
--   if vim.tbl_isempty(line_diagnostics) then return end
--
--   local diagnostic_message = ""
--   for i, diagnostic in ipairs(line_diagnostics) do
--     diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
--     print(diagnostic_message)
--     if i ~= #line_diagnostics then
--       diagnostic_message = diagnostic_message .. "\n"
--     end
--   end
--   popup.create(diagnostic_message, { border = true, line = line_nr, col = "cursor+0", minwidth = 25, minheight = 15, enter = false })
--   -- vim.api.nvim_open_win({{diagnostic_message, "Question"}}, false, {})
-- end

-- null-ls
-- configure null-ls to work with eslint_d and prettier
local null_ls = require("null-ls")

null_ls.setup(
  {
    sources = {
      null_ls.builtins.diagnostics.eslint,
      null_ls.builtins.code_actions.eslint,
      -- null_ls.builtins.diagnostics.eslint_d,
      -- null_ls.builtins.code_actions.eslint_d,
      null_ls.builtins.formatting.prettier
    },
    on_attach = on_attach
  }
)
