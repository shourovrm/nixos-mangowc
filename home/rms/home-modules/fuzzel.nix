# home/rms/home-modules/fuzzel.nix
# Fuzzel application launcher — Catppuccin Mocha palette.
# Used standalone (clipboard picker, dmenu calls) and as the UI backend for
# raffi when native mode is not desired.
{ pkgs, ... }:

{
  home.packages = [ pkgs.fuzzel ];

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    dpi-aware=yes
    font=JetBrains Mono:size=10
    terminal=foot
    width=40
    layer=overlay
    exit-on-keyboard-focus-loss=no
    inner-pad=12
    fields=filename,name,comment

    [colors]
    background=1e1e2eff
    text=cdd6f4ff
    match=89b4faff
    selection=45475aff
    selection-text=cdd6f4ff
    selection-match=89dcebff
    border=7fc8ffff
  '';
}
