-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({

  ---------------------
  -- Core Libraries
  ---------------------

  -- General-purpose Lua functions used by many plugins (async, paths, etc.)
  { "nvim-lua/plenary.nvim" },

  -- Popup API for floating windows, used by telescope and others
  { "nvim-lua/popup.nvim" },

  ---------------------
  -- Syntax & Treesitter
  ---------------------

  -- Incremental parsing for syntax highlighting, indentation, and code folding.
  -- Provides accurate, language-aware highlighting far beyond regex-based syntax.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    priority = 1000,
    config = function()
      require('config.treesitter')
    end,
  },

  -- Liquid template syntax (Shopify, Jekyll)
  { "eloyesp/vim-liquid" },

  -- DBML (Database Markup Language) syntax support
  { "jidn/vim-dbml" },

  ---------------------
  -- LSP & Language Support
  ---------------------

  -- Configurations for Neovim's built-in LSP client.
  -- Mason handles installing language servers automatically.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "davidosomething/format-ts-errors.nvim",
    },
    config = function()
      require('config.lsp_config')
    end,
  },

  -- Automatically close and rename HTML/JSX tags using treesitter
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Display Tailwind CSS class values in a popup
  { "MaximilianLloyd/tw-values.nvim" },

  -- Run TypeScript compiler and populate quickfix with errors
  {
    "dmmulroy/tsc.nvim",
    config = function()
      require('tsc').setup()
    end,
  },

  -- Lua development support with completion for vim APIs and plugin libraries
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  ---------------------
  -- Completion & Snippets
  ---------------------

  -- Autocompletion engine with multiple sources (LSP, buffer, path, snippets)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require('config.cmp')
    end,
  },

  -- Snippet engine with support for VSCode-style snippets
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require('config.luasnip')
    end,
  },

  -- Auto-insert matching brackets, quotes, and parentheses
  {
    "windwp/nvim-autopairs",
    config = function()
      require('config.autopairs')
    end,
  },

  ---------------------
  -- Search & Navigation
  ---------------------

  -- Fuzzy finder for files, buffers, grep, LSP symbols, and more
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require('config.telescope')
    end,
  },

  -- Use telescope as the UI for vim.ui.select (code actions, etc.)
  { "nvim-telescope/telescope-ui-select.nvim" },

  -- Frecency-based file sorting (frequency + recency) for telescope
  { "nvim-telescope/telescope-frecency.nvim" },

  -- File explorer that lets you edit your filesystem like a buffer
  {
    "stevearc/oil.nvim",
    config = function()
      require('config.oil')
    end,
  },

  -- Markdown outline view in a side panel
  {
    "hedyhli/outline.nvim",
    ft = "markdown",
    config = function()
      require("config.outline")
    end,
  },

  ---------------------
  -- Git Integration
  ---------------------

  -- Git signs in the gutter (added, modified, deleted lines)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('config.gitsigns')
    end,
  },

  -- Full-featured terminal UI for git (lazygit) inside neovim
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
  },

  -- GitHub pull request and issue management within neovim
  {
    "ldelossa/gh.nvim",
    dependencies = { "ldelossa/litee.nvim" },
    config = function()
      require('config.ghnvim')
    end,
  },

  ---------------------
  -- Editing Utilities
  ---------------------

  -- Add, change, and delete surrounding pairs (quotes, brackets, tags)
  { "tpope/vim-surround" },

  -- Handy bracket mappings for navigation ([q, ]q, [b, ]b, etc.)
  { "tpope/vim-unimpaired" },

  -- Seamless navigation between tmux panes and vim splits
  { "christoomey/vim-tmux-navigator" },

  -- Toggle comments with gc (line) and gb (block)
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto-convert JS strings to template literals when typing ${}
  {
    "axelvc/template-string.nvim",
    config = function()
      require('config.template_string')
    end,
  },

  -- Soft wrapping and writing-focused settings for prose
  { "reedes/vim-pencil" },

  -- Show diff when recovering swap files
  { "chrisbra/recover.vim" },

  ---------------------
  -- Formatting
  ---------------------

  -- Format code on save using external formatters (prettier, stylua, etc.)
  {
    "stevearc/conform.nvim",
    config = function()
      require('config.conform')
    end,
  },

  ---------------------
  -- UI & Appearance
  ---------------------

  -- Statusline with git, LSP, and mode indicators
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('config.lualine')
    end,
  },

  -- Colorschemes
  { "sainnhe/edge" },
  { "rebelot/kanagawa.nvim" },
  { "catppuccin/nvim",                name = "catppuccin" },
  { "olivercederborg/poimandres.nvim" },
  {
    "neanias/everforest-nvim",
    lazy = false,
    priority = 999,
    config = function()
      require("everforest").setup({})
    end,
  },

  ---------------------
  -- Miscellaneous
  ---------------------

  -- Automatic time tracking for coding activity
  { "wakatime/vim-wakatime" },

}, {
  -- Lazy.nvim configuration options
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
