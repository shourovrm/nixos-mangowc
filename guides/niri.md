# Niri Session Guide

Quick reference for the Niri Wayland compositor session.

Log in through **greetd + tuigreet** and choose the **niri** session.

---

## Keyboard layout

| Action | Keys |
| --- | --- |
| Switch English ↔ Bangla (Probhat) | `Super + Space` |

---

## Applications

| Action | Keys |
| --- | --- |
| Open terminal (foot) | `Super + T` |
| Open Raffi launcher (fuzzel UI) | `Super + D` |
| Toggle Noctalia launcher | `Super + Shift + D` |
| Lock screen | `Super + Ctrl + L` |

---

## Windows & columns

| Action | Keys |
| --- | --- |
| Close window | `Super + Q` |
| Focus left / right | `Super + H/L` or `Super + ←/→` |
| Focus up / down in column | `Super + J/K` or `Super + ↑/↓` |
| Move column left / right | `Super + Shift + H/L` |
| Maximise column | `Super + F` |
| Fullscreen window | `Super + Shift + F` |
| Centre column | `Super + C` |
| Cycle column widths (⅓ ½ ⅔) | `Super + R` |
| Shrink / grow column | `Super + -` / `Super + =` |

---

## Workspaces

| Action | Keys |
| --- | --- |
| Switch to workspace 1–5 | `Super + 1–5` |
| Move window to workspace 1–5 | `Super + Shift + 1–5` |

---

## Screenshots

| Action | Keys |
| --- | --- |
| Interactive region screenshot | `Print` |
| Full-screen screenshot | `Super + S` |
| Active window screenshot | `Alt + Print` |

Screenshots are saved to `~/Pictures/Screenshots/` by niri's built-in screenshot action.

---

## Noctalia bar

| Action | Keys |
| --- | --- |
| Switch keyboard layout | `Super + Space` |
| Toggle notification panel | `Super + N` |
| Toggle control centre | `Super + B` |
| Toggle overview | `Super + O` |

### Bar widgets (right side)

- **SessionMenu** — shutdown, reboot, logout, screen off
- **SystemMonitor** — CPU, RAM, network speed, disk usage
- **Volume** — click to open audio panel
- **Battery** — percentage + charging indicator
- **Clock**

### Bar widgets (left side)

- **ControlCenter** (distro logo) — opens control centre
- **Network** — connection status
- **Bluetooth** — toggle and device list

---

## Session

| Action | Keys |
| --- | --- |
| Quit niri | `Super + Shift + E` |

---

## Launcher

`Super + D` opens Raffi using Fuzzel as the UI backend.
The config lives at `~/.config/raffi/raffi.yaml`, and Fuzzel styling lives at `~/.config/fuzzel/fuzzel.ini`.

The seeded entries include Firefox, foot, Thunar, VS Code, Newsboat, weather, lock screen, and a `Google Drive` shortcut pointing to `~/GoogleDrive`.

---

## Power / idle behaviour

| Trigger | Action |
| --- | --- |
| 5 min idle | Screen locks (dark swaylock) |
| 10 min idle | Monitors turn off |
| 3 h idle on battery | Device suspends |
| On AC power | Never suspends automatically |

---

## Secret service (keyring)

`gnome-keyring-daemon` runs as a small background daemon (~3 MB RAM) — not gnome-shell.
It is enabled system-wide and auto-unlocked at greetd login via PAM (`modules/nixos/greetd.nix`).

Most apps using `libsecret` work automatically. Chromium-based and Electron apps need flags:

| App | How it's handled |
| --- | --- |
| VS Code | `--password-store=gnome-libsecret` in its override in `packages.nix` |
| Chromium / Chrome | `~/.config/chromium-flags.conf` written by Home Manager in `niri.nix` |
| Other Electron apps | Add a `.config/<appname>-flags.conf` with the two lines below |

```text
--ozone-platform=wayland
--password-store=gnome-libsecret
```
