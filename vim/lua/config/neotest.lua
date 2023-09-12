require("neotest").setup(
  {
    adapters = {
      require("neotest-jest")(
        {
          jestCommand = "yarn jest --watch"
        }
      )
    },
    icons = {
      child_indent = "│",
      child_prefix = "├",
      collapsed = "─",
      expanded = "╮",
      failed = "",
      final_child_indent = " ",
      final_child_prefix = "╰",
      non_collapsible = "─",
      passed = "",
      running = "",
      -- running_animated = {"", "", "", "", "", "", "", "", "", "", "", ""},
      running_animated = {
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
      },
      skipped = "",
      unknown = "x",
      watching = "?"
    }
  }
)
