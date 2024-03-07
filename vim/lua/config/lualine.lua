local filteredLspNames = {"tailwindcss", "eslint"}
local git_blame = require("gitblame")
require("lualine").setup {
  options = {
    theme = "auto"
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {
      {
        function()
          local blame = git_blame.get_current_blame_text()
          return blame or ""
        end,
        cond = git_blame.is_blame_text_available,
        color = "DiagnosticHint"
      }
    },
    lualine_x = {"filename"},
    lualine_y = {
      {
        function()
          local lsps = vim.lsp.get_active_clients({bufnr = vim.fn.bufnr()})
          if lsps and #lsps > 0 then
            local names = {}
            for _, lsp in ipairs(lsps) do
              if not vim.tbl_contains(filteredLspNames, lsp.name) then
                table.insert(names, lsp.name)
              end
            end
            return table.concat(names, ", ")
          else
            return ""
          end
        end,
        on_click = function()
          vim.api.nvim_command("LspInfo")
        end
      }
    },
    lualine_z = {{"datetime", style = "%H:%M"}}
  }
  -- inactive_sections = {
  --   lualine_x = {"encoding", "fileformat"},
  --   lualine_y = {}
  -- }
}
