#!/usr/bin/env bash
# Regenerates index.md across the dotfiles tree via okf index.
# Sourced by install.sh; not run standalone.

if ! command -v okf &>/dev/null; then
	log_skip 'okf not installed'
	return 0
fi

log_run 'okf index'
okf index "$DOTFILES_DIR" || exit
