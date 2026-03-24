# Newsboat Guide

Newsboat is a fast, Vim-keyed TUI RSS/Atom reader.  In this setup it is managed
by Home Manager (`home/rms/home-modules/newsboat.nix`) and integrates with several
custom scripts for opening links.

---

## Quick commands

| Action | Key |
| --- | --- |
| Open / enter | `l` |
| Quit / back | `h` |
| Next article | `j` |
| Previous article | `k` |
| Next feed | `J` |
| Previous feed | `K` |
| Jump to top | `g` |
| Jump to bottom | `G` |
| Page down | `d` |
| Page up | `u` |
| Toggle read | `a` |
| Next unread | `n` |
| Previous unread | `N` |
| Show URLs | `U` (opens urlscan) |
| Reload all feeds | `r` |

---

## Link-opening macros

Macros begin with `,` (comma) followed by the letter.

| Macro | Action |
| --- | --- |
| `,v` | Play URL in **mpv** |
| `,t` | Queue **yt-dlp** full download via task-spooler |
| `,a` | Queue **yt-dlp audio-only** download |
| `,w` | Open in **links2** text browser (new foot window) |
| `,d` | Open **fuzzel-handler** menu (choose any handler) |
| `,c` | Copy URL to **Wayland clipboard** (`wl-copy`) |
| `,,` | Open with default `link-handler` |

---

## Default browser: link-handler

The `browser` setting is `link-handler`, which dispatches URLs based on type:

| URL type | Handler |
| --- | --- |
| YouTube / Twitch / video links | `mpv` (streamed) |
| Images (png/jpg/gif/webp) | `mpv` (image display) |
| PDF / CBZ | `zathura` (downloaded to `/tmp`) |
| Audio files | `qndl` (queued download) |
| Local files | `nvim` inside `foot` |
| Everything else | `firefox` |

---

## Task-spooler (tsp) — download queue

Downloads queued with `,t` or `,a` are managed by `task-spooler` (the `tsp`
command).

```bash
tsp          # show job queue
tsp -c       # clear finished jobs
tsp -k <id>  # kill job by id
tsp -T       # kill all running + queued
```

Downloads land in the current working directory of the shell that launched
newsboat.  To control the download destination, set `$TSP_SLOTS` and invoke
`newsboat` from the desired target directory.

---

## Adding / removing feeds

Edit `home/rms/home-modules/newsboat.nix` under the `home.file.".config/newsboat/urls"` block.

Format per line:
```
<url> "~Feed title" "tag1" "tag2"
```

The `~` prefix sorts the feed to the top within its tag group.

Rebuild to apply:
```bash
nixswitch
```

---

## Updating feeds manually

```bash
newsboat -x reload    # reload all feeds in background
newsboat -x print-unread   # print unread count to stdout
```

---

## Config location

| File | Path |
| --- | --- |
| Nix module | `home/rms/home-modules/newsboat.nix` |
| Config file (generated) | `~/.config/newsboat/config` |
| URLs file (generated) | `~/.config/newsboat/urls` |
| Cache database | `~/.local/share/newsboat/cache.db` |
| Queue file | `~/.local/share/newsboat/queue` |

---

## Noctalia bar widget

The `CustomButton` widget in the Noctalia bar (configured in `home/rms/home-modules/noctalia.nix`) shows the unread article count by polling `newsboat-count` every 5 minutes.  Click it to open Newsboat in a foot terminal.

| Widget behaviour | Detail |
| --- | --- |
| Display text | `  <N>` (blank when count is 0) |
| Click action | Opens `foot newsboat` |
| Refresh interval | Every 5 minutes |
