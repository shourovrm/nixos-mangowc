# modules/nixos/niri.nix  (nixos-config-v2)
# Registers niri as the Wayland session and configures portals for a
# greetd-managed, non-GNOME desktop.
{ pkgs, ... }:

{
  # Enables niri and registers it as a Wayland session
  programs.niri.enable = true;

  # Polkit — already enabled by greetd.nix but safe to declare twice
  security.polkit.enable = true;

  # XDG portals — niri's screencast support integrates with the GNOME portal,
  # while gtk provides a lightweight file chooser for Thunar-centric setups.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome  # screen sharing / screencast for niri
      pkgs.xdg-desktop-portal-gtk    # lightweight file chooser, settings
    ];
    config = {
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      # Fallback for unknown sessions
      common = { default = [ "gtk" ]; };
    };
  };
}
