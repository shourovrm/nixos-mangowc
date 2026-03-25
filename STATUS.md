# System Status

> Keep this file updated after every change. Add a new entry under **Changelog** with today's date and a brief summary of what changed.

---

## Current configuration — 2026-03-25

### Host

| Field | Value |
| --- | --- |
| Hostname | `rms-laptop` |
| Channel | `nixos-unstable` |
| State version | `25.11` |
| Boot | GRUB + EFI |

### Desktop

| Concern | Detail |
| --- | --- |
| Display manager | greetd + tuigreet |
| Desktop (fallback) | none |
| Wayland compositor | Niri |
| Status bar | Noctalia Shell |
| Wallpaper | `wallhaven_eo2p3w.jpg` (Noctalia wallpaper engine via `~/.local/share/wallpapers/`) |
| Audio | PipeWire |
| Bluetooth | enabled (blueman) |
| Keyring | gnome-keyring-daemon (PAM auto-unlock at greetd) |
| Keyboard layouts | English (US) + Bangla Probhat — `Super+Space` to switch |

### System packages (in `configuration.nix`)

`git` `wget` `curl` `zathura`

### User packages (Home Manager — `packages.nix`)

`opencode` `firefox` `btop` `ripgrep` `fd` `bat` `eza` `mpv` `gparted` `libreoffice` `evince` `nodejs` `uv` `miktex` `perl` `distrobox` `podman` `newsboat` `yt-dlp` `links2` `taskspooler` `urlscan`

### File management / cloud packages (Home Manager — `filemanager.nix`)

`rclone` `keepassxc`

### Custom scripts (Home Manager — `pkgs/` + `scripts.nix`)

| Script | Binary | Purpose |
| --- | --- | --- |
| `fuzzel-handler` | `fuzzel-handler` | fuzzel --dmenu URL/file handler (open, mpv, yt-dlp, etc.) |
| `link-handler` | `link-handler` | Smart URL dispatcher used as newsboat browser |
| `qndl` | `qndl`, `qndl-audio` | Queue downloads with task-spooler (tsp) |
| `newsboat-utils` | `newsboat-count`, `newsboat-open` | Noctalia bar newsboat widget helpers |
| `weather-utils` | `weather-bar`, `weather-open` | Noctalia bar weather widget (wttr.in emoji + temp; 30 min refresh; click shows forecast) |
| `nvim-open` | `nvim-open` | Open files in nvim inside foot; foot closes when nvim exits (desktop entry uses a Neovim icon) |

### VSCode (Home Manager — `vscode.nix`)

Wayland + gnome-libsecret flags; extensions: **LaTeX Workshop** (`james-yu.latex-workshop`)

### Niri session tools (in `home/rms/home-modules/niri.nix`)

`fuzzel` `raffi` `foot` `swaylock` `swayidle` `wl-clipboard` `wlopm` `grim` `slurp` `libnotify` `mako` `brightnessctl` `playerctl` `gcr`

### Active Home Manager modules

| Module | Purpose |
| --- | --- |
| `packages.nix` | User packages |
| `scripts.nix` | Wires `pkgs/` custom scripts into home.packages |
| `vscode.nix` | VSCode with Wayland flags + LaTeX Workshop extension |
| `git.nix` | Git config |
| `bash.nix` | Shell config + general venv auto-activate |
| `gtk.nix` | GTK theme + dconf + `GTK_THEME` / cursor env vars |
| `clipboard.nix` | cliphist clipboard watcher service |
| `foot.nix` | foot terminal — Catppuccin Mocha, JetBrains Mono 10pt, 5% transparency |
| `neovim.nix` | Neovim + LSP servers (clangd, pyright, black, gcc) + wl-clipboard + symlink `home/rms/nvim/` → `~/.config/nvim/` |
| `newsboat.nix` | Newsboat RSS reader — vim keybinds, macros, Catppuccin colours, 22 feeds |
| `niri.nix` | Niri KDL config + session tools + power management |
| `filemanager.nix` | Thunar default, udiskie, rclone, KeePassXC, `~/GoogleDrive` mountpoint |
| `noctalia.nix` | Noctalia bar (widgets, colours, location) |

### Launcher

| Concern | Detail |
| --- | --- |
| Default launcher | Raffi using Fuzzel UI (`Super+D`) |
| Alt launcher | Noctalia launcher (`Super+Shift+D`) |
| Raffi config | `~/.config/raffi/raffi.yaml` |
| Fuzzel config | `~/.config/fuzzel/fuzzel.ini` |

### Cloud sync

| Concern | Detail |
| --- | --- |
| Tool | `rclone` |
| Expected Google Drive remote | `gdrive` |
| Local mountpoint | `~/GoogleDrive` |

### Noctalia bar widgets

