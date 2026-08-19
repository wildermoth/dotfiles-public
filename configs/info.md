---
title: Configs
description: App configs, templated then symlinked.
date created: 2026-08-16
date modified: 2026-08-17
---

# Configs
@index.md

App configs, symlinked by `install/20-symlinks.sh`.

Edit `.j2`, then `./scripts/generate_configs.sh`. Template list is hardcoded in that script.

Delimiters `<< >>` / `<% %>` / `<# #>` (not `{{ }}`). `OS` = `mac` | `wsl`. OS branches inline at file end. Exception: `zsh/core/05-os.zsh.j2` (must load before fnm).

Colors from `theme/palette.json`. Role values are pigment names, never `#hex`.

Don't hand-edit generated outputs. `alacritty.toml.j2` also renders `os-windows.toml` with `OS=windows` (not an install OS). Secrets stay out of templates (`~/.env.zsh`).
