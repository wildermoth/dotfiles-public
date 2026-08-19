---
title: Tests
description: Real-tool checks via tests/run.sh. check hard-fails. Never touch real $HOME.
date created: 2026-08-16
date modified: 2026-08-19
---

# Tests
@index.md

`./tests/run.sh` locates the repo via `DOTFILES_DIR` (default `~/dotfiles`). Runs every `tests/*.sh` except `lib.sh` / `run.sh` as subprocesses. No `-e`; failures go through `check`. Each suite ends with `finish`.

`check "label" cmd...` hard-fail (crash, bad parse, leftover `<<`/`<%`, broken symlink, Lua traceback). `info "label" cmd...` print only, never fails the suite. Use `info` for env gaps (today: nvim `:checkhealth`). Don't use it to hide a real fail.

Never mutate real `$HOME`, the real tmux server, or the Windows profile. `tests/install-dryrun.sh` remaps `HOME` and runs steps 20 / 40 / 60 / 70 (skips 00 / 10 / 50-karabiner / 80 so Darwin never `sudo`s LaunchDaemons). Then asserts each expected symlink destination, `~/.gitconfig.local` copied from the example, and no broken links. Tmux tests use `-S` socket.

`tests/configs.sh` leftover `<<`/`<%` on every `generate_configs.sh` output (including `p10k.zsh`). `tests/keyboard.sh`: `main.ahk` exists, every `#Include` basename is in `ahk/split/`, kanata sources have no `/Users/` and keep `__DOTFILES_DIR__`.

`tests/nvim.sh` remaps `HOME` and `XDG_*`. Unsets `TMUX` so `:checkhealth` does not query the live server. Sandbox `XDG_CONFIG_HOME` with `nvim` -> `configs/nvim` (do not point `XDG_CONFIG_HOME` at `configs/`: plugins mkdir sibling dirs). Plugin data is a symlink to the real nvim data dir if present. Startup Lua errors fail. `:checkhealth` is `info` (plugin env noise: mmdc, kitty, snacks): counts plus ERROR/WARNING lines, not the full report.

`install/00-deps.sh` is never executed. Lint only: `bash -n`.
