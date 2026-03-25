# Rclone Guide

`rclone` is installed through `home/rms/home-modules/filemanager.nix`.
This setup expects a Google Drive remote named `gdrive` and keeps a stable
mountpoint at `~/GoogleDrive`.

---

## What this repo provides

- `rclone` is installed in the user environment
- `~/GoogleDrive` is created automatically by Home Manager
- the Raffi launcher includes a `Google Drive` entry that opens `~/GoogleDrive`

---

## First-time Google Drive setup

Run the interactive setup once:

```bash
rclone config
```

Recommended choices:

1. `n` to create a new remote
2. remote name: `gdrive`
3. storage type: `drive`
4. follow the browser-based OAuth flow
5. accept the default scope unless you need something narrower

After setup, verify the remote works:

```bash
rclone lsd gdrive:
```

If that lists folders, the remote is ready.

---

## Mount Google Drive

Mount it into the repo's standard location:

```bash
rclone mount gdrive: ~/GoogleDrive --daemon
```

Open it with Thunar:

```bash
thunar ~/GoogleDrive
```

Or use the seeded Raffi launcher entry on `Super+D`.

---

## Unmount

If the mount is active and you want to stop it:

```bash
pkill -f "rclone mount gdrive: ~/GoogleDrive"
```

If that does not clear the mount, unmount the directory directly:

```bash
umount ~/GoogleDrive
```

---

## Useful commands

```bash
rclone ls gdrive:                     # list files
rclone copy ~/Downloads gdrive:Backup/Downloads
rclone sync ~/Documents gdrive:Backup/Documents
rclone mkdir gdrive:Notes
```

---

## Notes

- The repo does not auto-mount Google Drive at login yet.
- If you choose a different remote name, update `~/.config/raffi/raffi.yaml`.
- `rclone config file` shows where the remote credentials are stored.