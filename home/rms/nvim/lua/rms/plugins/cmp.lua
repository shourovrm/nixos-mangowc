-- lua/rms/plugins/cmp.lua
-- Completion engine wired to three sources:
--   nvim_lsp  → LSP completions (clangd, pyright, etc.)
--   buffer    → words visible in open buffers
--   path      → filesystem paths
-- <CR> confirms the selected suggestion.
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            },
        })
    end,
}
