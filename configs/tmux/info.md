---
title: Tmux
description: tmux.conf.j2. Prefix Ctrl-t. Session helpers go to ~/bin.
date created: 2026-08-16
date modified: 2026-08-18
---

# Tmux
@index.md

`tmux.conf.j2` -> `tmux.conf` (colors from `configs/theme/palette.json`). Prefix is Ctrl-t.

`tmux.conf.j2` loops over `core/*.conf.j2` sorted by filename (`glob_sorted` in `scripts/jinja_customize.py`), so a new numbered file is picked up with no template edit. Same idea as `configs/zsh/core/`: numbered, order matters. No `modules/` equivalent, tmux has no optional parts. Parts are stitched at generate time, so `tmux.conf` stays one file and needs no `source-file`. Include paths are repo-relative because `generate_configs.sh` cds to `DOTFILES_DIR` (jinjanate resolves includes and globs against cwd).

Keybinds aren't centralized; each file owns the keys for its own concern (see `core/info.md`). One job per file: `00-options` (session/terminal settings, `@popup` snippets, prefix), `10-status` (status-bar visuals + the click handler for them), `20-theme` (colors/styles, no keys), `30-copy-mode` (`copy-command` is OS-picked + copy-mode-vi keys), `40-layout` (pane splits/nav/resize, window create/kill/switch), `50-sessions` (persistent-session launchers + the fzf picker), `60-tools` (external tool launchers: fzf menu, pane history, lazygit).

Status line is clickable via `#[range=user|X]` + one `MouseDown1Status` binding, both in `10-status`: session name opens the `fzf-tools` session picker (same as `M-)`), `+` adds a window after the current one, `-` kills the window. Anything else falls back to `select-window -t=`.

Window list is `#I:#{window_name}` when `#{client_width}` >= `@status_narrow` (80), else `#I` only. Status draws per client, so a phone attach can show numbers while a desktop attach still shows names. Compare with `#{e|<}` (numeric); `#{<:}` is string compare and treats 100 as less than 80.

No functions in tmux, so repeated commands live in user options: `@popup` (popup geometry) and `@popup_sessions`. Options expand inside any shell-command; `#{E:...}` is needed when the value itself contains `#{...}`.

Two session helpers, both linked into `~/bin` by `install/60-bin-symlinks.sh`: `tmux-session-persistent` and `tmux-pane-history`. Ad-hoc session switching is `$FZF_TOOLS_DIR/bin/tmux_sessions` (`M-)` or the status click).

`tmux-session-persistent` maps a known name to a dir (env var, else the default), then creates/switches:
- `dotfiles` -> `$DOTFILES_DIR` or `$HOME/dotfiles`
- `dotfiles-ai` -> `$DOTFILES_AI_DIR` or `$HOME/dotfiles-ai`
- `obsidian` -> `$OBSIDIAN_PATH` or `$HOME/obsidian`

Unknown names and missing dirs fail.

`tmux-pane-history` captures a pane's scrollback to `/tmp/tmux-history-<pane-id>` and opens it in a scratch nvim buffer in a new window (`M-S-DC`), removing the temp file on clean exit.
