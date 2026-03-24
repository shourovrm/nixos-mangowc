# modules/nixos/nix-settings.nix
# Nix daemon settings: enable flakes, store optimisation, automatic GC.
{ ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];  # required for flake-based config
    auto-optimise-store   = true;  # hardlink identical store paths to save disk space
  };

  # Run `nix-collect-garbage --delete-old` weekly via a systemd timer.
  # This removes unreachable store paths (old rebuilds, unused dependencies).
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-old";
  };

  # Limit GRUB boot entries to 3 generations so the menu stays clean.
  # Older generations are cleaned up by the GC above.
  boot.loader.grub.configurationLimit = 3;
}
