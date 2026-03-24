-- lua/rms/plugins/copilot.lua
-- GitHub Copilot inline suggestions (ghost text while typing).
-- Requires a Copilot subscription; run `:Copilot auth` once to authenticate.
-- Keymaps (in insert mode):
--   <C-l>  → accept suggestion
--   <C-j>  → next suggestion
--   <C-k>  → previous suggestion
--   <C-h>  → dismiss suggestion
return {
    "zbirenbaum/copilot.lua",
    cmd   = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled     = true,
                auto_trigger = true,
                keymap = {
                    accept  = "<C-l>",
                    next    = "<C-j>",
                    prev    = "<C-k>",
                    dismiss = "<C-h>",
                },
            },
            panel = { enabled = false },
        })
    end,
}
