# NixOS Fresh Installation Guide (v2)

Complete walkthrough for the `nixos-config-v2/` setup.
This variant uses **greetd + tuigreet**, **Niri**, and **no GNOME/GDM**.

---

## 0. What is different in v2?

Compared with the main config, v2 changes the desktop stack in a few important ways:

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
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart primary ext4 512MiB 100%
```

### Format

```bash
mkfs.fat -F 32 -n EFI ${DISK}p1
mkfs.ext4 -L nixos ${DISK}p2
```

### Mount

```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/EFI /mnt/boot/efi
```

### Optional: create a swapfile

Use this if you want swap without a dedicated swap partition.

```bash
fallocate -l 8G /mnt/swapfile
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile
```

Add the matching entry after `nixos-generate-config` in
`hosts/rms-laptop/hardware-configuration.nix`:

```nix
swapDevices = [
   {
      device = "/swapfile";
      size = 8192;
   }
];
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
parted $DISK unit MiB print free
parted $DISK -- mkpart primary ext4 STARTMiB ENDMiB
```

### Format and mount

```bash
ROOTPART=/dev/nvme0n1p5   # example, verify with lsblk

mkfs.ext4 -L nixos $ROOTPART
mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi   # existing Windows EFI partition
```

Do **not** reformat the Windows EFI partition.

### Optional: create a swapfile

After mounting `/mnt`, create swap in the new NixOS root:

```bash
fallocate -l 8G /mnt/swapfile
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile
```

Then add the same `swapDevices` entry shown above to
`hosts/rms-laptop/hardware-configuration.nix` after generating the hardware config.

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

## 7. Put `nixos-config-v2` on the target system

This folder is intentionally standalone, so you can copy it locally instead of cloning a repo.

If the folder already exists on the machine:

```bash
mkdir -p /mnt/home/rms
cp -a /home/rms/nixos-config-v2 /mnt/home/rms/
```

If you are bringing it from another location or external drive, copy it into `/mnt/home/rms/nixos-config-v2`.

---

## 8. Copy the hardware config into v2

```bash
cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/rms/nixos-config-v2/hosts/rms-laptop/hardware-configuration.nix
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
- GRUB config matches your system
- user is `rms`

For dual-boot, `boot.loader.grub.useOSProber = true;` should stay enabled.

---

## 10. Install v2

```bash
nixos-install --flake /mnt/home/rms/nixos-config-v2#rms-laptop --root /mnt
```

Set the root password when prompted.

Then set the user password:

```bash
nixos-enter --root /mnt
passwd rms
exit
```

---

## 11. Reboot

```bash
umount -R /mnt
reboot
```

Remove the USB drive.

---

## 12. First login in v2

You will land in **tuigreet**, not GDM.

Available sessions:

- `niri`

Choose the session, log in as `rms`, and then run:

```bash
cd ~/nixos-config-v2
nix run home-manager/master -- switch --flake .#rms
```

This ensures the user-level config is fully applied.

---

## 13. Post-install checks for v2

### Sessions

At tuigreet, verify the Niri session appears:

- `niri`

### Wallpaper

Noctalia manages the wallpaper in v2.
The seeded default is:

```text
~/.local/share/wallpapers/wallhaven_eo2p3w.jpg
```

### Clipboard history

`Super+V` opens the cliphist picker in Niri.

### Storage and file managers

You should have:

- `udisks2`
- `udiskie`
- `gvfs`
- `Thunar`
- `Nautilus`
- NTFS/exFAT support

### Keyring and auth

`gnome-keyring` is unlocked through greetd PAM, and Polkit prompts are handled by `polkit-gnome`.

---

## 14. Python environment

```bash
uv venv ~/.venv/general
```

It auto-activates in new shells.

---

## 15. Rebuild commands

```bash
cd ~/nixos-config-v2

sudo nixos-rebuild switch --flake .#rms-laptop
home-manager switch --flake .#rms
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

Noctalia should be the only wallpaper layer in v2.

### No suspend behavior on AC

This is intentional. v2 only auto-suspends after 3 h idle on battery.

### Displays should turn off after idle

v2 uses `wlopm`, so Niri can power displays off after 10 minutes idle without compositor-specific IPC.
