---
title: Zsh
description: zshrc is a shim over core/*.zsh. p10k.zsh is generated. Secrets in ~/.env.zsh.
date created: 2026-08-16
date modified: 2026-08-19
---

# Zsh
@index.md

`zshrc` is a thin shim: sets and exports `DOTFILES_DIR`, sources `core/*.zsh` in filename order (`|| return` aborts the rest). Modules load from `core/07-modules.zsh`, not from zshrc.

`zshenv` is z4h bootstrap. Don't dump random exports there.

`p10k.zsh.j2` is stock wizard output. Live left prompt is `dir` + `vcs`; colors come from `configs/theme/palette.json`. Don't hand-edit the generated `p10k.zsh`. Linked as `~/.p10k.zsh`.

`env.zsh.example` documents untracked `~/.env.zsh` (sourced by `core/03-env.zsh`). Copy keys out; don't commit secrets. Path vars (`OBSIDIAN_PATH`, `FZF_TOOLS_DIR`, `DOTFILES_AI_DIR`) can be overridden there. `TSSH_HOST` / `TSSH_USER` are Mac-only (`modules/tssh.zsh`). `DOTFILES_DIR` must be set before zshrc (environment or zshenv) or the core files won't load.
