# Distrobox Guide

Distrobox lets you run any Linux distribution (Ubuntu, Fedora, Arch, etc.) as a
rootless container that shares your home directory, user, and display server.
It is installed from Nix (`home.packages`) and uses Podman as its container
backend (`virtualisation.podman` in `configuration.nix`).

---

## First-time Setup

After running `nixos-rebuild switch`, ensure the Podman socket is active:

```bash
systemctl --user start podman.socket
```

To start it automatically on login:

```bash
systemctl --user enable podman.socket
```

---

## Creating a Container

```bash
# Syntax: distrobox create --name <name> --image <image>
distrobox create --name ubuntu24 --image ubuntu:24.04
distrobox create --name fedora41  --image fedora:41
distrobox create --name arch      --image archlinux:latest
```

Common images (all available on Docker Hub / quay.io):

| Distribution     | Image                       |
|------------------|-----------------------------|
| Ubuntu 24.04     | `ubuntu:24.04`              |
| Fedora 41        | `fedora:41`                 |
| Arch Linux       | `archlinux:latest`          |
| Debian 12        | `debian:12`                 |
| openSUSE Tumbleweed | `opensuse/tumbleweed`    |

---

## Entering a Container

```bash
distrobox enter ubuntu24
```

You are now inside the container with your home directory mounted and your user
name preserved. Installed packages stay inside the container; your files at
`~` are shared with the host.

---

## Installing Packages Inside a Container

```bash
# Inside ubuntu24:
sudo apt update && sudo apt install build-essential python3-dev

# Inside arch:
sudo pacman -Syu        # full upgrade
sudo pacman -S gimp
```

---

## Exporting Commands to the Host

Once a binary is installed inside a container you can make it callable on the
host without entering the container every time:

```bash
# Export a CLI command
distrobox-export --app gimp          # exports GUI .desktop entry to host menus
distrobox-export --bin /usr/bin/gcc  # exports a CLI binary to ~/.local/bin/

# After export, use it on the host directly:
gcc --version
```

Remove an export:

```bash
distrobox-export --app gimp --delete
distrobox-export --bin /usr/bin/gcc --delete
```

---

## Running GUI Apps

Distrobox inherits the host's `DISPLAY`, `WAYLAND_DISPLAY`, and `XDG_RUNTIME_DIR`
automatically, so GUI apps launched inside the container appear on the host
display with no extra configuration.

```bash
distrobox enter ubuntu24 -- firefox   # open Firefox from inside the container
```

---

## Listing and Removing Containers

```bash
distrobox list            # see all containers and their status
distrobox stop ubuntu24   # stop a running container
distrobox rm ubuntu24     # delete a container (data inside is lost; ~/  is safe)
```

---

## Tips

- **Home directory**: your real `~` is bind-mounted into the container, so any
  files you create there persist after the container is deleted.
- **Dotfiles**: your `.bashrc`, `.config/`, and `.local/` are shared. Shell
  aliases and tool configs work inside the container out of the box.
- **NixOS packages vs container packages**: install *system-level build deps*
  (heavy SDKs, distro-specific libs) inside the container; keep your day-to-day
  tools in Nix.
- **Multiple containers**: there is no limit. Use one per project or per distro.
