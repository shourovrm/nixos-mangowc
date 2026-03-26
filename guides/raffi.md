# Raffi + Fuzzel — Launcher Guide

This setup uses three complementary launchers:

| Launcher | Keybind | Purpose |
|---|---|---|
| **Fuzzel** | `Super+D` | Full application launcher from installed `.desktop` files |
| **Raffi** (native UI) | `Super+Ctrl+D` | Curated tools launcher, calculator, currency, file browser |
| **Noctalia launcher** | `Super+Shift+D` | Noctalia built-in app switcher |
| **Clipboard picker** | `Super+V` | Fuzzel dmenu — paste from clipboard history |

---

## Why Fuzzel Finds More Apps

Fuzzel and Raffi do different jobs:

- `fuzzel` scans installed `.desktop` files, so it automatically finds LibreOffice, btop++, Foot, and other apps.
- `raffi` does **not** index desktop entries. It only shows the static entries declared in `raffi.yaml`, plus built-in addons like calculator, currency, and file browser.

That is why typing `writer` works in Fuzzel but not in Raffi.

---

## Fuzzel App Launcher (`Super+D`)

Press `Super+D` to open the normal app launcher. This is the right launcher when you want to start any installed desktop application.

- It searches installed `.desktop` files
- It finds apps added by NixOS, Home Manager, and user-local desktop entries
- It is the launcher to use for programs like LibreOffice Writer, Draw, Zathura, Blueman, and similar apps that are not explicitly listed in Raffi

---

## Raffi (`Super+Ctrl+D`)

Raffi opens as a centered floating window. Type to fuzzy-search any entry.

### Configured launchers

| Name | What it opens |
|---|---|
| `browser` | Firefox |
| `terminal` | Foot terminal |
| `files` | Thunar file manager |
| `downloads` | Thunar → ~/Downloads |
| `editor` | VS Code |
| `newsboat` | Newsboat (inside Foot) |
| `weather` | Weather forecast (inside Foot) |
| `google_drive` | Thunar → ~/GoogleDrive |
| `lock` | Lock screen (swaylock) |

Raffi is best used for:

- fixed shortcuts you want to keep near the top
- the built-in calculator
- currency conversion
- file browsing from `/` or `~`

### Navigation

| Key | Action |
|---|---|
| Type | Fuzzy-filter the list |
| `↑` / `↓` or `Alt+P` / `Alt+N` | Move through results / scroll history |
| `Enter` | Launch selected entry |
| `Escape` | Close without launching |

### Built-in calculator

Type any math expression directly in the search box — no prefix needed.

```
2 + 2          → 4
sin(pi/2)      → 1
(12 * 8) / 3   → 32
sqrt(144)      → 12
```

Press `Enter` to copy the result to the clipboard.

### Built-in currency converter

Type a `$` prefix followed by an amount and currency pair:

```
$100 USD to EUR
$50 GBP to BDT
$200 EUR to JPY
```

Raffi fetches the live rate via the internet and shows the converted amount.
Press `Enter` to copy the result.

### Search history

Raffi remembers your recent search queries (up to 10 by default).

- `Alt+P` — scroll back through previous queries
- `Alt+N` — scroll forward through query history

---

## Fuzzel Clipboard Picker (`Super+V`)

`Super+V` opens a fuzzel dmenu listing your clipboard history (managed by `cliphist`).

1. Press `Super+V`
2. Type to filter entries
3. Press `Enter` — the selected item is copied to the clipboard
4. Paste with `Ctrl+V` / middle-click / `wl-paste` as normal

Clipboard history accumulates automatically while `cliphist` runs in the background. All text, URLs, and code snippets you copy are stored.

---

## Fuzzel URL / File Handler (`fuzzel-handler`)

`fuzzel-handler` is used internally by scripts (e.g., newsboat's browser macro) as a dmenu to decide what to do with a link:

- **Open** — `xdg-open` default handler
- **MPV** — stream video/audio directly
- **yt-dlp** — queue download (via tsp)
- **Copy URL** — copy the link to clipboard

You normally don't invoke this directly; it is triggered by pressing `,o` in newsboat or by any script that calls `fuzzel-handler`.

---

## Editing the launcher list

Launchers are declared in `home/rms/home-modules/raffi.nix` under the `launchers:` block (v1 schema).

Each entry follows this shape:

```yaml
launchers:
  myapp:
    binary: app-binary-name
    args: ["--flag", "value"]      # optional
    description: "Human label"
    icon: icon-name                # freedesktop icon name or absolute path
    ifexist: app-binary-name       # optional — hide entry if binary not in PATH
```

After editing, run:

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop
```

The new `~/.config/raffi/raffi.yaml` is deployed automatically.

---

## Raffi config location

| File | Purpose |
|---|---|
| `~/.config/raffi/raffi.yaml` | Deployed by Home Manager (read-only symlink) |
| `home/rms/home-modules/raffi.nix` | Source of truth — edit this |
| `pkgs/raffi/default.nix` | Custom 0.20.0 derivation (built from source) |
