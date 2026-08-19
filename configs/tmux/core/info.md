---
title: Core
description: Numbered, order matters. One concern per file; keys live wherever their feature does.
date created: 2026-08-18
date modified: 2026-08-18
---

# Core
@index.md

Included by `../tmux.conf.j2`'s glob loop in filename order, same idea as `configs/zsh/core/`. Keybinds aren't centralized in one file; each file owns the keys for its own concern. One job per file: `00-options` (session/terminal settings, `@popup` snippets, prefix), `10-status` (status-bar visuals + the click handler for them), `20-theme` (colors/styles, no keys), `30-copy-mode` (`copy-command` is OS-picked + copy-mode-vi keys), `40-layout` (pane splits/nav/resize, window create/kill/switch), `50-sessions` (persistent-session launchers + the fzf picker), `60-tools` (external tool launchers: fzf menu, pane history, lazygit).
