# Flake Management Guide

Day-to-day and maintenance commands for this flake-based NixOS configuration.

---

## Rebuild commands

| Task | Command |
| --- | --- |
| Rebuild & switch | `sudo nixos-rebuild switch --flake ~/nixos-config-v2#rms-laptop` |
| Test without switching | `sudo nixos-rebuild test --flake ~/nixos-config-v2#rms-laptop` |
| Roll back | `sudo nixos-rebuild switch --rollback` |
| Garbage collect | `sudo nix-collect-garbage -d` |

Aliases in `.bashrc`:
- `nixswitch` — rebuild & switch
- `nixup` — flake update then switch

---

## Updating inputs (nixos-unstable)

```bash
# 1. Pull latest revisions for all inputs
nix flake update ~/nixos-config-v2

# 2. Test the build before activating
sudo nixos-rebuild test --flake ~/nixos-config-v2#rms-laptop

# 3. Switch if it looks good
sudo nixos-rebuild switch --flake ~/nixos-config-v2#rms-laptop

# 4. Commit the updated lock file
cd ~/nixos-config-v2
git add flake.lock
git commit -m "chore: flake update $(date '+%Y-%m-%d')"

# Optional — reclaim old store paths
sudo nix-collect-garbage -d
```

Update a single input only:
```bash
nix flake update nixpkgs
```

---

## What goes where

| Concern | File |
| --- | --- |
| Bootloader, kernel, filesystems | `hosts/rms-laptop/hardware-configuration.nix` |
| Machine identity, user account | `hosts/rms-laptop/configuration.nix` |
| Locale, greetd, storage, audio, Nix GC | `modules/nixos/*.nix` |
| User apps, shell, git, editors | `home/rms/home-modules/*.nix` |

---

## Adding packages or software

**Rule of thumb:** one-line installs → add to an existing file; richer config → new dedicated file.

### User package (no config needed)
Add to `home/rms/home-modules/packages.nix`:
```nix
home.packages = with pkgs; [
  my-new-package
];
```

### System package (needs root / available before login)
Add to `environment.systemPackages` in `hosts/rms-laptop/configuration.nix`.

### Program with Home Manager options
If a few lines, add to the relevant existing module (`bash.nix`, `neovim.nix`, etc.).
If it grows beyond ~20–30 lines, create a new file and import it in `home/rms/home.nix`:
```nix
imports = [
  ...
  ./home-modules/my-program.nix
];
```

### New system-level concern
Create `modules/nixos/my-concern.nix` and import it in `hosts/rms-laptop/configuration.nix`.

---

## Adding a second machine

```
hosts/
└── rms-desktop/
    ├── configuration.nix          # import same modules/nixos/* as laptop
    └── hardware-configuration.nix
```

Add a new output in `flake.nix`:
```nix
nixosConfigurations.rms-desktop = nixpkgs.lib.nixosSystem { ... };
```

All `modules/nixos/` and `home/rms/home-modules/` files reuse unchanged.

---

## Keeping STATUS.md current

After any change, update `STATUS.md` at the repo root:
1. Adjust the relevant table in *Current configuration* if something structural changed.
2. Append a dated bullet in the **Changelog** section.
