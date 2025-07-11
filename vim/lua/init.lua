require("plugins")
require("config/lsp_config")
require("commands")
require("settings")
require("keybindings")

-- Uncomment to enable profiling.
--
-- Run a profile by:
-- - $ NVIM_PROFILE=1 nvim
-- - prepare to do the thing you want to profile
-- - enter <leader>P to begin profiling
-- - do the slow thing
-- - enter <leader>P to stop profiling and export the results
--
-- local should_profile = os.getenv("NVIM_PROFILE")
-- if should_profile then
--   require("profile").instrument_autocmds()
--   if should_profile:lower():match("^start") then
--     require("profile").start("*")
--   else
--     require("profile").instrument("*")
--   end
-- end

-- local function toggle_profile()
--   local prof = require("profile")
--   if prof.is_recording() then
--     prof.stop()
--     vim.ui.input(
--       {prompt = "Save profile to:", completion = "file", default = "profile.json"},
--       function(filename)
--         if filename then
--           prof.export(filename)
--           vim.notify(string.format("Wrote %s", filename))
--         end
--       end
--     )
--   else
--     vim.notify("Beginning profiling")
--     prof.start("*")
--   end
-- end
-- vim.keymap.set("", "<leader>P", toggle_profile)
