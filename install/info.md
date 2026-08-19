---
title: Install
description: Numbered steps sourced by install.sh. return, never exit.
date created: 2026-08-16
date modified: 2026-08-19
---

# Install
@index.md

`install.sh` sets `DOTFILES_DIR` (default `~/dotfiles`) / `CONFIG_DIR` (`$XDG_CONFIG_HOME` or `~/.config`) / `OBSIDIAN_PATH`, sources `lib.sh` + `lib-windows-sync.sh`, then sources `install/[0-9]*.sh` in sort order. Header comes from the filename (`60-bin-symlinks.sh` -> `bin symlinks`). No `set -e`; fallible commands use `|| exit`.

Steps are sourced. `return` to skip. `exit` kills the whole install.

`lib*.sh` stay unnumbered or the loop runs them as steps. New `NN-foo.sh` is auto-picked. Number in tens.

- `00-deps`: network / sudo packages. Tests never run this for real.
- `10-configs`: `generate_configs.sh`
- `20-symlinks`: `backup_and_symlink` for nvim/zsh/tmux/git/lazygit/atuin
- `40-alacritty`: link generated `alacritty.toml`; WSL copies Windows render + AHK
- `50-karabiner`: mac only. Symlink leftover `karabiner.json` if present, then `sudo` Kanata install
- `60-bin-symlinks`: `~/bin` gets `tmux-session-persistent` and `tmux-pane-history`
- `70-obsidian`: vault default if `obsidian-cli` exists
- `80-okf-index`: `okf index` (regens `index.md`)

Use `is_*`, `$DOTFILES_DIR`, `log_*`, `backup_and_symlink`. No `log_section` inside a step.
