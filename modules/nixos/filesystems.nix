# modules/nixos/filesystems.nix  (nixos-config-v2)
# Modern storage support: NTFS/FAT/exFAT read-write, automount via udisks2 +
# udiskie, virtual filesystems (gvfs) for file managers, and dconf for GTK
# theme database.
{ pkgs, ... }:

{
  # ── Kernel filesystem support ─────────────────────────────────────────────
  # ntfs3: read-write NTFS driver in the mainline kernel (since 5.15).
  # vfat + exfat are always built in on NixOS kernels.
  boot.supportedFilesystems = [ "ntfs" "exfat" "vfat" ];

  # ── udisks2 — hotplug / policy ────────────────────────────────────────────
  # Daemon that lets non-root users mount/unmount removable storage.
  # udiskie (HM module) connects to udisks2 for auto-mount and tray icon.
  services.udisks2 = {
    enable        = true;
    mountOnMedia  = true;   # mount at /media/<label> instead of /run/media
  };

  # ── GVfs — virtual filesystem for file managers ───────────────────────────
  # Required by Nautilus (SFTP, Trash, MTP, SMB, etc.) and Thunar plugins.
  services.gvfs.enable = true;

  # ── Thumbnail generation (for Thunar / Nautilus) ──────────────────────────
  services.tumbler.enable = true;

  # ── Thunar file manager (system-level integration) ─────────────────────────
  programs.thunar = {
    enable  = true;
    plugins = with pkgs.xfce; [
      thunar-volman          # auto-mount removable drives inside Thunar
      thunar-archive-plugin  # right-click to (un)compress archives
    ];
  };

  # ── dconf ─────────────────────────────────────────────────────────────────
  # GSettings backend used by GTK apps, Nautilus, and our HM gtk module.
  # Must be enabled at the system level for dconf CLI + HM dconf.settings.
  programs.dconf.enable = true;

  # ── Runtime support libs for Wayland/GTK apps ─────────────────────────────
  environment.systemPackages = with pkgs; [
    glib          # GSettings schema tool (gsettings) + basic POSIX utils
    xdg-utils     # xdg-open, xdg-mime, xdg-user-dirs
    libsecret     # libsecret dev+runtime (needed by some apps' gnome keyring integration)
    ntfs3g        # FUSE NTFS driver (fallback / user-space ntfs-3g tools)
    exfatprogs    # mkfs.exfat, fsck.exfat
    gvfs          # gvfs CLI (gvfs-ls, gvfs-mount) for debug
  ];
}
