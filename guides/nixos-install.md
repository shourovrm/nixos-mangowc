# NixOS Fresh Installation Guide

Complete walkthrough for setting up this repository on a fresh machine.
This setup uses **greetd + tuigreet**, **Niri**, and **no GNOME/GDM**.

---

## 0. Desktop stack

This repository uses the following desktop stack:

- login manager: `greetd` + `tuigreet`
- session: `niri`
- wallpaper: Noctalia's built-in wallpaper engine
- file/device support: `udisks2`, `gvfs`, `udiskie`, NTFS/exFAT tools
- clipboard history: `cliphist`
- GTK apps: themed without GNOME desktop

Use this guide when you want the leaner non-GNOME setup.

---

## 1. Boot the minimal ISO

Download the **minimal** installer from <https://nixos.org/download> and boot from it.

If you need to flash it from another Linux system:

```bash
dd if=nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `/dev/sdX` with your USB drive.

---

## 2. Connect to the network

### Wired

Usually comes up automatically:

```bash
ip a
ping -c2 1.1.1.1
```

### Wi-Fi

```bash
iwctl

[iwd] device list
[iwd] station wlan0 scan
[iwd] station wlan0 get-networks
[iwd] station wlan0 connect "SSID"
[iwd] quit

ping -c2 1.1.1.1
```

---

## 3. Identify your target disk

```bash
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE
```

Typical names:

| Hardware | Disk |
| --- | --- |
| NVMe SSD | `/dev/nvme0n1` |
| SATA SSD / HDD | `/dev/sda` |

Choose **one** of the two partitioning paths below.

---

## 4A. Fresh disk install

Use this if the whole target disk is for NixOS.

```bash
DISK=/dev/nvme0n1
```

### Partition

```bash
cfdisk $DISK
```

Inside `cfdisk`:

- choose `gpt` if asked
- create a `512 MiB` `EFI System` partition
- create a `Linux swap` partition only if you want swap
- create a `Linux filesystem` partition with the remaining space for `/`

After writing the partition table, identify the resulting partition names:

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,PARTTYPENAME,MOUNTPOINT $DISK
```

### Format

```bash
EFIPART=/dev/nvme0n1p1
ROOTPART=/dev/nvme0n1p2
SWAPPART=/dev/nvme0n1p3   # optional; omit if you did not create one

mkfs.fat -F 32 -n EFI $EFIPART
mkfs.ext4 -L nixos $ROOTPART
```

If you created a swap partition:

```bash
mkswap -L swap $SWAPPART
swapon $SWAPPART
```

### Mount

```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/EFI /mnt/boot/efi
```

---

## 4B. Dual-boot alongside Windows

Use this if Windows already exists and you want to keep it.

### Shrink Windows first

From Windows:

1. open `diskmgmt.msc`
2. right-click `C:`
3. choose `Shrink Volume`
4. create unallocated space for NixOS
5. shut Windows down cleanly

### Create the Linux partition from the NixOS ISO

```bash
DISK=/dev/nvme0n1
lsblk -o NAME,SIZE,TYPE,FSTYPE,PARTTYPENAME,MOUNTPOINT
swapon --show
cfdisk $DISK
```

Before writing changes, check whether you already have a Linux swap partition
you want to reuse. A Windows pagefile is not Linux swap.

Inside `cfdisk`, use only the free space created from Windows:

- create one `Linux filesystem` partition for NixOS root
- create one `Linux swap` partition only if you do not already have Linux swap to reuse
- leave the existing Windows EFI partition intact

### Format and mount

```bash
EFIPART=/dev/nvme0n1p1    # existing Windows EFI partition
ROOTPART=/dev/nvme0n1p5   # example, verify with lsblk
SWAPPART=/dev/nvme0n1p6   # optional; only if created or reused

mkfs.ext4 -L nixos $ROOTPART
mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot/efi
mount $EFIPART /mnt/boot/efi
```

Do **not** reformat the Windows EFI partition.

If you have a Linux swap partition to use:

```bash
swapon $SWAPPART
```

---

## 5. Generate hardware config

```bash
nixos-generate-config --root /mnt
```

This creates `/mnt/etc/nixos/hardware-configuration.nix`.

---

