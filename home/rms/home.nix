# home/rms/home.nix
# Entry point only — identity, stateVersion, and imports.
{ config, pkgs, inputs, opencode, ... }:

{
  imports = [
    ./home-modules/packages.nix
    ./home-modules/scripts.nix   # custom scripts from pkgs/ (fuzzel-handler, link-handler, qndl, …)
    ./home-modules/vscode.nix
    ./home-modules/git.nix
    ./home-modules/bash.nix
    ./home-modules/foot.nix      # foot terminal — Catppuccin Mocha theme, JetBrains Mono
    ./home-modules/neovim.nix
    ./home-modules/newsboat.nix  # Newsboat RSS reader
    ./home-modules/niri.nix
    ./home-modules/noctalia.nix
    ./home-modules/gtk.nix           # v2: GTK theming + dconf (no GNOME session)
    ./home-modules/clipboard.nix     # v2: cliphist persistent clipboard history
    ./home-modules/filemanager.nix   # v2: Nautilus, Thunar, rclone, udiskie, KeePassXC
  ];

  home.username      = "rms";
  home.homeDirectory = "/home/rms";
  home.stateVersion  = "25.11";

  programs.home-manager.enable = true;
}
