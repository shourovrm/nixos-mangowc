# home/rms/home-modules/niri.nix  (nixos-config-v2)
# Niri compositor user configuration and helper tools.
# v2 uses greetd (not GDM) and wlopm for generic wlroots monitor power-off.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel          # app launcher
    raffi           # YAML-driven launcher on top of fuzzel
    foot            # Wayland-native terminal
    swaylock        # screen locker
    swayidle        # idle management
    wl-clipboard    # clipboard (wl-copy / wl-paste)
    wlopm           # monitor power manager used by swayidle
    grim            # screenshots
    slurp           # region selection for screenshots
    libnotify       # notify-send
    mako            # notification daemon
    brightnessctl   # screen brightness (XF86 keys)
    playerctl       # media playback control (XF86 keys)
    gcr             # SystemPrompter for gnome-keyring in non-GNOME sessions
  ];

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;   # dismiss notifications after 5 s
      ignore-timeout  = false;
    };
  };

  # ── Idle / power management ───────────────────────────────────────────────
  # Lock after 5 minutes, power displays off after 10 minutes, and suspend
  # after 3 hours only while the machine is discharging. Full paths are used
  # because swayidle's systemd unit runs with a restricted PATH.
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f -c 1a1a2e";
    };
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 1a1a2e";
      }
      {
        timeout = 600;
        command       = "${pkgs.wlopm}/bin/wlopm --off '*'";
        resumeCommand = "${pkgs.wlopm}/bin/wlopm --on '*'";
      }
      {
        timeout = 10800;
        command = ''${pkgs.gnugrep}/bin/grep -rq Discharging /sys/class/power_supply/ 2>/dev/null && /run/current-system/sw/bin/systemctl suspend || true'';
      }
    ];
  };

  # ── Wallpaper ───────────────────────────────────────────────────────────
  # Seed Noctalia's wallpaper directory from the repo so the shell's built-in
  # wallpaper layer can use a stable path independent of the checkout location.
  home.file.".local/share/wallpapers/wallhaven_eo2p3w.jpg".source =
    ../../../wallhaven_eo2p3w.jpg;

  # ── Secret service (keyring) ─────────────────────────────────────────────
  # The daemon itself is enabled at the NixOS level so PAM can unlock it.
  # gcr supplies the SystemPrompter used when apps need to ask for access.
  # Chromium-based/Electron apps still need an explicit password-store flag.

  # Chromium / Electron global flags — read by Chromium, Chrome, and most
  # Electron apps (VS Code uses its own override in packages.nix instead).
  home.file.".config/chromium-flags.conf".text = ''
    --ozone-platform=wayland
    --password-store=gnome-libsecret
  '';

  # Fuzzel is the frontend and Raffi provides the launcher entries / actions.
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    dpi-aware=yes
    font=JetBrains Mono:size=10
    terminal=foot
    width=40
    layer=overlay
    exit-on-keyboard-focus-loss=no
    inner-pad=12
    fields=filename,name,comment

    [colors]
    background=1e1e2eff
    text=cdd6f4ff
    match=89b4faff
    selection=45475aff
    selection-text=cdd6f4ff
    selection-match=89dcebff
    border=7fc8ffff
  '';

  xdg.configFile."raffi/raffi.yaml".text = ''
    version: 1

    general:
      ui_type: fuzzel
      max_history: 20

    launchers:
      browser:
        binary: firefox
        description: "Firefox"
        icon: firefox

      terminal:
        binary: foot
        description: "Foot terminal"
        icon: utilities-terminal

      files:
        binary: thunar
        description: "Thunar file manager"
        icon: org.xfce.thunar

      downloads:
        binary: thunar
        args: ["~/Downloads"]
        description: "Downloads"
        icon: folder-download

      editor:
        binary: code
        description: "VS Code"
        icon: vscode

      newsboat:
        binary: foot
        args: ["newsboat"]
        description: "Newsboat"
        icon: applications-internet

      weather:
        binary: weather-open
        description: "Weather forecast"
        icon: weather-overcast

      google_drive:
        binary: thunar
        args: ["~/GoogleDrive"]
        description: "Google Drive"
        icon: folder-remote

      lock:
        binary: swaylock
        args: ["-f"]
        description: "Lock screen"
        icon: system-lock-screen

    addons:
      web_searches:
        - name: "Google"
          keyword: "g"
          url: "https://www.google.com/search?q={query}"
          icon: google
        - name: "GitHub"
          keyword: "gh"
          url: "https://github.com/search?q={query}"
          icon: github
        - name: "Nix Packages"
          keyword: "np"
          url: "https://search.nixos.org/packages?channel=unstable&query={query}"
          icon: nix-snowflake
  '';

  # Polkit authentication agent for privilege dialogs inside niri
  services.polkit-gnome.enable = true;

  # Niri compositor config (~/.config/niri/config.kdl)
  xdg.configFile."niri/config.kdl".text = ''
    // ── Appearance ────────────────────────────────────────────────────────
    prefer-no-csd

    window-rule {
      geometry-corner-radius 12
      clip-to-geometry true
    }

    // Required for Noctalia notification actions and window activation
    debug {
      honor-xdg-activation-with-invalid-serial
    }

    // ── Input ─────────────────────────────────────────────────────────────
    input {
      keyboard {
        xkb {
          layout "us,bd"        // us = English, bd = Bangla
          variant ",probhat"    // second layout uses Probhat
          // No grp: toggle option needed — niri's own Super+Space bind handles layout cycling
        }
      }
      touchpad {
        tap
        natural-scroll
        accel-speed 0.2
      }
    }

    // ── Layout ────────────────────────────────────────────────────────────
    layout {
      gaps 8
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 2
        active-color "#7fc8ff"
        inactive-color "#505050"
      }

      border {
        off
      }
    }

    // ── Noctalia layer rule — blurred overview backdrop ───────────────────
    layer-rule {
      match namespace="^noctalia-overview*"
      place-within-backdrop true
    }

    // ── Key bindings ──────────────────────────────────────────────────────
    binds {
      // Apps
      Mod+T { spawn "foot"; }

      Mod+Ctrl+L { spawn "swaylock" "-f"; }

      // Volume (wpctl comes with PipeWire)
      XF86AudioRaiseVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute         { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute      { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      // Brightness
      XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
      XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

      // Media
      XF86AudioPlay  { spawn "playerctl" "play-pause"; }
      XF86AudioNext  { spawn "playerctl" "next"; }
      XF86AudioPrev  { spawn "playerctl" "previous"; }

      // Window management
      Mod+Q { close-window; }

      Mod+Left  { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up    { focus-window-up; }
      Mod+Down  { focus-window-down; }
      Mod+H { focus-column-left; }
      Mod+L { focus-column-right; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }

      Mod+Shift+Left  { move-column-left; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+H { move-column-left; }
      Mod+Shift+L { move-column-right; }

      Mod+F       { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+C       { center-column; }

      Mod+R     { switch-preset-column-width; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }

      // Workspaces
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+Shift+1 { move-window-to-workspace 1; }
      Mod+Shift+2 { move-window-to-workspace 2; }
      Mod+Shift+3 { move-window-to-workspace 3; }
      Mod+Shift+4 { move-window-to-workspace 4; }
      Mod+Shift+5 { move-window-to-workspace 5; }

      // Screenshots
      // Print → interactive region select; Mod+S → full screen
      Print     { screenshot; }
      Mod+S     { screenshot-screen; }
      Alt+Print { screenshot-window; }

      // Niri
      Mod+Shift+E { quit; }
      Mod+O       { toggle-overview; }

      // Launchers
      Mod+D       { spawn "raffi"; }  // default launcher: fuzzel frontend with Raffi entries
      Mod+Shift+D { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
      Mod+N     { spawn "noctalia-shell" "ipc" "call" "notifications" "togglePanel"; }
      Mod+B     { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }

      // Clipboard picker: Super+V → fuzzel dmenu → paste from history
      Mod+V { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }

      // Keyboard layout: cycle through configured XKB layouts (Super+Space)
      Mod+Space { switch-layout "next"; }
    }

    // ── Startup ───────────────────────────────────────────────────────────
    // Export the display/session environment into the user D-Bus activation
    // environment so portals and gcr prompts can find the active Wayland seat.
    spawn-at-startup "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "DISPLAY" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" "XDG_SESSION_TYPE" "NIRI_SOCKET"
    spawn-at-startup "noctalia-shell"
    // Polkit agent — needed since there is no GNOME session in v2
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
  '';
}