## 6. Enable flakes and get git

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nix-shell -p git
```

---

## 7. Clone the repo onto the target system

Clone the repo directly into the target filesystem:

```bash
mkdir -p /mnt/home/rms
git clone https://github.com/shourovrm/nixos-niri-config /mnt/home/rms/nixos-config
```

---

## 8. Copy the hardware config into the repo

```bash
cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/rms/nixos-config/hosts/rms-laptop/hardware-configuration.nix
```

If this is a new host, duplicate the host directory and add the new host to `flake.nix`.

---

## 9. Review the host config

Check:

- `hosts/rms-laptop/configuration.nix`
- `modules/nixos/greetd.nix`
- `modules/nixos/filesystems.nix`

Make sure:

- hostname is correct
- EFI mount path is `/boot/efi`
- GRUB config matches your system and keeps kernels/initrd on the root filesystem
- user is `rms`

These bootloader settings should be present:

```nix
boot.loader.efi.efiSysMountPoint = "/boot/efi";
boot.loader.grub.efiSupport = true;
boot.loader.grub.device = "nodev";
```

For dual-boot, `boot.loader.grub.useOSProber = true;` should stay enabled.

If you are using a swap partition, check `hosts/rms-laptop/hardware-configuration.nix`
after copying it into the repo and confirm `swapDevices` points to the correct
swap partition. `nixos-generate-config` usually detects any swap partition that
is active via `swapon`.

---

## 10. Install

```bash
nixos-install --flake /mnt/home/rms/nixos-config#rms-laptop --root /mnt
```

Set the root password when prompted.

---

## 11. Reboot

```bash
umount -R /mnt
reboot
```

Remove the USB drive.

---

## 12. Before first graphical login

Before logging into Niri for the first time, switch to a TTY and finish the
machine-local setup there.

Log in on a text console as `root`, then run:

```bash
passwd rms
chown -R rms:users /home/rms/nixos-config
chmod -R u+rw /home/rms/nixos-config
su - rms
export NIX_CONFIG="experimental-features = nix-command flakes"
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#rms-laptop
```

Only continue to the graphical login after that rebuild succeeds.

---

## 13. First login

You will land in **tuigreet**, not GDM.

Available sessions:

- `niri`

At tuigreet, use `niri` as the session command and log in as `rms`.

For later config changes, use:

```bash
nixswitch
```

---

## 14. Post-install checks

### Sessions

At tuigreet, verify the Niri session appears:

- `niri`

### Wallpaper

Noctalia manages the wallpaper in this setup.
The seeded default is:

```text
~/.local/share/wallpapers/wallhaven_eo2p3w.jpg
```

### Clipboard history

`Super+V` opens the cliphist picker in Niri.

### Launcher

`Super+D` opens Raffi through Fuzzel.

`Super+Shift+D` still opens Noctalia's own launcher.

### Storage and file managers

You should have:

- `udisks2`
- `udiskie`
- `gvfs`
- `Thunar`
- `rclone`
- NTFS/exFAT support

### Google Drive

`rclone` is installed already. Use a remote named `gdrive` so the included
launcher entry and docs line up:

```bash
rclone config
mkdir -p ~/GoogleDrive
rclone lsd gdrive:
rclone mount gdrive: ~/GoogleDrive --daemon
```

If you pick a different remote name, update `~/.config/raffi/raffi.yaml`.

### Keyring and auth

`gnome-keyring` is unlocked through greetd PAM, and Polkit prompts are handled by `polkit-gnome`.

---

## 15. Python environment

```bash
uv venv ~/.venv/general
```

It auto-activates in new shells.

---

## 16. Rebuild commands

```bash
cd ~/nixos-config

sudo nixos-rebuild switch --flake .#rms-laptop
nix flake check --no-build
```

---

## Troubleshooting

### `niri` does not appear in tuigreet

Rebuild the system and confirm the session file exists:

```bash
ls /run/current-system/sw/share/wayland-sessions/
```

Expected:

```text
niri.desktop
```

### Wallpaper is wrong after login

Check:

- `~/.config/noctalia/settings.json`
- `~/.cache/noctalia/wallpapers.json`

Noctalia should be the only wallpaper layer.

### No suspend behavior on AC

This is intentional. The system only auto-suspends after 3 h idle on battery.

### Displays should turn off after idle

This setup uses `wlopm`, so Niri can power displays off after 10 minutes idle without compositor-specific IPC.
