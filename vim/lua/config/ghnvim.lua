require("litee.lib").setup()
require("litee.gh").setup(
  {
    -- remap the arrow keys to resize any litee.nvim windows.
    map_resize_keys = false,
    -- do not map any keys inside any gh.nvim buffers.
    disable_keymaps = false,
    -- the icon set to use.
    icon_set = "default",
    -- any custom icons to use.
    -- icon_set_custom = nil,
    -- whether to register the @username and #issue_number omnifunc completion
    debug_logging = true,
    -- in buffers which start with .git/
    git_buffer_completion = true,
    -- defines keymaps in gh.nvim buffers.
    keymaps = {
      -- when inside a gh.nvim panel, this key will open a node if it has
      -- any futher functionality. for example, hitting <CR> on a commit node
      -- will open the commit's changed files in a new gh.nvim panel.
      open = "<CR>",
      -- when inside a gh.nvim panel, expand a collapsed node
      expand = "zo",
      -- when inside a gh.nvim panel, collpased and expanded node
      collapse = "zc",
      -- when cursor is over a "#1234" formatted issue or PR, open its details
      -- and comments in a new tab.
      goto_issue = "gd",
      -- show any details about a node, typically, this reveals commit messages
      -- and submitted review bodys.
      details = "d",
      -- inside a convo buffer, submit a comment
      submit_comment = "<C-s>",
      -- inside a convo buffer, when your cursor is ontop of a comment, open
      -- up a set of actions that can be performed.
      actions = "<C-a>",
      -- inside a thread convo buffer, resolve the thread.
      resolve_thread = "<C-r>",
      -- inside a gh.nvim panel, if possible, open the node's web URL in your
      -- browser. useful particularily for digging into external failed CI
      -- checks.
      goto_web = "gx"
    }
  }
)

-- Disabled: which-key was uninstalled
-- local wk = require("which-key")
-- wk.add(
--   {
--     {"<leader>g", group = "Git"},
--     {"<leader>gh", group = "Github"},
--     {"<leader>ghc", group = "Commits"},
--     {"<leader>ghcc", "<cmd>GHCloseCommit<cr>", desc = "Close"},
--     {"<leader>ghce", "<cmd>GHExpandCommit<cr>", desc = "Expand"},
--     {"<leader>ghco", "<cmd>GHOpenToCommit<cr>", desc = "Open To"},
--     {"<leader>ghcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out"},
--     {"<leader>ghcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse"},
--     {"<leader>ghi", group = "Issues"},
--     {"<leader>ghip", "<cmd>GHPreviewIssue<cr>", desc = "Preview"},
--     {"<leader>ghl", group = "Litee"},
--     {"<leader>ghlt", "<cmd>LTPanel<cr>", desc = "Toggle Panel"},
--     {"<leader>ghp", group = "Pull Request"},
--     {"<leader>ghpc", "<cmd>GHClosePR<cr>", desc = "Close"},
--     {"<leader>ghpd", "<cmd>GHPRDetails<cr>", desc = "Details"},
--     {"<leader>ghpe", "<cmd>GHExpandPR<cr>", desc = "Expand"},
--     {"<leader>ghpo", "<cmd>GHOpenPR<cr>", desc = "Open"},
--     {"<leader>ghpp", "<cmd>GHPopOutPR<cr>", desc = "PopOut"},
--     {"<leader>ghpr", "<cmd>GHRefreshPR<cr>", desc = "Refresh"},
--     {"<leader>ghpt", "<cmd>GHOpenToPR<cr>", desc = "Open To"},
--     {"<leader>ghpz", "<cmd>GHCollapsePR<cr>", desc = "Collapse"},
--     {"<leader>ghr", group = "Review"},
--     {"<leader>ghrb", "<cmd>GHStartReview<cr>", desc = "Begin"},
--     {"<leader>ghrc", "<cmd>GHCloseReview<cr>", desc = "Close"},
--     {"<leader>ghrd", "<cmd>GHDeleteReview<cr>", desc = "Delete"},
--     {"<leader>ghre", "<cmd>GHExpandReview<cr>", desc = "Expand"},
--     {"<leader>ghrs", "<cmd>GHSubmitReview<cr>", desc = "Submit"},
--     {"<leader>ghrz", "<cmd>GHCollapseReview<cr>", desc = "Collapse"},
--     {"<leader>ght", group = "Threads"},
--     {"<leader>ghtc", "<cmd>GHCreateThread<cr>", desc = "Create"},
--     {"<leader>ghtn", "<cmd>GHNextThread<cr>", desc = "Next"},
--     {"<leader>ghtt", "<cmd>GHToggleThread<cr>", desc = "Toggle"}
--   }
-- )

