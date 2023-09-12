require("template-string").setup(
  {
    filetypes = {"html", "typescript", "javascript", "typescriptreact", "javascriptreact", "python"}, -- filetypes where the plugin is active
    jsx_brackets = true, -- must add brackets to JSX attributes
    remove_template_string = false, -- remove backticks when there are no template strings
    restore_quotes = {
      -- quotes used when "remove_template_string" option is enabled
      normal = [[']],
      jsx = [["]]
    }
  }
)
