-- lua/rms/plugins/alpha.lua
-- Dashboard / start screen shown when Neovim opens with no file argument.
-- Displays a custom ASCII header, quick-action buttons, and a status footer
-- (date/time, plugin count, Neovim version).
return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
        }

        dashboard.section.buttons.val = {
            dashboard.button("e", "  New file",      ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", "󰈞  Find file",    ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "  Find text",    ":Telescope live_grep<CR>"),
            dashboard.button("p", "  Projects",     ":Telescope projects<CR>"),
            dashboard.button("c", "  Config",       ":e ~/.config/nvim/init.lua<CR>"),
            dashboard.button("h", "  Home",         ":e ~/<CR>"),
            dashboard.button("d", "  Documents",    ":e ~/Documents<CR>"),
            dashboard.button("u", "  Update plugins", ":Lazy sync<CR>"),
            dashboard.button("q", "  Quit",         ":qa<CR>"),
        }

        local function footer()
            local total_plugins = require("lazy").stats().count
            local datetime = os.date("  %Y-%m-%d   %H:%M:%S")
            local version = vim.version()
            local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
            return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
        end

        dashboard.section.footer.val = footer()
        dashboard.section.footer.opts.hl = "Constant"

        alpha.setup(dashboard.opts)

        vim.cmd([[
            autocmd FileType alpha setlocal nofoldenable
        ]])
    end,
}
