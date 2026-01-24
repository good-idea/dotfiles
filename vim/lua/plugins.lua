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
    -- use {
    --   "folke/which-key.nvim",
    --   config = [[ require('config/which-key') ]]
    -- }

    -- Highlights
    use {
      "nvim-treesitter/nvim-treesitter",
      config = [[require('config.treesitter')]]
      -- run = ":TSUpdate"
    }

    -- LSP & language stuff
    use {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig"
    }
    use {"davidosomething/format-ts-errors.nvim"}

    -- Automatically create & rename open/close tags
    -- Before        Input         After
    -- ------------------------------------
    -- <div           >              <div></div>
    -- <div></div>    ciwspan<esc>   <span></span>
    -- ------------------------------------
    use {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end
    }

    -- Use ,tw to view CSS values from TW classnames
    use "MaximilianLloyd/tw-values.nvim"
    -- use :TSC to get workspace typescript diagnostics
    use {
      "dmmulroy/tsc.nvim",
      config = [[ require('tsc').setup() ]]
    }

    use {
      "nvim-lualine/lualine.nvim",
      requires = {"kyazdani42/nvim-web-devicons", opt = true},
      config = [[ require('config/lualine') ]]
    }
    use "nvim-lua/popup.nvim"

    -- Syntax Highlighting
    use "eloyesp/vim-liquid"
    use "jidn/vim-dbml"

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

    -- Github PR reviews
    use {
      "ldelossa/gh.nvim",
      requires = {{"ldelossa/litee.nvim"}},
      config = [[ require('config/ghnvim') ]]
    }

    -- Misc
    use "reedes/vim-pencil" -- nicer markdown settings
    use "chrisbra/recover.vim" -- add "compare" option when a swap file is found
    -- use "christoomey/vim-tmux-navigator" -- Commented out: test if needed
    use "tpope/vim-unimpaired"
    use "tpope/vim-surround" -- surround commands
    use "tpope/vim-commentary" -- use gcc to comment selected lines

    -- TODO Learn these!
    -- use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }

    -- Themes
    use "sainnhe/edge"
    -- use "yorik1984/newpaper.nvim"
    use "rebelot/kanagawa.nvim"
    use {"catppuccin/nvim", as = "catppuccin"}
    use "olivercederborg/poimandres.nvim"
    use "neanias/everforest-nvim"

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

    use {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } }
        }
      }
    }

    -- Search & Navigation
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
        -- Not sure if this is necessary anymore?
        -- "BurntSushi/ripgrep",
      },
      config = [[require('config.telescope')]]
    }
    use {
      "nvim-telescope/telescope-ui-select.nvim"
    }
    use {
      "nvim-telescope/telescope-frecency.nvim"
    }

    use {
      "stevearc/oil.nvim",
      config = [[ require('config/oil') ]]
    }

    -- OpenAI
    -- use(
    --   {
    --     "jackMort/ChatGPT.nvim",
    --     config = [[ require('config/chatgpt') ]],
    --     requires = {
    --       "MunifTanjim/nui.nvim",
    --       "nvim-lua/plenary.nvim"
    --       -- "nvim-telescope/telescope.nvim"
    --     }
    --   }
    -- )

    use {
      "axelvc/template-string.nvim",
      config = [[require('config.template-string')]]
    }

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
      "stevearc/conform.nvim",
      config = [[ require('config/conform') ]]
    }

    -- time tracking
    use "wakatime/vim-wakatime"
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
