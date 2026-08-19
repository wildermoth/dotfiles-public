---
title: Macos
description: Kanata launchd install. start.sh is a foreground tester. Logs in /Library/Logs/Kanata.
date created: 2026-08-16
date modified: 2026-08-17
---

# Macos
@index.md

`install.sh` (root, `exit` ok): finds a cmd-enabled Kanata binary, writes LaunchDaemons, activates Karabiner VirtualHID, bootstraps manager -> vhid -> kanata. Called from `install/50-karabiner.sh` via `sudo`.

Labels: `com.james.keyboard.kanata`, `.karabiner-vhid`, `.karabiner-vhidmanager`. Keep them stable. Logs: `/Library/Logs/Kanata`.

Plist `--cfg` is `__DOTFILES_DIR__/configs/keyboard/kanata/main.resolved.kbd`. `install.sh` sed-fills `__KANATA_BIN__` and `__DOTFILES_DIR__`, and writes `main.resolved.kbd` from `main.kbd`.

`start.sh` is a foreground tester. Resolves `main.kbd` to `main.resolved.kbd` (same as `install.sh`) and execs Kanata. No sudo.

`switch_window.sh` is the FlashSpace helper. Caps+1..5 call it via the resolved absolute path.
