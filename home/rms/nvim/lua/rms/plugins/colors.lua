-- lua/rms/plugins/colors.lua
-- Colour scheme: rose-pine (moon/dawn/main variants available).
-- Switch variant by passing `{ style = "moon" }` to setup() if desired.
return {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        vim.cmd("colorscheme rose-pine")
    end,
}
