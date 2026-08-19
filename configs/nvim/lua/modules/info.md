---
title: Modules
description: Self-contained feature modules, one caller each, plugin-paired or standalone.
date created: 2026-08-18
date modified: 2026-08-18
---

# Modules
@index.md

Self-contained feature modules (`local M = {}` ... `return M`), each required by exactly one caller.

Plugin-paired: (logic for one `lua/plugins/<name>.lua` spec, kept out of its `config()` callback):
- `git_hidden_files.lua`: oil.lua
- `grep_motion.lua`: grep.lua
- `incremental_selection.lua`: treesitter.lua
- `line_history.lua`: git-history.lua.

Standalone (no plugin, required from `init.lua` or `core/keymaps.lua`): 
- `python_fstring.lua`,
- `xml_tags.lua`
- `runner.lua`.

Established pattern: any non-trivial plugin logic lives here as `modules/<name>.lua`, required into
its spec with `require("modules.<name>")`.
