---
title: Theme
description: palette.json is the color source for templates and nvim.
date created: 2026-08-17
date modified: 2026-08-17
---

# Theme
@index.md

`palette.json` is the color source. `palette` = pigment name -> `#rrggbb`. Role groups (`ui`, `git`, `diff`, `prompt`) = role -> pigment name, never raw hex.

`scripts/generate_configs.sh` feeds this file to jinjanate; `scripts/jinja_customize.py` resolves names to hex. Nvim reads the same file in `nvim/lua/shared/colors.lua` (no generate; path is `configs/nvim/...`).

Edit pigments or roles here. Not in `.j2` files, not in plugin specs.
