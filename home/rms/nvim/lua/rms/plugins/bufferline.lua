-- lua/rms/plugins/bufferline.lua
-- Buffer tabs rendered at the top of the screen.
-- Keymaps:
--   <Tab>       → next buffer
--   <S-Tab>     → previous buffer
--   <leader>bd  → delete (close) current buffer
return {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("bufferline").setup({
            options = {
                diagnostics          = "nvim_lsp",  -- show error/warn counts in tabs
                separator_style      = "slant",     -- triangular tab separators
                show_buffer_close_icons = true,
                show_close_icon         = false,    -- hide X on the right edge of the bar
            },
        })

        vim.keymap.set("n", "<Tab>",   ":BufferLineCycleNext<CR>")
        vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")
        vim.keymap.set("n", "<leader>bd", ":bd<CR>")
    end,
}
