---
title: Ahk
description: Windows extend-layer host + split fragments. Dest names stay extend_layer_wide_std*.
date created: 2026-08-17
date modified: 2026-08-17
---

# Ahk
@index.md

`main.ahk` is the host (dual-role Caps/Tab). `split/` is the fragments, `#Include`d raw.

`#Include` paths use `extend_layer_wide_std_split/`, not `split/`. Don't "fix" them.

AHK does its own window switch. FlashSpace helper is `kanata/os/macos/switch_window.sh`.

Copy helper: `sync_windows_ahk` in `install/lib-windows-sync.sh`.
