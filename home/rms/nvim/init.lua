-- nvim/init.lua
-- Entry point. Load order:
--   1. rms.set    → editor options (numbers, tabs, clipboard, diagnostics)
--   2. rms.remap  → global keymaps and <leader> definition
--   3. rms.lazy   → bootstraps lazy.nvim, then loads all plugins

-- Suppress a harmless upstream deprecation warning from nvim-lspconfig
-- that would otherwise appear on every startup.
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
    if name and name:match("lspconfig") then
        return
    end
    return original_deprecate(name, alternative, version, plugin, backtrace)
end

require("rms.set")
require("rms.remap")
require("rms.lazy")
