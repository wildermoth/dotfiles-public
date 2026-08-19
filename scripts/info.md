---
title: Scripts
description: Hand-run + install helpers. Template render, docs fold, Windows sync.
date created: 2026-08-16
date modified: 2026-08-19
---

# Scripts
@index.md

Hand-run + called from install. Install-time logic stays in `install/`.

- `generate_configs.sh`: jinjanate + `palette.json` + `OS`. Called from `install/10-configs.sh`. Template list is hardcoded. Cds to `DOTFILES_DIR` first so `<% include %>` can use repo-relative paths (jinjanate's loader resolves them against cwd).
- `jinja_customize.py`: `<< >>` / `<% %>` / `<# #>`, resolve roles to hex, inject `OS`.
- `sync-windows.sh`: WSL -> Windows Alacritty + AHK (`install/lib-windows-sync.sh`).
- `win-clip-img`: Windows clipboard image -> xclip. Not in `~/bin`; run by path.
- `windows-chrome`: WSL -> Windows Chrome. `05-os.zsh.j2` sets `BROWSER` if the script is executable.
- `push-public.sh`: parentless HEAD snapshot, force-push public repo. `--dry-run`.
- `nvim-startup-bench.sh`: bench helper. Writes under `tmp/nvim-bench` (gitignored). Sandbox `XDG_CONFIG_HOME` with `nvim` -> `configs/nvim`.

`~/bin` gets `tmux-session-persistent` and `tmux-pane-history` (`install/60-bin-symlinks.sh`). Rest of this dir is on PATH via `configs/zsh/core/03-env.zsh`.
