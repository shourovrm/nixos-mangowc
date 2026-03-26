# home/rms/home-modules/vscode.nix
# VSCode with Wayland flags + LaTeX Workshop extension.
{ config, lib, pkgs, ... }:

let
  vscodeSettings = {
    # Recompile on every save.
    "latex-workshop.latex.autoBuild.run" = "onSave";
    # Show compiled PDF in a side tab.
    "latex-workshop.view.pdf.viewer" = "tab";
    # Clean auxiliary files only when build fails.
    "latex-workshop.latex.autoClean.run" = "onFailed";
    # Enable SyncTeX so Ctrl+click in PDF jumps to source line.
    "latex-workshop.synctex.afterBuild.enabled" = true;
    # Reuse last-used recipe when auto-building.
    "latex-workshop.latex.recipe.default" = "lastUsed";
  };
in

{
  programs.vscode = {
    enable   = true;
    package  = pkgs.vscode.override {
      commandLineArgs = "--ozone-platform=wayland --password-store=gnome-libsecret";
    };

    # Allow installing extra extensions from the marketplace at runtime.
    mutableExtensionsDir = true;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      james-yu.latex-workshop
    ];
  };

  # Keep the initial VS Code settings, but store them in a regular writable file
  # instead of a Home Manager symlink into /nix/store.
  home.activation.vscodeMutableSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings_file="${config.xdg.configHome}/Code/User/settings.json"

    mkdir -p "$(dirname "$settings_file")"

    if [ -L "$settings_file" ]; then
      rm "$settings_file"
    fi

    if [ ! -e "$settings_file" ]; then
      cat > "$settings_file" <<'EOF'
${builtins.toJSON vscodeSettings}
EOF
    fi
  '';
}
