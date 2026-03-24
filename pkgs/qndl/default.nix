# pkgs/qndl/default.nix
# Builds the qndl (queue-and-download) script.
# Uses task-spooler (tsp) to queue downloads in the background, with
# desktop notifications on start and completion.
{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "qndl";
  src  = ./.;

  # Runtime deps: task-spooler (tsp), yt-dlp, curl, notify-send
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp qndl       $out/bin/qndl
    cp qndl-audio $out/bin/qndl-audio
    chmod +x $out/bin/qndl $out/bin/qndl-audio
  '';
}
