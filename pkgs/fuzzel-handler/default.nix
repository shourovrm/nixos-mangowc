# pkgs/fuzzel-handler/default.nix
# Builds the fuzzel-handler script: a Wayland-native URL/file handler menu
# powered by fuzzel instead of dmenu.  All X11 tools (xclip, nsxiv, xwallpaper)
# are replaced with Wayland equivalents (wl-copy, mpv, native portals).
{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "fuzzel-handler";
  src  = ./.;

  # Runtime deps are not part of the build closure but are documented here
  # so readers know what must be on PATH at runtime.
  # Runtime: fuzzel, wl-clipboard, mpv, zathura, foot, curl, yt-dlp, qndl
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp fuzzelhandler $out/bin/fuzzel-handler
    chmod +x $out/bin/fuzzel-handler
  '';
}
