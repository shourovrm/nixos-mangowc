# home/rms/home-modules/bash.nix
# Bash shell: aliases and extra bashrc snippets managed by Home Manager.
{ ... }:

{
  programs.bash = {
    enable = true;

    shellAliases = {
      ll        = "eza -lah";          # coloured long-listing with human sizes
      cat       = "bat";               # bat replaces cat with syntax highlighting
      nixswitch = "sudo nixos-rebuild switch --flake ~/nixos-config#rms-laptop"; # apply config
      nixup     = "nix flake update ~/nixos-config && nixswitch";               # update + apply
    };

    bashrcExtra = ''
      # Load API keys / secrets from an optional file excluded from git
      [ -f ~/.secrets/apirc ] && source ~/.secrets/apirc

      # Auto-activate the general Python venv if no other venv is already active.
      # The venv lives at ~/.venv/general and is created once with:
      #   uv venv ~/.venv/general && uv pip install <packages>
      if [ -z "$VIRTUAL_ENV" ] && [ -f "$HOME/.venv/general/bin/activate" ]; then
        source "$HOME/.venv/general/bin/activate"
      fi
    '';
  };
}
