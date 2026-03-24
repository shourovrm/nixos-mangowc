-- lua/rms/plugins/treesitter.lua
-- Syntax highlighting and indentation using Tree-sitter parsers.
-- Parsers listed under ensure_installed are downloaded on first launch.
-- On NixOS, gcc (from extraPackages in neovim.nix) is required to compile them.
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then return end

        configs.setup({
            ensure_installed = {
                "lua", "python", "cpp", "c", "json", "bash", "markdown",
            },
            highlight = { enable = true },
            indent    = { enable = true },
        })
    end,
}
