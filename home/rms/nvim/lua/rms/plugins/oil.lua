-- lua/rms/plugins/oil.lua
-- File explorer that renders directories as editable buffers.
-- Edit filenames, permissions, or delete lines to rename/delete files.
-- Keymap:
--   <leader>e  → toggle Oil sidebar (32-col split on the left)
return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            view_options = { show_hidden = true },
            columns = { "icon", "permissions", "size" },
            close_on_select         = false,
            skip_confirm_for_simple_edits = true,
        })

        -- Toggle Oil sidebar (left side)
        local oil_sidebar_win = nil

        vim.keymap.set("n", "<leader>e", function()
            if oil_sidebar_win and vim.api.nvim_win_is_valid(oil_sidebar_win) then
                vim.api.nvim_win_close(oil_sidebar_win, false)
                oil_sidebar_win = nil
            else
                vim.cmd("topleft vsplit")
                require("oil").open()
                oil_sidebar_win = vim.api.nvim_get_current_win()
                vim.cmd("vertical resize 32")
            end
        end, { desc = "Toggle Oil Explorer" })

        -- Auto-open Oil when Neovim is given a directory as argument
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                if vim.fn.argc() == 1 then
                    local arg = vim.fn.argv(0)
                    if vim.fn.isdirectory(arg) == 1 then
                        vim.cmd("vsplit | Oil " .. arg)
                        vim.cmd("wincmd h")
                    end
                end
            end,
        })

        -- Fixed sidebar width
        vim.api.nvim_create_autocmd("FileType", {
            pattern  = "oil",
            callback = function() vim.cmd("vertical resize 32") end,
        })
    end,
}
