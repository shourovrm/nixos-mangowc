# MangoWC (mango) Wayland Compositor

MangoWC (binary: `mango`) is a lightweight, dwl-based Wayland compositor with rich features: smooth animations, blur/shadow effects, flexible layouts (tile, scroller, monocle, grid, deck), tags (like workspaces), and XWayland support.

Nixpkgs package: `mangowc` (v0.10.5) | Upstream: [mangowm/mango](https://github.com/mangowm/mango) | Docs: [mangowm.github.io](https://mangowm.github.io/docs)

---

## Selecting the session

At the GDM login screen, click the **gear icon** (⚙) next to the Sign In button and choose **mango**. The session will start with Noctalia Shell, mako, swaybg, and swayidle running automatically.

---

## Keybindings

Keybindings closely mirror the Niri session so switching between them is easy.

### Application & session

| Key | Action |
| --- | --- |
| `Super + Return` | Open foot terminal |
| `Super + D` | Toggle Noctalia launcher |
| `Super + N` | Toggle notifications panel |
| `Super + B` | Toggle control center |
| `Super + Ctrl + L` | Lock screen (swaylock) |
| `Super + Shift + E` | Quit mango |
| `Super + Ctrl + R` | Hot-reload config (no restart) |

### Window management

| Key | Action |
| --- | --- |
| `Super + Q` | Close focused window |
| `Super + F` | Maximize window |
| `Super + Shift + F` | Fullscreen |
| `Super + O` | Toggle overview |
| `Super + Space` | Cycle keyboard layout (EN ↔ BD) |
| `Super + R` | Cycle layouts (tile → scroller → …) |

### Focus & movement

| Key | Action |
| --- | --- |
| `Super + H / ←` | Focus window left |
| `Super + L / →` | Focus window right |
| `Super + J / ↓` | Focus window down |
| `Super + K / ↑` | Focus window up |
| `Super + Shift + H/L/J/K` | Swap with neighbour |
| `Super + Shift + ← / →` | Swap with neighbour (arrow version) |

### Tags (workspaces)

MangoWC uses **tags** rather than workspaces.  Tags 1–5 are configured.

| Key | Action |
| --- | --- |
| `Super + 1–5` | Switch to tag |
| `Super + Shift + 1–5` | Move focused window to tag |

### Screenshots

| Key | Action |
| --- | --- |
| `Print` | Interactive region → saved to `~/Pictures/` |
| `Super + S` | Full-screen → saved to `~/Pictures/` |

### Media / hardware keys

| Key | Action |
| --- | --- |
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume −5% |
| `XF86AudioMute` | Toggle mute (sink) |
| `XF86AudioMicMute` | Toggle mute (source) |
| `XF86MonBrightnessUp` | Brightness +10% |
| `XF86MonBrightnessDown` | Brightness −10% |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioNext / Prev` | Next / previous track |

### Mouse

| Gesture | Action |
| --- | --- |
| `Super + drag (left button)` | Move floating window |
| `Super + drag (right button)` | Resize window |

---

## Config files

| File | Purpose |
| --- | --- |
| `~/.config/mango/config.conf` | Main compositor config (effects, layout, keybindings) |
| `~/.config/mango/autostart.sh` | Session startup script (bar, wallpaper, idle) |

Both are managed by Home Manager (`home/rms/home-modules/mangowc.nix`).  Edit that Nix file and run `nixswitch` to apply changes — no manual file editing needed.

To **hot-reload** keybindings only, press `Super + Ctrl + R` inside the mango session.

---

## Layouts

Switch between layouts with `Super + R`.  Available layouts:

| Layout | Description |
| --- | --- |
| `tile` | Classic master-stack (default) |
| `scroller` | Horizontal scroller (like Niri columns) |
| `monocle` | Single fullscreen window |
| `grid` | Equal-size grid |
| `deck` | Stacked windows |

---

## Idle / power management

Identical to the Niri session:

| Trigger | Action |
| --- | --- |
| 5 min idle | `swaylock` (dark `#1a1a2e`) |
| Before sleep (lid close) | `swaylock` |
| 3 h idle on battery | Suspend |
| On AC power | Never auto-suspends |

---

## Differences from the Niri session

| Feature | Niri | MangoWC |
| --- | --- | --- |
| Window model | Scrolling columns | Tags (tiling / floating) |
| Workspaces | Yes (workspaces 1–5) | Tags 1–5 (can view multiple simultaneously) |
| Config format | KDL | INI-like `.conf` |
| Fullscreen key | `Super + Shift + F` | `Super + Shift + F` |
| Maximize key | `Super + F` | `Super + F` |
| Column width | `Super + R` cycles presets | `Super + R` cycles layouts |

---

## Nix module structure

```text
modules/nixos/mangowc.nix          # system: session registration, XDG portals
home/rms/home-modules/mangowc.nix   # user:   config.conf + autostart.sh
```

The NixOS module sets `services.displayManager.sessionPackages = [ pkgs.mangowc ]` so GDM discovers the session. The HM module writes both config files and sets `home.packages = [ pkgs.mangowc ]`.
