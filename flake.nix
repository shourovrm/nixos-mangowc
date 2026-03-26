# flake.nix
# Root of the NixOS config. Declares all external inputs and wires them
# together into a single nixosConfiguration for each machine.
# Add a new machine: duplicate the rms-laptop block, change hostName + hardware.
{
  description = "rms NixOS config — greetd + tuigreet, Niri, no GNOME";

  inputs = {
    # nixos-unstable: rolling channel — latest packages but may change APIs.
    # Use github:NixOS/nixpkgs/nixos-24.11 for a stable channel instead.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager: manages the ~/.config files and user-level packages.
    # `inputs.nixpkgs.follows` makes it use OUR nixpkgs, not its own copy.
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # opencode: AI coding CLI not yet in nixpkgs; consumed as a flake input.
    opencode-flake = {
      url = "github:aodhanhayter/opencode-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia shell: QML-based status bar and launcher.
    # noctalia-qs is its quickshell dependency, pinned here so both use the
    # same nixpkgs and don't pull in two copies of the store closure.
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, opencode-flake, noctalia, noctalia-qs, ... }@inputs:
    let
      system = "x86_64-linux";  # change to aarch64-linux for ARM (e.g. Pi)
      pkgs   = nixpkgs.legacyPackages.${system};
    in
    {
      # ── Custom packages (pkgs/ directory) ───────────────────────────────────
      # Each entry can be built with: nix build .#<name>
      # They are also consumed by home/rms/home-modules/scripts.nix via callPackage.
      packages.${system} = {
        fuzzel-handler  = pkgs.callPackage ./pkgs/fuzzel-handler  {};
        link-handler    = pkgs.callPackage ./pkgs/link-handler    {};
        qndl            = pkgs.callPackage ./pkgs/qndl            {};
        newsboat-utils  = pkgs.callPackage ./pkgs/newsboat-utils  {};
        nvim-open       = pkgs.callPackage ./pkgs/nvim-open       {};
        weather-utils   = pkgs.callPackage ./pkgs/weather-utils   {};
      };

      # One attribute per machine. The key (rms-laptop) must match:
      #   boot.loader.grub entry and `nixos-rebuild --flake .#rms-laptop`
      nixosConfigurations.rms-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        # specialArgs passes `inputs` down to every NixOS module so they can
        # pull packages / modules from any flake input without extra imports.
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/rms-laptop/configuration.nix
          # Embed Home Manager inside NixOS so a single `nixos-rebuild switch`
          # applies both system config and user config atomically.
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs        = true;  # don't duplicate nixpkgs
            home-manager.useUserPackages      = true;  # install packages via HM
            home-manager.backupFileExtension  = "backup"; # avoid conflicts with existing files
            home-manager.users.rms            = import ./home/rms/home.nix;
            # Extra args forwarded exclusively to Home Manager modules:
            home-manager.extraSpecialArgs = {
              inherit inputs;  # lets HM modules access flake inputs (e.g. noctalia)
              opencode = opencode-flake.packages.${system}.default;
            };
          }
        ];
      };
    };
}
