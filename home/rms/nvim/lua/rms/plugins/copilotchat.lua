-- lua/rms/plugins/copilotchat.lua
-- CopilotChat: AI chat panel (vertical split, 30% width) for code Q&A.
-- `build = "make tiktoken"` is intentionally omitted — it needs Rust toolchain
-- and is not required for normal use.
-- Keymaps (`<leader>c` group):
--   <leader>cc  → toggle chat panel
--   <leader>cr  → reset chat history
--   <leader>ce  → explain selected code
--   <leader>cf  → fix selected code
--   <leader>co  → optimise selected code
--   <leader>ct  → write tests for selection
--   <leader>cd  → write documentation for selection
return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim", branch = "master" },
    },
    config = function()
        local chat = require("CopilotChat")

        chat.setup({
            window = {
                layout = "vertical",
                width  = 0.3,
                height = 1.0,
            },
            show_help = true,
            model     = "claude-haiku-4.5",
        })

        vim.keymap.set({ "n", "v" }, "<leader>cc", function() chat.toggle() end,
            { desc = "Toggle Copilot Chat" })
        vim.keymap.set({ "n", "v" }, "<leader>cr", function() chat.reset() end,
            { desc = "Reset Copilot Chat" })
        vim.keymap.set({ "n", "v" }, "<leader>ce", function()
            chat.ask("Explain this code in detail",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Explain Code" })
        vim.keymap.set({ "n", "v" }, "<leader>cf", function()
            chat.ask("Fix this code and explain what was wrong",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Fix Code" })
        vim.keymap.set({ "n", "v" }, "<leader>co", function()
            chat.ask("Optimize this code for better performance",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Optimize Code" })
        vim.keymap.set({ "n", "v" }, "<leader>ct", function()
            chat.ask("Write comprehensive tests for this code",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Write Tests" })
        vim.keymap.set({ "n", "v" }, "<leader>cd", function()
            chat.ask("Write documentation for this code",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Write Docs" })
    end,
}