- **Left:** ControlCenter (distro logo), Network, Bluetooth
- **Center:** Workspace
- **Right:** KeyboardLayout, SystemMonitor (RAM %, net speed, disk % shown inline), Volume, Battery, Weather (CustomButton — wttr.in emoji + temp, click=forecast), Newsboat unread count (CustomButton), DarkMode toggle, Clock, SessionMenu

### Niri keybinds (notable)

| Key | Action |
| --- | --- |
| `Super+D` | Open Raffi launcher (fuzzel UI) |
| `Super+Shift+D` | Toggle Noctalia launcher |
| `Super+Space` | Switch keyboard layout (next) |
| `Super+T` | Open foot terminal |
| `Super+S` | Full-screen screenshot |
| `Print` | Interactive region screenshot |

### Screenshot keybinds

| Key | Action |
| --- | --- |
| `Print` | Interactive region select |
| `Super + S` | Full-screen screenshot |
| `Alt + Print` | Active window screenshot |

### Idle / power (swayidle)

| Trigger | Action |
| --- | --- |
| 5 min idle | `swaylock` dark screen (`-c 1a1a2e`) |
| 10 min idle | Monitors off (`wlopm --off '*'`) |
| Before sleep | `swaylock` (lid close, etc.) |
| 3 h idle on battery | Suspend |
| On AC power | Never auto-suspends |

### Notification timeout (mako)

5 seconds (`default-timeout = 5000`)

### Python environments (uv)

| Env | Path | Purpose |
| --- | --- | --- |
| general (default) | `~/.venv/general` | Everyday packages; auto-activated in bash |

---

## Changelog

### 2026-03-25

- **Docs review:** refreshed all guides to match the current Niri-only setup, standardized commands around `~/nixos-config-v2`, and removed stale Home Manager-only post-install steps
- **Rclone guide:** added `guides/rclone.md` covering Google Drive remote setup, mounting, and the repo's `gdrive` / `~/GoogleDrive` convention
- **Shell aliases:** fixed `nixswitch` and `nixup` to point at `~/nixos-config-v2` so the documented commands match the actual bash config
- **Home Manager layout:** renamed the Home Manager tree to `home/rms/home-modules/` and updated imports, docs, and status references to match
- **Niri-only session:** removed MangoWC from the host and Home Manager imports, dropped mango-specific docs/modules, and made tuigreet advertise Niri as the only compositor session
- **Portals and keyring:** switched Niri screen sharing to `xdg-desktop-portal-gnome`, kept GTK as the file chooser portal, enabled system-level `gnome-keyring` with PAM unlock, and added `gcr` for keyring prompts
- **Lightweight desktop:** removed the leftover standalone wallpaper dependency, kept Noctalia as the only wallpaper layer, set `GTK_THEME`, made Thunar the default directory handler, and fixed idle timing to lock at 5 min and power displays off at 10 min
- **Launcher:** added `raffi` on top of `fuzzel`, seeded `~/.config/raffi/raffi.yaml` plus a matching `fuzzel.ini`, and made `Super+D` the default launcher while keeping Noctalia's launcher on `Super+Shift+D`
- **Google Drive:** kept `rclone` installed, created a stable `~/GoogleDrive` mountpoint, and aligned docs/launcher entries around an interactive `gdrive` remote created with `rclone config`

### 2026-03-24 (session 11)

- **Noctalia wallpaper engine:** switched v2 from a standalone wallpaper setter to Noctalia's built-in wallpaper layer; wallpaper now comes from `~/.local/share/wallpapers/` and uses `wallhaven_eo2p3w.jpg` as the seeded default with transitions disabled
- **MangoWC idle / power:** MangoWC now locks after 5 min, turns displays off after 10 min via `wlopm`, locks before sleep, and only suspends after 3 h on battery; on AC it never auto-suspends
- **Status / docs:** refreshed v2 status to reflect greetd + tuigreet, MangoWC availability, Noctalia wallpaper handling, and updated session tooling

### 2026-03-23 (session 4)

- **Fix:** `switch-keyboard-layout` is not a valid niri action name; corrected to `switch-layout "next"` — niri config was failing to parse, causing the status bar and wallpaper not to load; confirmed valid with `niri validate`

### 2026-03-23 (session 5)

- **Foot:** updated the terminal colour section to `[colors-dark]` to match upstream foot syntax and remove the deprecation warning
- **Neovim wrapper:** `nvim-open` now execs Neovim through foot with a proper app id/title, and the Home Manager desktop entry now advertises Neovim instead of a generic launcher
- **Widgets:** weather now shows a weather symbol plus temperature from wttr.in, and Newsboat now shows the unread count directly in the bar

### 2026-03-23 (session 6)

- **Widgets:** hid the built-in left icon on both Noctalia CustomButton widgets so the weather and Newsboat buttons stay text-only apart from their emoji/status text

### 2026-03-23 (session 3)

