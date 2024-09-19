local lspConfig = require "lspconfig"
-- Java setup
-- local home = os.getenv("HOME")
-- local root_markers = {"gradlew", "mvnw", ".git"}
-- local root_dir = require("jdtls.setup").find_root(root_markers)
-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
-- local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

lspConfig.jdtls.setup {}
require("jdtls").start_or_attach(
  {
    cmd = {
      vim.fn.expand "$HOME/.local/share/nvim/mason/bin/jdtls"
    }
  }
)
