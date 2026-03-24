-- lua/rms/plugins/git.lua
-- vim-fugitive: full Git integration inside Neovim.
-- vim-rhubarb:  required for :GBrowse to open GitHub URLs.
-- Keymaps:
--   <leader>gs  → interactive Git status buffer
--   <leader>gc  → commit
--   <leader>gp  → push
--   <leader>gP  → pull
--   <leader>gl  → log
--   <leader>gb  → branches
--   <leader>gB  → blame (full file annotation)
--   <leader>gd  → diff split (horizontal)
--   <leader>gD  → diff split (vertical)
--   <leader>ga  → stage current file
--   <leader>gA  → stage all files
--   <leader>gr  → restore (discard changes) current file
--   <leader>go  → open file/selection on GitHub (needs vim-rhubarb)
return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git,            { desc = "Git status" })
            vim.keymap.set("n", "<leader>gc", ":Git commit<CR>",      { desc = "Git commit" })
            vim.keymap.set("n", "<leader>gp", ":Git push<CR>",        { desc = "Git push" })
            vim.keymap.set("n", "<leader>gP", ":Git pull<CR>",        { desc = "Git pull" })
            vim.keymap.set("n", "<leader>gl", ":Git log<CR>",         { desc = "Git log" })
            vim.keymap.set("n", "<leader>gb", ":Git branch<CR>",      { desc = "Git branches" })
            vim.keymap.set("n", "<leader>gB", ":Git blame<CR>",       { desc = "Git blame" })
            vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>",      { desc = "Git diff split" })
            vim.keymap.set("n", "<leader>gD", ":Gvdiffsplit<CR>",     { desc = "Git diff vertical" })
            vim.keymap.set("n", "<leader>ga", ":Git add %<CR>",       { desc = "Git add current file" })
            vim.keymap.set("n", "<leader>gA", ":Git add .<CR>",       { desc = "Git add all" })
            vim.keymap.set("n", "<leader>gr", ":Git restore %<CR>",   { desc = "Git restore current file" })
            vim.keymap.set("n", "<leader>go", ":GBrowse<CR>",         { desc = "Open in browser" })
            vim.keymap.set("v", "<leader>go", ":GBrowse<CR>",         { desc = "Open selection in browser" })
        end,
    },
    -- vim-rhubarb: adds GitHub URL support so :GBrowse opens github.com
    { "tpope/vim-rhubarb" },
}
