-- lua/rms/remap.lua
-- Global keymaps. Plugin-specific maps live inside each plugin's config.

vim.g.mapleader = " "  -- <Space> is the leader key for all <leader> mappings

-- <leader>pv → open the built-in Ex file browser in the current directory
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
