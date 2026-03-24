# home/rms/home-modules/vscode.nix
# VSCode with Wayland flags + LaTeX Workshop extension.
{ pkgs, ... }:

{
  programs.vscode = {
    enable   = true;
    package  = pkgs.vscode.override {
      commandLineArgs = "--ozone-platform=wayland --password-store=gnome-libsecret";
    };

    # Allow installing extra extensions from the marketplace at runtime.
    mutableExtensionsDir = true;

    extensions = with pkgs.vscode-extensions; [
      james-yu.latex-workshop
    ];

    userSettings = {
      # ── LaTeX Workshop ──────────────────────────────────────────────────
      # Recompile on every save
      "latex-workshop.latex.autoBuild.run"         = "onSave";
      # Show compiled PDF in a side tab (side-by-side editing)
      "latex-workshop.view.pdf.viewer"             = "tab";
      # Clean auxiliary files only when build fails
      "latex-workshop.latex.autoClean.run"         = "onFailed";
      # Enable SyncTeX so Ctrl+click in PDF jumps to source line
      "latex-workshop.synctex.afterBuild.enabled"  = true;
      # Reuse last-used recipe when auto-building
      "latex-workshop.latex.recipe.default"        = "lastUsed";
    };
  };
}
