-- conform.nvim configuration
-- Modern async formatter with better error handling

-- Enabled by default; use :FormatOnSave disable to opt out for this session.
local format_on_save_enabled = true

vim.api.nvim_create_user_command("FormatOnSave", function(opts)
  if opts.args == "enable" then
    format_on_save_enabled = true
  elseif opts.args == "disable" then
    format_on_save_enabled = false
  else
    vim.notify("Usage: :FormatOnSave enable|disable", vim.log.levels.ERROR)
    return
  end

  vim.notify("Format on save " .. (format_on_save_enabled and "enabled" or "disabled"))
end, {
  nargs = 1,
  desc = "Enable or disable Conform formatting on save for this session",
  complete = function(arg_lead)
    return vim.tbl_filter(function(value)
      return value:sub(1, #arg_lead) == arg_lead
    end, { "enable", "disable" })
  end,
})

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

    -- Elixir: let Conform delegate formatting to ElixirLS.
    elixir = { lsp_format = "prefer" },
    eelixir = { lsp_format = "prefer" },
    heex = { lsp_format = "prefer" },

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

  format_on_save = function()
    if not format_on_save_enabled then
      return
    end

    return {
      timeout_ms = 2000,
      lsp_format = "fallback",
    }
  end,

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
