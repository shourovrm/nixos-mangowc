# home/rms/home-modules/noctalia.nix
# Noctalia shell — declarative config via its Home Manager module.
{ config, inputs, pkgs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    # Noctalia's Network/Bluetooth services shell out to nmcli/bluetoothctl.
    # Bundle those CLIs into the wrapped runtime PATH instead of relying on
    # the compositor session environment to expose /run/current-system/sw/bin.
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      extraPackages = with pkgs; [ networkmanager bluez ];
    };

    settings = {
      bar = {
        density     = "compact";
        position    = "top";
        showCapsule = false;

        widgets = {
          left = [
            { id = "ControlCenter"; useDistroLogo = true; }
            { id = "Network"; }
            { id = "Bluetooth"; }
          ];
          center = [
            { id = "Workspace"; hideUnoccupied = false; labelMode = "none"; }
          ];
          right = [
            # Current keyboard layout — click cycles to next layout; Super+Space also works
            { id = "KeyboardLayout"; }

            # System stats: RAM %, net speed, /root disk % shown inline.
            # compactMode = true  → mini-gauge icon only (no text, click to see values)
            # compactMode = false → displays the actual values as text in the bar
            {
              id                    = "SystemMonitor";
              compactMode           = false;  # show values inline, not just icon
              useMonospaceFont      = true;
              showCpuUsage          = false;
              showCpuTemp           = false;
              showMemoryUsage       = true;
              showMemoryAsPercent   = true;
              showNetworkStats      = true;
              showDiskUsage         = true;
              showDiskUsageAsPercent = true;
              diskPath              = "/";
            }
            # Volume — click opens audio mixer
            { id = "Volume"; displayMode = "always"; }
            { id = "Battery"; alwaysShowPercentage = true; warningThreshold = 20; }
            {
              id                = "Clock";
              # Format: "24 Mar 26, Tue, 08:00 AM"
              # Qt tokens: d=day, MMM=short month, yy=2-digit year,
              # ddd=short weekday, hh=12h hour, mm=minute, AP=AM/PM
              formatHorizontal  = "d MMM yy, ddd, hh:mm AP";
              formatVertical    = "hh:mm\nAP";
              useMonospacedFont = true;
              usePrimaryColor   = true;
            }
            # Current temperature — weather-bar emits a weather symbol plus temp;
            # click opens the full forecast in foot.
            {
              id             = "CustomButton";
              showIcon       = false;
              textCommand    = "weather-bar";   # outputs "🌦 +26°C" or "N/A"
              textIntervalMs = 1800000;         # refresh every 30 minutes
              leftClickExec  = "weather-open";  # opens full 3-day forecast in foot
            }
            # Newsboat unread articles — shows a newspaper emoji plus unread count.
            {
              id              = "CustomButton";
              showIcon        = false;
              textCommand     = "newsboat-count";  # script outputs "📰 <n>"
              textIntervalMs  = 300000;            # refresh every 5 minutes
              leftClickExec   = "newsboat-open";   # opens newsboat in foot terminal
            }
            # Dark / light mode toggle for Noctalia colour scheme
            { id = "DarkMode"; }
            # Session menu — shutdown / reboot / logout / screen off
            { id = "SessionMenu"; }
          ];
        };
      };

      colorSchemes.predefinedScheme = "Monochrome";

      # Use Noctalia's wallpaper engine as the single background layer in this setup.
      # This keeps overview integration consistent without a separate wallpaper app.
      wallpaper = {
        enabled = true;
        directory = "${config.home.homeDirectory}/.local/share/wallpapers";
        fillMode = "crop";
        automationEnabled = false;
        setWallpaperOnAllMonitors = true;
        overviewEnabled = true;
        transitionType = [ "none" ];
        skipStartupTransition = true;
      };

      general = {
        avatarImage = "/home/rms/.face";
        radiusRatio = 0.2;
      };

      location = {
        monthBeforeDay = false;
        name           = "Dhaka, Bangladesh";
      };
    };
  };

  home.file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
    defaultWallpaper = "${config.home.homeDirectory}/.local/share/wallpapers/wallhaven_eo2p3w.jpg";
    wallpapers = { };
    usedRandomWallpapers = { };
  };
}
