-- lua/rms/plugins/format.lua
-- conform.nvim: run code formatters on demand or on save.
-- Formatters used (must be on PATH; provided by neovim.nix extraPackages):
--   C/C++/CUDA → clang-format
--   Python     → black
-- Keymap:
--   <leader>ff  → format current file (falls back to LSP if no formatter matches)
return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                c      = { "clang_format" },
                cpp    = { "clang_format" },
                cuda   = { "clang_format" },
                python = { "black" },
            },
        })

        vim.keymap.set("n", "<leader>ff", function()
            require("conform").format({ lsp_fallback = true })
        end, { desc = "Format file" })
    end,
}
