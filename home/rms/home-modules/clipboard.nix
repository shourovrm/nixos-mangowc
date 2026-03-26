# home/rms/home-modules/clipboard.nix
# Persistent clipboard history using cliphist + wl-clipboard.
# cliphist stores every clipboard entry (text and images) and exposes a dmenu-
# compatible list so you can paste any previous entry via fuzzel.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cliphist    # clipboard history manager (stores entries from wl-paste)
    wl-clipboard  # wl-copy / wl-paste (already in niri.nix but idempotent)
  ];

  # ── Autostart: feed clipboard events into cliphist ────────────────────────
  # This systemd user service runs wl-paste in watch mode and pipes each new
  # clipboard entry into cliphist. It starts automatically in the Wayland
  # session because it is a graphical-session-pre.target dependency.
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history daemon (cliphist)";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart   = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # ── Keybind hint ──────────────────────────────────────────────────────────
  # niri.nix binds Super+V to the clipboard picker:
  #   cliphist list | fuzzel --dmenu | cliphist decode | wl-copy
}
