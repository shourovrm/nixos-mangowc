-- lua/rms/set.lua
-- Editor behaviour and appearance options.

vim.opt.number         = true  -- show absolute line numbers
vim.opt.relativenumber = true  -- show relative numbers (easy jump distances)
vim.opt.cursorline     = true  -- highlight the line the cursor is on
vim.opt.tabstop        = 4     -- a tab character is 4 spaces wide
vim.opt.shiftwidth     = 4     -- indent/dedent by 4 spaces
vim.opt.expandtab      = true  -- insert spaces instead of real tab characters

-- Use system clipboard so yanked text is available outside Neovim (wl-clipboard)
vim.opt.clipboard = "unnamedplus"

-- Diagnostic display: show inline virtual text; update only after leaving insert mode
vim.diagnostic.config({
    virtual_text      = true,
    signs             = true,
    underline         = true,
    update_in_insert  = false,
})

-- Register the .cu extension as CUDA so Tree-sitter and LSP use the cuda filetype
vim.filetype.add({
    extension = {
        cu = "cuda",
    },
})
