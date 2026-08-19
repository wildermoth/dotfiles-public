---
title: Launchd
description: Three LaunchDaemons. Absolute paths. Binary, not a wrapper.
date created: 2026-08-16
date modified: 2026-08-17
---

# Launchd
@index.md

Plists installed to `/Library/LaunchDaemons/`. Absolute paths. Run the binary, not a shell wrapper.

Kanata plist: `__KANATA_BIN__` and `__DOTFILES_DIR__` (sed'd by `../install.sh`). `--cfg` is `main.resolved.kbd`. vhidmanager plist has no log keys.

After plist edits: rerun `../install.sh`.
