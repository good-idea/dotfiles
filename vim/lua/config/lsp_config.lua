require("mason").setup(
  {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  }
)
require("mason-lspconfig").setup()

require("lspconfig").tsserver.setup {}
require("lspconfig").volar.setup {}

local lspConfig = require "lspconfig"

LspDiagnosticsFloatingError = {fg = color1, bg = none, style = "bold"}
LspDiagnosticsFloatingWarning = {fg = color2, bg = none, style = "bold"}
LspDiagnosticsFloatingInformation = {fg = color3, bg = none, style = "italic"}
LspDiagnosticsFloatingHint = {fg = color4, bg = none, style = "italic"}

-- Server setups
-- require "lspconfig".volar.setup({})

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
-- autocmd CursorHold * silent! lua vim.lsp.buf.hover()
vim.cmd [[
 autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
]]

-- -- null-ls
-- -- configure null-ls to work with eslint_d and prettier
-- local null_ls = require("null-ls")

-- null_ls.setup(
--   {
--     sources = {
--       null_ls.builtins.diagnostics.eslint.with({}),
--       null_ls.builtins.code_actions.eslint,
--       -- null_ls.builtins.diagnostics.eslint_d,
--       -- null_ls.builtins.code_actions.eslint_d,
--       null_ls.builtins.formatting.prettier
--     },
--     on_attach = on_attach
--   }
-- )
