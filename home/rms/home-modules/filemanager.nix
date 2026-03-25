# home/rms/home-modules/filemanager.nix  (nixos-config-v2)
# File management, cloud sync, and removable-media automount.
#   Thunar    — XFCE file manager (registered via programs.thunar in NixOS module)
#   rclone    — Google Drive / cloud sync (CLI; create a `gdrive` remote)
#   udiskie   — automount daemon for removable drives (tray icon + notifications)
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    rclone            # Cloud storage CLI (Google Drive, S3, Dropbox, etc.)
    keepassxc         # Password manager with optional secret-service provider
  ];

  # ── Google Drive mountpoint ───────────────────────────────────────────────
  # Keep a stable mountpoint ready for the `gdrive:` rclone remote used in the
  # launcher config and install guide.
  home.activation.createGoogleDriveMountpoint = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/GoogleDrive"
  '';

  # ── udiskie: automount removable storage ──────────────────────────────────
  # Connects to udisks2 (enabled in filesystems.nix) and auto-mounts USB
  # drives, SD cards, etc.  Also shows a system-tray icon and sends
  # notifications via libnotify (mako handles them in the session).
  services.udiskie = {
    enable    = true;
    automount = true;
    notify    = true;
    tray      = "auto";  # show tray icon if a system tray is available
  };

  # ── Thunar as default file manager for xdg-open ───────────────────────────
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory"           = [ "thunar.desktop" ];
      "application/x-directory"   = [ "thunar.desktop" ];
    };
  };

  # ── rclone: initial setup reminder ────────────────────────────────────────
  # Create a remote named `gdrive` so the install guide and Raffi launcher can
  # refer to a single stable Google Drive mountpoint at ~/GoogleDrive.
}
