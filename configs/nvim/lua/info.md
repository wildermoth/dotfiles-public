---
title: Lua
description: core/ + shared/ + modules/ split editor setup by role. plugins/ is one lazy spec per file.
date created: 2026-08-16
date modified: 2026-08-17
---

# Lua
@index.md

`core/` = bootstrap: options, keymaps, lazy. `shared/` = cross-cutting utilities reused by more than
one plugin spec (palette colors). `modules/` = self-contained feature modules, one caller each,
whether plugin-paired or standalone. `plugins/` = one `lazy.nvim` spec per file, imported by
`core.lazy`. Not a package `init.lua` requires as a whole.
