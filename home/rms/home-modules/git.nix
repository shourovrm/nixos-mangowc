# home/rms/home-modules/git.nix
# Git identity and global settings managed by Home Manager.
{ ... }:

{
  programs.git = {
    enable    = true;
    userName  = "rms";
    userEmail = "you@example.com";   # CHANGE to your real email before first commit

    extraConfig = {
      init.defaultBranch = "main";  # new repos start on 'main', not 'master'
      pull.rebase        = false;   # 'git pull' creates a merge commit (not rebase)
      core.editor        = "nvim";  # nvim is the default Git commit-message editor
    };
  };
}
