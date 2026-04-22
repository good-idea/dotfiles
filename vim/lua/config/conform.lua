-- conform.nvim configuration
-- Modern async formatter with better error handling

require("conform").setup({
  formatters_by_ft = {
    -- JavaScript/TypeScript family
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    vue = { "prettierd" },

    -- Web languages
    html = { "prettierd" },
    css = { "prettierd" },
    scss = { "prettierd" },
    json = { "prettierd" },
    liquid = { "prettierd" },
    astro = { "prettierd" },

    -- Markdown
    markdown = { "prettierd" },

    -- Elixir
    elixir = { "prettierd" },
    eelixir = { "prettierd" },
    heex = { "prettierd" },

    -- Shell scripts
    sh = { "prettierd" },
    bash = { "prettierd" },
    zsh = { "prettierd" },

    -- Other languages
    sql = { "prettierd" },
    java = { "prettierd" },
    rust = { "prettierd" },

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
    lsp_fallback = true,
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
