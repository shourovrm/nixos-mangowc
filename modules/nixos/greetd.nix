# modules/nixos/greetd.nix  (nixos-config-v2)
# Login manager: greetd + tuigreet (replaces GDM + GNOME in v1).
# greetd is a minimal, compositor-agnostic login manager.
# tuigreet is a TUI greeter that lists all registered Wayland/X11 sessions.
{ pkgs, ... }:

{
  # ── Display server (still needed for XWayland/Xorg fallback) ─────────────
  services.xserver.enable = true;

  # ── Login manager ─────────────────────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # --time: show clock  --remember: remember last user + session
        # --sessions: list available Wayland/X11 sessions from the system path
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --remember-session \
            --sessions /run/current-system/sw/share/wayland-sessions
        '';
        user = "greeter";
      };
    };
  };

  # Ensure the greeter can see all registered sessions
  environment.sessionVariables.XDG_DATA_DIRS =
    [ "/run/current-system/sw/share" ];

  # ── Keyring: unlock gnome-keyring-daemon at greetd login ─────────────────
  # Run the keyring daemon outside GNOME and unlock it through greetd/login PAM
  # so apps can use org.freedesktop.secrets in the Niri session.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring  = true;

  # ── PolKit ────────────────────────────────────────────────────────────────
  security.polkit.enable = true;

  # ── XKB keyboard layouts ─────────────────────────────────────────────────
  services.xserver.xkb = {
    layout  = "us,bd";
    variant = ",probhat";
  };

  # ── Printing ──────────────────────────────────────────────────────────────
  services.printing.enable = true;
}
