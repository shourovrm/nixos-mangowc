# pkgs/nvim-open/default.nix
# A tiny wrapper that opens files in Neovim inside a foot terminal.
# foot auto-closes when Neovim exits, which makes it behave like a "neovim
# that also closes its window on :q".
{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "nvim-open";
  src  = ./.;

  # Runtime deps: foot, nvim
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp nvim-open $out/bin/nvim-open
    chmod +x $out/bin/nvim-open
  '';
}
