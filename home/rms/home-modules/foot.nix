# home/rms/home-modules/foot.nix
# foot terminal emulator configuration via Home Manager.
#
# Theme: Catppuccin Mocha (dark purple-tinted dark theme), matching the overall
# Noctalia Monochrome palette.
# Font: JetBrains Mono at 10 pt — consistent with other tooling.
# Transparency: 5% alpha for a subtle translucency effect.
# Scrollback: 10 000 lines.
#
# Dependencies: JetBrains Mono is available in nixpkgs as jetbrains-mono.
{ pkgs, ... }:

{
  # Provide JetBrains Mono font
  home.packages = [ pkgs.jetbrains-mono ];

  programs.foot = {
    enable = true;

    settings = {
      # ── Main ──────────────────────────────────────────────────────────────
      main = {
        # JetBrains Mono: excellent legibility, good ligature coverage
        font      = "JetBrains Mono:size=10";
        dpi-aware = "yes";  # scale font by display DPI automatically
        pad       = "8x8";  # 8 px horizontal × 8 px vertical inner padding
        # Shell inherits from the system default (bash via home.nix)
      };

      # ── Scrollback ────────────────────────────────────────────────────────
      scrollback = {
        lines = 10000;
      };

      # ── Cursor ────────────────────────────────────────────────────────────
      cursor = {
        style = "beam";   # blinking beam cursor (editor-style)
        blink = "yes";
      };

      # ── Mouse ─────────────────────────────────────────────────────────────
      mouse = {
        hide-when-typing = "yes";  # cursor disappears while you type
      };

      # ── Colours (Catppuccin Mocha) ────────────────────────────────────────
      # Background has 5 % transparency (alpha = 0.95) for a slight blur effect.
      # Foreground and palette follow the official Catppuccin Mocha spec.
      colors-dark = {
        # 5 % transparent background — complements the Noctalia dark overlay
        alpha      = "0.95";

        # Base text colours
        foreground = "cdd6f4";  # text
        background = "1e1e2e";  # base (deep dark purple)

        # ── Normal (0–7) ──────────────────────────────────────────────────
        regular0 = "45475a";   # surface1    (black)
        regular1 = "f38ba8";   # red
        regular2 = "a6e3a1";   # green
        regular3 = "f9e2af";   # yellow
        regular4 = "89b4fa";   # blue
        regular5 = "f5c2e7";   # pink        (magenta)
        regular6 = "94e2d5";   # teal        (cyan)
        regular7 = "bac2de";   # subtext1    (white)

        # ── Bright (8–15) ─────────────────────────────────────────────────
        bright0  = "585b70";   # surface2    (bright black / grey)
        bright1  = "f38ba8";   # red         (same; Catppuccin keeps it)
        bright2  = "a6e3a1";   # green
        bright3  = "f9e2af";   # yellow
        bright4  = "89b4fa";   # blue
        bright5  = "f5c2e7";   # pink
        bright6  = "94e2d5";   # teal
        bright7  = "a6adc8";   # subtext0    (bright white)

        # Selection overlay
        selection-foreground = "cdd6f4";
        selection-background = "45475a";
      };

      # ── Desktop notifications ─────────────────────────────────────────────
      bell = {
        urgent = "yes";  # mark window urgent in taskbar on BEL
        notify = "no";   # do not send a desktop notification per BEL
      };
    };
  };
}
