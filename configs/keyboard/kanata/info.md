---
title: Kanata
description: Shared main.kbd. defsrc is 60 keys. OS stays U.S. QWERTY.
date created: 2026-08-16
date modified: 2026-08-17
---

# Kanata
@index.md

`main.kbd` is the shared layout (mac-first). Startup/install lives under `os/<platform>/`, not beside this file.

OS input stays U.S. QWERTY. Kanata does Colemak-DH ANSI Wide on layer `base`. Other layers: `tabnav`, `capsnav`.

`defsrc` is 60 keys (14 / 14 / 13 / 12 / 7). Every `deflayer` must match that count.

Physical mods: Ctrl -> Command, Win -> Control, Alt stays Option. Arrow key is `rght`, not `right`.

`os/macos/switch_window.sh` paths in `main.kbd` use `__DOTFILES_DIR__`. `os/macos/install.sh` writes `main.resolved.kbd` (gitignored) and points launchd at that.
