-- lua/rms/plugins/whichkey.lua
-- Shows a popup listing available keybindings after a prefix is pressed.
-- Groups are labelled so the popup is readable (e.g. <leader>p = Telescope/Project).
-- Keymap:
--   <leader>?  → show all normal-mode keybindings immediately
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")

        wk.setup({
            spec = {
                { "<leader>p",  group = "🔭 Telescope/Project" },
                { "<leader>b",  group = "📋 Buffer" },
                { "<leader>c",  group = "🤖 Copilot Chat" },
                { "<leader>f",  group = "🔍 Find/Format" },
                { "<leader>g",  group = "🌿 Git" },
                { "<leader>h",  group = "🔧 Git Hunk" },
                { "<leader>t",  group = "🔄 Toggle" },
                { "<leader>x",  group = "🔧 Trouble/Diagnostics" },
                { "<leader>e",  desc  = "📁 Toggle File Explorer" },
                { "<leader>?",  desc  = "❓ Show All Keymaps" },
            },
            win = {
                border  = "rounded",
                padding = { 1, 2 },
            },
        })

        vim.keymap.set("n", "<leader>?", function()
            wk.show({ mode = "n" })
        end, { desc = "Show All Keybindings" })
    end,
}
