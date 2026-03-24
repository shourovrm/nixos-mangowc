-- lua/rms/plugins/projects.lua
-- Detects project roots by looking for marker files (.git, Makefile, etc.).
-- Integrates with Telescope (<leader>pp) to jump between recent projects.
-- Project history is stored in ~/.local/share/nvim/project_nvim/.
return {
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup({
            detection_methods = { "pattern" },
            patterns = { ".git", "Makefile", "CMakeLists.txt", "pyproject.toml" },
        })
    end,
}
