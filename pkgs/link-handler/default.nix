# pkgs/link-handler/default.nix
# Builds the link-handler script: a Wayland-native smart URL/file dispatcher.
# Replaces the classic dmenu-era linkhandler (which used X11 tools).
# Images and video go to mpv, PDFs to Zathura, text files to Neovim in foot,
# everything else to Firefox.
{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "link-handler";
  src  = ./.;

  # Runtime deps (on PATH at runtime, not build-time):
  # mpv, zathura, foot, curl, firefox, wl-clipboard, notify-send, qndl
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp linkhandler $out/bin/link-handler
    chmod +x $out/bin/link-handler
  '';
}
