-- Ensure dotfiles lua directory is in package path
local config_path = vim.fn.stdpath("config")
package.path = package.path .. ";" .. config_path .. "/lua/?.lua"
package.path = package.path .. ";" .. vim.fn.expand("~/.dotfiles/vim/lua/?.lua")

require("plugins")
require("commands")
require("settings")
require("keybindings")
