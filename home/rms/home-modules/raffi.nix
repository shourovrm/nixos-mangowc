# home/rms/home-modules/raffi.nix
# Raffi 0.20.0 application launcher — built from source.
# Uses the v1 YAML schema (version: 1 + launchers: wrapper, with optional
# general: block). Native iced UI is set via general.ui_type in the config.
# Calculator (type a math expr) and currency (type $) are built-in features.
{ config, pkgs, ... }:
let
  raffi = pkgs.callPackage ../../../pkgs/raffi {};
in
{
  home.packages = [ raffi ];

  # ── raffi.yaml — v1 schema (raffi ≥ 0.20.0) ────────────────────────────────
  # Top-level keys: version, general (optional), launchers, addons (optional).
  # Launchers are nested under the `launchers:` key.
  xdg.configFile."raffi/raffi.yaml".text = ''
    version: 1

    general:
      ui_type: native
      window_width: 640
      window_height: 480

    launchers:
      browser:
        binary: firefox
        description: "Firefox"
        icon: firefox

      terminal:
        binary: foot
        description: "Foot terminal"
        icon: utilities-terminal

      files:
        binary: thunar
        description: "Thunar file manager"
        icon: org.xfce.thunar

      downloads:
        binary: thunar
        args: ["${config.home.homeDirectory}/Downloads"]
        description: "Downloads"
        icon: folder-download

      editor:
        binary: code
        description: "VS Code"
        icon: vscode

      newsboat:
        binary: foot
        args: ["-e", "newsboat"]
        description: "Newsboat"
        icon: applications-internet

      weather:
        binary: weather-open
        description: "Weather forecast"
        icon: weather-overcast

      google_drive:
        binary: thunar
        args: ["${config.home.homeDirectory}/GoogleDrive"]
        description: "Google Drive"
        icon: folder-remote

      lock:
        binary: swaylock
        args: ["-f"]
        description: "Lock screen"
        icon: system-lock-screen
  '';
}
