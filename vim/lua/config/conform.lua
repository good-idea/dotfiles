-- conform.nvim configuration
-- Modern async formatter with better error handling

require("conform").setup({
  formatters_by_ft = {
    -- JavaScript/TypeScript family
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    vue = { "prettierd", "prettier", stop_after_first = true },

    -- Web languages
    html = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    liquid = { "prettierd", "prettier", stop_after_first = true },
    astro = { "prettierd", "prettier", stop_after_first = true },

    -- Markdown
    markdown = { "prettierd", "prettier", stop_after_first = true },

    -- Elixir
    elixir = { "prettierd", "prettier", stop_after_first = true },
    eelixir = { "prettierd", "prettier", stop_after_first = true },
    heex = { "prettierd", "prettier", stop_after_first = true },

    -- Shell scripts
    sh = { "prettierd", "prettier", stop_after_first = true },
    bash = { "prettierd", "prettier", stop_after_first = true },
    zsh = { "prettierd", "prettier", stop_after_first = true },

    -- Other languages
    sql = { "prettierd", "prettier", stop_after_first = true },
    java = { "prettierd", "prettier", stop_after_first = true },
    rust = { "prettierd", "prettier", stop_after_first = true },

    -- Go (multiple formatters run in sequence)
    go = { "goimports", "gofmt" },

    -- Lua
    lua = { "luafmt" },

    -- Python
    python = { "black" },

    -- LaTeX
    tex = { "latexindent" },
  },

  -- Format on save
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 2000,
    lsp_format = "fallback",
  },

  -- Customize formatters
  formatters = {
    luafmt = {
      prepend_args = { "--indent-count", "2" },
    },
    black = {
      prepend_args = { "-" },
    },
  },
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Save cursor position
    local save_cursor = vim.fn.getpos(".")

    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])

    -- Remove trailing blank lines
    vim.cmd([[%s/\n\+\%$//e]])

    -- Restore cursor position
    vim.fn.setpos(".", save_cursor)
  end,
})
