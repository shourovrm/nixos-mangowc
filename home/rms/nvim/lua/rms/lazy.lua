-- lua/rms/lazy.lua
-- Bootstraps lazy.nvim (the plugin manager) and loads all plugins under
-- lua/rms/plugins/.  On NixOS the Nix store is read-only, so lazy and all
-- plugin data are kept in ~/.local/share/nvim/ (stdpath("data")).

-- Clone lazy.nvim into the writable data dir if it isn’t there yet
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("rms.plugins", {
  -- Keep lock file in the data dir so the read-only Nix-store config is untouched
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
