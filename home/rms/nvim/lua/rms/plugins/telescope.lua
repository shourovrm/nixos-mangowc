-- lua/rms/plugins/telescope.lua
-- Fuzzy finder over files, git objects, buffers, text, and more.
-- Key mappings:
--   <leader>pf  → find files in project
--   <C-p>       → find git-tracked files
--   <leader>fr  → recent files
--   <leader>fh  → find files in home
--   <leader>fa  → find files everywhere (hidden included)
--   <leader>ps  → live grep (search text)
--   <leader>fw  → grep word under cursor
--   <leader>/   → fuzzy search current buffer
--   <leader>pb  → list open buffers
--   <leader>pp  → switch projects
--   <leader>fk  → list keymaps
--   <leader>fc  → list commands
return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin   = require("telescope.builtin")
        local telescope = require("telescope")

        telescope.setup({
            defaults = {
                file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
                layout_strategy = "horizontal",
                layout_config   = { horizontal = { preview_width = 0.55 } },
            },
        })

        telescope.load_extension("projects")

        -- File finding
        vim.keymap.set("n", "<leader>pf", builtin.find_files,  { desc = "Find files in project" })
        vim.keymap.set("n", "<C-p>",      builtin.git_files,   { desc = "Find git files" })
        vim.keymap.set("n", "<leader>fr", builtin.oldfiles,    { desc = "Find recent files" })
        vim.keymap.set("n", "<leader>fh", function()
            builtin.find_files({ cwd = "~" })
        end, { desc = "Find files in home" })
        vim.keymap.set("n", "<leader>fa", function()
            builtin.find_files({ cwd = "/", hidden = true })
        end, { desc = "Find files everywhere" })

        -- Text searching
        vim.keymap.set("n", "<leader>ps", builtin.live_grep,                    { desc = "Search text in project" })
        vim.keymap.set("n", "<leader>fw", builtin.grep_string,                  { desc = "Find word under cursor" })
        vim.keymap.set("n", "<leader>/",  builtin.current_buffer_fuzzy_find,    { desc = "Search in current buffer" })

        -- Buffer / project
        vim.keymap.set("n", "<leader>pb", builtin.buffers,                      { desc = "List buffers" })
        vim.keymap.set("n", "<leader>pp", "<cmd>Telescope projects<cr>",        { desc = "Switch projects" })

        -- Misc
        vim.keymap.set("n", "<leader>fk", builtin.keymaps,  { desc = "Find keymaps" })
        vim.keymap.set("n", "<leader>fc", builtin.commands,  { desc = "Find commands" })
    end,
}
