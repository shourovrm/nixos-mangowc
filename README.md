# NixOS Configuration

A flake-based NixOS + Home Manager configuration for testing on a new machine.

**Key differences from v1:**
- **Login manager**: greetd + tuigreet (replaces GDM + GNOME)
- **Compositor**: Niri
- **No GNOME** — GTK theming via `gtk.nix` + dconf
- **Launcher**: Raffi on top of Fuzzel (`Super+D`)
- **NTFS/FAT/exFAT** support with udisks2 + udiskie automount
- **Clipboard history** via cliphist (`Super+V` to pick from history)
- **File manager**: Thunar with volume management plugins
- **Cloud sync**: rclone with `gdrive` remote convention for Google Drive
- **Password manager**: KeePassXC (can act as secret service provider)
- **Keyring**: gnome-keyring unlocked via greetd PAM

## First-time setup

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"

# Copy the target machine's hardware config
sudo cp /etc/nixos/hardware-configuration.nix \
        ~/nixos-config/hosts/rms-laptop/hardware-configuration.nix

# Apply
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop
```

## Sessions available in tuigreet

| Session | Binary | Config |
| --- | --- | --- |
| Niri | `niri` | `~/.config/niri/config.kdl` |

## Layout

```text
nixos-config/
├── flake.nix
├── hosts/rms-laptop/          # machine config (swap hardware-configuration.nix)
├── modules/nixos/
│   ├── greetd.nix             # login manager (greetd + tuigreet + PAM keyring)
│   ├── filesystems.nix        # NTFS/FAT/exFAT, udisks2, gvfs, dconf, Thunar
│   └── niri.nix               # Niri session (GNOME+GTK portals, no GNOME desktop)
└── home/rms/home-modules/
    ├── gtk.nix                # GTK theming (adw-gtk3-dark + dconf)
    ├── clipboard.nix          # cliphist + systemd watcher service
    └── filemanager.nix        # Thunar default, rclone, KeePassXC, udiskie
```

## Quick commands

| Task | Command |
| --- | --- |
| Rebuild & switch | `nixswitch` |
| Update flake + switch | `nixup` |
| Garbage collect | `sudo nix-collect-garbage -d` |

A flake-based NixOS + Home Manager configuration for the `rms-laptop` host, tracking **nixos-unstable**.

## Status

Current installed software and configuration state is tracked in **[STATUS.md](STATUS.md)**.
After every change (new package, module edit, flake update, etc.), open `STATUS.md` and:
1. Update the relevant table in the *Current configuration* section if the change is structural.
2. Append a dated bullet under **Changelog** describing what changed.

Keep entries concise — one line per change is enough.

## Guides

Detailed documentation lives in the [`guides/`](guides/) folder:

| Guide | Contents |
| --- | --- |
| [nixos-install.md](guides/nixos-install.md) | Fresh NixOS install + applying this config on a new machine |
| [flake.md](guides/flake.md) | Rebuilding, updating inputs, adding packages, multi-host setup |
| [niri.md](guides/niri.md) | Niri keybindings, bar widgets, power/idle behaviour, keyring |
| [uv-python.md](guides/uv-python.md) | Python environments, package management, inline deps |
| [neovim.md](guides/neovim.md) | Neovim plugins, LSP, clipboard, keybindings |
| [newsboat.md](guides/newsboat.md) | Newsboat RSS reader, link macros, download queue |
| [latex.md](guides/latex.md) | LaTeX with MiKTeX + VSCode LaTeX Workshop |
| [rclone.md](guides/rclone.md) | Google Drive setup and mounting with rclone |
| [distrobox.md](guides/distrobox.md) | Running other distros with Distrobox + Podman |

## Layout

```text
nixos-config/
├── flake.nix                              # Entry point — inputs & outputs
├── flake.lock                             # Auto-generated, commit this
├── STATUS.md                              # Current system state + changelog
├── guides/                                # Detailed how-to guides
│   ├── nixos-install.md
│   ├── flake.md
│   ├── niri.md
│   ├── uv-python.md
│   ├── neovim.md
│   ├── newsboat.md
│   ├── latex.md
│   ├── distrobox.md
│   └── flake.md
├── pkgs/                                  # Custom Nix packages (callPackage)
│   ├── fuzzel-handler/                    # fuzzel --dmenu URL/file handler
│   ├── link-handler/                      # Smart URL dispatcher
│   ├── qndl/                              # task-spooler download queue
│   ├── newsboat-utils/                    # Noctalia bar newsboat widgets
│   └── nvim-open/                         # foot+nvim wrapper (auto-close)
├── hosts/
│   └── rms-laptop/
│       ├── configuration.nix              # Machine identity, bootloader, user
│       └── hardware-configuration.nix     # Auto-generated — never edit
├── modules/
│   └── nixos/                             # Shared system-level modules
│       ├── locale.nix
│       ├── greetd.nix                     # greetd + tuigreet + PAM keyring
│       ├── audio.nix                      # PipeWire
│       ├── nix-settings.nix               # Flakes, GC, generation limit
│       ├── niri.nix                       # Niri Wayland session entry
│       ├── filesystems.nix                # Thunar, gvfs, udisks2, dconf
│       └── noctalia-system.nix            # Bluetooth, upower, power-profiles
└── home/
    └── rms/
        ├── home.nix                       # Entry point — imports only
        └── modules/                       # User-level modules
            ├── packages.nix               # All user packages
            ├── git.nix
            ├── bash.nix
            ├── neovim.nix
            ├── foot.nix                   # foot terminal (Catppuccin Mocha)
            ├── newsboat.nix               # Newsboat RSS reader
            ├── scripts.nix                # Wires pkgs/ custom scripts
            ├── niri.nix                   # KDL config, session tools, power
            ├── gtk.nix                    # GTK theme + env overrides
            ├── filemanager.nix            # Thunar default, rclone, KeePassXC
            └── noctalia.nix               # Noctalia bar (Home Manager module)
```

## First-time setup on a new machine

For a **fresh NixOS install** see [guides/nixos-install.md](guides/nixos-install.md).

If NixOS is already installed and you just want to apply this config:

```bash
# Enable flakes for the current shell session
export NIX_CONFIG="experimental-features = nix-command flakes"

# Clone the repo
git clone https://github.com/shourovrm/nixos-niri-config.git ~/nixos-config

# Copy your machine's hardware config into the repo
sudo cp /etc/nixos/hardware-configuration.nix \
    ~/nixos-config/hosts/rms-laptop/hardware-configuration.nix

# Apply
sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop
```

## Quick commands

| Task | Command / alias |
| --- | --- |
| Rebuild & switch | `nixswitch` |
| Update flake + switch | `nixup` |
| Test without switching | `sudo nixos-rebuild test --flake ~/nixos-config#rms-laptop` |
| Roll back | `sudo nixos-rebuild switch --rollback` |
| Garbage collect | `sudo nix-collect-garbage -d` |

> **Note:** Never change `stateVersion` in `configuration.nix` or `home.nix` after the
> initial install. It records the NixOS release the system was first set up on.

