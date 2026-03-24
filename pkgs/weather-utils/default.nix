# pkgs/weather-utils/default.nix
# Two small scripts for the Noctalia bar weather widget:
#   weather-bar  — prints current temperature (e.g. "+26°C") for the bar text
#   weather-open — opens full wttr.in forecast in a foot terminal
{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation {
  pname   = "weather-utils";
  version = "1";

  src = ./.;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    install -Dm755 weather-bar  $out/bin/weather-bar
    install -Dm755 weather-open $out/bin/weather-open

    # Wrap to ensure curl and foot are on PATH
    wrapProgram $out/bin/weather-bar  --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.curl ]}
    wrapProgram $out/bin/weather-open --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.curl pkgs.foot ]}
  '';
}
