# Python with uv

`uv` is installed system-wide. A **general** virtual environment lives at `~/.venv/general`
and is activated automatically in every new shell.

---

## General environment (default)

The general env is auto-activated in your shell. Its purpose is to keep a tidy set
of everyday Python tools without polluting the system Python.

```bash
# First-time setup (only needed once after a fresh install)
uv venv ~/.venv/general

# Check active env
python -c "import sys; print(sys.prefix)"
```

### Add / remove packages in the general env

```bash
# Make sure you're in the general env (it activates automatically)
uv pip install httpx rich         # install
uv pip uninstall httpx            # remove
uv pip list                       # show installed
uv pip freeze                     # requirements.txt-style output
```

---

## Project environments

Each project gets its own isolated env. Work inside the project folder:

```bash
cd ~/projects/myproject

uv venv                   # creates .venv/ inside the project
source .venv/bin/activate # activate it (overrides the general env)

uv pip install fastapi uvicorn
uv pip freeze > requirements.txt
```

To deactivate and return to the general env:
```bash
deactivate
```

---

## Sync from a requirements file

```bash
uv pip sync requirements.txt          # install exactly what's listed
uv pip install -r requirements.txt    # install (additive)
```

---

## Temporary / inline dependency runs

Run a one-off script with dependencies, without touching any env:

```bash
# Run a script with inline deps (PEP 723 style)
uv run --with httpx --with rich my_script.py

# Or use inline metadata inside the script:
# /// script
# requires-python = ">=3.11"
# dependencies = ["httpx", "rich"]
# ///
uv run my_script.py
```

---

## Global tool installs (CLI apps)

Install Python CLI tools globally, isolated from any venv:

```bash
uv tool install ruff          # linter / formatter
uv tool install black
uv tool install mypy
uv tool list                  # show installed tools
uv tool uninstall ruff
```

These tools are available in your PATH regardless of the active env.

---

## Python version management

```bash
uv python list                # show available Python versions
uv python install 3.12        # download and install a version
uv venv --python 3.12 .venv   # create env with a specific version
```

---

## Common day-to-day workflow

```bash
# Start a new project
mkdir ~/projects/foo && cd ~/projects/foo
uv venv
source .venv/bin/activate
uv pip install <deps>
uv pip freeze > requirements.txt

# Return to general env
deactivate

# Quick script with temp deps
uv run --with requests script.py
```
