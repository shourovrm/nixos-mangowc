-- lua/rms/plugins/comment.lua
-- Toggle code comments with ergonomic keys (works with any language treesitter knows).
-- Keymaps:
--   gcc         → toggle comment on current line
--   gbc         → toggle block comment
--   gc{motion}  → line-comment over a motion (e.g. gc5j = comment 5 lines down)
--   gb{motion}  → block-comment over a motion
return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup({
            toggler = {
                line  = "gcc",   -- Toggle comment on current line
                block = "gbc",   -- Toggle block comment
            },
            opleader = {
                line  = "gc",    -- Operator for line comments
                block = "gb",    -- Operator for block comments
            },
        })
    end,
}
