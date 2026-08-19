---
title: Shared
description: Cross-cutting utilities reused by more than one plugin spec.
date created: 2026-08-18
date modified: 2026-08-18
---

# Shared
@index.md

Cross-cutting utilities reused by multiple plugin specs, not paired to just one. Currently `colors.lua`: reads `configs/theme/palette.json`, must `resolve` the path first since `~/.config/nvim` is a symlink. Pulled in by `colorscheme.lua`, `gitsigns.lua`, and `snacks.lua` via `require("shared.colors")`.
