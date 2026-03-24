# modules/nixos/niri.nix  (nixos-config-v2)
# Registers niri as an available Wayland session.
# GNOME is NOT present in v2 — portals use wlr + gtk backends.
{ pkgs, ... }:

{
  # Enables niri and registers it as a Wayland session
  programs.niri.enable = true;

  # Polkit — already enabled by greetd.nix but safe to declare twice
  security.polkit.enable = true;

  # XDG portals — wlr handles screen capture in all wlroots sessions;
  # gtk provides file pickers and other GTK-based portals.
  xdg.portal = {
    enable       = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr   # screen sharing / capture (wlroots)
      pkgs.xdg-desktop-portal-gtk   # file picker, settings, screenshots
    ];
    config = {
      niri  = { default = [ "wlr" "gtk" ]; };
      mango = { default = [ "wlr" "gtk" ]; };
      # Fallback for unknown sessions
      common = { default = [ "gtk" ]; };
    };
  };
}
