-- lua/rms/plugins/lualine.lua
-- Status line at the bottom of each window.
-- Shows: mode | filename | git branch | diagnostics | filetype | position.
-- Theme is 'auto' so it follows the active colour scheme (rose-pine here).
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                section_separators    = "",  -- no angle/arrow separators between sections
                component_separators  = "",  -- no separators between components
            },
        })
    end,
}