- **Fix:** `packages.nix` had a syntax error (`];` merged onto same line as `urlscan`) — fixed
- **Fix:** `task-spooler` is not a valid Nix identifier; corrected to `taskspooler` (the actual nixpkgs attribute name)
- **Weather widget:** Added `pkgs/weather-utils/` with `weather-bar` (fetches current temperature from `wttr.in`, 30 min refresh) and `weather-open` (opens full 3-day forecast in foot terminal); wired into `scripts.nix`, `flake.nix`, and Noctalia bar as a `CustomButton` widget before Newsboat

### 2026-03-23 (session 2)

- **Keyboard layout:** `Alt+Shift` → `Super+Space`; added `KeyboardLayout` widget to Noctalia bar right side
- **Noctalia launcher:** `Super+D` now opens Noctalia launcher (was fuzzel); fuzzel still available via `fuzzel-handler`
- **DarkMode widget:** Added DarkMode toggle to Noctalia bar right side
- **Neovim:** Fixed all 12 plugin specs (missing name as first element); `init.lua` now returns `{}` (lazy auto-discovers); `git.lua` refactored to include vim-rhubarb; added `wl-clipboard` to extraPackages for Wayland clipboard (`unnamedplus` register)
- **pkgs/ system:** Created custom derivations: `fuzzel-handler`, `link-handler`, `qndl` (+ `qndl-audio`), `newsboat-utils` (`newsboat-count`/`newsboat-open`), `nvim-open`; wired via `scripts.nix`; also registered in `flake.nix` packages output
- **Newsboat:** Full setup — `programs.newsboat` HM config, vim keybinds, macros (`,v`,t`,a`,w`,d`,c`), Catppuccin colours, 22 feeds (news, Reddit, YouTube, arXiv); Noctalia bar widget shows unread count
- **foot:** `programs.foot` HM config — Catppuccin Mocha, JetBrains Mono 10pt, 5% transparency, beam cursor, 10 000-line scrollback
- **Packages added:** `newsboat` `yt-dlp` `links2` `task-spooler` `urlscan`
- **Guides:** Updated `neovim.md` (clipboard section, init.lua note); created `newsboat.md`

### 2026-03-23

- Added repo-wide comments to all Nix and Lua configuration files so each segment is easier to read
- Added `distrobox` plus `podman` support and created `guides/distrobox.md`
- Fixed Noctalia SystemMonitor to show values inline again by disabling compact mode
- Updated `.gitignore` to exclude LaTeX build artefacts and editor scratch files
- Verified `nixos-rebuild switch` succeeded after the changes
- Confirmed the 3-hour battery suspend rule is working as intended; it only suspends when the machine is actually discharging

### 2026-03-22

- Restructured repo layout (moved hosts, modules into final folder structure)
- Added Niri Wayland session and all session tools
- Added Noctalia Shell bar
- Added GNOME keyring + Chromium/Electron secret-service flags
- Ran `nix flake update`
- Added `STATUS.md` (this file) and linked from README
- Stripped README to layout + quick-start; moved all guides to `guides/`
- Created `guides/nixos-install.md`, `guides/flake.md`, `guides/niri.md`, `guides/uv-python.md`
- Added `uv` package; general venv at `~/.venv/general` auto-activates in bash
- Enriched Noctalia bar: added SystemMonitor (RAM %, net speed, disk %), Volume, SessionMenu
- Fixed Mako notifications: now auto-dismiss after 5 s (`default-timeout = 5000`)
- Screenshot keys swapped: `Print` → interactive region, `Super+S` → fullscreen
- Power management: swaylock (dark) after 5 min, monitors off after 10 min, suspend on battery after 3 h; AC never auto-suspends

### 2026-03-22 (continued)

- **LaTeX**: added `miktex` + `perl`; VSCode moved to `vscode.nix` with `programs.vscode` + LaTeX Workshop extension; auto-build on save, side-by-side PDF preview, SyncTeX; see `guides/latex.md`
- **Neovim**: full config migrated from external drive into `home/rms/nvim/`; symlinked by HM via `xdg.configFile`; lazy.nvim manages plugins; LSP servers (clangd, pyright) + formatters (black, clang-format) provided by Nix; see `guides/neovim.md`

### 2026-03-22 (idle fix)

- Fixed swayidle monitor power-off: swayidle's systemd unit has a restricted PATH (bash only); `niri msg`, `grep`, `systemctl` were not found → silently failed; now use full Nix store paths (`${pkgs.niri}/bin/niri`, `${pkgs.gnugrep}/bin/grep`, `/run/current-system/sw/bin/systemctl`)
- Monitors now turn off 30 s after the lock screen (was 10 min; was also broken)
- Added `before-sleep` event to lock screen before suspend (lid close etc.)
- Confirmed: GNOME session manager is NOT bleeding into Niri (`gsd-power` and `gnome-session` are not running in the Niri user session)
