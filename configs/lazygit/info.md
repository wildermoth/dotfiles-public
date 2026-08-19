---
title: Lazygit
description: "config.yml.j2. Go-templates stay {{ }} because Jinja uses << >>."
date created: 2026-08-16
date modified: 2026-08-17
---

# Lazygit
@index.md

`config.yml.j2` -> `config.yml` via `scripts/generate_configs.sh`. Colors from `configs/theme/palette.json`.

Lazygit's own Go-templates stay `{{ }}`. Config Jinja uses `<< >>` so those pass through (`scripts/jinja_customize.py`).

Mac install path: `~/Library/Application Support/lazygit/config.yml`. Else `~/.config/lazygit/config.yml`.
