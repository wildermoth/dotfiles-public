---
title: Nvim
description: ~/.config/nvim symlink. Plugins are lua/plugins/*.lua. Colors from palette.json.
date created: 2026-08-16
date modified: 2026-08-17
---

# Nvim
@index.md

`~/.config/nvim` -> this dir (`install/20-symlinks.sh`). Entry: `init.lua` (options, keymaps,
xml_tags, python_fstring, then lazy).

New plugin = new file in `lua/plugins/`. Don't grow `init.lua`. Standalone editor features go in
`lua/modules/`; plugin-paired feature logic goes there too, required into its
`lua/plugins/<name>.lua` spec.

Colors: `lua/shared/colors.lua` reads `configs/theme/palette.json` (resolves the symlink so
`:h:h:h:h:h` is repo root).

Providers stay off in `options.lua` (`perl`/`ruby`/`node`/`python3`). `vim.g.editorconfig = false`.

Ignore `configs/nvim/nvim/` (nested junk, gitignored). There is no `pack/` and no `skills/`.

`lua/plugins/obsidian.lua` loads `wildermoth/personal-obsidian.nvim`. That plugin assumes this vault layout. Keep it; this repo is personal.
