---
title: Dotfiles
description: Multi-OS dotfiles. info.md is the agent knowledge file.
date created: 2026-08-16
date modified: 2026-08-18
---

# Dotfiles
@README.md
@index.md

Checkout expects `~/dotfiles`. `DOTFILES_DIR` is exported by zshrc (default `~/dotfiles`) and
overrides install/scripts. Other shared dirs live in `configs/zsh/core/03-env.zsh`:
`DOTFILES_AI_DIR`, `OBSIDIAN_PATH`, `FZF_TOOLS_DIR`. Install uses `CONFIG_DIR` (`$XDG_CONFIG_HOME`
or `~/.config`).

Docs: edit `info.md` only. `AGENTS.md`/`CLAUDE.md` stay `@info.md` + `@index.md`. `index.md` regen
by `okf index` (`install/80-okf-index.sh`). Don't put notes in AGENTS, CLAUDE, or index.

Palette: `configs/theme/palette.json`. Nvim reads it live (`configs/nvim/lua/shared/colors.lua`).

Config Jinja (`configs/*.j2`): `<< >>` / `<% %>` / `<# #>` via `scripts/jinja_customize.py`. New
`.j2` does nothing until listed in `scripts/generate_configs.sh`.

Don't edit generated (gitignored): `configs/lazygit/config.yml`, `configs/tmux/tmux.conf`,
`configs/zsh/core/05-os.zsh`, `configs/zsh/p10k.zsh`, `configs/alacritty/alacritty.toml`,
`configs/alacritty/os-windows.toml`, `configs/keyboard/karabiner.json`. Tracked source is the `.j2`.

```
./install.sh
./scripts/generate_configs.sh
./scripts/sync-windows.sh
./tests/run.sh
```

After a `.j2` edit: generate first, then `./tests/run.sh`.

`configs/` = app configs (nvim, keyboard, zsh, …). Windows is not an install OS; WSL copies
Alacritty + AHK over.
