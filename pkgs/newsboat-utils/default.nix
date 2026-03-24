# pkgs/newsboat-utils/default.nix
# Two small scripts consumed by the Noctalia bar:
#   newsboat-count  — outputs unread article count (for the CustomButton widget)
#   newsboat-open   — opens Newsboat in a foot terminal (bar click action)
{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "newsboat-utils";
  src  = ./.;

  # Runtime deps: newsboat, foot
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp newsboat-count $out/bin/newsboat-count
    cp newsboat-open  $out/bin/newsboat-open
    chmod +x $out/bin/newsboat-count $out/bin/newsboat-open
  '';
}
