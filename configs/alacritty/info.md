---
title: Alacritty
description: alacritty.toml.j2 renders this machine and native Windows.
date created: 2026-08-16
date modified: 2026-08-17
---

# Alacritty
@index.md

`alacritty.toml.j2` -> `alacritty.toml` (this machine, `OS=mac`/`wsl`) and `os-windows.toml` (`OS=windows`). `install/40-alacritty.sh` links the first to `~/.config/alacritty/alacritty.toml`. WSL copies the second as the native Windows config.

Shared: window, cursor, scroll, font family, Ctrl+N. Mac: `option_as_alt` + word/line binds. Windows: `wsl.exe` shell, font 12, box-drawing, a few extra binds. Don't edit generated files.
