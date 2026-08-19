---
title: Core
description: Numbered zsh startup. Order matters. 05-os.zsh is generated.
date created: 2026-08-17
date modified: 2026-08-18
---

# Core
@index.md

Load-order-sensitive files, sourced by `../zshrc` in filename order. No `04-`.

1. `01-zstyles.zsh` before `z4h init`
2. `02-z4h-init.zsh` (`z4h init || return`)
3. `03-env.zsh` PATH, shared dirs (`DOTFILES_DIR`, `DOTFILES_AI_DIR`, `OBSIDIAN_PATH`, `FZF_TOOLS_DIR`), then `z4h source ~/.env.zsh`
4. `05-os.zsh` (from `05-os.zsh.j2`) before fnm so fnm beats brew node on WSL
5. `06-fnm.zsh`
6. `07-modules.zsh` globs `../modules/*.zsh` (no `|| return`)
7. `08-p10k-finalize.zsh` last, after all earlier stdout (including modules)

`05-os.zsh` is the only templated file here. Don't hand-edit it.
