-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap =
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

vim.cmd(
  [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]
)

local packer = require("packer")

return packer.startup {
  function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"
    -- Commands
    use {
      "folke/which-key.nvim",
      config = [[ require('config/which-key') ]]
    }

    -- Highlights
    use {
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/nvim-treesitter-textobjects"
      },
      config = [[require('config.treesitter')]],
      run = ":TSUpdate"
    }

    -- LSP
    use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig"
    }

    -- Use ,tw to view CSS values from TW classnames
    use "MaximilianLloyd/tw-values.nvim"

    use {
      "weilbith/nvim-code-action-menu"
    }
    use {
      "jose-elias-alvarez/nvim-lsp-ts-utils"
    }

    use {
      "nvim-lualine/lualine.nvim",
      requires = {"kyazdani42/nvim-web-devicons", opt = true},
      config = [[ require('config/lualine') ]]
    }
    use "nvim-lua/popup.nvim"
    use {
      -- Utility functions for getting diagnostic status and progress messages from LSP servers, for use in the Neovim statusline
      "nvim-lua/lsp-status.nvim",
      config = [[ require('config/lsp_status') ]]
    }

    -- Elixir
    use {
      "elixir-tools/elixir-tools.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
      },
      config = [[ require('config/elixir') ]]
    }

    -- Syntax Highlighting
    use "eloyesp/vim-liquid"
    use "elzr/vim-json"
    use "jparise/vim-graphql"
    use "elixir-editors/vim-elixir"

    -- Git
    use {
      "kdheepak/lazygit.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
      }
    }

    -- use "sindrets/diffview.nvim"
    use {
      "lewis6991/gitsigns.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
      },
      config = [[ require('config/gitsigns') ]]
    }

    use {
      "ldelossa/gh.nvim",
      requires = {{"ldelossa/litee.nvim"}},
      config = [[ require('config/ghnvim') ]]
    }

    -- Misc
    use "reedes/vim-pencil" -- nicer markdown settings
    use "chrisbra/recover.vim" -- add "compare" option when a swap file is found
    use "jakelinnzy/autocmd-lua" -- easier autocommands
    -- generate jsdoc comments with :JsDoc
    use {
      "heavenshell/vim-jsdoc",
      cmd = "JsDoc",
      ft = {"js", "jsx", "ts", "tsx"},
      run = "make install"
    }
    use "christoomey/vim-tmux-navigator"
    use "tpope/vim-unimpaired"
    use "tpope/vim-surround" -- surround commands
    use "tpope/vim-commentary" -- use gcc to comment selected lines

    -- TODO Learn these!
    -- use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }

    -- Themes
    -- enable theme in ./settings.lua
    use "rebelot/kanagawa.nvim"

    -- Completion
    use {
      -- A super powerful autopairs for Neovim. It support multiple character.
      "windwp/nvim-autopairs",
      config = [[ require('config/autopairs') ]]
    }

    use {
      -- A completion plugin for neovim coded in Lua.
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for neovim builtin LSP client
        "hrsh7th/cmp-nvim-lua", -- nvim-cmp source for nvim lua
        "hrsh7th/cmp-buffer", -- nvim-cmp source for buffer words.
        "hrsh7th/cmp-path", -- nvim-cmp source for filesystem paths.
        "hrsh7th/cmp-calc", -- nvim-cmp source for math calculation.
        "saadparwaiz1/cmp_luasnip" -- luasnip completion source for nvim-cmp
      },
      config = [[ require('config/cmp') ]]
    }

    use {
      -- Snippet Engine for Neovim written in Lua.
      "L3MON4D3/LuaSnip",
      -- requires = {
      --   "rafamadriz/friendly-snippets" -- Snippets collection for a set of different programming languages for faster development.
      -- },
      config = [[ require('config/luasnip') ]]
    }

    -- Search & Navigation
    use {
      {
        "nvim-telescope/telescope.nvim",
        requires = {
          "nvim-lua/popup.nvim",
          "nvim-lua/plenary.nvim",
          "telescope-frecency.nvim",
          "telescope-fzf-native.nvim",
          "BurntSushi/ripgrep",
          "windwp/nvim-ts-autotag"
        },
        wants = {
          "popup.nvim",
          "plenary.nvim",
          "telescope-frecency.nvim",
          "telescope-fzf-native.nvim"
        },
        config = [[require('config.telescope')]],
        cmd = "Telescope",
        module = "telescope"
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        after = "telescope.nvim",
        requires = "tami5/sql.nvim"
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make"
      }
    }

    use {
      -- File explorer
      "kyazdani42/nvim-tree.lua",
      requires = "kyazdani42/nvim-web-devicons",
      config = [[ require('config/nvim-tree') ]],
      setup = [[ require('config/nvim-tree-setup') ]]
    }

    -- OpenAI
    use(
      {
        "jackMort/ChatGPT.nvim",
        config = [[ require('config/chatgpt') ]],
        requires = {
          "MunifTanjim/nui.nvim",
          "nvim-lua/plenary.nvim"
          -- "nvim-telescope/telescope.nvim"
        }
      }
    )

    use {
      "axelvc/template-string.nvim",
      config = [[require('config.template-string')]]
    }

    -- use "nvim-treesitter/nvim-treesitter-textobjects"
    --
    -- use {
    --   "lukas-reineke/indent-blankline.nvim",
    --   config = [[ require('plugins/blankline') ]]
    -- }
    --
    -- use {
    --   -- UNIX commands in vim, i.e. :Mkdir
    --   "tpope/vim-eunuch"
    -- }
    --
    --
    --
    --
    -- use {
    --   "folke/zen-mode.nvim",
    --   config = [[ require('plugins/zen-mode') ]]
    -- }
    --
    -- use {
    --   "ThePrimeagen/git-worktree.nvim",
    --   config = [[ require('plugins/git-worktree') ]]
    -- }
    --
    use {
      "mhartington/formatter.nvim",
      config = [[ require('config/formatter') ]]
    }
    --
    -- use {
    --   "kmonad/kmonad-vim"
    -- }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require("packer").sync()
    end
  end
}
