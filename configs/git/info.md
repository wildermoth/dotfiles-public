---
title: Git
description: Shared gitconfig. Linked to ~/.gitconfig.
date created: 2026-08-16
date modified: 2026-08-19
---

# Git
@index.md

`install/20-symlinks.sh` links `gitconfig` to `~/.gitconfig`. Settings are shared. `gh` helper is `!gh auth git-credential` (PATH). No windows gitconfig.

Identity, `signingkey`, `commit.gpgsign`, `http.cookiefile`, and `filter.lfs.required` live in untracked `~/.gitconfig.local` (`[include]` at the end of `gitconfig`). Missing include is ignored. `20-symlinks` copies `gitconfig.local.example` there if the file is absent.

Do not `git config --global user.email` (writes through the `~/.gitconfig` symlink into this repo). Edit `~/.gitconfig.local` or `git config -f ~/.gitconfig.local`.

`gitignore_global` linked separately.
