# home/rms/home-modules/packages.nix
# User-level packages that only need an install (no rich Home Manager config).
# Anything needing >~5 lines of config gets its own module file instead.
# VSCode lives in vscode.nix; Neovim lives in neovim.nix.
{ pkgs, opencode, ... }:

{
  home.packages = with pkgs; [
    opencode     # AI coding assistant (sourced from opencode-flake input)
    firefox      # web browser
    btop         # interactive process/resource monitor
    rustc        # Rust compiler
    cargo        # Rust package manager/build tool
    rustfmt      # Rust formatter
    clippy       # Rust linter
    rust-analyzer # Rust language server
    ripgrep      # fast recursive grep (rg)
    fd           # fast alternative to find
    bat          # cat with syntax highlighting and paging
    eza          # modern ls replacement
    pfetch       # lightweight system information summary
    liquidprompt # adaptive shell prompt for Bash/Zsh
    mpv          # lightweight video/audio player
    gparted      # graphical partition editor (needs root)
    libreoffice  # office suite
    evince       # PDF/document viewer
    nodejs       # JavaScript runtime (needed by some tools, e.g. Copilot)
    uv           # Python package & environment manager

    # ── LaTeX (offline, auto-installs missing packages on first compile) ────
    miktex       # MiKTeX TeX distribution; downloads CTAN packages on demand
    perl         # latexmk is a Perl script; required by MiKTeX’s latexmk

    # ── Container / distro tooling ───────────────────────────────────
    distrobox    # run any Linux distro as a rootless container; integrates with host
    podman       # OCI container runtime (backend for distrobox; daemonless)
    # ── News / media consumption (newsboat ecosystem) ────────────────────
    newsboat     # TUI RSS/Atom reader; config in home/rms/home-modules/newsboat.nix
    yt-dlp       # YouTube / streaming site downloader (queued by qndl)
    links2       # text-mode web browser for reading articles in terminal
    taskspooler  # tsp: serialise background jobs (used by qndl for downloads)
    urlscan      # TUI URL selector for newsboat external-url-viewer
  ];
}
