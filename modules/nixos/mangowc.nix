# modules/nixos/mangowc.nix  (nixos-config-v2)
# Registers the mango Wayland session so it appears in tuigreet's session list.
# MangoWC is the nixpkgs package (v0.10.5); binary: `mango`, session: "mango".
{ pkgs, ... }:

{
  # Register the session — session desktop files land in:
  # /run/current-system/sw/share/wayland-sessions/mango.desktop
  # tuigreet uses --sessions pointing there (see greetd.nix).
  services.displayManager.sessionPackages = [ pkgs.mangowc ];

  # PolKit — already enabled by niri.nix but harmless to state here too.
  security.polkit.enable = true;

  # XDG portals for the mango session are configured in niri.nix (v2)
  # alongside the wlr and gtk backends.  Nothing extra needed here.
}
