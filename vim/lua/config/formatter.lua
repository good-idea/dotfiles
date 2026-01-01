-- Auto formatting:
-- for file types that should use formatting plugin
vim.cmd(
  [[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.ex,*.md,*.js,*.jsx,*.ts,*.tsx,*.rs,*.lua,*.css,*.scss,*.sass,*.vue,*.mjs,*.mts,*.eex,*.html,*.liquid FormatWrite
  augroup END
]],
  true
)

-- Auto formatting:
-- for file types that should use LSP formatting
vim.cmd([[
  autocmd BufWritePost *.hee,*.json, lua vim.lsp.buf.format()
]])

local goFmt = function()
  return {
    exe = "gofmt",
    args = {"-w"},
    tempfile_postfix = ".tmp",
    stdin = false
  }
end

local goImports = function()
  return {
    exe = "goimports",
    args = {"-w"},
    tempfile_postfix = ".tmp",
    stdin = false
  }
end

local prettier = function()
  return {
    exe = [[ prettier ]],
    args = {
      "--stdin-filepath",
      -- manually quote the filepath to avoid Zsh globbing issues
      [["]] .. vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) .. [["]]
    },
    stdin = true
  }
end

require("formatter").setup(
  {
    filetype = {
      html = {
        prettier
      },
      tex = {
        -- prettier
        function()
          return {
            exe = "latexindent",
            stdin = true
          }
        end
      },
      css = {
        prettier
      },
      scss = {
        prettier
      },
      vue = {
        prettier
      },
      json = {
        prettier
      },
      markdown = {
        prettier
      },
      mjs = {
        prettier
      },
      javascript = {
        prettier
      },
      javascriptreact = {
        prettier
      },
      java = {
        prettier
      },
      sh = {
        prettier
      },
      zsh = {
        prettier
      },
      bash = {
        prettier
      },
      sql = {
        prettier
      },
      typescript = {
        prettier
      },
      typescriptreact = {
        prettier
      },
      liquid = {
        prettier
      },
      go = {
        goImports,
        goFmt
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      },
      python = {
        -- Configuration for psf/black
        function()
          return {
            exe = "black", -- this should be available on your $PATH
            args = {"-"},
            stdin = true
          }
        end
      }
    }
  }
)

vim.api.nvim_exec(
  [[
augroup TrimTrailingWhiteSpace
      au!
      au BufWritePre * %s/\s\+$//e
      au BufWritePre * %s/\n\+\%$//e
  augroup END
]],
  true
)
