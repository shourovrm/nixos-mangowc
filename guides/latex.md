# Offline LaTeX Setup Guide

Full Overleaf-equivalent workflow using **MiKTeX** + **VSCode LaTeX Workshop** — all configured in the Nix repo for one-command reproduction on any machine.

---

## How it works

| Component | Role |
| --- | --- |
| **MiKTeX** | TeX distribution — provides `pdflatex`, `xelatex`, `lualatex`, `latexmk`; **automatically downloads missing packages** from CTAN on the first compile |
| **LaTeX Workshop** (VSCode extension) | Editor integration — syntax highlighting, build shortcuts, live PDF preview, SyncTeX (click PDF → jump to source) |
| **Nix** | Installs MiKTeX & the extension declaratively; reproducible on any machine managed by this config |

---

## Installation (first time)

### 1 — Apply the NixOS config

```bash
sudo nixos-rebuild switch --flake ~/nixos-config-v2#rms-laptop
```

This installs `miktex`, `perl`, and the LaTeX Workshop VSCode extension automatically.

### 2 — Initialise MiKTeX (once per user)

MiKTeX must be initialised before its first use:

```bash
# Initialise the per-user MiKTeX installation
miktexsetup finish

# Enable automatic package download (the killer feature — no prompts)
initexmf --set-config-value "[MPM]AutoInstall=1"
```

Run these **once** after the first `nixos-rebuild switch`. They write to `~/.miktex/` and persist across rebuilds.

### 3 — Verify

```bash
pdflatex --version      # should print MiKTeX's pdflatex
latexmk --version
```

---

## Daily use

### Open a LaTeX project in VSCode

```bash
code ~/Documents/my-paper/
```

Open any `.tex` file. LaTeX Workshop activates automatically.

### Build

| Action | How |
| --- | --- |
| **Build on save** | Just save the file — Workshop rebuilds automatically |
| **Build manually** | `Ctrl+Alt+B` |
| **View PDF side-by-side** | `Ctrl+Alt+V` — opens the compiled PDF in a VSCode tab beside the editor |

The first build of a new document may take a minute while MiKTeX downloads required packages from CTAN. Subsequent builds are instant (packages are cached in `~/.miktex/texmfs/install/`).

### SyncTeX (jump between source and PDF)

| Action | How |
| --- | --- |
| Source → PDF | `Ctrl+Alt+J` (forward search) |
| PDF → Source | `Ctrl+click` in the PDF viewer |

### Clean auxiliary files

LaTeX Workshop cleans `.aux`, `.log`, etc. automatically when a build fails (`autoClean.run = onFailed`). To clean manually:

```
Ctrl+Shift+P → "LaTeX Workshop: Clean up auxiliary files"
```

---

## Project structure recommendation

```
my-paper/
├── main.tex          ← root document
├── sections/
│   ├── intro.tex
│   └── methods.tex
├── figures/
│   └── diagram.pdf
├── references.bib
└── .gitignore
```

**`.gitignore` for LaTeX** — add this so auxiliary files are not committed:

```gitignore
# LaTeX auxiliary files
*.aux
*.log
*.out
*.toc
*.lof
*.lot
*.fls
*.fdb_latexmk
*.synctex.gz
*.bbl
*.blg
_minted-*/
```

---

## Collaboration via GitHub

```bash
# Create the repo (on GitHub website or gh CLI)
cd ~/Documents/my-paper
git init
git add main.tex sections/ figures/ references.bib .gitignore
git commit -m "init: LaTeX project"
git remote add origin git@github.com:username/my-paper.git
git push -u origin main
```

Collaborators need only their own LaTeX setup. MiKTeX auto-downloads whatever packages your `\usepackage{}` lines require, so they never need to manually install anything.

---

## Switching the compiler

LaTeX Workshop's default recipe uses `latexmk` → `pdflatex`. To switch to XeLaTeX or LuaLaTeX for Unicode / custom font support:

```
Ctrl+Shift+P → "LaTeX Workshop: Build with recipe" → choose recipe
```

Or set a `% !TEX program = xelatex` magic comment at the top of your `.tex` file.

---

## Troubleshooting

| Problem | Fix |
| --- | --- |
| `pdflatex: command not found` in VSCode | Run `miktexsetup finish` in terminal, restart VSCode |
| MiKTeX prompts to install packages interactively | Re-run `initexmf --set-config-value "[MPM]AutoInstall=1"` |
| PDF viewer doesn't open | `Ctrl+Alt+V` or `Ctrl+Shift+P → "LaTeX Workshop: View LaTeX PDF"` |
| Want more/different extensions | Install from the VSCode marketplace — `mutableExtensionsDir = true` is set in the Nix config |
