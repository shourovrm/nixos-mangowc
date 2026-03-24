# home/rms/home-modules/filemanager.nix  (nixos-config-v2)
# File managers, cloud sync, and removable-media automount.
#   Nautilus  — GNOME file manager (native Wayland, thumbnails, GVFS)
#   Thunar    — XFCE file manager (registered via programs.thunar in NixOS module)
#   rclone    — Google Drive / cloud sync (CLI; configure with `rclone config`)
#   udiskie   — automount daemon for removable drives (tray icon + notifications)
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus          # GNOME file manager
    nautilus-python   # Python extensions support for Nautilus
    rclone            # Cloud storage CLI (Google Drive, S3, Dropbox, etc.)
    keepassxc         # Password manager with optional secret-service provider
  ];

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

  # ── Nautilus as default file manager for xdg-open ─────────────────────────
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory"           = [ "org.gnome.Nautilus.desktop" ];
      "application/x-directory"   = [ "org.gnome.Nautilus.desktop" ];
    };
  };

  # ── rclone: initial setup reminder ────────────────────────────────────────
  # Run `rclone config` to add Google Drive or other remotes.
  # Mount example: rclone mount gdrive: ~/GoogleDrive --daemon
  # Systemd user service for auto-mounting can be added here later.
}
