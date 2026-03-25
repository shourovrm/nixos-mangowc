# home/rms/home-modules/gtk.nix  (nixos-config-v2)
# GTK theming and dconf settings so GTK apps (Nautilus, Thunar, Firefox, etc.)
# look consistent and use dark Adwaita rather than ugly unstyled defaults.
{ pkgs, ... }:

{
  # ── GTK theme (Home Manager manages ~/.config/gtk-3.0 and gtk-4.0) ───────
  gtk = {
    enable = true;

    theme = {
      name    = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;   # Adwaita-style dark theme for GTK 3
    };

    iconTheme = {
      name    = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    cursorTheme = {
      name    = "Adwaita";
      size    = 24;
      package = pkgs.adwaita-icon-theme;
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  # ── dconf / GSettings overrides ───────────────────────────────────────────
  # These settings are read by GTK apps via GSettings.  They persist across
  # sessions because dconf stores them in ~/.config/dconf/user.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme    = "adw-gtk3-dark";
      icon-theme   = "Adwaita";
      cursor-theme = "Adwaita";
      cursor-size  = 24;
      # prefer-dark: GTK4 apps (Firefox, Nautilus, etc.) use dark variant
      color-scheme = "prefer-dark";
    };
    # Decorations: prefer client-side (no server double border in tiling WMs)
    "org/gnome/settings-daemon/plugins/xsettings" = {
      overrides = "{\"Gtk/ShellShowsMenubar\": <0>, \"Gtk/DialogsUseHeader\": <0>}";
    };
  };

  # ── Cursor environment variable ───────────────────────────────────────────
  # Some GTK/XWayland apps still respect environment overrides more reliably
  # than settings portals, so export the theme and cursor explicitly.
  home.sessionVariables = {
    GTK_THEME     = "adw-gtk3-dark";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE  = "24";
  };
}
