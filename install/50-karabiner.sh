#!/usr/bin/env bash
# macOS only: symlink leftover karabiner.json if present, then install
# Kanata macOS services.
# Sourced by install.sh; not run standalone.

if ! is_macos; then
	log_skip 'macOS only'
	return 0
fi

karabiner_json="$DOTFILES_DIR/configs/keyboard/karabiner.json"
if [[ -f $karabiner_json ]]; then
	mkdir -p "$CONFIG_DIR/karabiner" || exit
	backup_and_symlink \
		"$CONFIG_DIR/karabiner/karabiner.json" \
		"$karabiner_json"
else
	log_skip 'karabiner.json missing'
fi

kanata_macos_install="$DOTFILES_DIR/configs/keyboard/kanata/os/macos/install.sh"
if [[ -x $kanata_macos_install ]]; then
	log_run 'Kanata macOS services'
	sudo "$kanata_macos_install" || exit
else
	log_skip 'Kanata macos install.sh not executable'
fi
