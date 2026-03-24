# home/rms/home-modules/scripts.nix
# Wire all custom packages from pkgs/ into the user environment.
#
# Each package under pkgs/ is a standalone derivation with its own default.nix.
# Adding a new script means only:
#   1. Creating pkgs/<name>/default.nix + the script file
#   2. Adding a callPackage line below
# The rest of home.nix never needs to change for new scripts.
{ pkgs, ... }:
let
  # ── Custom scripts ────────────────────────────────────────────────────────
  # callPackage resolves the derivation relative to this repo root.
  fuzzelHandler  = pkgs.callPackage ../../../pkgs/fuzzel-handler  {};
  linkHandler    = pkgs.callPackage ../../../pkgs/link-handler    {};
  qndl           = pkgs.callPackage ../../../pkgs/qndl            {};
  newsboatUtils  = pkgs.callPackage ../../../pkgs/newsboat-utils  {};
  nvimOpen       = pkgs.callPackage ../../../pkgs/nvim-open       {};
  weatherUtils   = pkgs.callPackage ../../../pkgs/weather-utils   {};
in
{
  home.packages = [
    fuzzelHandler   # fuzzel-handler: Wayland URL/file handler menu (Mod+U from newsboat etc.)
    linkHandler     # link-handler:   smart dispatcher (video→mpv, pdf→zathura, text→nvim)
    qndl            # qndl:           queue downloads with task-spooler
    newsboatUtils   # newsboat-count + newsboat-open: bar widget helpers
    nvimOpen        # nvim-open:      open files in Neovim+foot; foot closes on exit
    weatherUtils    # weather-bar + weather-open: bar weather widget scripts
  ];
}
