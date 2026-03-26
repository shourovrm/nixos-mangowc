# Neovim Guide

Full-featured Neovim setup managed in this Nix repo. Config lives in `home/rms/nvim/` and is symlinked to `~/.config/nvim/` by Home Manager on every rebuild.

---

## How it works

| Component | Role |
| --- | --- |
| **Nix** (`neovim.nix`) | Installs Neovim + LSP servers + formatters; symlinks Lua config |
| **lazy.nvim** | Plugin manager — self-bootstraps on first launch, downloads plugins to `~/.local/share/nvim/lazy/` |
| **Mason** | Plugin UI kept for browsing but **not** used for installing on NixOS (Nix provides LSP servers) |

**LSP servers provided by Nix:** `clangd` (C/C++/CUDA), `pyright` (Python).  
**Formatters:** `clang-format` (C/C++), `black` (Python).

---

## Installation (first time)

### 1 — Apply the NixOS config

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop
```

### 2 — First launch — let lazy.nvim install plugins

```bash
nvim
```

On the very first launch lazy.nvim clones itself and all plugins. This requires an internet connection and takes ~30 seconds. Wait for it to finish (you'll see a progress window).

Tree-sitter parsers are compiled automatically on the first open of each file type; `gcc` (provided by Nix) handles the compilation.

### 3 — Authenticate GitHub Copilot (optional)

```
:Copilot auth
```

Follow the browser prompt. Only needed once.

---

## Updating plugins

```vim
:Lazy sync
```

Or press `u` on the dashboard.

---

## Leader key

`<Space>`

Press `<leader>?` at any time to see a popup of all keybindings.

---

## Shortcuts reference

### General

| Key | Action |
| --- | --- |
| `<leader>?` | Show all keybindings (which-key popup) |
| `<leader>pv` | Open Netrw file browser |

### 📁 File Explorer (Oil)

| Key | Action |
| --- | --- |
| `<leader>e` | Toggle sidebar file explorer |
| `<CR>` (in Oil) | Open file / enter directory |
| `-` (in Oil) | Go to parent directory |
| `_` (in Oil) | Open in horizontal split |
| `<C-v>` (in Oil) | Open in vertical split |
| `g?` (in Oil) | Show Oil help |
| `<C-w>l` | Move to code window from sidebar |

### 🔭 Telescope (Fuzzy Finder)

| Key | Action |
| --- | --- |
| `<leader>pf` | Find files in project |
| `<C-p>` | Find git-tracked files |
| `<leader>fr` | Recent files |
| `<leader>fh` | Find files in home dir |
| `<leader>fa` | Find files everywhere |
| `<leader>ps` | Live grep (search text) |
| `<leader>fw` | Find word under cursor |
| `<leader>/` | Search in current buffer |
| `<leader>pb` | List open buffers |
| `<leader>pp` | Switch projects |
| `<leader>fk` | Find keymaps |
| `<leader>fc` | Find commands |

### 📋 Buffers

| Key | Action |
| --- | --- |
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>bd` | Close buffer |

### 🔧 LSP

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |

### 🔍 Format

| Key | Action |
| --- | --- |
| `<leader>ff` | Format current file (clang-format / black) |

### 🌿 Git (vim-fugitive)

