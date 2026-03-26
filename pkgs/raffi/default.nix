# pkgs/raffi/default.nix — raffi 0.20.0 built from source
# nixpkgs-unstable only ships 0.12.0; this derivation provides the full 0.20.0
# which supports the v1 YAML schema (version: 1 + launchers: wrapper),
# the native iced UI (--ui-type native), inline calculator (meval) and
# live currency conversion (ureq).
{ lib, rustPlatform, fetchFromGitHub, pkg-config, makeWrapper, libxkbcommon, wayland, openssl }:

rustPlatform.buildRustPackage rec {
  pname    = "raffi";
  version  = "0.20.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo  = "raffi";
    rev   = "v${version}";
    hash  = "sha256-WAYSHQIQRd37xTpOs4EhK0V4wcBLWIRP7KvA7XjIZ0g=";
  };

  cargoHash = "sha256-VPgMavPK6HGKICmGgPIM1YDvsRJrdndfbetAOqMAQ0M=";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs       = [ libxkbcommon wayland openssl ];

  # iced/winit loads libwayland-client.so dynamically at runtime; the RPATH
  # from buildInputs is not enough.  Wrap the binary so the library is found.
  postInstall = ''
    wrapProgram $out/bin/raffi \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland libxkbcommon ]}"
  '';

  # "wayland" is already the default feature in Cargo.toml, so no
  # extra buildFeatures flag is required. The feature enables iced
  # (native UI), meval (calculator), ureq (currency) and regex.

  # Some tests require filesystem emoji/config fixtures not present in the
  # nix build sandbox; skip them.
  doCheck = false;

  meta = with lib; {
    description = "A YAML-based application launcher with native or fuzzel UI";
    homepage    = "https://github.com/chmouel/raffi";
    license     = licenses.asl20;
    mainProgram = "raffi";
    platforms   = platforms.linux;
  };
}
