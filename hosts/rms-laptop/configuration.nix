# hosts/rms-laptop/configuration.nix
# Machine-specific settings only. Shared concerns live in modules/nixos/.
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/greetd.nix      # login manager (greetd + tuigreet)
    ../../modules/nixos/audio.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/niri.nix
    ../../modules/nixos/mangowc.nix
    ../../modules/nixos/noctalia-system.nix
    ../../modules/nixos/filesystems.nix  # NTFS/FAT, udisks2, gvfs, dconf, Thunar
  ];

  # ── Machine identity ──────────────────────────────────────────────────────
  networking.hostName              = "rms-laptop";
  networking.networkmanager.enable = true;

  # ── Bootloader ────────────────────────────────────────────────────────────
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot/efi";
  boot.loader.grub.efiSupport          = true;
  boot.loader.grub.device              = "nodev";
  boot.loader.grub.useOSProber         = true;

  # ── User account ──────────────────────────────────────────────────────────
  users.users.rms = {
    isNormalUser = true;
    description  = "rms";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  # ── System-wide packages ──────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [ git wget curl zathura ];

  nixpkgs.config.allowUnfree = true;

  # ── Container runtime (required by distrobox) ─────────────────────────────
  # Podman is a daemonless, rootless OCI runtime.
  # distrobox uses it to run full Linux distros as containers.
  virtualisation.podman = {
    enable         = true;
    dockerCompat   = true;  # provide a `docker` shim so docker-aware scripts work
  };

  # ── State version — do not change ─────────────────────────────────────────
  system.stateVersion = "25.11";
}
