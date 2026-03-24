# home/rms/home-modules/mangowc.nix
# MangoWC (mango) compositor — user configuration and autostart.
# Config: ~/.config/mango/config.conf
# Autostart: ~/.config/mango/autostart.sh
#
# Keybindings mirror Niri's layout where logical:
#   Super+Return  → terminal    Super+Q      → close window
#   Super+H/L/J/K → focus       Super+Shift+H/L/J/K → swap
#   Super+1-5     → switch tag  Super+Shift+1-5 → move to tag
#   Super+D       → launcher    Super+N/B → notification/control panels
#   Super+Space   → next layout Super+O → overview
#   Super+Ctrl+L  → lock screen Super+Shift+E → quit
{ pkgs, ... }:

{
  # ── Additional packages needed by the autostart / keybinds ───────────────
  # Most session tools (foot, swaylock, swaybg, grim, slurp, mako, …) are
  # already provided by niri.nix which is also imported for this host.
  home.packages = with pkgs; [
    mangowc       # the compositor itself (binary: mango)
  ];

  # ── MangoWC config ────────────────────────────────────────────────────────
  xdg.configFile."mango/config.conf".text = ''
    # MangoWC / mango compositor config
    # Docs: https://mangowm.github.io/docs
    # ── Effect ─────────────────────────────────────────────────────────────
    blur=0
    blur_layer=1
    blur_optimized=1
    blur_params_num_passes=2
    blur_params_radius=5
    blur_params_noise=0.02
    blur_params_brightness=0.9
    blur_params_contrast=0.9
    blur_params_saturation=1.2

    shadows=1
    layer_shadows=1
    shadow_only_floating=1
    shadows_size=12
    shadows_blur=15
    shadows_position_x=0
    shadows_position_y=0
    shadowscolor=0x000000ff

    border_radius=6
    no_radius_when_single=0
    focused_opacity=1.0
    unfocused_opacity=0.85

    # ── Animation ──────────────────────────────────────────────────────────
    animations=1
    layer_animations=1
    animation_type_open=zoom
    animation_type_close=slide
    layer_animation_type_open=slide
    layer_animation_type_close=slide
    animation_fade_in=1
    animation_fade_out=1
    tag_animation_direction=1
    zoom_initial_ratio=0.3
    zoom_end_ratio=0.7
    fadein_begin_opacity=0.5
    fadeout_begin_opacity=0.8
    animation_duration_move=500
    animation_duration_open=400
    animation_duration_tag=350
    animation_duration_close=800
    animation_duration_focus=400
    animation_curve_open=0.46,1.0,0.29,1.1
    animation_curve_move=0.46,1.0,0.29,1
    animation_curve_tag=0.46,1.0,0.29,1
    animation_curve_close=0.08,0.92,0,1
    animation_curve_focus=0.46,1.0,0.29,1

    # ── Appearance / Layout ────────────────────────────────────────────────
    # Inner gaps 8 px, outer gaps 15 px — same feel as Niri (gaps = 8)
    gappih=8
    gappiv=8
    gappoh=15
    gappov=15
    borderpx=2
    no_border_when_single=0
    rootcolor=0x1e1e2eff
    bordercolor=0x505050ff
    focuscolor=0x7fc8ffff
    urgentcolor=0xad401fff
    maximizescreencolor=0xa6d189ff

    scratchpad_width_ratio=0.8
    scratchpad_height_ratio=0.9

    # ── Master-Stack defaults ──────────────────────────────────────────────
    new_is_master=1
    smartgaps=0
    default_mfact=0.55
    default_nmaster=1

    # ── Scroller defaults ──────────────────────────────────────────────────
    scroller_default_proportion=0.8
    scroller_focus_center=0
    scroller_prefer_center=1
    scroller_proportion_preset=0.5,0.8,1.0

    # ── Overview ───────────────────────────────────────────────────────────
    hotarea_size=10
    enable_hotarea=1
    overviewgappi=5
    overviewgappo=30

    # ── Misc ───────────────────────────────────────────────────────────────
    xwayland_persistence=1
    focus_on_activate=1
    sloppyfocus=1
    warpcursor=1
    cursor_size=24
    cursor_hide_timeout=0
    drag_tile_to_tile=1
    single_scratchpad=1
    circle_layout=tile,scroller

    # ── Keyboard ──────────────────────────────────────────────────────────
    repeat_rate=25
    repeat_delay=600
    numlockon=1
    xkb_rules_layout=us,bd
    xkb_rules_variant=,probhat

    # ── Touchpad ──────────────────────────────────────────────────────────
    disable_trackpad=0
    tap_to_click=1
    tap_and_drag=1
    drag_lock=1
    trackpad_natural_scrolling=1
    disable_while_typing=1
    accel_speed=0.2

    # ── Keybindings ────────────────────────────────────────────────────────
    # Syntax: bind=MODIFIERS,KEY,COMMAND[,PARAMS]
    # Modifiers: SUPER CTRL ALT SHIFT NONE — combined with +

    # Apps
    bind=SUPER,Return,spawn,foot
    bind=SUPER+CTRL,L,spawn,swaylock -f -c 1a1a2e

    # Noctalia IPC (matches Niri: Super+D launcher, Super+N notifs, Super+B CC)
    bind=SUPER,D,spawn_shell,noctalia-shell ipc call launcher toggle
    bind=SUPER,N,spawn_shell,noctalia-shell ipc call notifications togglePanel
    bind=SUPER,B,spawn_shell,noctalia-shell ipc call controlCenter toggle

    # Clipboard picker: Super+V → select from cliphist → paste
    bind=SUPER,V,spawn_shell,cliphist list | fuzzel --dmenu | cliphist decode | wl-copy

    # Volume (PipeWire / WirePlumber)
    bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    # Brightness
    bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl set +10%
    bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl set 10%-

    # Media playback
    bind=NONE,XF86AudioPlay,spawn,playerctl play-pause
    bind=NONE,XF86AudioNext,spawn,playerctl next
    bind=NONE,XF86AudioPrev,spawn,playerctl previous

    # Screenshots: Print = region select, Super+S = fullscreen
    bind=NONE,Print,spawn_shell,grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
    bind=SUPER,S,spawn_shell,grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

    # Window management
    bind=SUPER,Q,killclient
    bind=SUPER+SHIFT,F,togglefullscreen
    bind=SUPER,F,togglemaximizescreen
    bind=SUPER,O,toggleoverview

    # Keyboard layout cycling (Super+Space — matches Niri)
    bind=SUPER,Space,switch_keyboard_layout

    # Focus: vim keys + arrow keys (matches Niri Super+H/L/J/K, Super+Arrow)
    bind=SUPER,H,focusdir,left
    bind=SUPER,L,focusdir,right
    bind=SUPER,J,focusdir,down
    bind=SUPER,K,focusdir,up
    bind=SUPER,Left,focusdir,left
    bind=SUPER,Right,focusdir,right
    bind=SUPER,Down,focusdir,down
    bind=SUPER,Up,focusdir,up

    # Move / swap windows (matches Niri Super+Shift+H/L and arrow keys)
    bind=SUPER+SHIFT,H,exchange_client,left
    bind=SUPER+SHIFT,L,exchange_client,right
    bind=SUPER+SHIFT,J,exchange_client,down
    bind=SUPER+SHIFT,K,exchange_client,up
    bind=SUPER+SHIFT,Left,exchange_client,left
    bind=SUPER+SHIFT,Right,exchange_client,right

    # Layout cycling (Super+R — matches Niri's preset-column-width cycle)
    bind=SUPER,R,switch_layout

    # Tags 1–5 (like Niri workspaces: Super+N switches, Super+Shift+N moves)
    bind=SUPER,1,view,1
    bind=SUPER,2,view,2
    bind=SUPER,3,view,3
    bind=SUPER,4,view,4
    bind=SUPER,5,view,5
    bind=SUPER+SHIFT,1,tag,1
    bind=SUPER+SHIFT,2,tag,2
    bind=SUPER+SHIFT,3,tag,3
    bind=SUPER+SHIFT,4,tag,4
    bind=SUPER+SHIFT,5,tag,5

    # Mouse: Super+drag to move/resize floating windows
    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresize

    # Reload config hot (no compositor restart needed)
    bind=SUPER+CTRL,R,reload_config

    # Quit (matches Niri Super+Shift+E)
    bind=SUPER+SHIFT,E,quit

    # ── Autostart ──────────────────────────────────────────────────────────
    exec-once=~/.config/mango/autostart.sh
  '';

  # ── Autostart script ─────────────────────────────────────────────────────
  # mango runs this on session start.  We set PATH explicitly because mango
  # may launch with a thin environment depending on the login manager.
  home.file.".config/mango/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # MangoWC autostart — session tools launched when mango starts.
      export PATH="/run/current-system/sw/bin:/home/rms/.nix-profile/bin:$PATH"

      # Polkit authentication agent (no GNOME session in v2)
      /run/current-system/sw/libexec/polkit-gnome-authentication-agent-1 &

      # Status bar
      noctalia-shell &

      # Notification daemon (configured via niri.nix services.mako)
      mako &

      # Clipboard history watcher (feeds wl-paste into cliphist)
      wl-paste --type text --watch cliphist store &

      # Idle management: lock at 5 min, turn displays off at 10 min, suspend
      # only on battery at 3 h. Lock/display-off happen on both AC and battery.
      swayidle -w \
        timeout 300  "swaylock -f -c 1a1a2e" \
        timeout 600  "wlopm --off '*'" \
        resume       "wlopm --on '*'" \
        timeout 10800 \
          "grep -rq Discharging /sys/class/power_supply/ 2>/dev/null \
           && /run/current-system/sw/bin/systemctl suspend || true" \
        before-sleep "swaylock -f -c 1a1a2e" &
    '';
  };
}
