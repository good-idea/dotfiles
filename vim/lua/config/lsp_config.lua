local lspConfig = require "lspconfig"

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

require("mason-lspconfig").setup(
  {
    ensure_installed = {"tailwindcss", "ts_ls", "eslint"}
  }
)

-- Java setup lives in ftplugin/java.lua
-- Elixir setup lives in config/elixir.lua

lspConfig.solargraph.setup {}
lspConfig.tailwindcss.setup {
  init_options = {
    userLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex"
    }
  }
}
lspConfig.eslint.setup {}
lspConfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT"
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",
          "require"
        }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true)
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false
      }
    }
  }
}

lspConfig.flow.setup {}
lspConfig.ts_ls.setup {
  settings = {
    codeAction = {
      applyRefactoring = {enabled = false}
    }
  },
  root_dir = function(fname)
    return lspConfig.util.root_pattern("tsconfig.json")(fname) or
      not lspConfig.util.root_pattern(".flowconfig")(fname) and
        lspConfig.util.root_pattern("package.json", "jsconfig.json", ".git")(fname)
  end,
  handlers = {
    -- see https://github.com/davidosomething/format-ts-errors.nvim
    ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
      if result.diagnostics == nil then
        return
      end

      -- ignore some tsserver diagnostics
      local idx = 1
      while idx <= #result.diagnostics do
        local entry = result.diagnostics[idx]

        local formatter = require("format-ts-errors")[entry.code]
        entry.message = formatter and formatter(entry.message) or entry.message

        -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
        if entry.code == 80001 then
          -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
          table.remove(result.diagnostics, idx)
        else
          idx = idx + 1
        end
      end

      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end,
    ["textDocument/definition"] = function(_, result, params)
      if result == nil or vim.tbl_isempty(result) then
        local _ = vim.lsp.log.info() and vim.lsp.log.info(params.method, "No location found")
        return nil
      end

      if vim.tbl_islist(result) then
        vim.lsp.util.jump_to_location(result[1])
        if #result > 1 then
          local isReactDTs = false
          for key, value in pairs(result) do
            if string.match(value.targetUri, "react/index.d.ts") then
              isReactDTs = true
              break
            end
          end
          if not isReactDTs then
            vim.fn.setqflist(vim.lsp.util.locations_to_items(result))
            vim.api.nvim_command("copen")
          end
        end
      else
        vim.lsp.util.jump_to_location(result)
      end
    end
  }
}
lspConfig.volar.setup {}
lspConfig.elixirls.setup {
  cmd = {"elixir-ls"}, -- Adjust this if needed
  filetypes = {"elixir", "eelixir", "ex", "exs"} -- Ensure exs is included
}
-- lspConfig.nextls.setup {
--   cmd:
-- }
-- lspConfig.elixirls.setup {
--   cmd = {"/Users/joseph/.elixir-ls/language_server.sh"},
--   on_attach = on_attach
-- }

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

-- Set up folding
-- https://www.jmaguire.tech/posts/treesitter_folding/
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldlevel = 99

-- Auto-display the signature on hver when in Insert mode and within parens
-- autocmd CursorHold * silent! lua vim.lsp.buf.hover()
-- vim.cmd [[
--  autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
-- ]]
