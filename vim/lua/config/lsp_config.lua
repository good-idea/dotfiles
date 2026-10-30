-- Mason setuplsp_config.lua

-- Treat PICO-8 Lua source as its own filetype so pico8_ls attaches instead of lua_ls.
vim.filetype.add({
  pattern = {
    [".*%.p8%.lua"] = "p8",
  },
})

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
    ensure_installed = { "tailwindcss", "ts_ls", "eslint", "lua_ls", "elixirls", "astro", "bashls", "vue_ls" },
    automatic_enable = true -- Automatically enable installed servers
  }
)

-- Server Configurations

-- Tailwind CSS with custom init_options for Elixir/Heex support
vim.lsp.config('tailwindcss', {
  init_options = {
    userLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex"
    }
  }
})

-- ESLint - include Vue single-file components
vim.lsp.config('eslint', {
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
  },
})

-- Lua LS with custom settings
-- Note: lazydev.nvim handles most Lua config automatically, but we keep this for reference
vim.lsp.config('lua_ls', {
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
})

-- Vue language server (Volar)
vim.lsp.config('vue_ls', {})

vim.lsp.config("pico8_ls", {
  filetypes = { "p8" },
})


-- TypeScript with custom handlers for diagnostics and definitions
-- Vue support requires ts_ls to attach to .vue files with Vue's TypeScript plugin.
local vue_language_server_path = vim.fn.stdpath('data') ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
}

vim.lsp.config('ts_ls', {
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
  },
  init_options = {
    hostInfo = 'neovim',
    plugins = { vue_plugin },
  },
  settings = {
    codeAction = {
      applyRefactoring = { enabled = false }
    }
  },
  handlers = {
    -- Custom diagnostics handler: filters and formats TypeScript errors
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
    -- Custom definition handler: smart quickfix list for multiple definitions
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
})

-- Elixir LS with custom cmd and filetypes
vim.lsp.config('elixirls', {
  cmd = { "elixir-ls" },
  filetypes = { "elixir", "eelixir", "heex" }
})

-- Astro language server
vim.lsp.config('astro', {
  init_options = {
    typescript = {
      tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
    }
  }
})

-- Diagnostic sign styling (kept from original config)
LspDiagnosticsFloatingError = { fg = color1, bg = none, style = "bold" }
LspDiagnosticsFloatingWarning = { fg = color2, bg = none, style = "bold" }
LspDiagnosticsFloatingInformation = { fg = color3, bg = none, style = "italic" }
LspDiagnosticsFloatingHint = { fg = color4, bg = none, style = "italic" }

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

-- vim.lsp.handlers["textDocument/hover"] =
--     vim.lsp.with(
--       vim.lsp.handlers.hover,
--       {
--         border = "single"
--       }
--     )

-- config for the signature window
-- vim.lsp.handlers["textDocument/signatureHelp"] =
--     vim.lsp.with(
--       vim.lsp.handlers.signature_help,
--       {
--         silent = true,
--         focusable = false
--       }
--     )

-- Diagnostic sign icons (Neovim 0.11+ style)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "○",
      [vim.diagnostic.severity.HINT] = "○",
      [vim.diagnostic.severity.INFO] = "○",
    },
  },
})

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
