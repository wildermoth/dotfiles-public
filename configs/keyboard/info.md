---
title: Keyboard
description: Kanata (mac). AHK (Windows) under ahk/. leftover karabiner.json still installed if present.
date created: 2026-08-16
date modified: 2026-08-17
---

# Keyboard
@index.md

OS keyboard stays U.S. QWERTY. Remaps do Colemak-DH ANSI Wide.

Kanata (mac): `kanata/main.kbd`. Services under `kanata/os/macos/`.

AHK (Windows): `ahk/main.ahk` + `ahk/split/`. Caps hold = F24, Tab hold = F23. Windows dest names stay `extend_layer_wide_std.ahk` + `extend_layer_wide_std_split/`. Sync via `scripts/sync-windows.sh` / `install/40-alacritty.sh`.

Karabiner rule sources are gone. Leftover `karabiner.json` is still symlinked on mac if the file exists (`install/50-karabiner.sh`).
