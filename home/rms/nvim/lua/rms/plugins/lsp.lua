-- On NixOS, Mason cannot compile/download binaries (immutable store).
-- LSP servers are provided by Nix via programs.neovim.extraPackages:
--   clang-tools (clangd + clang-format), pyright, black.
-- Mason is kept for its UI but ensure_installed is intentionally empty.
return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                -- NixOS: leave empty; Nix puts servers in PATH instead
                ensure_installed = {},
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            lspconfig.clangd.setup({
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--completion-style=detailed",
                    "--header-insertion=iwyu",
                    "--fallback-style=LLVM",
                },
                filetypes = { "c", "cpp", "cuda" },
            })

            lspconfig.pyright.setup({})

            -- LSP keymaps
            vim.keymap.set("n", "gd",          vim.lsp.buf.definition,  { desc = "Go to definition" })
            vim.keymap.set("n", "K",            vim.lsp.buf.hover,       { desc = "Hover documentation" })
            vim.keymap.set("n", "<leader>rn",   vim.lsp.buf.rename,      { desc = "Rename symbol" })
            vim.keymap.set("n", "<leader>ca",   vim.lsp.buf.code_action, { desc = "Code action" })
        end,
    },
}
