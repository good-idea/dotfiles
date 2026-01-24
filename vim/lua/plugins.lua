-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  -- Treesitter: Advanced syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('config.treesitter')
    end,
  },

  -- LSP & Language Support
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

  -- Auto-close and rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Tailwind CSS utilities
  { "MaximilianLloyd/tw-values.nvim" },

  -- TypeScript compiler diagnostics
  {
    "dmmulroy/tsc.nvim",
    config = function()
      require('tsc').setup()
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require('config.lualine')
    end,
  },

  -- Popup library (dependency for other plugins)
  { "nvim-lua/popup.nvim" },

  -- Syntax Highlighting
  { "eloyesp/vim-liquid" },
  { "jidn/vim-dbml" },

  -- Git Integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "LazyGit",
  },

  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('config.gitsigns')
    end,
  },

  -- GitHub PR reviews
  {
    "ldelossa/gh.nvim",
    dependencies = { "ldelossa/litee.nvim" },
    config = function()
      require('config.ghnvim')
    end,
  },

  -- Editing Utilities
  { "reedes/vim-pencil" },
  { "chrisbra/recover.vim" },
  -- { "christoomey/vim-tmux-navigator" }, -- Commented out: test if needed
  { "tpope/vim-unimpaired" },
  { "tpope/vim-surround" },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Themes
  { "sainnhe/edge" },
  { "rebelot/kanagawa.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "olivercederborg/poimandres.nvim" },
  { "neanias/everforest-nvim" },

  -- Completion & Snippets
  {
    "windwp/nvim-autopairs",
    config = function()
      require('config.autopairs')
    end,
  },

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

  {
    "L3MON4D3/LuaSnip",
    config = function()
      require('config.luasnip')
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Search & Navigation
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('config.telescope')
    end,
  },

  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-frecency.nvim" },

  -- File Navigation
  {
    "stevearc/oil.nvim",
    config = function()
      require('config.oil')
    end,
  },

  -- Template String Conversion
  {
    "axelvc/template-string.nvim",
    config = function()
      require('config.template_string')
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require('config.conform')
    end,
  },

  -- Time Tracking
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