| Key | Action |
| --- | --- |
| `<leader>gs` | Git status window |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gP` | Git pull |
| `<leader>gl` | Git log |
| `<leader>gb` | Git branches |
| `<leader>gB` | Git blame |
| `<leader>gd` | Git diff split |
| `<leader>ga` | Stage current file |
| `<leader>gA` | Stage all |
| `<leader>gr` | Restore current file |

### 🔧 Git Hunks (gitsigns)

| Key | Action |
| --- | --- |
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hR` | Reset entire buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hu` | Undo stage hunk |
| `<leader>hd` | Diff this |

### 🔄 Toggles

| Key | Action |
| --- | --- |
| `<leader>tb` | Toggle current-line git blame |
| `<leader>td` | Toggle deleted lines |

### 🔧 Diagnostics (Trouble)

| Key | Action |
| --- | --- |
| `<leader>xx` | Toggle diagnostics panel |
| `<leader>xw` | Toggle workspace diagnostics |

### 🤖 Copilot (AI)

**Inline suggestions**

| Key | Action |
| --- | --- |
| `<C-l>` | Accept suggestion |
| `<C-j>` | Next suggestion |
| `<C-k>` | Previous suggestion |
| `<C-h>` | Dismiss suggestion |

**CopilotChat sidebar** (select code in visual mode, then press shortcut)

| Key | Action |
| --- | --- |
| `<leader>cc` | Toggle chat sidebar |
| `<leader>cr` | Reset chat |
| `<leader>ce` | Explain code |
| `<leader>cf` | Fix code |
| `<leader>co` | Optimize code |
| `<leader>ct` | Write tests |
| `<leader>cd` | Write docs |

### 💬 Comments

| Key | Action |
| --- | --- |
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc` (visual) | Comment selection |

---

## Adding a new language

1. **LSP server** — add to `programs.neovim.extraPackages` in `home/rms/home-modules/neovim.nix`, then add `lspconfig.<server>.setup({})` in `home/rms/nvim/lua/rms/plugins/lsp.lua`.
2. **Tree-sitter parser** — add the language to `ensure_installed` in `home/rms/nvim/lua/rms/plugins/treesitter.lua`.
3. **Formatter** — add `{ ft = { "formatter" } }` in `home/rms/nvim/lua/rms/plugins/format.lua` and the tool to `extraPackages`.

---

## Config layout

```
home/rms/nvim/
├── init.lua                     ← entry point
└── lua/rms/
    ├── set.lua                  ← editor options (clipboard = "unnamedplus")
    ├── remap.lua                ← base keymaps
    ├── lazy.lua                 ← lazy.nvim bootstrap
    └── plugins/
        ├── init.lua             ← returns {} — lazy auto-discovers all *.lua files
        ├── alpha.lua            ← dashboard
        ├── bufferline.lua       ← buffer tabs
        ├── cmp.lua              ← completion
        ├── colors.lua           ← rose-pine theme
        ├── comment.lua          ← comment toggle
        ├── copilot.lua          ← GitHub Copilot inline
        ├── copilotchat.lua      ← CopilotChat sidebar
        ├── format.lua           ← conform.nvim formatter
        ├── git.lua              ← vim-fugitive + vim-rhubarb
        ├── gitsigns.lua         ← gutter git signs + hunk ops
        ├── lsp.lua              ← LSP config (Mason UI only on NixOS)
        ├── lualine.lua          ← status bar
        ├── oil.lua              ← file explorer sidebar
        ├── projects.lua         ← project detection
        ├── telescope.lua        ← fuzzy finder
        ├── treesitter.lua       ← syntax + indent
        ├── trouble.lua          ← diagnostics panel
        └── whichkey.lua         ← keybinding popup
```

---

## System clipboard (Wayland)

`vim.opt.clipboard = "unnamedplus"` is set in `set.lua`, so yanks/pastes use the
OS clipboard by default. On Wayland, Neovim uses `wl-copy` / `wl-paste` from the
`wl-clipboard` package (provided via `extraPackages` in `neovim.nix`).

| Action | Neovim shortcut |
| --- | --- |
| Yank to system clipboard | `y` (any normal yank) |
| Paste from system clipboard | `p` (normal paste) |
| Paste from clipboard in insert mode | `<C-r>+` |

> No `"+y` / `"+p` prefix needed—the `+` register is always active.

---

## Notes for NixOS

- **Mason** is installed but cannot compile binaries on NixOS. It's kept for its UI (`:Mason`). All actual LSP servers come from Nix.
- **Plugin lock file** is written to `~/.local/share/nvim/lazy-lock.json` (not inside the symlinked `~/.config/nvim/`).
- **Tree-sitter** compiles parsers using `gcc` from Nix on the first file open.
- A **Nerd Font** is recommended for icon glyphs in the status bar, file explorer, and dashboard. Install one and set it in your terminal emulator (`foot`).
