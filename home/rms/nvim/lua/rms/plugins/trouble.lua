-- lua/rms/plugins/trouble.lua
-- Pretty diagnostic list (errors, warnings, hints) in a bottom panel.
-- Useful for seeing all project-wide issues without jumping file by file.
-- Keymaps:
--   <leader>xx  → toggle diagnostics panel
--   <leader>xw  → toggle workspace diagnostics (all open files)
return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("trouble").setup({})
        vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",           { desc = "Toggle diagnostics" })
        vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics toggle<cr>", { desc = "Workspace diagnostics" })
    end,
}
